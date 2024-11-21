unit RefreshMissingFileDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst,
  TramAssetMetadata;

type

  { TRefreshMissingFileDialog }

  TRefreshMissingFileDialog = class(TForm)
    Remove: TButton;
    IgnoreAll: TButton;
    SelectAll: TCheckBox;
    FileChecklist: TCheckListBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure RemoveClick(Sender: TObject);
    constructor Create(formOwner: TComponent; files: TAssetMetadataArray); overload;
    procedure IgnoreAllClick(Sender: TObject);
    procedure SelectAllChange(Sender: TObject);
  private

  public
    files: TAssetMetadataArray;
  end;

var
  RefreshMissingFileDialog: TRefreshMissingFileDialog;

implementation

{$R *.lfm}

constructor TRefreshMissingFileDialog.Create(formOwner: TComponent; files: TAssetMetadataArray);
var
  assetFile: TAssetMetadata;
  i: Integer;
begin
  inherited Create(formOwner);

  self.files := files;

  for assetFile in self.files do
  begin
    FileChecklist.AddItem(assetFile.GetName, assetFile);
  end;

  FileCheckList.CheckAll(cbChecked);
end;

procedure TRefreshMissingFileDialog.RemoveClick(Sender: TObject);
var
  i: Integer;
begin
 for i := 0 to FileChecklist.Count - 1 do
   (FileChecklist.Items.Objects[i] as TAssetMetadata).Remove;

 self.Close;
end;

procedure TRefreshMissingFileDialog.IgnoreAllClick(Sender: TObject);
begin
  self.Close;
end;

procedure TRefreshMissingFileDialog.SelectAllChange(Sender: TObject);
begin
  if SelectAll.Checked then
     FileCheckList.CheckAll(cbChecked)
  else
     FileCheckList.CheckAll(cbUnchecked);
end;

end.

