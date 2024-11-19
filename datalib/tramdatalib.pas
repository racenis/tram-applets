{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit tramdatalib;

{$warn 5023 off : no warning about unused units}
interface

uses
  TramAssetParser, TramAssetMetadata, TramAssetMetadataTest, 
  TramAssetParserTest, TramAssetCollection, Tram3DModelAsset, 
  LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('tramdatalib', @Register);
end.
