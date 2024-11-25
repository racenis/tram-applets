unit PreferencesDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  ExtCtrls, fgl, TramAssetParser, TramAssetWriter, AssetAuthorDialogUnit
  {$IFDEF WINDOWS}, Win32Proc {$ENDIF};

function GetPreference(name:string): string;
procedure SetPreference(name:string; value:string);

type
    TProjectPreferenceDict = specialize TFPGMap<string, string>;

  { TPreferencesDialog }

  TPreferencesDialog = class(TForm)
    UserRole: TComboBox;
    UserIdentifier: TEdit;
    UserName: TEdit;
    UserAddress: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    UserNotes: TMemo;
    OpenFile: TLabeledEdit;
    OpenDirectory: TLabeledEdit;
    ShowInDirectory: TLabeledEdit;
    PageControl1: TPageControl;
    Reset: TButton;
    Save: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    ProfileTab: TTabSheet;
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

  UserIdentifier.Text := GetPreference('USER_IDENTIFIER');
  UserName.Text := GetPreference('USER_NAME');
  UserAddress.Text := GetPreference('USER_ADDRESS');
  UserRole.Text := GetPreference('USER_ROLE');
  UserNotes.Text := GetPreference('USER_NOTES');
end;

procedure TPreferencesDialog.Depopulate;
var
  author: TAssetAuthor;
begin
  SetPreference('SHOW_IN_DIRECTORY', ShowInDirectory.Text);
  SetPreference('OPEN_DIRECTORY', OpenDirectory.Text);
  SetPreference('OPEN_FILE', OpenFile.Text);

  SetPreference('USER_IDENTIFIER', UserIdentifier.Text);
  SetPreference('USER_NAME', UserName.Text);
  SetPreference('USER_ADDRESS', UserAddress.Text);
  SetPreference('USER_ROLE', UserRole.Text);
  SetPreference('USER_NOTES', UserNotes.Text);

  author := FindAssetAuthor(UserIdentifier.Text);
  author.Identifier := UserIdentifier.Text;
  author.Name := UserName.Text;
  author.Address := UserAddress.Text;
  author.Role := UserRole.Text;
  author.Notes := UserNotes.Text;
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

procedure SetDefault(pref: string; val: string);
begin
  if GetPreference(pref) = '' then SetPreference(pref, val);
end;

// TODO: figure out what defaults should be for UNIX
procedure SetDefaults;
begin
  SetDefault('SHOW_IN_DIRECTORY', 'explorer.exe /select,%path');
  SetDefault('OPEN_DIRECTORY', 'explorer.exe %path');
  SetDefault('OPEN_FILE', 'explorer.exe %path');
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
      SetPreference(fileLoader.GetValue(row, 0), fileLoader.GetValue(row, 1).Replace('''''', '"'));
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
  SetDefaults;
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
  SetDefaults;
end;

end.

