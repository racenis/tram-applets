unit NewProjectFrameUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls;

type

  { TNewProjectFrame }

  TNewProjectFrame = class(TFrame)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private

  public
    backToMain: procedure of object;
  end;

implementation

{$R *.lfm}

{ TNewProjectFrame }

procedure TNewProjectFrame.Button1Click(Sender: TObject);
begin
  backToMain();
end;

end.

