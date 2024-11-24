unit ProcessQueue;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Process, TramAssetMetadata, AssetQueueDialogUnit,
  ProjectSettingsDialogUnit, Character;

type
  TQueueCallback = Procedure of object;

procedure AddToQueue(asset: TAssetMetadata);
procedure ProcessQueueSync();
function GetQueueLength: Integer;
procedure SetQueueCallback(callback: TQueueCallback);


implementation

var
   assetQueue: array of TAssetMetadata = nil;
   assetQueueCallback: TQueueCallback = nil;


procedure AddToQueue(asset: TAssetMetadata);
begin
  SetLength(assetQueue, Length(assetQueue) + 1);
  assetQueue[High(assetQueue)] := asset;

  if assetQueueCallback <> nil then
     assetQueueCallback;
end;

function GetQueueLength: Integer;
begin
  Result := Length(assetQueue);
end;

procedure SetQueueCallback(callback: TQueueCallback);
begin
  assetQueueCallback := callback;
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

// TODO: thread safety

// calling widget functions, like appending text and progressbar setting is not
// very good. they should only happen from main thread.
// look into using SendMessage()/PostMessage() functions.
// also writing and reading from database assets is not that safe
// basically, what what we should do is:
// 1. generate a list of commands to call
// 2. start a new thread and give it these commands
// 3. listen for messages and events from the thread
// 4. update widgets as progress messages come in
// 5. receive a report from the thread containing failed/successful commands
// 6. update the database from this report

// TODO: alternative background processing

// we could create a seperate async queue. it would be possible to add stuff to
// the async queue. after stuff is added to the queue, it would start up and
// it would process similarly to normal queue, except there would be no dialog.
// also all outputs could be saved in case there is an error.
// when all processing completes, a message box would pop up. if there were
// errors in processing, outputs from those programs would be displayed

procedure TAssetProcessThread.Execute;
const
  BUF_SIZE = 2048;
var
  process: TProcess;
  bytesRead: Integer;
  byteBuffer: array[1..BUF_SIZE] of Byte;
  outputString: string;
  asset: TAssetMetadata;
  currentProgress: Integer;
  targetProgress: Integer;
  failures: Integer;
  processed: Integer;

  executionFailed: Boolean;
  command: string;
  splitCommand: TStringArray;
  parm: Integer;
begin
  currentProgress := 0;
  targetProgress := 0;

  failures := 0;
  processed := 0;

  for asset in assetQueue do
  begin
    process := TProcess.Create(nil);

    // update progress bar value
    processed := processed + 1;
    currentProgress := targetProgress;
    targetProgress := (100 * processed) div Length(assetQueue);

    // update dialog caption
    AssetQueueDialog.Caption := 'Processing... ' + asset.GetName;
    AssetQueueDialog.AssetName.Caption := 'Processing... ' + asset.GetName;

    // prepare the command
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

    // try running the command
    executionFailed := True;
    try
      process.Execute;

      repeat
        bytesRead := process.Output.Read(byteBuffer, BUF_SIZE);
        SetString(outputString, PAnsiChar(@byteBuffer[1]), bytesRead);
        AssetQueueDialog.AppendText(outputString.Trim);

        if currentProgress < targetProgress then
           currentProgress := currentProgress + 1;
        AssetQueueDialog.SetProgressBar(currentProgress);
      until bytesRead = 0;

      executionFailed := False;
    except
      on E : Exception do ShowMessage('An error occured when trying to convert'
                       + ' asset ' + asset.GetPath + ', with a message of:'
                       + #10#10 + E.ToString);
    end;

    if executionFailed or (process.ExitCode <> 0) then
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

  assetQueueCallback;
end;

initialization
begin
  end;

end.

