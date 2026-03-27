unit TramSpriteAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser, fgl,
  TramAssetWriter;

type

  { TSpriteData }

  TSpriteData = class
  public
     constructor Create;
  public
     isMarker: Boolean;
     nameIfMarker: string;

     offsetX: Integer;
     offsetY: Integer;
     width: Integer;
     height: Integer;
     midpointX: Integer;
     midpointY: Integer;
     borderH: Integer;
     borderV: Integer;
  end;
  TSpriteDataList = specialize TFPGList<TSpriteData>;

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

      function NewSprite(): TSpriteData;
      procedure RemoveSprite(sprite: TSpriteData);

      procedure LoadFromDisk; override;
      procedure SaveToDisk; override;

      function GetSprites: TSpriteDataList;
      function GetMaterial: string;
      procedure SetMaterial(material: string);

      procedure InsertFrame(index: Integer);
      procedure InsertMarker(index: Integer);
      procedure RemoveFrame(index: Integer);
      procedure DuplicateFrame(index: Integer);
      procedure MoveFrameUp(index: Integer);
      procedure MoveFrameDown(index: Integer);

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected
     material: string;
     sprites: TSpriteDataList;
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

  self.sprites := TSpriteDataList.Create;
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

function TSprite.NewSprite(): TSpriteData;
begin
  sprites.Add(TSpriteData.Create);
end;

procedure TSprite.RemoveSprite(sprite: TSpriteData);
begin
  sprites.Remove(sprite);
end;

procedure TSprite.LoadFromDisk;
var
  assetFile: TAssetParser;
  rowIndex: Integer;
  sprite: TSpriteData;
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

  if (assetFile.GetValue(0, 0) <> 'SPRv2') and (assetFile.GetValue(0, 0) <> 'SPRv3') then
  begin
    WriteLn('INCORRECT HEADER!!!');
    Exit;
  end;

  fs := DefaultFormatSettings;
  fs.DecimalSeparator := '.';

  material := assetFile.GetValue(0, 1);

  if assetFile.GetValue(0, 0) = 'SPRv2' then
    for rowIndex := 1 to assetFile.GetRowCount - 1 do begin
      sprite := TSpriteData.Create;

      sprite.offsetX := StrToInt(assetFile.GetValue(rowIndex, 0));
      sprite.offsetY := StrToInt(assetFile.GetValue(rowIndex, 1));
      sprite.width := StrToInt(assetFile.GetValue(rowIndex, 2));
      sprite.height := StrToInt(assetFile.GetValue(rowIndex, 3));
      sprite.midpointX := StrToInt(assetFile.GetValue(rowIndex, 4));
      sprite.midpointY := StrToInt(assetFile.GetValue(rowIndex, 5));
      sprite.borderH := StrToInt(assetFile.GetValue(rowIndex, 6));
      sprite.borderV := StrToInt(assetFile.GetValue(rowIndex, 7));

      self.sprites.Add(sprite);
    end;

  if assetFile.GetValue(0, 0) = 'SPRv3' then
    for rowIndex := 1 to assetFile.GetRowCount - 1 do
    if assetFile.GetValue(rowIndex, 0) = 'frame' then begin
      sprite := TSpriteData.Create;

      sprite.isMarker := False;

      sprite.offsetX := StrToInt(assetFile.GetValue(rowIndex, 1));
      sprite.offsetY := StrToInt(assetFile.GetValue(rowIndex, 2));
      sprite.width := StrToInt(assetFile.GetValue(rowIndex, 3));
      sprite.height := StrToInt(assetFile.GetValue(rowIndex, 4));
      sprite.midpointX := StrToInt(assetFile.GetValue(rowIndex, 5));
      sprite.midpointY := StrToInt(assetFile.GetValue(rowIndex, 6));
      sprite.borderH := StrToInt(assetFile.GetValue(rowIndex, 7));
      sprite.borderV := StrToInt(assetFile.GetValue(rowIndex, 8));

      self.sprites.Add(sprite);
    end else begin
      sprite := TSpriteData.Create;

      sprite.isMarker := True;

      sprite.nameIfMarker := assetFile.GetValue(rowIndex, 1);

      self.sprites.Add(sprite);
    end;

end;

procedure TSprite.SaveToDisk;
var
  output: TAssetWriter;
  sprite: TSpriteData;
begin
  output := TAssetWriter.Create(GetPath);
  output.Append(['# Tramway SDK Sprite File']);
  output.Append(['# Generated by: Sprite Editor v0.1.1']);
  output.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  output.Append(nil);
  output.Append(['SPRv3', material]);
  output.Append(nil);
  for sprite in self.sprites do begin
    if sprite.isMarker then
      output.Append(['marker', sprite.nameIfMarker])
    else
      output.Append(['frame', '',
                     IntToStr(sprite.offsetX), '',
                     IntToStr(sprite.offsetY), '',
                     IntToStr(sprite.width), '',
                     IntToStr(sprite.height), '',
                     IntToStr(sprite.midpointX), '',
                     IntToStr(sprite.midpointY), '',
                     IntToStr(sprite.borderH), '',
                     IntToStr(sprite.borderV)
      ]);
  end;
  output.Free;
end;

function TSprite.GetSprites: TSpriteDataList;
begin
  Result := sprites;
end;

function TSprite.GetMaterial: string;
begin
  Result := material;
end;

procedure TSprite.SetMaterial(material: string);
begin
  self.material := material;
end;

procedure TSprite.InsertFrame(index: Integer);
var
  newFrame: TSpriteData;
begin
  newFrame := TSpriteData.Create;
  newFrame.isMarker := False;
  newFrame.nameIfMarker := 'not marker';

  newFrame.offsetX := 4;
  newFrame.offsetY := 4;
  newFrame.width := 8;
  newFrame.height := 16;
  newFrame.midpointX := 4;
  newFrame.midpointY := 8;
  newFrame.borderH := 2;
  newFrame.borderV := 2;

  WriteLn('Inserting new frame at', index);

  self.sprites.Insert(index, newFrame);
end;

procedure TSprite.InsertMarker(index: Integer);
var
  newFrame: TSpriteData;
begin
  newFrame := TSpriteData.Create;
  newFrame.isMarker := True;
  newFrame.nameIfMarker := 'NEW_MARKER';

  self.sprites.Insert(index, newFrame);
end;

procedure TSprite.RemoveFrame(index: Integer);
begin
  self.sprites.Delete(index);
end;

procedure TSprite.DuplicateFrame(index: Integer);
var
  newFrame: TSpriteData;
begin
  newFrame := TSpriteData.Create;

  newFrame.isMarker := sprites[index].isMarker;
  newFrame.nameIfMarker := sprites[index].nameIfMarker;

  newFrame.offsetX := sprites[index].offsetX;
  newFrame.offsetY := sprites[index].offsetY;
  newFrame.width := sprites[index].width;
  newFrame.height := sprites[index].height;
  newFrame.midpointX := sprites[index].midpointX;
  newFrame.midpointY := sprites[index].midpointY;
  newFrame.borderH := sprites[index].borderH;
  newFrame.borderV := sprites[index].borderV;

  self.sprites.Insert(index, newFrame);
end;

procedure TSprite.MoveFrameUp(index: Integer);
begin
  self.sprites.Exchange(index, index-1);
end;

procedure TSprite.MoveFrameDown(index: Integer);
begin
  self.sprites.Exchange(index, index+1);
end;

procedure TSprite.LoadMetadata();
begin

end;

{ TSpriteData }

constructor TSpriteData.Create;
begin
  offsetX := 0;
  offsetY := 0;
  width := 10;
  height := 10;
  midpointX := 5;
  midpointY := 5;
  borderH := 2;
  borderV := 2;
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
      sprite.SetDateOnDisk(ActualFileAge(spriteFile));
      Continue;
    end;

    // otherwise add it to database
    sprite := TSprite.Create( spriteName, self);
    sprite.SetDateOnDisk(ActualFileAge(spriteFile));

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

