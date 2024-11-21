unit TramAssetMetadata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAssetCollection = class;
  TAssetMetadata = class
  public
     constructor Create(const path: string; const name: string; parent: TAssetCollection = nil);
     function GetName: string;
     function GetPath: string;
     function GetType: string; virtual;

     // TODO: yeet DateInSource
     // TODO: add source reference / setsource/getsource idk

     procedure Remove;

     procedure SetDateInDBAsOnDisk;

     function GetDateInDB: Integer;
     function GetDateOnDisk: Integer;
     function GetDateInSource: Integer;
  protected
     name: string;
     path: string;
     dateInDB: Integer;
     dateOnDisk: Integer;
     dateInSource: Integer;
     parent: TAssetCollection;
  end;
  TAssetMetadataArray = array of TAssetMetadata;
  TAssetCollection = class
  public
     //constructor Create();
     procedure Clear; virtual; abstract;
     procedure ScanFromDisk; virtual; abstract;
     procedure InsertFromDB(name: string; date: Integer); virtual; abstract;
     procedure Remove(asset: TAssetMetadata); virtual; abstract;
     function GetAssets: TAssetMetadataArray; virtual; abstract;
  end;

implementation

constructor TAssetMetadata.Create(const path: string; const name: string; parent: TAssetCollection = nil);
begin
  self.path := path;
  self.name := name;
  self.parent := parent;
  self.dateInDB := 0;
  self.dateOnDisk := 0;
  self.dateInSource := 0;
end;

procedure TAssetMetadata.SetDateInDBAsOnDisk;
begin
  self.dateInDB := self.dateOnDisk;
end;

procedure TAssetMetadata.Remove;
begin
  parent.Remove(self);
end;

function TAssetMetadata.GetName: string;
begin
  Result := self.name;
end;

function TAssetMetadata.GetPath: string;
begin
  Result := self.path;
end;

function TAssetMetadata.GetType: string;
begin
  Result := 'NONE';
end;



function TAssetMetadata.GetDateInDB: Integer;
begin
  Result := self.dateInDB;
end;

function TAssetMetadata.GetDateOnDisk: Integer;
begin
  Result := self.dateOnDisk;
end;

function TAssetMetadata.GetDateInSource: Integer;
begin
  Result := self.dateInSource;
end;

end.

