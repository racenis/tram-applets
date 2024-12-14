unit TramItemAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser, TramAssetWriter, fgl;

type
  TItem = class;
  TItemData = class;
  TItemDataList = specialize TFPGList<TItemData>;

  TItemAttributeEffectType = (itemAttribute, itemEffect);
  TItemAttributeEffect = class
     attributeType: string;
     value: string;
     name: string;
     tag: string;
     effectType: string;
     duration: string;
     recordType: TItemAttributeEffectType;
  end;
  TItemAttributeEffectList = specialize TFPGList<TItemAttributeEffect>;

  TItemData = class
  public
     constructor Create;
     function FindInDataList(name: string): TItemData;
  public
    name: string;
    base: string;
    equipmentSlot: string;

    viewmodel: string;
    worldmodel: string;

    sprite: string;
    spriteFrame: string;

    icon: string;
    iconFrame: string;

    width: string;
    height: string;
    stack: string;
    weight: string;

    compartment: string;

    effects: TItemAttributeEffectList;

    dataList: TItemDataList; static;
  end;

  TItemCollection = class;
  TItem = class(TAssetMetadata)
  public
      constructor Create(dialogName: string; collection: TItemCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata; override;
      procedure LoadFromDisk; override;

      procedure SaveToDisk; override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected

  end;

  TItemCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     dialogs: array of TItem;
  end;

implementation

constructor TItemData.Create;
begin
  self.effects := TItemAttributeEffectList.Create;
end;

function TItemData.FindInDataList(name: string): TItemData;
var
  candidate: TItemData;
begin
  for candidate in dataList do if candidate.name = name then Exit(candidate);
  Result := nil;
end;

constructor TItem.Create(dialogName: string; collection: TItemCollection);
begin
  self.name := dialogName;
  self.parent := collection;
end;

function TItem.GetType: string;
begin
  Result := 'ITEM';
end;

function TItem.GetPath: string;
begin
  Result := 'data/' + name + '.dialog';
end;

procedure TItem.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TItem.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TItem.SetMetadata(const prop: string; value: Variant);
begin

end;
function TItem.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TItem.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TItem.LoadMetadata();
begin

end;

procedure TItem.LoadFromDisk();
var
  assetFile: TAssetParser;
  rowIndex: Integer;
  item: TItemData;
  effect: TItemAttributeEffect;
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

  if assetFile.GetValue(0, 0) <> 'ITEMv1' then
  begin
    WriteLn('INCORRECT HEADER!!!');
    Exit;
  end;

  for rowIndex := 1 to assetFile.GetRowCount - 1 do
  case assetFile.GetValue(rowIndex, 0) of
    'item-class': begin
      item := TItemData.Create;

      item.name := assetFile.GetValue(rowIndex, 1);
      item.base := assetFile.GetValue(rowIndex, 2);
      item.equipmentSlot := assetFile.GetValue(rowIndex, 3);

      TItemData.dataList.Add(item);
    end;
    'world-display': begin
      item := item.FindInDataList(assetFile.GetValue(rowIndex, 1));

      item.viewmodel := assetFile.GetValue(rowIndex, 2);
      item.viewmodel := assetFile.GetValue(rowIndex, 3);
    end;
    'gui-display': begin
      item := item.FindInDataList(assetFile.GetValue(rowIndex, 1));

      item.sprite := assetFile.GetValue(rowIndex, 2);
      item.spriteFrame := assetFile.GetValue(rowIndex, 3);
      item.icon := assetFile.GetValue(rowIndex, 4);
      item.iconFrame := assetFile.GetValue(rowIndex, 5);
    end;
    'item-layout': begin
      item := item.FindInDataList(assetFile.GetValue(rowIndex, 1));

      item.width := assetFile.GetValue(rowIndex, 2);
      item.height := assetFile.GetValue(rowIndex, 3);
      item.stack := assetFile.GetValue(rowIndex, 4);
      item.weight := assetFile.GetValue(rowIndex, 5);
      item.compartment := assetFile.GetValue(rowIndex, 6);
    end;
    'item-attribute': begin
      item := item.FindInDataList(assetFile.GetValue(rowIndex, 1));

      effect := TItemAttributeEffect.Create;

      effect.attributeType := assetFile.GetValue(rowIndex, 2);
      effect.value := assetFile.GetValue(rowIndex, 3);

      effect.recordType := itemAttribute;

      item.effects.Add(effect);
    end;
    'item-effect': begin
      item := item.FindInDataList(assetFile.GetValue(rowIndex, 1));

      effect := TItemAttributeEffect.Create;

      effect.attributeType := assetFile.GetValue(rowIndex, 2);
      effect.value := assetFile.GetValue(rowIndex, 3);
      effect.name := assetFile.GetValue(rowIndex, 4);
      effect.tag := assetFile.GetValue(rowIndex, 5);
      effect.effectType := assetFile.GetValue(rowIndex, 6);
      effect.duration := assetFile.GetValue(rowIndex, 7);

      effect.recordType := itemEffect;

      item.effects.Add(effect);
    end;
    else WriteLn(assetFile.GetValue(rowIndex, 0));
  end;
end;

function NoneIfBlank(param: string): string;
begin
  Result := param.Trim;
  if Result = '' then Result := 'none';
end;

function IsNotNone(param: string): Boolean;
begin
  Result := NoneIfBlank(param) <> 'none';
end;

procedure TItem.SaveToDisk();
var
  output: TAssetWriter;
  item: TItemData;
  typeAsString: string;
  nextTopic: string;
  effect: TItemAttributeEffect;
begin
  output := TAssetWriter.Create(GetPath);

  output.Append(['# Tramway SDK Kitchensink Dialog File']);
  output.Append(['# Generated by: Kitchensink Editor v0.0.9']);
  output.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  output.Append(nil);

  output.Append(['DIALOGv1']);
  output.Append(nil);

  for item in TItemData.dataList do begin
    output.Append(['item-class',
                   NoneIfBlank(item.name),
                   NoneIfBlank(item.base),
                   NoneIfBlank(item.equipmentSlot)]);

    if IsNotNone(item.viewmodel) and IsNotNone(item.worldmodel) then
      output.Append(['world-display',
                     NoneIfBlank(item.name),
                     NoneIfBlank(item.viewmodel),
                     NoneIfBlank(item.worldmodel)]);
    if IsNotNone(item.sprite) and IsNotNone(item.icon) then
      output.Append(['gui-display',
                     NoneIfBlank(item.name),
                     NoneIfBlank(item.sprite),
                     item.spriteFrame,
                     NoneIfBlank(item.icon),
                     item.iconFrame]);
    output.Append(['item-layout',
                   NoneIfBlank(item.name),
                   item.width,
                   item.height,
                   item.stack,
                   item.weight,
                   NoneIfBlank(item.compartment)]);

    for effect in item.effects do
      case effect.recordType of
        itemAttribute:
          output.Append(['item-attribute',
                         NoneIfBlank(item.name),
                         effect.attributeType,
                         effect.value]);
        itemEffect:
          output.Append(['item-effect',
                         NoneIfBlank(item.name),
                         effect.attributeType,
                         effect.value,
                         NoneIfBlank(effect.name),
                         NoneIfBlank(effect.tag),
                         effect.effectType,
                         effect.duration]);
      end;

  end;

  output.Free;
end;

constructor TItemCollection.Create;
begin

end;

procedure TItemCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(dialogs) do
      if dialogs[index] = asset then
         Break;
  if dialogs[index] <> asset then Exit;
  for index := index to High(dialogs) - 1 do
      dialogs[index] := dialogs[index  + 1];
  SetLength(dialogs, Length(dialogs) - 1);
end;

procedure TItemCollection.Clear;
var
  dialog: TItem;
begin
  for dialog in self.dialogs do dialog.Free;
  SetLength(dialogs, 0);
end;

procedure TItemCollection.ScanFromDisk;
var
  files: TStringList;
  dialogFile: string;
  dialogName: string;
  dialog: TItem;
  dialogCandidate: TItem;
begin
  files := FindAllFiles('data/', '*.dialog', true);

  for dialog in dialogs do
      dialog.SetDateOnDisk(0);

  for dialogFile in files do
  begin
    dialog := nil;

    // extract asset name from path
    dialogName := dialogFile.Replace('\', '/');
    dialogName := dialogName.Replace('data/', '');

    dialogName := dialogName.Replace('.dialog', '');

    // check if dialog already exists in database
    for dialogCandidate in dialogs do
      if dialogCandidate.GetName() = dialogName then
      begin
        dialog := dialogCandidate;
        Break;
      end;

    // if exists, update date on disk
    if dialog <> nil then
    begin
      dialog.SetDateOnDisk(FileAge(dialogFile));
      Continue;
    end;

    // otherwise add it to database
    dialog := TItem.Create( dialogName, self);
    dialog.SetDateOnDisk(FileAge(dialogFile));

    SetLength(self.dialogs, Length(self.dialogs) + 1);
    self.dialogs[High(self.dialogs)] := dialog;
  end;
end;

function TItemCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  dialog: TItem;
  dialogCandidate: TItem;
begin
  dialog := nil;

  for dialogCandidate in dialogs do
      if dialogCandidate.GetName() = name then
      begin
        dialog := dialogCandidate;
        Break;
      end;

  if dialog <> nil then
  begin
    dialog.SetDateInDB(date);
    Exit(dialog);
  end;

  dialog := TItem.Create(name, self);
  dialog.SetDateInDB(date);

  SetLength(self.dialogs, Length(self.dialogs) + 1);
  self.dialogs[High(self.dialogs)] := dialog;

  Result := dialog;
end;

function TItemCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.dialogs));

  for i := 0 to High(self.dialogs) do
      Result[i] := self.dialogs[i];
end;


initialization
begin
  TItemData.dataList := TItemDataList.Create;
end;

end.

