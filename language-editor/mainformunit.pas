unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, AboutDialogUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    ListBox1: TListBox;
    LanguageList: TEdit;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    HelpMenu: TMenuItem;
    AboutMenu: TMenuItem;
    Quit: TMenuItem;
    NewSprite: TMenuItem;
    Separator1: TMenuItem;
    StatusBar1: TStatusBar;
    procedure AboutMenuClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.AboutMenuClick(Sender: TObject);
begin
  AboutDialog.Show;
end;

procedure TMainForm.QuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

end.

