unit TramAssetWriterTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, TramAssetWriter,
  TramAssetParser;

type
  TramAssetWriterTestTest = class(TTestCase)
  published
    procedure TestInvalid;
    procedure TestWriteAnything;
    procedure TestWriteReadBack;
  end;

implementation

procedure TramAssetWriterTestTest.TestInvalid;
var
  writer: TAssetWriter;
begin
  writer := TAssetWriter.Create('testdata/invalid.test');

  // we didn't assign any data, so it should fail writing
  AssertEquals(writer.TryWrite(), False);

  writer.Free;
end;

procedure TramAssetWriterTestTest.TestWriteAnything;
var
  writer: TAssetWriter;
  text: TAssetWriterData;
begin
  writer := TAssetWriter.Create('testdata/writer.text');

  text := [['hello!', 'column2'], ['second line', 'text'], ['#this is a commenting@!!!']];
  writer.SetData(text);

  AssertEquals(writer.TryWrite(), True);

  writer.Free;
end;

procedure TramAssetWriterTestTest.TestWriteReadBack;
var
  writer: TAssetWriter;
  parser: TAssetParser;
  text: TAssetWriterData;
begin
  writer := TAssetWriter.Create('testdata/writer.text');

  text := [['text1', 'text2'], ['text3', 'text4'], ['text5', 'text6']];
  writer.SetData(text);
  writer.Free;

  parser := TAssetParser.Create('testdata/writer.text');
  AssertEquals(parser.IsOpen(), True);

  AssertEquals(parser.GetRowCount, Length(text));

  AssertEquals(parser.GetValue(0, 0), text[0, 0]);
  AssertEquals(parser.GetValue(0, 1), text[0, 1]);
  AssertEquals(parser.GetValue(1, 0), text[1, 0]);
  AssertEquals(parser.GetValue(1, 1), text[1, 1]);
  AssertEquals(parser.GetValue(2, 0), text[2, 0]);
  AssertEquals(parser.GetValue(2, 1), text[2, 1]);
end;

(*procedure TramAssetParserTestTest.TestCanOpen;
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
end;*)



initialization
  RegisterTest(TramAssetWriterTestTest);
end.

