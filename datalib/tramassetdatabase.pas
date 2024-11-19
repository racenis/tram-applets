unit TramAssetDatabase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Tram3DModelAsset, TramAssetMetadata;

type
  TAssetDatabase = class
  public
     constructor Create;
     procedure LoadFromDisk;
     procedure ScanFromDisk;
     procedure SaveToDisk;

     function GetAssets: TAssetMetadataArray;

     procedure InsertFromDB(assetType: string; name: string; date: Integer);

     protected
        collection3Dmodel: T3DModelCollection;
  end;

implementation

constructor TAssetDatabase.Create;
begin
  collection3Dmodel := T3DModelCollection.Create;
end;

procedure TAssetDatabase.LoadFromDisk;
begin
  // TODO: implement
end;

procedure TAssetDatabase.SaveToDisk;
begin
  // TODO: implement
end;

procedure TAssetDatabase.ScanFromDisk;
begin
  collection3Dmodel.ScanFromDisk;
end;

function TAssetDatabase.GetAssets: TAssetMetadataArray;
begin
  Result := collection3Dmodel.GetAssets;
end;

procedure TAssetDatabase.InsertFromDB(assetType: string; name: string; date: Integer);
begin
  case assetType of
       'STMDL', 'DYMDL', 'MDMDL': collection3Dmodel.InsertFromDB(name, date);
  end;
end;

end.

