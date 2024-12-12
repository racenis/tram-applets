unit TramDialogAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser, fgl;

type
  TDialog = class;
  TDialogTopic = class;
  TDialogTopicList = specialize TFPGList<TDialogTopic>;
  TDialogTopicType = (dialogTopic, dialogSingle, dialogMulti);
  TDialogTopic = class
  public
     constructor Create;
  public
    name: string;
    dialogType: TDialogTopicType;
    prompt: string;
    answer: string;

    conditionQuest: string;
    conditionVariable: string;

    triggerQuest: string;
    triggerTrigger: string;

    //nextTopics: TStringArray;
    nextTopics: TStringList;

    parent: TDialog;

    dataList: TDialogTopicList; static;
  end;

  TDialogCollection = class;
  TDialog = class(TAssetMetadata)
  public
      constructor Create(dialogName: string; collection: TDialogCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
      procedure LoadFromDisk(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected

  end;

  TDialogCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     dialogs: array of TDialog;
  end;

implementation

constructor TDialogTopic.Create;
begin
  self.nextTopics := TStringList.Create;
end;

constructor TDialog.Create(dialogName: string; collection: TDialogCollection);
begin
  self.name := dialogName;
  self.parent := collection;
end;

function TDialog.GetType: string;
begin
  Result := 'DIALOG';
end;

function TDialog.GetPath: string;
begin
  Result := 'data/' + name + '.dialog';
end;

procedure TDialog.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TDialog.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TDialog.SetMetadata(const prop: string; value: Variant);
begin

end;
function TDialog.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TDialog.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TDialog.LoadMetadata();
begin

end;

procedure TDialog.LoadFromDisk();
var
  assetFile: TAssetParser;
  rowIndex: Integer;
  topic: TDialogTopic;
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

  if assetFile.GetValue(0, 0) <> 'DIALOGv1' then
  begin
    WriteLn('INCORRECT HEADER!!!');
    Exit;
  end;

  for rowIndex := 1 to assetFile.GetRowCount - 1 do
  case assetFile.GetValue(rowIndex, 0) of
    'dialog': begin
      topic := TDialogTopic.Create;

      case assetFile.GetValue(rowIndex, 1) of
        'import-single': topic.dialogType := dialogSingle;
        'import-multiple': topic.dialogType := dialogMulti;
        else topic.dialogType := dialogTopic;
      end;

      topic.name := assetFile.GetValue(rowIndex, 2);
      topic.prompt := assetFile.GetValue(rowIndex, 3);
      topic.answer := assetFile.GetValue(rowIndex, 4);

      topic.parent := self;

      TDialogTopic.dataList.Add(topic);
    end;
    'next': begin
      for topic in TDialogTopic.dataList do
          if topic.name = assetFile.GetValue(rowIndex, 1) then begin
            topic.nextTopics.Add(assetFile.GetValue(rowIndex, 2));
            //SetLength(topic.nextTopics, Length(topic.nextTopics) + 1);
            //topic.nextTopics[High(topic.nextTopics)] := assetFile.GetValue(rowIndex, 2);
          end;
    end;
    else WriteLn(assetFile.GetValue(rowIndex, 0));
  end;
end;

constructor TDialogCollection.Create;
begin

end;

procedure TDialogCollection.Remove(asset: TAssetMetadata);
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

procedure TDialogCollection.Clear;
var
  dialog: TDialog;
begin
  for dialog in self.dialogs do dialog.Free;
  SetLength(dialogs, 0);
end;

procedure TDialogCollection.ScanFromDisk;
var
  files: TStringList;
  dialogFile: string;
  dialogName: string;
  dialog: TDialog;
  dialogCandidate: TDialog;
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
    dialog := TDialog.Create( dialogName, self);
    dialog.SetDateOnDisk(FileAge(dialogFile));

    SetLength(self.dialogs, Length(self.dialogs) + 1);
    self.dialogs[High(self.dialogs)] := dialog;
  end;
end;

function TDialogCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  dialog: TDialog;
  dialogCandidate: TDialog;
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

  dialog := TDialog.Create(name, self);
  dialog.SetDateInDB(date);

  SetLength(self.dialogs, Length(self.dialogs) + 1);
  self.dialogs[High(self.dialogs)] := dialog;

  Result := dialog;
end;

function TDialogCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.dialogs));

  for i := 0 to High(self.dialogs) do
      Result[i] := self.dialogs[i];
end;


initialization
begin
  TDialogTopic.dataList := TDialogTopicList.Create;
end;

end.

