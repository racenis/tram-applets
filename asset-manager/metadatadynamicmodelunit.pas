unit MetadataDynamicModelUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, TramAssetMetadata;

type

  { TMetadataDynamicModel }

  TMetadataDynamicModel = class(TFrame)
    Label1: TLabel;
    constructor Create(TheOwner: TComponent; asset: TAssetMetadata); overload;
  private
    asset: TAssetMetadata;
  public

  end;

implementation

{$R *.lfm}

constructor TMetadataDynamicModel.Create(TheOwner: TComponent; asset: TAssetMetadata);
begin
  inherited Create(TheOwner);
  self.asset := asset;
  Label1.Caption := Label1.Caption + self.asset.GetName;
end;

end.

