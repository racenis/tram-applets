unit TramPathAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TPathCollection = class;
  TPath = class(TAssetMetadata)
  public
      constructor Create(pathName: string; collection: TPathCollection);
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

  end;

  TPathCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     paths: array of TPath;
  end;

implementation

constructor TPath.Create(pathName: string; collection: TPathCollection);
begin
  self.name := pathName;
  self.parent := collection;
end;

function TPath.GetType: string;
begin
  Result := 'PATH';
end;

function TPath.GetPath: string;
begin
  Result := 'data/paths/' + name + '.path';
end;

procedure TPath.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TPath.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TPath.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TPath.SetMetadata(const prop: string; value: Variant);
begin

end;
function TPath.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TPath.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TPath.LoadMetadata();
begin

end;


constructor TPathCollection.Create;
begin

end;

procedure TPathCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(paths) do
      if paths[index] = asset then
         Break;
  if paths[index] <> asset then Exit;
  for index := index to High(paths) - 1 do
      paths[index] := paths[index  + 1];
  SetLength(paths, Length(paths) - 1);
end;

procedure TPathCollection.Clear;
var
  path: TPath;
begin
  for path in self.paths do path.Free;
  SetLength(paths, 0);
end;

procedure TPathCollection.ScanFromDisk;
var
  files: TStringList;
  pathFile: string;
  pathName: string;
  path: TPath;
  pathCandidate: TPath;
begin
  files := FindAllFiles('data/paths', '*.path', true);

  for path in paths do
      path.SetDateOnDisk(0);

  for pathFile in files do
  begin
    path := nil;

    // extract asset name from path
    pathName := pathFile.Replace('\', '/');
    pathName := pathName.Replace('data/paths/', '');

    pathName := pathName.Replace('.path', '');

    // check if path already exists in database
    for pathCandidate in paths do
      if pathCandidate.GetName() = pathName then
      begin
        path := pathCandidate;
        Break;
      end;

    // if exists, update date on disk
    if path <> nil then
    begin
      path.SetDateOnDisk(FileAge(pathFile));
      Continue;
    end;

    // otherwise add it to database
    path := TPath.Create( pathName, self);
    path.SetDateOnDisk(FileAge(pathFile));

    SetLength(self.paths, Length(self.paths) + 1);
    self.paths[High(self.paths)] := path;
  end;
end;

function TPathCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  path: TPath;
  pathCandidate: TPath;
begin
  path := nil;

  for pathCandidate in paths do
      if pathCandidate.GetName() = name then
      begin
        path := pathCandidate;
        Break;
      end;

  if path <> nil then
  begin
    path.SetDateInDB(date);
    Exit(path);
  end;

  path := TPath.Create(name, self);
  path.SetDateInDB(date);

  SetLength(self.paths, Length(self.paths) + 1);
  self.paths[High(self.paths)] := path;

  Result := path;
end;

function TPathCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.paths));

  for i := 0 to High(self.paths) do
      Result[i] := self.paths[i];
end;

end.

