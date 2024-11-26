unit TramCollisionModelAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TCollisionModelCollection = class;
  TCollisionModel = class(TAssetMetadata)
  public
      constructor Create(collisionModelName: string; collection: TCollisionModelCollection);
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

  end;

  TCollisionModelCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     collisionModels: array of TCollisionModel;
  end;

implementation

constructor TCollisionModel.Create(collisionModelName: string; collection: TCollisionModelCollection);
begin
  self.name := collisionModelName;
  self.parent := collection;
end;

function TCollisionModel.GetType: string;
begin
  Result := 'COLLMDL';
end;

function TCollisionModel.GetPath: string;
begin
  Result := 'data/models/' + name + '.collmdl';
end;

procedure TCollisionModel.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TCollisionModel.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TCollisionModel.SetMetadata(const prop: string; value: Variant);
begin

end;
function TCollisionModel.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TCollisionModel.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TCollisionModel.LoadMetadata();
begin

end;


constructor TCollisionModelCollection.Create;
begin

end;

procedure TCollisionModelCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(collisionModels) do
      if collisionModels[index] = asset then
         Break;
  if collisionModels[index] <> asset then Exit;
  for index := index to High(collisionModels) - 1 do
      collisionModels[index] := collisionModels[index  + 1];
  SetLength(collisionModels, Length(collisionModels) - 1);
end;

procedure TCollisionModelCollection.Clear;
var
  collisionModel: TCollisionModel;
begin
  for collisionModel in self.collisionModels do collisionModel.Free;
  SetLength(collisionModels, 0);
end;

procedure TCollisionModelCollection.ScanFromDisk;
var
  files: TStringList;
  collisionModelFile: string;
  collisionModelName: string;
  collisionModel: TCollisionModel;
  collisionModelCandidate: TCollisionModel;
begin
  files := FindAllFiles('data/models', '*.collmdl', true);

  for collisionModel in collisionModels do
      collisionModel.SetDateOnDisk(0);

  for collisionModelFile in files do
  begin
    collisionModel := nil;

    // extract asset name from path
    collisionModelName := collisionModelFile.Replace('\', '/');
    collisionModelName := collisionModelName.Replace('data/models/', '');

    collisionModelName := collisionModelName.Replace('.collmdl', '');

    // check if collision model already exists in database
    for collisionModelCandidate in collisionModels do
      if collisionModelCandidate.GetName() = collisionModelName then
      begin
        collisionModel := collisionModelCandidate;
        Break;
      end;

    // if exists, update date on disk
    if collisionModel <> nil then
    begin
      collisionModel.SetDateOnDisk(FileAge(collisionModelFile));
      Continue;
    end;

    // otherwise add it to database
    collisionModel := TCollisionModel.Create( collisionModelName, self);
    collisionModel.SetDateOnDisk(FileAge(collisionModelFile));

    SetLength(self.collisionModels, Length(self.collisionModels) + 1);
    self.collisionModels[High(self.collisionModels)] := collisionModel;
  end;
end;

function TCollisionModelCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  collisionModel: TCollisionModel;
  collisionModelCandidate: TCollisionModel;
begin
  collisionModel := nil;

  for collisionModelCandidate in collisionModels do
      if collisionModelCandidate.GetName() = name then
      begin
        collisionModel := collisionModelCandidate;
        Break;
      end;

  if collisionModel <> nil then
  begin
    collisionModel.SetDateInDB(date);
    Exit(collisionModel);
  end;

  collisionModel := TCollisionModel.Create(name, self);
  collisionModel.SetDateInDB(date);

  SetLength(self.collisionModels, Length(self.collisionModels) + 1);
  self.collisionModels[High(self.collisionModels)] := collisionModel;

  Result := collisionModel;
end;

function TCollisionModelCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.collisionModels));

  for i := 0 to High(self.collisionModels) do
      Result[i] := self.collisionModels[i];
end;

end.

