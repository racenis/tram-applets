unit TramNavmeshAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// ideas:
// - no ideas, head empty

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TNavmeshCollection = class;
  TNavmesh = class(TAssetMetadata)
  public
      constructor Create(navmeshName: string; collection: TNavmeshCollection);
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

  TNavmeshCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     navmeshes: array of TNavmesh;
  end;

implementation

constructor TNavmesh.Create(navmeshName: string; collection: TNavmeshCollection);
begin
  self.name := navmeshName;
  self.parent := collection;
end;

function TNavmesh.GetType: string;
begin
  Result := 'NAVMESH';
end;

function TNavmesh.GetPath: string;
begin
  Result := 'data/navmeshes/' + name + '.nav';
end;

procedure TNavmesh.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TNavmesh.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TNavmesh.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TNavmesh.SetMetadata(const prop: string; value: Variant);
begin

end;
function TNavmesh.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TNavmesh.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TNavmesh.LoadMetadata();
begin

end;


constructor TNavmeshCollection.Create;
begin

end;

procedure TNavmeshCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(navmeshes) do
      if navmeshes[index] = asset then
         Break;
  if navmeshes[index] <> asset then Exit;
  for index := index to High(navmeshes) - 1 do
      navmeshes[index] := navmeshes[index  + 1];
  SetLength(navmeshes, Length(navmeshes) - 1);
end;

procedure TNavmeshCollection.Clear;
var
  navmesh: TNavmesh;
begin
  for navmesh in self.navmeshes do navmesh.Free;
  SetLength(navmeshes, 0);
end;

procedure TNavmeshCollection.ScanFromDisk;
var
  files: TStringList;
  navmeshFile: string;
  navmeshName: string;
  navmesh: TNavmesh;
  navmeshCandidate: TNavmesh;
begin
  files := FindAllFiles('data/navmeshes', '*.nav', true);

  for navmesh in navmeshes do
      navmesh.SetDateOnDisk(0);

  for navmeshFile in files do
  begin
    navmesh := nil;

    // extract asset name from path
    navmeshName := navmeshFile.Replace('\', '/');
    navmeshName := navmeshName.Replace('data/navmeshes/', '');

    navmeshName := navmeshName.Replace('.nav', '');

    // check if navmesh already exists in database
    for navmeshCandidate in navmeshes do
      if navmeshCandidate.GetName() = navmeshName then
      begin
        navmesh := navmeshCandidate;
        Break;
      end;

    // if exists, update date on disk
    if navmesh <> nil then
    begin
      navmesh.SetDateOnDisk(FileAge(navmeshFile));
      Continue;
    end;

    // otherwise add it to database
    navmesh := TNavmesh.Create( navmeshName, self);
    navmesh.SetDateOnDisk(FileAge(navmeshFile));

    SetLength(self.navmeshes, Length(self.navmeshes) + 1);
    self.navmeshes[High(self.navmeshes)] := navmesh;
  end;
end;

function TNavmeshCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  navmesh: TNavmesh;
  navmeshCandidate: TNavmesh;
begin
  navmesh := nil;

  for navmeshCandidate in navmeshes do
      if navmeshCandidate.GetName() = name then
      begin
        navmesh := navmeshCandidate;
        Break;
      end;

  if navmesh <> nil then
  begin
    navmesh.SetDateInDB(date);
    Exit(navmesh);
  end;

  navmesh := TNavmesh.Create(name, self);
  navmesh.SetDateInDB(date);

  SetLength(self.navmeshes, Length(self.navmeshes) + 1);
  self.navmeshes[High(self.navmeshes)] := navmesh;

  Result := navmesh;
end;

function TNavmeshCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.navmeshes));

  for i := 0 to High(self.navmeshes) do
      Result[i] := self.navmeshes[i];
end;

end.

