unit TramQuestAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TQuestCollection = class;
  TQuest = class(TAssetMetadata)
  public
      constructor Create(questName: string; collection: TQuestCollection);
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

  TQuestCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     quests: array of TQuest;
  end;

implementation

constructor TQuest.Create(questName: string; collection: TQuestCollection);
begin
  self.name := questName;
  self.parent := collection;
end;

function TQuest.GetType: string;
begin
  Result := 'QUEST';
end;

function TQuest.GetPath: string;
begin
  Result := 'data/' + name + '.quest';
end;

procedure TQuest.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TQuest.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TQuest.SetMetadata(const prop: string; value: Variant);
begin

end;
function TQuest.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TQuest.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TQuest.LoadMetadata();
begin

end;


constructor TQuestCollection.Create;
begin

end;

procedure TQuestCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(quests) do
      if quests[index] = asset then
         Break;
  if quests[index] <> asset then Exit;
  for index := index to High(quests) - 1 do
      quests[index] := quests[index  + 1];
  SetLength(quests, Length(quests) - 1);
end;

procedure TQuestCollection.Clear;
var
  quest: TQuest;
begin
  for quest in self.quests do quest.Free;
  SetLength(quests, 0);
end;

procedure TQuestCollection.ScanFromDisk;
var
  files: TStringList;
  questFile: string;
  questName: string;
  quest: TQuest;
  questCandidate: TQuest;
begin
  files := FindAllFiles('data/', '*.quest', true);

  for quest in quests do
      quest.SetDateOnDisk(0);

  for questFile in files do
  begin
    quest := nil;

    // extract asset name from Sprite
    questName := questFile.Replace('\', '/');
    questName := questName.Replace('data/', '');

    questName := questName.Replace('.quest', '');

    // check if quest already exists in database
    for questCandidate in quests do
      if questCandidate.GetName() = questName then
      begin
        quest := questCandidate;
        Break;
      end;

    // if exists, update date on disk
    if quest <> nil then
    begin
      quest.SetDateOnDisk(FileAge(questFile));
      Continue;
    end;

    // otherwise add it to database
    quest := TQuest.Create( questName, self);
    quest.SetDateOnDisk(FileAge(questFile));

    SetLength(self.quests, Length(self.quests) + 1);
    self.quests[High(self.quests)] := quest;
  end;
end;

function TQuestCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  quest: TQuest;
  questCandidate: TQuest;
begin
  quest := nil;

  for questCandidate in quests do
      if questCandidate.GetName() = name then
      begin
        quest := questCandidate;
        Break;
      end;

  if quest <> nil then
  begin
    quest.SetDateInDB(date);
    Exit(quest);
  end;

  quest := TQuest.Create(name, self);
  quest.SetDateInDB(date);

  SetLength(self.quests, Length(self.quests) + 1);
  self.quests[High(self.quests)] := quest;

  Result := quest;
end;

function TQuestCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.quests));

  for i := 0 to High(self.quests) do
      Result[i] := self.quests[i];
end;

end.

