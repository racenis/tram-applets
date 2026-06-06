unit OptionsValueUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, TramParticleAsset;

type

  { TOptionsValueFrame }

  TOptionsValueFrame = class(TFrame)
    ValueTypeLabel: TLabel;
    ValueName: TEdit;
    ValueNameLabel: TLabel;
    ValueScalar: TRadioButton;
    ValueVector: TRadioButton;
    procedure ValueNameChange(Sender: TObject);
    procedure ValueScalarClick(Sender: TObject);
    procedure ValueVectorClick(Sender: TObject);
  private
    value: TParticleData;
  public
    procedure SetValue(val: TParticleData);
  end;

implementation

{$R *.lfm}

{ TOptionsValueFrame }

procedure TOptionsValueFrame.ValueScalarClick(Sender: TObject);
begin
  value.dataType := 'scalar';
end;

procedure TOptionsValueFrame.ValueNameChange(Sender: TObject);
begin
  value.dataName := ValueName.Text;
end;

procedure TOptionsValueFrame.ValueVectorClick(Sender: TObject);
begin
  value.dataType := 'vector';
end;

procedure TOptionsValueFrame.SetValue(val: TParticleData);
begin
  value := val;
  ValueName.Text := value.dataName;
  if value.dataType = 'scalar' then ValueScalar.Checked := True;
  if value.dataType = 'vector' then ValueVector.Checked := True;
end;

end.

