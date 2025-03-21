unit RefreshChangeFileDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst,
  TramAssetMetadata, ProcessQueue;

type

  { TRefreshChangeFileDialog }

  TRefreshChangeFileDialog = class(TForm)
    Remember: TCheckBox;
    NoReprocess: TButton;
    Reprocess: TButton;
    IgnoreAll: TButton;
    SelectAll: TCheckBox;
    FileChecklist: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure NoReprocessClick(Sender: TObject);
    procedure ReprocessClick(Sender: TObject);
    constructor Create(formOwner: TComponent; files: TAssetMetadataArray); overload;
    procedure IgnoreAllClick(Sender: TObject);
    procedure SelectAllChange(Sender: TObject);
  private

  public
    files: TAssetMetadataArray;
  end;

var
  RefreshChangeFileDialog: TRefreshChangeFileDialog;

implementation

{$R *.lfm}

constructor TRefreshChangeFileDialog.Create(formOwner: TComponent; files: TAssetMetadataArray);
var
  assetFile: TAssetMetadata;
begin
  inherited Create(formOwner);

  self.files := files;

  for assetFile in self.files do
  begin
    FileChecklist.AddItem(assetFile.GetPath.Substring(assetFile.GetPath.IndexOf(assetFile.GetName)), assetFile);
  end;

  FileCheckList.CheckAll(cbChecked);
end;

procedure TRefreshChangeFileDialog.ReprocessClick(Sender: TObject);
var
  i: Integer;
begin
 for i := 0 to FileChecklist.Count - 1 do
     if FileChecklist.Checked[i] then
        AddToQueue(FileChecklist.Items.Objects[i] as TAssetMetadata);

 self.Close;
end;

procedure TRefreshChangeFileDialog.NoReprocessClick(Sender: TObject);
var
  i: Integer;
begin
 for i := 0 to FileChecklist.Count - 1 do
     if FileChecklist.Checked[i] then
        (FileChecklist.Items.Objects[i] as TAssetMetadata).SetDateInDBAsOnDisk;

 self.Close;
end;

procedure TRefreshChangeFileDialog.IgnoreAllClick(Sender: TObject);
begin
  self.Close;
end;

procedure TRefreshChangeFileDialog.SelectAllChange(Sender: TObject);
begin
  if SelectAll.Checked then
     FileCheckList.CheckAll(cbChecked)
  else
     FileCheckList.CheckAll(cbUnchecked);
end;

end.

