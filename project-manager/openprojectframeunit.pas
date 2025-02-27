unit OpenProjectFrameUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls;

type

  { TOpenProjectFrame }

  TOpenProjectFrame = class(TFrame)
    BackgroundImage: TImage;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private

  public
    constructor Create(TheOwner: TComponent); override;
  public
    backToMain: procedure of object;
  end;

implementation

{$R *.lfm}

{ TOpenProjectFrame }

procedure TOpenProjectFrame.Button1Click(Sender: TObject);
begin
  backToMain;
end;

constructor TOpenProjectFrame.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  BackgroundImage.Picture.LoadFromFile('C:\Users\Poga\Desktop\painis\tram-binary\resources\background.jpg');
end;

end.

