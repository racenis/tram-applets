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
    procedure TestCanParseCorrectly;
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

procedure TramAssetParserTestTest.TestCanParseCorrectly;
var
  parser: TAssetParser;
begin
  parser := TAssetParser.Create('testdata/text.text');

  AssertEquals(parser.IsOpen(), True);

  AssertEquals(parser.GetValue(0, 0), 'hello');
  AssertEquals(parser.GetValue(0, 1), 'this');
  AssertEquals(parser.GetValue(0, 2), 'is');
  AssertEquals(parser.GetValue(0, 3), 'line');

  AssertEquals(parser.GetValue(4, 0), 'THIS');
  AssertEquals(parser.GetValue(4, 1), ' is   ca  kcakke kkeeke');
  AssertEquals(parser.GetValue(4, 2), 'yes');

  FreeAndNil(parser);
end;



initialization

  RegisterTest(TramAssetParserTestTest);
end.

