unit TramAssetMetadataTest;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, TramAssetMetadata;

type

  TramAssetMetadataTestCase= class(TTestCase)
  published
    procedure MakeMetadata;
    procedure MetadataInitialDates;
  end;

implementation

procedure TramAssetMetadataTestCase.MakeMetadata;
var
  bepis: TAssetMetadata;
  tepis: TAssetMetadata;
begin
  bepis := TAssetMetadata.Create('data', 'Bepis');
  tepis := TAssetMetadata.Create('assets', 'bepi/tepis tepitong/tepi.pepi');

  AssertEquals(bepis.GetName(), 'Bepis');
  AssertEquals(tepis.GetName(), 'bepi/tepis tepitong/tepi.pepi');

  AssertEquals(bepis.GetPath(), 'data');
  AssertEquals(tepis.GetPath(), 'assets');
end;

procedure TramAssetMetadataTestCase.MetadataInitialDates;
var
  bepis: TAssetMetadata;
  tepis: TAssetMetadata;
begin
  bepis := TAssetMetadata.Create('data', 'Bepis');

  AssertEquals(bepis.GetDateInDB(), 0);
  AssertEquals(bepis.GetDateOnDisk(), 0);
  AssertEquals(bepis.GetDateInSource(), 0);
end;



initialization
  RegisterTest(TramAssetMetadataTestCase);
end.

