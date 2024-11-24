unit AssetQueueDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  AsyncProcess;

type

  { TAssetQueueDialog }

  TAssetQueueDialog = class(TForm)
    AssetName: TLabel;
    AssetProcessor: TAsyncProcess;
    CloseDialog: TButton;
    OutputText: TMemo;
    ProgressBar: TProgressBar;
    procedure AssetProcessorReadData(Sender: TObject);
    procedure AssetProcessorTerminate(Sender: TObject);
    procedure CloseDialogClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

    public
      failureFlag: Boolean;
  public
    procedure SetProgressBar(progress: Integer);
    procedure AppendText(appendable: string);
    procedure ClearText;
    procedure Reset;
  end;
var
  AssetQueueDialog: TAssetQueueDialog;

implementation

procedure TAssetQueueDialog.AssetProcessorReadData(Sender: TObject);
begin
  OutputText.Text:= AssetProcessor.Output.ReadAnsiString;
end;

procedure TAssetQueueDialog.AssetProcessorTerminate(Sender: TObject);
begin
  if failureFlag then
    CloseDialog.Visible := True
  else
    self.Close;
    //Exit;
end;

procedure TAssetQueueDialog.CloseDialogClick(Sender: TObject);
begin
  self.Close;
end;

procedure TAssetQueueDialog.FormShow(Sender: TObject);
begin

end;

procedure TAssetQueueDialog.SetProgressBar(progress: Integer);
begin
  ProgressBar.Position := progress;
end;

procedure TAssetQueueDialog.AppendText(appendable: string);
begin
  OutputText.Lines.Add(appendable);
end;

procedure TAssetQueueDialog.ClearText;
begin
  AssetQueueDialog.OutputText.Clear;
end;

procedure TAssetQueueDialog.Reset;
begin
  CloseDialog.Visible := False;
  failureFlag := False;
  OutputText.Clear;
end;

{$R *.lfm}

end.

