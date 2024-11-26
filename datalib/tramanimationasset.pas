unit TramAnimationAsset;

{$mode objfpc}{$H+}
{$WARN 6058 off : Call to subroutine "$1" marked as inline is not inlined}
interface

// TODO:
// - Animation files are usually small
// - We could parse the file
// - Save a list of bones that the file uses
// - Save the total animation length
// - Cache as properties

uses
  Classes, SysUtils, TramAssetMetadata, FileUtil, TramAssetParser;

type
  TAnimationCollection = class;
  TAnimation = class(TAssetMetadata)
  public
      constructor Create(animationName: string; collection: TAnimationCollection);
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

  TAnimationCollection = class(TAssetCollection)
  public
     constructor Create();
     procedure Clear; override;
     procedure ScanFromDisk; override;
     function InsertFromDB(name: string; date: Integer): TAssetMetadata; override;
     procedure Remove(asset: TAssetMetadata); override;
     function GetAssets: TAssetMetadataArray; override;
  protected
     animations: array of TAnimation;
  end;

implementation

constructor TAnimation.Create(animationName: string; collection: TAnimationCollection);
begin
  self.name := animationName;
  self.parent := collection;
end;

function TAnimation.GetType: string;
begin
  Result := 'ANIM';
end;

function TAnimation.GetPath: string;
begin
  Result := 'data/animations/' + name + '.anim';
end;

procedure TAnimation.SetDateInDB(date: Integer);
begin
  self.dateInDB := date;
end;

procedure TAnimation.SetDateOnDisk(date: Integer);
begin
  self.dateOnDisk := date;
end;

procedure TAnimation.SetMetadata(const prop: string; value: Variant);
begin

end;
function TAnimation.GetMetadata(const prop: string): Variant;
begin

end;

function TAnimation.GetPropertyList: TAssetPropertyList;
begin
  Result := [];
end;

procedure TAnimation.LoadMetadata();
begin

end;


constructor TAnimationCollection.Create;
begin

end;

procedure TAnimationCollection.Remove(asset: TAssetMetadata);
var
   index: Integer;
begin
  for index := 0 to High(animations) do
      if animations[index] = asset then
         Break;
  if animations[index] <> asset then Exit;
  for index := index to High(animations) - 1 do
      animations[index] := animations[index  + 1];
  SetLength(animations, Length(animations) - 1);
end;

procedure TAnimationCollection.Clear;
var
  animation: TAnimation;
begin
  for animation in self.animations do animation.Free;
  SetLength(animations, 0);
end;

procedure TAnimationCollection.ScanFromDisk;
var
  files: TStringList;
  animationFile: string;
  animationName: string;
  animation: TAnimation;
  animationCandidate: TAnimation;
begin
  files := FindAllFiles('data/animations', '*.anim', true);

  for animation in animations do
      animation.SetDateOnDisk(0);

  for animationFile in files do
  begin
    animation := nil;

    // extract asset name from path
    animationName := animationFile.Replace('\', '/');
    animationName := animationName.Replace('data/animations/', '');

    animationName := animationName.Replace('.anim', '');

    // check if animation already exists in database
    for animationCandidate in animations do
      if animationCandidate.GetName() = animationName then
      begin
        animation := animationCandidate;
        Break;
      end;

    // if exists, update date on disk
    if animation <> nil then
    begin
      animation.SetDateOnDisk(FileAge(animationFile));
      Continue;
    end;

    // otherwise add it to database
    animation := TAnimation.Create( animationName, self);
    animation.SetDateOnDisk(FileAge(animationFile));

    SetLength(self.animations, Length(self.animations) + 1);
    self.animations[High(self.animations)] := animation;
  end;
end;

function TAnimationCollection.InsertFromDB(name: string; date: Integer): TAssetMetadata;
var
  animation: TAnimation;
  animationCandidate: TAnimation;
begin
  animation := nil;

  for animationCandidate in animations do
      if animationCandidate.GetName() = name then
      begin
        animation := animationCandidate;
        Break;
      end;

  if animation <> nil then
  begin
    animation.SetDateInDB(date);
    Exit(animation);
  end;

  animation := TAnimation.Create(name, self);
  animation.SetDateInDB(date);

  SetLength(self.animations, Length(self.animations) + 1);
  self.animations[High(self.animations)] := animation;

  Result := animation;
end;

function TAnimationCollection.GetAssets: TAssetMetadataArray;
var
   i: Integer;
begin
  SetLength(Result{%H-}, Length(self.animations));

  for i := 0 to High(self.animations) do
      Result[i] := self.animations[i];
end;

end.

