unit TramShaderAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// TODO: have the shader store the proper extension
// TODO: have the shader store which type it is (opengl4, opengles, etc)

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TShaderCollection = class;
  TShader = class(TAssetMetadata)
  public
      constructor Create(shaderName: string; collection: TShaderCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected

  end;

  TShaderCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     shaders: array of TShader;
  end;

implementation

constructor TShader.Create(shaderName: string; collection: TShaderCollection);
begin
  self.name := shaderName;
  self.parent := collection;
end;

function TShader.GetType: string;
begin
  Result := 'SHADER';
end;

function TShader.GetPath: string;
begin
  Result := 'shaders/' + name + '.glsl';
end;

procedure TShader.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TShader.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TShader.SetMetadata(const prop: string; value: Variant);
begin

end;
function TShader.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TShader.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TShader.LoadMetadata();
begin

end;


constructor TShaderCollection.Create;
begin

end;

procedure TShaderCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(shaders) do
      if shaders[index] = asset then
         Break;
  if shaders[index] <> asset then Exit;
  for index := index to High(shaders) - 1 do
      shaders[index] := shaders[index  + 1];
  SetLength(shaders, Length(shaders) - 1);
end;

procedure TShaderCollection.Clear;
var
  shader: TShader;
begin
  for shader in self.shaders do shader.Free;
  SetLength(shaders, 0);
end;

procedure TShaderCollection.ScanFromDisk;
var
  files: TStringList;
  shaderFile: string;
  shaderName: string;
  shader: TShader;
  shaderCandidate: TShader;
begin
  files := FindAllFiles('shaders/', '*.vert;*.frag;*.glsl', true);

  for shader in shaders do
      shader.SetDateOnDisk(0);

  for shaderFile in files do
  begin
    shader := nil;

    // extract asset name from path
    shaderName := shaderFile.Replace('\', '/');
    shaderName := shaderName.Replace('shaders/opengl3/', '');
    shaderName := shaderName.Replace('shaders/gles3/', '');

    shaderName := shaderName.Remove(Length(shaderName) - Length('.glsl'));

    // check if shader already exists in database
    for shaderCandidate in shaders do
      if shaderCandidate.GetName() = shaderName then
      begin
        shader := shaderCandidate;
        Break;
      end;

    // if exists, update date on disk
    if shader <> nil then
    begin
      shader.SetDateOnDisk(FileAge(shaderFile));
      Continue;
    end;

    // otherwise add it to database
    shader := TShader.Create( shaderName, self);
    shader.SetDateOnDisk(FileAge(shaderFile));

    SetLength(self.shaders, Length(self.shaders) + 1);
    self.shaders[High(self.shaders)] := shader;
  end;
end;

function TShaderCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  shader: TShader;
  shaderCandidate: TShader;
begin
  shader := nil;

  for shaderCandidate in shaders do
      if shaderCandidate.GetName() = name then
      begin
        shader := shaderCandidate;
        Break;
      end;

  if shader <> nil then
  begin
    shader.SetDateInDB(date);
    Exit(shader);
  end;

  shader := TShader.Create(name, self);
  shader.SetDateInDB(date);

  SetLength(self.shaders, Length(self.shaders) + 1);
  self.shaders[High(self.shaders)] := shader;

  Result := shader;
end;

function TShaderCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.shaders));

  for i := 0 to High(self.shaders) do
      Result[i] := self.shaders[i];
end;

end.

