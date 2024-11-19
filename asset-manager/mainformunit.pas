unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, ExtCtrls, StdCtrls, Grids, TramAssetDatabase, TramAssetMetadata,
  DateUtils;

type

  { TMainForm }

  TMainForm = class(TForm)
    FilterButton: TButton;
    DBGrid: TDBGrid;
    FilterClear: TButton;
    FilterName: TEdit;
    FilterType: TComboBox;
    GroupBox1: TGroupBox;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    AssetMenu: TMenuItem;
    LoadDB: TMenuItem;
    Import: TMenuItem;
    Panel1: TPanel;
    SaveDB: TMenuItem;
    StatusBar: TStatusBar;
    StringGrid: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  MainForm: TMainForm;
  database: TAssetDatabase;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
var
  row: Integer;
  asset: TAssetMetadata;
  date: string;
begin
     //ShowMessage('Hewwoo!!');
  row := 1;

  for asset in database.GetAssets do
  begin
    date := FormatDateTime('yyyy-mm-dd hh:nn:ss',
                           FileDateToDateTime(asset.GetDateOnDisk));
    StringGrid.InsertRowWithValues(row, [asset.GetType,
                                         asset.GetName,
                                         date]);
    row += 1;
  end;

//WriteLn('ADADAWDAW');
  //StringGrid.InsertRowWithValues(1, ['aa', 'ee', 'oo']);
end;

initialization
begin
  database := TAssetDatabase.Create;
  database.ScanFromDisk;
end;

end.

