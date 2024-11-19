unit TramAssetMetadata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAssetMetadata = class
  public
     constructor Create(const path: string; const name: string);
     function GetName: string;
     function GetPath: string;
     function GetType: string; virtual;

     // TODO: yeet DateInSource
     // TODO: add source reference / setsource/getsource idk

     function GetDateInDB: Integer;
     function GetDateOnDisk: Integer;
     function GetDateInSource: Integer;
  protected
     name: string;
     path: string;
     dateInDB: Integer;
     dateOnDisk: Integer;
     dateInSource: Integer;
  end;

implementation

constructor TAssetMetadata.Create(const path: string; const name: string);
begin
  self.path := path;
  self.name := name;
  self.dateInDB := 0;
  self.dateOnDisk := 0;
  self.dateInSource := 0;
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

