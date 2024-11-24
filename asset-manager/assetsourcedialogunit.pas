unit AssetSourceDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus;

type

  { TAssetSourceDialog }

  TAssetSource = class;
  TAssetSourceArray = array of TAssetSource;
  TAssetSourceDialog = class(TForm)
    EnableEditing: TCheckBox;
    CloseDialog: TButton;
    AssetSourcePopup: TPopupMenu;
    AddAssetSource: TMenuItem;
    RemoveAssetSource: TMenuItem;
    SourceLicense: TComboBox;
    SourceIdentifier: TEdit;
    SourceAddress: TEdit;
    SourceCredits: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SourceList: TListBox;
    SourceNotes: TMemo;
    procedure AddAssetSourceClick(Sender: TObject);
    procedure CloseDialogClick(Sender: TObject);
    procedure EnableEditingChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RemoveAssetSourceClick(Sender: TObject);
    procedure SourceAddressChange(Sender: TObject);
    procedure SourceCreditsChange(Sender: TObject);
    procedure SourceIdentifierChange(Sender: TObject);
    procedure SourceLicenseChange(Sender: TObject);
    procedure SourceListSelectionChange(Sender: TObject; User: boolean);
    procedure SourceNotesChange(Sender: TObject);
    procedure RefreshSourceList;
  private

  public

  end;

  TAssetSource = class
  private
    sourceIdentifier: string;
    sourceAddress: string;
    sourceLicense: string;
    sourceCredits: string;
    sourceNotes: string;
  public
    property Identifier: string read sourceIdentifier write sourceIdentifier;
    property Address: string read sourceAddress write sourceAddress;
    property License: string read sourceLicense write sourceLicense;
    property Credits: string read sourceCredits write sourceCredits;
    property Notes: string read sourceNotes write sourceNotes;

  end;

function FindAssetSource(identifier: string): TAssetSource;
function GetAllAssetSources(): TAssetSourceArray;

var
  AssetSourceDialog: TAssetSourceDialog;

implementation

{$R *.lfm}

{ TAssetSourceDialog }

var
  assetSources: TAssetSourceArray;
  selectedSource: TAssetSource;

function FindAssetSource(identifier: string): TAssetSource;
var
  candidate: TAssetSource;
  selected: TAssetSource;
begin
  selected := nil;
  for candidate in assetSources do
      if candidate.Identifier = identifier then selected := candidate;

  if selected <> nil then Exit(selected);

  selected := TAssetSource.Create;
  selected.Identifier := identifier;

  SetLength(assetSources, Length(assetSources) + 1);
  assetSources[High(assetSources)] := selected;

  Result := selected;
end;

function GetAllAssetSources(): TAssetSourceArray;
begin
  Result := assetSources;
end;

procedure TAssetSourceDialog.RefreshSourceList;
var
  asset: TAssetSource;
begin
  SourceList.Clear;
  for asset in assetSources do
      SourceList.AddItem(asset.Identifier, asset);
  selectedSource := nil;
  EnableEditing.Checked := False
end;

procedure TAssetSourceDialog.CloseDialogClick(Sender: TObject);
begin
  EnableEditing.Checked := False;
  SourceList.ClearSelection;
  Close;
end;

procedure TAssetSourceDialog.EnableEditingChange(Sender: TObject);
begin
  if selectedSource = nil then begin
    EnableEditing.Checked := False;
    Exit;
  end;
  SourceIdentifier.Enabled := EnableEditing.Checked;
  SourceAddress.Enabled := EnableEditing.Checked;
  SourceCredits.Enabled := EnableEditing.Checked;
  SourceLicense.Enabled := EnableEditing.Checked;
  SourceNotes.Enabled := EnableEditing.Checked;
end;

procedure TAssetSourceDialog.FormCreate(Sender: TObject);
begin
  RefreshSourceList;
end;

procedure TAssetSourceDialog.RemoveAssetSourceClick(Sender: TObject);
var
  index: Integer;
  sourceIndex: Integer;
begin
  if selectedSource = nil then begin
    ShowMessage('Hello, pls select something first thanks.');
    Exit;
  end;
  if MessageDlg('Confirmation Request',
                'You sure you want to delete the asset source identified to us'
                + ' as ' + selectedSource.Identifier + '?', mtConfirmation,
                [mbYes, mbNo], 0) = mrNo then Exit;

  for index := 0 to High(assetSources) do
      if assetSources[index] = selectedSource then sourceIndex := index;
  for index := sourceIndex to High(assetSources) - 1 do
      assetSources[index] := assetSources[index + 1];

  SetLength(assetSources, Length(assetSources) - 1);
  selectedSource := nil;
end;

procedure TAssetSourceDialog.SourceAddressChange(Sender: TObject);
begin
  selectedSource.Address := SourceAddress.Text;
end;

procedure TAssetSourceDialog.SourceCreditsChange(Sender: TObject);
begin
  selectedSource.Credits := SourceCredits.Text;
end;

procedure TAssetSourceDialog.SourceIdentifierChange(Sender: TObject);
begin
  // TODO: add validation -> that there is no other such identifier
  selectedSource.Identifier := SourceIdentifier.Text;
  //RefreshSourceList;
end;

procedure TAssetSourceDialog.SourceLicenseChange(Sender: TObject);
begin
  selectedSource.License := SourceLicense.Text;
end;

procedure TAssetSourceDialog.SourceListSelectionChange(Sender: TObject;
  User: boolean);
begin
  if SourceList.ItemIndex < 0 then Exit;
  selectedSource := assetSources[SourceList.ItemIndex];
  SourceIdentifier.Text := selectedSource.Identifier;
  SourceAddress.Text := selectedSource.Address;
  SourceLicense.Text := selectedSource.License;
  SourceCredits.Text := selectedSource.Credits;
  SourceNotes.Text := selectedSource.Notes;
end;


procedure TAssetSourceDialog.SourceNotesChange(Sender: TObject);
begin
  selectedSource.Notes := SourceNotes.Text;
end;

procedure TAssetSourceDialog.AddAssetSourceClick(Sender: TObject);
var
  identifier : string;
begin
  if not InputQuery('What', 'What the identifier, chief?', identifier) then Exit;
  FindAssetSource(identifier);
  RefreshSourceList;
end;

initialization
begin
  assetSources := [];
  selectedSource := nil;
end;

end.

