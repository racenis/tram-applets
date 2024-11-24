unit AssetAuthorDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TAssetAuthorDialog }

  TAssetAuthorDialog = class(TForm)
    CloseDialog: TButton;
    AuthorUsername: TEdit;
    AuthorName: TEdit;
    AuthorEmail: TEdit;
    AuthorRole: TEdit;
    AuthorList: TListBox;
    AuthorNotes: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  AssetAuthorDialog: TAssetAuthorDialog;

implementation

{$R *.lfm}

{ TAssetAuthorDialog }

procedure TAssetAuthorDialog.FormCreate(Sender: TObject);
begin

end;

end.

