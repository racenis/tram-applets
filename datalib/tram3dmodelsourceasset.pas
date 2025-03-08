unit Tram3DModelSourceAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// TODO:
// - add properties for processing
// - such as limiting which mesh from the file should be exported
// - option to override the name
// - option to choose whether the animations should be exported
// - option to choose output model format (stmdl/dymdl)

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  T3DModelSourceCollection = class;
  T3DModelSource = class(TAssetMetadata)
  public
      constructor Create(ext: string; modelSourceName: string; collection: T3DModelSourceCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function IsProcessable: Boolean; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected
      fileExtension: string;
  end;

  T3DModelSourceCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     modelSources: array of T3DModelSource;
  end;

implementation

constructor T3DModelSource.Create(ext: string; modelSourceName: string; collection: T3DModelSourceCollection);
begin
  self.name := modelSourceName;
  self.parent := collection;

  self.fileExtension := ext;
end;

function T3DModelSource.GetType: string;
begin
  Result := 'MDLSRC';
end;

function T3DModelSource.GetPath: string;
begin
  Result := 'assets/' + name + fileExtension;
end;

procedure T3DModelSource.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure T3DModelSource.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function T3DModelSource.IsProcessable: Boolean;
begin
  Result := True;
end;

procedure T3DModelSource.SetMetadata(const prop: string; value: Variant);
begin

end;
function T3DModelSource.GetMetadata(const prop: string): Variant;
begin
  case prop of
       'EXTENSION': Result := fileExtension;
       'FILE_NAME': Result := 'assets/' + name + fileExtension;

       else Result := nil;
  end;

end;

function T3DModelSource.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure T3DModelSource.LoadMetadata();
begin

end;


constructor T3DModelSourceCollection.Create;
begin

end;

procedure T3DModelSourceCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(modelSources) do
      if modelSources[index] = asset then
         Break;
  if modelSources[index] <> asset then Exit;
  for index := index to High(modelSources) - 1 do
      modelSources[index] := modelSources[index  + 1];
  SetLength(modelSources, Length(modelSources) - 1);
end;

procedure T3DModelSourceCollection.Clear;
var
  modelSource: T3DModelSource;
begin
  for modelSource in self.modelSources do modelSource.Free;
  SetLength(modelSources, 0);
end;

procedure T3DModelSourceCollection.ScanFromDisk;
var
  files: TStringList;
  modelSourceFile: string;
  sourceName: string;
  fileExtension: string;
  modelSource: T3DModelSource;
  modelSourceCandidate: T3DModelSource;
begin
  files := FindAllFiles('assets/', '*.map;*.blend;*.gltf;*.obj;*.fbx;*.dae', true);

  for modelSource in modelSources do
      modelSource.SetDateOnDisk(0);

  for modelSourceFile in files do
  begin
    modelSource := nil;

    // extract asset name from path
    sourceName := modelSourceFile.Replace('\', '/');
    sourceName := sourceName.Replace('assets/', '');

    fileExtension := ExtractFileExt(sourceName);
    sourceName := ChangeFileExt(sourceName, '');

    // check if model source already exists in database
    for modelSourceCandidate in modelSources do
      if modelSourceCandidate.GetName() = sourceName then
      begin
        modelSource := modelSourceCandidate;
        Break;
      end;

    // if exists, update date on disk
    if modelSource <> nil then
    begin
      modelSource.SetDateOnDisk(FileAge(modelSourceFile));
      Continue;
    end;

    // otherwise add it to database
    modelSource := T3DModelSource.Create(fileExtension, sourceName, self);
    modelSource.SetDateOnDisk(FileAge(modelSourceFile));

    SetLength(self.modelSources, Length(self.modelSources) + 1);
    self.modelSources[High(self.modelSources)] := modelSource;
  end;
end;

function T3DModelSourceCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  modelSource: T3DModelSource;
  modelSourceCandidate: T3DModelSource;
  fileExtension: string;
begin
  modelSource := nil;

  for modelSourceCandidate in modelSources do
      if modelSourceCandidate.GetName() = name then
      begin
        modelSource := modelSourceCandidate;
        Break;
      end;

  if modelSource <> nil then
  begin
    modelSource.SetDateInDB(date);
    Exit(modelSource);
  end;

  if FileExists('assets/' + name + '.map') then
     fileExtension := '.map'
  else if FileExists('assets/' + name + '.blend') then
     fileExtension := '.blend'
  else if FileExists('assets/' + name + '.gltf') then
     fileExtension := '.gltf'
  else if FileExists('assets/' + name + '.obj') then
     fileExtension := '.obj'
  else if FileExists('assets/' + name + '.fbx') then
     fileExtension := '.fbx'
  else if FileExists('assets/' + name + '.dae') then
     fileExtension := '.dae'
  else
     fileExtension := '.idk';

  modelSource := T3DModelSource.Create(fileExtension, name, self);
  modelSource.SetDateInDB(date);

  SetLength(self.modelSources, Length(self.modelSources) + 1);
  self.modelSources[High(self.modelSources)] := modelSource;

  Result := modelSource;
end;

function T3DModelSourceCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.modelSources));

  for i := 0 to High(self.modelSources) do
      Result[i] := self.modelSources[i];
end;

end.

