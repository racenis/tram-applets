unit TramAssetWriter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAssetWriterData = array of array of string;
  TAssetWriterLine = array of string;
  TAssetWriter = class
     constructor Create(const path: string);
     destructor Destroy(); override;

     procedure SetData(data: TAssetWriterData);
     procedure Append(line: TAssetWriterLine);

     function TryWrite(): Boolean;
  private
     writePerformed: Boolean;
     writeSuccess: Boolean;

     path: string;
     data: array of array of string;
  end;

implementation

constructor TAssetWriter.Create(const path: string);
begin
  self.writePerformed := False;
  self.writeSuccess := False;

  self.path := path;
  self.data := nil;
end;

destructor TAssetWriter.Destroy();
begin
  if not writePerformed then TryWrite;
end;

procedure TAssetWriter.SetData(data: TAssetWriterData);
begin
  self.data := data;
end;

procedure TAssetWriter.Append(line: TAssetWriterLine);
begin
  SetLength(self.data, Length(self.data) + 1);
  self.data[High(self.data)] := line;
end;

function TAssetWriter.TryWrite(): Boolean;
var
  colCount: Integer;
  colWidth: array of Integer;
  line: array of string;
  token: string;
  col: Integer;
  outputFile: TFileStream;
begin

  // check if data is set for writing
  if data = nil then
  begin
    self.writePerformed := True;
    self.writeSuccess := False;
    Exit(False);
  end;

  // count out how many columns we will have
  colCount := 0;
  colWidth := nil;

  for line in data do
    if Length(line) > colCount then
       colCount := Length(line);

  // find widths of each column
  SetLength(colWidth, colCount);
  for col := 0 to High(colWidth) do
    colWidth[col] := 0;

  for line in data do
    for col := 0 to High(line) do
        if not line[col].StartsWith('#') then
          if Length(line[col]) > colWidth[col] then
             colWidth[col] := Length(line[col]);

  // write out the file
  try
    outputFile := TFileStream.Create(self.path, fmCreate);

    for line in data do
      begin
        for col := 0 to High(line) do
          begin
            token := line[col];

            // maybe in the future we will automatically add quotes, instead of
            // replacing spaces, but currently the C++ runtime doesn't know what
            // to do with quotes if we are writing what is supposed to be a name
            if (not token.StartsWith('"')) and (not token.StartsWith('#')) then
               token := token.Replace(' ', '-');

            token := token.PadRight(colWidth[col] + 1);

            outputFile.Write(token[1], Length(token));
          end;
        token := #10;
        outputFile.Write(token[1], 1);
      end;

    outputFile.Free;

  // handle write error
  except
    on E: Exception do
       begin
         self.writePerformed := True;
         self.writeSuccess := False;
         Exit(False);
       end;
  end;


  Result := True;
end;

end.

