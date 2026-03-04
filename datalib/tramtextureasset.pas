unit TramTextureAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TTextureCollection = class;
  TTexture = class(TAssetMetadata)
  public
      constructor Create(textureName: string; collection: TTextureCollection);
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

  TTextureCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     textures: array of TTexture;
  end;

implementation

constructor TTexture.Create(textureName: string; collection: TTextureCollection);
begin
  self.name := textureName;
  self.parent := collection;
end;

function TTexture.GetType: string;
begin
  Result := 'TEXTURE'
end;

function TTexture.GetPath: string;
begin
  Result := 'data/textures/' + name + '.png';
end;

procedure TTexture.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TTexture.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TTexture.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TTexture.SetMetadata(const prop: string; value: Variant);
begin

end;
function TTexture.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TTexture.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TTexture.LoadMetadata();
begin

end;


constructor TTextureCollection.Create;
begin

end;

procedure TTextureCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  // TODO: check if asset in textures even
  for index := 0 to High(textures) do
      if textures[index] = asset then
         Break;
  for index := index to High(textures) - 1 do
      textures[index] := textures[index  + 1];
  SetLength(textures, Length(textures) - 1);
end;

procedure TTextureCollection.Clear;
var
  texture: TTexture;
begin
  for texture in self.textures do texture.Free;
  SetLength(textures, 0);
end;

procedure TTextureCollection.ScanFromDisk;
var
  files: TStringList;
  textureFile: string;
  textureName: string;
  texture: TTexture;
  textureCandidate: TTexture;
begin
  files := FindAllFiles('data/textures', '*.png', true);

  for texture in textures do
      texture.SetDateOnDisk(0);

  for textureFile in files do
  begin
    texture := nil;

    // extract asset name from path
    textureName := textureFile.Replace('\', '/');
    textureName := textureName.Replace('data/textures/', '');

    textureName := textureName.Replace('.png', '');

    // check if texture already exists in database
    for textureCandidate in textures do
      if textureCandidate.GetName() = textureName then
      begin
        texture := textureCandidate;
        Break;
      end;

    // if exists, update date on disk
    if texture <> nil then
    begin
      texture.SetDateOnDisk(ActualFileAge(textureFile));
      Continue;
    end;

    // otherwise add it to database
    texture := TTexture.Create(textureName, self);
    texture.SetDateOnDisk(ActualFileAge(textureFile));

    SetLength(self.textures, Length(self.textures) + 1);
    self.textures[High(self.textures)] := texture;
  end;
end;

function TTextureCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  texture: TTexture;
  texture_candidate: TTexture;
begin
  texture := nil;

  for texture_candidate in textures do
      if texture_candidate.GetName() = name then
      begin
        texture := texture_candidate;
        Break;
      end;

  if texture <> nil then
  begin
    texture.SetDateInDB(date);
    Exit(texture);
  end;

  texture := TTexture.Create(name, self);
  texture.SetDateInDB(date);

  SetLength(self.textures, Length(self.textures) + 1);
  self.textures[High(self.textures)] := texture;

  Result := texture;
end;

function TTextureCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.textures));

  for i := 0 to High(self.textures) do
      Result[i] := self.textures[i];
end;

end.

