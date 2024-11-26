unit TramLanguageAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TLanguageCollection = class;
  TLanguage = class(TAssetMetadata)
  public
      constructor Create(languageName: string; collection: TLanguageCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected

  end;

  TLanguageCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     languages: array of TLanguage;
  end;

implementation

constructor TLanguage.Create(languageName: string; collection: TLanguageCollection);
begin
  self.name := languageName;
  self.parent := collection;
end;

function TLanguage.GetType: string;
begin
  Result := 'LANG';
end;

function TLanguage.GetPath: string;
begin
  Result := 'data/' + name + '.lang';
end;

procedure TLanguage.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TLanguage.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TLanguage.SetMetadata(const prop: string; value: Variant);
begin

end;
function TLanguage.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TLanguage.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TLanguage.LoadMetadata();
begin

end;


constructor TLanguageCollection.Create;
begin

end;

procedure TLanguageCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(languages) do
      if languages[index] = asset then
         Break;
  if languages[index] <> asset then Exit;
  for index := index to High(languages) - 1 do
      languages[index] := languages[index  + 1];
  SetLength(languages, Length(languages) - 1);
end;

procedure TLanguageCollection.Clear;
var
  language: TLanguage;
begin
  for language in self.languages do language.Free;
  SetLength(languages, 0);
end;

procedure TLanguageCollection.ScanFromDisk;
var
  files: TStringList;
  languageFile: string;
  languageName: string;
  language: TLanguage;
  languageCandidate: TLanguage;
begin
  files := FindAllFiles('data/', '*.lang', true);

  for language in languages do
      language.SetDateOnDisk(0);

  for languageFile in files do
  begin
    language := nil;

    // extract asset name from path
    languageName := languageFile.Replace('\', '/');
    languageName := languageName.Replace('data/', '');

    languageName := languageName.Replace('.lang', '');

    // check if language already exists in database
    for languageCandidate in languages do
      if languageCandidate.GetName() = languageName then
      begin
        language := languageCandidate;
        Break;
      end;

    // if exists, update date on disk
    if language <> nil then
    begin
      language.SetDateOnDisk(FileAge(languageFile));
      Continue;
    end;

    // otherwise add it to database
    language := TLanguage.Create( languageName, self);
    language.SetDateOnDisk(FileAge(languageFile));

    SetLength(self.languages, Length(self.languages) + 1);
    self.languages[High(self.languages)] := language;
  end;
end;

function TLanguageCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  language: TLanguage;
  languageCandidate: TLanguage;
begin
  language := nil;

  for languageCandidate in languages do
      if languageCandidate.GetName() = name then
      begin
        language := languageCandidate;
        Break;
      end;

  if language <> nil then
  begin
    language.SetDateInDB(date);
    Exit(language);
  end;

  language := TLanguage.Create(name, self);
  language.SetDateInDB(date);

  SetLength(self.languages, Length(self.languages) + 1);
  self.languages[High(self.languages)] := language;

  Result := language;
end;

function TLanguageCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.languages));

  for i := 0 to High(self.languages) do
      Result[i] := self.languages[i];
end;

end.

