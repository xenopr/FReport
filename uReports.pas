unit uReports;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, FR_Class, FR_Desgn, FR_DCtrl, FR_BDEDB, FR_IBXDB, FR_E_HTM,
  FR_E_CSV, FR_E_TXT, FR_E_RTF, FR_Cross, FR_OLE, FR_DSet, FR_DBSet,
  FR_RRect, FR_Chart, FR_BarC, FR_Shape, FR_ChBox, FR_Rich, FR_OCIDB, DB,
  NCOciDB, FR_DOADB,
  FR_E_BMP, FR_E_XLS, FR_E_RTF_RS, JsExcelExport, frexpimg, frOLEExl,
  frXMLExl, frRtfExp, frTXTExp, FR_ADODB
  //,FR_E_BsExl01, FR_E_BsExl, FR_E_IRTF, FR_E_RTF_RS
  ;

type
  TfReports = class(TForm)
    frReport1: TfrReport;
    frDesigner1: TfrDesigner;
    frDialogControls1: TfrDialogControls;
    Label2: TLabel;
    frBDEComponents1: TfrBDEComponents;
    frIBXComponents1: TfrIBXComponents;
    frRTFExport1: TfrRTFExport;
    frCSVExport1: TfrCSVExport;
    frTextExport1: TfrTextExport;
    frHTMExport1: TfrHTMExport;
    frRichObject1: TfrRichObject;
    frCheckBoxObject1: TfrCheckBoxObject;
    frShapeObject1: TfrShapeObject;
    frBarCodeObject1: TfrBarCodeObject;
    frChartObject1: TfrChartObject;
    frRoundRectObject1: TfrRoundRectObject;
    frDBDataSet1: TfrDBDataSet;
    frUserDataset1: TfrUserDataset;
    frOLEObject1: TfrOLEObject;
    frCrossObject1: TfrCrossObject;
    frOCIComponents1: TfrOCIComponents;
    frDOAComponents1: TfrDOAComponents;
    frRoundRectObject2: TfrRoundRectObject;
    frBMPExport1: TfrBMPExport;
    JsFrExcelExport1: TJsFrExcelExport;
    frADOComponents1: TfrADOComponents;
    frTextAdvExport1: TfrTextAdvExport;
    frRtfAdvExport1: TfrRtfAdvExport;
    frJPEGExport1: TfrJPEGExport;
    frTIFFExport1: TfrTIFFExport;
    frXMLExcelExport1: TfrXMLExcelExport;
    frOLEExcelExport1: TfrOLEExcelExport;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fReports: TfReports;

implementation

uses uMain;

{$R *.DFM}


end.
