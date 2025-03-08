unit TramSpriteAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TSpriteCollection = class;
  TSprite = class(TAssetMetadata)
  public
      constructor Create(spriteName: string; collection: TSpriteCollection);
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

  TSpriteCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     sprites: array of TSprite;
  end;

implementation

constructor TSprite.Create(spriteName: string; collection: TSpriteCollection);
begin
  self.name := spriteName;
  self.parent := collection;
end;

function TSprite.GetType: string;
begin
  Result := 'SPRITE';
end;

function TSprite.GetPath: string;
begin
  Result := 'data/sprites/' + name + '.spr';
end;

procedure TSprite.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TSprite.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TSprite.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TSprite.SetMetadata(const prop: string; value: Variant);
begin

end;
function TSprite.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TSprite.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TSprite.LoadMetadata();
begin

end;


constructor TSpriteCollection.Create;
begin

end;

procedure TSpriteCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(sprites) do
      if sprites[index] = asset then
         Break;
  if sprites[index] <> asset then Exit;
  for index := index to High(sprites) - 1 do
      sprites[index] := sprites[index  + 1];
  SetLength(sprites, Length(sprites) - 1);
end;

procedure TSpriteCollection.Clear;
var
  sprite: TSprite;
begin
  for sprite in self.sprites do sprite.Free;
  SetLength(sprites, 0);
end;

procedure TSpriteCollection.ScanFromDisk;
var
  files: TStringList;
  spriteFile: string;
  spriteName: string;
  sprite: TSprite;
  spriteCandidate: TSprite;
begin
  files := FindAllFiles('data/sprites', '*.spr', true);

  for sprite in sprites do
      sprite.SetDateOnDisk(0);

  for spriteFile in files do
  begin
    sprite := nil;

    // extract asset name from path
    spriteName := spriteFile.Replace('\', '/');
    spriteName := spriteName.Replace('data/sprites/', '');

    spriteName := spriteName.Replace('.spr', '');

    // check if sprite already exists in database
    for spriteCandidate in sprites do
      if spriteCandidate.GetName() = spriteName then
      begin
        sprite := spriteCandidate;
        Break;
      end;

    // if exists, update date on disk
    if sprite <> nil then
    begin
      sprite.SetDateOnDisk(FileAge(spriteFile));
      Continue;
    end;

    // otherwise add it to database
    sprite := TSprite.Create( spriteName, self);
    sprite.SetDateOnDisk(FileAge(spriteFile));

    SetLength(self.sprites, Length(self.sprites) + 1);
    self.sprites[High(self.sprites)] := sprite;
  end;
end;

function TSpriteCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  sprite: TSprite;
  spriteCandidate: TSprite;
begin
  sprite := nil;

  for spriteCandidate in sprites do
      if spriteCandidate.GetName() = name then
      begin
        sprite := spriteCandidate;
        Break;
      end;

  if sprite <> nil then
  begin
    sprite.SetDateInDB(date);
    Exit(sprite);
  end;

  sprite := TSprite.Create(name, self);
  sprite.SetDateInDB(date);

  SetLength(self.sprites, Length(self.sprites) + 1);
  self.sprites[High(self.sprites)] := sprite;

  Result := sprite;
end;

function TSpriteCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.sprites));

  for i := 0 to High(self.sprites) do
      Result[i] := self.sprites[i];
end;

end.

