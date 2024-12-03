unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  StdCtrls, ExtCtrls, Spin, EditBtn,

  TramAssetParser, TramAssetWriter, TramAssetMetadata, Tram3DModelAsset,
  TramWorldCellAsset, TramDialogAsset, TramQuestAsset, TramLanguageAsset

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
    QuestTabTriggerConditionVariable: TComboBox;
    QuestTabTriggerValue: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    QuestTabTriggerList: TListBox;
    QuestTabStageAddNew: TButton;
    QuestTabStageDelete: TButton;
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
    QuestTabStageTitle: TEdit;
    QuestTabStageSubtitle: TEdit;
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
    QuestTabStageList: TListBox;
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
    GroupBox1: TGroupBox;
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
    QuestTabStageStage: TSpinEdit;
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
    procedure FormCreate(Sender: TObject);
    procedure MenuItemQuitClick(Sender: TObject);
    procedure QuestTabDeleteItemClick(Sender: TObject);
    procedure QuestTabFileChange(Sender: TObject);
    procedure QuestTabGeneralNameEditingDone(Sender: TObject);
    procedure QuestTabNewItemClick(Sender: TObject);
    procedure QuestTabStageAddNewClick(Sender: TObject);
    procedure QuestTabStageDeleteClick(Sender: TObject);
    procedure QuestTabStageListClick(Sender: TObject);
    procedure QuestTabTriggerRecheck;
    procedure QuestTabTriggerAddNewClick(Sender: TObject);
    procedure QuestTabTriggerListClick(Sender: TObject);
    procedure QuestTabVariableRecheck;
    procedure QuestTabVariableAddNewClick(Sender: TObject);
    procedure QuestTabVariableListClick(Sender: TObject);
    procedure RefrshAllFileLists;
    procedure QuestTabRefreshList;
    procedure QuestTabRefresh;
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
  selectedQuest: TQuestData;
  selectedVariable: TQuestVariable;
  selectedStage: TQuestVariable;
  selectedTrigger: TQuestTrigger;

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


  //MainForm.QuestTabRefreshList;
end;

procedure RefrshAllFileLists;
begin

end;

procedure TMainForm.ItemTabDeleteAttributeClick(Sender: TObject);
begin

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
    selectedStage := nil;
    selectedTrigger := nil;
  end;


  QuestTabStageList.Clear;
  QuestTabVariableList.Clear;
  QuestTabTriggerList.Clear;

  for variable in selectedQuest.variables do
      QuestTabVariableList.AddItem(variable.name, variable);

  for trigger in selectedQuest.triggers do
      QuestTabTriggerList.AddItem(trigger.name, trigger);
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  LoadAllFilesAndStuff;
end;

procedure TMainForm.MenuItemQuitClick(Sender: TObject);
begin
  Close;
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

procedure TMainForm.QuestTabStageAddNewClick(Sender: TObject);
begin
  if selectedQuest = nil then begin
    ShowMessage('Select a Quest file, then you can add a stage to it!');
    Exit;
  end;

  selectedStage := TQuestVariable.Create;
  selectedStage.name := 'new-objective';

  selectedQuest.variables.Add(selectedStage);

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabStageDeleteClick(Sender: TObject);
begin

end;

procedure TMainForm.QuestTabStageListClick(Sender: TObject);
begin

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

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabTriggerRecheck;
begin

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

procedure TMainForm.QuestTabTriggerListClick(Sender: TObject);
begin
  if QuestTabTriggerList.ItemIndex < 0 then begin
    selectedTrigger := nil;
    Exit;
  end;

  selectedTrigger := QuestTabTriggerList.Items.Objects[QuestTabTriggerList.ItemIndex] as TQuestTrigger;

  QuestTabTriggerName.Text := selectedTrigger.name;
  QuestTabTriggerConditionQuest.Text := selectedTrigger.conditionQuest;
  QuestTabTriggerConditionVariable.Text := selectedTrigger.conditionVariable;
  QuestTabTriggerType.Text := selectedTrigger.triggerType;
  QuestTabTriggerTarget.Text := selectedTrigger.triggerTarget;
  QuestTabTriggerValue.Text := selectedTrigger.value;

  case selectedTrigger.valueType of
    'int': QuestTabTriggerRadioInt.Checked := True;
    'float': QuestTabTriggerRadioFloat.Checked := True;
    'bool': QuestTabTriggerRadioBoolean.Checked := True;
    'name': QuestTabTriggerRadioName.Checked := True;
  end;

  QuestTabTriggerRecheck;
end;

procedure TMainForm.QuestTabVariableAddNewClick(Sender: TObject);
begin
  if selectedQuest = nil then begin
    ShowMessage('Select a Quest file, then you can add a variable to it!');
    Exit;
  end;

  selectedVariable := TQuestVariable.Create;
  selectedVariable.name := 'new-variable';

  selectedQuest.variables.Add(selectedVariable);

  QuestTabRefresh;
end;

procedure TMainForm.QuestTabVariableRecheck;
begin
  case selectedVariable.variableType of
    'not', 'script': begin
        QuestTabVariableRadioInt.Enabled := False;
        QuestTabVariableRadioFloat.Enabled := False;
        QuestTabVariableRadioBoolean.Enabled := False;
        QuestTabVariableRadioName.Enabled := False;

        QuestTabVariableValueString.Text := 'Not applicable.';
        QuestTabVariableValueString.Enabled := False;
    end;
    else begin
        QuestTabVariableRadioInt.Enabled := True;
        QuestTabVariableRadioFloat.Enabled := True;
        QuestTabVariableRadioBoolean.Enabled := True;
        QuestTabVariableRadioName.Enabled := True;

        QuestTabVariableValueString.Enabled := True;
    end;
  end;

  case selectedVariable.variableType of
    'value', 'script': begin
        QuestTabVariableQuest.Enabled := False;
        QuestTabVariableVariable.Enabled := False;

        QuestTabVariableQuest.Text := 'Not applicable.';
        QuestTabVariableVariable.Text := 'Not applicable.';
    end;
    else begin
        QuestTabVariableQuest.Enabled := True;
        QuestTabVariableVariable.Enabled := True;
    end;
  end;
end;

procedure TMainForm.QuestTabVariableListClick(Sender: TObject);
begin
  if QuestTabVariableList.ItemIndex < 0 then begin
    selectedVariable := nil;
    Exit;
  end;

  selectedVariable := QuestTabVariableList.Items.Objects[QuestTabVariableList.ItemIndex] as TQuestVariable;

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

  QuestTabVariableRecheck;
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
    Exit;
  end;

  WriteLn(QuestTabItemList.ItemIndex);

  selectedQuest := QuestTabItemList.Items.Objects[QuestTabItemList.ItemIndex] as TQuestData;

  QuestTabStageList.Clear;
  QuestTabVariableList.Clear;
  QuestTabTriggerList.Clear;

  QuestTabGeneralName.Text:= selectedQuest.name;

  for questVariable in selectedQuest.variables do
      QuestTabVariableList.AddItem(questVariable.name, questVariable);

  for questTrigger in selectedQuest.triggers do
      QuestTabTriggerList.AddItem(questTrigger.name, questTrigger);
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

  selectedQuest := nil;
  selectedVariable := nil;
  selectedStage := nil;
  selectedTrigger := nil;
end;

end.

