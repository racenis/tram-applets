unit ProcessQueue;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, Process, TramAssetMetadata, AssetQueueDialogUnit;

procedure AddToQueue(asset: TAssetMetadata);
procedure ProcessQueueSync();

implementation

var
   assetQueue: array of TAssetMetadata = nil;

procedure AddToQueue(asset: TAssetMetadata);
begin
  SetLength(assetQueue, Length(assetQueue) + 1);
  assetQueue[High(assetQueue)] := asset;
end;


type
  TAssetProcessThread = class(TThread)
    procedure Execute; override;
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

    // TODO: replace placeholder with actual command
    process.Executable := 'ping';
    process.Parameters.Add('8.8.8.8');

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
       failures := failures + 1;

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

