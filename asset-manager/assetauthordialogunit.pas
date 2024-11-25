unit AssetAuthorDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Menus;

type

  { TAssetAuthorDialog }

  TAssetAuthor = class;
  TAssetAuthorArray = array of TAssetAuthor;
  TAssetAuthorDialog = class(TForm)
    CloseDialog: TButton;
    AuthorIdentifier: TEdit;
    AuthorName: TEdit;
    AuthorAddress: TEdit;
    AuthorRole: TEdit;
    AuthorList: TListBox;
    AuthorNotes: TMemo;
    procedure AuthorListSelectionChange(Sender: TObject; User: boolean);
    procedure CloseDialogClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

  TAssetAuthor = class
  private
    authorIdentifier: string;
    authorName: string;
    authorAddress: string;
    authorRole: string;
    authorNotes: string;
  public
    property Identifier: string read authorIdentifier write authorIdentifier;
    property Name: string read authorName write authorName;
    property Address: string read authorAddress write authorAddress;
    property Role: string read authorRole write authorRole;
    property Notes: string read authorNotes write authorNotes;
  end;

function FindAssetAuthor(identifier: string): TAssetAuthor;
function GetAllAssetAuthors(): TAssetAuthorArray;

var
  AssetAuthorDialog: TAssetAuthorDialog;

implementation

{$R *.lfm}

{ TAssetAuthorDialog }

var
  assetAuthors: TAssetAuthorArray;
  selectedAuthor: TAssetAuthor;


function FindAssetAuthor(identifier: string): TAssetAuthor;
var
  candidate: TAssetAuthor;
  selected: TAssetAuthor;
begin
  selected := nil;
  for candidate in assetAuthors do
      if candidate.Identifier = identifier then selected := candidate;

  if selected <> nil then Exit(selected);

  selected := TAssetAuthor.Create;
  selected.Identifier := identifier;

  SetLength(assetAuthors, Length(assetAuthors) + 1);
  assetAuthors[High(assetAuthors)] := selected;

  Result := selected;
end;

function GetAllAssetAuthors(): TAssetAuthorArray;
begin
  Result := assetAuthors;
end;

procedure TAssetAuthorDialog.FormCreate(Sender: TObject);
var
  author: TAssetAuthor;
begin
  AuthorList.Clear;
  for author in assetAuthors do
      AuthorList.AddItem(author.Identifier, author);
  selectedAuthor := nil;
end;

procedure TAssetAuthorDialog.CloseDialogClick(Sender: TObject);
begin
  Close;
end;

procedure TAssetAuthorDialog.AuthorListSelectionChange(Sender: TObject;
  User: boolean);
begin
  if AuthorList.ItemIndex < 0 then Exit;
  selectedAuthor := assetAuthors[AuthorList.ItemIndex];

  AuthorIdentifier.Text := selectedAuthor.Identifier;
  AuthorName.Text := selectedAuthor.Name;
  AuthorAddress.Text := selectedAuthor.Address;
  AuthorRole.Text := selectedAuthor.Role;
  AuthorNotes.Text := selectedAuthor.Notes;
end;

end.

