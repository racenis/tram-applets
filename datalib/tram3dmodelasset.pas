unit Tram3DModelAsset;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, TramAssetMetadata, TramAssetCollection;

// TODO: add model type enum
// TODO: have constructor take in model type enum
// TODO: set GetType to choose appropriate type from enum

type
  T3DModelType = (type3DModelGeneric,
                  type3DModelStatic,
                  type3DModelDynamic,
                  type3DModelModification);
  T3DModel = class(TAssetMetadata)
  public
      constructor Create(modelType: T3DModelType; modelName: string);
      function GetType: string; override;
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
     function GetAssets: TAssetMetadataArray; override;
  protected
     models: array of T3DModel;
  end;

implementation

constructor T3DModel.Create(modelType: T3DModelType; modelName: string);
begin
  self.modelType := modelType;
  self.name := modelName;
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

procedure T3DModelCollection.Clear;
var
  model: T3DModel;
begin
  for model in self.models do model.Free;
  SetLength(models, 0);
end;

procedure T3DModelCollection.ScanFromDisk;
begin
  // start at /data/models/ directory
  // recursively process it:
  //   for each .stmdl or .dymdl
  //     find it in model array
  //     if not exist, append
  //     if exist, add date
end;

procedure T3DModelCollection.InsertFromDB(name: string; date: Integer);
var
  model: T3DModel;
  model_candidate: T3DModel;
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

  // TODO: pass in the correct type!!
  model := T3DModel.Create(type3DModelGeneric, name);

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

