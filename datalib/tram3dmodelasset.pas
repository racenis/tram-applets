unit Tram3DModelAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  T3DModelCollection = class;
  T3DModelType = (type3DModelGeneric,
                  type3DModelStatic,
                  type3DModelDynamic,
                  type3DModelModification);
  T3DModel = class(TAssetMetadata)
  public
      constructor Create(modelType: T3DModelType; modelName: string; collection: T3DModelCollection);
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
      modelHeader: string;
      modelType: T3DModelType;
      materials: array of string;
      vertexCount: Integer;
      triangleCount: Integer;
      boneCount: Integer;
      vertexGroupCount: Integer;
      lightmapWidth: Integer;
      lightmapHeight: Integer;
      baseModel: string;
      mappings: array of array[0..1] of string;
  end;

  T3DModelCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     models: array of T3DModel;
  end;

implementation

constructor T3DModel.Create(modelType: T3DModelType; modelName: string; collection: T3DModelCollection);
begin
  self.modelType := modelType;
  self.name := modelName;
  self.parent := collection;

  self.modelHeader := 'N/A';
  self.materials := nil;
  self.vertexCount := 0;
  self.triangleCount := 0;
  self.boneCount := 0;
  self.vertexGroupCount := 0;
  self.lightmapWidth := 0;
  self.lightmapHeight := 0;
  self.baseModel := 'none';
  self.mappings := nil;
end;

function T3DModel.GetType: string;
begin
  case (self.modelType) of
       type3DModelGeneric: Result := '3DMDL';
       type3DModelStatic: Result := 'STMDL';
       type3DModelDynamic: Result := 'DYMDL';
       type3DModelModification: Result := 'MDMDL';
  end;
end;

function T3DModel.GetPath: string;
begin
  case (self.modelType) of
       type3DModelGeneric: Result := 'data/models/' + name + '.3dmdl';
       type3DModelStatic: Result := 'data/models/' + name + '.stmdl';
       type3DModelDynamic: Result := 'data/models/' + name + '.dymdl';
       type3DModelModification: Result := 'data/models/' + name + '.mdmdl';
  end;
end;

procedure T3DModel.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure T3DModel.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function T3DModel.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure T3DModel.SetMetadata(const prop: string; value: Variant);
begin
  case prop of
       'LIGHTMAP_WIDTH': lightmapWidth := value;
       'LIGHTMAP_HEIGHT': lightmapHeight := value;
  end;
end;
function T3DModel.GetMetadata(const prop: string): Variant;
begin
  case prop of
       'MODEL_HEADER': Result := modelHeader;
       'LIGHTMAP_WIDTH': Result := lightmapWidth;
       'LIGHTMAP_HEIGHT': Result := lightmapHeight;
       'VERTICES': Result := vertexCount;
       'TRIANGLES': Result := triangleCount;
       'MATERIALS': Result := Length(materials);
       'BONES': Result := boneCount;
       'VERTEX_GROUPS': Result := vertexGroupCount;
       'BASE_MODEL': Result := baseModel;
       'MAPPINGS': Result := Length(mappings);
       'APPROX_SIZE': begin
         case (self.modelType) of
              type3DModelGeneric: Result := 'N/A';
              type3DModelStatic: Result := ((vertexCount * 44 + triangleCount * 12) div 1024).ToString + ' KB';
              type3DModelDynamic: Result := ((vertexCount * 68 + triangleCount * 12) div 1024).ToString + ' KB';
              type3DModelModification: Result := 'Same As Base';
         end;
       end else begin
         if prop.StartsWith('MATERIAL') then
           Result := materials[prop.Remove(0, Length('MATERIAL')).ToInteger]
         else if prop.StartsWith('MAPPING_FROM') then
           Result := mappings[prop.Remove(0, Length('MAPPING_FROM')).ToInteger][0]
         else if prop.StartsWith('MAPPING_TO') then
           Result := mappings[prop.Remove(0, Length('MAPPING_TO')).ToInteger][1]
         else Result := nil;
       end;
  end;
end;

function T3DModel.GetPropertyList: TAssetPropertyList;
begin
  case (self.modelType) of
       type3DModelGeneric: Result := [];
       type3DModelStatic: Result := ['LIGHTMAP_WIDTH', 'LIGHTMAP_HEIGHT'];
       type3DModelDynamic: Result := [];
       type3DModelModification: Result := [];
  end;
end;

procedure T3DModel.LoadMetadata();
var
  modelFile: TAssetParser;
  materialCount: Integer;
  mat: Integer;
begin
  modelFile := TAssetParser.Create(self.GetPath, 30);

  if not modelFile.IsOpen then
  begin
       Exit;
  end;

  if modelFile.GetValue(0, 0) = 'DYMDLv1' then begin
    modelHeader := 'DYMDLv1';

    vertexCount := modelFile.GetValue(0, 1).ToInteger;
    triangleCount := modelFile.GetValue(0, 2).ToInteger;
    materialCount := modelFile.GetValue(0, 3).ToInteger;
    boneCount := modelFile.GetValue(0, 4).ToInteger;
    vertexGroupCount := modelFile.GetValue(0, 5).ToInteger;

    SetLength(materials, materialCount);

    for mat := 0 to materialCount - 1 do
        materials[mat] := modelFile.GetValue(mat + 1, 0);

    // if we ever change the DYMDL format around, so that vertex groups and bone
    // names start at the very beginning, then we could read them in just like
    // with materials

  end else if modelFile.GetValue(0, 0) = 'MDMDLv1' then begin
    modelHeader := 'MDMDLv1';

    baseModel := modelFile.GetValue(0, 1);

    SetLength(mappings, modelFile.GetRowCount - 1);

    for mat := 0 to High(mappings) do begin
      mappings[mat][0] := modelFile.GetValue(mat + 1, 0);
      mappings[mat][1] := modelFile.GetValue(mat + 1, 1);
    end;


  end else begin
    // here we will assume that if there is no header, then the model is a
    // static model. if we ever add a header to static models, we could check
    // here for STMDLv1 or whatever and then we could have another case where
    // we don't parse anything else, but only save the header, whatever that is

    vertexCount := modelFile.GetValue(0, 0).ToInteger;
    triangleCount := modelFile.GetValue(0, 1).ToInteger;
    materialCount := modelFile.GetValue(0, 2).ToInteger;

    if materialCount > modelFile.GetRowCount - 1 then materialCount := 0;

    SetLength(materials, materialCount);

    for mat := 0 to materialCount - 1 do
        materials[mat] := modelFile.GetValue(mat + 1, 0);
  end;


end;


constructor T3DModelCollection.Create;
begin

end;

procedure T3DModelCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(models) do
      if models[index] = asset then
         Break;
  if models[index] <> asset then Exit;
  for index := index to High(models) - 1 do
      models[index] := models[index  + 1];
  SetLength(models, Length(models) - 1);
end;

procedure T3DModelCollection.Clear;
var
  model: T3DModel;
begin
  for model in self.models do model.Free;
  SetLength(models, 0);
end;

procedure T3DModelCollection.ScanFromDisk;
var
  files: TStringList;
  modelFile: string;
  modelName: string;
  model: T3DModel;
  modelCandidate: T3DModel;
  modelType: T3DModelType;
begin
  files := FindAllFiles('data/models', '*.stmdl;*.dymdl;*.mdmdl', true);

  for model in models do
      model.SetDateOnDisk(0);

  for modelFile in files do
  begin
    model := nil;

    // find the model type from filename
    modelType := type3DModelGeneric;

    if modelFile.EndsWith('.stmdl') then modelType := type3DModelStatic;
    if modelFile.EndsWith('.dymdl') then modelType := type3DModelDynamic;
    if modelFile.EndsWith('.mdmdl') then modelType := type3DModelModification;

    // extract asset name from path
    modelName := modelFile.Replace('\', '/');
    modelName := modelName.Replace('data/models/', '');

    modelName := modelName.Replace('.stmdl', '');
    modelName := modelName.Replace('.dymdl', '');
    modelName := modelName.Replace('.mdmdl', '');

    // check if model already exists in database
    for modelCandidate in models do
      if modelCandidate.GetName() = modelName then
      begin
        model := modelCandidate;
        Break;
      end;

    // if exists, update date on disk
    if model <> nil then
    begin
      model.SetDateOnDisk(FileAge(modelFile));
      Continue;
    end;

    // otherwise add it to database
    model := T3DModel.Create(modelType, modelName, self);
    model.SetDateOnDisk(FileAge(modelFile));

    SetLength(self.models, Length(self.models) + 1);
    self.models[High(self.models)] := model;
  end;
end;

function T3DModelCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  model: T3DModel;
  model_candidate: T3DModel;
  modelType: T3DModelType;
begin
  model := nil;

  for model_candidate in models do
      if model_candidate.GetName() = name then
      begin
        model := model_candidate;
        Break;
      end;

  if model <> nil then
  begin
    model.SetDateInDB(date);
    Exit(model);
  end;

  modelType := type3DModelGeneric;

  if FileExists('data/models/' + name + '.mdmdl') then modelType := type3DModelModification;
  if FileExists('data/models/' + name + '.dymdl') then modelType := type3DModelDynamic;
  if FileExists('data/models/' + name + '.stmdl') then modelType := type3DModelStatic;

  model := T3DModel.Create(modelType, name, self);
  model.SetDateInDB(date);

  SetLength(self.models, Length(self.models) + 1);
  self.models[High(self.models)] := model;

  Result := model;
end;

function T3DModelCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.models));

  for i := 0 to High(self.models) do
      Result[i] := self.models[i];
end;

end.

