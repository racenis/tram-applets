unit MetadataStaticModelUnit;

{$mode ObjFPC}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, TramAssetMetadata,
  Dialogs;

type

  { TMetadataStaticModel }

  TMetadataStaticModel = class(TFrame)
    CalculateLayout: TButton;
    ApproximateSize: TEdit;
    LightmapWidth: TComboBox;
    LightmapHeight: TComboBox;
    ModelHeader: TEdit;
    VertexCount: TEdit;
    TriangleCount: TEdit;
    MaterialCount: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Materials: TListBox;
    procedure CalculateLayoutClick(Sender: TObject);
    constructor Create(TheOwner: TComponent; asset: TAssetMetadata); overload;
    procedure LightmapHeightChange(Sender: TObject);
    procedure LightmapWidthChange(Sender: TObject);
    procedure MaterialsSelectionChange(Sender: TObject; User: boolean);
  private
    asset: TAssetMetadata;
  public

  end;

implementation

{$R *.lfm}

constructor TMetadataStaticModel.Create(TheOwner: TComponent; asset: TAssetMetadata);
var
  material: Integer;
begin
  inherited Create(TheOwner);
  self.asset := asset;

  asset.LoadMetadata;

  ModelHeader.Text := asset.GetMetadata('MODEL_HEADER');
  ApproximateSize.Text := asset.GetMetadata('APPROX_SIZE');

  VertexCount.Text := asset.GetMetadata('VERTICES');
  TriangleCount.Text := asset.GetMetadata('TRIANGLES');
  MaterialCount.Text := asset.GetMetadata('MATERIALS');

  LightmapWidth.Text := asset.GetMetadata('LIGHTMAP_WIDTH');
  LightmapHeight.Text := asset.GetMetadata('LIGHTMAP_HEIGHT');

  if asset.GetMetadata('LIGHTMAP_WIDTH') = 0 then LightmapWidth.ItemIndex := 0;
  if asset.GetMetadata('LIGHTMAP_HEIGHT') = 0 then LightmapHeight.ItemIndex := 0;

  for material := 0 to asset.GetMetadata('MATERIALS') - 1 do
      Materials.AddItem(asset.GetMetadata('MATERIAL' + material.ToString), nil);


end;

procedure TMetadataStaticModel.CalculateLayoutClick(Sender: TObject);
begin
  ShowMessage('Not implemented yet.')
end;

procedure TMetadataStaticModel.LightmapHeightChange(Sender: TObject);
var
  size: Integer;
begin
  if LightmapHeight.ItemIndex = 0 then
     size := 0
  else
     size := LightmapHeight.Items[LightmapHeight.ItemIndex].ToInteger;
  asset.SetMetadata('LIGHTMAP_HEIGHT', size);
end;

procedure TMetadataStaticModel.LightmapWidthChange(Sender: TObject);
var
  size: Integer;
begin
  if LightmapWidth.ItemIndex = 0 then
     size := 0
  else
     size := LightmapWidth.Items[LightmapWidth.ItemIndex].ToInteger;
  asset.SetMetadata('LIGHTMAP_WIDTH', size);
end;

procedure TMetadataStaticModel.MaterialsSelectionChange(Sender: TObject;
  User: boolean);
begin
  Materials.ClearSelection;
end;


end.

