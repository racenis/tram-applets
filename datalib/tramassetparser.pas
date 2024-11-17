unit TramAssetParser;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

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
     data: array of array of string;
  end;

implementation

constructor TAssetParser.Create(const path: string);
type
  ParseState = (normal, whitespace, quote, comment);
var
  readFile: TextFile;
  line: string;
  splitLine: array of string;
  token: string;
  state: ParseState;
  c: Char;
begin
  if not FileExists(path) then
  begin
    self.opened := False;
    Exit();
  end;

  AssignFile(readFile, path);

  //try
     reset(readFile);

     // insert first token
     data := [['']];
     self.rowCount := 1;
     self.colCount := 1;

     // start the parse, char by char
     while True do
     begin

          // reads in next char
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
            rowCount := rowCount + 1;
            SetLength(data, rowCount);
            data[rowCount - 1] := [''];

            //Continue;
          end;

          //Write(state, #10);

          case state of
               normal:
                      begin

                           // check if end of token
                           if (c = #13) or (c = #9) or (c = ' ') then
                           begin
                              SetLength(data[rowCount - 1], Length(data[rowCount - 1]) + 1);
                              state := whitespace;
                              Continue;
                           end;

                           // append this char to token
                           data[rowCount - 1][High(data[rowCount - 1])] += c;


                           Write(c);
                      end;
               whitespace:
                      begin
                           if (c = #13) or (c = #10) or (c = #9) or (c = ' ') then Continue;

                           // if reached non-whitespace, i.e. new token
                           //Seek(readFile, FilePos(readFile) - 1);
                           state := normal;
                      end;
               comment:
                      begin
                           //Write('Comment char: ', c, #10);
                           if c = #10 then state := normal;
                           // switch to whitesapce, maybe?
                      end;
          end;




          //writeln('Text read from file: ', line);
          if EOF(readFile) then break;
     end;


     // TODO: replace this with a more robust parser

     (*while True do
     begin
          ReadLn(readFile, line);

          line := StringReplace(line, #9, ' ', [rfReplaceAll]);
          splitLine := SplitString(line, ' ');

          for token in splitLine do
          begin
               writeln('Token: "', token, '"');
          end;

          //writeln('Text read from file: ', line);
          if EOF(readFile) then break;
     end;*)
  //finally
     CloseFile(readFile);
  //end;

  for splitLine in data do
  begin
       for token in splitLine do
       begin
            Write('(', token, ') ');
       end;
       Write(#10);
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
