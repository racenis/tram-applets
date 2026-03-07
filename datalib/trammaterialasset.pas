unit TramMaterialAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser, fgl,
  TramAssetWriter;

type
  TMaterialCollection = class;

  // MATERIAL
  // Corresponds to a single entry in a .list material file. Gets loaded into a
  // Render::Material class in the C++ API.
  TMaterialData = class
  public
     constructor Create(newMaterialName: string);
  public
     name: string;
     materialType: string;
     filter: string;
     materialProperty: string;
     colorR: Real;
     colorG: Real;
     colorB: Real;
     specular: Real;
     exponent: Real;
     transparency: Real;
     reflectivity: Real;
     source: string;
  end;

  TMaterialDataList = specialize TFPGList<TMaterialData>;

  // MATERIAL FILE
  // This class holds info about a .list material file. It keeps track of all
  // materials inside the file.

  { TMaterial }

  TMaterial = class(TAssetMetadata)
  public
      constructor Create(materialFileName: string; collection: TMaterialCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function IsProcessable: Boolean; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadFromDisk; override;
      procedure SaveToDisk; override;

      procedure LoadMetadata(); override;

      function NewMaterial(materialName: string): TMaterialData;
      procedure RemoveMaterial(material: TMaterialData);

      function GetMaterials: TMaterialDataList;
      function FindMaterialInFile(materialName: string): TMaterialData;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected
      materials: TMaterialDataList;
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

// +---------------------------------------------------------------------------+
// |                                                                           |
// |                             MATERIAL DATA                                 |
// |                                                                           |
// +---------------------------------------------------------------------------+
constructor TMaterialData.Create(newMaterialName: string);
begin
  // maybe keep a global material index counter? then number to name.
  self.name := newMaterialName;
  self.materialType := 'flat';
  self.filter := 'nearest';
  self.materialProperty := 'metal';
  self.colorR := 1.0;
  self.colorG := 1.0;
  self.colorB := 1.0;
  self.specular := 0.0;
  self.exponent := 1.0;
  self.transparency := 0.0;
  self.reflectivity := 0.0;
  self.source := 'same';
end;

// +---------------------------------------------------------------------------+
// |                                                                           |
// |                             MATERIAL FILE                                 |
// |                                                                           |
// +---------------------------------------------------------------------------+
constructor TMaterial.Create(materialFileName: string; collection: TMaterialCollection);
begin
  self.name := materialFileName;
  self.parent := collection;
  self.materials := TMaterialDataList.Create;
end;

function TMaterial.GetType: string;
begin
  Result := 'MATERIAL'
end;

function TMaterial.GetPath: string;
begin
  Result := 'data/' + name + '.list';
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

procedure TMaterial.LoadFromDisk;
var
  assetFile: TAssetParser;
  rowIndex: Integer;
  material: TMaterialData;
  fs: TFormatSettings;
begin
  assetFile := TAssetParser.Create(GetPath);

  if not assetFile.IsOpen then
  begin
    WriteLn('was not loaded!!!!!');
    Exit;
  end;

  if assetFile.GetRowCount < 1 then
  begin
    WriteLn('was not loaded!!!!!');
    Exit;
  end;

  if assetFile.GetValue(0, 0) <> 'MATv7' then
  begin
    WriteLn('INCORRECT HEADER!!!');
    Exit;
  end;

  fs := DefaultFormatSettings;
  fs.DecimalSeparator := '.';

  for rowIndex := 1 to assetFile.GetRowCount - 1 do begin
    material := TMaterialData.Create(assetFile.GetValue(rowIndex, 0));

    material.materialType := assetFile.GetValue(rowIndex, 1);
    material.filter := assetFile.GetValue(rowIndex, 2);
    material.materialProperty := assetFile.GetValue(rowIndex, 3);
    material.colorR := StrToFloat(assetFile.GetValue(rowIndex, 4), fs);
    material.colorG := StrToFloat(assetFile.GetValue(rowIndex, 5), fs);
    material.colorB := StrToFloat(assetFile.GetValue(rowIndex, 6), fs);
    material.specular := StrToFloat(assetFile.GetValue(rowIndex, 7), fs);
    material.exponent := StrToFloat(assetFile.GetValue(rowIndex, 8), fs);
    material.transparency := StrToFloat(assetFile.GetValue(rowIndex, 9), fs);
    material.reflectivity := StrToFloat(assetFile.GetValue(rowIndex, 10), fs);
    material.source := assetFile.GetValue(rowIndex, 11);

    self.materials.Add(material);
      // we should probably validate the file here.. ahh whatevs
  end;
end;

procedure TMaterial.SaveToDisk;
var
  output: TAssetWriter;
  material: TMaterialData;

  procedure writeTableHeader;
  begin
    output.Append(['# material name', '|',
      'type', '|',
      'filter', '|',
      'property', '|',
      'color', '|',
      'specl.', '|',
      'exp.', '|',
      'tr.', '|',
      'refl.', '|',
      'source'
    ]);
  end;
begin
  output := TAssetWriter.Create(GetPath);

  output.Append(['# Tramway SDK Material File']);
  output.Append(['# Generated by: Material Editor v0.1.1']);
  output.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  output.Append(nil);

  output.Append(['MATv7']);
  output.Append(nil);

  writeTableHeader;

  for material in self.materials do begin
    output.Append([material.name, '',
                   material.materialType, '',
                   material.filter, '',
                   material.materialProperty, '',
                   Format('%f %f %f', [material.colorR, material.colorG, material.colorB]), '',
                   string(material.specular), '',
                   string(material.exponent),
                   string(material.transparency),
                   string(material.reflectivity),
                   material.source
    ]);
  end;

  output.Free;
end;

procedure TMaterial.LoadMetadata();
begin

end;

function TMaterial.NewMaterial(materialName: string): TMaterialData;
begin
  Result := TMaterialData.Create(materialName);
  self.materials.Add(Result);
end;

procedure TMaterial.RemoveMaterial(material: TMaterialData);
begin
  self.materials.Remove(material);
end;


function TMaterial.GetMaterials: TMaterialDataList;
begin
  Result := materials;
end;

function TMaterial.FindMaterialInFile(materialName: string): TMaterialData;
var
  candidate: TMaterialData;
begin
  for candidate in materials do if candidate.name = materialName then Exit(candidate);
  Result := nil;
end;


constructor TMaterialCollection.Create;
begin

end;

// +---------------------------------------------------------------------------+
// |                                                                           |
// |                          MATERIAL COLLECTION                              |
// |                                                                           |
// +---------------------------------------------------------------------------+
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
  files := FindAllFiles('data/', '*.list', true);

  for material in materials do
      material.SetDateOnDisk(0);

  for materialFile in files do
  begin
    material := nil;

    // extract asset name from path
    materialName := materialFile.Replace('\', '/');
    materialName := materialName.Replace('data/', '');

    materialName := materialName.Replace('.list', '');

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
      material.SetDateOnDisk(ActualFileAge(materialFile));
      Continue;
    end;

    // otherwise add it to database
    material := TMaterial.Create(materialName, self);
    material.SetDateOnDisk(ActualFileAge(materialFile));

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

