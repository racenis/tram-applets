unit TramAssetMetadataTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, TramAssetMetadata;

type

  TramAssetMetadataTestCase= class(TTestCase)
  published
    procedure MakeMetadata;
  end;

implementation

procedure TramAssetMetadataTestCase.MakeMetadata;
var
  bepis: TAssetMetadata;
  tepis: TAssetMetadata;
begin
  bepis := TAssetMetadata.Create('Bepis');
  tepis := TAssetMetadata.Create('bepi/tepis tepitong/tepi.pepi');

  AssertEquals(bepis.GetName(), 'Bepis');
  AssertEquals(tepis.GetName(), 'bepi/tepis tepitong/tepi.pepi');
end;



initialization
  RegisterTest(TramAssetMetadataTestCase);
end.

