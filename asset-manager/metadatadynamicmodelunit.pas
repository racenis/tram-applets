unit MetadataDynamicModelUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, TramAssetMetadata;

type

  { TMetadataDynamicModel }

  TMetadataDynamicModel = class(TFrame)
    ApproximateSize: TEdit;
    BoneCount: TEdit;
    VertexGroupCount: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    VertexGroups: TListBox;
    Materials: TListBox;
    MaterialCount: TEdit;
    TriangleCount: TEdit;
    VertexCount: TEdit;
    ModelHeader: TEdit;
    constructor Create(TheOwner: TComponent; asset: TAssetMetadata); overload;
    procedure MaterialsSelectionChange(Sender: TObject; User: boolean);
  private
    asset: TAssetMetadata;
  public

  end;

implementation

{$R *.lfm}

constructor TMetadataDynamicModel.Create(TheOwner: TComponent; asset: TAssetMetadata);
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
  BoneCount.Text := asset.GetMetadata('BONES');
  VertexGroupCount.Text := asset.GetMetadata('VERTEX_GROUPS');

  for material := 0 to asset.GetMetadata('MATERIALS') - 1 do
      Materials.AddItem(asset.GetMetadata('MATERIAL' + material.ToString), nil);
end;

procedure TMetadataDynamicModel.MaterialsSelectionChange(Sender: TObject;
  User: boolean);
begin
  Materials.ClearSelection;
end;

end.

