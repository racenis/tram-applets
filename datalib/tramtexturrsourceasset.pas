unit TramTexturrSourceAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// TODO:
// - make texturesource remember and identify specific format
// - add properties to image source
// - allow scaling property (32px, 128px, etc.)

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TTextureSourceCollection = class;
  TTextureSource = class(TAssetMetadata)
  public
      constructor Create(ext: string; textureSourceName: string; collection: TTextureSourceCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected
      fileExtension: string;
  end;

  TTextureSourceCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     textureSources: array of TTextureSource;
  end;

implementation

constructor TTextureSource.Create(ext: string; textureSourceName: string; collection: TTextureSourceCollection);
begin
  self.name := textureSourceName;
  self.parent := collection;

  self.fileExtension := ext;
end;

function TTextureSource.GetType: string;
begin
  Result := 'TEXSRC';
end;

function TTextureSource.GetPath: string;
begin
  Result := 'assets/' + name + fileExtension;
end;

procedure TTextureSource.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TTextureSource.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TTextureSource.SetMetadata(const prop: string; value: Variant);
begin

end;
function TTextureSource.GetMetadata(const prop: string): Variant;
begin
  case prop of
       'EXTENSION': Result := fileExtension;
       'FILE_NAME': Result := 'assets/' + name + fileExtension;

       else Result := nil;
  end;
end;

function TTextureSource.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TTextureSource.LoadMetadata();
begin

end;


constructor TTextureSourceCollection.Create;
begin

end;

procedure TTextureSourceCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(textureSources) do
      if textureSources[index] = asset then
         Break;
  if textureSources[index] <> asset then Exit;
  for index := index to High(textureSources) - 1 do
      textureSources[index] := textureSources[index  + 1];
  SetLength(textureSources, Length(textureSources) - 1);
end;

procedure TTextureSourceCollection.Clear;
var
  textureSource: TTextureSource;
begin
  for textureSource in self.textureSources do textureSource.Free;
  SetLength(textureSources, 0);
end;

procedure TTextureSourceCollection.ScanFromDisk;
var
  files: TStringList;
  textureSourceFile: string;
  sourceName: string;
  fileExtension: string;
  textureSource: TTextureSource;
  textureSourceCandidate: TTextureSource;
begin
  files := FindAllFiles('assets/', '*.bmp;*.jpg;*.jpeg;*.svg;*.gif;*.tga;*.xcf;*.psd', true);

  for textureSource in textureSources do
      textureSource.SetDateOnDisk(0);

  for textureSourceFile in files do
  begin
    textureSource := nil;

    // extract asset name from path
    sourceName := textureSourceFile.Replace('\', '/');
    sourceName := sourceName.Replace('assets/', '');

    fileExtension := ExtractFileExt(sourceName);
    sourceName := ChangeFileExt(sourceName, '');


    // check if texture source already exists in database
    for textureSourceCandidate in textureSources do
      if textureSourceCandidate.GetName() = sourceName then
      begin
        textureSource := textureSourceCandidate;
        Break;
      end;

    // if exists, update date on disk
    if textureSource <> nil then
    begin
      textureSource.SetDateOnDisk(FileAge(textureSourceFile));
      Continue;
    end;

    // otherwise add it to database
    textureSource := TTextureSource.Create(fileExtension, sourceName, self);
    textureSource.SetDateOnDisk(FileAge(textureSourceFile));

    SetLength(self.textureSources, Length(self.textureSources) + 1);
    self.textureSources[High(self.textureSources)] := textureSource;
  end;
end;

function TTextureSourceCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  textureSource: TTextureSource;
  textureSourceCandidate: TTextureSource;
  fileExtension: string;
begin
  textureSource := nil;

  for textureSourceCandidate in textureSources do
      if textureSourceCandidate.GetName() = name then
      begin
        textureSource := textureSourceCandidate;
        Break;
      end;

  if textureSource <> nil then
  begin
    textureSource.SetDateInDB(date);
    Exit(textureSource);
  end;

  if FileExists('assets/' + name + '.bmp') then
     fileExtension := '.bmp'
  else if FileExists('assets/' + name + '.jpg') then
     fileExtension := '.jpg'
  else if FileExists('assets/' + name + '.jpeg') then
     fileExtension := '.jpeg'
  else if FileExists('assets/' + name + '.svg') then
     fileExtension := '.svg'
  else if FileExists('assets/' + name + '.gif') then
     fileExtension := '.gif'
  else if FileExists('assets/' + name + '.tga') then
     fileExtension := '.tga'
  else if FileExists('assets/' + name + '.xcf') then
     fileExtension := '.xcf'
  else if FileExists('assets/' + name + '.psd') then
     fileExtension := '.psd'
  else
     fileExtension := '.idk';

  textureSource := TTextureSource.Create(fileExtension, name, self);
  textureSource.SetDateInDB(date);

  SetLength(self.textureSources, Length(self.textureSources) + 1);
  self.textureSources[High(self.textureSources)] := textureSource;

  Result := textureSource;
end;

function TTextureSourceCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.textureSources));

  for i := 0 to High(self.textureSources) do
      Result[i] := self.textureSources[i];
end;

end.

