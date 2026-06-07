unit OptionsParameterUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin, TramParticleAsset;

type

  { TOptionsParameter }

  TOptionsParameter = class(TFrame)
    ValueName: TComboBox;
    NumX: TFloatSpinEdit;
    NumY: TFloatSpinEdit;
    NumZ: TFloatSpinEdit;
    TypeVector: TRadioButton;
    TypeScalar: TRadioButton;
    TypeValue: TRadioButton;
    procedure NumXChange(Sender: TObject);
    procedure NumYChange(Sender: TObject);
    procedure NumZChange(Sender: TObject);
    procedure TypeScalarClick(Sender: TObject);
    procedure TypeValueClick(Sender: TObject);
    procedure TypeVectorClick(Sender: TObject);
    procedure ValueNameChange(Sender: TObject);
  private
    parameter: TParticleParameter;
  public
    procedure SetParameter(param: TParticleParameter);
  end;

implementation

{$R *.lfm}

{ TOptionsParameter }

procedure TOptionsParameter.TypeValueClick(Sender: TObject);
begin
  parameter.paramType := 'data';
  SetParameter(parameter);
end;

procedure TOptionsParameter.TypeVectorClick(Sender: TObject);
begin
  parameter.paramType := 'vector';
  SetParameter(parameter);
end;

procedure TOptionsParameter.ValueNameChange(Sender: TObject);
begin
  parameter.data := ValueName.Text;
end;

procedure TOptionsParameter.TypeScalarClick(Sender: TObject);
begin
  parameter.paramType := 'scalar';
  SetParameter(parameter);
end;

procedure TOptionsParameter.NumZChange(Sender: TObject);
begin
  if parameter.paramType <> 'vector' then Exit;
  parameter.z := StringReplace(NumZ.Text, ',', '.', [rfReplaceAll]);
end;

procedure TOptionsParameter.NumYChange(Sender: TObject);
begin
  if parameter.paramType <> 'vector' then Exit;
  parameter.y := StringReplace(NumY.Text, ',', '.', [rfReplaceAll]);
end;

procedure TOptionsParameter.NumXChange(Sender: TObject);
begin
  if (parameter.paramType <> 'scalar') and (parameter.paramType <> 'vector') then Exit;
  parameter.x := StringReplace(NumX.Text, ',', '.', [rfReplaceAll]);
end;

procedure TOptionsParameter.SetParameter(param: TParticleParameter);
begin
  parameter := param;
  if param.paramType = 'none' then begin
    self.Enabled := False;
    Exit;
  end;
  self.Enabled := True;

  if param.paramType = 'data' then begin
    NumX.Visible := False;
    NumY.Visible := False;
    NumZ.Visible := False;
    ValueName.Visible := True;
    ValueName.Text:= param.data;
    TypeValue.Checked := True;
    Exit;
  end;
  NumX.Visible := True;
  NumY.Visible := True;
  NumZ.Visible := True;
  ValueName.Visible := False;
  if param.paramType = 'scalar' then begin
    NumY.Enabled := False;
    NumZ.Enabled := False;
    NumX.Text := param.x;
    NumY.Text := '';
    NumZ.Text := '';
    TypeScalar.Checked := True;
  end;
  if param.paramType = 'vector' then begin
    NumY.Enabled := True;
    NumZ.Enabled := True;
    NumX.Text := param.x;
    NumY.Text := param.y;
    NumZ.Text := param.z;
    TypeVector.Checked := True;
  end;
end;

end.

