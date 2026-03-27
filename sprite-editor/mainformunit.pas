unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, Menus, ValEdit, TramSpriteAsset, TramAssetMetadata,
  TramTextureAsset, Grids, LCLType, AboutDialogUnit;

type

  { TMainForm }

  TMainForm = class(TForm)
    FrameListPopup: TPopupMenu;
    InsertMarkerAbove: TMenuItem;
    InsertMarkerBelow: TMenuItem;
    InsertFrameAbove: TMenuItem;
    InsertFrameBelow: TMenuItem;
    DuplicateFrame: TMenuItem;
    MainMenuOpenProject: TMenuItem;
    MainMenuNewSprite: TMenuItem;
    MainMenuSaveAllSprites: TMenuItem;
    MainMenuQuit: TMenuItem;
    MainMenuAbout: TMenuItem;
    RemoveFrame: TMenuItem;
    MoveFrameDown: TMenuItem;
    MoveFrameUp: TMenuItem;
    Separator1: TMenuItem;
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    Separator6: TMenuItem;
    SpriteTextureList: TComboBox;
    SpriteList: TComboBox;
    SpriteFrameList: TListView;
    MainMenu: TMainMenu;
    MainMenuFile: TMenuItem;
    MainMenuHelp: TMenuItem;
    SpriteDisplay: TScrollBox;
    SpriteValues: TValueListEditor;
    procedure DuplicateFrameClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Paint(Sender: TObject);
    procedure InsertFrameAboveClick(Sender: TObject);
    procedure InsertFrameBelowClick(Sender: TObject);
    procedure InsertMarkerAboveClick(Sender: TObject);
    procedure InsertMarkerBelowClick(Sender: TObject);
    procedure MainMenuAboutClick(Sender: TObject);
    procedure MainMenuNewSpriteClick(Sender: TObject);
    procedure MainMenuOpenProjectClick(Sender: TObject);
    procedure MainMenuQuitClick(Sender: TObject);
    procedure MainMenuSaveAllSpritesClick(Sender: TObject);
    procedure MoveFrameDownClick(Sender: TObject);
    procedure MoveFrameUpClick(Sender: TObject);
    procedure RemoveFrameClick(Sender: TObject);
    procedure SpriteDisplayPaint(Sender: TObject);
    procedure SpriteFrameListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SpriteListChange(Sender: TObject);
    procedure SpriteTextureListChange(Sender: TObject);
    procedure SpriteValuesValidateEntry(Sender: TObject; aCol, aRow: Integer;
      const OldValue: string; var NewValue: String);
  private
    spriteSheet: TPortableNetworkGraphic;
    allSprites: TSpriteCollection;
    allTextures: TTextureCollection;
  public

  end;

var
  MainForm: TMainForm;
  SelectedSprite: TSprite;
  SelectedFrame: TSpriteData;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.SpriteDisplayPaint(Sender: TObject);
var
  R: TRect;
  E: TRect;
  sprite: TSpriteData;
begin
  E.Left   := 0;
  E.Top    := 0;
  E.Right  := spriteSheet.Width;
  E.Bottom := spriteSheet.Height;

  SpriteDisplay.Canvas.StretchDraw(E, spriteSheet);

  SpriteDisplay.Canvas.Brush.Style := bsClear;

  // TODO: implement better drawing
  // 1. draw all edges
  // 2. draw all rectangles
  // 3. and 4. draw selected edge and rectangle ON TOP

  for sprite in SelectedSprite.GetSprites do
      if not sprite.isMarker then begin
        R.Left := sprite.offsetX;
        R.Top := sprite.offsetY;

        R.Right := sprite.offsetX + sprite.width;
        R.Bottom := sprite.offsetY + sprite.height;

        E.Left := R.Left - sprite.borderV;
        E.Right := R.Right + sprite.borderV;

        E.Top := R.Top - sprite.borderH;
        E.Bottom := R.Bottom + sprite.borderH;

        SpriteDisplay.Canvas.Pen.Color := clBlue;

        SpriteDisplay.Canvas.Rectangle(E);


        SpriteDisplay.Canvas.Pen.Color := clRed;

        if sprite = SelectedFrame then
           SpriteDisplay.Canvas.Pen.Color := clYellow;


        SpriteDisplay.Canvas.Rectangle(R);
      end;
end;


procedure TMainForm.SpriteFrameListSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SelectedFrame := TSpriteData(Item.Data);
  SpriteDisplay.Invalidate;

  SpriteValues.Clear;
  if SelectedFrame.isMarker then begin
    SpriteValues.InsertRow('Name', SelectedFrame.nameIfMarker, True);
    Exit;
  end;

  SpriteValues.InsertRow('X', SelectedFrame.offsetX.ToString, True);
  SpriteValues.InsertRow('Y', SelectedFrame.offsetY.ToString, True);
  SpriteValues.InsertRow('W', SelectedFrame.width.ToString, True);
  SpriteValues.InsertRow('H', SelectedFrame.height.ToString, True);
  SpriteValues.InsertRow('mid X', SelectedFrame.midpointX.ToString, True);
  SpriteValues.InsertRow('mid Y', SelectedFrame.midpointY.ToString, True);
  SpriteValues.InsertRow('bordr H', SelectedFrame.borderH.ToString, True);
  SpriteValues.InsertRow('bordr V', SelectedFrame.borderV.ToString, True);
end;

procedure TMainForm.SpriteListChange(Sender: TObject);
var
  sprite: TSpriteData;
  index: Integer;

  rangeW: Integer;
  rangeH: Integer;
begin
  SelectedSprite := SpriteList.Items.Objects[SpriteList.ItemIndex] as TSprite;
  SpriteFrameList.Clear;

  SpriteTextureList.Text := SelectedSprite.GetMaterial;

  // populate sprite frame list
  SpriteFrameList.Clear;

  index := 0;
  for sprite in SelectedSprite.GetSprites do
      if sprite.isMarker then
         SpriteFrameList.AddItem(sprite.nameIfMarker, sprite)
      else begin
        SpriteFrameList.AddItem(index.ToString, sprite);
        index := index + 1;
      end;

  // load sprite image
  try
     spriteSheet.LoadFromFile('data/textures/' + SelectedSprite.GetMaterial + '.png');
  except
    Exit;
  end;

  // setup sprite viewport
  rangeW := spriteSheet.Width - SpriteDisplay.Width + SpriteDisplay.HorzScrollBar.Size;
  rangeH := spriteSheet.Height - SpriteDisplay.Height + SpriteDisplay.VertScrollBar.Size;

  if rangeW < 0 then rangeW := 0;
  if rangeH < 0 then rangeH := 0;

  SpriteDisplay.HorzScrollBar.Range := rangeW;
  SpriteDisplay.VertScrollBar.Range := rangeH;

  SpriteDisplay.Invalidate;
end;

procedure TMainForm.SpriteTextureListChange(Sender: TObject);
begin
  SelectedSprite.SetMaterial(SpriteTextureList.Text);
  self.SpriteListChange(self);
end;

procedure TMainForm.SpriteValuesValidateEntry(Sender: TObject; aCol,
  aRow: Integer; const OldValue: string; var NewValue: String);
begin
  if SelectedFrame.isMarker then begin
    SelectedFrame.nameIfMarker := NewValue;
    SpriteFrameList.Items[SpriteFrameList.ItemIndex].Caption:=NewValue;
    Exit;
  end;


  case aRow of
  1: SelectedFrame.offsetX := NewValue.ToInteger;
  2: SelectedFrame.offsetY := NewValue.ToInteger;
  3: SelectedFrame.width := NewValue.ToInteger;
  4: SelectedFrame.height := NewValue.ToInteger;
  5: SelectedFrame.midpointX := NewValue.ToInteger;
  6: SelectedFrame.midpointY := NewValue.ToInteger;
  7: SelectedFrame.borderH := NewValue.ToInteger;
  8: SelectedFrame.borderV := NewValue.ToInteger;
  end;

  SpriteDisplay.Invalidate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  sprite: TAssetMetadata;
  texture: TAssetMetadata;
begin
  allSprites := TSpriteCollection.Create;
  allSprites.ScanFromDisk;

  for sprite in allSprites.GetAssets do begin
    SpriteList.AddItem(sprite.GetName, sprite);
    sprite.LoadFromDisk();
  end;

  allTextures := TTextureCollection.Create;
  allTextures.ScanFromDisk;

  for texture in allTextures.GetAssets do
    SpriteTextureList.AddItem(texture.GetName, texture);

  if SpriteList.Items.Count > 0 then
     SpriteList.ItemIndex := 0;

  spriteSheet := TPortableNetworkGraphic.Create;

  SpriteListChange(self);
end;

procedure TMainForm.DuplicateFrameClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.DuplicateFrame(SpriteFrameList.ItemIndex);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;
procedure TMainForm.Image1Paint(Sender: TObject);
begin
end;

procedure TMainForm.InsertFrameAboveClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.InsertFrame(SpriteFrameList.ItemIndex);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;

procedure TMainForm.InsertFrameBelowClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.InsertFrame(SpriteFrameList.ItemIndex + 1);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;

procedure TMainForm.InsertMarkerAboveClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.InsertMarker(SpriteFrameList.ItemIndex);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;

procedure TMainForm.InsertMarkerBelowClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.InsertMarker(SpriteFrameList.ItemIndex + 1);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;

procedure TMainForm.MainMenuAboutClick(Sender: TObject);
begin
  AboutDialog.ShowModal;
end;

procedure TMainForm.MainMenuNewSpriteClick(Sender: TObject);
var
  newSpriteFileName: string;
  newSpriteMaterialName: string;
  newSpriteFile: TSprite;
begin
  newSpriteFileName := InputBox('Create a New Sprite', 'Please input sprite name', '');
  if newSpriteFileName = '' then Exit;

  newSpriteMaterialName := InputBox('Create a New Sprite', 'Please input material name that the sprite will reference', '');
  if newSpriteMaterialName = '' then Exit;

  if ID_YES <> Application.MessageBox(PChar(Format('Create a %s?', [newSpriteFileName])),
                                      'Input Confirmation',
                                      MB_ICONQUESTION + MB_YESNO) then Exit;

  newSpriteFile := allSprites.InsertFromDB(newSpriteFileName, 0) as TSprite;
  newSpriteFile.SetMaterial(newSpriteMaterialName);

  newSpriteFile.InsertFrame(0);

  SpriteList.AddItem(newSpriteFileName, newSpriteFile);
  SpriteList.ItemIndex := SpriteList.Items.Count - 1;
  SpriteListChange(self);
end;

procedure TMainForm.MainMenuOpenProjectClick(Sender: TObject);
var
  dialog: TSelectDirectoryDialog;
begin
  dialog := TSelectDirectoryDialog.Create(self);
  dialog.Execute;

  if (ID_YES <> Application.MessageBox(PChar(Format('Discard all unsaved changes and open %s?', [dialog.FileName])),
                                      'Open Project',
                                      MB_ICONQUESTION + MB_YESNO)) then Exit;

  SetCurrentDir(dialog.FileName);

  // TODO: reload all sprite files
end;

procedure TMainForm.MainMenuQuitClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.MainMenuSaveAllSpritesClick(Sender: TObject);
var
  spriteFile: TAssetMetadata;
begin
  for spriteFile in allSprites.GetAssets() do
        spriteFile.SaveToDisk();
end;

procedure TMainForm.MoveFrameDownClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.MoveFrameDown(SpriteFrameList.ItemIndex);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;

procedure TMainForm.MoveFrameUpClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.MoveFrameUp(SpriteFrameList.ItemIndex);
  SpriteListChange(self);
  SpriteFrameList.ItemIndex := prevIndex;
  SpriteFrameList.Items[prevIndex].MakeVisible(False);
end;

procedure TMainForm.RemoveFrameClick(Sender: TObject);
var
  prevIndex: Integer;
begin
  prevIndex := SpriteFrameList.ItemIndex;
  SelectedSprite.RemoveFrame(SpriteFrameList.ItemIndex);
  SpriteListChange(self);
  if prevIndex >= SpriteFrameList.Items.Count then
     SpriteFrameList.ItemIndex := prevIndex - 1
  else
    SpriteFrameList.ItemIndex := prevIndex;
end;

end.

