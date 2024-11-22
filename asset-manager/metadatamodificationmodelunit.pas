unit MetadataModificationModelUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ComCtrls, TramAssetMetadata;

type

  { TMetadataModificationModel }

  TMetadataModificationModel = class(TFrame)
    ApproximateSize: TEdit;
    BaseModel: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Mappings: TListView;
    ModelHeader: TEdit;
    constructor Create(TheOwner: TComponent; asset: TAssetMetadata); overload;
  private
    asset: TAssetMetadata;
  public

  end;

implementation

{$R *.lfm}

constructor TMetadataModificationModel.Create(TheOwner: TComponent; asset: TAssetMetadata);
var
  mapping: Integer;
  item: TListItem;
begin
  inherited Create(TheOwner);
  self.asset := asset;

  asset.LoadMetadata;

  ModelHeader.Text := asset.GetMetadata('MODEL_HEADER');
  ApproximateSize.Text := asset.GetMetadata('APPROX_SIZE');

  BaseModel.Text := asset.GetMetadata('BASE_MODEL');

  for mapping := 0 to asset.GetMetadata('MAPPINGS') - 1 do
  begin
    //Mappings.AddItem(asset.GetMetadata('MAPPING_FROM' + mapping.ToString), nil);
    item := Mappings.Items.Add;
    item.Caption := asset.GetMetadata('MAPPING_FROM' + mapping.ToString);
    item.SubItems.Add(asset.GetMetadata('MAPPING_TO' + mapping.ToString));
  end;

end;

end.

