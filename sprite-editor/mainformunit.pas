unit MainFormUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls, Menus, ValEdit, TramSpriteAsset, TramAssetMetadata;

type

  { TMainForm }

  TMainForm = class(TForm)
    BitBtn1: TBitBtn;
    SpriteList: TComboBox;
    SpriteFrameList: TListView;
    MainMenu: TMainMenu;
    MainMenuFile: TMenuItem;
    MainMenuHelp: TMenuItem;
    SpriteDisplay: TScrollBox;
    SpriteValues: TValueListEditor;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Paint(Sender: TObject);
    procedure SpriteDisplayClick(Sender: TObject);
    procedure SpriteDisplayPaint(Sender: TObject);
    procedure SpriteListChange(Sender: TObject);
  private
    egg: Integer;
    spriteSheet: TPortableNetworkGraphic;
    allSprites: TSpriteCollection;
  public

  end;

var
  MainForm: TMainForm;
  SelectedSprite: TSprite;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.SpriteDisplayClick(Sender: TObject);
begin

end;

procedure TMainForm.SpriteDisplayPaint(Sender: TObject);
var
  R: TRect;
  E: TRect;
begin
   R.Left   := egg;
  R.Top    := 50;
  R.Right  := egg + 50;
  R.Bottom := 100;

  E.Left   := 0;
  E.Top    := 0;
  E.Right  := 640;
  E.Bottom := 480;

  // Set the fill color
  SpriteDisplay.Canvas.Brush.Color := clRed;
  SpriteDisplay.Canvas.Brush.Style := bsSolid;

  // Set the border color
  Canvas.Pen.Color := clBlue;
  Canvas.Pen.Width := 5;
  Canvas.Pen.Style := psSolid;

  // Draw the rectangle
  //Canvas.Rectangle(R);

  SpriteDisplay.Canvas.StretchDraw(E, spriteSheet);

  SpriteDisplay.Canvas.Rectangle(R);



end;

procedure TMainForm.SpriteListChange(Sender: TObject);
var
  sprite: TSpriteData;
  index: Integer;
begin
  SelectedSprite := SpriteList.Items.Objects[SpriteList.ItemIndex] as TSprite;
  SpriteFrameList.Clear;

  index := 0;
  for sprite in SelectedSprite.GetSprites do
      if sprite.isMarker then
         SpriteFrameList.AddItem(sprite.nameIfMarker, sprite)
      else begin
        SpriteFrameList.AddItem(index.ToString, sprite);
        index := index + 1;
      end;

end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  sprite: TAssetMetadata;
begin
  egg := 25;

  allSprites := TSpriteCollection.Create;
  allSprites.ScanFromDisk;

  for sprite in allSprites.GetAssets do begin
    SpriteList.AddItem(sprite.GetName, sprite);
    sprite.LoadFromDisk();
  end;

  if SpriteList.Items.Count > 0 then
     SpriteList.ItemIndex := 0;

  spriteSheet := TPortableNetworkGraphic.Create;
  spriteSheet.LoadFromFile('C:\Users\Poga\Desktop\solution_my.png');

  SpriteListChange(self);

  //Image1.Picture.LoadFromFile('C:\Users\Poga\Desktop\solution_my.png');
end;

procedure TMainForm.BitBtn1Click(Sender: TObject);
begin
  egg := egg + 10;
  //Image1.Invalidate;
  SpriteDisplay.Invalidate;
end;

procedure TMainForm.Image1Paint(Sender: TObject);
begin
end;

end.

