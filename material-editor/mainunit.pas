unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, ComCtrls, ColorBox, Spin, OpenGLContext, gl, CFunctions,
  TramAssetMetadata, TramMaterialAsset, LCLType, NewMaterialDialogUnit,
  AboutDialogUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    MaterialTypeLabel: TLabel;
    MaterialFilterLabel: TLabel;
    MaterialPropertyLabel: TLabel;
    MaterialColorLabel: TLabel;
    MaterialSpecularityLabel: TLabel;
    MaterialExponentLabel: TLabel;
    MaterialTransparencyLabel: TLabel;
    MaterialReflectivityLabel: TLabel;
    MaterialSourceLabel: TLabel;
    MaterialColorSelect: TColorBox;
    MaterialTypeSelect: TComboBox;
    MaterialFilterSelect: TComboBox;
    MaterialPropertySelect: TComboBox;
    MaterialSourceSelect: TComboBox;
    MaterialExponentSelect: TFloatSpinEdit;
    MaterialSpecularitySelect: TFloatSpinEdit;
    MaterialTransparencySelect: TFloatSpinEdit;
    MaterialReflectivitySelect: TFloatSpinEdit;
    MaterialFileSelect: TComboBox;
    MaterialList: TListView;
    MainMenu: TMainMenu;
    MainMenuFile: TMenuItem;
    MainMenuHelp: TMenuItem;
    MainMenuOpenProject: TMenuItem;
    MainMenuSaveProject: TMenuItem;
    MainMenuExit: TMenuItem;
    MainMenuAbout: TMenuItem;
    MainMenuNewMaterial: TMenuItem;
    MaterialDataPanel: TPanel;
    MaterialListMenu: TPopupMenu;
    MaterialListMenuAdd: TMenuItem;
    MaterialListMenuRemove: TMenuItem;
    MaterialListMenuAddFromTexture: TMenuItem;
    RenderPanel: TPanel;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure GLboxPaint(Sender: TObject);
    procedure MainMenuAboutClick(Sender: TObject);
    procedure MainMenuExitClick(Sender: TObject);
    procedure MainMenuOpenProjectClick(Sender: TObject);
    procedure MainMenuSaveProjectClick(Sender: TObject);
    procedure MaterialColorSelectChange(Sender: TObject);
    procedure MaterialExponentSelectChange(Sender: TObject);
    procedure MaterialFileSelectChange(Sender: TObject);
    procedure MaterialFilterSelectChange(Sender: TObject);
    procedure MaterialListMenuAddClick(Sender: TObject);
    procedure MaterialListMenuAddFromTextureClick(Sender: TObject);
    procedure MaterialListMenuRemoveClick(Sender: TObject);
    procedure MaterialListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MaterialPropertySelectChange(Sender: TObject);
    procedure MaterialReflectivitySelectChange(Sender: TObject);
    procedure MaterialSourceSelectChange(Sender: TObject);
    procedure MaterialSourceSelectEditingDone(Sender: TObject);
    procedure MaterialSpecularitySelectChange(Sender: TObject);
    procedure MaterialTransparencySelectChange(Sender: TObject);
    procedure MaterialTypeSelectChange(Sender: TObject);
    procedure MainMenuNewMaterialClick(Sender: TObject);
    procedure RenderPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RenderPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RenderPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ResetMaterial;
    procedure ResetMesh;
  private

  public
    GLBox: TOpenGLControl;

    PreviewMaterial: Pointer;
    PreviewMeshSphere: Pointer;

    PreviewRotateX: Real;
    PreviewRotateY: Real;
    IsPreviewDragged: Boolean;
    PreviewDragStartX: Integer;
    PreviewDragStartY: Integer;
    PreviewDragLastX: Integer;
    PreviewDragLastY: Integer;
  end;

var
  MainForm: TMainForm;
  MaterialFiles: TMaterialCollection;
  SelectedFile: TMaterial;
  SelectedMaterial: TMaterialData;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  materialFile: TAssetMetadata;
  light: Pointer;
begin
  GLbox := TOpenGLControl.Create(Self);
  GLbox.AutoResizeViewport := true;
  GLBox.Parent             := RenderPanel;
  GLBox.MultiSampling      := 4;
  GLBox.Align              := alClient;
  GLBox.OnPaint            := @GLboxPaint;

  GLBox.OpenGLMajorVersion := 4;
  GLBox.OpenGLMinorVersion := 0;

  GLBox.MakeCurrent();

  GLBox.OnMouseMove := @RenderPanelMouseMove;
  GLBox.OnMouseDown := @RenderPanelMouseDown;
  GLBox.OnMouseUp := @RenderPanelMouseUp;

  SDKLoadLibs('../cwrapper/wrapper.dll');

  sdk_init();

  sdk_platform_window_screen_resize(RenderPanel.ClientWidth, RenderPanel.ClientHeight);

  // setup view
  sdk_render_set_view_position(0.0, 0.0, 3.0, 0);
  sdk_render_set_background_color(0.0, 0.0, 0.0);

  // create material
  PreviewMaterial := sdk_render_material_find('error');

  // create 3D preview mesh
  PreviewMeshSphere := sdk_components_mesh_make();
  sdk_components_mesh_set_location(PreviewMeshSphere, 0.0, 0.0, 0.0);
  sdk_components_mesh_set_material(PreviewMeshSphere, PreviewMaterial, 0);
  sdk_ext_meshtools_make_cube_sphere(PreviewMeshSphere, 4, 1.0);
  sdk_framework_component_init(PreviewMeshSphere);

  // setup lighting
  sdk_render_set_sun_color(0.0, 0.0, 0.0, 0);
  sdk_render_set_sun_ambient_color(0.2, 0.2, 0.2, 0);

  light := sdk_component_light_make();
  sdk_component_light_set_location(light, 1.0, 3.0, 3.0);
  sdk_component_light_set_color(light, 0.7, 0.7, 0.7);
  sdk_framework_component_init(light);

  (*light := sdk_component_light_make();
  sdk_component_light_set_location(light, 3.0, 4.0, 3.0);
  sdk_component_light_set_color(light, 0.5, 0.5, 0.5);
  sdk_framework_component_init(light);

  light := sdk_component_light_make();
  sdk_component_light_set_location(light, 0.0, 2.5, 3.0);
  sdk_component_light_set_color(light, 0.3, 0.3, 0.3);
  sdk_framework_component_init(light);*)

  // allow random data to load in
  sdk_update();
  sdk_update();
  sdk_update();

  // redraw the screen
  GLBox.invalidate;


  MaterialFiles := TMaterialCollection.Create();
  MaterialFiles.ScanFromDisk;

  for materialFile in MaterialFiles.GetAssets() do
      MaterialFileSelect.AddItem(materialFile.GetName, materialFile);

  // right now we'll load all materials from disk. later maybe we will lazy load
  for materialFile in MaterialFiles.GetAssets() do
      materialFile.LoadFromDisk();

  if MaterialFileSelect.Items.Count > 0 then begin
     MaterialFileSelect.ItemIndex := 0;
     self.MaterialFileSelectChange(self);
  end;

end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  response: Integer;
begin
  response := Application.MessageBox('Save changes before exiting?',
                                     'Exiting Project...',
                                     MB_ICONQUESTION + MB_YESNOCANCEL);
  if response = ID_CANCEL then begin
     CanClose := False;
     Exit;
  end;

  if response = ID_YES then
     MainMenuSaveProjectClick(self);

  CanClose := True;
end;

procedure TMainForm.GLboxPaint(Sender: TObject);
begin
  sdk_update();

  GLbox.SwapBuffers;
end;

procedure TMainForm.MainMenuAboutClick(Sender: TObject);
begin
  AboutDialog.ShowModal;
end;

procedure TMainForm.MainMenuExitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MainMenuOpenProjectClick(Sender: TObject);
var
  materialFile: TAssetMetadata;
  dialog: TSelectDirectoryDialog;
begin
  dialog := TSelectDirectoryDialog.Create(self);
  dialog.Execute;

  if (ID_YES <> Application.MessageBox(PChar(Format('Discard all unsaved changes and open %s?', [dialog.FileName])),
                                      'Open Project',
                                      MB_ICONQUESTION + MB_YESNO)) then Exit;

  SetCurrentDir(dialog.FileName);

  MaterialFileSelect.Clear;
  MaterialList.Clear;
  MaterialDataPanel.Enabled := False;

  MaterialFiles.Free;

  MaterialFiles := TMaterialCollection.Create();
  MaterialFiles.ScanFromDisk;

  for materialFile in MaterialFiles.GetAssets() do
      MaterialFileSelect.AddItem(materialFile.GetName, materialFile);

  for materialFile in MaterialFiles.GetAssets() do
      materialFile.LoadFromDisk();

  if MaterialFileSelect.Items.Count > 0 then begin
     MaterialFileSelect.ItemIndex := 0;
     self.MaterialFileSelectChange(self);
  end;
end;

procedure TMainForm.MainMenuSaveProjectClick(Sender: TObject);
var
  materialFile: TAssetMetadata;
begin
  for materialFile in MaterialFiles.GetAssets() do
        materialFile.SaveToDisk();
end;

procedure TMainForm.MaterialFileSelectChange(Sender: TObject);
var
  material: TMaterialData;
begin
  SelectedFile := MaterialFileSelect.Items.Objects[MaterialFileSelect.ItemIndex] as TMaterial;
  MaterialList.Clear;

  for material in SelectedFile.GetMaterials do begin
    MaterialList.AddItem(material.name, material);
    MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(material.materialType);
    MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(material.filter);
    MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(material.materialProperty);
    MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(material.source);
  end;

end;

procedure TMainForm.MaterialListMenuAddClick(Sender: TObject);
var
  newMaterialName: string;
  newMaterial: TMaterialData;
begin
  if SelectedFile = nil then begin
     Application.MessageBox('Select or create a material file first!', 'Unexpected Input', MB_ICONERROR);
     Exit;
  end;

  newMaterialName := InputBox('Create a New Material', 'Please input material name', 'dingbat');

  if (newMaterialName = 'dingbat') and (ID_YES <> Application.MessageBox('Create a "dingbat"?',
                                      'Unclear Input',
                                      MB_ICONQUESTION + MB_YESNO)) then Exit;

  newMaterial := SelectedFile.NewMaterial(newMaterialName);

  MaterialList.AddItem(newMaterialName, newMaterial);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.materialType);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.filter);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.materialProperty);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.source);

  MaterialList.ItemIndex := MaterialList.Items.Count-1;
end;

procedure TMainForm.MaterialListMenuAddFromTextureClick(Sender: TObject);
var
  assetMetadata: TAssetMetadata;
  material: TMaterialData;
  newMaterial: TMaterialData;
begin
  for assetMetadata in MaterialFiles.GetAssets do
      for material in (assetMetadata as TMaterial).GetMaterials do
          NewMaterialDialog.AddMaterial(material);

  NewMaterialDialog.Refresh;
  NewMaterialDialog.ShowModal;

  if NewMaterialDialog.GetSelectedMaterial = '' then Exit;

  newMaterial := SelectedFile.NewMaterial(NewMaterialDialog.GetSelectedMaterial);

  MaterialList.AddItem(NewMaterialDialog.GetSelectedMaterial, newMaterial);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.materialType);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.filter);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.materialProperty);
  MaterialList.Items.Item[MaterialList.Items.Count-1].SubItems.Add(newMaterial.source);

  MaterialList.ItemIndex := MaterialList.Items.Count-1;
end;

procedure TMainForm.MaterialListMenuRemoveClick(Sender: TObject);
var
  listItem: TListItem;
begin
  if SelectedMaterial = nil then begin
       Application.MessageBox('Select a material first', 'Unexpected Input', MB_ICONERROR);
       Exit;
    end;

  if ID_YES <> Application.MessageBox(PChar(Format('Remove material %s?', [SelectedMaterial.name])),
                                      'Yeet a Material, Permanently?',
                                      MB_ICONEXCLAMATION + MB_YESNO) then Exit;

  SelectedFile.RemoveMaterial(SelectedMaterial);

  listItem := MaterialList.Items.FindData(SelectedMaterial);
  MaterialList.Items.Delete(listItem.Index);

  SelectedMaterial := nil;
  MaterialDataPanel.Enabled := False;
end;

procedure TMainForm.MaterialListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SelectedMaterial := TObject(Item.Data) as TMaterialData;

  MaterialDataPanel.Enabled := SelectedFile <> nil;

  if SelectedFile = nil then Exit;

  // load properties into UI
  MaterialTypeSelect.Text := SelectedMaterial.materialType;
  MaterialFilterSelect.Text := SelectedMaterial.filter;
  MaterialPropertySelect.Text := SelectedMaterial.materialProperty;
  MaterialColorSelect.Selected := RGBToColor(Byte(Round(255.0 * SelectedMaterial.colorR)),
                                          Byte(Round(255.0 * SelectedMaterial.colorG)),
                                          Byte(Round(255.0 * SelectedMaterial.colorB)));
  MaterialSpecularitySelect.Value := SelectedMaterial.specular;
  MaterialExponentSelect.Value := SelectedMaterial.exponent;
  MaterialTransparencySelect.Value := SelectedMaterial.transparency;
  MaterialReflectivitySelect.Value := SelectedMaterial.reflectivity;
  MaterialSourceSelect.Text := SelectedMaterial.source;

  // load properties into renderer
  PreviewMaterial := sdk_render_material_find(PChar(SelectedMaterial.name));
  ResetMaterial;

  ResetMesh;
end;

procedure TMainForm.MaterialPropertySelectChange(Sender: TObject);
var
  subItems: TStrings;
begin
  SelectedMaterial.materialProperty := MaterialPropertySelect.Text;
  subItems := MaterialList.Items.FindData(SelectedMaterial).SubItems;
  subItems[2] := SelectedMaterial.materialProperty;
end;

procedure TMainForm.MaterialReflectivitySelectChange(Sender: TObject);
begin
  SelectedMaterial.reflectivity := MaterialReflectivitySelect.Value;
  ResetMaterial;
end;

procedure TMainForm.MaterialSourceSelectChange(Sender: TObject);
var
  subItems: TStrings;
begin
  SelectedMaterial.source := MaterialSourceSelect.Text;
  subItems := MaterialList.Items.FindData(SelectedMaterial).SubItems;
  subItems[3] := SelectedMaterial.source;
end;

procedure TMainForm.MaterialSourceSelectEditingDone(Sender: TObject);
begin
  ResetMaterial;
end;

procedure TMainForm.MaterialSpecularitySelectChange(Sender: TObject);
begin
  SelectedMaterial.specular := MaterialSpecularitySelect.Value;
  ResetMaterial;
end;

procedure TMainForm.MaterialTransparencySelectChange(Sender: TObject);
begin
  SelectedMaterial.transparency := MaterialTransparencySelect.Value;
  ResetMaterial;
end;

procedure TMainForm.MaterialTypeSelectChange(Sender: TObject);
var
  subItems: TStrings;
begin
  SelectedMaterial.materialType := MaterialTypeSelect.Text;
  subItems := MaterialList.Items.FindData(SelectedMaterial).SubItems;
  subItems[0] := SelectedMaterial.materialType;
  ResetMaterial;
end;

procedure TMainForm.MainMenuNewMaterialClick(Sender: TObject);
var
  newMaterialFileName: string;
  newMaterialFile: TMaterial;
begin
  newMaterialFileName := InputBox('Create a New Material', 'Please input material name', '');

  if newMaterialFileName = '' then Exit;

  if ID_YES <> Application.MessageBox(PChar(Format('Create a %s?', [newMaterialFileName])),
                                      'Input Confirmation',
                                      MB_ICONQUESTION + MB_YESNO) then Exit;

  newMaterialFile := MaterialFiles.InsertFromDB(newMaterialFileName, 0) as TMaterial;

  MaterialFileSelect.AddItem(newMaterialFileName, newMaterialFile);
  MaterialFileSelect.ItemIndex := MaterialFileSelect.Items.Count - 1;
  MaterialFileSelectChange(self);

  MaterialDataPanel.Enabled := False;
end;

procedure TMainForm.MaterialFilterSelectChange(Sender: TObject);
var
  subItems: TStrings;
begin
  SelectedMaterial.filter := MaterialFilterSelect.Text;
  subItems := MaterialList.Items.FindData(SelectedMaterial).SubItems;
  subItems[1] := SelectedMaterial.filter;
  ResetMaterial;
end;

procedure TMainForm.MaterialColorSelectChange(Sender: TObject);
begin
  SelectedMaterial.colorR := Real(Red(ColorToRGB(MaterialColorSelect.Selected))) / 255.0;
  SelectedMaterial.colorG := Real(Green(ColorToRGB(MaterialColorSelect.Selected))) / 255.0;
  SelectedMaterial.colorB := Real(Blue(ColorToRGB(MaterialColorSelect.Selected))) / 255.0;
  ResetMaterial;
end;

procedure TMainForm.MaterialExponentSelectChange(Sender: TObject);
begin
  SelectedMaterial.exponent := MaterialExponentSelect.Value;
  ResetMaterial;
end;

procedure TMainForm.RenderPanelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then begin
       PreviewRotateX := 0.0;
       PreviewRotateY := 0.0;
       sdk_components_mesh_set_rotation(PreviewMeshSphere, PreviewRotateY, PreviewRotateX, 0.0);
       GLBox.Invalidate;
       Exit;
  end;

  IsPreviewDragged := True;
  PreviewDragStartX := X;
  PreviewDragStartY := Y;
  PreviewDragLastX := X;
  PreviewDragLastY := Y;
end;

procedure TMainForm.RenderPanelMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  DeltaX: Integer;
  DeltaY: Integer;
begin
  if not IsPreviewDragged then Exit;

  DeltaX := X - PreviewDragLastX;
  DeltaY := Y - PreviewDragLastY;
  PreviewRotateX := PreviewRotateX + 0.01 * Real(DeltaX);
  PreviewRotateY := PreviewRotateY + 0.01 * Real(DeltaY);

  PreviewDragLastX := X;
  PreviewDragLastY := Y;

  sdk_components_mesh_set_rotation(PreviewMeshSphere, PreviewRotateY, PreviewRotateX, 0.0);
  GLBox.Invalidate;
end;

procedure TMainForm.RenderPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsPreviewDragged := False;
end;

procedure TMainForm.ResetMaterial;
var
  materialType: Integer;
  materialFilter: Integer;
  textureType: Integer;
  textureSourceInMaterial: Pointer;
  reloadMaterial: Boolean;
begin

  case SelectedMaterial.materialType of
    'flat': materialType := MATERIAL_TEXTURE;
    'alpha': materialType := MATERIAL_TEXTURE_ALPHA;
    'blend': materialType := MATERIAL_TEXTURE_BLEND;
    'lightmap': materialType := MATERIAL_LIGHTMAP;
    // the next two don't have registered strings for some reason
    //'': materialType := MATERIAL_ENVIRONMENTMAP;
    //'': materialType := MATERIAL_MSDF;
    'glyph': materialType := MATERIAL_GLYPH;
    'water': materialType := MATERIAL_WATER;
    'none': materialType := MATERIAL_FLAT_COLOR;
  else
    materialType := MATERIAL_TEXTURE;
  end;

  case SelectedMaterial.filter of
    'nearest': materialFilter := FILTER_NEAREST;
    'linear': materialFilter := FILTER_LINEAR;
  else
    materialFilter := FILTER_NEAREST;
  end;

  case SelectedMaterial.source of
    'none': textureType := TEXTURE_NONE;
    'same': textureType := TEXTURE_SAME;
    'normal': textureType := TEXTURE_SAME_NORMAL;
  else
    textureType := TEXTURE_SOURCE;
  end;

  // we need the mesh to reload, since changing type means changing shader
  if materialType <> sdk_render_material_get_type(PreviewMaterial) then begin
     sdk_render_material_set_material_type(PreviewMaterial, materialType);
     ResetMesh;
     ResetMaterial;
     Exit;
  end;

  sdk_render_material_set_material_filter(PreviewMaterial, materialFilter);
  sdk_render_material_set_color(PreviewMaterial, SelectedMaterial.colorR,
                                                 SelectedMaterial.colorG,
                                                 SelectedMaterial.colorB);
  sdk_render_material_set_specular(PreviewMaterial, SelectedMaterial.specular,
                                                    SelectedMaterial.exponent,
                                                    SelectedMaterial.transparency);
  sdk_render_material_set_reflectivity(PreviewMaterial, SelectedMaterial.reflectivity);

  // changing texture type is a bit more involved
  reloadMaterial := False;
  if textureType = TEXTURE_SOURCE then begin
     textureSourceInMaterial := sdk_render_material_find(PChar(SelectedMaterial.source));

     if sdk_render_material_get_source(PreviewMaterial) <> textureSourceInMaterial then begin
       sdk_render_material_set_source(PreviewMaterial, textureSourceInMaterial);
       reloadMaterial := True;
     end;
  end
  else
     if sdk_render_material_get_texture_type(PreviewMaterial) <> textureType then begin
       sdk_render_material_set_source(PreviewMaterial, nil);
       reloadMaterial := True;
     end;

  sdk_render_material_set_texture_type(PreviewMaterial, textureType);
  if reloadMaterial then begin
    sdk_framework_resource_unload(PreviewMaterial);
    sdk_framework_resource_load(PreviewMaterial);
  end;

  GLBox.Invalidate;
end;

procedure TMainForm.ResetMesh;
begin
  if SelectedMaterial = nil then Exit;

  if PreviewMeshSphere <> nil then
     sdk_components_mesh_yeet(PreviewMeshSphere);

  PreviewMeshSphere := sdk_components_mesh_make();
  sdk_components_mesh_set_location(PreviewMeshSphere, 0.0, 0.0, 0.0);
  sdk_components_mesh_set_rotation(PreviewMeshSphere, PreviewRotateY, PreviewRotateX, 0.0);
  sdk_components_mesh_set_material(PreviewMeshSphere, PreviewMaterial, 0);
  sdk_ext_meshtools_make_cube_sphere(PreviewMeshSphere, 4, 1.0);
  sdk_framework_component_init(PreviewMeshSphere);

  GLBox.Invalidate;
end;

end.

