program scratchpad;

uses
    TramAssetParser;

var
  parser: TAssetParser;
begin
  WriteLn('this is prog!');
  parser := TAssetParser.Create('testdata/text.text');
  WriteLn(parser.IsOpen);

  ReadLn;
end.

