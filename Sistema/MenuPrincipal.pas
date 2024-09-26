unit MenuPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.OleCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  Vcl.StdCtrls, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  View.WebCharts, SHDocVw;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Button1: TButton;
    WebBrowser1: TWebBrowser;
    FDQuery1DATA_HORA: TSQLTimeStampField;
    FDQuery1MEDICAO: TFMTBCDField;
    FDQuery1RGB: TStringField;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    WebChart: TWebCharts;
  public
    { Public declarations }
    constructor create;
  end;

var
  Form2: TForm2;

implementation

uses
  Charts.Types;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  If Not Assigned(WebChart) Then
    WebChart := TWebCharts.Create;
  WebChart
    .NewProject
    .Charts
      ._ChartType(line)
        .Attributes
          .Name('FUNE')
          .ColSpan(12)
          .DataSet
            .DataSet(FDQuery1)
            .LabelName('DATA_HORA')
            .ValueName('MEDICAO')
            .RGBName('RGB')
          .&End
        .&End
      .&End
    .&End
  .WebBrowser(WebBrowser1)
  .Generated;
end;

constructor TForm2.create;
begin
//  WebChart := TWebCharts.create;
end;

end.
