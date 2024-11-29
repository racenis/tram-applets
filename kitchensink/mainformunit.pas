unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, Menus,
  StdCtrls, ExtCtrls, Spin, EditBtn;

type

  { TMainForm }

  TMainForm = class(TForm)
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
    QuestTabTriggerParameter: TEdit;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    ListBox1: TListBox;
    QuestTabStageAddNew: TButton;
    QuestTabStageDelete: TButton;
    QuestTabTriggerTarget: TComboBox;
    QuestTabTriggerType: TComboBox;
    QuestTabVariableAddNew: TButton;
    QuestTabTriggerAddNew: TButton;
    QuestTabVariableDelete: TButton;
    QuestTabTriggerDelete: TButton;
    QuestTabTriggerName: TEdit;
    QuestTabTriggerCondition: TComboBox;
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
    ItemTabDeleteItem6: TButton;
    DialogTabDeleteItem: TButton;
    ItemTabFile1: TComboBox;
    ItemTabFile2: TComboBox;
    ClassTabFile: TComboBox;
    ItemTabFile4: TComboBox;
    ItemTabFile5: TComboBox;
    ItemTabFile6: TComboBox;
    DialogTabFile: TComboBox;
    ItemTabItemList1: TListBox;
    ItemTabItemList2: TListBox;
    ClassTabClassList: TListBox;
    ItemTabItemList4: TListBox;
    ItemTabItemList5: TListBox;
    ItemTabItemList6: TListBox;
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
    ItemTabNewItem6: TButton;
    DialogTabNewItem: TButton;
    ItemTabSearchItem1: TEdit;
    ItemTabSearchItem2: TEdit;
    ClassTabSearchClass: TEdit;
    ItemTabSearchItem4: TEdit;
    ItemTabSearchItem5: TEdit;
    ItemTabSearchItem6: TEdit;
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
    procedure ItemTabDeleteAttributeClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.ItemTabDeleteAttributeClick(Sender: TObject);
begin

end;

end.

