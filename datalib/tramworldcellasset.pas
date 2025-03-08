unit TramWorldCellAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TWorldCellCollection = class;
  TWorldCell = class(TAssetMetadata)
  public
      constructor Create(worldCellName: string; collection: TWorldCellCollection);
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

  TWorldCellCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     worldCells: array of TWorldCell;
  end;

implementation

constructor TWorldCell.Create(worldCellName: string; collection: TWorldCellCollection);
begin
  self.name := worldCellName;
  self.parent := collection;
end;

function TWorldCell.GetType: string;
begin
  Result := 'WORLDCELL';
end;

function TWorldCell.GetPath: string;
begin
  Result := 'data/worldcells/' + name + '.cell';
end;

procedure TWorldCell.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TWorldCell.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TWorldCell.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TWorldCell.SetMetadata(const prop: string; value: Variant);
begin

end;
function TWorldCell.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TWorldCell.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TWorldCell.LoadMetadata();
begin

end;


constructor TWorldCellCollection.Create;
begin

end;

procedure TWorldCellCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(worldCells) do
      if worldCells[index] = asset then
         Break;
  if worldCells[index] <> asset then Exit;
  for index := index to High(worldCells) - 1 do
      worldCells[index] := worldCells[index  + 1];
  SetLength(worldCells, Length(worldCells) - 1);
end;

procedure TWorldCellCollection.Clear;
var
  worldCell: TWorldCell;
begin
  for worldCell in self.worldCells do worldCell.Free;
  SetLength(worldCells, 0);
end;

procedure TWorldCellCollection.ScanFromDisk;
var
  files: TStringList;
  worldCellFile: string;
  worldCellName: string;
  worldCell: TWorldCell;
  worldCellCandidate: TWorldCell;
begin
  files := FindAllFiles('data/worldcells', '*.cell', true);

  for worldCell in worldCells do
      worldCell.SetDateOnDisk(0);

  for worldCellFile in files do
  begin
    worldCell := nil;

    // extract asset name from path
    worldCellName := worldCellFile.Replace('\', '/');
    worldCellName := worldCellName.Replace('data/worldcells/', '');

    worldCellName := worldCellName.Replace('.cell', '');

    // check if worldcell already exists in database
    for worldCellCandidate in worldCells do
      if worldCellCandidate.GetName() = worldCellName then
      begin
        worldCell := worldCellCandidate;
        Break;
      end;

    // if exists, update date on disk
    if worldCell <> nil then
    begin
      worldCell.SetDateOnDisk(FileAge(worldCellFile));
      Continue;
    end;

    // otherwise add it to database
    worldCell := TWorldCell.Create( worldCellName, self);
    worldCell.SetDateOnDisk(FileAge(worldCellFile));

    SetLength(self.worldCells, Length(self.worldCells) + 1);
    self.worldCells[High(self.worldCells)] := worldCell;
  end;
end;

function TWorldCellCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  worldCell: TWorldCell;
  worldCellCandidate: TWorldCell;
begin
  worldCell := nil;

  for worldCellCandidate in worldCells do
      if worldCellCandidate.GetName() = name then
      begin
        worldCell := worldCellCandidate;
        Break;
      end;

  if worldCell <> nil then
  begin
    worldCell.SetDateInDB(date);
    Exit(worldCell);
  end;

  worldCell := TWorldCell.Create(name, self);
  worldCell.SetDateInDB(date);

  SetLength(self.worldCells, Length(self.worldCells) + 1);
  self.worldCells[High(self.worldCells)] := worldCell;

  Result := worldCell;
end;

function TWorldCellCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.worldCells));

  for i := 0 to High(self.worldCells) do
      Result[i] := self.worldCells[i];
end;

end.

