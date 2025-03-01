unit OpenProjectFrameUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, FileUtil, Dialogs,
  fgl, TramAssetParser, LCLType, Process;

type

  { TOpenProjectFrame }

  TProject = class
    public

      directory: string;
      name: string;
      desc: string;

  end;

  TOpenProjectFrame = class(TFrame)
    BackgroundImage: TImage;
    Back: TButton;
    Finish: TButton;
    ProjectDesc: TMemo;
    ProjectName: TEdit;
    ProjectGroup: TGroupBox;
    ProjectImage: TImage;
    ProjectList: TListBox;
    procedure BackClick(Sender: TObject);
    procedure FinishClick(Sender: TObject);
    procedure ProjectListSelectionChange(Sender: TObject; User: boolean);
  private

  public
    constructor Create(TheOwner: TComponent); override;
  public
    backToMain: procedure of object;
  end;

implementation

{$R *.lfm}

{ TOpenProjectFrame }

procedure TOpenProjectFrame.BackClick(Sender: TObject);
begin
  backToMain;
end;

procedure TOpenProjectFrame.FinishClick(Sender: TObject);
var
  project: TProject;
  projectProcess: TProcess;
begin
  if ProjectList.ItemIndex < 0 then begin
    Application.MessageBox('Select a project before launching it!', 'Illegal project', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;

  project := ProjectList.Items.Objects[ProjectList.ItemIndex] as TProject;

  projectProcess := TProcess.Create(nil);
  projectProcess.CurrentDirectory := project.directory;
  projectProcess.Executable := 'assetmanager';
  projectProcess.Execute;

  Halt;

end;

procedure TOpenProjectFrame.ProjectListSelectionChange(Sender: TObject;
  User: boolean);
var
  project: TProject;
begin
  if ProjectList.ItemIndex < 0 then Exit;
  project := ProjectList.Items.Objects[ProjectList.ItemIndex] as TProject;
  if project = nil then Exit;
  ProjectName.Text := project.name;
  ProjectDesc.Text := project.desc;
  if FileExists(project.directory + '/project.jpg') then
         ProjectImage.Picture.LoadFromFile(project.directory + '/project.jpg') else
             if FileExists('resources/noimage.png') then
                    ProjectImage.Picture.LoadFromFile('resources/noimage.png');
end;

constructor TOpenProjectFrame.Create(TheOwner: TComponent);
var
  projectDirs: TStringList;
  project: TProject;
  projectDir: string;
  projectData: TAssetParser;
  pair: array of string;
begin
  inherited Create(TheOwner);
  BackgroundImage.Picture.LoadFromFile('C:\Users\Poga\Desktop\painis\tram-binary\resources\background.jpg');

  if FileExists('resources/noimage.png') then
         ProjectImage.Picture.LoadFromFile('resources/noimage.png');

  projectDirs := FindAllDirectories('../', False);

  for projectDir in projectDirs do
     if FileExists(projectDir + '/project.cfg') then begin
       project := TProject.Create;
       project.directory := projectDir;
       project.name := projectDir;

       projectData := TAssetParser.Create(projectDir + '/project.cfg');

       for pair in projectData.GetData do
          //ShowMessage(projectDir + '/project.cfg' + ' ' + IntToStr(Length(pair)));
           if Length(pair) >= 2 then case pair[0] of
                'PROJECT_NAME': project.name := pair[1];
                'PROJECT_DESC': project.desc := pair[1];
           end;

       ProjectList.AddItem(project.name, project);
     end;

end;

end.

