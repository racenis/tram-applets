unit MainFormDB;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB;

type
  MainFormDataset = class(TDataset)
    function GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    procedure InternalClose; override;
    procedure InternalOpen; override;
    procedure InternalInitFieldDefs; override;
    function IsCursorOpen: Boolean; override;
  end;


implementation

//procedure MainFormDataset.Open;
//begin
// do whatevs
//end;

procedure MainFormDataset.InternalOpen;
begin
// do whatevs
end;

procedure MainFormDataset.InternalClose;
begin
// do whatevs
end;

procedure MainFormDataset.InternalInitFieldDefs;
begin
// do whatevs
end;

function MainFormDataset.IsCursorOpen: Boolean;
begin
// do whatevs
end;

function MainFormDataset.GetRecord(Buffer: TRecordBuffer; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
begin

end;

end.

