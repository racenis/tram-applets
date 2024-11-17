unit TramAssetParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAssetParser = class
     constructor Create(const path: string);
     destructor Destroy(); override;

     function GetRowCount: Integer;
     function GetColCount(const row: Integer): Integer;
     function GetValue(const col: Integer; const row: Integer): string;

     function IsOpen(): Boolean;
  private
     rowCount: Integer;
     colCount: Integer;
     opened: Boolean;
  end;

implementation

constructor TAssetParser.Create(const path: string);
var
  readFile: TextFile;
  line: string;
begin
  if not FileExists(path) then
  begin
    self.opened := False;
    Exit();
  end;

  AssignFile(readFile, path);

  try
     reset(readFile);
     readln(readFile, line);
     //writeln('Text read from file: ', line)
     ShowMessage(line);
  finally
     CloseFile(readFile)
  end;

  self.opened := True;
end;

destructor TAssetParser.Destroy();
begin
  // TODO: do whatever
  Inherited;
end;

function TAssetParser.IsOpen(): Boolean;
begin
  Result := opened;
end;

function TAssetParser.GetRowCount: Integer;
begin
  Result := rowCount;
end;

function TAssetParser.GetColCount(const row: Integer): Integer;
begin
  Result := colCount;
end;

function TAssetParser.GetValue(const col: Integer; const row: Integer): string;
begin

end;




end.
