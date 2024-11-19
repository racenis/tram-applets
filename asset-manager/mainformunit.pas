unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, ExtCtrls, StdCtrls, Grids, TramAssetDatabase, TramAssetMetadata,
  DateUtils, TramAssetWriter, TramAssetParser;

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
    procedure SaveDBClick(Sender: TObject);
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

  databaseFile: TAssetParser;
  databaseRecord: array of string;
begin

  // load in database file
  databaseFile := TAssetParser.Create('asset.db');
  if not databaseFile.IsOpen then
     ShowMessage('Database file not found!')
  else
     for databaseRecord in databaseFile.GetData do
         if Length(databaseRecord) = 3 then
            database.InsertFromDB(databaseRecord[0],
                                  databaseRecord[1],
                                  databaseRecord[2].ToInteger);
  databaseFile.Free;

  // check what files exist on disk
  database.ScanFromDisk;

  // check which files have changed since database was saved
  for asset in database.GetAssets do
      if asset.GetDateOnDisk <> asset.GetDateInDB then
         ShowMessage('Not matvh up!! ' + asset.GetName);


  // populate asset list
  row := 1;
  for asset in database.GetAssets do
  begin
    if asset.GetDateInDB <> 0 then
       date := FormatDateTime('yyyy-mm-dd hh:nn:ss',
                              FileDateToDateTime(asset.GetDateInDB))
    else
       date := 'N/A';

    StringGrid.InsertRowWithValues(row, [asset.GetType,
                                         asset.GetName,
                                         date]);
    row += 1;
  end;
end;

procedure TMainForm.SaveDBClick(Sender: TObject);
var
  databaseFile: TAssetWriter;
  asset: TAssetMetadata;
begin
  databaseFile := TAssetWriter.Create('asset.db');

  databaseFile.Append(['# Tramway SDK Asset Manager Applet Database']);
  databaseFile.Append(['# Generated on: ' + DateTimeToStr(Now)]);
  databaseFile.Append(nil);

  for asset in database.GetAssets do
      databaseFile.Append([asset.GetType,
                           asset.GetName,
                           asset.GetDateOnDisk.ToString]);
  databaseFile.Free;
end;

initialization
begin
  database := TAssetDatabase.Create;
end;

end.

