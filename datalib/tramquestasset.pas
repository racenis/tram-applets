unit TramQuestAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser, TramAssetWriter, fgl;

type
  TQuest = class;
  TQuestData = class;
  TQuestDataList = specialize TFPGList<TQuestData>;

  TQuestVariable = class
  public
     name: string;
     variableType: string;

     valueType: string;
     value: string;
     valueQuest: string;

     targetQuest: string;
     targetVariable: string;

     objectiveSubtitle: string;
     objectiveState: string;
  end;
  TQuestVariableList = specialize TFPGList<TQuestVariable>;

  TQuestTrigger = class
  public
     name: string;                // name of the trigger

     conditionQuest: string;      // quest that contains the condition variable
     conditionVariable: string;   // variable that evals to 'bool'

     triggerType: string;         // type of trigger, e.g. 'set-variable'
     triggerTarget: string;       // depends on type

     valueType: string;           // 'int', 'bool', 'name', etc.
     valueQuest: string;          // used if valueType = 'var'
     value: string;               // value, as a string

  end;
  TQuestTriggerList = specialize TFPGList<TQuestTrigger>;

  TQuestData = class
  public
     constructor Create;
  public
     name: string;
     parent: TQuest;

     variables: TQuestVariableList;
     triggers: TQuestTriggerList;

     dataList: TQuestDataList; static;
  end;



  TQuestCollection = class;
  TQuest = class(TAssetMetadata)
  public
      constructor Create(questName: string; collection: TQuestCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function IsProcessable: Boolean; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
      procedure LoadFromDisk(); override;

      procedure SaveToDisk; override;
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

function TQuest.IsProcessable: Boolean;
begin
  Result := False;
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

procedure TQuest.LoadFromDisk();
var
   assetFile: TAssetParser;
   rowIndex: Integer;
   prevQuest: TQuestData;
   newVariable: TQuestVariable;
   newTrigger: TQuestTrigger;
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

  if assetFile.GetValue(0, 0) <> 'QUESTv1' then
  begin
    WriteLn('INCORRECT HEADER!!!');
    Exit;
  end;

  // if quest -> new quest
  // remember pointer
  // if var -> new var and parse it
  // like that..

  for rowIndex := 1 to assetFile.GetRowCount - 1 do
  case assetFile.GetValue(rowIndex, 0) of
       //case '':
       'quest': begin
         prevQuest := TQuestData.Create;
         TQuestData.dataList.Add(prevQuest);

         prevQuest.name := assetFile.GetValue(rowIndex, 1);
         prevQuest.parent := self;
       end;

       'variable': begin
         newVariable := TQuestVariable.Create;

         newVariable.name := assetFile.GetValue(rowIndex, 1);
         newVariable.variableType := assetFile.GetValue(rowIndex, 2);


         case newVariable.variableType of
              'value': begin
                 newVariable.valueType := assetFile.GetValue(rowIndex, 3);
                 newVariable.value := assetFile.GetValue(rowIndex, 4);
               end;

              'objective': begin
                 newVariable.value := assetFile.GetValue(rowIndex, 3);
                 newVariable.objectiveSubtitle := assetFile.GetValue(rowIndex, 4);
                 newVariable.objectiveState := assetFile.GetValue(rowIndex, 5);
               end;

              'script': begin
                 newVariable.value := assetFile.GetValue(rowIndex, 3);
               end;

              else begin

                WriteLn( newVariable.variableType);

                newVariable.targetQuest := assetFile.GetValue(rowIndex, 3);
                newVariable.targetVariable := assetFile.GetValue(rowIndex, 4);

                if newVariable.variableType <> 'not' then begin
                  newVariable.valueType := assetFile.GetValue(rowIndex, 5);

                  if newVariable.valueType = 'var' then begin
                    newVariable.valueQuest := assetFile.GetValue(rowIndex, 6);
                    newVariable.value := assetFile.GetValue(rowIndex, 7);
                  end else begin
                    newVariable.value := assetFile.GetValue(rowIndex, 6);
                  end;
                end;

              end;
         end;


         prevQuest.variables.Add(newVariable);
       end;

       'trigger': begin
         newTrigger := TQuestTrigger.Create;

         newTrigger.name := assetFile.GetValue(rowIndex, 1);
         newTrigger.conditionQuest := assetFile.GetValue(rowIndex, 2);
         newTrigger.conditionVariable := assetFile.GetValue(rowIndex, 3);

         newTrigger.triggerType := assetFile.GetValue(rowIndex, 4);
         newTrigger.triggerTarget := assetFile.GetValue(rowIndex, 5);

         case newTrigger.triggerType of
              'set-objective': newTrigger.value := assetFile.GetValue(rowIndex, 6);
              'set-variable': begin
                newTrigger.valueType := assetFile.GetValue(rowIndex, 6);

                if newTrigger.valueType = 'var' then begin
                  //newTrigger.valueQuest := assetFile.GetValue(rowIndex, 7);
                  newTrigger.valueQuest := prevQuest.name;
                  newTrigger.value := assetFile.GetValue(rowIndex, 7);
                end else begin
                  newTrigger.value := assetFile.GetValue(rowIndex, 7);
                end;
              end;
         end;

         prevQuest.triggers.Add(newTrigger);
       end
       else WriteLn('What is this:', assetFile.GetValue(rowIndex, 0));


  end;
  //begin
   // WriteLn(assetFile.GetValue(rowIndex, 0));
  //end;



end;

function NoneIfBlank(param: string): string;
begin
  Result := param.Trim;
  if Result = '' then Result := 'none';
end;

procedure TQuest.SaveToDisk();
var
  output: TAssetWriter;
  quest: TQuestData;

  variable: TQuestVariable;
  trigger: TQuestTrigger;

  line: TStringArray;

  typeAsString: string;
  nextTopic: string;
begin
  output := TAssetWriter.Create(GetPath);

  output.Append(['# Tramway SDK Kitchensink Quest File']);
  output.Append(['# Generated by: Kitchensink Editor v0.1.0']);
  output.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  output.Append(nil);

  output.Append(['QUESTv1']);
  output.Append(nil);

  for quest in TQuestData.dataList do begin
    if quest.parent <> self then Continue;

    output.Append(['quest', quest.name]);

    for variable in quest.variables do begin
      line := ['variable', variable.name, variable.variableType, '', '', '', ''];

      case variable.variableType of
           'value': begin
             line[3] := variable.valueType;
             line[4] := variable.value;
           end;

           'objective': begin
             line[3] := variable.value;
             line[4] := variable.objectiveSubtitle;
             line[5] := variable.objectiveState;
           end;

           'script': begin
             line[3] := variable.value;
           end;

           else begin
             line[3] := variable.targetQuest;
             line[4] := variable.targetVariable;

             if variable.variableType <> 'not' then begin
               line[5] := variable.valueType;

               if variable.valueType = 'var' then begin
                 line[6] := variable.valueQuest;
                 line[7] := variable.value;
               end else begin
                 line[6] := variable.value;
               end;
             end;

           end;
      end;

      output.Append(line);
    end;


    for trigger in quest.triggers do begin

      line := ['trigger',
               trigger.name,
               NoneIfBlank(trigger.conditionQuest),
               NoneIfBlank(trigger.conditionVariable),
               NoneIfBlank(trigger.triggerType),
               NoneIfBlank(trigger.triggerTarget),
               '',
               ''
      ];

      case trigger.triggerType of
           'set-objective': line[6] := trigger.value;
           'set-variable': begin
             line[6] := trigger.valueType;

             if trigger.valueType = 'var' then begin
               line[7] := trigger.value;
             end else begin
               line[7] := trigger.value;
             end;
           end;
      end;

      output.Append(line);
    end;

  end;

  output.Free;
end;

constructor TQuestData.Create;
begin
  variables := TQuestVariableList.Create;
  triggers := TQuestTriggerList.Create;
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

initialization
begin
  TQuestData.dataList := TQuestDataList.Create;
end;

end.

