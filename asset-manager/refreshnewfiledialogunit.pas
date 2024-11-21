unit RefreshNewFileDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst,
  TramAssetMetadata;

type

  { TRefreshNewFileDialog }

  TRefreshNewFileDialog = class(TForm)
    Label3: TLabel;
    Track: TButton;
    Ignore: TButton;
    SelectAll: TCheckBox;
    FileChecklist: TCheckListBox;
    Label1: TLabel;
    constructor Create(formOwner: TComponent; files: TAssetMetadataArray); overload;
    procedure IgnoreClick(Sender: TObject);
    procedure SelectAllChange(Sender: TObject);
    procedure TrackClick(Sender: TObject);
  private

  public
    files: TAssetMetadataArray;
  end;

var
  RefreshNewFileDialog: TRefreshNewFileDialog;

implementation

{$R *.lfm}

{ TRefreshNewFileDialog }

constructor TRefreshNewFileDialog.Create(formOwner: TComponent; files: TAssetMetadataArray);
var
  assetFile: TAssetMetadata;
begin
  inherited Create(formOwner);

  self.files := files;

  for assetFile in self.files do
  begin
    FileChecklist.AddItem(assetFile.GetName, assetFile);
  end;

  FileCheckList.CheckAll(cbChecked);
end;

procedure TRefreshNewFileDialog.IgnoreClick(Sender: TObject);
begin
  self.Close;
end;

procedure TRefreshNewFileDialog.SelectAllChange(Sender: TObject);
begin
  if SelectAll.Checked then
     FileCheckList.CheckAll(cbChecked)
  else
     FileCheckList.CheckAll(cbUnchecked);
end;

procedure TRefreshNewFileDialog.TrackClick(Sender: TObject);
var
  i: Integer;
begin
 for i := 0 to FileChecklist.Count - 1 do
   (FileChecklist.Items.Objects[i] as TAssetMetadata).SetDateInDBAsOnDisk;

 self.Close;
end;

end.

