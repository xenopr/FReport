{$WARN UNIT_PLATFORM OFF}

unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, ToolEdit, Placemnt, ComCtrls,
  Buttons, ShellCtrls, Menus, DB, NCOciDB,
  uDB,
  ShellApi, ShlObj, ComObj, ActiveX, ImgList,
  StrUtils, ActnList, ExtCtrls;

type
  TfMain = class(TForm)
    fsMain: TFormStorage;
    fsShell: TFormStorage;
    ImageList1: TImageList;
    ActionList1: TActionList;
    Action1: TAction;
    pMain: TPanel;
    eFile: TListView;
    eDir: TDirectoryEdit;
    Panel1: TPanel;
    Label2: TLabel;
    lName: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    bPreview: TBitBtn;
    bDesign: TBitBtn;
    bDB: TBitBtn;
    New: TBitBtn;
    bClose: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bDesignClick(Sender: TObject);
    procedure bPreviewClick(Sender: TObject);
    procedure eFileDblClick(Sender: TObject);
    procedure bCloseClick(Sender: TObject);
    procedure bDBClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure eDirKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eDirChange(Sender: TObject);
    procedure eFileCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure NewClick(Sender: TObject);
    procedure eFileEdited(Sender: TObject; Item: TListItem; var S: String);
    procedure eFileEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure eFileDeletion(Sender: TObject; Item: TListItem);
    procedure Action1Execute(Sender: TObject);
    procedure eFileKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SpeedButton3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FirstStart:boolean;
    CurFile:string;
    procedure FillFiles;
  end;

var
  fMain: TfMain;

implementation

uses uReports;

{$R *.dfm}

procedure TfMain.FillFiles;
var
  sr: TSearchRec;
  li: TListItem;
begin
  eFile.Items.BeginUpdate;
  Screen.Cursor:=crHourGlass;
  eFile.Items.Clear;
  try
   if DirectoryExists(eDir.Text) then
   if FindFirst(eDir.Text+'\*.*', (faAnyFile), sr) = 0 then
   begin
     repeat
      if (((sr.Attr and faDirectory)>0)and(sr.Name<>'.'))or
         (((sr.Attr and faDirectory)=0)and(ExtractFileExt(sr.Name)='.frf')) then
        begin
         li:=eFile.Items.Add;
         li.Caption:=sr.Name;
         if (sr.Attr and faDirectory)=0 then li.ImageIndex:=0 else li.ImageIndex:=1;
         li.SubItems.Add(FormatDateTime('dd.mm.yyyy hh:nn',FileDateToDateTime(sr.Time)));
         li.SubItems.Add(IntToStr(sr.Size));
         if sr.Name=CurFile then begin
           li.Focused:=true;
           li.Selected:=true;
           li.MakeVisible(true);
         end;
        end;
     until FindNext(sr)<>0;
     FindClose(sr);
   end;
  finally
   eFile.AlphaSort;
   eFile.Items.EndUpdate;
   Screen.Cursor:=crDefault;
  end;
end;


procedure TfMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 if DirectoryExists(eDir.Text) then fsMain.WriteString('CurDir',eDir.Text);
 fsMain.WriteString('CurFile',CurFile);
 fsMain.WriteInteger('cbLoadDBs',Integer(fDB.cbLoadDBs.Checked));
 fsMain.WriteInteger('WidthFile',eFile.Columns[0].Width);
end;

procedure TfMain.bDesignClick(Sender: TObject);
begin
  if eFile.Selected<>nil then
  if eFile.Selected.ImageIndex=0 then
  if FileExists(eDir.Text+'\'+eFile.Selected.Caption) then
  with fReports do
  begin
    CurFile:=eFile.Selected.Caption;
    frDesigner1.OpenDir:=eDir.InitialDir;
    frDesigner1.SaveDir:=eDir.InitialDir;
    frReport1.LoadFromFile(eDir.Text+'\'+eFile.Selected.Caption);
    frReport1.DesignReport;
  end;
  FillFiles;
end;

procedure TfMain.bPreviewClick(Sender: TObject);
begin
  if eFile.Selected<>nil then
  if eFile.Selected.ImageIndex=0 then
  if FileExists(eDir.Text+'\'+eFile.Selected.Caption) then
  with fReports do
  begin
    frDesigner1.OpenDir:=eDir.InitialDir;
    frDesigner1.SaveDir:=eDir.InitialDir;
    frReport1.LoadFromFile(eDir.Text+'\'+eFile.Selected.Caption);
    frReport1.ShowReport;
    CurFile:=ExtractFileName(frReport1.FileName);
  end;
  FillFiles;
end;

procedure TfMain.eFileDblClick(Sender: TObject);
var
 s:string;
 n:integer;
begin
 with eFile do
 if Selected<>nil then
  if Selected.ImageIndex=0 then begin
   bPreview.Click;
  end else begin
   s:=eDir.Text;
   if trim(Selected.Caption)='..' then begin
     n:=Length(s)-1;
     while (n>0)and(s[n]<>'\') do Dec(n);
     CurFile:=Copy(s,n+1,Length(s));
//     ShowMessage(CurFile);
     s:=Copy(s,1,n-1);
   end else if Selected.Caption<>'.' then begin
     CurFile:='..';
     s:=s+'\'+Selected.Caption;
   end;
//   s:=StringReplace(s,'\\','\',[rfReplaceAll]);
   eDir.Text:=s;
  end;
end;

procedure TfMain.bCloseClick(Sender: TObject);
begin
 CLose;
end;

procedure TfMain.bDBClick(Sender: TObject);
begin
 fDB.ShowModal;
end;

procedure TfMain.FormShow(Sender: TObject);
begin
 if FirstStart then exit;
 FirstStart:=true;

 eFile.Columns[0].Width:=fsMain.ReadInteger('WidthFile',eFile.Columns[0].Width);

 if ParamStr(1)<>'' then
 begin
  CurFile:=ExtractFileName(ParamStr(1));
  if ExtractFilePath(ParamStr(1))<>'' then begin
   eDir.Text:=ExtractFilePath(ParamStr(1));
  end else begin
   eDir.Text:=GetCurrentDir;
  end;
 end else begin
  if fsMain.ReadString('CurDir','')<>'' then
   eDir.Text:=fsMain.ReadString('CurDir','')
  else eDir.Text:=ExtractFilePath(Application.ExeName);
   CurFile:=fsMain.ReadString('CurFile','');
 end;
 SetCurrentDir(eDir.Text);
 FillFiles;
 Refresh;

 fDB.cbLoadDBs.Checked:=boolean(fsMain.ReadInteger('cbLoadDBs',0));
 with fDB do
 begin
  OpenDialog1.InitialDir:=eDir.Text;
  SaveDialog1.InitialDir:=eDir.Text;
  if cbLoadDBs.Checked then
  begin
   Show;
   LoadDBs;
   Close;
  end;
 end;

 if ParamStr(1)<>'' then
 with fReports do
  begin
   frReport1.LoadFromFile(CurFile);
   frReport1.ShowReport;
  end;
end;

procedure TfMain.SpeedButton1Click(Sender: TObject);
var
    IObject: IUnknown;
    SLink: IShellLink;
    PFile: IPersistFile;
begin
 Screen.Cursor:=crHourGlass;
 try
  IObject := CreateComObject(CLSID_ShellLink);
  SLink := IObject as IShellLink;
  PFile := IObject as IPersistFile;
  with SLink do begin
    SetArguments(PChar(''));
    SetDescription(PChar('FReport - оболочка FastReport'));
    SetPath(PChar(Application.ExeName));
  end;
  PFile.Save(PWChar(WideString(fsShell.ReadString('Desktop','')+'\FReport.lnk')), FALSE);
 finally
  Screen.Cursor:=crDefault;
 end;
end;

procedure TfMain.Label3Click(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShellExecute(handle,'open','http://www.fastreport.ru','','',SW_SHOWNORMAL);
  Screen.Cursor:=crDefault;
end;

procedure TfMain.Label5Click(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShellExecute(handle,'open','http://andypro.narod.ru','','',SW_SHOWNORMAL);
  Screen.Cursor:=crDefault;
end;

procedure TfMain.Label6Click(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShellExecute(handle,'open',PChar('mailto:Protasov Andrey<andypro@mail.ru>?SUBJECT='+lName.Caption),'','',SW_SHOWNORMAL);
  Screen.Cursor:=crDefault;
end;

procedure TfMain.SpeedButton2Click(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShellExecute(handle,'open',PChar(ExtractFilePath(Application.ExeName)+'\fr24rus.chm'),'','',SW_SHOWNORMAL);
  Screen.Cursor:=crDefault;
end;

procedure TfMain.eDirKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=13 then FillFiles;
end;

procedure TfMain.eDirChange(Sender: TObject);
begin
  FillFiles;
end;

procedure TfMain.eFileCompare(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
begin
 if Item1.ImageIndex=Item2.ImageIndex then
    Compare := CompareText(Item1.Caption,Item2.Caption)
  else begin
   Compare:=Item2.ImageIndex-Item1.ImageIndex;
  end;
end;

procedure TfMain.NewClick(Sender: TObject);
var
 ss:string;
 h:Integer;
begin
 if InputQuery('Новый отчет', 'Введите название нового отчета (без .frf):', ss) then begin
  with fReports do
  begin
   h:=FileCreate(eDir.Text+'\'+ss+'.frf');
   if h<>-1 then begin
    FileClose(h);
    CurFile:=ss+'.frf';
    FillFiles;
    frDesigner1.OpenDir:=eDir.InitialDir;
    frDesigner1.SaveDir:=eDir.InitialDir;
    frReport1.LoadFromFile(eDir.Text+'\'+CurFile);
    frReport1.DesignReport;
   end;
  end;
 end;
end;

procedure TfMain.eFileEdited(Sender: TObject; Item: TListItem;
  var S: String);
begin
 if FileExists(eDir.Text+'\'+Item.Caption) then
  begin
   if ExtractFileExt(S)<>'.frf' then S:=S+'.frf';
   if not RenameFile(eDir.Text+'\'+Item.Caption,eDir.Text+'\'+S) then S:=Item.Caption;
  end;
end;

procedure TfMain.eFileEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
 AllowEdit:=Item.ImageIndex=0;
end;

procedure TfMain.eFileDeletion(Sender: TObject; Item: TListItem);
begin
 abort;
end;

procedure TfMain.Action1Execute(Sender: TObject);
begin
 if eFile.Selected<>nil then eFile.Selected.EditCaption;
end;

procedure TfMain.eFileKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
 if Key=13 then
  if eFile.Selected<>nil then
   if eFile.Selected.ImageIndex<>0 then
     eFileDblClick(Sender);
end;

procedure TfMain.SpeedButton3Click(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  ShellExecute(handle,'open',PChar(ExtractFilePath(Application.ExeName)+'\fruser.hlp'),'','',SW_SHOWNORMAL);
  Screen.Cursor:=crDefault;
end;

end.
