unit OptionsEmitterUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, TramParticleAsset,
  OptionsParameterUnit;

type

  { TOptionsEmitterFrame }

  TOptionsEmitterFrame = class(TFrame)
    RateLabel: TLabel;
    DelayLabel: TLabel;
    RatePanel: TPanel;
    DelayPanel: TPanel;
  private
    emitter: TParticleEmitter;
    RateFrame: TOptionsParameter;
    DelayFrame: TOptionsParameter;
  public
    procedure SetEmitter(em: TParticleEmitter);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

{$R *.lfm}

{ TOptionsEmitterFrame }

procedure TOptionsEmitterFrame.SetEmitter(em: TParticleEmitter);
begin
  emitter := em;

  RateFrame.SetParameter(emitter.rate);
  DelayFrame.SetParameter(emitter.delay);
end;

procedure TOptionsEmitterFrame.AfterConstruction;
begin
  inherited AfterConstruction;

  RateFrame := TOptionsParameter.Create(RatePanel);
  DelayFrame := TOptionsParameter.Create(DelayPanel);

  RateFrame.Parent := RatePanel;
  DelayFrame.Parent := DelayPanel;
end;

procedure TOptionsEmitterFrame.BeforeDestruction;
begin
  FreeAndNil(RateFrame);
  FreeAndNil(DelayFrame);

  inherited BeforeDestruction;
end;

end.

