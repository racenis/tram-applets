unit AboutDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TAboutDialog }

  TAboutDialog = class(TForm)
    CloseDialog: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure CloseDialogClick(Sender: TObject);
  private

  public

  end;

var
  AboutDialog: TAboutDialog;

implementation

{$R *.lfm}

{ TAboutDialog }

procedure TAboutDialog.CloseDialogClick(Sender: TObject);
begin
  self.Close;
end;

end.

