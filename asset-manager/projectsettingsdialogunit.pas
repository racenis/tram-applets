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
    LabeledEdit1: TLabeledEdit;
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

//var


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
end;

procedure TProjectSettingsDialog.Dereset;
begin
  SetSetting('PROJECT_NAME', ProjectName.Text);
  SetSetting('PROJECT_VERSION', ProjectVersion.Text);

  SetSetting('RUN_COMMAND', RunCommand.Text);
  SetSetting('COMPILE_COMMAND', CompileCommand.Text);
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
      //ProjectSettings.Add(fileLoader.GetValue(row, 0), fileLoader.GetValue(row, 1));
      SetSetting(fileLoader.GetValue(row, 0), fileLoader.GetValue(row, 1));
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
  //LoadSettings;
  //Reset;
  Close;
end;

procedure TProjectSettingsDialog.SaveClick(Sender: TObject);
begin
  Dereset;
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
end;

end.

