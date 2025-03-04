program assetmanager;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, MainFormUnit, MainFormDB, RefreshNewFileDialogUnit,
  RefreshChangeFileDialogUnit, RefreshMissingFileDialogUnit,
  ImportFileDialogUnit, MetadataStaticModelUnit, MetadataDynamicModelUnit,
  MetadataModificationModelUnit, AboutDialogUnit, PreferencesDialogUnit,
  ProjectSettingsDialogUnit, ProcessQueue, AssetQueueDialogUnit,
  AssetSourceDialogUnit, AssetAuthorDialogUnit
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='Tramway SDK Asset Manager';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TRefreshNewFileDialog, RefreshNewFileDialog);
  Application.CreateForm(TRefreshChangeFileDialog, RefreshChangeFileDialog);
  Application.CreateForm(TRefreshMissingFileDialog, RefreshMissingFileDialog);
  Application.CreateForm(TImportFileDialog, ImportFileDialog);
  Application.CreateForm(TAboutDialog, AboutDialog);
  Application.CreateForm(TPreferencesDialog, PreferencesDialog);
  Application.CreateForm(TProjectSettingsDialog, ProjectSettingsDialog);
  Application.CreateForm(TAssetQueueDialog, AssetQueueDialog);
  Application.CreateForm(TAssetAuthorDialog, AssetAuthorDialog);
  Application.CreateForm(TAssetSourceDialog, AssetSourceDialog);
  Application.Run;
end.

