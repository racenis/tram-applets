unit OptionsOperationUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, TramParticleAsset,
  OptionsParameterUnit;

type

  { TOptionsOperationFrame }

  TOptionsOperationFrame = class(TFrame)
    TargetSelect: TComboBox;
    TargetLabel: TLabel;
    Param1Panel: TPanel;
    Param2Panel: TPanel;
    Param3Panel: TPanel;
    Param4Panel: TPanel;
    Param2Name: TEdit;
    Param3Name: TEdit;
    Param4Name: TEdit;
    Param1Name: TEdit;
    OpTypeLabel: TLabel;
    MergeTypeLabel: TLabel;
    MergeDestLabel: TLabel;
    MergeType: TComboBox;
    OperationType: TComboBox;
    MergeDestPanel: TPanel;
    MergeDestAny: TRadioButton;
    MergeDestX: TRadioButton;
    MergeDestY: TRadioButton;
    MergeDestZ: TRadioButton;
    procedure MergeDestAnyClick(Sender: TObject);
    procedure MergeDestXClick(Sender: TObject);
    procedure MergeDestYClick(Sender: TObject);
    procedure MergeDestZClick(Sender: TObject);
    procedure MergeTypeChange(Sender: TObject);
    procedure OperationTypeChange(Sender: TObject);
    procedure TargetSelectChange(Sender: TObject);
  private
    operation: TParticleOperation;
    Param1Frame: TOptionsParameter;
    Param2Frame: TOptionsParameter;
    Param3Frame: TOptionsParameter;
    Param4Frame: TOptionsParameter;
  public
    procedure SetOperation(op: TParticleOperation);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

{$R *.lfm}

uses
  MainFormUnit;

{ TOptionsOperationFrame }

procedure TOptionsOperationFrame.MergeDestAnyClick(Sender: TObject);
begin
  operation.mergeDest := 'any';
end;

procedure TOptionsOperationFrame.MergeDestXClick(Sender: TObject);
begin
  operation.mergeDest := 'x';
end;

procedure TOptionsOperationFrame.MergeDestYClick(Sender: TObject);
begin
  operation.mergeDest := 'y';
end;

procedure TOptionsOperationFrame.MergeDestZClick(Sender: TObject);
begin
  operation.mergeDest := 'z';
end;

procedure TOptionsOperationFrame.MergeTypeChange(Sender: TObject);
begin
  operation.mergeType := MergeType.Text;
end;

procedure TOptionsOperationFrame.OperationTypeChange(Sender: TObject);
begin
  operation.opType := OperationType.Text;
  MainForm.OperationList.Items.Strings[MainForm.OperationList.ItemIndex] := OperationType.Text;
  operation.ToggleParams;
  SetOperation(operation);
end;

procedure TOptionsOperationFrame.TargetSelectChange(Sender: TObject);
begin
  operation.target := TargetSelect.Text;
end;

procedure TOptionsOperationFrame.SetOperation(op: TParticleOperation);
begin
  operation := op;
  TargetSelect.Text := op.target;
  OperationType.Text := op.opType;
  MergeType.Text := op.mergeType;
  if op.mergeDest = 'any' then MergeDestAny.Checked := True;
  if op.mergeDest = 'x' then MergeDestX.Checked := True;
  if op.mergeDest = 'y' then MergeDestY.Checked := True;
  if op.mergeDest = 'z' then MergeDestZ.Checked := True;

  Param1Frame.SetParameter(op.param1);
  Param2Frame.SetParameter(op.param2);
  Param3Frame.SetParameter(op.param3);
  Param4Frame.SetParameter(op.param4);

  Param1Name.Text := op.GetParamName(1);
  Param2Name.Text := op.GetParamName(2);
  Param3Name.Text := op.GetParamName(3);
  Param4Name.Text := op.GetParamName(4);
end;

procedure TOptionsOperationFrame.AfterConstruction;
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

procedure TOptionsOperationFrame.BeforeDestruction;
begin
  FreeAndNil(Param1Frame);
  FreeAndNil(Param2Frame);
  FreeAndNil(Param3Frame);
  FreeAndNil(Param4Frame);

  inherited BeforeDestruction;
end;

end.

