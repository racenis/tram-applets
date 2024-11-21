unit ImportFileDialogUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls;

type

  { TImportFileDialog }

  TImportType = (importCopy, importMove, importLink);
  TImportFileDialog = class(TForm)
    Path: TEdit;
    ImportTypeCopy: TRadioButton;
    ImportTypeMove: TRadioButton;
    ImportTypeGroup: TRadioGroup;
    ImportTypeLink: TRadioButton;
    Select: TButton;
    Cancel: TButton;
    Label1: TLabel;
    DirectoryTree: TTreeView;
    constructor Create(formOwner: TComponent; paths: TStringArray); overload;
    procedure CancelClick(Sender: TObject);
    procedure DirectoryTreeChange(Sender: TObject; Node: TTreeNode);
    procedure FormCreate(Sender: TObject);
    procedure PathKeyPress(Sender: TObject; var Key: char);
    procedure SelectClick(Sender: TObject);
    function GetSelectedPath: string;
    function GetSelectedType: TImportType;
    function IsSuccess: Boolean;
  private

  public
    paths: TStringArray;
    selectedPath: string;
    importType: TImportType;
    success: Boolean;
  end;

var
  ImportFileDialog: TImportFileDialog;

implementation

{$R *.lfm}

{ TImportFileDialog }

procedure RecursiveAdd(tree: TTreeView; parent: TTreeNode; index: Integer; strings: TStringArray);
var
  node: TTreeNode;
begin
  //ShowMessage('index: ' + index.ToString);


  if index > High(strings) then
     Exit;

  if parent = nil then
     begin
       //ShowMessage('no parent: ' + strings[index]);
       node := tree.Items.FindNodeWithTextPath(strings[index]);

       if node = nil then
          node := tree.Items.Add(nil, strings[index]);

       RecursiveAdd(tree, node, index + 1, strings);
     end
  else
    begin
      //ShowMessage('yes parent: ' + strings[index] + ' is ' + parent.Text);

      node := parent.FindNode(strings[index]);

      if node = nil then
         node := tree.Items.AddChild(parent, strings[index]);

      RecursiveAdd(tree, node, index + 1, strings);
    end;
end;

constructor TImportFileDialog.Create(formOwner: TComponent; paths: TStringArray);
var
  dirpath: string;
begin
  inherited Create(formOwner);

  self.paths := paths;
  self.selectedPath := '';
  self.importType := importCopy;
  self.success := False;

  for dirpath in paths do
      RecursiveAdd(self.DirectoryTree, nil, 0, dirpath.Split('/'));
      //self.DirectoryTree.Items.Add(nil, dirpath);
end;

procedure TImportFileDialog.CancelClick(Sender: TObject);
begin
  self.success := False;

  self.Close;
end;

procedure TImportFileDialog.DirectoryTreeChange(Sender: TObject; Node: TTreeNode
  );
begin
  self.Path.Text := Node.GetTextPath;
end;

procedure TImportFileDialog.FormCreate(Sender: TObject);
begin
  self.DirectoryTree.FullExpand;
end;

procedure TImportFileDialog.PathKeyPress(Sender: TObject; var Key: char);
begin
  if Key = ' ' then Key := '-';
end;

procedure TImportFileDialog.SelectClick(Sender: TObject);
begin
  self.selectedPath := self.Path.Text;

  self.success := True;

  if self.ImportTypeCopy.Checked then self.importType := importCopy;
  if self.ImportTypeMove.Checked then self.importType := importMove;
  if self.ImportTypeLink.Checked then self.importType := importLink;

  self.Close;
end;

function TImportFileDialog.GetSelectedPath: string;
begin
  Result := self.selectedPath;
end;

function TImportFileDialog.GetSelectedType: TImportType;
begin
  Result := self.importType;
end;

function TImportFileDialog.IsSuccess: Boolean;
begin
  Result := self.success;
end;



end.

