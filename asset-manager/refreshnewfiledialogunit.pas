unit RefreshNewFileDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, CheckLst,
  TramAssetMetadata, PreferencesDialogUnit;

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
    addedFiles: TAssetMetadataArray;
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
  self.addedFiles := [];

  for assetFile in self.files do
  begin
    FileChecklist.AddItem(assetFile.GetPath.Substring(assetFile.GetPath.IndexOf(assetFile.GetName)), assetFile);
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
  asset: TAssetMetadata;
begin
 for i := 0 to FileChecklist.Count - 1 do begin

   if not FileChecklist.Checked[i] then Continue;

   asset := FileChecklist.Items.Objects[i] as TAssetMetadata;
   asset.SetDateInDBAsOnDisk;
   asset.SetAuthor(GetPreference('USER_IDENTIFIER'));

   self.addedFiles := Concat(self.addedFiles, [asset]);
 end;

 self.Close;
end;

end.

