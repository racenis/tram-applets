unit MainFormUnit;

{$mode objfpc}{$H+}


// List of stuff to do:
// - Move database saving and loading
//   - Either into a seperate file or into data library
// - Move settings and parameters into datalib
// - Add icons to asset list based on asset type
// - Maybe add highlighting based of whether asset is processed or not

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, ExtCtrls, StdCtrls, Grids, TramAssetDatabase, TramAssetMetadata,
  DateUtils, XMLConf, TramAssetWriter, TramAssetParser, Process,
  RefreshNewFileDialogUnit, RefreshMissingFileDialogUnit,
  RefreshChangeFileDialogUnit, LCLType, LCLIntf, IniPropStorage, FileUtil,
  ImportFileDialogUnit, MetadataStaticModelUnit, AboutDialogUnit,
  MetadataDynamicModelUnit, MetadataModificationModelUnit, ProcessQueue,
  PreferencesDialogUnit, ProjectSettingsDialogUnit, AssetAuthorDialogUnit,
  AssetSourceDialogUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    AssetEdit: TButton;
    AssetShowDirectory: TButton;
    CheckBox1: TCheckBox;
    AssetType: TEdit;
    AssetName: TEdit;
    AssetAlwaysProcess: TCheckBox;
    AssetIgnoreModified: TCheckBox;
    AssetAuthor: TEdit;
    AssetSource: TComboBox;
    FilterButton: TButton;
    DBGrid: TDBGrid;
    FilterClear: TButton;
    FilterName: TEdit;
    FilterType: TComboBox;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    AssetMenu: TMenuItem;
    LoadDB: TMenuItem;
    Help: TMenuItem;
    GetHelp: TMenuItem;
    About: TMenuItem;
    ImportAsset: TMenuItem;
    Compile: TMenuItem;
    ExportAsset: TMenuItem;
    EditAsset: TMenuItem;
    AddAssetToQueue: TMenuItem;
    AddToAsyncQueue: TMenuItem;
    AssetSources: TMenuItem;
    AssetAuthors: TMenuItem;
    PopupShowInExplorer: TMenuItem;
    PopupProcess: TMenuItem;
    PopUpQueue: TMenuItem;
    PopupMove: TMenuItem;
    PopupRemove: TMenuItem;
    Separator11: TMenuItem;
    PopupView: TMenuItem;
    PopupEdit: TMenuItem;
    Separator12: TMenuItem;
    Separator13: TMenuItem;
    StringGridPopupMenu: TPopupMenu;
    Separator10: TMenuItem;
    ShowInExplorer: TMenuItem;
    RemoveAsset: TMenuItem;
    MoveAsset: TMenuItem;
    Separator7: TMenuItem;
    Separator8: TMenuItem;
    Separator9: TMenuItem;
    ViewAsset: TMenuItem;
    StartProcessQueue: TMenuItem;
    OpenLanguageEditor: TMenuItem;
    OpenMaterialEditor: TMenuItem;
    ProjectSettings: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    Separator6: TMenuItem;
    ShowDirectory: TMenuItem;
    OpenLevelEditor: TMenuItem;
    RunExecutable: TMenuItem;
    Project: TMenuItem;
    Preferences: TMenuItem;
    Quit: TMenuItem;
    OpenDialog: TOpenDialog;
    Panel1: TPanel;
    MetadataProperty: TPanel;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    SharedProperty: TPanel;
    SaveDB: TMenuItem;
    StatusBar: TStatusBar;
    StringGrid: TStringGrid;
    procedure AboutClick(Sender: TObject);
    procedure AddAssetToQueueClick(Sender: TObject);
    procedure AssetAlwaysProcessChange(Sender: TObject);
    procedure AssetAuthorsClick(Sender: TObject);
    procedure AssetDeleteClick(Sender: TObject);
    procedure AssetEditClick(Sender: TObject);
    procedure AssetIgnoreModifiedChange(Sender: TObject);
    procedure AssetShowDirectoryClick(Sender: TObject);
    procedure AssetSourceChange(Sender: TObject);
    procedure AssetSourcesClick(Sender: TObject);
    procedure CompileClick(Sender: TObject);
    procedure EditAssetClick(Sender: TObject);
    procedure FilterButtonClick(Sender: TObject);
    procedure FilterClearClick(Sender: TObject);
    procedure FilterNameKeyDown(Sender: TObject; var Key: Word;
      {%H-}Shift: TShiftState);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure GetHelpClick(Sender: TObject);
    procedure ImportAssetClick(Sender: TObject);
    procedure ImportClick(Sender: TObject);
    procedure LoadDBClick(Sender: TObject);
    procedure MoveAssetClick(Sender: TObject);
    procedure OpenLevelEditorClick(Sender: TObject);
    procedure PopupEditClick(Sender: TObject);
    procedure PopupMoveClick(Sender: TObject);
    procedure PopupProcessClick(Sender: TObject);
    procedure PopUpQueueClick(Sender: TObject);
    procedure PopupRemoveClick(Sender: TObject);
    procedure PopupShowInExplorerClick(Sender: TObject);
    procedure PopupViewClick(Sender: TObject);
    procedure PreferencesClick(Sender: TObject);
    procedure ProjectSettingsClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure RemoveAssetClick(Sender: TObject);
    procedure RunExecutableClick(Sender: TObject);
    procedure SaveDBClick(Sender: TObject);
    procedure ShowDirectoryClick(Sender: TObject);
    procedure ShowInExplorerClick(Sender: TObject);
    procedure StartProcessQueueClick(Sender: TObject);
    procedure StringGridAfterSelection(Sender: TObject; {%H-}aCol, {%H-}aRow: Integer);
    procedure SetSelectedAsset(asset: TAssetMetadata);
    procedure ResetStatusBar;
    procedure ResetSourceDropdown;
    procedure ViewAssetClick(Sender: TObject);
    function AssetSelected: Boolean;
  private
    metadataPropertyFrame: TFrame;
  public

  end;

var
  MainForm: TMainForm;
  database: TAssetDatabase;
  selectedAsset: TAssetMetadata;


implementation

{$R *.lfm}

{ TMainForm }

// ************************************************************************** //
// *                                                                        * //
// *                        DATABASE INITIALIZATION                         * //
// *                                                                        * //
// ************************************************************************** //

procedure LoadDatabaseFromFile;
var
  databaseFile: TAssetParser;
  databaseRecord: array of string;

  asset: TAssetMetadata;
  source: TAssetSource;
  author: TAssetAuthor;
begin
  databaseFile := TAssetParser.Create('asset.db');
  asset := nil;
  source := nil;
  author := nil;

  if not databaseFile.IsOpen then
     ShowMessage('Database file not found!')
  else
     for databaseRecord in databaseFile.GetData do
         if Length(databaseRecord) = 3 then begin
            if databaseRecord[0] = 'PROPERTY' then
               asset.SetMetadata(databaseRecord[1], databaseRecord[2])
            else
               asset := database.InsertFromDB(databaseRecord[0],
                                              databaseRecord[1],
                                              databaseRecord[2].ToInteger)
         end else if Length(databaseRecord) = 2 then begin
              if databaseRecord[0] = 'FLAG' then begin
                 if databaseRecord[1] = 'ALWAYS_PROCESS' then
                    asset.SetAlwaysProcess(True)
                 else if databaseRecord[1] = 'IGNORE_MODIFIED' then
                    asset.SetIgnoreModified(True)
              end else if databaseRecord[0] = 'AUTHOR' then
                 asset.SetAuthor(databaseRecord[1])
              else if databaseRecord[0] = 'SOURCE' then
                 asset.SetSource(databaseRecord[1])
         end else if Length(databaseRecord) = 4 then
            if databaseRecord[0] = 'AUTHOR' then begin
              author := FindAssetAuthor(databaseRecord[1]);
              case databaseRecord[2] of
                  'IDENTIFIER': author.Identifier := databaseRecord[3];
                  'NAME': author.Name := databaseRecord[3];
                  'ADDRESS': author.Address := databaseRecord[3];
                  'ROLE': author.Role := databaseRecord[3];
                  'NOTES': author.Notes := databaseRecord[3];
              end;
            end else if databaseRecord[0] = 'SOURCE' then begin
              source := FindAssetSource(databaseRecord[1]);
              case databaseRecord[2] of
                  'IDENTIFIER': source.Identifier := databaseRecord[3];
                  'CREDITS': source.Credits := databaseRecord[3];
                  'ADDRESS': source.Address := databaseRecord[3];
                  'LICENSE': source.License := databaseRecord[3];
                  'NOTES': source.Notes := databaseRecord[3];
              end;
            end;
     //end;


  databaseFile.Free;
end;

procedure RefreshDatabase;
var
  asset: TAssetMetadata;

  newAssets: array of TAssetMetadata;
  modifiedAssets: array of TAssetMetadata;
  removedAssets: array of TAssetMetadata;
begin
  newAssets := [];
  modifiedAssets := [];
  removedAssets := [];

  asset := nil;

  // check what files exist on disk
  database.ScanFromDisk;

  // check which files have changed since database was saved
  for asset in database.GetAssets do
      if asset.GetDateInDB = 0 then
         newAssets := Concat(newAssets, [asset])
      else if asset.GetDateOnDisk = 0 then
         removedAssets := Concat(removedAssets, [asset])
      else if asset.GetDateInDB < asset.GetDateOnDisk then
         if asset.GetAlwaysProcess then
            AddToQueue(asset)
         else if not asset.GetIgnoreModified then
            modifiedAssets := Concat(modifiedAssets, [asset])
      else if asset.GetDateInDB <> asset.GetDateOnDisk then
         ShowMessage('Asset ' + asset.GetName + ' has a date of '
                            + FormatDateTime('yyyy-mm-dd hh:nn:ss',
                              FileDateToDateTime(asset.GetDateInDB))
                            + ' in the database, but a date of '
                            + FormatDateTime('yyyy-mm-dd hh:nn:ss',
                              FileDateToDateTime(asset.GetDateInDB))
                            + ' on disk. I think that this means'
                            + ' something, but I do not really know'
                            + ' what exactly.');

  if Length(newAssets) > 0 then
  begin
    RefreshNewFileDialog := TRefreshNewFileDialog.Create(MainForm, newAssets);
    RefreshNewFileDialog.ShowModal;
    FreeAndNil(RefreshNewFileDialog);
  end;

  if Length(removedAssets) > 0 then
  begin
    RefreshMissingFileDialog := TRefreshMissingFileDialog.Create(MainForm, removedAssets);
    RefreshMissingFileDialog.ShowModal;
    FreeAndNil(RefreshMissingFileDialog);
  end;

  if Length(modifiedAssets) > 0 then
  begin
    RefreshChangeFileDialog := TRefreshChangeFileDialog.Create(MainForm, modifiedAssets);
    RefreshChangeFileDialog.ShowModal;
    FreeAndNil(RefreshChangeFileDialog);
  end;
end;

procedure PopulateAssetList;
var
  row: Integer;
  asset: TAssetMetadata;
  date: string;
begin
  row := 1;
  for asset in database.GetAssets do
  begin
    if asset.GetDateInDB <> 0 then
       date := FormatDateTime('yyyy-mm-dd hh:nn:ss',
                              FileDateToDateTime(asset.GetDateInDB))
    else
       date := 'N/A';

    MainForm.StringGrid.InsertRowWithValues(row, [asset.GetType,
                                         asset.GetName,
                                         //asset.GetAuthor,
                                         //asset.GetSource,
                                         date]);
    MainForm.StringGrid.Objects[0, row] := asset;

    row += 1;
  end;
end;

procedure RefreshAssetList;
var
  row: Integer;
  asset: TAssetMetadata;
  date: string;
begin
  MainForm.StringGrid.RowCount := 1;

  row := 1;
    for asset in database.GetAssets do
    begin
      if MainForm.FilterType.ItemIndex > 0 then
         if MainForm.FilterType.Items.Strings[MainForm.FilterType.ItemIndex] <> asset.GetType then
            Continue;//ShowMessage('need |' + MainForm.FilterType.Items.Strings[MainForm.FilterType.ItemIndex] + '| but has |' + asset.GetType + '|');
      if MainForm.FilterName.Text <> '' then
         if Pos(MainForm.FilterName.Text, asset.GetName) = 0 then
            Continue;


      if asset.GetDateInDB <> 0 then
         date := FormatDateTime('yyyy-mm-dd hh:nn:ss',
                                FileDateToDateTime(asset.GetDateInDB))
      else
         date := 'N/A';

      MainForm.StringGrid.InsertRowWithValues(row, [asset.GetType,
                                         asset.GetName,
                                         //asset.GetAuthor,
                                         //asset.GetSource,
                                         date]);
      MainForm.StringGrid.Objects[0, row] := asset;

      row += 1;
    end;
end;

// ************************************************************************** //
// *                                                                        * //
// *                             EVERYTHING ELSE                            * //
// *                                                                        * //
// ************************************************************************** //

// TODO: bring in the other logics in here
procedure TMainForm.SetSelectedAsset(asset: TAssetMetadata);
begin
  if asset = nil then
  begin
    MainForm.SharedProperty.Enabled := False;
    if metadataPropertyFrame <> nil then metadataPropertyFrame.Enabled := False;
  end
  else
  begin
    MainForm.SharedProperty.Enabled := True;

    if metadataPropertyFrame <> nil then FreeAndNil(metadataPropertyFrame);


    //metadataPropertyFrame := TMetadataStaticModel.Create(MetadataProperty);

    case asset.GetType of
        'STMDL': metadataPropertyFrame := TMetadataStaticModel.Create(MetadataProperty, asset);
        'DYMDL': metadataPropertyFrame := TMetadataDynamicModel.Create(MetadataProperty, asset);
        'MDMDL': metadataPropertyFrame := TMetadataModificationModel.Create(MetadataProperty, asset);
    end;

    if metadataPropertyFrame <> nil then metadataPropertyFrame.Parent := MetadataProperty;

  end;

  selectedAsset := asset;
end;

procedure TMainForm.ResetStatusBar;
begin
  if GetQueueLength > 0 then
     StatusBar.Panels[0].Text := 'Items waiting in queue.'
  else
     StatusBar.Panels[0].Text := 'Ready.';

  StatusBar.Panels[1].Text := 'Asset processing queue length: ' + GetQueueLength.ToString;
end;

procedure TMainForm.ViewAssetClick(Sender: TObject);
begin
  AssetEdit.Click;
end;

function TMainForm.AssetSelected: Boolean;
begin
  if selectedAsset = nil then begin
    StatusBar.Panels[0].Text := 'No asset selected. Please select an asset.';
    Exit(False);
  end;

  ResetStatusBar;

  Result := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  metadataPropertyFrame := nil;

  SetQueueCallback(@ResetStatusBar);

  LoadDatabaseFromFile;
  RefreshDatabase;
  PopulateAssetList;
  ResetSourceDropdown;

  Caption := GetSetting('PROJECT_NAME');
  if Caption = '' then
     Caption := 'Untitled';
  Caption := Caption + ' - Tramway SDK Asset Manager';

  ResetStatusBar;
end;

function FindImportPaths: TStringList;
var
  assetFiles: TStringList;
  dataFiles: TStringList;
  allFiles: TStringList;
  assetFile: string;
  rebases: array of string;
  rebase: string;
begin
  assetFiles := FindAllDirectories('assets');
  dataFiles := FindAllDirectories('data');

  allFiles := TStringList.Create;
  allFiles.Sorted := True;
  allFiles.Duplicates := dupIgnore;

  rebases := ['data/animations', 'data\animations',
              'data/audio',      'data\audio',
              'data/models',     'data\models',
              'data/navmeshes',  'data\navmeshes',
              'data/paths',      'data\paths',
              'data/sprites',    'data\sprites',
              'data/textures',   'data\textures',
              'data/worldcells', 'data\worldcells'];

  for assetFile in assetFiles do
    allFiles.Add(assetFile.Remove(0, 'assets/'.Length).Replace('\', '/'));

  for assetFile in dataFiles do
      for rebase in rebases do
          if assetFile = rebase then
             Break
          else if assetFile.StartsWith(rebase) then
             begin
               allFiles.Add(assetFile.Remove(0, rebase.Length + 1).Replace('\', '/'));
               Break;
             end;

  Result := allFiles;
end;

{$IFDEF WINDOWS}
function CreateSymbolicLinkA(
  lpSymlinkFileName: PAnsiChar;
  lpTargetFileName: PAnsiChar;
  dwFlags: DWORD
): Boolean; stdcall; external 'kernel32';

procedure CreateSymlink(target: string; source: string);
var
  targetAnsi: PAnsiChar;
  sourceAnsi: PAnsiChar;
begin
  source := source.Replace('/', '\');
  target := (GetCurrentDir() + '/' + target).Replace('/', '\');

  sourceAnsi := StrAlloc(Length(source) + 1);
  targetAnsi := StrAlloc(Length(target) + 1);

  StrPCopy(sourceAnsi, source);
  StrPCopy(targetAnsi, target);

  if CreateSymbolicLinkA(targetAnsi, sourceAnsi, 0) = False then
     ShowMessage('Error creating a symlink from ' + sourceAnsi + ' to ' + targetAnsi);

  StrDispose(sourceAnsi);
  StrDispose(targetAnsi);
end;

{$ENDIF}

procedure ImportFiles(files: array of string);
var
  importPaths: TStringList;
  filePath: string;
  fileName: string;
  fileExt: string;
  fileNewPath: string;
begin
  importPaths := FindImportPaths;

  ImportFileDialog := TImportFileDialog.Create(MainForm, importPaths.ToStringArray);
  ImportFileDialog.ShowModal;

  if ImportFileDialog.IsSuccess then
  begin
    for filePath in files do
    begin
      fileName := ExtractFileName(filePath);
      fileExt := ExtractFileExt(filePath);
      fileName := fileName.Remove(Length(fileName) - Length(fileExt));

      case fileExt of
        '.stmdl', '.dymdl', '.mdmdl': fileNewPath := 'data/models/';
        else
          begin
            ShowMessage('File ' + filePath + ' unknown extension: ' + fileExt);
            Continue;
          end;
      end;

      if ImportFileDialog.GetSelectedPath <> '' then
         fileNewPath += ImportFileDialog.GetSelectedPath + '/';

      if not DirectoryExists(fileNewPath) then
         ForceDirectories(fileNewPath);

      fileNewPath += fileName + fileExt;

      ShowMessage('Import destination: ' + fileNewPath);

      case ImportFileDialog.GetSelectedType of
        importCopy: CopyFile(filePath, fileNewPath);
        importMove: RenameFile(filePath, fileNewPath);
        importLink:
          {$IFDEF WINDOWS}
          CreateSymlink(fileNewPath, filePath);
          {$ELSE}
          ShowMessage('Import link not implemented!');
          {$ENDIF}
      end;
    end;
  end;

  FreeAndNil(ImportFileDialog);
end;

procedure TMainForm.ImportClick(Sender: TObject);
begin

end;

procedure TMainForm.FormDropFiles(Sender: TObject;
  const FileNames: array of string);
begin
  ImportFiles(FileNames);
end;

procedure TMainForm.GetHelpClick(Sender: TObject);
begin
  OpenURL('https://racenis.github.io/tram-sdk/documentation.html');
end;

procedure TMainForm.ImportAssetClick(Sender: TObject);
begin
  if not OpenDialog.Execute then Exit;
  ImportFiles(OpenDialog.Files.ToStringArray);
end;

procedure TMainForm.FilterNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
     FilterButton.Click;
end;

function IsDebuggerPresent(): integer stdcall; external 'kernel32.dll';

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  dialogResult: TModalResult;
begin
  if IsDebuggerPresent > 0 then
  begin
    CanClose := True;
    Exit;
  end;

  dialogResult := MessageDlg('Save asset database before shitting quitting?',
                             mtConfirmation,
                             [mbYes, mbNo, mbCancel], 0);
  case dialogResult of
      mrYes: SaveDB.Click;
      mrCancel: CanClose := False;
  end;
end;

procedure TMainForm.FilterClearClick(Sender: TObject);
begin
  FilterType.ItemIndex := 0;
  FilterName.Clear;

  FilterButton.Click;
end;

procedure TMainForm.FilterButtonClick(Sender: TObject);
begin
  RefreshAssetList;

  SharedProperty.Enabled := False;
  StringGrid.ClearSelections;
end;

procedure TMainForm.AssetAlwaysProcessChange(Sender: TObject);
begin
  MainForm.AssetIgnoreModified.Enabled := not MainForm.AssetAlwaysProcess.Checked;
  if MainForm.AssetAlwaysProcess.Checked then
     MainForm.AssetIgnoreModified.Checked := False;
  selectedAsset.SetAlwaysProcess(MainForm.AssetAlwaysProcess.Checked);
end;

procedure TMainForm.AssetAuthorsClick(Sender: TObject);
begin
  AssetAuthorDialog.ShowModal;
end;

procedure TMainForm.AssetDeleteClick(Sender: TObject);
begin

end;

procedure TMainForm.AboutClick(Sender: TObject);
begin
  AboutDialog := TAboutDialog.Create(self);
  AboutDialog.ShowModal;
  FreeAndNil(AboutDialog);
end;

procedure TMainForm.AddAssetToQueueClick(Sender: TObject);
begin
  if not AssetSelected then Exit;
  AddToQueue(selectedAsset);
end;



procedure ExtractCommandline(path : string; out command: string; out params : string);
begin
  command := path.Trim(' ');
  if command.StartsWith('"') then begin
    command := command.Substring(1);
    params := command.Substring(command.IndexOf('"') + 1);
    command := command.Substring(0, command.IndexOf('"'));
  end else begin
    params := command.Substring(command.IndexOf(' '));
    command := command.Substring(0, command.IndexOf(' '));
  end;
end;

procedure TMainForm.AssetEditClick(Sender: TObject);
var
  path: string;
  command: string;
  parameters: string;
begin
  path := selectedAsset.GetPath;
  // TODO: add windows check
  path := path.Replace('/', '\');

  ExtractCommandline(GetPreference('OPEN_FILE'), command, parameters);
  parameters := parameters.Replace('%path', path);

  ExecuteProcess(command, parameters, []);
end;

procedure TMainForm.AssetShowDirectoryClick(Sender: TObject);
var
  path: string;
  command: string;
  parameters: string;
begin
  if not AssetSelected then Exit;

  path := selectedAsset.GetPath;
  // TODO: add windows check
  path := path.Replace('/', '\');

  ExtractCommandline(GetPreference('SHOW_IN_DIRECTORY'), command, parameters);
  parameters := parameters.Replace('%path', path);

  ExecuteProcess(command, parameters, []);
end;

procedure TMainForm.AssetSourceChange(Sender: TObject);
begin
  if MessageDlg('Confirmation Request',
                'You sure you want to change the source?', mtConfirmation,
                [mbYes, mbNo], 0) = mrNo then Exit;
  selectedAsset.SetSource(AssetSource.Text);
end;

procedure TMainForm.ResetSourceDropdown;
var
  source: TAssetSource;
begin
  AssetSource.Items.Clear;
  for source in GetAllAssetSources do
      AssetSource.Items.Add(source.Identifier);
end;

procedure TMainForm.AssetSourcesClick(Sender: TObject);

begin
  AssetSourceDialog.ShowModal;
  ResetSourceDropdown;
end;

procedure TMainForm.CompileClick(Sender: TObject);
var
  cmd: array of string;
  process: TProcess;
begin
  cmd := SplitCommandline(GetSetting('COMPILE_COMMAND'));

  process := TProcess.Create(nil);
  if Length(cmd) > 0 then
     process.Executable := cmd[0];
  if Length(cmd) > 1 then
     process.Parameters.AddStrings(Copy(cmd, 2));

  // here's an idea of what we could do in the future:
  // 1. create a process runner form
  // 2. when shown, it can be given a command to run
  // 3. it would then run the command and display the standard output in a box
  // 4. it would then close when the process exits

  try
     process.Execute;
  except
      on E : Exception do ShowMessage('An error occured when trying to compile'
                       + ' the program:' + #10#10 + E.ToString);
    end;
end;

procedure TMainForm.EditAssetClick(Sender: TObject);
begin
  AssetEdit.Click;
end;

procedure TMainForm.AssetIgnoreModifiedChange(Sender: TObject);
begin
  selectedAsset.SetIgnoreModified(MainForm.AssetIgnoreModified.Checked);
end;





procedure TMainForm.LoadDBClick(Sender: TObject);
begin
  //LoadDatabaseFromFile;
  RefreshDatabase;
  RefreshAssetList;
end;

procedure TMainForm.MoveAssetClick(Sender: TObject);
begin
  AssetShowDirectory.Click;
end;

procedure TMainForm.OpenLevelEditorClick(Sender: TObject);
var
  cmd: array of string;
  process: TProcess;
begin
  cmd := SplitCommandline(GetSetting('LEVEL_EDITOR_COMMAND'));

  process := TProcess.Create(nil);
  if Length(cmd) > 0 then
     process.Executable := cmd[0];
  if Length(cmd) > 1 then
     process.Parameters.AddStrings(Copy(cmd, 2));

  process.Options := process.Options + [poDetached];

  try
     process.Execute;
  except
      on E : Exception do ShowMessage('An error occured when trying to run'
                       + ' the level editor:' + #10#10 + E.ToString);
    end;
end;

procedure TMainForm.PopupEditClick(Sender: TObject);
begin
  EditAsset.Click;
end;

procedure TMainForm.PopupMoveClick(Sender: TObject);
begin
  MoveAsset.Click;
end;

procedure TMainForm.PopupProcessClick(Sender: TObject);
begin
  AddToAsyncQueue.Click;
end;

procedure TMainForm.PopUpQueueClick(Sender: TObject);
begin
  AddAssetToQueue.Click;
end;

procedure TMainForm.PopupRemoveClick(Sender: TObject);
begin
  RemoveAsset.Click;
end;

procedure TMainForm.PopupShowInExplorerClick(Sender: TObject);
begin
  ShowInExplorer.Click;
end;

procedure TMainForm.PopupViewClick(Sender: TObject);
begin
  ViewAsset.Click;
end;

procedure TMainForm.PreferencesClick(Sender: TObject);
begin
  PreferencesDialog.ShowModal;
end;

procedure TMainForm.ProjectSettingsClick(Sender: TObject);
begin
  //ProjectSettingsDialog := TProjectSettingsDialog.Create(self);
  ProjectSettingsDialog.ShowModal;
  //FreeAndNil(ProjectSettingsDialog);
end;

procedure TMainForm.QuitClick(Sender: TObject);
begin
  self.Close;
end;

procedure TMainForm.RemoveAssetClick(Sender: TObject);
var
  dialogResult: TModalResult;
begin
  dialogResult := MessageDlg('We will delete this asset.',
                             'The asset "' + selectedAsset.GetName
                             + '" will be removed from the database. Do you'
                             + ' want us to remove its file from the disk too?',
                             mtConfirmation,
                             [mbYes, mbNo, mbCancel], 0);
  case dialogResult of
      mrYes: DeleteFile(selectedAsset.GetPath);
      mrNo: ;
      mrCancel: Exit;
  end;

  selectedAsset.Remove;
  //selectedAsset := nil;
  SetSelectedAsset(nil);
  SharedProperty.Enabled := False;
  FilterButton.Click;
end;

procedure TMainForm.RunExecutableClick(Sender: TObject);
var
  cmd: array of string;
  process: TProcess;
begin
  cmd := SplitCommandline(GetSetting('RUN_COMMAND'));

  process := TProcess.Create(nil);
  if Length(cmd) > 0 then
     process.Executable := cmd[0];
  if Length(cmd) > 1 then
     process.Parameters.AddStrings(Copy(cmd, 2));


  process.Options := process.Options + [poDetached];

  try
     process.Execute;
  except
      on E : Exception do ShowMessage('An error occured when trying to run'
                       + ' the program:' + #10#10 + E.ToString);
    end;
end;

procedure TMainForm.SaveDBClick(Sender: TObject);
var
  databaseFile: TAssetWriter;
  asset: TAssetMetadata;
  prop: string;
  author: TAssetAuthor;
  source: TAssetSource;
begin
  databaseFile := TAssetWriter.Create('asset.db');

  databaseFile.Append(['# Tramway SDK Asset Manager Applet Database']);
  databaseFile.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  databaseFile.Append(nil);

  for asset in database.GetAssets do
      if asset.GetDateInDB <> 0 then begin
        databaseFile.Append([asset.GetType,
                             asset.GetName,
                             asset.GetDateOnDisk.ToString]);
        for prop in asset.GetPropertyList do
            databaseFile.Append(['PROPERTY', prop, asset.GetMetadata(prop)]);
        if asset.GetAuthor <> '' then databaseFile.Append(['AUTHOR', asset.GetAuthor]);
        if asset.GetSource <> '' then databaseFile.Append(['SOURCE', asset.GetSource]);
      end;
  for author in GetAllAssetAuthors do begin
    databaseFile.Append(['AUTHOR', author.Identifier, 'IDENTIFIER', author.Identifier]);
    databaseFile.Append(['AUTHOR', author.Identifier, 'NAME', '"' + author.Name + '"']);
    databaseFile.Append(['AUTHOR', author.Identifier, 'ADDRESS', '"' + author.Address + '"']);
    databaseFile.Append(['AUTHOR', author.Identifier, 'ROLE', '"' + author.Role + '"']);
    databaseFile.Append(['AUTHOR', author.Identifier, 'NOTES', '"' + author.Notes + '"']);
  end;
  for source in GetAllAssetSources do begin
    databaseFile.Append(['SOURCE', source.Identifier, 'IDENTIFIER', source.Identifier]);
    databaseFile.Append(['SOURCE', source.Identifier, 'CREDITS', '"' + source.Credits + '"']);
    databaseFile.Append(['SOURCE', source.Identifier, 'ADDRESS', '"' + source.Address + '"']);
    databaseFile.Append(['SOURCE', source.Identifier, 'LICENSE', '"' + source.License + '"']);
    databaseFile.Append(['SOURCE', source.Identifier, 'NOTES', '"' + source.Notes + '"']);
  end;
  databaseFile.Free;
end;

procedure TMainForm.ShowDirectoryClick(Sender: TObject);
var
  command: string;
  parameters: string;
begin
  ExtractCommandline(GetPreference('OPEN_DIRECTORY'), command, parameters);
  // TODO: add windows check
  parameters := parameters.Replace('%path', '.\');

  ExecuteProcess(command, parameters, []);
end;

procedure TMainForm.ShowInExplorerClick(Sender: TObject);
begin
  AssetShowDirectory.Click;
end;

procedure TMainForm.StartProcessQueueClick(Sender: TObject);
begin
  ProcessQueueSync;
end;

procedure TMainForm.StringGridAfterSelection(Sender: TObject; aCol,
  aRow: Integer);
var
  row: Integer;
begin
  row := MainForm.StringGrid.Selection.Bottom;

  SetSelectedAsset(MainForm.StringGrid.Objects[0, row] as TAssetMetadata);

  MainForm.AssetName.Text := selectedAsset.GetName;
  MainForm.AssetType.Text := selectedAsset.GetType;

  MainForm.AssetAlwaysProcess.Checked := selectedAsset.GetAlwaysProcess;
  MainForm.AssetIgnoreModified.Checked := selectedAsset.GetIgnoreModified;

  MainForm.AssetIgnoreModified.Enabled := not selectedAsset.GetAlwaysProcess;

  MainForm.AssetSource.Text := selectedAsset.GetSource;
  MainForm.AssetAuthor.Text := selectedAsset.GetAuthor;

  Mainform.SharedProperty.Enabled := True;
end;

initialization
begin
  database := TAssetDatabase.Create;

  selectedAsset := nil;
end;

end.

