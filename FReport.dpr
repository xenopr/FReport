program FReport;

uses
  Forms,
  uMain in 'uMain.pas' {fMain},
  uReports in 'uReports.pas' {fReports},
  uDB in 'uDB.pas' {fDB};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'FReport';
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfReports, fReports);
  Application.CreateForm(TfDB, fDB);
  Application.Run;
end.
