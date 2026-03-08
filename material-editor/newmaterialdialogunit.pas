unit NewMaterialDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  TramMaterialAsset, TramTextureAsset, Generics.Collections, TramAssetMetadata;

type
  TStrBoolDictionary = specialize TDictionary<string, Boolean>;

  { TNewMaterialDialog }

  TNewMaterialDialog = class(TForm)
    AcceptMaterial: TButton;
    CancelMaterial: TButton;
    TextureListFilter: TEdit;
    TextureList: TListBox;
    procedure AcceptMaterialClick(Sender: TObject);
    procedure CancelMaterialClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TextureListFilterChange(Sender: TObject);
  private
    existingMaterials: TMaterialDataList;
    textureCollection: TTextureCollection;
    selectedMaterial: string;
    suggestedMaterials: TStringList;
  public
    procedure AddMaterial(newMaterial: TMaterialData);
    procedure Refresh;
    function GetSelectedMaterial: string;
  end;

var
  NewMaterialDialog: TNewMaterialDialog;

implementation

{$R *.lfm}

{ TNewMaterialDialog }

procedure TNewMaterialDialog.FormCreate(Sender: TObject);
begin
  existingMaterials := TMaterialDataList.Create;
  suggestedMaterials := TStringList.Create;
end;

procedure TNewMaterialDialog.TextureListFilterChange(Sender: TObject);
var
  suggestion: string;
begin
  TextureList.Clear;
  for suggestion in suggestedMaterials do
      if (TextureListFilter.Text = '') or suggestion.Contains(TextureListFilter.Text) then
         TextureList.AddItem(suggestion, nil);
end;

procedure TNewMaterialDialog.AddMaterial(newMaterial: TMaterialData);
begin
  existingMaterials.Add(newMaterial);
end;

procedure TNewMaterialDialog.Refresh;
var
  texture: TAssetMetadata;
  material: TMaterialData;
  dict: TStrBoolDictionary;
begin
  textureCollection := TTextureCollection.Create;
  textureCollection.ScanFromDisk;

  // we'll mark all existing materials in here
  dict := TStrBoolDictionary.Create;

  for material in existingMaterials do
      dict.AddOrSetValue(material.name, True);

  suggestedMaterials.Clear;

  for texture in textureCollection.GetAssets do
      if not dict.ContainsKey(texture.GetName) then
         suggestedMaterials.Add(texture.GetName);

  textureCollection.Free;
  dict.Free;

  if suggestedMaterials.Count = 0 then begin
    TextureList.AddItem('No textures without material records found.', nil);
    TextureList.Enabled := False;
    AcceptMaterial.Enabled := False;
  end else begin
    TextureList.Enabled := True;
    AcceptMaterial.Enabled := True;
  end;

  TextureListFilterChange(self);
end;

function TNewMaterialDialog.GetSelectedMaterial: string;
begin
  Result := selectedMaterial;
end;

procedure TNewMaterialDialog.CancelMaterialClick(Sender: TObject);
begin
  existingMaterials.Clear;
  selectedMaterial := '';
  Close;
end;

procedure TNewMaterialDialog.AcceptMaterialClick(Sender: TObject);
begin
  existingMaterials.Clear;
  selectedMaterial := TextureList.Items[TextureList.ItemIndex] ;
  Close;
end;

end.

