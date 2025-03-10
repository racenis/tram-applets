unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  StdCtrls, ExtCtrls, Spin, EditBtn,

  TramAssetParser, TramAssetWriter, TramAssetMetadata, Tram3DModelAsset,
  TramWorldCellAsset, TramDialogAsset, TramQuestAsset, TramLanguageAsset,
  TramItemAsset

  ;

type

  { TMainForm }

  TMainForm = class(TForm)
    GeneralTabCompartementAddNew: TButton;
    GeneralTabCompartementDelete: TButton;
    GeneralTabInventorySlotAddNew: TButton;
    GeneralTabInventorySlotDelete: TButton;
    GeneralTabAttributeAddNew: TButton;
    GeneralTabAttributeDelete: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    FactionTabFilterDisposition: TCheckBox;
    DialogTabNextAdd: TButton;
    DialogTabNextRemove: TButton;
    DialogTabType: TComboBox;
    DialogTabConditionQuest: TComboBox;
    DialogTabConditionVariable: TComboBox;
    DialogTabTriggerQuest: TComboBox;
    DialogTabTriggerName: TComboBox;
    DialogTabName: TEdit;
    DialogTabPrompt: TEdit;
    DialogTabAnswer: TEdit;
    DialogTabNextSelectFilter: TEdit;
    DialogTabGeneral: TGroupBox;
    DialogTabStrings: TGroupBox;
    DialogTabCondition: TGroupBox;
    DialogTabTrigger: TGroupBox;
    DialogTabNextTopics: TGroupBox;
    FactionTabSelectFilter: TEdit;
    FactionTabName: TEdit;
    GenerealTabCompartments: TGroupBox;
    GenerealTabInventorySlots: TGroupBox;
    GeneralTabAttributes: TGroupBox;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    DialogTabNextSelect: TListBox;
    DialogTabNextList: TListBox;
    Label48: TLabel;
    Label49: TLabel;
    FactionTabSelect: TListBox;
    GeneralTabCompartmentSelect: TListBox;
    GeneralTabInventorySlotSelect: TListBox;
    GeneralTabAttributeSelect: TListBox;
    Label50: TLabel;
    Label51: TLabel;
    QuestTabObjectiveName: TEdit;
    QuestTabObjectiveState: TComboBox;
    QuestTabTriggerConditionVariable: TComboBox;
    QuestTabTriggerValue: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    QuestTabTriggerList: TListBox;
    QuestTabObjectiveAddNew: TButton;
    QuestTabObjectiveDelete: TButton;
    QuestTabTriggerTarget: TComboBox;
    QuestTabTriggerType: TComboBox;
    QuestTabVariableAddNew: TButton;
    QuestTabTriggerAddNew: TButton;
    QuestTabVariableDelete: TButton;
    QuestTabTriggerDelete: TButton;
    QuestTabTriggerName: TEdit;
    QuestTabTriggerConditionQuest: TComboBox;
    QuestTabVariableValueBool: TCheckBox;
    ClassTabAddBaseClass: TButton;
    ClassTabDeleteBaseClass: TButton;
    ClassTabFactionAdd: TButton;
    ClassTabFactionRemove: TButton;
    ClassTabAddAttribute: TButton;
    ClassTabDeleteAttribute: TButton;
    ClassTabOverride: TCheckBox;
    ClassTabGeneralGroup: TGroupBox;
    ClassTabFactionGroup: TGroupBox;
    ClassTabBaseClassGroup: TGroupBox;
    ClassTabAttributeGroup: TGroupBox;
    ClassTabBaseSelect: TComboBox;
    ClassTabFactionSelect: TComboBox;
    ClassTabAttributeSelect: TComboBox;
    ClassTabClassName: TEdit;
    ClassTabFactionLoyalty: TFloatSpinEdit;
    ClassTabFactionRank: TFloatSpinEdit;
    ClassTabAttributeValue: TFloatSpinEdit;
    CharacterTabGeneral: TGroupBox;
    CharacterTabFactions: TGroupBox;
    CharacterTabDispositions: TGroupBox;
    CharacterTabAttributes: TGroupBox;
    CharacterTabInventory: TGroupBox;
    CharacterTabAIPackages: TGroupBox;
    ClassTabAIPackages: TGroupBox;
    QuestTabVariableType: TComboBox;
    QuestTabVariableQuest: TComboBox;
    QuestTabVariableVariable: TComboBox;
    QuestTabObjectiveTitle: TEdit;
    QuestTabObjectiveSubtitle: TEdit;
    QuestTabGeneralName: TEdit;
    QuestTabVariableName: TEdit;
    QuestTabVariableValueString: TEdit;
    FactionTabGeneral: TGroupBox;
    FactionTabRelations: TGroupBox;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    QuestTabObjectiveList: TListBox;
    QuestTabVariableList: TListBox;
    QuestsTabGeneral: TGroupBox;
    QuestsTabStages: TGroupBox;
    QuestsTabVariables: TGroupBox;
    QuestsTabTriggers: TGroupBox;
    ItemTabDeleteItem1: TButton;
    ItemTabDeleteItem2: TButton;
    ClassTabeDeleteClass: TButton;
    ItemTabDeleteItem4: TButton;
    ItemTabDeleteItem5: TButton;
    QuestTabDeleteItem: TButton;
    DialogTabDeleteItem: TButton;
    ItemTabFile1: TComboBox;
    ItemTabFile2: TComboBox;
    ClassTabFile: TComboBox;
    ItemTabFile4: TComboBox;
    ItemTabFile5: TComboBox;
    QuestTabFile: TComboBox;
    DialogTabFile: TComboBox;
    ItemTabItemList1: TListBox;
    ItemTabItemList2: TListBox;
    ClassTabClassList: TListBox;
    ItemTabItemList4: TListBox;
    ItemTabItemList5: TListBox;
    QuestTabItemList: TListBox;
    DialogTabItemList: TListBox;
    ItemTabNewItem: TButton;
    ItemTabDeleteItem: TButton;
    ItemTabNewAttribute: TButton;
    ItemTabDeleteAttribute: TButton;
    ItemTabBaseClass: TComboBox;
    ItemTabItemCompartment: TComboBox;
    ItemTabNewItem1: TButton;
    ItemTabNewItem2: TButton;
    ClassTabNewClass: TButton;
    ItemTabNewItem4: TButton;
    ItemTabNewItem5: TButton;
    QuestTabNewItem: TButton;
    DialogTabNewItem: TButton;
    ItemTabSearchItem1: TEdit;
    ItemTabSearchItem2: TEdit;
    ClassTabSearchClass: TEdit;
    ItemTabSearchItem4: TEdit;
    ItemTabSearchItem5: TEdit;
    QuestTabSearchItem: TEdit;
    DialogTabSearchTopic: TEdit;
    ItemTabViewmodel: TComboBox;
    ItemTabWorldmodel: TComboBox;
    ItemTabEquipmentSlot: TComboBox;
    ItemTabSprite: TComboBox;
    ItemTabIcon: TComboBox;
    ItemTabFile: TComboBox;
    ItemTabAttribute: TComboBox;
    ItemTabEffectType: TComboBox;
    ItemTabSearchItem: TEdit;
    ItemTabClassName: TEdit;
    ItemTabEffectTag: TEdit;
    ItemTabEffectName: TEdit;
    ItemTabAttributeValue: TFloatSpinEdit;
    ItemTabEffectDuration: TFloatSpinEdit;
    ItemTabItemWeight: TFloatSpinEdit;
    ItemTabAttributeEffectGroup: TGroupBox;
    ItemTabLayoutGroup: TGroupBox;
    ItemTabGeneralGroup: TGroupBox;
    ItemTab2DGroup: TGroupBox;
    ItemTab3DGroup: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ItemTabItemList: TListBox;
    ItemTabAttributeList: TListBox;
    ClassTabBaseList: TListBox;
    ClassTabAttributeList: TListBox;
    ClassTabFactionList: TListView;
    MainMenu: TMainMenu;
    MenuItemAbout: TMenuItem;
    MenuItemHelp: TMenuItem;
    MenuItemGetHelp: TMenuItem;
    MenuItemQuit: TMenuItem;
    MenuItemNewCharacter: TMenuItem;
    MenuItemNewItem: TMenuItem;
    MenuItemNewDialog: TMenuItem;
    MenuItemNewQuest: TMenuItem;
    MenuItemFile: TMenuItem;
    ItemTabAttributeRadio: TRadioButton;
    ItemTabEffectRadio: TRadioButton;
    ItemTabAttributeEffectSwitch: TRadioGroup;
    ItemTabSpriteFrame: TSpinEdit;
    ItemTabIconFrame: TSpinEdit;
    ItemTabItemWidth: TSpinEdit;
    ItemTabItemHeight: TSpinEdit;
    ItemTabItemStack: TSpinEdit;
    MenuItemLoadDatabase: TMenuItem;
    MenuItemSaveFiles: TMenuItem;
    QuestTabVariableRadioInt: TRadioButton;
    QuestTabVariableRadioFloat: TRadioButton;
    QuestTabVariableRadioBoolean: TRadioButton;
    QuestTabVariableRadioName: TRadioButton;
    QuestTabTriggerRadioInt: TRadioButton;
    QuestTabTriggerRadioFloat: TRadioButton;
    QuestTabTriggerRadioBoolean: TRadioButton;
    QuestTabTriggerRadioName: TRadioButton;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    FactionTabDisposition: TSpinEdit;
    Tabs: TPageControl;
    GeneralTab: TTabSheet;
    ItemTab: TTabSheet;
    DropTableTab: TTabSheet;
    CharacterTab: TTabSheet;
    ClassTab: TTabSheet;
    FactionTab: TTabSheet;
    AIPackageTab: TTabSheet;
    QuestTab: TTabSheet;
    DialogTab: TTabSheet;
    procedure DialogTabAnswerEditingDone(Sender: TObject);
    procedure DialogTabConditionQuestEditingDone(Sender: TObject);
    procedure DialogTabConditionVariableEditingDone(Sender: TObject);
    procedure DialogTabDeleteItemClick(Sender: TObject);
    procedure DialogTabFileChange(Sender: TObject);
    procedure DialogTabItemListClick(Sender: TObject);
    procedure DialogTabNameEditingDone(Sender: TObject);
    procedure DialogTabNewItemClick(Sender: TObject);
    procedure DialogTabNextAddClick(Sender: TObject);
    procedure DialogTabNextListDblClick(Sender: TObject);
    procedure DialogTabNextRemoveClick(Sender: TObject);
    procedure DialogTabNextSelectFilterChange(Sender: TObject);
    procedure DialogTabPromptEditingDone(Sender: TObject);
    procedure DialogTabSearchTopicChange(Sender: TObject);
    procedure DialogTabTriggerNameEditingDone(Sender: TObject);
    procedure DialogTabTriggerQuestEditingDone(Sender: TObject);
    procedure DialogTabTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ItemTabAttributeChange(Sender: TObject);
    procedure ItemTabAttributeListClick(Sender: TObject);
    procedure ItemTabAttributeRadioChange(Sender: TObject);
    procedure ItemTabAttributeEditingDone(Sender: TObject);
    procedure ItemTabClassNameChange(Sender: TObject);
    procedure ItemTabDeleteItemClick(Sender: TObject);
    procedure ItemTabEffectRadioChange(Sender: TObject);
    procedure ItemTabFieldChange(Sender: TObject);
    procedure ItemTabFileChange(Sender: TObject);
    procedure ItemTabItemListClick(Sender: TObject);
    procedure ItemTabNewAttributeClick(Sender: TObject);
    procedure ItemTabNewItemClick(Sender: TObject);
    procedure MenuItemNewDialogClick(Sender: TObject);
    procedure MenuItemNewItemClick(Sender: TObject);
    procedure MenuItemNewQuestClick(Sender: TObject);
    procedure MenuItemQuitClick(Sender: TObject);
    procedure MenuItemSaveFilesClick(Sender: TObject);
    procedure QuestTabDeleteItemClick(Sender: TObject);
    procedure QuestTabFileChange(Sender: TObject);
    procedure QuestTabGeneralNameEditingDone(Sender: TObject);
    procedure QuestTabNewItemClick(Sender: TObject);
    procedure QuestTabObjectiveAddNewClick(Sender: TObject);
    procedure QuestTabObjectiveDeleteClick(Sender: TObject);
    procedure QuestTabObjectiveListClick(Sender: TObject);
    procedure QuestTabObjectiveNameEditingDone(Sender: TObject);
    procedure QuestTabObjectiveStateEditingDone(Sender: TObject);
    procedure QuestTabObjectiveSubtitleEditingDone(Sender: TObject);
    procedure QuestTabObjectiveTitleEditingDone(Sender: TObject);
    procedure QuestTabTriggerConditionQuestEditingDone(Sender: TObject);
    procedure QuestTabTriggerConditionVariableEditingDone(Sender: TObject);
    procedure QuestTabTriggerDeleteClick(Sender: TObject);
    procedure QuestTabTriggerNameEditingDone(Sender: TObject);
    procedure QuestTabTriggerRadioChange(Sender: TObject);
    procedure QuestTabTriggerRecheck;
    procedure QuestTabTriggerAddNewClick(Sender: TObject);
    procedure QuestTabTriggerListClick(Sender: TObject);
    procedure QuestTabTriggerTargetEditingDone(Sender: TObject);
    procedure QuestTabTriggerTypeEditingDone(Sender: TObject);
    procedure QuestTabTriggerValueEditingDone(Sender: TObject);
    procedure QuestTabVariableDeleteClick(Sender: TObject);
    procedure QuestTabVariableNameEditingDone(Sender: TObject);
    procedure QuestTabVariableQuestEditingDone(Sender: TObject);
    procedure QuestTabVariableRadioChange(Sender: TObject);
    procedure QuestTabVariableRecheck;
    procedure QuestTabVariableAddNewClick(Sender: TObject);
    procedure QuestTabVariableListClick(Sender: TObject);
    procedure QuestTabVariableTypeEditingDone(Sender: TObject);
    procedure QuestTabVariableValueStringEditingDone(Sender: TObject);
    procedure QuestTabVariableVariableEditingDone(Sender: TObject);
    procedure RefrshAllFileLists;
    procedure QuestTabRefreshList;
    procedure QuestTabRefresh;
    procedure QuestTabRefreshObjective;
    procedure QuestTabRefreshVariable;
    procedure QuestTabRefreshTrigger;
    procedure DialogTabRefreshList;
    procedure DialogTabRefresh;
    procedure DialogTabRefreshNextSelect;
    procedure DialogTabRefreshCondition;
    procedure DialogTabRefreshTrigger;
    procedure ItemTabRefreshList;
    procedure ItemTabRefresh;
    procedure ItemTabRefreshAttributes;
    procedure ItemTabRefreshEffect;
    procedure ItemTabDeleteAttributeClick(Sender: TObject);
    procedure QuestTabItemListClick(Sender: TObject);
    procedure MenuItemLoadDatabaseClick(Sender: TObject);
    procedure TabsChange(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;
  questCollection: TQuestCollection;
  dialogCollection: TDialogCollection;
  itemCollection: TItemCollection;

  selectedQuest: TQuestData;
  selectedVariable: TQuestVariable;
  selectedObjective: TQuestVariable;
  selectedTrigger: TQuestTrigger;
  selectedItem: TItemData;
  selectedEffect: TItemAttributeEffect;

  selectedTopic: TDialogTopic;

implementation

{$R *.lfm}

{ TMainForm }

procedure LoadAllFilesAndStuff();
var
  asset: TAssetMetadata;
begin
  questCollection.ScanFromDisk;

  for asset in questCollection.GetAssets do begin
      asset.LoadFromDisk;
      MainForm.QuestTabFile.AddItem(asset.GetName, asset);
  end;

  dialogCollection.ScanFromDisk;

  for asset in dialogCollection.GetAssets do begin
      asset.LoadFromDisk;
      MainForm.DialogTabFile.AddItem(asset.GetName, asset);
  end;

  itemCollection.ScanFromDisk;

  for asset in itemCollection.GetAssets do begin
      asset.LoadFromDisk;
      MainForm.ItemTabFile.AddItem(asset.GetName, asset);
  end;

  //MainForm.QuestTabRefreshList;
end;

procedure RefrshAllFileLists;
begin

end;

procedure TMainForm.ItemTabDeleteAttributeClick(Sender: TObject);
begin
  if selectedEffect = nil then begin
    ShowMessage('Select an attribute before removing it!');
    Exit;
  end;

  if MessageDlg('Removing attribute/effect', 'Do you want to remove '
                + selectedEffect.attributeType + ' from ' + selectedItem.name
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    selectedItem.effects.Remove(selectedEffect);
    selectedEffect := nil;

    ItemTabRefresh;
    ItemTabRefreshEffect;
  end;
end;

procedure TMainForm.QuestTabRefreshList;
var
  asset: TAssetMetadata;
  quest: TQuestData;
begin
  QuestTabItemList.Clear;
  QuestTabItemList.ClearSelection;

  for quest in TQuestData.dataList do
      if (QuestTabFile.Items.Objects[QuestTabFile.ItemIndex] as TQuest) = quest.parent then
         QuestTabItemList.AddItem(quest.name, quest);


end;

procedure TMainForm.QuestTabRefresh;
var
  variable: TQuestVariable;
  trigger: TQuestTrigger;
begin
  if selectedQuest = nil then begin
    selectedVariable := nil;
    selectedObjective := nil;
    selectedTrigger := nil;

    QuestTabRefreshVariable;
    QuestTabRefreshObjective;
    QuestTabRefreshTrigger;

    Exit;
  end;

  QuestTabGeneralName.Text:= selectedQuest.name;

  QuestTabObjectiveList.Clear;
  QuestTabVariableList.Clear;
  QuestTabTriggerList.Clear;

  for variable in selectedQuest.variables do
      WriteLn('VarTYpe:', variable.variableType);

  for variable in selectedQuest.variables do
      if variable.variableType = 'objective' then
         QuestTabObjectiveList.AddItem(variable.name, variable)
      else
          QuestTabVariableList.AddItem(variable.name, variable);

  for trigger in selectedQuest.triggers do
      QuestTabTriggerList.AddItem(trigger.name, trigger);
end;

procedure TMainForm.QuestTabRefreshObjective;
begin
  QuestTabObjectiveName.Enabled := selectedObjective <> nil;
  QuestTabObjectiveTitle.Enabled := selectedObjective <> nil;
  QuestTabObjectiveSubtitle.Enabled := selectedObjective <> nil;
  QuestTabObjectiveState.Enabled := selectedObjective <> nil;

  if selectedObjective = nil then begin
    QuestTabObjectiveName.Text := 'No objective selected.';
    Exit;
  end;

  QuestTabObjectiveName.Text := selectedObjective.name;
  QuestTabObjectiveTitle.Text := selectedObjective.value;
  QuestTabObjectiveSubtitle.Text := selectedObjective.objectiveSubtitle;

  QuestTabObjectiveState.Text := selectedObjective.objectiveState;
end;

procedure TMainForm.QuestTabRefreshVariable;
var
  disableValueTypeSelect: Boolean;
  disableValueSelect: Boolean;
  disableQuestSelect: Boolean;

  candidateQuest: TQuestData;
  variableQuest: TQuestData;
  variableVariable: TQuestVariable;
begin
  QuestTabVariableName.Enabled := selectedVariable <> nil;
  QuestTabVariableType.Enabled := selectedVariable <> nil;
  QuestTabVariableQuest.Enabled := selectedVariable <> nil;
  QuestTabVariableVariable.Enabled := selectedVariable <> nil;
  QuestTabVariableValueString.Enabled := selectedVariable <> nil;
  QuestTabVariableRadioInt.Enabled := selectedVariable <> nil;
  QuestTabVariableRadioFloat.Enabled := selectedVariable <> nil;
  QuestTabVariableRadioBoolean.Enabled := selectedVariable <> nil;
  QuestTabVariableRadioName.Enabled := selectedVariable <> nil;

  if selectedVariable = nil then begin
    QuestTabVariableName.Text := 'No quest variable selected';
    Exit;
  end;

  QuestTabVariableName.Text := selectedVariable.name;
  QuestTabVariableType.Text := selectedVariable.variableType;
  QuestTabVariableQuest.Text := selectedVariable.targetQuest;
  QuestTabVariableVariable.Text := selectedVariable.targetVariable;
  QuestTabVariableValueString.Text := selectedVariable.value;

  case selectedVariable.valueType of
    'int': QuestTabVariableRadioInt.Checked := True;
    'float': QuestTabVariableRadioFloat.Checked := True;
    'bool': QuestTabVariableRadioBoolean.Checked := True;
    'name': QuestTabVariableRadioName.Checked := True;
  end;

  // setting up quest trigger variable dropdown
  QuestTabVariableQuest.Items.Clear;
  variableQuest := nil;
  for candidateQuest in TQuestData.dataList do begin
      if candidateQuest.name = QuestTabVariableQuest.Text then
         variableQuest := candidateQuest;
      QuestTabVariableQuest.AddItem(candidateQuest.name, candidateQuest);
  end;

  QuestTabVariableVariable.Items.Clear;
  if variableQuest <> nil then
     for variableVariable in variableQuest.variables do
         QuestTabVariableVariable.AddItem(variableVariable.name, variableVariable);



  // checking which controls need to be disabled for the variable's type
  disableValueTypeSelect := False;
  disableValueSelect := False;
  disableQuestSelect := False;

  case selectedVariable.variableType of
    'not': begin
        disableValueTypeSelect := True;
        disableValueSelect := True;
    end;
    'script': begin
        disableValueTypeSelect := True;
        disableQuestSelect := True;
    end;
    'value': begin
        disableQuestSelect := True;
    end;
  end;

  // applying the enables and disables of the controls

  // applying value type
  QuestTabVariableRadioInt.Enabled := not disableValueTypeSelect;
  QuestTabVariableRadioFloat.Enabled := not disableValueTypeSelect;
  QuestTabVariableRadioBoolean.Enabled := not disableValueTypeSelect;
  QuestTabVariableRadioName.Enabled := not disableValueTypeSelect;

  // applying value string
  QuestTabVariableValueString.Enabled := not disableValueSelect;

  if disableValueSelect then
     QuestTabVariableValueString.Text := 'Not applicable.';

  // applying quest
  QuestTabVariableQuest.Enabled := not disableQuestSelect;
  QuestTabVariableVariable.Enabled := not disableQuestSelect;

  if disableQuestSelect then begin
    QuestTabVariableQuest.Text := 'Not applicable.';
    QuestTabVariableVariable.Text := 'Not applicable.';
  end;
end;

procedure TMainForm.QuestTabRefreshTrigger;
var
  candidateQuest: TQuestData;
  conditionQuest: TQuestData;
  conditionVariable: TQuestVariable;
  targetVariable: TQuestVariable;
begin
  QuestTabTriggerName.Enabled := selectedTrigger <> nil;
  QuestTabTriggerConditionQuest.Enabled := selectedTrigger <> nil;
  QuestTabTriggerConditionVariable.Enabled := selectedTrigger <> nil;
  QuestTabTriggerTarget.Enabled := selectedTrigger <> nil;
  QuestTabTriggerType.Enabled := selectedTrigger <> nil;
  QuestTabTriggerValue.Enabled := selectedTrigger <> nil;
  QuestTabTriggerRadioInt.Enabled := selectedTrigger <> nil;
  QuestTabTriggerRadioFloat.Enabled := selectedTrigger <> nil;
  QuestTabTriggerRadioBoolean.Enabled := selectedTrigger <> nil;
  QuestTabTriggerRadioName.Enabled := selectedTrigger <> nil;

   if selectedTrigger = nil then begin
     QuestTabTriggerName.Text := 'No quest trigger selected';
     Exit;
   end;

  QuestTabTriggerName.Text := selectedTrigger.name;
  QuestTabTriggerConditionQuest.Text := selectedTrigger.conditionQuest;
  QuestTabTriggerConditionVariable.Text := selectedTrigger.conditionVariable;
  QuestTabTriggerType.Text := selectedTrigger.triggerType;
  QuestTabTriggerTarget.Text := selectedTrigger.triggerTarget;
  QuestTabTriggerValue.Text := selectedTrigger.value;


  // we don't actually need to reset the quest list here, we could reset it
  // only when new quests are added, removed or loaded.
  // but this will be simpler
  QuestTabTriggerConditionQuest.Items.Clear;
  conditionQuest := nil;
  for candidateQuest in TQuestData.dataList do begin
      if candidateQuest.name = QuestTabTriggerConditionQuest.Text then
         conditionQuest := candidateQuest;
      QuestTabTriggerConditionQuest.AddItem(candidateQuest.name, candidateQuest);
  end;

  QuestTabTriggerConditionVariable.Items.Clear;
  if conditionQuest <> nil then
     for conditionVariable in conditionQuest.variables do
         QuestTabTriggerConditionVariable.AddItem(conditionVariable.name, conditionVariable);


  QuestTabTriggerTarget.Items.Clear;
  case selectedTrigger.triggerType of
    'set-value', 'increment':
      for targetVariable in selectedQuest.variables do
          if targetVariable.variableType <> 'objective' then
             QuestTabTriggerTarget.AddItem(targetVariable.name, targetVariable);
    'set-objective':
      for targetVariable in selectedQuest.variables do
          if targetVariable.variableType = 'objective' then
             QuestTabTriggerTarget.AddItem(targetVariable.name, targetVariable);
  end;


  case selectedTrigger.valueType of
    'int': QuestTabTriggerRadioInt.Checked := True;
    'float': QuestTabTriggerRadioFloat.Checked := True;
    'bool': QuestTabTriggerRadioBoolean.Checked := True;
    'name': QuestTabTriggerRadioName.Checked := True;
  end;

  // RADIO BUTTONS
  case selectedTrigger.triggerType of
    'set-objective', 'increment': begin
        QuestTabTriggerRadioInt.Enabled := False;
        QuestTabTriggerRadioFloat.Enabled := False;
        QuestTabTriggerRadioBoolean.Enabled := False;
        QuestTabTriggerRadioName.Enabled := False;

        //QuestTabVariableValueString.Text := 'Not applicable.';
        //QuestTabVariableValueString.Enabled := False;
    end;
    else begin
        QuestTabTriggerRadioInt.Enabled := True;
        QuestTabTriggerRadioFloat.Enabled := True;
        QuestTabTriggerRadioBoolean.Enabled := True;
        QuestTabTriggerRadioName.Enabled := True;

        //QuestTabVariableValueString.Enabled := True;
    end;
  end;

  // TEXT FIELD
  case selectedTrigger.triggerType of
    'increment': begin
        QuestTabTriggerValue.Text := 'Not applicable.';
        QuestTabTriggerValue.Enabled := False;
    end;
    else begin
        QuestTabTriggerValue.Enabled := True;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadAllFilesAndStuff;

  QuestsTabGeneral.Enabled := False;
  QuestsTabStages.Enabled := False;
  QuestsTabVariables.Enabled := False;
  QuestsTabTriggers.Enabled := False;

  DialogTabGeneral.Enabled := False;
  DialogTabStrings.Enabled := False;
  DialogTabCondition.Enabled := False;
  DialogTabTrigger.Enabled := False;
  DialogTabNextTopics.Enabled := False;

  ItemTabRefresh;
end;

procedure TMainForm.ItemTabAttributeChange(Sender: TObject);
begin
  selectedEffect.attributeType := ItemTabAttribute.Text;
  ItemTabRefresh;
end;

procedure TMainForm.ItemTabAttributeListClick(Sender: TObject);
begin
  if ItemTabAttributeList.ItemIndex < 0 then begin
    selectedEffect := nil;
    Exit;
  end;

  selectedEffect := ItemTabAttributeList.Items.Objects[ItemTabAttributeList.ItemIndex] as TItemAttributeEffect;

  ItemTabRefreshEffect;
end;

procedure TMainForm.ItemTabAttributeRadioChange(Sender: TObject);
begin
  selectedEffect.recordType := itemAttribute;
  ItemTabRefreshEffect;
end;

procedure TMainForm.ItemTabAttributeEditingDone(Sender: TObject);
begin
  selectedEffect.value := ItemTabAttributeValue.Text;
  if selectedEffect.recordType = itemAttribute then Exit;
  selectedEffect.name := ItemTabEffectName.Text;
  selectedEffect.tag := ItemTabEffectTag.Text;
  selectedEffect.effectType := ItemTabEffectType.Text;
  selectedEffect.duration := ItemTabEffectDuration.Text;
end;

procedure TMainForm.ItemTabClassNameChange(Sender: TObject);
begin
  selectedItem.name := ItemTabClassName.Text;
  ItemTabRefreshList;
end;

procedure TMainForm.ItemTabRefreshList;
var
  asset: TAssetMetadata;
  item: TItemData;
begin
  ItemTabItemList.Clear;
  ItemTabItemList.ClearSelection;

  for item in TItemData.dataList do
      if (ItemTabFile.Items.Objects[ItemTabFile.ItemIndex] as TItem) = item.parent then
         ItemTabItemList.AddItem(item.name, item);
end;

procedure TMainForm.ItemTabRefresh;
var
  effect: TItemAttributeEffect;
  enable: Boolean;
begin

  enable := selectedItem <> nil;

  ItemTabGeneralGroup.Enabled := enable;
  ItemTab3DGroup.Enabled := enable;
  ItemTab2DGroup.Enabled := enable;
  ItemTabLayoutGroup.Enabled := enable;
  ItemTabAttributeEffectGroup.Enabled := enable;

  if selectedItem = nil then begin
    Exit;
  end;

  ItemTabClassName.Text := selectedItem.name;
  ItemTabBaseClass.Text := selectedItem.base;
  ItemTabEquipmentSlot.Text := selectedItem.equipmentSlot;

  ItemTabViewmodel.Text := selectedItem.viewmodel;
  ItemTabWorldmodel.Text := selectedItem.worldmodel;

  ItemTabSprite.Text := selectedItem.sprite;
  ItemTabSpriteFrame.Text := selectedItem.spriteFrame;
  ItemTabIcon.Text := selectedItem.icon;
  ItemTabIconFrame.Text := selectedItem.iconFrame;

  ItemTabItemWidth.Text := selectedItem.width;
  ItemTabItemHeight.Text := selectedItem.height;
  ItemTabItemStack.Text := selectedItem.stack;
  ItemTabItemWeight.Text := selectedItem.weight;
  ItemTabItemCompartment.Text := selectedItem.compartment;

  ItemTabAttributeList.Clear;
  for effect in selectedItem.effects do
      ItemTabAttributeList.AddItem(effect.attributeType, effect);
end;

procedure TMainForm.ItemTabRefreshAttributes;
var
  effect: TItemAttributeEffect;
begin
  ItemTabAttributeList.Clear;

  for effect in selectedItem.effects do
      ItemTabAttributeList.AddItem(effect.name, effect);
end;

procedure TMainForm.ItemTabDeleteItemClick(Sender: TObject);
begin
  if selectedItem = nil then begin
    ShowMessage('Select a item before removing it!');
    Exit;
  end;

  if MessageDlg('Removing item', 'Do you want to remove '
                + selectedItem.name + ' from ' + selectedItem.parent.GetName
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    TItemData.dataList.Remove(selectedItem);
    selectedItem := nil;
    selectedEffect := nil;

    ItemTabRefresh;
    ItemTabRefreshList;
  end;
end;

procedure TMainForm.ItemTabEffectRadioChange(Sender: TObject);
begin
  selectedEffect.recordType := itemEffect;
  ItemTabRefreshEffect;
end;

procedure TMainForm.ItemTabFieldChange(Sender: TObject);
begin
  selectedItem.base := ItemTabBaseClass.Text;
  selectedItem.equipmentSlot := ItemTabEquipmentSlot.Text;

  selectedItem.viewmodel := ItemTabViewmodel.Text;
  selectedItem.worldmodel := ItemTabWorldmodel.Text;

  selectedItem.sprite := ItemTabSprite.Text;
  selectedItem.spriteFrame := ItemTabSpriteFrame.Text;
  selectedItem.icon := ItemTabIcon.Text;
  selectedItem.iconFrame := ItemTabIconFrame.Text;

  selectedItem.width := ItemTabItemWidth.Text;
  selectedItem.height := ItemTabItemHeight.Text;
  selectedItem.stack := ItemTabItemStack.Text;
  selectedItem.weight := ItemTabItemWeight.Text;
  selectedItem.compartment := ItemTabItemCompartment.Text;
end;

procedure TMainForm.ItemTabFileChange(Sender: TObject);
begin
  ItemTabRefreshList;
end;

procedure TMainForm.ItemTabItemListClick(Sender: TObject);
begin
  if ItemTabItemList.ItemIndex < 0 then begin
    selectedItem := nil;
    selectedEffect := nil;

    ItemTabRefresh;
    ItemTabRefreshEffect;
    //QuestsTabGeneral.Enabled := False;
   // QuestsTabStages.Enabled := False;
    //QuestsTabVariables.Enabled := False;
    //QuestsTabTriggers.Enabled := False;

    Exit;
  end;


  selectedItem := ItemTabItemList.Items.Objects[ItemTabItemList.ItemIndex] as TItemData;
  selectedEffect := nil;

  //ItemTabGeneral.Enabled := True;
  //QuestsTabStages.Enabled := True;
  //QuestsTabVariables.Enabled := True;
  //QuestsTabTriggers.Enabled := True;


  ItemTabRefresh;
  ItemTabRefreshEffect;
end;

procedure TMainForm.ItemTabRefreshEffect;
begin
  if selectedEffect = nil then begin
    ItemTabAttribute.Enabled := False;
    ItemTabAttributeValue.Enabled := False;
    ItemTabEffectName.Enabled := False;
    ItemTabEffectTag.Enabled := False;
    ItemTabEffectType.Enabled := False;
    ItemTabEffectDuration.Enabled := False;
    ItemTabAttributeEffectSwitch.Enabled := False;

    Exit;
  end;

  ItemTabAttribute.Enabled := True;
  ItemTabAttributeValue.Enabled := True;
  ItemTabAttributeEffectSwitch.Enabled := True;

  ItemTabAttribute.Text := selectedEffect.attributeType;
  ItemTabAttributeValue.Text := selectedEffect.value;

  ItemTabEffectName.Enabled := selectedEffect.recordType = itemEffect;
  ItemTabEffectTag.Enabled := selectedEffect.recordType = itemEffect;
  ItemTabEffectType.Enabled := selectedEffect.recordType = itemEffect;
  ItemTabEffectDuration.Enabled := selectedEffect.recordType = itemEffect;

  //ItemTabAttributeRadio.Checked := selectedEffect.recordType = itemAttribute;
  //ItemTabEffectRadio.Checked := selectedEffect.recordType = itemEffect;

  if selectedEffect.recordType = itemAttribute then begin
    ItemTabEffectName.Text := 'Not applicable.';
    ItemTabEffectTag.Text := 'Not applicable.';
    ItemTabEffectType.Text := 'Not applicable.';
    ItemTabEffectDuration.Text := 'Not applicable.';

    ItemTabAttributeRadio.Checked := True;
  end else begin
    ItemTabEffectName.Text := selectedEffect.name;
    ItemTabEffectTag.Text := selectedEffect.tag;
    ItemTabEffectType.Text := selectedEffect.effectType;
    ItemTabEffectDuration.Text := selectedEffect.duration;

    ItemTabEffectRadio.Checked := True;
  end;


end;

procedure TMainForm.ItemTabNewAttributeClick(Sender: TObject);
begin
  selectedEffect := TItemAttributeEffect.Create;

  selectedEffect.attributeType := 'new-effect';
  selectedEffect.value := '';
  selectedEffect.recordType := itemAttribute;

  selectedItem.effects.Add(selectedEffect);
  ItemTabAttributeList.AddItem(selectedEffect.attributeType, selectedEffect);

  ItemTabRefreshEffect;
end;

procedure TMainForm.ItemTabNewItemClick(Sender: TObject);
var
  itemFile: TItem;
  newItem: TItemData;
  itemName: string;
begin
  if ItemTabFile.ItemIndex < 0 then begin
    ShowMessage('Select a Item file, then you can add a item to it!');
    Exit;
  end;

  itemFile := (ItemTabFile.Items.Objects[ItemTabFile.ItemIndex] as TItem);

  itemName := ItemTabSearchItem.Text;
  itemName := itemName.Trim;

  // TODO: add more validation (no spaces, unique, etc.)
  if itemName = '' then begin
    ShowMessage('Type in the quest name into the search box.'
                + 'This name will be used for the quest name.');
    Exit;
  end;

  newItem := TItemData.Create;
  newItem.name := itemName;
  newItem.parent := itemFile;

  TItemData.dataList.Add(newItem);

  selectedItem := newItem;
  ItemTabRefresh;

  ItemTabSearchItem.Text := '';
  ItemTabRefreshList;
end;

procedure TMainForm.MenuItemNewDialogClick(Sender: TObject);
var
  newAsset: TAssetMetadata;
  assetName: string;
begin
  // TODO: validate
  assetName := InputBox('Create New Dialog File', 'What to call it?', 'new-dialog');

  newAsset := dialogCollection.InsertFromDB(assetName, 0);
  DialogTabFile.AddItem(assetName, newAsset);
end;

procedure TMainForm.MenuItemNewItemClick(Sender: TObject);
var
  newAsset: TAssetMetadata;
  assetName: string;
begin
  // TODO: validate
  assetName := InputBox('Create New Item File', 'What to call it?', 'new-item');

  newAsset := itemCollection.InsertFromDB(assetName, 0);
  ItemTabFile.AddItem(assetName, newAsset);
end;

procedure TMainForm.MenuItemNewQuestClick(Sender: TObject);
var
  newAsset: TAssetMetadata;
  assetName: string;
begin
  // TODO: validate
  assetName := InputBox('Create New Quest File', 'What to call it?', 'new-quest');

  newAsset := questCollection.InsertFromDB(assetName, 0);
  QuestTabFile.AddItem(assetName, newAsset);
end;

procedure TMainForm.DialogTabRefreshList;
var
  topic: TDialogTopic;
begin
  DialogTabItemList.Clear;
  DialogTabItemList.ClearSelection;

  for topic in TDialogTopic.dataList do
      if (DialogTabFile.Items.Objects[DialogTabFile.ItemIndex] as TDialog) = topic.parent then
         if (DialogTabSearchTopic.Text = '') or topic.name.Contains(DialogTabSearchTopic.Text) then
            DialogTabItemList.AddItem(topic.name, topic);
end;

procedure TMainForm.DialogTabFileChange(Sender: TObject);
begin
  DialogTabRefreshList;
end;

procedure TMainForm.DialogTabRefresh;
var
  topic: TDialogTopic;
  nextTopic: string;
  hasNext: Boolean;
  quest: TQuestData;
begin
  DialogTabGeneral.Enabled := selectedTopic <> nil;
  DialogTabStrings.Enabled := selectedTopic <> nil;
  DialogTabCondition.Enabled := selectedTopic <> nil;
  DialogTabTrigger.Enabled := selectedTopic <> nil;
  DialogTabNextTopics.Enabled := selectedTopic <> nil;

  DialogTabNextSelectFilter.Text := '';

  if selectedTopic = nil then begin
    Exit;
  end;

  DialogTabStrings.Enabled := selectedTopic.dialogType = dialogTopic;

  case selectedTopic.dialogType of
    TDialogTopicType.dialogTopic: DialogTabType.Text := 'topic';
    TDialogTopicType.dialogSingle: DialogTabType.Text := 'import-single';
    TDialogTopicType.dialogMulti: DialogTabType.Text := 'import-multiple';
  end;

  DialogTabName.Text := selectedTopic.name;

  DialogTabPrompt.Text := selectedTopic.prompt;
  DialogTabAnswer.Text := selectedTopic.answer;

  DialogTabNextSelect.Clear;
  DialogTabNextList.Clear;

  for topic in TDialogTopic.dataList do begin
      hasNext := False;

      for nextTopic in selectedTopic.nextTopics do
          if nextTopic = topic.name then hasNext := True;

      if hasNext then
          DialogTabNextList.AddItem(topic.name, topic)
      else
         DialogTabNextSelect.AddItem(topic.name, topic);
  end;


  DialogTabConditionQuest.Items.Clear;
  DialogTabTriggerQuest.Items.Clear;

  for quest in TQuestData.dataList do begin
      DialogTabConditionQuest.AddItem(quest.name, quest);
      DialogTabTriggerQuest.AddItem(quest.name, quest);
  end;

  DialogTabConditionQuest.Text := selectedTopic.conditionQuest;
  DialogTabConditionVariable.Text := selectedTopic.conditionVariable;

  DialogTabTriggerQuest.Text := selectedTopic.triggerQuest;
  DialogTabTriggerName.Text := selectedTopic.triggerTrigger;

  DialogTabRefreshCondition;
  DialogTabRefreshTrigger;
end;

procedure TMainForm.DialogTabRefreshCondition;
var
  variable: TQuestVariable;
begin
  DialogTabConditionVariable.Items.Clear;
  if DialogTabConditionQuest.ItemIndex >= 0 then
     for variable in (DialogTabConditionQuest.Items.Objects[DialogTabConditionQuest.ItemIndex] as TQuestData).variables do
         if variable.variableType <> 'objective' then
            DialogTabConditionVariable.AddItem(variable.name, variable);
end;

procedure TMainForm.DialogTabRefreshTrigger;
var
  trigger: TQuestTrigger;
begin
  DialogTabTriggerName.Items.Clear;
  if DialogTabTriggerQuest.ItemIndex >= 0 then
     for trigger in (DialogTabTriggerQuest.Items.Objects[DialogTabConditionQuest.ItemIndex] as TQuestData).triggers do
         if DialogTabTriggerName.Items.IndexOf(trigger.name) < 0 then
            DialogTabTriggerName.AddItem(trigger.name, trigger);
end;

procedure TMainForm.DialogTabRefreshNextSelect;
var
  topic: TDialogTopic;
begin
  DialogTabNextSelect.Items.Clear;

  for topic in TDialogTopic.dataList do begin
      if (DialogTabNextSelectFilter.Text <> '')
         and (not topic.name.Contains(DialogTabNextSelectFilter.Text)) then Continue;
      if selectedTopic.nextTopics.IndexOf(topic.name) < 0 then
         DialogTabNextSelect.AddItem(topic.name, topic);
  end;
end;

procedure TMainForm.DialogTabItemListClick(Sender: TObject);
var
  questVariable: TQuestVariable;
  questTrigger: TQuestTrigger;
begin
  if DialogTabItemList.ItemIndex < 0 then begin
    selectedTopic := nil;
    Exit;
  end;

  WriteLn(DialogTabItemList.ItemIndex);

  selectedTopic := DialogTabItemList.Items.Objects[DialogTabItemList.ItemIndex] as TDialogTopic;

  DialogTabRefresh;
end;

procedure TMainForm.DialogTabNameEditingDone(Sender: TObject);
var
  index: Integer;
begin
  index := DialogTabItemList.Items.IndexOfObject(selectedTopic);
  if index >= 0 then
     DialogTabItemList.Items.Strings[index] := DialogTabName.Text;
  selectedTopic.name := DialogTabName.Text;
  //DialogTabRefreshList;
end;

procedure TMainForm.DialogTabDeleteItemClick(Sender: TObject);
begin
  if selectedTopic = nil then begin
    ShowMessage('Select a dialog before removing it!');
    Exit;
  end;

  if MessageDlg('Removing dialog topic', 'Do you want to remove '
                + selectedTopic.name + ' from ' + selectedTopic.parent.GetName
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    TDialogTopic.dataList.Remove(selectedTopic);
    selectedTopic := nil;

    DialogTabGeneral.Enabled := False;
    DialogTabStrings.Enabled := False;
    DialogTabCondition.Enabled := False;
    DialogTabTrigger.Enabled := False;
    DialogTabNextTopics.Enabled := False;

    DialogTabRefreshList;
  end;
end;

procedure TMainForm.DialogTabAnswerEditingDone(Sender: TObject);
begin
  selectedTopic.answer := DialogTabAnswer.Text;
end;

procedure TMainForm.DialogTabConditionQuestEditingDone(Sender: TObject);
begin
  selectedTopic.conditionQuest := DialogTabConditionQuest.Text;
  DialogTabRefreshCondition;
end;

procedure TMainForm.DialogTabConditionVariableEditingDone(Sender: TObject);
begin
  selectedTopic.conditionVariable := DialogTabConditionVariable.Text;
end;

procedure TMainForm.DialogTabNewItemClick(Sender: TObject);
var
  dialogFile: TDialog;
  newTopic: TDialogTopic;
  topicName: string;
begin
  if DialogTabFile.ItemIndex < 0 then begin
    ShowMessage('Select a Dialog file, then you can add a quest to it!');
    Exit;
  end;

  dialogFile := (DialogTabFile.Items.Objects[DialogTabFile.ItemIndex] as TDialog);

  topicName := DialogTabSearchTopic.Text;
  topicName := topicName.Trim;

  // TODO: add more validation (no spaces, unique, etc.)
  if topicName = '' then begin
    ShowMessage('Type in the dialog topic name into the search box.'
                + 'This name will be used for the topic name.');
    Exit;
  end;

  newTopic := TDialogTopic.Create;
  newTopic.name := topicName;
  newTopic.parent := dialogFile;

  TDialogTopic.dataList.Add(newTopic);

  DialogTabSearchTopic.Text := '';
  DialogTabRefreshList;
end;

procedure TMainForm.DialogTabNextAddClick(Sender: TObject);
begin
  if DialogTabNextSelect.ItemIndex < 0 then begin
    ShowMessage('Select a topic before adding it');
    Exit;
  end;

  selectedTopic.nextTopics.Add(DialogTabNextSelect.Items.Strings[DialogTabNextSelect.ItemIndex]);

  DialogTabNextList.AddItem(DialogTabNextSelect.Items[DialogTabNextSelect.ItemIndex],
                            DialogTabNextSelect.Items.Objects[DialogTabNextSelect.ItemIndex]);
  DialogTabNextSelect.DeleteSelected;
  //selectedTopic.nextTopics.Delete(selectedTopic.nextTopics.IndexOf(DialogTabNextList.Items[DialogTabNextList.ItemIndex]));
end;

procedure TMainForm.DialogTabNextListDblClick(Sender: TObject);
begin
  if DialogTabNextList.ItemIndex < 0 then Exit;
  selectedTopic := DialogTabNextList.Items.Objects[DialogTabNextList.ItemIndex] as TDialogTopic;
  DialogTabRefresh;
end;

procedure TMainForm.DialogTabNextRemoveClick(Sender: TObject);
begin
  if DialogTabNextList.ItemIndex < 0 then begin
    ShowMessage('Select a topic before removing it');
    Exit;
  end;

  selectedTopic.nextTopics.Delete(selectedTopic.nextTopics.IndexOf(DialogTabNextList.Items.Strings[DialogTabNextList.ItemIndex]));

  DialogTabNextSelect.AddItem(DialogTabNextList.Items[DialogTabNextList.ItemIndex],
                              DialogTabNextList.Items.Objects[DialogTabNextList.ItemIndex]);
  DialogTabNextList.DeleteSelected;
end;

procedure TMainForm.DialogTabNextSelectFilterChange(Sender: TObject);
begin
  DialogTabRefreshNextSelect;
end;

procedure TMainForm.DialogTabPromptEditingDone(Sender: TObject);
begin
  selectedTopic.prompt := DialogTabPrompt.Text;
end;

procedure TMainForm.DialogTabSearchTopicChange(Sender: TObject);
begin
  DialogTabRefreshList;
end;

procedure TMainForm.DialogTabTriggerNameEditingDone(Sender: TObject);
begin
  selectedTopic.triggerTrigger := DialogTabTriggerName.Text;
end;

procedure TMainForm.DialogTabTriggerQuestEditingDone(Sender: TObject);
begin
  selectedTopic.triggerQuest := DialogTabTriggerQuest.Text;
  DialogTabRefreshTrigger;
end;

procedure TMainForm.DialogTabTypeChange(Sender: TObject);
begin
  case DialogTabType.Text of
    'topic': selectedTopic.dialogType := dialogTopic;
    'import-single': selectedTopic.dialogType := dialogSingle;
    'import-multiple': selectedTopic.dialogType := dialogMulti;
  end;

  DialogTabStrings.Enabled := selectedTopic.dialogType = dialogTopic;
end;

procedure TMainForm.MenuItemQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MenuItemSaveFilesClick(Sender: TObject);
var
  asset: TAssetMetadata;
begin
  for asset in questCollection.GetAssets do begin
      asset.SaveToDisk;
  end;

  for asset in dialogCollection.GetAssets do begin
      asset.SaveToDisk;
  end;

  for asset in itemCollection.GetAssets do begin
      asset.SaveToDisk;
  end;
end;

procedure TMainForm.QuestTabDeleteItemClick(Sender: TObject);
begin
  if selectedQuest = nil then begin
    ShowMessage('Select a quest before removing it!');
    Exit;
  end;

  if MessageDlg('Removing quest', 'Do you want to remove '
                + selectedQuest.name + ' from ' + selectedQuest.parent.GetName
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    TQuestData.dataList.Remove(selectedQuest);
    selectedQuest := nil;

    QuestsTabGeneral.Enabled := False;
    QuestsTabStages.Enabled := False;
    QuestsTabVariables.Enabled := False;
    QuestsTabTriggers.Enabled := False;

    QuestTabRefreshList;
  end;
end;

procedure TMainForm.QuestTabFileChange(Sender: TObject);
begin
  QuestTabRefreshList;
end;

procedure TMainForm.QuestTabGeneralNameEditingDone(Sender: TObject);
begin
  // TODO: add validation (no spaces, not empty, unique, etc.)
  selectedQuest.name := QuestTabGeneralName.text;

  QuestTabRefreshList;
end;

procedure TMainForm.QuestTabNewItemClick(Sender: TObject);
var
  questFile: TQuest;
  newQuest: TQuestData;
  questName: string;
begin
  if QuestTabFile.ItemIndex < 0 then begin
    ShowMessage('Select a Quest file, then you can add a quest to it!');
    Exit;
  end;

  questFile := (QuestTabFile.Items.Objects[QuestTabFile.ItemIndex] as TQuest);

  questName := QuestTabSearchItem.Text;
  questName := questName.Trim;

  // TODO: add more validation (no spaces, unique, etc.)
  if questName = '' then begin
    ShowMessage('Type in the quest name into the search box.'
                + 'This name will be used for the quest name.');
    Exit;
  end;

  newQuest := TQuestData.Create;
  newQuest.name := questName;
  newQuest.parent := questFile;

  TQuestData.dataList.Add(newQuest);

  QuestTabSearchItem.Text := '';
  QuestTabRefreshList;
end;

procedure TMainForm.QuestTabObjectiveAddNewClick(Sender: TObject);
begin
  if selectedQuest = nil then begin
    ShowMessage('Select a Quest file, then you can add a stage to it!');
    Exit;
  end;

  selectedObjective := TQuestVariable.Create;
  selectedObjective.name := 'new-objective';
  selectedObjective.variableType := 'objective';
  selectedObjective.objectiveState := '0';

  selectedQuest.variables.Add(selectedObjective);

  QuestTabObjectiveList.AddItem('new-objective', selectedObjective);
  QuestTabObjectiveList.ItemIndex := QuestTabObjectiveList.Items.Count - 1;

  QuestTabRefreshObjective;
end;

procedure TMainForm.QuestTabObjectiveDeleteClick(Sender: TObject);
begin
  if selectedObjective = nil then begin
    ShowMessage('Select a Quest Stage, then you can remove it!');
    Exit;
  end;

  if MessageDlg('Removing stage', 'Do you want to remove '
                + selectedObjective.name + ' from ' + selectedQuest.name
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    selectedQuest.variables.Remove(selectedObjective);
    selectedObjective := nil;
    QuestTabRefresh;
    QuestTabRefreshObjective;
  end;
end;

procedure TMainForm.QuestTabObjectiveListClick(Sender: TObject);
begin
  if QuestTabObjectiveList.ItemIndex < 0 then begin
    selectedObjective := nil;
    Exit;
  end;

  selectedObjective := QuestTabObjectiveList.Items.Objects[QuestTabObjectiveList.ItemIndex] as TQuestVariable;

  QuestTabRefreshObjective;
end;

procedure TMainForm.QuestTabObjectiveNameEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedObjective = nil then Exit;
  selectedObjective.name := QuestTabObjectiveName.text;

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabObjectiveStateEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedObjective = nil then Exit;
  selectedObjective.objectiveState := QuestTabObjectiveState.text;

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabObjectiveSubtitleEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedObjective = nil then Exit;
  selectedObjective.objectiveSubtitle := QuestTabObjectiveSubtitle.text;

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabObjectiveTitleEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedObjective = nil then Exit;
  selectedObjective.value := QuestTabObjectiveTitle.Text;

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabTriggerConditionQuestEditingDone(Sender: TObject);
begin
  if selectedTrigger = nil then Exit;
  selectedTrigger.conditionQuest := QuestTabTriggerConditionQuest.Text;

  QuestTabRefreshTrigger
end;

procedure TMainForm.QuestTabTriggerConditionVariableEditingDone(Sender: TObject
  );
begin
  if selectedTrigger = nil then Exit;
  selectedTrigger.conditionVariable := QuestTabTriggerConditionVariable.Text;
end;

procedure TMainForm.QuestTabTriggerDeleteClick(Sender: TObject);
begin
  if selectedTrigger = nil then begin
    ShowMessage('Select a Quest Trigger, then you can remove it!');
    Exit;
  end;

  if MessageDlg('Removing trigger', 'Do you want to remove '
                + selectedTrigger.name + ' from ' + selectedQuest.name
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    selectedQuest.triggers.Remove(selectedTrigger);
    selectedTrigger := nil;
    QuestTabRefresh;
  end;
end;

procedure TMainForm.QuestTabTriggerNameEditingDone(Sender: TObject);
begin
  if selectedTrigger = nil then Exit;
  // TODO: validate
  selectedTrigger.name := QuestTabTriggerName.Text;
  QuestTabRefresh;
end;

procedure TMainForm.QuestTabTriggerRadioChange(Sender: TObject);
begin
  if selectedTrigger = nil then Exit;

  if QuestTabTriggerRadioInt.Checked then selectedTrigger.valueType := 'int';
  if QuestTabTriggerRadioFloat.Checked then selectedTrigger.valueType := 'float';
  if QuestTabTriggerRadioBoolean.Checked then selectedTrigger.valueType := 'bool';
  if QuestTabTriggerRadioName.Checked then selectedTrigger.valueType := 'name';

end;

procedure TMainForm.QuestTabTriggerAddNewClick(Sender: TObject);
begin
  if selectedQuest = nil then begin
    ShowMessage('Select a Quest file, then you can add a stage to it!');
    Exit;
  end;

  selectedTrigger := TQuestTrigger.Create;
  selectedTrigger.name := 'new-trigger';

  selectedQuest.triggers.Add(selectedTrigger);

  QuestTabTriggerList.AddItem('new-trigger', selectedTrigger);
  QuestTabTriggerList.ItemIndex := QuestTabTriggerList.Items.Count - 1;

  QuestTabRefreshTrigger;
end;

procedure TMainForm.QuestTabTriggerRecheck;
begin


end;

procedure TMainForm.QuestTabTriggerListClick(Sender: TObject);
begin
  if QuestTabTriggerList.ItemIndex < 0 then begin
    selectedTrigger := nil;
    Exit;
  end;

  selectedTrigger := QuestTabTriggerList.Items.Objects[QuestTabTriggerList.ItemIndex] as TQuestTrigger;

  QuestTabRefreshTrigger;
end;

procedure TMainForm.QuestTabTriggerTargetEditingDone(Sender: TObject);
begin
  if selectedTrigger = nil then Exit;
  selectedTrigger.triggerTarget := QuestTabTriggerTarget.Text;
end;

procedure TMainForm.QuestTabTriggerTypeEditingDone(Sender: TObject);
begin
  if selectedTrigger = nil then Exit;
  selectedTrigger.triggerType := QuestTabTriggerType.Text;

  QuestTabRefreshTrigger;
end;

procedure TMainForm.QuestTabTriggerValueEditingDone(Sender: TObject);
begin
  if selectedTrigger = nil then Exit;
  selectedTrigger.value := QuestTabTriggerValue.Text;
end;

procedure TMainForm.QuestTabVariableDeleteClick(Sender: TObject);
begin
  if selectedVariable = nil then begin
    ShowMessage('Select a Quest Variable, then you can remove it!');
    Exit;
  end;

  if MessageDlg('Removing variable', 'Do you want to remove '
                + selectedVariable.name + ' from ' + selectedQuest.name
                + '?', mtConfirmation,
   [mbYes, mbNo], 0) = mrYes
  then begin
    selectedQuest.variables.Remove(selectedVariable);
    selectedVariable := nil;
    QuestTabRefresh;
  end;
end;

procedure TMainForm.QuestTabVariableNameEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedVariable = nil then Exit;
  selectedVariable.name := QuestTabVariableName.text;

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabVariableQuestEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedVariable = nil then Exit;
  selectedVariable.targetQuest := QuestTabVariableQuest.Text;
  QuestTabRefreshVariable;
end;

procedure TMainForm.QuestTabVariableRadioChange(Sender: TObject);
begin
  if selectedVariable = nil then Exit;

  if QuestTabVariableRadioInt.Checked then selectedVariable.valueType := 'int';
  if QuestTabVariableRadioFloat.Checked then selectedVariable.valueType := 'float';
  if QuestTabVariableRadioBoolean.Checked then selectedVariable.valueType := 'bool';
  if QuestTabVariableRadioName.Checked then selectedVariable.valueType := 'name';

end;

procedure TMainForm.QuestTabVariableAddNewClick(Sender: TObject);
begin
  if selectedQuest = nil then begin
    ShowMessage('Select a Quest file, then you can add a variable to it!');
    Exit;
  end;

  selectedVariable := TQuestVariable.Create;
  selectedVariable.name := 'new-variable';
  selectedVariable.value := '0';
  selectedVariable.valueType := 'int';

  selectedQuest.variables.Add(selectedVariable);

  QuestTabVariableList.AddItem('new-variable', selectedVariable);
  QuestTabVariableList.ItemIndex := QuestTabVariableList.Items.Count - 1;

  QuestTabRefreshVariable;
end;

procedure TMainForm.QuestTabVariableRecheck;
begin
  // TODO: delete this
end;

procedure TMainForm.QuestTabVariableListClick(Sender: TObject);
begin
  if QuestTabVariableList.ItemIndex < 0 then begin
    selectedVariable := nil;
    Exit;
  end;

  selectedVariable := QuestTabVariableList.Items.Objects[QuestTabVariableList.ItemIndex] as TQuestVariable;

  QuestTabRefreshVariable;


  (*QuestTabVariableName.Text := selectedVariable.name;
  QuestTabVariableType.Text := selectedVariable.variableType;
  QuestTabVariableQuest.Text := selectedVariable.targetQuest;
  QuestTabVariableVariable.Text := selectedVariable.targetVariable;
  QuestTabVariableValueString.Text := selectedVariable.value;

  case selectedVariable.valueType of
    'int': QuestTabVariableRadioInt.Checked := True;
    'float': QuestTabVariableRadioFloat.Checked := True;
    'bool': QuestTabVariableRadioBoolean.Checked := True;
    'name': QuestTabVariableRadioName.Checked := True;
  end;

  QuestTabVariableRecheck;*)
end;

procedure TMainForm.QuestTabVariableTypeEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedVariable = nil then Exit;
  selectedVariable.variableType := QuestTabVariableType.Text;
  QuestTabRefreshVariable;
end;



procedure TMainForm.QuestTabVariableValueStringEditingDone(Sender: TObject);
begin
  // TODO: validate
  // check which type is selected and then do the thing
  if selectedVariable = nil then Exit;
  selectedVariable.value := QuestTabVariableValueString.Text;
end;

procedure TMainForm.QuestTabVariableVariableEditingDone(Sender: TObject);
begin
  // TODO: validate
  if selectedVariable = nil then Exit;
  selectedVariable.targetVariable := QuestTabVariableVariable.Text;
end;

procedure TMainForm.RefrshAllFileLists;
begin

end;

procedure TMainForm.QuestTabItemListClick(Sender: TObject);
var
  questVariable: TQuestVariable;
  questTrigger: TQuestTrigger;
begin
  if QuestTabItemList.ItemIndex < 0 then begin
    selectedQuest := nil;

    QuestsTabGeneral.Enabled := False;
    QuestsTabStages.Enabled := False;
    QuestsTabVariables.Enabled := False;
    QuestsTabTriggers.Enabled := False;

    Exit;
  end;

  WriteLn(QuestTabItemList.ItemIndex);

  selectedQuest := QuestTabItemList.Items.Objects[QuestTabItemList.ItemIndex] as TQuestData;


  QuestsTabGeneral.Enabled := True;
  QuestsTabStages.Enabled := True;
  QuestsTabVariables.Enabled := True;
  QuestsTabTriggers.Enabled := True;

  //QuestTabObjectiveList.Clear;
  //QuestTabVariableList.Clear;
  //QuestTabTriggerList.Clear;

  //QuestTabGeneralName.Text:= selectedQuest.name;
  QuestTabRefresh;

  QuestTabRefreshObjective;
  QuestTabRefreshVariable;
  QuestTabRefreshTrigger;

  //for questVariable in selectedQuest.variables do
   //   QuestTabVariableList.AddItem(questVariable.name, questVariable);

  //for questTrigger in selectedQuest.triggers do
  //    QuestTabTriggerList.AddItem(questTrigger.name, questTrigger);
end;

procedure TMainForm.MenuItemLoadDatabaseClick(Sender: TObject);
begin

end;

procedure TMainForm.TabsChange(Sender: TObject);
begin

end;

initialization
begin
  questCollection := TQuestCollection.Create;
  dialogCollection := TDialogCollection.Create;
  itemCollection := TItemCollection.Create;

  selectedQuest := nil;
  selectedVariable := nil;
  selectedObjective := nil;
  selectedTrigger := nil;
  selectedItem := nil;
  selectedEffect := nil;

  DefaultFormatSettings.DecimalSeparator := '.';
end;

end.

