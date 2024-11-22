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
  MetadataModificationModelUnit
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TRefreshNewFileDialog, RefreshNewFileDialog);
  Application.CreateForm(TRefreshChangeFileDialog, RefreshChangeFileDialog);
  Application.CreateForm(TRefreshMissingFileDialog, RefreshMissingFileDialog);
  Application.CreateForm(TImportFileDialog, ImportFileDialog);
  Application.Run;
end.
