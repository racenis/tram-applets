unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, Menus,
  ComCtrls, ExtCtrls, StdCtrls, Grids, TramAssetDatabase, TramAssetMetadata,
  DateUtils, TramAssetWriter, TramAssetParser, RefreshNewFileDialogUnit;

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

  newAssets: array of TAssetMetadata;
  modifiedAssets: array of TAssetMetadata;
  removedAssets: array of TAssetMetadata;

  databaseFile: TAssetParser;
  databaseRecord: array of string;
begin
  newAssets := [];
  modifiedAssets := [];
  removedAssets := [];

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
      if asset.GetDateInDB = 0 then
         newAssets := Concat(newAssets, [asset])
      else if asset.GetDateOnDisk = 0 then
         removedAssets := Concat(removedAssets, [asset])
      else if asset.GetDateInDB < asset.GetDateOnDisk then
         modifiedAssets := Concat(modifiedAssets, [asset])
      else if asset.GetDateInDB <> asset.GetDateOnDisk then
         ShowMessage('Asset ' + asset.GetName + ' has a date of '
                            + FormatDateTime('yyyy-mm-dd hh:nn:ss',
                              FileDateToDateTime(asset.GetDateInDB))
                            + ' in the database, but a date of '
                            + FormatDateTime('yyyy-mm-dd hh:nn:ss',
                              FileDateToDateTime(asset.GetDateInDB))
                            + ' on disk. I think that this means'
                            + ' something, but I do not really know'
                            + ' what exactly.');

  if Length(newAssets) > 0 then
  begin
    RefreshNewFileDialog := TRefreshNewFileDialog.Create(self, newAssets);
    RefreshNewFileDialog.ShowModal;
    FreeAndNil(RefreshNewFileDialog);
  end;


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

