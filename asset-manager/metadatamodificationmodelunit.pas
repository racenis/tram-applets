unit MetadataModificationModelUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, TramAssetMetadata;

type

  { TMetadataModificationModel }

  TMetadataModificationModel = class(TFrame)
    Label1: TLabel;
    constructor Create(TheOwner: TComponent; asset: TAssetMetadata); overload;
  private
    asset: TAssetMetadata;
  public

  end;

implementation

{$R *.lfm}

constructor TMetadataModificationModel.Create(TheOwner: TComponent; asset: TAssetMetadata);
begin
  inherited Create(TheOwner);
  self.asset := asset
end;

end.

