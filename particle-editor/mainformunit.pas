unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, AboutDialogUnit, OpenGLContext, gl, CFunctions,
  TramAssetMetadata, TramParticleAsset, LCLType;

type

  { TMainForm }

  TMainForm = class(TForm)
    AddSystem: TButton;
    AutoPlay: TCheckBox;
    StopParticle: TButton;
    StartParticle: TButton;
    OpenProject: TMenuItem;
    SaveSprites: TMenuItem;
    RemoveSystem: TButton;
    MoveOpUp: TButton;
    MoveOpDown: TButton;
    AddOp: TButton;
    RemoveOp: TButton;
    ParticleList: TListBox;
    OperationList: TListBox;
    ParticleListFilter: TEdit;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    HelpMenu: TMenuItem;
    AboutMenu: TMenuItem;
    RenderPanel: TPanel;
    Quit: TMenuItem;
    NewParticleCreate: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    StatusBar1: TStatusBar;
    ParticleTree: TTreeView;
    procedure AboutMenuClick(Sender: TObject);
    procedure AddOpClick(Sender: TObject);
    procedure AddSystemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GLboxPaint(Sender: TObject);
    procedure NewParticleCreateClick(Sender: TObject);
    procedure OperationListSelectionChange(Sender: TObject; User: boolean);
    procedure ParticleListSelectionChange(Sender: TObject; User: boolean);
    procedure ParticleTreeChange(Sender: TObject; Node: TTreeNode);
    procedure QuitClick(Sender: TObject);
    procedure RemoveOpClick(Sender: TObject);
    procedure RemoveSystemClick(Sender: TObject);
    procedure RenderPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RenderPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RenderPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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

  Particles: TParticleCollection;
  SelectedParticle: TParticle;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.AboutMenuClick(Sender: TObject);
begin
  AboutDialog.Show;
end;

procedure TMainForm.AddOpClick(Sender: TObject);
var
  op: TParticleOperation;
  ct: TParticleConstraint;
  em: TParticleEmitter;
  val: TParticleData;
  sys: TParticleSystem;
begin
  if ParticleTree.Selected.Parent <> nil then
     sys := TParticleSystem(ParticleTree.Selected.Parent.Data)
  else
      sys := TParticleSystem(ParticleTree.Selected.Data);

  if ParticleTree.Selected.Text = 'Initializers' then begin
     op := sys.AddInit;
     OperationList.AddItem(op.opType, op);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Operations' then begin
     op := sys.AddOp;
     OperationList.AddItem(op.opType, op);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Constraints' then begin
     ct := sys.AddConstr;
     OperationList.AddItem(ct.ctType, ct);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Emitters' then begin
     em := sys.AddEmit;
     OperationList.AddItem('emita', em);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Values' then begin
     val := sys.AddValue;
     OperationList.AddItem(val.dataName + #9 + 'egg', val);
     Exit;
  end;
end;

procedure TMainForm.AddSystemClick(Sender: TObject);
var
  system: TParticleSystem;
  node: TTreeNode;
begin
  system := SelectedParticle.NewParticleSystem;
  node := ParticleTree.Items.Add(nil, 'System ' + (SelectedParticle.GetParticleSystems.Count).ToString);
  node.Data := system;
  ParticleTree.Items.AddChild(node, 'Initializers');
  ParticleTree.Items.AddChild(node, 'Operations');
  ParticleTree.Items.AddChild(node, 'Constraints');
  node.Expand(True);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  particleFile: TAssetMetadata;
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


  Particles := TParticleCollection.Create();
  Particles.ScanFromDisk;

  for particleFile in Particles.GetAssets() do
      ParticleList.AddItem(particleFile.GetName, particleFile);

  // right now we'll load all materials from disk. later maybe we will lazy load
  for particleFile in Particles.GetAssets() do
      particleFile.LoadFromDisk();

  if ParticleList.Items.Count > 0 then begin
     ParticleList.ItemIndex := 0;
     self.ParticleListSelectionChange(self, False);
  end;
end;

procedure TMainForm.GLboxPaint(Sender: TObject);
begin
  sdk_update();

  GLbox.SwapBuffers;
end;

procedure TMainForm.NewParticleCreateClick(Sender: TObject);
var
  newParticleName: string;
  newParticle: TParticle;
begin
  newParticleName := InputBox('Create a New Particle', 'Please input particle name', '');

  if newParticleName = '' then Exit;

  if ID_YES <> Application.MessageBox(PChar(Format('Create a %s?', [newParticleName])),
                                      'Input Confirmation',
                                      MB_ICONQUESTION + MB_YESNO) then Exit;

  newParticle := Particles.InsertFromDB(newParticleName, 0) as TParticle;

  // we'll add the base system here, since all particles need them anyway
  newParticle.NewParticleSystem.isBase:= True;

  ParticleList.AddItem(newParticleName, newParticle);
  ParticleList.ItemIndex := ParticleList.Items.Count - 1;
  ParticleListSelectionChange(self, False);
end;

procedure TMainForm.OperationListSelectionChange(Sender: TObject; User: boolean
  );
var
  isSelected: Boolean;
  isOperation: Boolean;
begin
  isSelected := OperationList.ItemIndex >= 0;
  isOperation := (ParticleTree.Selected.Text = 'Initializers')
              or (ParticleTree.Selected.Text = 'Operations');
  RemoveOp.Enabled := isSelected;
  MoveOpUp.Enabled := isSelected and isOperation;
  MoveOpDown.Enabled := isSelected and isOperation;
end;

procedure TMainForm.ParticleListSelectionChange(Sender: TObject; User: boolean);
var
  system: TParticleSystem;
  syscount: Integer;
  node: TTreeNode;
begin
  if ParticleList.ItemIndex < 0 then begin
     SelectedParticle := nil;
     // TODO: disable particle tree
     Exit;
  end;

  SelectedParticle := ParticleList.Items.Objects[ParticleList.ItemIndex] as TParticle;

  syscount := 0;
  ParticleTree.Items.Clear;
  for system in SelectedParticle.GetParticleSystems do begin
    if system.isBase then begin
       node := ParticleTree.Items.Add(nil, 'Base');
       node.Data := system;
       ParticleTree.Items.AddChild(node, 'Initializers');
       ParticleTree.Items.AddChild(node, 'Operations');
       ParticleTree.Items.AddChild(node, 'Emitters');
       ParticleTree.Items.AddChild(node, 'Values');
    end else begin
      syscount += 1;
      node := ParticleTree.Items.Add(nil, 'System ' + syscount.ToString);
      node.Data := system;
      ParticleTree.Items.AddChild(node, 'Initializers');
      ParticleTree.Items.AddChild(node, 'Operations');
      ParticleTree.Items.AddChild(node, 'Constraints');
      ParticleTree.Items.AddChild(node, 'Values');
    end;
  end;

  ParticleTree.FullExpand;
end;

procedure TMainForm.ParticleTreeChange(Sender: TObject; Node: TTreeNode);
var
  op: TParticleOperation;
  ct: TParticleConstraint;
  em: TParticleEmitter;
  val: TParticleData;
  sys: TParticleSystem;
begin
  RemoveSystem.Enabled := False;

  if ParticleTree.Selected = nil then begin
     // TODO: disable other stuff
     Exit;
  end;

  if ParticleTree.Selected.Parent <> nil then
     sys := TParticleSystem(ParticleTree.Selected.Parent.Data)
  else
      sys := TParticleSystem(ParticleTree.Selected.Data);
  OperationList.Items.Clear;

  AddOp.Enabled := True;
  RemoveOp.Enabled := False;
  MoveOpUp.Enabled := False;
  MoveOpDown.Enabled := False;

  if ParticleTree.Selected.Text = 'Initializers' then begin
     AddOp.Caption := 'Add Op';
     RemoveOp.Caption := 'Remove Op';

     for op in sys.GetInits do
         OperationList.AddItem(op.opType, op);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Operations' then begin
     AddOp.Caption := 'Add Op';
     RemoveOp.Caption := 'Remove Op';
     for op in sys.GetOps do
         OperationList.AddItem(op.opType, op);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Constraints' then begin
     AddOp.Caption := 'Add Constr';
     RemoveOp.Caption := 'Remove Constr';
     for ct in sys.GetConstrs do
         OperationList.AddItem(ct.ctType, ct);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Emitters' then begin
     AddOp.Caption := 'Add Emit';
     RemoveOp.Caption := 'Remove Emit';
     for em in sys.GetEmits do
         OperationList.AddItem('Emitter', em);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Values' then begin
     AddOp.Caption := 'Add Value';
     RemoveOp.Caption := 'Remove Value';
     for val in sys.GetValues do
         OperationList.AddItem(val.dataName, val);
     Exit;
  end;

  AddOp.Enabled := False;
  RemoveOp.Enabled := False;

  if not TParticleSystem(ParticleTree.Selected.Data).isBase then
     RemoveSystem.Enabled := True;



end;

procedure TMainForm.QuitClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.RemoveOpClick(Sender: TObject);
var
  op: TParticleOperation;
  ct: TParticleConstraint;
  em: TParticleEmitter;
  val: TParticleData;
  sys: TParticleSystem;
begin
  if ParticleTree.Selected.Parent <> nil then
     sys := TParticleSystem(ParticleTree.Selected.Parent.Data)
  else
      sys := TParticleSystem(ParticleTree.Selected.Data);

  if OperationList.ItemIndex < 0 then Exit;

  RemoveOp.Enabled := False;
  MoveOpUp.Enabled := False;
  MoveOpDown.Enabled := False;

  if ParticleTree.Selected.Text = 'Initializers' then begin
     op := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleOperation;
     sys.RemoveInit(op);
     OperationList.Items.Delete(OperationList.ItemIndex);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Operations' then begin
     op := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleOperation;
     sys.RemoveOp(op);
     OperationList.Items.Delete(OperationList.ItemIndex);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Constraints' then begin
     ct := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleConstraint;
     sys.RemoveConstr(ct);
     OperationList.Items.Delete(OperationList.ItemIndex);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Emitters' then begin
     em := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleEmitter;
     sys.RemoveEmit(em);
     OperationList.Items.Delete(OperationList.ItemIndex);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Values' then begin
     val := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleData;
     sys.RemoveValue(val);
     OperationList.Items.Delete(OperationList.ItemIndex);
     Exit;
  end;
end;

procedure TMainForm.RemoveSystemClick(Sender: TObject);
begin
  if ParticleTree.Selected = nil then Exit;
  if ParticleTree.Selected.Data = nil then Exit;
  if TParticleSystem(ParticleTree.Selected.Data).isBase then Exit;
  SelectedParticle.RemoveParticleSystem(TParticleSystem(ParticleTree.Selected.Data));
  ParticleTree.Items.Delete(ParticleTree.Selected);
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

end.

