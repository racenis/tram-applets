unit ProcessQueue;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Process, TramAssetMetadata, AssetQueueDialogUnit,
  ProjectSettingsDialogUnit, Character;

procedure AddToQueue(asset: TAssetMetadata);
procedure ProcessQueueSync();
function GetQueueLength: Integer;

implementation

var
   assetQueue: array of TAssetMetadata = nil;

procedure AddToQueue(asset: TAssetMetadata);
begin
  SetLength(assetQueue, Length(assetQueue) + 1);
  assetQueue[High(assetQueue)] := asset;
end;

function GetQueueLength: Integer;
begin
  Result := Length(assetQueue);
end;

type
  TAssetProcessThread = class(TThread)
    procedure Execute; override;
  end;

procedure ExtractCommandline(path : string; out command: string; out params : string);
begin
  command := path.Trim(' ');
  if command.StartsWith('"') then begin
    command := command.Substring(1);
    params := command.Substring(command.IndexOf('"') + 1);
    command := command.Substring(0, command.IndexOf('"'));
  end else begin
    params := command.Substring(command.IndexOf(' '));
    command := command.Substring(0, command.IndexOf(' '));
  end;
end;

function SplitCommandline(path: string): TStringArray;
type
  TState = (stateNormal, stateWhitespace, stateQuote);
var
  state : TState;
  index : Integer;
  token : string;
begin
  state := stateWhitespace;
  token := '';

  Result := [];


  for index := 1 to High(path) do begin

      if state = stateQuote then
         if path[index] = '"' then begin
           state := stateWhitespace;
           WriteLn('Parsed off: ', token);
           SetLength(Result, Length(Result) + 1);
           Result[High(Result)] := token;
           token := '';
           Continue;
         end else begin
             token := token + path[index];
             Continue;
         end;

      if path[index] = '"' then begin
             state := stateQuote;
             Continue;
         end;

      if IsWhiteSpace(path[index]) then begin
         if state = stateNormal then begin
           state := stateWhitespace;
           WriteLn('Parsed off: ', token);
           SetLength(Result, Length(Result) + 1);
           Result[High(Result)] := token;
           token := '';
         end;

         Continue;
      end;

      state := stateNormal;

      token := token + path[index];




  end;

end;

procedure TAssetProcessThread.Execute;
const
  BUF_SIZE = 2048;
var
  process: TProcess;
  bytesRead: Integer;
  byteBuffer: array[1..BUF_SIZE] of Byte;
  outputString: string;
  asset: TAssetMetadata;
  progressIncrement: Integer;
  currentProgress: Integer;
  targetProgress: Integer;
  failures: Integer;

  command: string;
  splitCommand: TStringArray;
  parm: Integer;
begin
  progressIncrement := 100 div Length(assetQueue);
  currentProgress := 0;
  targetProgress := 0;

  failures := 0;

  for asset in assetQueue do
  begin
    process := TProcess.Create(nil);


    AssetQueueDialog.Caption := 'Processing... ' + asset.GetName;
    AssetQueueDialog.AssetName.Caption := 'Processing... ' + asset.GetName;

    case asset.GetType of
         'STMDL': command := GetSetting('TMAP_COMMAND')
                               .Replace('%model', asset.GetName)
                               .Replace('%size', asset.GetMetadata('LIGHTMAP_WIDTH'))
                               .Replace('%padding', ''); // TODO: add padding
    end;

    splitCommand := SplitCommandline(command);

    if Length(splitCommand) = 0 then
       ShowMessage('Error preparing command!');

    command := GetCurrentDir + '>';

    for parm := 0 to High(splitCommand) do begin
      command := command + ' ' + splitCommand[parm];

      if parm = 0 then
        process.Executable := splitCommand[parm]
      else
        process.Parameters.Add(splitCommand[parm]);
    end;

    AssetQueueDialog.AppendText(command);

    process.Options := [poUsePipes];

    process.Execute;

    currentProgress := targetProgress;
    targetProgress := targetProgress + progressIncrement;

    repeat
      bytesRead := process.Output.Read(byteBuffer, BUF_SIZE);
      SetString(outputString, PAnsiChar(@byteBuffer[1]), bytesRead);
      AssetQueueDialog.AppendText(outputString.Trim);

      if currentProgress < targetProgress then
         currentProgress := currentProgress + 1;
      AssetQueueDialog.SetProgressBar(currentProgress);

    until bytesRead = 0;

    if process.ExitCode <> 0 then
       failures := failures + 1
    else
      asset.ResetBothDates;

    process.Free;
  end;

  if failures = 0 then Exit;

  AssetQueueDialog.failureFlag := True;
  AssetQueueDialog.Caption := 'Disappointing failure.';
  AssetQueueDialog.SetProgressBar(0);
  AssetQueueDialog.AssetName.Caption := 'Failed to load ' + failures.ToString
                                     + ' assets.';
end;

procedure ProcessQueueSync();
var
   processThread: TAssetProcessThread;
begin
  if Length(assetQueue) = 0 then Exit;

  AssetQueueDialog.Reset;

  processThread := TAssetProcessThread.Create(True);
  processThread.OnTerminate:= @AssetQueueDialog.AssetProcessorTerminate;

  processThread.Start;

  AssetQueueDialog.ShowModal;

  SetLength(assetQueue, 0);
end;

initialization
begin
  end;

end.

