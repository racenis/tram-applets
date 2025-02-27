unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  StdCtrls, MainFrameUnit, NewProjectFrameUnit, OpenProjectFrameUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    BackgroundImage: TImage;
    procedure FormCreate(Sender: TObject);
  private

  public
    procedure NewProject;
    procedure OpenProject;
    procedure Documentation;
    procedure BackToMain;

  end;

var
  activeFrame: TFrame;
  MainForm: TMainForm;

  mainFrame: TMainFrame;
  newProjectFrame: TNewProjectFrame;
  openProjectFrame: TOpenProjectFrame;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //BackgroundImage.Picture.LoadFromFile('C:\Users\Poga\Desktop\painis\tram-binary\resources\background.jpg');

  mainFrame := TMainFrame.Create(self);
  mainFrame.newProject := @self.NewProject;
  mainFrame.openProject := @self.OpenProject;
  mainFrame.documentationProject := @self.Documentation;

  newProjectFrame := TNewProjectFrame.Create(self);
  newProjectFrame.backToMain := @self.BackToMain;

  openProjectFrame := TOpenProjectFrame.Create(self);
  openProjectFrame.backToMain := @self.BackToMain;

  activeFrame := mainFrame;

  mainFrame.Parent := self;

end;

procedure TMainForm.NewProject;
begin
  //TThread.ForceQueue(nil, activeFrame.Free);
  //activeFrame.Free;
  activeFrame.Parent := nil;
  activeFrame := newProjectFrame;
  activeFrame.Parent := self;
end;

procedure TMainForm.OpenProject;
begin
  activeFrame.Parent := nil;
  activeFrame := openProjectFrame;
  activeFrame.Parent := self;
end;

procedure TMainForm.Documentation;
begin

end;

procedure TMainForm.BackToMain;
begin
  activeFrame.Parent := nil;
  activeFrame := mainFrame;
  activeFrame.Parent := self;
end;

end.

