unit TramAssetCollection;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, TramAssetMetadata;

type
  TAssetCollection = class
  public
     constructor Create();
     procedure Clear; virtual; abstract;
     procedure ScanFromDisk; virtual; abstract;
     procedure InsertFromDB(name: string; date: Integer); virtual; abstract;
     function GetAssets: TAssetMetadataArray; virtual; abstract;
  end;

implementation

constructor TAssetCollection.Create();
begin
  ;
end;





end.

