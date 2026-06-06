unit TramParticleAsset;

{$mode objfpc}{$H+}

interface


uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser, fgl,
  TramAssetWriter;

type
  TParticleParameter = class
  public
     constructor Create;
  public
     paramType: string;
     data: string;
     x: string;
     y: string;
     z: string;
  end;

  { TParticleData }

  TParticleData = class
  public
     constructor Create;
  public
     dataName: string;
     dataType: string;
  end;

  { TParticleOperation }

  TParticleOperation = class
  public
     constructor Create;
     procedure ToggleParams;
     function GetParamName(param: Integer): string;
  public
     opType: string;
     mergeType: string;
     mergeDest: string;
     target: string;
     param1: TParticleParameter;
     param2: TParticleParameter;
     param3: TParticleParameter;
     param4: TParticleParameter;

     isInit: Boolean;
  end;

  { TParticleConstraint }

  TParticleConstraint = class
  public
     constructor Create;
     procedure ToggleParams;
     function GetParamName(param: Integer): string;
  public
     ctType: string;
     mergeDest: string;
     target: string;
     param1: TParticleParameter;
     param2: TParticleParameter;
     param3: TParticleParameter;
     param4: TParticleParameter;
  end;

  TParticleEmitter = class
  public
     constructor Create;
  public
     rate: TParticleParameter;
     delay: TParticleParameter;
  end;

  TParticleDataList = specialize TFPGList<TParticleData>;
  TParticleOperationList = specialize TFPGList<TParticleOperation>;
  TParticleConstraintList = specialize TFPGList<TParticleConstraint>;
  TParticleEmitterList = specialize TFPGList<TParticleEmitter>;

  TParticleCollection = class;
  // this will be TParticleSystem
  // need get ops, get inits, get constriants

  { TParticleSystem }

  TParticleSystem = class
  public
     constructor Create;
  public
     function AddValue: TParticleData;
     function AddInit: TParticleOperation;
     function AddOp: TParticleOperation;
     function AddConstr: TParticleConstraint;
     function AddEmit: TParticleEmitter;

     procedure MoveUp(op: TParticleOperation);
     procedure MoveDown(op: TParticleOperation);

     procedure RemoveValue(val: TParticleData);
     procedure RemoveInit(op: TParticleOperation);
     procedure RemoveOp(op: TParticleOperation);
     procedure RemoveConstr(ct: TParticleConstraint);
     procedure RemoveEmit(em: TParticleEmitter);

     function GetInits: TParticleOperationList;
     function GetOps: TParticleOperationList;
     function GetConstrs: TParticleConstraintList;
     function GetEmits: TParticleEmitterList;
     function GetValues: TParticleDataList;
  public
     sprite: string;
     wire: string;
     model: string;

     particleLimit: string;

     isBase: Boolean;
  protected
     inits: TParticleOperationList;
     ops: TParticleOperationList;
     constrs: TParticleConstraintList;
     emits: TParticleEmitterList;
     values: TParticleDataList;
  end;

  TParticleSystemList = specialize TFPGList<TParticleSystem>;

  // PARTICLE FILE
  // This class holds info about a .prt particle file.

  TParticle = class(TAssetMetadata)
  public
      constructor Create(particleFileName: string; collection: TParticleCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function IsProcessable: Boolean; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadFromDisk; override;
      procedure SaveToDisk; override;

      procedure LoadMetadata(); override;

      function NewParticleSystem: TParticleSystem;
      procedure RemoveParticleSystem(particle: TParticleSystem);

      function NewControl: TParticleData;
      procedure RemoveControl(particle: TParticleData);

      function GetParticleSystems: TParticleSystemList;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected
      systems: TParticleSystemList;
      controls: TParticleDataList;
  end;

  TParticleCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     particles: array of TParticle;
  end;

implementation

// +---------------------------------------------------------------------------+
// |                                                                           |
// |                             PARTICLE DATA                                 |
// |                                                                           |
// +---------------------------------------------------------------------------+
constructor TParticleSystem.Create;
begin
  sprite := '';
  wire := '';
  model := '';

  particleLimit := '128';

  isBase := False;

  inits := TParticleOperationList.Create;
  ops := TParticleOperationList.Create;
  constrs := TParticleConstraintList.Create;
  emits := TParticleEmitterList.Create;
  values := TParticleDataList.Create;
end;

function TParticleSystem.AddValue: TParticleData;
begin
  Result := TParticleData.Create;
  values.Add(Result);
end;

function TParticleSystem.AddInit: TParticleOperation;
begin
  Result := TParticleOperation.Create;
  Result.isInit := True;
  inits.Add(Result);
end;

function TParticleSystem.AddOp: TParticleOperation;
begin
  Result := TParticleOperation.Create;
  Result.isInit := False;
  ops.Add(Result);
end;

function TParticleSystem.AddConstr: TParticleConstraint;
begin
  Result := TParticleConstraint.Create;
  constrs.Add(Result);
end;

function TParticleSystem.AddEmit: TParticleEmitter;
begin
  Result := TParticleEmitter.Create;
  emits.Add(Result);
end;

procedure TParticleSystem.MoveUp(op: TParticleOperation);
var
   index: Integer;
begin
  if op.isInit then begin
    index := inits.IndexOf(op);
    if (index <= 0) or (inits.Count < 2) then Exit;
    inits.Exchange(index, index-1);
  end else begin
    index := ops.IndexOf(op);
    if (index <= 0) or (ops.Count < 2) then Exit;
    ops.Exchange(index, index-1);
  end;
end;

procedure TParticleSystem.MoveDown(op: TParticleOperation);
var
   index: Integer;
begin
  if op.isInit then begin
    index := inits.IndexOf(op);
    if (index < 0) or (index+1 >= inits.Count) then Exit;
    inits.Exchange(index, index+1);
  end else begin
    index := ops.IndexOf(op);
    if (index < 0) or (index+1 >= ops.Count) then Exit;
    ops.Exchange(index, index+1);
  end;
end;

procedure TParticleSystem.RemoveValue(val: TParticleData);
begin
  values.Remove(val);
end;

procedure TParticleSystem.RemoveInit(op: TParticleOperation);
begin
  inits.Remove(op);
end;

procedure TParticleSystem.RemoveOp(op: TParticleOperation);
begin
  ops.Remove(op);
end;

procedure TParticleSystem.RemoveConstr(ct: TParticleConstraint);
begin
  constrs.Remove(ct);
end;

procedure TParticleSystem.RemoveEmit(em: TParticleEmitter);
begin
  emits.Remove(em);
end;

function TParticleSystem.GetInits: TParticleOperationList;
begin
  Result := inits;
end;

function TParticleSystem.GetOps: TParticleOperationList;
begin
  Result := ops;
end;

function TParticleSystem.GetConstrs: TParticleConstraintList;
begin
  Result := constrs;
end;

function TParticleSystem.GetEmits: TParticleEmitterList;
begin
  Result := emits;
end;

function TParticleSystem.GetValues: TParticleDataList;
begin
  Result := values;
end;

// +---------------------------------------------------------------------------+
// |                                                                           |
// |                             PARTICLE FILE                                 |
// |                                                                           |
// +---------------------------------------------------------------------------+
constructor TParticle.Create(particleFileName: string; collection: TParticleCollection);
begin
  self.name := particleFileName;
  self.parent := collection;
  self.systems := TParticleSystemList.Create;
end;

function TParticle.GetType: string;
begin
  Result := 'PARTICLE'
end;

function TParticle.GetPath: string;
begin
  Result := 'data/particles/' + name + '.prt';
end;

procedure TParticle.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TParticle.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TParticle.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TParticle.SetMetadata(const prop: string; value: Variant);
begin

end;
function TParticle.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TParticle.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TParticle.LoadFromDisk;
var
  assetFile: TAssetParser;
  rowIndex: Integer;
  system: TParticleSystem;
  data: TParticleData;
  op: TParticleOperation;
  ct: TParticleConstraint;
  em: TParticleEmitter;

  procedure ReadParam(index: Integer; p: TParticleParameter);
  begin
    p.paramType := assetFile.GetValue(index, 0);
    case p.paramType of
         'none':       Exit;
         'data':       p.data := assetFile.GetValue(index, 1);
         'scalar':     p.x := assetFile.GetValue(index, 1);
         'vector':     begin
             p.x := assetFile.GetValue(index, 1);
             p.y := assetFile.GetValue(index, 2);
             p.z := assetFile.GetValue(index, 3);
         end;
    end;
  end;
begin
  assetFile := TAssetParser.Create(GetPath);

  if not assetFile.IsOpen then
  begin
    WriteLn('was not loaded!!!!!');
    Exit;
  end;

  if assetFile.GetRowCount < 1 then
  begin
    WriteLn('was not loaded!!!!!');
    Exit;
  end;

  if assetFile.GetValue(0, 0) <> 'PRTv1' then
  begin
    WriteLn('INCORRECT HEADER!!!');
    Exit;
  end;

  rowIndex := 1;
  while rowIndex < assetFile.GetRowCount do begin

    if assetFile.GetValue(rowIndex, 0) = 'control' then begin
      data := self.NewControl;
      data.dataType := assetFile.GetValue(rowIndex, 2);
      data.dataName := assetFile.GetValue(rowIndex, 1);
      Inc(rowIndex);
      Continue;
    end;

    Inc(rowIndex);

    if assetFile.GetValue(rowIndex-1, 0) = 'base' then begin
      system := self.NewParticleSystem;
      system.isBase := True;
    end else if assetFile.GetValue(rowIndex-1, 0) = 'system' then begin
      system := self.NewParticleSystem;
      system.isBase := False;
    end else Continue;


    while rowIndex < assetFile.GetRowCount do case assetFile.GetValue(rowIndex, 0) of
       'sprite': begin
         system.sprite := assetFile.GetValue(rowIndex, 1);
         Inc(rowIndex);
       end;
       'wire': begin
         system.wire := assetFile.GetValue(rowIndex, 1);
         Inc(rowIndex);
       end;
       'model': begin
         system.model := assetFile.GetValue(rowIndex, 1);
         Inc(rowIndex);
       end;
       'value': begin
         data := system.AddValue;
         data.dataType := assetFile.GetValue(rowIndex, 2);
         data.dataName := assetFile.GetValue(rowIndex, 1);
         Inc(rowIndex);
       end;
       'initializer', 'operation': begin
         if assetFile.GetValue(rowIndex, 0) = 'initializer' then
            op := system.AddInit else op := system.AddOp;

         op.opType := assetFile.GetValue(rowIndex, 1);
         op.mergeType := assetFile.GetValue(rowIndex, 2);
         op.mergeDest := assetFile.GetValue(rowIndex, 3);
         op.target := assetFile.GetValue(rowIndex, 4);

         Inc(rowIndex); ReadParam(rowIndex, op.param1);
         Inc(rowIndex); ReadParam(rowIndex, op.param2);
         Inc(rowIndex); ReadParam(rowIndex, op.param3);
         Inc(rowIndex); ReadParam(rowIndex, op.param4);
         Inc(rowIndex);
       end;
       'constraint': begin
         ct := system.AddConstr;
         ct.ctType := assetFile.GetValue(rowIndex, 1);
         ct.mergeDest := assetFile.GetValue(rowIndex, 2);
         ct.target := assetFile.GetValue(rowIndex, 3);

         Inc(rowIndex); ReadParam(rowIndex, ct.param1);
         Inc(rowIndex); ReadParam(rowIndex, ct.param2);
         Inc(rowIndex); ReadParam(rowIndex, ct.param3);
         Inc(rowIndex); ReadParam(rowIndex, ct.param4);
         Inc(rowIndex);
       end;
       'emitter': begin
         em := system.AddEmit;
         Inc(rowIndex); ReadParam(rowIndex, em.rate);
         Inc(rowIndex); ReadParam(rowIndex, em.delay);
         Inc(rowIndex);
       end;
       'end': begin
         Inc(rowIndex);
         Break;
       end;
       else
         Inc(rowIndex);
    end;
  end;
end;

procedure TParticle.SaveToDisk;
var
  output: TAssetWriter;
  system: TParticleSystem;
  data: TParticleData;
  op: TParticleOperation;
  ct: TParticleConstraint;
  em: TParticleEmitter;

  procedure WriteParam(p: TParticleParameter);
  begin
    case p.paramType of
         'none':       output.Append(['none']);
         'data':       output.Append(['data', p.data]);
         'scalar':     output.Append(['scalar', p.x]);
         'vector':     output.Append(['vector', p.x, p.y, p.z]);
    end;
  end;
begin
  output := TAssetWriter.Create(GetPath);

  output.Append(['# Tramway SDK Particle File']);
  output.Append(['# Generated by: Particle Editor v0.1.1']);
  output.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  output.Append(nil);

  output.Append(['PRTv1']);
  output.Append(nil);

  for data in self.controls do begin
      output.Append(['control', data.dataName, data.dataType]);
  end;

  for system in self.systems do begin
    if system.isBase then
       output.Append(['base'])
    else
       output.Append(['system']);

    if system.sprite <> '' then output.Append(['sprite', system.sprite]);
    if system.wire <> '' then output.Append(['wire', system.wire]);
    if system.model <> '' then output.Append(['model', system.model]);

    for data in system.values do begin
      output.Append(['value', data.dataName, data.dataType]);
    end;

    for op in system.ops do begin
      output.Append(['operation', op.opType, op.mergeType, op.mergeDest, op.target]);
      WriteParam(op.param1); WriteParam(op.param2);
      WriteParam(op.param3); WriteParam(op.param4);
    end;

    for op in system.inits do begin
      output.Append(['initializer', op.opType, op.mergeType, op.mergeDest, op.target]);
      WriteParam(op.param1); WriteParam(op.param2);
      WriteParam(op.param3); WriteParam(op.param4);
    end;

    for ct in system.constrs do begin
      output.Append(['constraint', ct.ctType, ct.mergeDest, ct.target]);
      WriteParam(ct.param1); WriteParam(ct.param2);
      WriteParam(ct.param3); WriteParam(ct.param4);
    end;

    for em in system.emits do begin
      output.Append(['emitter']);
      WriteParam(em.rate); WriteParam(em.delay);
    end;

    output.Append(['end']);
  end;

  output.Free;
end;

procedure TParticle.LoadMetadata();
begin

end;

function TParticle.NewParticleSystem: TParticleSystem;
begin
  Result := TParticleSystem.Create;
  self.systems.Add(Result);
end;

procedure TParticle.RemoveParticleSystem(particle: TParticleSystem);
begin
  self.systems.Remove(particle);
end;

function TParticle.NewControl: TParticleData;
begin
  Result := TParticleData.Create;
  self.controls.Add(Result);
end;

procedure TParticle.RemoveControl(particle: TParticleData);
begin
  self.controls.Remove(particle);
end;


function TParticle.GetParticleSystems: TParticleSystemList;
begin
  Result := systems;
end;


constructor TParticleCollection.Create;
begin

end;

// +---------------------------------------------------------------------------+
// |                                                                           |
// |                          PARTICLE COLLECTION                              |
// |                                                                           |
// +---------------------------------------------------------------------------+
procedure TParticleCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  // TODO: check if asset in particles even
  for index := 0 to High(particles) do
      if particles[index] = asset then
         Break;
  for index := index to High(particles) - 1 do
      particles[index] := particles[index  + 1];
  SetLength(particles, Length(particles) - 1);
end;

procedure TParticleCollection.Clear;
var
  particle: TParticle;
begin
  for particle in self.particles do particle.Free;
  SetLength(particles, 0);
end;

procedure TParticleCollection.ScanFromDisk;
var
  files: TStringList;
  particleFile: string;
  particleName: string;
  particle: TParticle;
  particleCandidate: TParticle;
begin
  files := FindAllFiles('data/particles/', '*.prt', true);

  for particle in particles do
      particle.SetDateOnDisk(0);

  for particleFile in files do
  begin
    particle := nil;

    // extract asset name from path
    particleName := particleFile.Replace('\', '/');
    particleName := particleName.Replace('data/particles/', '');

    particleName := particleName.Replace('.prt', '');

    // check if particle already exists in database
    for particleCandidate in particles do
      if particleCandidate.GetName() = particleName then
      begin
        particle := particleCandidate;
        Break;
      end;

    // if exists, update date on disk
    if particle <> nil then
    begin
      particle.SetDateOnDisk(ActualFileAge(particleFile));
      Continue;
    end;

    // otherwise add it to database
    particle := TParticle.Create(particleName, self);
    particle.SetDateOnDisk(ActualFileAge(particleFile));

    SetLength(self.particles, Length(self.particles) + 1);
    self.particles[High(self.particles)] := particle;
  end;
end;

function TParticleCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  particle: TParticle;
  particle_candidate: TParticle;
begin
  particle := nil;

  for particle_candidate in particles do
      if particle_candidate.GetName() = name then
      begin
        particle := particle_candidate;
        Break;
      end;

  if particle <> nil then
  begin
    particle.SetDateInDB(date);
    Exit(particle);
  end;

  particle := TParticle.Create(name, self);
  particle.SetDateInDB(date);

  SetLength(self.particles, Length(self.particles) + 1);
  self.particles[High(self.particles)] := particle;

  Result := particle;
end;

function TParticleCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.particles));

  for i := 0 to High(self.particles) do
      Result[i] := self.particles[i];
end;

{ TParticleParameter }

constructor TParticleParameter.Create;
begin
  self.paramType := 'none';
  self.data := 'none';
  self.x := '0.0';
  self.y := '0.0';
  self.z := '0.0';
end;

{ TParticleData }

constructor TParticleData.Create;
begin
  self.dataType := 'scalar';
  self.dataName := 'none';
end;

{ TParticleOperation }

constructor TParticleOperation.Create;
begin
  self.opType := 'copy';
  self.mergeType := 'set';
  self.mergeDest := 'any';
  self.target := 'none';
  self.param1 := TParticleParameter.Create;
  self.param2 := TParticleParameter.Create;
  self.param3 := TParticleParameter.Create;
  self.param4 := TParticleParameter.Create;
  self.param1.paramType := 'scalar';
  self.param1.x := '0';

  self.isInit := False;
end;

procedure TParticleOperation.ToggleParams;
  procedure SetEnableParam(param: TParticleParameter; enabled: Boolean);
  begin
    if enabled and (param.paramType = 'none') then begin
      param.paramType := 'scalar';
    end;
    if (not enabled) and (param.paramType <> 'none') then begin
      param.paramType := 'none';
    end;
  end;
begin
  case opType of
       'copy': begin
         SetEnableParam(param1, True);
         SetEnableParam(param2, False);
         SetEnableParam(param3, False);
         SetEnableParam(param4, False);
       end;
       'oscillator': begin
         SetEnableParam(param1, True);
         SetEnableParam(param2, True);
         SetEnableParam(param3, True);
         SetEnableParam(param4, False);
       end;
       'noise': begin
         SetEnableParam(param1, True);
         SetEnableParam(param2, True);
         SetEnableParam(param3, False);
         SetEnableParam(param4, False);
       end;
       'clamp': begin
         SetEnableParam(param1, False);
         SetEnableParam(param2, False);
         SetEnableParam(param3, False);
         SetEnableParam(param4, False);
       end;
       'normalize': begin
         SetEnableParam(param1, False);
         SetEnableParam(param2, False);
         SetEnableParam(param3, False);
         SetEnableParam(param4, False);
       end;
  end;
end;

function TParticleOperation.GetParamName(param: Integer): string;
begin
  case opType of
       'copy': begin
         if param = 1 then Exit('VALUE'); Exit('N/A');
       end;
       'oscillator': begin
         if param = 1 then Exit('AMPLITUDE');
         if param = 2 then Exit('FREQUENCY');
         if param = 3 then Exit('PHASE'); Exit('N/A');
       end;
       'noise': begin
         if param = 1 then Exit('OFFSET');
         if param = 2 then Exit('AMPLITUDE'); Exit('N/A');
       end;
       'clamp': begin
         Exit('N/A');
       end;
       'normalize': begin
         Exit('N/A');
       end;
  end;
  Exit('UNKNOWN');
end;

{ TParticleConstraint }

constructor TParticleConstraint.Create;
begin
  self.ctType := 'lt';
  self.mergeDest := 'any';
  self.target := 'none';
  self.param1 := TParticleParameter.Create;
  self.param2 := TParticleParameter.Create;
  self.param3 := TParticleParameter.Create;
  self.param4 := TParticleParameter.Create;
  self.param1.paramType := 'scalar';
  self.param1.x := '0';
end;

procedure TParticleConstraint.ToggleParams;
  procedure SetEnableParam(param: TParticleParameter; enabled: Boolean);
  begin
    if enabled and (param.paramType = 'none') then begin
      param.paramType := 'scalar';
    end;
    if (not enabled) and (param.paramType <> 'none') then begin
      param.paramType := 'none';
    end;
  end;
begin
  case ctType of
       'lt', 'gt': begin
         SetEnableParam(param1, True);
         SetEnableParam(param2, False);
         SetEnableParam(param3, False);
         SetEnableParam(param4, False);
       end;
  end;
end;

function TParticleConstraint.GetParamName(param: Integer): string;
begin
  case ctType of
       'lt', 'gt': begin
         if param = 1 then Exit('VALUE'); Exit('N/A');
       end;
  end;
  Exit('UNKNOWN');
end;

{ TParticleEmitter }

constructor TParticleEmitter.Create;
begin
  self.rate := TParticleParameter.Create;
  self.delay := TParticleParameter.Create;
  self.rate.paramType := 'scalar';
  self.rate.x := '1';
  self.delay.paramType := 'scalar';
  self.delay.x := '1';
end;

end.

