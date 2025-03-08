unit TramMaterialAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TMaterialCollection = class;
  TMaterial = class(TAssetMetadata)
  public
      constructor Create(materialName: string; collection: TMaterialCollection);
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
  end;

  TMaterialCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     materials: array of TMaterial;
  end;

implementation

constructor TMaterial.Create(materialName: string; collection: TMaterialCollection);
begin
  self.name := materialName;
  self.parent := collection;
end;

function TMaterial.GetType: string;
begin
  Result := 'MATERIAL'
end;

function TMaterial.GetPath: string;
begin
  Result := 'data/textures/' + name + '.png';
end;

procedure TMaterial.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TMaterial.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TMaterial.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TMaterial.SetMetadata(const prop: string; value: Variant);
begin

end;
function TMaterial.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TMaterial.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TMaterial.LoadMetadata();
begin

end;


constructor TMaterialCollection.Create;
begin

end;

procedure TMaterialCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  // TODO: check if asset in materials even
  for index := 0 to High(materials) do
      if materials[index] = asset then
         Break;
  for index := index to High(materials) - 1 do
      materials[index] := materials[index  + 1];
  SetLength(materials, Length(materials) - 1);
end;

procedure TMaterialCollection.Clear;
var
  material: TMaterial;
begin
  for material in self.materials do material.Free;
  SetLength(materials, 0);
end;

procedure TMaterialCollection.ScanFromDisk;
var
  files: TStringList;
  materialFile: string;
  materialName: string;
  material: TMaterial;
  materialCandidate: TMaterial;
begin
  files := FindAllFiles('data/textures', '*.png', true);

  for material in materials do
      material.SetDateOnDisk(0);

  for materialFile in files do
  begin
    material := nil;

    // extract asset name from path
    materialName := materialFile.Replace('\', '/');
    materialName := materialName.Replace('data/textures/', '');

    materialName := materialName.Replace('.png', '');

    // check if material already exists in database
    for materialCandidate in materials do
      if materialCandidate.GetName() = materialName then
      begin
        material := materialCandidate;
        Break;
      end;

    // if exists, update date on disk
    if material <> nil then
    begin
      material.SetDateOnDisk(FileAge(materialFile));
      Continue;
    end;

    // otherwise add it to database
    material := TMaterial.Create(materialName, self);
    material.SetDateOnDisk(FileAge(materialFile));

    SetLength(self.materials, Length(self.materials) + 1);
    self.materials[High(self.materials)] := material;
  end;
end;

function TMaterialCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  material: TMaterial;
  material_candidate: TMaterial;
begin
  material := nil;

  for material_candidate in materials do
      if material_candidate.GetName() = name then
      begin
        material := material_candidate;
        Break;
      end;

  if material <> nil then
  begin
    material.SetDateInDB(date);
    Exit(material);
  end;

  material := TMaterial.Create(name, self);
  material.SetDateInDB(date);

  SetLength(self.materials, Length(self.materials) + 1);
  self.materials[High(self.materials)] := material;

  Result := material;
end;

function TMaterialCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.materials));

  for i := 0 to High(self.materials) do
      Result[i] := self.materials[i];
end;

end.

