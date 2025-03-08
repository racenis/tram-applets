unit TramEntityDefinitionAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TEntityDefinitionCollection = class;
  TEntityDefinition = class(TAssetMetadata)
  public
      constructor Create(entityDefinitionName: string; collection: TEntityDefinitionCollection);
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

  TEntityDefinitionCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     entityDefinitions: array of TEntityDefinition;
  end;

implementation

constructor TEntityDefinition.Create(entityDefinitionName: string; collection: TEntityDefinitionCollection);
begin
  self.name := entityDefinitionName;
  self.parent := collection;
end;

function TEntityDefinition.GetType: string;
begin
  Result := 'ENTDEF';
end;

function TEntityDefinition.GetPath: string;
begin
  Result := 'data/' + name + '.entdef';
end;

procedure TEntityDefinition.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TEntityDefinition.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TEntityDefinition.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TEntityDefinition.SetMetadata(const prop: string; value: Variant);
begin

end;
function TEntityDefinition.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TEntityDefinition.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TEntityDefinition.LoadMetadata();
begin

end;


constructor TEntityDefinitionCollection.Create;
begin

end;

procedure TEntityDefinitionCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(entityDefinitions) do
      if entityDefinitions[index] = asset then
         Break;
  if entityDefinitions[index] <> asset then Exit;
  for index := index to High(entityDefinitions) - 1 do
      entityDefinitions[index] := entityDefinitions[index  + 1];
  SetLength(entityDefinitions, Length(entityDefinitions) - 1);
end;

procedure TEntityDefinitionCollection.Clear;
var
  entityDefinition: TEntityDefinition;
begin
  for entityDefinition in self.entityDefinitions do entityDefinition.Free;
  SetLength(entityDefinitions, 0);
end;

procedure TEntityDefinitionCollection.ScanFromDisk;
var
  files: TStringList;
  entityDefinitionFile: string;
  entityDefinitionName: string;
  entityDefinition: TEntityDefinition;
  entityDefinitionCandidate: TEntityDefinition;
begin
  files := FindAllFiles('data/', '*.entdef', true);

  for entityDefinition in entityDefinitions do
      entityDefinition.SetDateOnDisk(0);

  for entityDefinitionFile in files do
  begin
    entityDefinition := nil;

    // extract asset name from path
    entityDefinitionName := entityDefinitionFile.Replace('\', '/');
    entityDefinitionName := entityDefinitionName.Replace('data/', '');

    entityDefinitionName := entityDefinitionName.Replace('.entdef', '');

    // check if entity definition already exists in database
    for entityDefinitionCandidate in entityDefinitions do
      if entityDefinitionCandidate.GetName() = entityDefinitionName then
      begin
        entityDefinition := entityDefinitionCandidate;
        Break;
      end;

    // if exists, update date on disk
    if entityDefinition <> nil then
    begin
      entityDefinition.SetDateOnDisk(FileAge(entityDefinitionFile));
      Continue;
    end;

    // otherwise add it to database
    entityDefinition := TEntityDefinition.Create( entityDefinitionName, self);
    entityDefinition.SetDateOnDisk(FileAge(entityDefinitionFile));

    SetLength(self.entityDefinitions, Length(self.entityDefinitions) + 1);
    self.entityDefinitions[High(self.entityDefinitions)] := entityDefinition;
  end;
end;

function TEntityDefinitionCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  entityDefinition: TEntityDefinition;
  entityDefinitionCandidate: TEntityDefinition;
begin
  entityDefinition := nil;

  for entityDefinitionCandidate in entityDefinitions do
      if entityDefinitionCandidate.GetName() = name then
      begin
        entityDefinition := entityDefinitionCandidate;
        Break;
      end;

  if entityDefinition <> nil then
  begin
    entityDefinition.SetDateInDB(date);
    Exit(entityDefinition);
  end;

  entityDefinition := TEntityDefinition.Create(name, self);
  entityDefinition.SetDateInDB(date);

  SetLength(self.entityDefinitions, Length(self.entityDefinitions) + 1);
  self.entityDefinitions[High(self.entityDefinitions)] := entityDefinition;

  Result := entityDefinition;
end;

function TEntityDefinitionCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.entityDefinitions));

  for i := 0 to High(self.entityDefinitions) do
      Result[i] := self.entityDefinitions[i];
end;

end.

