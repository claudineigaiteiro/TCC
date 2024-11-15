unit View.Anemometro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.FormBaseDemonstracao, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls, Types, View.WebCharts,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.OleCtrls,
  SHDocVw;

type
  TAnemometro = class(TfrmBaseDesmonstracao)
    mtGrafico: TFDMemTable;
    wbGrafico: TWebBrowser;
    mtGraficoID: TIntegerField;
    mtGraficoVELOVIDADE: TCurrencyField;
    mtGraficoIDUNIDADE: TIntegerField;
    mtGraficoDATAHORA: TDateTimeField;
    dsMedia: TDataSource;
    mtMedia: TFDMemTable;
    mtMediaVELOCIDADE_MEDIA: TFloatField;
    procedure BtnGerarDadosClick(Sender: TObject);
  private
    FUnidade: TUnidade;
    FGrafico: TWebCharts;
  protected
    procedure GerarGrafico; override;
  public
    class function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
    class function getMediaDia(AIdUnidade: String; AData: TDate): String;
    class function getLeituraPeriodo(AIdUnidade: String;
      ADataInicio, ADataFim: TDate): String;
    class function getMediaPeriodo(AIdUnidade: String;
      ADataInicio, ADataFim: TDate): String;

    property Unidade: TUnidade write FUnidade;
  end;

var
  Anemometro: TAnemometro;

implementation

uses
  RESTRequest4D, System.JSON, Charts.Types, DataSet.Serialize;

{$R *.dfm}
{ TAnemometro }

procedure TAnemometro.BtnGerarDadosClick(Sender: TObject);
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

        LJsonStream := TStringStream.Create(getMediaDia(FUnidade.ID,
          tpDataInicio.Date));
        Try
          mtMedia.Close;
          mtMedia.LoadFromJSON(LJsonStream.DataString);
          mtMedia.Open;
        Finally
          FreeAndNil(LJsonStream);
        End;

      end;
    1:
      begin
        LJsonStream := TStringStream.Create(getLeituraPeriodo(FUnidade.ID,
          tpDataInicio.Date, tpDataFim.Date));
        Try
          mtGrafico.Close;
          mtGrafico.LoadFromJSON(LJsonStream.DataString);
          mtGrafico.Open;
        Finally
          FreeAndNil(LJsonStream);
        End;

        LJsonStream := TStringStream.Create(getMediaPeriodo(FUnidade.ID,
          tpDataInicio.Date, tpDataFim.Date));
        Try
          mtMedia.Close;
          mtMedia.LoadFromJSON(LJsonStream.DataString);
          mtMedia.Open;
        Finally
          FreeAndNil(LJsonStream);
        End;


      end;
  end;
  GerarGrafico;
end;

procedure TAnemometro.GerarGrafico;
begin
  inherited;
  If Assigned(FGrafico) Then
    If Assigned(FGrafico) Then
      FreeAndNil(FGrafico);

  FGrafico := TWebCharts.Create;
  FGrafico.NewProject.Charts._ChartType(line).Attributes.Name('Pluviometro')
    .ColSpan(12).DataSet.DataSet(mtGrafico)
    .textLabel('mm de chuva por hora do dia corrente').Fill(True)
    .LabelName('DATA_HORA').ValueName('VELOCIDADE').RGBName('0.0.0')
    .&End.&End.&End.&End.WebBrowser(wbGrafico).Generated;
end;

class function TAnemometro.getLeituraDiaria(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/aneometros/%s/dia';
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

class function TAnemometro.getLeituraPeriodo(AIdUnidade: String;
  ADataInicio, ADataFim: TDate): String;
const
  CUrl = 'http://localhost:9000/aneometros/%s/periodo';
var
  LResponse: IResponse;
  LUrl: String;
  LDataInicio, LDataFim: String;
begin
  LDataInicio := DateToStr(ADataInicio);
  LDataInicio := StringReplace(LDataInicio, '/', '.', [rfReplaceAll]);

  LDataFim := DateToStr(ADataFim);
  LDataFim := StringReplace(LDataFim, '/', '.', [rfReplaceAll]);

  LUrl := Format(CUrl, [AIdUnidade]);
  LResponse := TRequest.New.BaseURL(LUrl)
    .AddBody(TJSONObject.Create.AddPair('data_inicio', LDataInicio)
    .AddPair('data_fim', LDataFim)).Accept('application/json').Get;

  Result := LResponse.Content;
end;

class function TAnemometro.getMediaDia(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/aneometros/%s/media/dia';
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

class function TAnemometro.getMediaPeriodo(AIdUnidade: String;
  ADataInicio, ADataFim: TDate): String;
const
  CUrl = 'http://localhost:9000/aneometros/%s/media/periodo';
var
  LResponse: IResponse;
  LUrl: String;
  LDataInicio, LDataFim: String;
begin
  LDataInicio := DateToStr(ADataInicio);
  LDataInicio := StringReplace(LDataInicio, '/', '.', [rfReplaceAll]);
  LDataFim := DateToStr(ADataFim);
  LDataFim := StringReplace(LDataFim, '/', '.', [rfReplaceAll]);
  LUrl := Format(CUrl, [AIdUnidade]);
  LResponse := TRequest.New.BaseURL(LUrl)
    .AddBody(TJSONObject.Create.AddPair('data_inicio', LDataInicio)
    .AddPair('data_fim', LDataFim)).Accept('application/json').Get;

  Result := LResponse.Content;
end;

end.
