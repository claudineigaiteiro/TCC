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
    mtGraficoID: TIntegerField;
    mtGraficoMEDICAO: TCurrencyField;
    mtGraficoID_UNIDADE: TIntegerField;
    mtGraficoDATA_HORA: TDateTimeField;
    mtMedia: TFDMemTable;
    dsMedia: TDataSource;
    mtMediaMEDICAO_MEDIA: TFloatField;
    mtTotal: TFDMemTable;
    mtTotalMEDICAO_TOTAL: TFloatField;
    dsTotal: TDataSource;
    procedure BtnGerarDadosClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RgTipoBuscaClick(Sender: TObject);
  private
    FUnidade: TUnidade;
    FGrafico: TWebCharts;
  protected
    procedure GerarGrafico; override;
  public
    property Unidade: TUnidade Write FUnidade;
    class function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
    class function getLeituraPeriodo(AIdUnidade: String;
      ADataInicio, ADataFim: TDate): String;
    class function getMediaDia(AIdUnidade: String; AData: TDate): String;
    class function getTotal(AIdUnidade: String; AData: TDate): String;

    class function getMediaPeriodo(AIdUnidade: String;
      ADataInicio, ADataFim: TDate): String;
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

        LJsonStream := TStringStream.Create(getMediaDia(FUnidade.ID,
          tpDataInicio.Date));
        Try
          mtMedia.Close;
          mtMedia.LoadFromJSON(LJsonStream.DataString);
          mtMedia.Open;
        Finally
          FreeAndNil(LJsonStream);
        End;

        LJsonStream := TStringStream.Create
          (getTotal(FUnidade.ID, tpDataInicio.Date));
        Try
          mtTotal.Close;
          mtTotal.LoadFromJSON(LJsonStream.DataString);
          mtTotal.Open;
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

procedure TPluviometro.FormDestroy(Sender: TObject);
begin
  inherited;
  If Assigned(FGrafico) Then
    FreeAndNil(FGrafico);
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

class function TPluviometro.getLeituraPeriodo(AIdUnidade: String;
  ADataInicio, ADataFim: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/periodo';
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

class function TPluviometro.getMediaDia(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/media/dia';
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

class function TPluviometro.getMediaPeriodo(AIdUnidade: String;
  ADataInicio, ADataFim: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/media/periodo';
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
    .AddBody(TJSONObject.Create.AddPair('data_inicio', LDataInicio).AddPair('data_fim', LDataFIm))
    .Accept('application/json').Get;

  Result := LResponse.Content;
end;

class function TPluviometro.getTotal(AIdUnidade: String; AData: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/total/dia';
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

procedure TPluviometro.RgTipoBuscaClick(Sender: TObject);
begin
  inherited;
  mtGrafico.Close;
  mtGrafico.Cancel;
  mtGrafico.Open;

  mtMedia.Close;
  mtMedia.Cancel;
  mtMedia.Open;

  mtTotal.Close;
  mtTotal.Cancel;
  mtTotal.Open;

  GerarGrafico;
end;

end.
