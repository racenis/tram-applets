unit tramassetdatabase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Tram3DModelAsset;

type
  TAssetDatabase = class
  public
     constructor Create;
     procedure LoadFromDisk;
     procedure ScanFromDisk;
     procedure SaveToDisk;

     protected
        collection3Dmodel: T3DModelCollection;
  end;

implementation

constructor TAssetDatabase.Create;
begin
  self.collection3Dmodel.Create;
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


end.

