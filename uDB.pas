unit uDB;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, RXCtrls, CheckLst, DB, DBTables, NCOciDB,
  IBDatabase, Placemnt,
  OracleLogon, Oracle,
  ADODB, OleDB, ComObj, ActiveX, ExtCtrls;

type
  TDataBaseDescr=record
              Name:string;
              IDType:integer;
              Server:string;
              User:string;
              Pass:string;
              Database:TCustomConnection;
             end;
type
  TfDB = class(TForm)
    eDatabases: TCheckListBox;
    fsDB: TFormStorage;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    bAdd: TSpeedButton;
    bDel: TSpeedButton;
    bConnect: TSpeedButton;
    bClose: TBitBtn;
    eName: TEdit;
    eUser: TEdit;
    ePass: TEdit;
    eServer: TEdit;
    eType: TComboBox;
    bLoad: TBitBtn;
    bSave: TBitBtn;
    cbFile: TCheckBox;
    cbLoadDBs: TCheckBox;
    sbConn: TSpeedButton;
    procedure bAddClick(Sender: TObject);
    procedure bDelClick(Sender: TObject);
    procedure eDatabasesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eDatabasesClickCheck(Sender: TObject);
    procedure bConnectClick(Sender: TObject);
    procedure bLoadClick(Sender: TObject);
    procedure bSaveClick(Sender: TObject);
    procedure cbFileClick(Sender: TObject);
    procedure sbConnClick(Sender: TObject);
  private
    { Private declarations }
    procedure FillList;
  public
    { Public declarations }
    Databases:array of TDatabaseDescr;
    procedure SaveDBs;
    procedure LoadDBs;
  end;

var
  fDB: TfDB;

implementation

uses uReports;

const
 RegistryKey='Software\AndyPro\FReport\Databases';

{$R *.dfm}

procedure TfDB.FormShow(Sender: TObject);
begin
 FillList;
end;

procedure TfDB.FillList;
var
 n:Integer;
begin
 eDatabases.Items.Clear;
 for n:=0 to Length(Databases)-1 do begin
  eDatabases.Items.Add(Databases[n].Name+' ('+eType.Items[Databases[n].IDType]+')');
  if Databases[n].Database<>nil then
    eDatabases.Checked[n]:=Databases[n].Database.Connected;
 end;
 bConnect.Enabled:=eDatabases.Items.Count>0;
end;

procedure TfDB.bAddClick(Sender: TObject);
var
 n:Integer;
 b:boolean;
 tmpoci:TOCIDatabase;
 tmpdoa:TOracleSession;
 tmpibx:TIBDatabase;
 tmpbde:TDatabase;
 tmpado:TADOConnection;
begin
 if trim(eName.Text)='' then
  begin
   ShowMessage('Укажите наименование !');
   exit;
  end;
 b:=false;
 for n:=0 to Length(Databases)-1 do
  begin
   if trim(Databases[n].Name)=trim(eName.Text) then b:=true;
  end;
 if b then
 begin
   ShowMessage('Наименование уже используется !');
   exit;
 end;
 SetLength(Databases,Length(Databases)+1);
 with DataBases[Length(Databases)-1] do
 try
   Name:=eName.Text;
   IDType:=eType.ItemIndex;
   Server:=eServer.Text;
   User:=eUser.Text;
   Pass:=ePass.Text;
   case IDType of
    0: begin
        tmpbde:=TDatabase.Create(Self);
        tmpbde.DatabaseName:=Name;
        tmpbde.AliasName:=Server;
        tmpbde.Name:=Name;
        tmpbde.LoginPrompt:=false;
        Database:=TDatabase(tmpbde);
       end;
    1: begin
        tmpibx:=TIBDataBase.Create(Self);
        tmpibx.DefaultTransaction:=TIBTransaction.Create(Self);
        tmpibx.DefaultTransaction.AutoStopAction:=saCommit;
        tmpibx.DatabaseName:=Server;
        tmpibx.Name:=Name;
        tmpibx.LoginPrompt:=false;
        Database:=TDatabase(tmpibx);
       end;
    2: begin
        tmpoci:=TOCIDataBase.Create(Self);
        tmpoci.DatabaseName:=Name;
        tmpoci.Name:=Name;
        tmpoci.LoginPrompt:=false;
        Database:=TDatabase(tmpoci);
       end;
    3: begin
        tmpado:=TADOConnection.Create(Self);
        tmpado.ConnectionString:=Name;
        tmpado.Name:=Name;
        tmpado.LoginPrompt:=false;
        tmpado.Mode:=cmRead;
        Database:=TDatabase(tmpado);
       end;
    4: begin
        Database:=TDatabase(TOracleSession.Create(Self));
        TOracleSession(Database).LogonDatabase:=Name;
        TOracleSession(Database).Name:=Name;
//        Database.Assign(TDatabase(tmpdoa));
//        tmpdoa.Share();
       end;
   end;
 finally
  FillList;
  eDatabases.ItemIndex:=eDatabases.Items.Count-1;
 end;
end;

procedure TfDB.bDelClick(Sender: TObject);
var
 n:Integer;
begin
 if eDatabases.Items.Count<=0 then exit;
 if eDatabases.ItemIndex<0 then eDatabases.ItemIndex:=eDatabases.Items.Count-1;
 if eDatabases.ItemIndex>=0 then
  begin
   if DataBases[eDatabases.ItemIndex].Database<>nil then DataBases[eDatabases.ItemIndex].Database.Free;
   for n:=eDatabases.ItemIndex+1 to Length(Databases)-1 do Databases[n-1]:=Databases[n];
  end;
 SetLength(Databases,Length(Databases)-1);
 FillList;
 eDatabases.ItemIndex:=eDatabases.Items.Count-1;
 eDatabasesClick(eDatabases);
end;

procedure TfDB.eDatabasesClick(Sender: TObject);
begin
 if eDatabases.ItemIndex>=0 then
 with Databases[eDatabases.ItemIndex] do
 begin
   eName.Text:=Name;
   eServer.Text:=Server;
   eUser.Text:=User;
   ePass.Text:=Pass;
   eType.ItemIndex:=IDType;
 end;
end;

procedure TfDB.eDatabasesClickCheck(Sender: TObject);
begin
 if eDatabases.ItemIndex>=0 then
  with Databases[eDatabases.ItemIndex] do
   if Database<>nil then
    begin
     if Database.Connected then Database.Connected:=false
     else bConnect.Click;
     eDatabases.Checked[eDatabases.ItemIndex]:=Database.Connected;
    end;
end;

procedure TfDB.bConnectClick(Sender: TObject);
begin
 if eDatabases.ItemIndex>=0 then
  with Databases[eDatabases.ItemIndex] do
  if Database<>nil then
  begin
    if (eName.Text<>Name)or(eType.ItemIndex<>IDType) then
    begin
     if Application.MessageBox(PChar('Наименование или тип доступа изменены.'#10+
        'Создать новое соединение с новым именем или отменить ?'),PChar('Продолжить ?'),MB_OKCANCEL+MB_ICONWARNING)=IDOK then
     begin
      bAdd.Click;
     end else
     begin
      exit;
     end;
    end;
 end;
 if eDatabases.ItemIndex>=0 then
  with Databases[eDatabases.ItemIndex] do
  if Database<>nil then
  begin
    Server:=eServer.Text;
    User:=eUser.Text;
    Pass:=ePass.Text;
    Database.Connected:=false;
    eDatabases.Checked[eDatabases.ItemIndex]:=Database.Connected;
    case IDType of
     0:begin
        TDatabase(Database).AliasName:=Server;
        TDatabase(Database).Params.Clear;
        TDatabase(Database).Params.Add('USER_NAME='+User);
        TDatabase(Database).Params.Add('PASSWORD='+Pass);
       end;
     1:begin
        TIBDatabase(Database).DatabaseName:=Server;
        TIBDatabase(Database).Params.Clear;
        TIBDatabase(Database).Params.Add('USER_NAME='+User);
        TIBDatabase(Database).Params.Add('PASSWORD='+Pass);
       end;
     2:begin
        TOCIDatabase(Database).ServerName:=Server;
        TOCIDatabase(Database).UserName:=User;
        TOCIDatabase(Database).Password:=Pass;
       end;
     3:begin
        TADOConnection(Database).ConnectionString:=Server;
        if (Pos('Password=',Server)=0)and(Pass<>'') then
          TADOConnection(Database).ConnectionString:=TADOConnection(Database).ConnectionString+';Password='+Pass;
        if (Pos('User ID=',Server)=0)and(User<>'') then
          TADOConnection(Database).ConnectionString:=TADOConnection(Database).ConnectionString+';User ID='+User;
       end;
     4:begin
        TOracleSession(Database).LogonDatabase:=Server;
        TOracleSession(Database).LogonUserName:=User;
        TOracleSession(Database).LogonPassword:=Pass;
       end;
    end;
    try
     Screen.Cursor:=crSQLWait;
     Database.Connected:=true;
    finally
     Screen.Cursor:=crDefault;
    end;
    eDatabases.Checked[eDatabases.ItemIndex]:=Database.Connected;
  end;
end;

procedure TfDB.SaveDBs;
var
 n:Integer;
begin
 with fsDB do
 begin
  for n:=0 to Length(Databases) do
  begin
   IniSection:=inttostr(n);
   EraseSections;
  end;
  for n:=0 to Length(Databases)-1 do
  begin
   IniSection:=inttostr(n);
   with Databases[n] do
   begin
    WriteString('Name',Name);
    WriteInteger('IDType',IDType);
    WriteString('Server',Server);
    WriteString('User',User);
    WriteString('PassE',LogonEncrypt(Pass));
    WriteString('Pass','');
    if Database<>nil then WriteInteger('Connected',Integer(Database.Connected));
   end;
  end;
 end;
end;

procedure TfDB.LoadDBs;
var
 n:Integer;
begin
 for n:=0 to Length(Databases)-1 do
  with Databases[n] do
  begin
   if Database<>nil then Database.Free;
  end;
 SetLength(Databases,0);
 eDatabases.Items.Clear;
 with fsDB do
 begin
  n:=0;
  IniSection:=inttostr(n);
  while ReadString('Name','')<>'' do
  begin
   eName.Text:=ReadString('Name','');
   eType.ItemIndex:=ReadInteger('IDType',0);
   eServer.Text:=ReadString('Server','');
   eUser.Text:=ReadString('User','');
   if ReadString('Pass','')='' then ePass.Text:=LogonDecrypt(ReadString('PassE',''))
   else ePass.Text:=ReadString('Pass','');
   bAdd.Click;
   inc(n);
   IniSection:=inttostr(n);
  end;
  n:=0;
  IniSection:=inttostr(n);
  while ReadString('Name','')<>'' do
  begin
   eDataBases.ItemIndex:=n;
   eDataBases.OnClick(eDatabases);
   try
    eDataBases.Refresh;
    if ReadInteger('Connected',0)<>0 then bConnect.Click;
   except
    on E:Exception do ShowMessage('Невозможно выполнить соединение с '+eName.Text+':'#10+E.Message);
   end;
   inc(n);
   IniSection:=inttostr(n);
  end;
 end;
end;

procedure TfDB.bLoadClick(Sender: TObject);
begin
 if cbFile.Checked then
  begin
  if OpenDialog1.Execute then
   begin
    fsDB.UseRegistry:=false;
    fsDB.IniFileName:=OpenDialog1.FileName;
    LoadDBs;
    cbFile.Checked:=false;
   end;
  end else
  begin
    fsDB.UseRegistry:=true;
    fsDB.IniFileName:=RegistryKey;
    LoadDBs;
  end;
end;

procedure TfDB.bSaveClick(Sender: TObject);
begin
 if cbFile.Checked then
  begin
  if SaveDialog1.Execute then
   begin
    fsDB.UseRegistry:=false;
    fsDB.IniFileName:=SaveDialog1.FileName;
    SaveDBs;
    cbFile.Checked:=false;
   end;
  end else
  begin
    fsDB.UseRegistry:=true;
    fsDB.IniFileName:=RegistryKey;
    SaveDBs;
  end;
end;

procedure TfDB.cbFileClick(Sender: TObject);
begin
 if cbFile.Checked then cbFile.Caption:='в/из файла'
 else cbFile.Caption:='в/из реестра';
end;

function PromptDataSource(ParentHandle: THandle; InitialString: WideString): WideString;
var
  DataInit: IDataInitialize;
  DBPrompt: IDBPromptInitialize;
  DataSource: IUnknown;
  InitStr: PWideChar;
begin
  Result := InitialString;
  DataInit := CreateComObject(CLSID_DataLinks) as IDataInitialize;
  if InitialString <> '' then
    DataInit.GetDataSource(nil, CLSCTX_INPROC_SERVER,
      PWideChar(InitialString), IUnknown, DataSource);
  DBPrompt := CreateComObject(CLSID_DataLinks) as IDBPromptInitialize;
  if Succeeded(DBPrompt.PromptDataSource(nil, ParentHandle,
    DBPROMPTOPTIONS_PROPERTYSHEET, 0, nil, nil, IUnknown, DataSource)) then
  begin
    InitStr := nil;
    DataInit.GetInitializationString(DataSource, True, InitStr);
    Result := InitStr;
  end;
end;

procedure TfDB.sbConnClick(Sender: TObject);
begin
   if eType.ItemIndex=3 then eServer.Text := PromptDataSource(Handle, eServer.Text);
end;

end.


