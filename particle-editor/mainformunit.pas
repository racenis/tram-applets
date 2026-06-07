unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, AboutDialogUnit, OpenGLContext, gl, CFunctions,
  TramAssetMetadata, TramParticleAsset, LCLType, OptionsSystemUnit,
  OptionsValueUnit, OptionsConstraintUnit, OptionsEmitterUnit,
  OptionsOperationUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    AddSystem: TButton;
    AutoPlay: TCheckBox;
    OptionsPanel: TPanel;
    StopParticle: TButton;
    StartParticle: TButton;
    MainMenuOpenProject: TMenuItem;
    MainMenuSaveProject: TMenuItem;
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
    MainMenuQuit: TMenuItem;
    MainMenuNewParticleCreate: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    StatusBar1: TStatusBar;
    ParticleTree: TTreeView;
    RenderTimer: TTimer;
    procedure AboutMenuClick(Sender: TObject);
    procedure AddOpClick(Sender: TObject);
    procedure AddSystemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GLboxPaint(Sender: TObject);
    procedure MainMenuNewParticleCreateClick(Sender: TObject);
    procedure MainMenuOpenProjectClick(Sender: TObject);
    procedure MoveOpDownClick(Sender: TObject);
    procedure MoveOpUpClick(Sender: TObject);
    procedure OperationListSelectionChange(Sender: TObject; User: boolean);
    procedure ParticleListSelectionChange(Sender: TObject; User: boolean);
    procedure ParticleTreeChange(Sender: TObject; Node: TTreeNode);
    procedure MainMenuQuitClick(Sender: TObject);
    procedure RemoveOpClick(Sender: TObject);
    procedure RemoveSystemClick(Sender: TObject);
    procedure RenderPanelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RenderPanelMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RenderPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RenderPanelMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure MainMenuSaveProjectClick(Sender: TObject);
    procedure RenderTimerTimer(Sender: TObject);
    procedure StartParticleClick(Sender: TObject);
    procedure StopParticleClick(Sender: TObject);
  private

  public
    GLBox: TOpenGLControl;

    PreviewMaterial: Pointer;
    PreviewMeshSphere: Pointer;

    PreviewParticle: Pointer;
    PreviewParticleComponent: Pointer;

    optionsFrame: TFrame;

    PreviewRotateX: Real;
    PreviewRotateY: Real;
    PreviewZoom: Real;
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
     OperationList.AddItem(val.dataName, val);
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
  ParticleTree.Items.AddChild(node, 'Emitters');
  ParticleTree.Items.AddChild(node, 'Values');
  node.Expand(True);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  particleFile: TAssetMetadata;
  light: Pointer;
begin
  DefaultFormatSettings.DecimalSeparator := '.';

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
  GLBox.OnMouseWheel := @RenderPanelMouseWheel;

  SDKLoadLibs('../cwrapper/wrapper.dll');

  sdk_init();

  sdk_platform_window_screen_resize(RenderPanel.ClientWidth, RenderPanel.ClientHeight);

  // setup view
  sdk_render_set_view_position(0.0, 0.0, 5.0, 0);
  sdk_render_set_background_color(0.0, 0.0, 0.0);

  // create material
  PreviewMaterial := sdk_render_material_find('error');

  // create 3D preview mesh
  (*PreviewMeshSphere := sdk_components_mesh_make();
  sdk_components_mesh_set_location(PreviewMeshSphere, 0.0, 0.0, 0.0);
  sdk_components_mesh_set_scale(PreviewMeshSphere, 0.2, 0.2, 0.2);
  sdk_components_mesh_set_material(PreviewMeshSphere, PreviewMaterial, 0);
  sdk_ext_meshtools_make_cube_sphere(PreviewMeshSphere, 4, 1.0);
  sdk_framework_component_init(PreviewMeshSphere);*)

  // setup lighting
  sdk_render_set_sun_color(1.0, 1.0, 1.0, 0);
  sdk_render_set_sun_direction(1.0, 1.0, 1.0, 0);
  sdk_render_set_sun_ambient_color(0.2, 0.2, 0.2, 0);

  (*light := sdk_component_light_make();
  sdk_component_light_set_location(light, 1.0, 3.0, 3.0);
  sdk_component_light_set_color(light, 0.7, 0.7, 0.7);
  sdk_framework_component_init(light);*)

  // setup initial particle stuff
  PreviewParticle := nil;
  PreviewParticleComponent := nil;

  PreviewZoom := 5.0;

  // allow random data to load in
  sdk_update();
  sdk_update();
  sdk_update();

  // redraw the screen
  GLBox.invalidate;

  optionsFrame := nil;

  Particles := TParticleCollection.Create();
  Particles.ScanFromDisk;

  for particleFile in Particles.GetAssets() do
      ParticleList.AddItem(particleFile.GetName, particleFile);

  for particleFile in Particles.GetAssets() do
      particleFile.LoadFromDisk();

  if ParticleList.Items.Count > 0 then begin
     ParticleList.ItemIndex := 0;
     self.ParticleListSelectionChange(self, False);
  end;
end;

procedure TMainForm.GLboxPaint(Sender: TObject);
var
  viewX: Real;
  viewY: Real;
  viewZ: Real;
begin
  viewX := PreviewZoom * Sin(-PreviewRotateX) * Cos(PreviewRotateY);
  viewY := PreviewZoom * Sin(PreviewRotateY);
  viewZ := PreviewZoom * Cos(-PreviewRotateX) * Cos(PreviewRotateY);

  sdk_render_set_view_position(viewX, viewY, viewZ, 0);
  sdk_render_set_view_position(viewX, viewY, viewZ, 1);
  sdk_render_set_view_rotation(-PreviewRotateY, -PreviewRotateX, 0.0, 0);
  sdk_render_set_view_rotation(-PreviewRotateY, -PreviewRotateX, 0.0, 1);

  sdk_render_add_line(0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0, 0.0);
  sdk_render_add_line(0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0, 0.0);
  sdk_render_add_line(0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 1.0);
  sdk_update();

  GLbox.SwapBuffers;
end;

procedure TMainForm.MainMenuNewParticleCreateClick(Sender: TObject);
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

procedure TMainForm.MainMenuOpenProjectClick(Sender: TObject);
var
  particleFile: TAssetMetadata;
  dialog: TSelectDirectoryDialog;
begin
  dialog := TSelectDirectoryDialog.Create(self);
  dialog.Execute;

  if (ID_YES <> Application.MessageBox(PChar(Format('Discard all unsaved changes and open %s?', [dialog.FileName])),
                                      'Open Project',
                                      MB_ICONQUESTION + MB_YESNO)) then Exit;

  SetCurrentDir(dialog.FileName);

  ParticleList.Clear;
  ParticleTree.Items.Clear;
  OperationList.Clear;
  OptionsPanel.Enabled := False;

  Particles.Free;

  Particles := TParticleCollection.Create();
  Particles.ScanFromDisk;

  for particleFile in Particles.GetAssets() do
      ParticleList.AddItem(particleFile.GetName, particleFile);

  for particleFile in Particles.GetAssets() do
      particleFile.LoadFromDisk();

  if ParticleList.Items.Count > 0 then begin
     ParticleList.ItemIndex := 0;
     self.ParticleListSelectionChange(self, False);
  end;
end;

procedure TMainForm.MoveOpDownClick(Sender: TObject);
var
  prevIndex: Integer;
  op: TParticleOperation;
  sys: TParticleSystem;
begin
  if ParticleTree.Selected.Parent <> nil then
     sys := TParticleSystem(ParticleTree.Selected.Parent.Data)
  else
      sys := TParticleSystem(ParticleTree.Selected.Data);

  prevIndex := OperationList.ItemIndex;

  op := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleOperation;
  sys.MoveDown(op);

  self.ParticleTreeChange(self, nil);

  OperationList.ItemIndex := prevIndex + 1;
end;

procedure TMainForm.MoveOpUpClick(Sender: TObject);
var
  prevIndex: Integer;
  op: TParticleOperation;
  sys: TParticleSystem;
begin
  if ParticleTree.Selected.Parent <> nil then
     sys := TParticleSystem(ParticleTree.Selected.Parent.Data)
  else
      sys := TParticleSystem(ParticleTree.Selected.Data);

  prevIndex := OperationList.ItemIndex;

  op := OperationList.Items.Objects[OperationList.ItemIndex] as TParticleOperation;
  sys.MoveUp(op);

  self.ParticleTreeChange(self, nil);

  OperationList.ItemIndex := prevIndex - 1;
end;

procedure TMainForm.OperationListSelectionChange(Sender: TObject; User: boolean
  );
var
  isSelected: Boolean;
  isOperation: Boolean;
  isLast: Boolean;
  isFirst: Boolean;
begin
  isSelected := OperationList.ItemIndex >= 0;
  isOperation := (ParticleTree.Selected.Text = 'Initializers')
              or (ParticleTree.Selected.Text = 'Operations');
  isLast := OperationList.ItemIndex + 1 >= OperationList.Items.Count;
  isFirst := OperationList.ItemIndex = 0;
  RemoveOp.Enabled := isSelected;
  MoveOpUp.Enabled := isSelected and isOperation and (not isFirst);
  MoveOpDown.Enabled := isSelected and isOperation and (not isLast);
  OptionsPanel.Enabled := isSelected;

  if OperationList.ItemIndex < 0 then Exit;
  if (ParticleTree.Selected.Text = 'Operations') or (ParticleTree.Selected.Text = 'Initializers') then
      (optionsFrame as TOptionsOperationFrame).SetOperation(OperationList.Items.Objects[OperationList.ItemIndex] as TParticleOperation);
  if ParticleTree.Selected.Text = 'Constraints' then
      (optionsFrame as TOptionsConstraintFrame).SetConstraint(OperationList.Items.Objects[OperationList.ItemIndex] as TParticleConstraint);
  if ParticleTree.Selected.Text = 'Emitters' then
      (optionsFrame as TOptionsEmitterFrame).SetEmitter(OperationList.Items.Objects[OperationList.ItemIndex] as TParticleEmitter);
  if ParticleTree.Selected.Text = 'Values' then
      (optionsFrame as TOptionsValueFrame).SetValue(OperationList.Items.Objects[OperationList.ItemIndex] as TParticleData);
end;

procedure TMainForm.ParticleListSelectionChange(Sender: TObject; User: boolean);
var
  system: TParticleSystem;
  syscount: Integer;
  node: TTreeNode;
begin
  if ParticleList.ItemIndex < 0 then begin
     SelectedParticle := nil;
     ParticleTree.Enabled := False;
     OperationList.Enabled := False;
     Exit;
  end;

  ParticleTree.Enabled := True;
  OperationList.Enabled := False;
  OptionsPanel.Enabled := False;

  SelectedParticle := ParticleList.Items.Objects[ParticleList.ItemIndex] as TParticle;

  syscount := 0;
  ParticleTree.Items.Clear;
  for system in SelectedParticle.GetParticleSystems do begin
    if system.isBase then begin
       node := ParticleTree.Items.Add(nil, 'Base');
       node.Data := system;
       ParticleTree.Items.AddChild(node, 'Initializers');
       ParticleTree.Items.AddChild(node, 'Operations');
       ParticleTree.Items.AddChild(node, 'Values');
    end else begin
      syscount += 1;
      node := ParticleTree.Items.Add(nil, 'System ' + syscount.ToString);
      node.Data := system;
      ParticleTree.Items.AddChild(node, 'Initializers');
      ParticleTree.Items.AddChild(node, 'Operations');
      ParticleTree.Items.AddChild(node, 'Constraints');
      ParticleTree.Items.AddChild(node, 'Emitters');
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
     OperationList.Enabled := False;
     OptionsPanel.Enabled := False;
     Exit;
  end;

  OperationList.Enabled := True;
  OptionsPanel.Enabled := False;

  if ParticleTree.Selected.Parent <> nil then
     sys := TParticleSystem(ParticleTree.Selected.Parent.Data)
  else
      sys := TParticleSystem(ParticleTree.Selected.Data);
  OperationList.Items.Clear;

  AddOp.Enabled := True;
  RemoveOp.Enabled := False;
  MoveOpUp.Enabled := False;
  MoveOpDown.Enabled := False;

  if optionsFrame <> nil then begin
     optionsFrame.Free;
     optionsFrame := nil;
  end;

  if ParticleTree.Selected.Text = 'Initializers' then begin
     AddOp.Caption := 'Add Op';
     RemoveOp.Caption := 'Remove Op';
     optionsFrame := TOptionsOperationFrame.Create(OptionsPanel);
     optionsFrame.Parent := OptionsPanel;

     for op in sys.GetInits do
         OperationList.AddItem(op.opType, op);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Operations' then begin
     AddOp.Caption := 'Add Op';
     RemoveOp.Caption := 'Remove Op';
     optionsFrame := TOptionsOperationFrame.Create(OptionsPanel);
     optionsFrame.Parent := OptionsPanel;
     for op in sys.GetOps do
         OperationList.AddItem(op.opType, op);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Constraints' then begin
     AddOp.Caption := 'Add Constr';
     RemoveOp.Caption := 'Remove Constr';
     optionsFrame := TOptionsConstraintFrame.Create(OptionsPanel);
     optionsFrame.Parent := OptionsPanel;
     for ct in sys.GetConstrs do
         OperationList.AddItem(ct.ctType, ct);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Emitters' then begin
     AddOp.Caption := 'Add Emit';
     RemoveOp.Caption := 'Remove Emit';
     optionsFrame := TOptionsEmitterFrame.Create(OptionsPanel);
     optionsFrame.Parent := OptionsPanel;
     for em in sys.GetEmits do
         OperationList.AddItem('Emitter', em);
     Exit;
  end;

  if ParticleTree.Selected.Text = 'Values' then begin
     AddOp.Caption := 'Add Value';
     RemoveOp.Caption := 'Remove Value';
     optionsFrame := TOptionsValueFrame.Create(OptionsPanel);
     optionsFrame.Parent := OptionsPanel;
     for val in sys.GetValues do
         OperationList.AddItem(val.dataName, val);
     Exit;
  end;

  AddOp.Enabled := False;
  RemoveOp.Enabled := False;

  if not TParticleSystem(ParticleTree.Selected.Data).isBase then
     RemoveSystem.Enabled := True;

  OptionsPanel.Enabled := True;

  optionsFrame := TOptionsSystemFrame.Create(OptionsPanel);
  optionsFrame.Parent := OptionsPanel;
  (optionsFrame as TOptionsSystemFrame).SetSystem(sys);
end;

procedure TMainForm.MainMenuQuitClick(Sender: TObject);
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
       PreviewZoom := 5.0;

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

  if not RenderTimer.Enabled then GLBox.Invalidate;
end;

procedure TMainForm.RenderPanelMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  IsPreviewDragged := False;
end;

procedure TMainForm.RenderPanelMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  begin
  if WheelDelta > 0 then
     PreviewZoom -= 0.5
  else
    PreviewZoom += 0.5;

  if PreviewZoom < 1.0 then PreviewZoom := 1.0;
  if PreviewZoom > 15.0 then PreviewZoom := 15.0;

  Handled := True;
end;
end;

procedure TMainForm.MainMenuSaveProjectClick(Sender: TObject);
var
  particleFile: TAssetMetadata;
begin
  for particleFile in Particles.GetAssets() do
      particleFile.SaveToDisk();
end;

procedure TMainForm.RenderTimerTimer(Sender: TObject);
begin
  GLBox.Invalidate;
end;

procedure TMainForm.StartParticleClick(Sender: TObject);
var
  system: TParticleSystem;
  data: TParticleData;
  op: TParticleOperation;
  ct: TParticleConstraint;
  em: TParticleEmitter;

  ptrSystem: Pointer;
  ptrOp: Pointer;
  ptrCt: Pointer;

  function DataTypeToEnum(dataType: string): Integer;
  begin
    case dataType of
         'scalar': Exit(DATA_SCALAR);
         'vector': Exit(DATA_VECTOR);
    end;
  end;

  function MakeParam(p: TParticleParameter): Pointer;
  begin
    Result := sdk_render_particle_parameter_make();
    case p.paramType of
         'none':       sdk_render_particle_parameter_set_none(Result);
         'data':       sdk_render_particle_parameter_set_data(Result, PChar(p.data));
         'scalar':     sdk_render_particle_parameter_set_scalar(Result, p.x.ToSingle);
         'vector':     sdk_render_particle_parameter_set_vector(Result, p.x.ToSingle, p.y.ToSingle, p.z.ToSingle);
    end;
  end;

  function MakeOp(op: TParticleOperation): Pointer;
  begin
    Result := sdk_render_particle_operation_make();
    case op.opType of
       'copy': sdk_render_particle_operation_set_type(Result, OPERATION_COPY);
       'oscillator': sdk_render_particle_operation_set_type(Result, OPERATION_OSCILLATOR);
       'noise': sdk_render_particle_operation_set_type(Result, OPERATION_NOISE);
       'clamp': sdk_render_particle_operation_set_type(Result, OPERATION_CLAMP);
       'normalize': sdk_render_particle_operation_set_type(Result, OPERATION_NORMALIZE);
    end;

    case op.mergeType of
       'set': sdk_render_particle_operation_set_merge(Result, MERGE_SET);
       'add': sdk_render_particle_operation_set_merge(Result, MERGE_ADD);
       'sub': sdk_render_particle_operation_set_merge(Result, MERGE_SUBTRACT);
       'mul': sdk_render_particle_operation_set_merge(Result, MERGE_MULTIPLY);
       'div': sdk_render_particle_operation_set_merge(Result, MERGE_DIVIDE);
    end;

    case op.mergeDest of
       'any': sdk_render_particle_operation_set_dest(Result, MERGE_ANY);
       'x': sdk_render_particle_operation_set_dest(Result, MERGE_X);
       'y': sdk_render_particle_operation_set_dest(Result, MERGE_Y);
       'z': sdk_render_particle_operation_set_dest(Result, MERGE_Z);
    end;

    sdk_render_particle_operation_set_target(Result, PChar(op.target));

    sdk_render_particle_operation_set_param(Result, 0, MakeParam(op.param1));
    sdk_render_particle_operation_set_param(Result, 1, MakeParam(op.param2));
    sdk_render_particle_operation_set_param(Result, 2, MakeParam(op.param3));
    sdk_render_particle_operation_set_param(Result, 3, MakeParam(op.param4));
  end;

begin
  if PreviewParticle <> nil then begin
     sdk_framework_resource_unload(PreviewParticle);
  end;

  if PreviewParticleComponent <> nil then begin
     sdk_components_particle_yeet(PreviewParticleComponent);
  end;

  PreviewParticle := sdk_render_particle_find('irrelevant');

  for data in SelectedParticle.GetControls do begin
      sdk_render_particle_add_control(PreviewParticle, PChar(data.dataName), DataTypeToEnum(data.dataType));
  end;

  for system in SelectedParticle.GetParticleSystems do begin
    if system.isBase then
       ptrSystem := sdk_render_particle_get_base_system(PreviewParticle)
    else
       ptrSystem := sdk_render_particle_create_system(PreviewParticle);

    if system.sprite <> '' then sdk_render_particle_system_set_sprite(ptrSystem, sdk_render_sprite_find(PChar(system.sprite)));
    if system.wire <> '' then sdk_render_particle_system_set_wire(ptrSystem, sdk_render_material_find(PChar(system.wire)));
    if system.model <> '' then sdk_render_particle_system_set_model(ptrSystem, sdk_render_model_find(PChar(system.model)));

    for data in system.GetValues do begin
      sdk_render_particle_system_add_value(ptrSystem, PChar(data.dataName), DataTypeToEnum(data.dataType));
    end;

    for op in system.GetOps do begin
      ptrOp := MakeOp(op);
      sdk_render_particle_system_add_operation(ptrSystem, ptrOp);
    end;

    for op in system.GetInits do begin
      ptrOp := MakeOp(op);
      sdk_render_particle_system_add_initializer(ptrSystem, ptrOp);
    end;

    for ct in system.GetConstrs do begin
      ptrCt := sdk_render_particle_constraint_make();

      case ct.ctType of
         'lt': sdk_render_particle_constraint_set_type(ptrCt, CONSTRAINT_LESSER_THAN);
         'gt': sdk_render_particle_constraint_set_type(ptrCt, CONSTRAINT_GREATER_THAN);
      end;

      case ct.mergeDest of
       'any': sdk_render_particle_constraint_set_dest(ptrCt, MERGE_ANY);
       'x': sdk_render_particle_constraint_set_dest(ptrCt, MERGE_X);
       'y': sdk_render_particle_constraint_set_dest(ptrCt, MERGE_Y);
       'z': sdk_render_particle_constraint_set_dest(ptrCt, MERGE_Z);
      end;

      sdk_render_particle_constraint_set_property(ptrCt, PChar(ct.target));

      sdk_render_particle_constraint_set_param(ptrCt, 0, MakeParam(ct.param1));
      sdk_render_particle_constraint_set_param(ptrCt, 1, MakeParam(ct.param2));
      sdk_render_particle_constraint_set_param(ptrCt, 2, MakeParam(ct.param3));
      sdk_render_particle_constraint_set_param(ptrCt, 3, MakeParam(ct.param4));

      sdk_render_particle_system_add_constraint(ptrSystem, ptrCt);
    end;

    for em in system.GetEmits do begin
      sdk_render_particle_system_add_emitter(ptrSystem, MakeParam(em.rate), MakeParam(em.delay));
    end;

    sdk_render_particle_system_set_particle_limit(ptrSystem, system.particleLimit.ToInteger);
  end;

  sdk_framework_resource_load(PreviewParticle);

  PreviewParticleComponent := sdk_components_particle_make();
  sdk_components_particle_update_location(PreviewParticleComponent, 0.0, 0.0, 0.0);
  sdk_components_particle_set_particle(PreviewParticleComponent, PreviewParticle);

  sdk_framework_component_init(PreviewParticleComponent);

  StartParticle.Enabled := False;
  StopParticle.Enabled := True;
  RenderTimer.Enabled := True;
end;

procedure TMainForm.StopParticleClick(Sender: TObject);
begin
  StartParticle.Enabled := True;
  StopParticle.Enabled := False;
  RenderTimer.Enabled := False;
end;

end.

