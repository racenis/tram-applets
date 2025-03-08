unit TramAudioAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// TODO:
// - Showing sample rate would be useful
// - Also sound length
// - Might be tricky, since .ogg files don't really have headers

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TAudioCollection = class;
  TAudio = class(TAssetMetadata)
  public
      constructor Create(audioName: string; collection: TAudioCollection);
      function GetType: string; override;
      function GetPath: string; override;

      procedure SetMetadata(const prop: string; value: Variant); override;
      function GetMetadata(const prop: string): Variant; override;

      function IsProcessable: Boolean; override;

      function GetPropertyList: TAssetPropertyList; override;

      procedure LoadMetadata(); override;
  protected
      procedure SetDateInDB(date: Integer);
      procedure SetDateOnDisk(date: Integer);
  protected

  end;

  TAudioCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     audios: array of TAudio;
  end;

implementation

constructor TAudio.Create(audioName: string; collection: TAudioCollection);
begin
  self.name := audioName;
  self.parent := collection;
end;

function TAudio.GetType: string;
begin
  Result := 'AUDIO';
end;

function TAudio.GetPath: string;
begin
  Result := 'data/audio/' + name + '.ogg';
end;

procedure TAudio.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TAudio.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TAudio.IsProcessable: Boolean;
begin
  Result := False;
end;

procedure TAudio.SetMetadata(const prop: string; value: Variant);
begin

end;
function TAudio.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TAudio.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TAudio.LoadMetadata();
begin

end;


constructor TAudioCollection.Create;
begin

end;

procedure TAudioCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(audios) do
      if audios[index] = asset then
         Break;
  if audios[index] <> asset then Exit;
  for index := index to High(audios) - 1 do
      audios[index] := audios[index  + 1];
  SetLength(audios, Length(audios) - 1);
end;

procedure TAudioCollection.Clear;
var
  animation: TAudio;
begin
  for animation in self.audios do animation.Free;
  SetLength(audios, 0);
end;

procedure TAudioCollection.ScanFromDisk;
var
  files: TStringList;
  audioFile: string;
  audioName: string;
  audio: TAudio;
  audioCandidate: TAudio;
begin
  files := FindAllFiles('data/audio', '*.ogg', true);

  for audio in audios do
      audio.SetDateOnDisk(0);

  for audioFile in files do
  begin
    audio := nil;

    // extract asset name from path
    audioName := audioFile.Replace('\', '/');
    audioName := audioName.Replace('data/audio/', '');

    audioName := audioName.Replace('.ogg', '');

    // check if audio already exists in database
    for audioCandidate in audios do
      if audioCandidate.GetName() = audioName then
      begin
        audio := audioCandidate;
        Break;
      end;

    // if exists, update date on disk
    if audio <> nil then
    begin
      audio.SetDateOnDisk(FileAge(audioFile));
      Continue;
    end;

    // otherwise add it to database
    audio := TAudio.Create(audioName, self);
    audio.SetDateOnDisk(FileAge(audioFile));

    SetLength(self.audios, Length(self.audios) + 1);
    self.audios[High(self.audios)] := audio;
  end;
end;

function TAudioCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  audio: TAudio;
  audioCandidate: TAudio;
begin
  audio := nil;

  for audioCandidate in audios do
      if audioCandidate.GetName() = name then
      begin
        audio := audioCandidate;
        Break;
      end;

  if audio <> nil then
  begin
    audio.SetDateInDB(date);
    Exit(audio);
  end;

  audio := TAudio.Create(name, self);
  audio.SetDateInDB(date);

  SetLength(self.audios, Length(self.audios) + 1);
  self.audios[High(self.audios)] := audio;

  Result := audio;
end;

function TAudioCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.audios));

  for i := 0 to High(self.audios) do
      Result[i] := self.audios[i];
end;

end.

