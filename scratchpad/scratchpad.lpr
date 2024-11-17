program scratchpad;

uses
    TramAssetParser;

var
  parser: TAssetParser;
  row: Integer;
  col: Integer;
begin
  WriteLn('this is prog!');
  parser := TAssetParser.Create('../datalib/testdata/text.text');
  WriteLn(parser.IsOpen);

  for row := 0 to parser.GetRowCount() - 1 do
      begin
        Write('Row: ', row, ' Len: ', parser.GetColCount(row), ' is ');
        for col := 0 to parser.GetColCount(row) - 1 do
          begin
               Write('"', parser.GetValue(row, col), '" ');
          end;
        WriteLn('');
      end;


  ReadLn;
end.

