unit OptionsConstraintUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, TramParticleAsset,
  OptionsParameterUnit;

type

  { TOptionsConstraintFrame }

  TOptionsConstraintFrame = class(TFrame)
    ConstraintType: TComboBox;
    MergeDestAny: TRadioButton;
    MergeDestLabel: TLabel;
    MergeDestPanel: TPanel;
    MergeDestX: TRadioButton;
    MergeDestY: TRadioButton;
    MergeDestZ: TRadioButton;
    CtTypeLabel: TLabel;
    Param1Name: TEdit;
    Param1Panel: TPanel;
    Param2Name: TEdit;
    Param2Panel: TPanel;
    Param3Name: TEdit;
    Param3Panel: TPanel;
    Param4Name: TEdit;
    Param4Panel: TPanel;
    TargetLabel: TLabel;
    TargetSelect: TComboBox;
    procedure MergeDestAnyClick(Sender: TObject);
    procedure MergeDestXClick(Sender: TObject);
    procedure MergeDestYClick(Sender: TObject);
    procedure MergeDestZClick(Sender: TObject);
    procedure ConstraintTypeChange(Sender: TObject);
    procedure TargetSelectChange(Sender: TObject);
  private
    constraint: TParticleConstraint;
    Param1Frame: TOptionsParameter;
    Param2Frame: TOptionsParameter;
    Param3Frame: TOptionsParameter;
    Param4Frame: TOptionsParameter;
  public
    procedure SetConstraint(ct: TParticleConstraint);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

{$R *.lfm}

uses
  MainFormUnit;

{ TOptionsConstraintFrame }

procedure TOptionsConstraintFrame.ConstraintTypeChange(Sender: TObject);
begin
  constraint.ctType := ConstraintType.Text;
  MainForm.OperationList.Items.Strings[MainForm.OperationList.ItemIndex] := ConstraintType.Text;
  constraint.ToggleParams;
  SetConstraint(constraint);
end;

procedure TOptionsConstraintFrame.TargetSelectChange(Sender: TObject);
begin
  constraint.target := TargetSelect.Text;
end;

procedure TOptionsConstraintFrame.MergeDestAnyClick(Sender: TObject);
begin
  constraint.mergeDest := 'any';
end;

procedure TOptionsConstraintFrame.MergeDestXClick(Sender: TObject);
begin
  constraint.mergeDest := 'x';
end;

procedure TOptionsConstraintFrame.MergeDestYClick(Sender: TObject);
begin
  constraint.mergeDest := 'y';
end;

procedure TOptionsConstraintFrame.MergeDestZClick(Sender: TObject);
begin
  constraint.mergeDest := 'z';
end;

procedure TOptionsConstraintFrame.SetConstraint(ct: TParticleConstraint);
begin
  constraint := ct;
  TargetSelect.Text := ct.target;
  ConstraintType.Text := ct.ctType;
  if ct.mergeDest = 'any' then MergeDestAny.Checked := True;
  if ct.mergeDest = 'x' then MergeDestX.Checked := True;
  if ct.mergeDest = 'y' then MergeDestY.Checked := True;
  if ct.mergeDest = 'z' then MergeDestZ.Checked := True;

  Param1Frame.SetParameter(ct.param1);
  Param2Frame.SetParameter(ct.param2);
  Param3Frame.SetParameter(ct.param3);
  Param4Frame.SetParameter(ct.param4);

  Param1Name.Text := ct.GetParamName(1);
  Param2Name.Text := ct.GetParamName(2);
  Param3Name.Text := ct.GetParamName(3);
  Param4Name.Text := ct.GetParamName(4);
end;

procedure TOptionsConstraintFrame.AfterConstruction;
begin
  inherited AfterConstruction;

  Param1Frame := TOptionsParameter.Create(Param1Panel);
  Param2Frame := TOptionsParameter.Create(Param2Panel);
  Param3Frame := TOptionsParameter.Create(Param3Panel);
  Param4Frame := TOptionsParameter.Create(Param4Panel);

  Param1Frame.Parent := Param1Panel;
  Param2Frame.Parent := Param2Panel;
  Param3Frame.Parent := Param3Panel;
  Param4Frame.Parent := Param4Panel;
end;

procedure TOptionsConstraintFrame.BeforeDestruction;
begin
  FreeAndNil(Param1Frame);
  FreeAndNil(Param2Frame);
  FreeAndNil(Param3Frame);
  FreeAndNil(Param4Frame);

  inherited BeforeDestruction;
end;

end.

