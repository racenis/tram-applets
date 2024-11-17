unit TramAssetParserTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, TramAssetParser;

type

  TramAssetParserTestTest= class(TTestCase)
  published
    procedure TestInvalid;
    procedure TestCanOpen;
    procedure TestCanParse;
  end;

implementation

procedure TramAssetParserTestTest.TestInvalid;
var
  parser: TAssetParser;
begin
  parser := TAssetParser.Create('testdata/invalid.test');

  AssertEquals(parser.IsOpen(), False)
end;

procedure TramAssetParserTestTest.TestCanOpen;
var
  parser: TAssetParser;
begin
  parser := TAssetParser.Create('testdata/text.text');

  AssertEquals(parser.IsOpen(), True);

  FreeAndNil(parser);
end;

procedure TramAssetParserTestTest.TestCanParse;
var
  parser: TAssetParser;
begin
  parser := TAssetParser.Create('testdata/text.text');

  AssertEquals(parser.IsOpen(), True);

  AssertEquals(parser.GetRowCount(), 5);
  AssertEquals(parser.GetColCount(0), 4);
  AssertEquals(parser.GetColCount(1), 4);
  AssertEquals(parser.GetColCount(2), 3);
  AssertEquals(parser.GetColCount(3), 5);
  AssertEquals(parser.GetColCount(4), 3);

  FreeAndNil(parser);
end;



initialization

  RegisterTest(TramAssetParserTestTest);
end.

