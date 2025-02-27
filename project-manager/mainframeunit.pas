unit MainFrameUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, Graphics;

type

   TMethodPtr = procedure of object;

  { TMainFrame }

  TMainFrame = class(TFrame)
    BackgroundImage: TImage;
    VersionNumber: TLabel;
    OpenProjectLinkShadow: TLabel;
    DocumentationLinkShadow: TLabel;
    OpenProjectLink: TLabel;
    DocumentationLink: TLabel;
    SubtitleShadow: TLabel;
    Title: TLabel;
    NewProjectLink: TLabel;
    NewProjectLinkShadow: TLabel;
    Subtitle: TLabel;
    TitleShadow: TLabel;
    procedure DocumentationLinkClick(Sender: TObject);
    procedure DocumentationLinkMouseEnter(Sender: TObject);
    procedure DocumentationLinkMouseLeave(Sender: TObject);
    procedure NewProjectLinkClick(Sender: TObject);
    procedure NewProjectLinkMouseEnter(Sender: TObject);
    procedure NewProjectLinkMouseLeave(Sender: TObject);
    procedure OpenProjectLinkClick(Sender: TObject);
    procedure OpenProjectLinkMouseEnter(Sender: TObject);
    procedure OpenProjectLinkMouseLeave(Sender: TObject);
  public
    constructor Create(TheOwner: TComponent); override;
  private

  public
    newProject: TMethodPtr ;
    openProject: TMethodPtr ;
    documentationProject: TMethodPtr ;
  end;

implementation

{$R *.lfm}

{ TMainFrame }

procedure TMainFrame.NewProjectLinkMouseEnter(Sender: TObject);
begin
  NewProjectLink.Font.Color := TColor($008CFF);
  NewProjectLink.Font.Underline := True;
end;

procedure TMainFrame.OpenProjectLinkMouseEnter(Sender: TObject);
begin
  OpenProjectLink.Font.Color := TColor($008CFF);
  OpenProjectLink.Font.Underline := True;
end;

procedure TMainFrame.DocumentationLinkMouseEnter(Sender: TObject);
begin
  DocumentationLink.Font.Color := TColor($008CFF);
  DocumentationLink.Font.Underline := True;
end;

procedure TMainFrame.DocumentationLinkClick(Sender: TObject);
begin
  documentationProject;
end;

procedure TMainFrame.NewProjectLinkMouseLeave(Sender: TObject);
begin
  NewProjectLink.Font.Color := TColor($00A5FF);
  NewProjectLink.Font.Underline := False;
end;

procedure TMainFrame.OpenProjectLinkClick(Sender: TObject);
begin
  openProject;
end;

procedure TMainFrame.OpenProjectLinkMouseLeave(Sender: TObject);
begin
  OpenProjectLink.Font.Color := TColor($00A5FF);
  OpenProjectLink.Font.Underline := False;
end;

procedure TMainFrame.DocumentationLinkMouseLeave(Sender: TObject);
begin
  DocumentationLink.Font.Color := TColor($00A5FF);
  DocumentationLink.Font.Underline := False;
end;

procedure TMainFrame.NewProjectLinkClick(Sender: TObject);
begin
  newProject;
end;



constructor TMainFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  BackgroundImage.Picture.LoadFromFile('C:\Users\Poga\Desktop\painis\tram-binary\resources\background.jpg');


  Title.Font.Color := TColor($00A5FF);
  Subtitle.Font.Color := TColor($00A5FF);

  NewProjectLink.Font.Color := TColor($00A5FF);
  OpenProjectLink.Font.Color := TColor($00A5FF);
  DocumentationLink.Font.Color := TColor($00A5FF);

  VersionNumber.Font.Color := TColor($00A5FF);
end;

end.

