unit TramAssetParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

type
  TAssetParserData = array of array of string;
  TAssetParser = class
     constructor Create(const path: string; const limit: Integer = 0);
     destructor Destroy(); override;

     function GetRowCount: Integer;
     function GetColCount(const row: Integer): Integer;
     function GetValue(const row: Integer; const col: Integer): string;

     function GetData: TAssetParserData;

     function IsOpen(): Boolean;
  private
     rowCount: Integer;
     colCount: Integer;
     rowIndex: Integer;
     colIndex: Integer;
     opened: Boolean;
     data: array of array of string;
  end;

implementation

constructor TAssetParser.Create(const path: string; const limit: Integer);
type
  ParseState = (normal, whitespace, quote, comment);
var
  readFile: File of Char;
  token: string;
  state: ParseState;
  c: Char;
begin
  // init properties
  data := [[]];
  self.rowCount := 1;
  self.colCount := 0;
  self.rowIndex := 0;
  self.colIndex := 0;

  // check if file exists
  if not FileExists(path) then
  begin
    self.opened := False;
    Exit();
  end;

  // open file
  Assign(readFile, path);
  Reset(readFile);

  // init first token
  token := '';

  // start the parse, char by char
  while True do
  begin

      // check if end of file
      if EOF(readFile) then Break;

      // read in next char
      Read(readFile, c);

      // check for comment
      if c = '#' then
      begin
         state := comment;
         Continue;
      end;

      // check if newline
      if c = #10 then
      begin
         // append token
         if token <> '' then
         begin
            SetLength(data[rowIndex], colIndex + 1);
            data[rowIndex][colIndex] := token;
            token := '';
            colIndex += 1;
         end;

         // add new line
         if data[rowIndex] <> nil then
         begin
            self.rowCount += 1;
            self.rowIndex += 1;
            SetLength(data, rowCount);
            data[rowIndex] := [];
         end;

         colIndex := 0;

         state := whitespace;

         // check if reached line limit
         if (limit <> 0) and (rowCount > limit) then Break;
      end;

      case state of
           normal:
                  begin

                       // check if end of token
                       if (c = #9) or (c = ' ') then
                       begin
                          // append token
                           SetLength(data[rowIndex], colIndex + 1);
                           data[rowIndex][colIndex] := token;
                           token := '';
                           colIndex += 1;

                          state := whitespace;
                          Continue;
                       end;

                       // check if quote starts
                       if c = '"' then
                       begin
                          state := quote;
                          Continue;
                       end;

                       // append this char to token
                       if (c <> #13) and (c <> #10) then token += c;

                  end;
           whitespace:
                  begin
                       if (c = #13) or (c = #10) or (c = #9) or (c = ' ') then Continue;

                       // if reached non-whitespace, i.e. new token
                       Seek(readFile, FilePos(readFile) - 1);
                       state := normal;
                  end;
           quote:
                  begin
                       if c = '"' then
                       begin
                          state := normal;
                          Continue;
                       end;

                       token += c;
                  end;
           comment:
                  begin
                       if c = #10 then state := whitespace;
                  end;
      end;

  end;

  // append final token if it was being parsed when file ended
  if token <> '' then
  begin
    SetLength(data[rowIndex], colIndex + 1);
    data[rowIndex][colIndex] := token;
  end;

  // if last row is empty, yeet it
  if Length(data[rowIndex]) = 0 then rowCount -= 1;

  CloseFile(readFile);

  (*for splitLine in data do
  begin
       for token in splitLine do
       begin
            Write('(', token, ') ');
       end;
       Write(#10);
  end;*)

  self.opened := True;
end;

destructor TAssetParser.Destroy();
begin
  SetLength(data, 0);
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
  Result := Length(data[row]);
end;

function TAssetParser.GetValue(const row: Integer; const col: Integer): string;
begin
  Result := data[row][col];
end;

function TAssetParser.GetData: TAssetParserData;
begin
  Result := data;
end;




end.
