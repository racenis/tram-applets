unit TramAssetMetadata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAssetMetadata = class
  public
     constructor Create(const name: string);
     function GetName: string;
  protected
     name: string;
  end;

implementation

constructor TAssetMetadata.Create(const name: string);
begin
  self.name := name;
end;

function TAssetMetadata.GetName: string;
begin
  Result := self.name;
end;




end.
