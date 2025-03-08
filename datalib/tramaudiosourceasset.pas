unit TramAudioSourceAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// TODO:
// - add bitrate property
// - add channel overide property (mono/stereo)
// - these settings will be used when converting files

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TAudioSourceCollection = class;
  TAudioSource = class(TAssetMetadata)
  public
      constructor Create(ext: string; animationName: string; collection: TAudioSourceCollection);
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
      fileExtension: string;
  end;

  TAudioSourceCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     audioSources: array of TAudioSource;
  end;

implementation

constructor TAudioSource.Create(ext: string; animationName: string; collection: TAudioSourceCollection);
begin
  self.name := animationName;
  self.parent := collection;

  self.fileExtension := ext;
end;

function TAudioSource.GetType: string;
begin
  Result := 'AUDIOSRC';
end;

function TAudioSource.GetPath: string;
begin
  Result := 'source/' + name + fileExtension;
end;

procedure TAudioSource.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TAudioSource.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

function TAudioSource.IsProcessable: Boolean;
begin
  Result := True;
end;

procedure TAudioSource.SetMetadata(const prop: string; value: Variant);
begin

end;
function TAudioSource.GetMetadata(const prop: string): Variant;
begin
  Result := nil;
end;

function TAudioSource.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TAudioSource.LoadMetadata();
begin

end;


constructor TAudioSourceCollection.Create;
begin

end;

procedure TAudioSourceCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(audioSources) do
      if audioSources[index] = asset then
         Break;
  if audioSources[index] <> asset then Exit;
  for index := index to High(audioSources) - 1 do
      audioSources[index] := audioSources[index  + 1];
  SetLength(audioSources, Length(audioSources) - 1);
end;

procedure TAudioSourceCollection.Clear;
var
  animation: TAudioSource;
begin
  for animation in self.audioSources do animation.Free;
  SetLength(audioSources, 0);
end;

procedure TAudioSourceCollection.ScanFromDisk;
var
  files: TStringList;
  audioSourceFile: string;
  audioName: string;
  fileExtension: string;
  audioSource: TAudioSource;
  audioSourceCandidate: TAudioSource;
begin
  files := FindAllFiles('data/audio', '*.wav;*.wma;*.flac;*.mp3', true);

  for audioSource in audioSources do
      audioSource.SetDateOnDisk(0);

  for audioSourceFile in files do
  begin
    audioSource := nil;

    // extract asset name from path
    audioName := audioSourceFile.Replace('\', '/');
    audioName := audioName.Replace('source/', '');

    if audioName.EndsWith('.wav') then begin
      fileExtension := '.wav';
      audioName := audioName.Replace('.wav', '');
    end;

    if audioName.EndsWith('.wma') then begin
      fileExtension := '.wma';
      audioName := audioName.Replace('.wma', '');
    end;

    if audioName.EndsWith('.flac') then begin
      fileExtension := '.flac';
      audioName := audioName.Replace('.flac', '');
    end;

    if audioName.EndsWith('.mp3') then begin
      fileExtension := '.mp3';
      audioName := audioName.Replace('.mp3', '');
    end;





    // check if audio source already exists in database
    for audioSourceCandidate in audioSources do
      if audioSourceCandidate.GetName() = audioName then
      begin
        audioSource := audioSourceCandidate;
        Break;
      end;

    // if exists, update date on disk
    if audioSource <> nil then
    begin
      audioSource.SetDateOnDisk(FileAge(audioSourceFile));
      Continue;
    end;

    // otherwise add it to database
    audioSource := TAudioSource.Create(fileExtension, audioName, self);
    audioSource.SetDateOnDisk(FileAge(audioSourceFile));

    SetLength(self.audioSources, Length(self.audioSources) + 1);
    self.audioSources[High(self.audioSources)] := audioSource;
  end;
end;

function TAudioSourceCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  audioSource: TAudioSource;
  audioSourceCandidate: TAudioSource;
  fileExtension: string;
begin
  audioSource := nil;

  for audioSourceCandidate in audioSources do
      if audioSourceCandidate.GetName() = name then
      begin
        audioSource := audioSourceCandidate;
        Break;
      end;

  if audioSource <> nil then
  begin
    audioSource.SetDateInDB(date);
    Exit(audioSource);
  end;

  if FileExists('source/' + name + '.wav') then
     fileExtension := '.wav'
  else if FileExists('source/' + name + '.wma') then
     fileExtension := '.wma'
  else if FileExists('source/' + name + '.mp3') then
     fileExtension := '.mp3'
  else if FileExists('source/' + name + '.flac') then
     fileExtension := '.flac'
  else
     fileExtension := '.idk';

  audioSource := TAudioSource.Create(fileExtension, name, self);
  audioSource.SetDateInDB(date);

  SetLength(self.audioSources, Length(self.audioSources) + 1);
  self.audioSources[High(self.audioSources)] := audioSource;

  Result := audioSource;
end;

function TAudioSourceCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.audioSources));

  for i := 0 to High(self.audioSources) do
      Result[i] := self.audioSources[i];
end;

end.

