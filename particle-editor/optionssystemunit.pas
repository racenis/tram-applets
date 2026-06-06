unit OptionsSystemUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, Spin, TramParticleAsset;

type

  { TOptionsSystemFrame }

  TOptionsSystemFrame = class(TFrame)
    LimitLabel: TLabel;
    LimitSelect: TSpinEdit;
    ModelLabel: TLabel;
    ModelSelect: TComboBox;
    SpriteSelect: TComboBox;
    WireLabel: TLabel;
    SpriteLabel: TLabel;
    WireSelect: TComboBox;
    procedure LimitSelectChange(Sender: TObject);
    procedure ModelSelectChange(Sender: TObject);
    procedure SpriteSelectChange(Sender: TObject);
    procedure WireSelectChange(Sender: TObject);
  private
    system: TParticleSystem;
  public
    procedure SetSystem(sys: TParticleSystem);
  end;

implementation

{$R *.lfm}

{ TOptionsSystemFrame }

procedure TOptionsSystemFrame.SpriteSelectChange(Sender: TObject);
begin
  system.sprite := SpriteSelect.Text;
end;

procedure TOptionsSystemFrame.ModelSelectChange(Sender: TObject);
begin
  system.model := ModelSelect.Text;
end;

procedure TOptionsSystemFrame.LimitSelectChange(Sender: TObject);
begin
  system.particleLimit := LimitSelect.Value.ToString;
end;

procedure TOptionsSystemFrame.WireSelectChange(Sender: TObject);
begin
  system.wire := WireSelect.Text;
end;

procedure TOptionsSystemFrame.SetSystem(sys: TParticleSystem);
begin
  system := sys;
  SpriteSelect.Text := sys.sprite;
  WireSelect.Text := sys.wire;
  ModelSelect.Text := sys.model;
  LimitSelect.Text := sys.particleLimit;
end;

end.

