unit NewProjectFrameUnit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, StdCtrls, ExtCtrls, FileUtil, Dialogs, fgl,
  TramAssetParser, LCLType, Process, lclintf;

type

  { TNewProjectFrame }

  TProjectTemplate = class
    public

      directory: string;
      name: string;
      desc: string;

  end;
  TProjectList = specialize TFPGList<TProjectTemplate>;

  TNewProjectFrame = class(TFrame)
    Back: TButton;
    BackgroundImage: TImage;
    ProjectFancyName: TEdit;
    ProjectName: TEdit;
    Finish: TButton;
    GetMoreTemplates: TButton;
    TemplateName: TEdit;
    TemplateGroup: TGroupBox;
    InstanceGroup: TGroupBox;
    TemplateImage: TImage;
    TemplateList: TListBox;
    TemplateDescription: TMemo;
    procedure BackClick(Sender: TObject);
    procedure FinishClick(Sender: TObject);
    procedure GetMoreTemplatesClick(Sender: TObject);
    procedure TemplateListSelectionChange(Sender: TObject; User: boolean);
  private
    templates: TProjectList;
  public
    constructor Create(TheOwner: TComponent); override;
  public
    backToMain: procedure of object;
  end;

implementation

{$R *.lfm}

{ TNewProjectFrame }

procedure TNewProjectFrame.BackClick(Sender: TObject);
begin
  backToMain();
end;

procedure TNewProjectFrame.FinishClick(Sender: TObject);
var
  newProjectName: string;
  template: TProjectTemplate;

  fileToCopy: string;
  filePath: string;
  fileDir: string;

  projectProcess: TProcess;
  projectConfig: TextFile;
begin
  newProjectName := ProjectName.Text;

  if TemplateList.ItemIndex < 0 then begin
    Application.MessageBox('Select a template before creating a new project!', 'Illegal project parameter', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;

  template := TemplateList.Items.Objects[TemplateList.ItemIndex] as TProjectTemplate;

  if newProjectName.Length < 1 then begin
    Application.MessageBox('Project name needs to have characters!', 'Illegal project name', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;

  if (name.IndexOf(' ') <> -1)
     or (newProjectName.IndexOf('/') <> -1)
     or (newProjectName.IndexOf('\') <> -1)
     or (newProjectName.IndexOf('|') <> -1)
     or (newProjectName.IndexOf('<') <> -1)
     or (newProjectName.IndexOf('>') <> -1)
     or (newProjectName.IndexOf(':') <> -1)
     or (newProjectName.IndexOf('"') <> -1)
     or (newProjectName.IndexOf('?') <> -1)
     or (newProjectName.IndexOf('*') <> -1)
     or (newProjectName.IndexOf(' ') <> -1)
     or (newProjectName.IndexOf(#9) <> -1)
     or (newProjectName.IndexOf(#10) <> -1)
     or (newProjectName.IndexOf(#13) <> -1) then begin
        Application.MessageBox('Project name has illegal characters.', 'Illegal project name', MB_OK + MB_ICONEXCLAMATION);
        Exit;
     end;

  if DirectoryExists('../' + ProjectName.Text) then begin
    Application.MessageBox('Project directory already exists!', 'Illegal project name', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;

  if not DirectoryExists(template.directory) then begin
    Application.MessageBox('Template directory does not exist!', 'Illegal template', MB_OK + MB_ICONEXCLAMATION);
    Exit;
  end;

  //ShowMessage(template.directory);

  Application.MessageBox('After clicking the OK button, the file copy will begin. The program might appear as if it has hanged. Do not worry! It will just be copying files.', 'Beginning file copy...', MB_OK + MB_ICONINFORMATION);

  for fileToCopy in FindAllFiles(template.directory, '', True) do begin
      //ShowMessage(fileToCopy);

      filePath := fileToCopy.Substring(template.directory.Length + 1);

      fileDir := '../' + newProjectName + '/' + ExtractFileDir(filePath);
      //IncludeTrailingPathDelimiter(ExtractFileDir(filePath))

      if not DirectoryExists(fileDir) then
             ForceDirectories(fileDir);


      if filePath = 'template.png' then Continue;
      if filePath = 'template.jpg' then Continue;
      if filePath = 'template.cfg' then Continue;
      if filePath = '.git' then Continue;
      if filePath = '.gitattributes' then Continue;

      //if filePath.Length < 1 then Continue;

      //ShowMessage('(' + fileToCopy + ') [' + filePath + '] ' + fileDir);




      CopyFile(fileToCopy, fileDir + '/' + ExtractFileName(filePath));

  end;


  AssignFile(projectConfig, '../' + newProjectName + '/project.cfg');

  rewrite(projectConfig);

  writeln(projectConfig, '# Tramway SDK Project Settings');
  writeln(projectConfig, '# Gemerated by: Tramway SDK Project Manager Applet');
  writeln(projectConfig, '');

  writeln(projectConfig, 'SDK_VERSION          "0.1.1"');
  writeln(projectConfig, 'PROJECT_NAME         "', ProjectFancyName.Text, '"');

  CloseFile(projectConfig);

  if IDYES = Application.MessageBox('New project created! Open it now?', '', MB_YESNO + MB_ICONQUESTION) then begin
    projectProcess := TProcess.Create(nil);
    projectProcess.CurrentDirectory := '../' + newProjectName;
    projectProcess.Executable := 'assetmanager';
    projectProcess.Execute;

    Halt;

  end;

  Halt;

end;

procedure TNewProjectFrame.GetMoreTemplatesClick(Sender: TObject);
begin
  OpenURL('https://racenis.github.io/tram-sdk/templates.html');
end;

procedure TNewProjectFrame.TemplateListSelectionChange(Sender: TObject;
  User: boolean);
var
  template: TProjectTemplate;
begin
  if TemplateList.ItemIndex < 0 then Exit;
  template := TemplateList.Items.Objects[TemplateList.ItemIndex] as TProjectTemplate;
  if template = nil then Exit;
  TemplateName.Text := template.name;
  TemplateDescription.Text := template.desc;
  if FileExists(template.directory + '/template.jpg') then
         TemplateImage.Picture.LoadFromFile(template.directory + '/template.jpg') else
             if FileExists('resources/noimage.png') then
                    TemplateImage.Picture.LoadFromFile('resources/noimage.png');

end;

constructor TNewProjectFrame.Create(TheOwner: TComponent);
var
  projectDirs: TStringList;
  projectDir: string;
  project: TProjectTemplate;
  projectData: TAssetParser;
  pair: array of string;
begin
  inherited Create(TheOwner);
  if FileExists('resources/background.jpg') then
     BackgroundImage.Picture.LoadFromFile('resources/background.jpg');


  if FileExists('resources/noimage.png') then
         TemplateImage.Picture.LoadFromFile('resources/noimage.png');

  templates := TProjectList.Create;

  projectDirs := FindAllDirectories('../', False);

  for projectDir in projectDirs do
      if (projectDir <> 'tram-sdk')
         and (projectDir <> 'tram-applets')
         and (projectDir <> 'tram-binary') then
             if FileExists(projectDir + '/template.cfg') then begin
               project := TProjectTemplate.Create;
               project.directory := projectDir;
               project.name := projectDir;

               projectData := TAssetParser.Create(projectDir + '/template.cfg');

               for pair in projectData.GetData do
                   case pair[0] of
                        'TEMPLATE_NAME': project.name := pair[1];
                        'TEMPLATE_DESC': project.desc := pair[1];
                   end;

               templates.Add(project);
               TemplateList.AddItem(project.name, project);
             end;
end;

end.

