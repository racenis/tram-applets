unit ProjectSettingsDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, fgl, TramAssetParser, TramAssetWriter;

function GetSetting(name:string): string;
procedure SetSetting(name:string; value:string);


type
  TProjectSettingDict = specialize TFPGMap<string, string>;

  { TProjectSettingsDialog }

  TProjectSettingsDialog = class(TForm)
    Cancel: TButton;
    CompileCommand: TLabeledEdit;
    LevelEditor: TLabeledEdit;
    TabSheet4: TTabSheet;
    TMapCommand: TLabeledEdit;
    TRadCommand: TLabeledEdit;
    TBSPCommand: TLabeledEdit;
    ProjectVersion: TLabeledEdit;
    ProjectName: TLabeledEdit;
    SDKVersion: TLabeledEdit;
    RunCommand: TLabeledEdit;
    ProjectPath: TLabeledEdit;
    PageControl1: TPageControl;
    Save: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    procedure CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure Reset;
    procedure Dereset;
  private

  public

  end;

var
  ProjectSettingsDialog: TProjectSettingsDialog;
  ProjectSettings: TProjectSettingDict;


implementation

{$R *.lfm}

{ TProjectSettingsDialog }

procedure TProjectSettingsDialog.Reset;
begin
  ProjectPath.Text := GetCurrentDir;
  ProjectName.Text := GetSetting('PROJECT_NAME');
  ProjectVersion.Text := GetSetting('PROJECT_VERSION');
  SDKVersion.Text := GetSetting('SDK_VERSION');

  RunCommand.Text := GetSetting('RUN_COMMAND');
  CompileCommand.Text := GetSetting('COMPILE_COMMAND');

  TBSPCommand.Text := GetSetting('TBSP_COMMAND');
  TMAPCommand.Text := GetSetting('TMAP_COMMAND');
  TRADCommand.Text := GetSetting('TRAD_COMMAND');

  LevelEditor.Text := GetSetting('LEVEL_EDITOR_COMMAND');
end;

procedure TProjectSettingsDialog.Dereset;
begin
  SetSetting('PROJECT_NAME', ProjectName.Text);
  SetSetting('PROJECT_VERSION', ProjectVersion.Text);

  SetSetting('RUN_COMMAND', RunCommand.Text);
  SetSetting('COMPILE_COMMAND', CompileCommand.Text);

  SetSetting('TBSP_COMMAND', TBSPCommand.Text);
  SetSetting('TMAP_COMMAND', TMAPCommand.Text);
  SetSetting('TRAD_COMMAND', TRADCommand.Text);

  SetSetting('LEVEL_EDITOR_COMMAND', LevelEditor.Text);
end;

procedure SetDefault(pref: string; val: string);
begin
  if GetSetting(pref) = '' then SetSetting(pref, val);
end;

procedure SetDefaults;
begin
  // TODO: setup linux versions of defaults
  SetDefault('RUN_COMMAND', 'tram-template.exe');
  SetDefault('COMPILE_COMMAND', 'make project');

  SetDefault('TBSP_COMMAND', 'idk');
  SetDefault('TMAP_COMMAND', '..\tram-template\tmap %model %size %padding');
  SetDefault('TRAD_COMMAND', 'idk');

  SetDefault('LEVEL_EDITOR_COMMAND', '..\tram-template\leveleditor');
end;

procedure TProjectSettingsDialog.FormCreate(Sender: TObject);
begin
  Reset;
end;

procedure LoadSettings;
var
  fileLoader: TAssetParser;
  row: Integer;
begin
  FreeAndNil(ProjectSettings);
  ProjectSettings := TProjectSettingDict.Create;
  fileLoader := TAssetParser.Create('project.cfg');
  if not fileLoader.IsOpen then
  begin
    ShowMessage('Error loading project.cfg!');
    Exit;
  end;
  for row := 0 to fileLoader.GetRowCount - 1 do
      if fileLoader.GetColCount(row) = 2 then
        SetSetting(fileLoader.GetValue(row, 0), fileLoader.GetValue(row, 1).Replace('''''', '"'));


  fileLoader.Free;
end;

procedure SaveSettings;
var
fileWriter: TAssetWriter;
prepData: string;
row:Integer;
begin
  fileWriter := TAssetWriter.Create('project.cfg');
  fileWriter.Append(['# Tramway SDK Project Settings']);
  fileWriter.Append(['# Gemerated by: Tramway SDK Asset Manager Applet']);
  fileWriter.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  fileWriter.Append(nil);
  for row := 0 to ProjectSettings.Count - 1 do
      begin
        prepData := ProjectSettings.Data[row];
        prepData := prepData.Replace('"', '''''');
        prepData := '"' + prepData + '"';
        fileWriter.Append([ProjectSettings.Keys[row], prepData]);
      end;

  fileWriter.Free;
end;

procedure TProjectSettingsDialog.CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TProjectSettingsDialog.SaveClick(Sender: TObject);
begin
  Dereset;
  SetDefaults;
  SaveSettings;
  Close;
end;


function GetSetting(name:string): string;
begin
  if not ProjectSettings.TryGetData(name, Result) then Result := '';
end;
procedure SetSetting(name:string; value:string);
begin
  ProjectSettings[name] := value;
end;

initialization
begin
  LoadSettings;
  SetDefaults;
end;

end.

