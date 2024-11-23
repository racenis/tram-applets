unit PreferencesDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, fgl, TramAssetParser, TramAssetWriter
  {$IFDEF WINDOWS}, Win32Proc {$ENDIF};

function GetPreference(name:string): string;
procedure SetPreference(name:string; value:string);

type
    TProjectPreferenceDict = specialize TFPGMap<string, string>;

  { TPreferencesDialog }

  TPreferencesDialog = class(TForm)
    OpenFile: TLabeledEdit;
    OpenDirectory: TLabeledEdit;
    ShowInDirectory: TLabeledEdit;
    PageControl1: TPageControl;
    Reset: TButton;
    Save: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure Populate;
    procedure Depopulate;
  private

  public

  end;

var
  PreferencesDialog: TPreferencesDialog;
  ProjectSettings: TProjectPreferenceDict;

implementation

{$R *.lfm}

{ TPreferencesDialog }

procedure TPreferencesDialog.Populate;
begin
  ShowInDirectory.Text := GetPreference('SHOW_IN_DIRECTORY');
  OpenDirectory.Text := GetPreference('OPEN_DIRECTORY');
  OpenFile.Text := GetPreference('OPEN_FILE');

  // set in defaults
end;

procedure TPreferencesDialog.Depopulate;
begin
  SetPreference('SHOW_IN_DIRECTORY', ShowInDirectory.Text);
  SetPreference('OPEN_DIRECTORY', OpenDirectory.Text);
  SetPreference('OPEN_FILE', OpenFile.Text);
end;

function GetPreferenceDirectory: string;
begin
{$IFDEF WINDOWS}
case WindowsVersion of
     wv95, wvNT4: Result := GetEnvironmentVariable('windir') + '\tram_sdk\';
     wvMe, wv98: Result := GetEnvironmentVariable('windir') + '\Application Data\tram_sdk\';
     wv2000, wvXP, wvServer2003: Result := GetEnvironmentVariable('USERPROFILE') + '\Local Settings\Application Data\tram-sdk\';
     else Result := GetEnvironmentVariable('appdata') + '\tram-sdk\'
end;
{$ELSE}
Result := '~/.tram-sdk/';
{$ENDIF}
end;

function GetPreferencePath: string;
begin
  Result := GetPreferenceDirectory + 'asset-manager.cfg';
end;

procedure LoadPreferences;
var
  fileLoader: TAssetParser;
  row: Integer;
begin
  FreeAndNil(ProjectSettings);
  ProjectSettings := TProjectPreferenceDict.Create;
  fileLoader := TAssetParser.Create(GetPreferencePath);
  if not fileLoader.IsOpen then
  begin
    ShowMessage('Error loading "' + GetPreferencePath + '"!');
    Exit;
  end;
  for row := 0 to fileLoader.GetRowCount - 1 do
      SetPreference(fileLoader.GetValue(row, 0), fileLoader.GetValue(row, 1));
  fileLoader.Free;
end;

procedure SavePreferences;
var
fileWriter: TAssetWriter;
prepData: string;
row:Integer;
begin
  ForceDirectories(GetPreferenceDirectory);
  fileWriter := TAssetWriter.Create(GetPreferencePath);
  fileWriter.Append(['# Tramway SDK Asset Manager Applet User Preferences']);
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

procedure TPreferencesDialog.SaveClick(Sender: TObject);
begin
  Depopulate;
  SavePreferences;
  self.Close;
end;

procedure TPreferencesDialog.ResetClick(Sender: TObject);
begin
  self.Close;
end;

procedure TPreferencesDialog.FormCreate(Sender: TObject);
begin

end;

procedure TPreferencesDialog.FormShow(Sender: TObject);
begin
  Populate;
end;


function GetPreference(name:string): string;
begin
  if not ProjectSettings.TryGetData(name, Result) then Result := '';
end;
procedure SetPreference(name:string; value:string);
begin
  ProjectSettings[name] := value;
end;

initialization
begin
  LoadPreferences;
end;

end.

