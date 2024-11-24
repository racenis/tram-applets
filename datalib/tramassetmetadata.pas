unit TramAssetMetadata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAssetCollection = class;
  TAssetPropertyList = array of string;
  TAssetMetadata = class
  public
     constructor Create(const path: string; const name: string; parent: TAssetCollection = nil);
     function GetName: string;
     function GetPath: string; virtual;
     function GetType: string; virtual;

     procedure SetMetadata(const {%H-}prop: string; {%H-}value: Variant); virtual;
     function GetMetadata(const {%H-}prop: string): Variant; virtual;

     function GetPropertyList: TAssetPropertyList; virtual;

     procedure LoadMetadata(); virtual;
     procedure LoadFromDisk(); virtual;
     // TODO: yeet DateInSource
     // TODO: add source reference / setsource/getsource idk

     procedure Remove;

     procedure SetDateInDBAsOnDisk;
     procedure ResetBothDates;

     function GetDateInDB: Integer;
     function GetDateOnDisk: Integer;
     function GetDateInSource: Integer;

     function GetAlwaysProcess: Boolean;
     function GetIgnoreModified: Boolean;

     procedure SetAlwaysProcess(value: Boolean);
     procedure SetIgnoreModified(value: Boolean);
  protected
     name: string;
     path: string;
     dateInDB: Integer;
     dateOnDisk: Integer;
     dateInSource: Integer;
     parent: TAssetCollection;
     alwaysProcess: Boolean;
     ignoreModified: Boolean;
  end;
  TAssetMetadataArray = array of TAssetMetadata;
  TAssetCollection = class
  public
     //constructor Create();
     procedure Clear; virtual; abstract;
     procedure ScanFromDisk; virtual; abstract;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; virtual; abstract;
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

procedure TAssetMetadata.ResetBothDates;
begin
  self.dateOnDisk := FileAge(self.GetPath);
  self.dateInDB := dateOnDisk;
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


procedure TAssetMetadata.SetMetadata(const prop: string; value: Variant);
begin
  ;
end;

function TAssetMetadata.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TAssetMetadata.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TAssetMetadata.LoadMetadata();
begin
  ;
end;

procedure TAssetMetadata.LoadFromDisk();
begin
  ;
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


function TAssetMetadata.GetAlwaysProcess: Boolean;
begin
  Result := self.alwaysProcess;
end;

function TAssetMetadata.GetIgnoreModified: Boolean;
begin
  Result := self.ignoreModified;
end;

procedure TAssetMetadata.SetAlwaysProcess(value: Boolean);
begin
  self.alwaysProcess := value;
end;

procedure TAssetMetadata.SetIgnoreModified(value: Boolean);
begin
  self.ignoreModified := value;
end;

end.

