unit View.Pluviometro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.FormBaseDemonstracao, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls, System.Sensors,
  System.Sensors.Components, Vcl.OleCtrls, SHDocVw, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Types, View.WebCharts;

type
  TPluviometro = class(TfrmBaseDesmonstracao)
    wbGrafico: TWebBrowser;
    mtGrafico: TFDMemTable;
    procedure BtnGerarDadosClick(Sender: TObject);
  private
    FUnidade: TUnidade;
    FGrafico: TWebCharts;
  protected
    procedure GerarGrafico; override;
  public
    property Unidade: TUnidade Write FUnidade;
    class function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
  end;

var
  Pluviometro: TPluviometro;

implementation

{$R *.dfm}
{ TPluviometro }

uses RESTRequest4D, System.JSON, Charts.Types, DataSet.Serialize;

procedure TPluviometro.BtnGerarDadosClick(Sender: TObject);
var
  LJsonStream: TStringStream;
begin
  inherited;
  case RgTipoBusca.ItemIndex of
    0:
      begin
        LJsonStream := TStringStream.Create(getLeituraDiaria(FUnidade.ID,
          tpDataInicio.Date));
        Try
          mtGrafico.Close;
          mtGrafico.LoadFromJSON(LJsonStream.DataString);
          mtGrafico.Open;
        Finally
          FreeAndNil(LJsonStream);
        End;
      end;
    1:
      begin
        //
      end;
  end;
  GerarGrafico;
end;

procedure TPluviometro.GerarGrafico;
begin
  inherited;
  If Assigned(FGrafico) Then
    If Assigned(FGrafico) Then
      FreeAndNil(FGrafico);

  FGrafico := TWebCharts.Create;
  FGrafico.NewProject.Charts._ChartType(line).Attributes.Name('Pluviometro')
    .ColSpan(12).DataSet.DataSet(mtGrafico)
    .textLabel('mm de chuva por hora do dia corrente').Fill(True)
    .LabelName('DATA_HORA').ValueName('MEDICAO').RGBName('0.0.0')
    .&End.&End.&End.&End.WebBrowser(wbGrafico).Generated;
end;

class function TPluviometro.getLeituraDiaria(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/dia';
var
  LResponse: IResponse;
  LUrl: String;
  LData: String;
begin
  LData := DateToStr(AData);
  LData := StringReplace(LData, '/', '.', [rfReplaceAll]);
  LUrl := Format(CUrl, [AIdUnidade]);
  LResponse := TRequest.New.BaseURL(LUrl)
    .AddBody(TJSONObject.Create.AddPair('data', LData))
    .Accept('application/json').Get;

  Result := LResponse.Content;
end;

end.
