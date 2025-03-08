unit TramScriptAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

// Possible improvements.
// Currently we only have Lua scripting. In the future we might have more
// scripting languages, so it might be useful to take that into account.

type
  TScriptCollection = class;
  TScript = class(TAssetMetadata)
  public
      constructor Create(scriptName: string; collection: TScriptCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function IsProcessable: Boolean; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected

  end;

  TScriptCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     scripts: array of TScript;
  end;

implementation

constructor TScript.Create(scriptName: string; collection: TScriptCollection);
begin
  self.name := scriptName;
  self.parent := collection;
end;

function TScript.GetType: string;
begin
  Result := 'SCRIPT';
end;

function TScript.GetPath: string;
begin
  Result := 'scripts/' + name + '.lua';
end;

procedure TScript.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TScript.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TScript.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TScript.SetMetadata(const prop: string; value: Variant);
begin

end;
function TScript.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TScript.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TScript.LoadMetadata();
begin

end;


constructor TScriptCollection.Create;
begin

end;

procedure TScriptCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(scripts) do
      if scripts[index] = asset then
         Break;
  if scripts[index] <> asset then Exit;
  for index := index to High(scripts) - 1 do
      scripts[index] := scripts[index  + 1];
  SetLength(scripts, Length(scripts) - 1);
end;

procedure TScriptCollection.Clear;
var
  script: TScript;
begin
  for script in self.scripts do script.Free;
  SetLength(scripts, 0);
end;

procedure TScriptCollection.ScanFromDisk;
var
  files: TStringList;
  scriptFile: string;
  scriptName: string;
  script: TScript;
  scriptCandidate: TScript;
begin
  files := FindAllFiles('scripts/', '*.lua', true);

  for script in scripts do
      script.SetDateOnDisk(0);

  for scriptFile in files do
  begin
    script := nil;

    // extract asset name from path
    scriptName := scriptFile.Replace('\', '/');
    scriptName := scriptName.Replace('scripts/', '');

    scriptName := scriptName.Replace('.lua', '');

    // check if script already exists in database
    for scriptCandidate in scripts do
      if scriptCandidate.GetName() = scriptName then
      begin
        script := scriptCandidate;
        Break;
      end;

    // if exists, update date on disk
    if script <> nil then
    begin
      script.SetDateOnDisk(FileAge(scriptFile));
      Continue;
    end;

    // otherwise add it to database
    script := TScript.Create( scriptName, self);
    script.SetDateOnDisk(FileAge(scriptFile));

    SetLength(self.scripts, Length(self.scripts) + 1);
    self.scripts[High(self.scripts)] := script;
  end;
end;

function TScriptCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  script: TScript;
  scriptCandidate: TScript;
begin
  script := nil;

  for scriptCandidate in scripts do
      if scriptCandidate.GetName() = name then
      begin
        script := scriptCandidate;
        Break;
      end;

  if script <> nil then
  begin
    script.SetDateInDB(date);
    Exit(script);
  end;

  script := TScript.Create(name, self);
  script.SetDateInDB(date);

  SetLength(self.scripts, Length(self.scripts) + 1);
  self.scripts[High(self.scripts)] := script;

  Result := script;
end;

function TScriptCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.scripts));

  for i := 0 to High(self.scripts) do
      Result[i] := self.scripts[i];
end;

end.

