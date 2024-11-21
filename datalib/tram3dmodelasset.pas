unit Tram3DModelAsset;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil;

// TODO: add model type enum
// TODO: have constructor take in model type enum
// TODO: set GetType to choose appropriate type from enum

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
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected
      modelType: T3DModelType;
  end;

  T3DModelCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     procedure InsertFromDB(name: string; date: Integer); override;
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

constructor T3DModelCollection.Create;
begin

end;

procedure T3DModelCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  // TODO: check if asset in models even
  for index := 0 to High(models) do
      if models[index] = asset then
         Break;
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

procedure T3DModelCollection.InsertFromDB(name: string; date: Integer);
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
    Exit;
  end;

  modelType := type3DModelGeneric;

  if FileExists('data/models/' + name + '.mdmdl') then modelType := type3DModelModification;
  if FileExists('data/models/' + name + '.dymdl') then modelType := type3DModelDynamic;
  if FileExists('data/models/' + name + '.stmdl') then modelType := type3DModelStatic;

  model := T3DModel.Create(modelType, name, self);
  model.SetDateInDB(date);

  SetLength(self.models, Length(self.models) + 1);
  self.models[High(self.models)] := model;

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

