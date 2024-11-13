unit View.MenuInicial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Menus, System.Threading, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.OleCtrls,
  SHDocVw, DataSet.Serialize, View.WebCharts, Vcl.ComCtrls, Types;

type
  TFrmMenuInicial = class(TForm)
    PnlRodaPe: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LblCodigoRodape: TLabel;
    LblUnidadeRodape: TLabel;
    memMenuPrincipal: TMainMenu;
    miArquivo: TMenuItem;
    mtGraficoPluviometro: TFDMemTable;
    PageControl1: TPageControl;
    tbsPluviometro: TTabSheet;
    PnlGraficoPluviometro: TPanel;
    wbPluviometro: TWebBrowser;
    BtnRodapeUnidades: TButton;
    mtGraficoPluviometroID: TIntegerField;
    mtGraficoPluviometroDATA_HORA: TDateTimeField;
    mtGraficoPluviometroID_UNIDADE: TIntegerField;
    mtGraficoPluviometroMEDICAO: TCurrencyField;
    miSair: TMenuItem;
    tbsAneometro: TTabSheet;
    Panel1: TPanel;
    wbAneometro: TWebBrowser;
    mtGraficoAneometro: TFDMemTable;
    mtGraficoAneometroID: TIntegerField;
    mtGraficoAneometroDATA_HORA: TDateTimeField;
    mtGraficoAneometroVELOCIDADE: TCurrencyField;
    mtGraficoAneometroID_UNIDADE: TIntegerField;
    miDados: TMenuItem;
    miGraficoPluviometro: TMenuItem;
    miGraficoAnemometro: TMenuItem;
    miListaImagem: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AtualizarRodape;
    procedure BtnRodapeUnidadesClick(Sender: TObject);
    procedure miSairClick(Sender: TObject);
    procedure miGraficoPluviometroClick(Sender: TObject);
    procedure miListaImagemClick(Sender: TObject);
  private
    FUnidade: TUnidade;
    FGrafico: TWebCharts;
    FTransacaoAneometro: ITask;
    FTransacaoPluviometro: ITask;
    procedure GerarAtualizarGraficoPluviometroMenuPrincipal;
    procedure GerarAtualizarGraficoAneometroMenuPrincipal;
    procedure GerarGraficoPluviometro;
    procedure GerarGraficoAneometro;
    procedure BuscarUnidade;
  public
    { Public declarations }
  end;

var
  FrmMenuInicial: TFrmMenuInicial;

implementation

{$R *.dfm}

uses
  View.Unidades, System.JSON, View.Pluviometro, Charts.Types, View.Imagem, View.Anemometro;

procedure TFrmMenuInicial.AtualizarRodape;
begin
  LblCodigoRodape.Caption := FUnidade.CODIGO;
  LblUnidadeRodape.Caption := FUnidade.NOME;
end;

procedure TFrmMenuInicial.FormCreate(Sender: TObject);
begin
  BuscarUnidade;

  GerarAtualizarGraficoPluviometroMenuPrincipal;
  GerarAtualizarGraficoAneometroMenuPrincipal;
end;

procedure TFrmMenuInicial.FormDestroy(Sender: TObject);
begin
  try
    FTransacaoAneometro.Cancel;
    FTransacaoPluviometro.Cancel;

    If Assigned(FGrafico) then
      FreeAndNil(FGrafico);
  except

  end;
end;

procedure TFrmMenuInicial.GerarAtualizarGraficoAneometroMenuPrincipal;
begin
  FTransacaoAneometro := TTask.Run(
    procedure
    begin
      while True do
      begin
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          var
            LJsonStream: TStringStream;
          begin
            Try
              LJsonStream := TStringStream.Create(TAnemometro.getLeituraDiaria
                (FUnidade.ID, Date));
              mtGraficoAneometro.Close;
              mtGraficoAneometro.LoadFromJSON(LJsonStream.DataString);
              mtGraficoAneometro.Open();

              if Assigned(FGrafico) then
                FreeAndNil(FGrafico);

              FGrafico := TWebCharts.Create;
              FGrafico.NewProject.Charts._ChartType(line)
                .Attributes.Name('Pluviometro').ColSpan(12)
                .DataSet.DataSet(mtGraficoAneometro)
                .textLabel('Velocidade do vento por hora do dia corrente')
                .Fill(True).LabelName('DATA_HORA').ValueName('VELOCIDADE')
                .RGBName('0.0.0').&End.&End.&End.&End.WebBrowser(wbAneometro)
                .Generated;
            Finally
              FreeAndNil(LJsonStream);
            End;
          end);
        Sleep(60000);
      end;
    end);
end;

procedure TFrmMenuInicial.GerarAtualizarGraficoPluviometroMenuPrincipal;

begin
  FTransacaoPluviometro := TTask.Run(
    procedure
    begin
      while True do
      begin
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          var
            LJsonStream: TStringStream;
          begin
            LJsonStream := TStringStream.Create(TPluviometro.getLeituraDiaria
              (FUnidade.ID, Date));
            Try
              mtGraficoPluviometro.Close;
              mtGraficoPluviometro.LoadFromJSON(LJsonStream.DataString);
              mtGraficoPluviometro.Open();

              if Assigned(FGrafico) then
                FreeAndNil(FGrafico);

              FGrafico := TWebCharts.Create;
              FGrafico.NewProject.Charts._ChartType(line)
                .Attributes.Name('Pluviometro').ColSpan(12)
                .DataSet.DataSet(mtGraficoPluviometro)
                .textLabel('mm de chuva por hora do dia corrente').Fill(True)
                .LabelName('DATA_HORA').ValueName('MEDICAO').RGBName('0.0.0')
                .&End.&End.&End.&End.WebBrowser(wbPluviometro).Generated;
            Finally
              FreeAndNil(LJsonStream);
            End;
          end);
        Sleep(60000);
      end;
    end);
end;

procedure TFrmMenuInicial.GerarGraficoAneometro;
var
  LJsonStream: TStringStream;
begin
  try
    LJsonStream := TStringStream.Create
      (TAnemometro.getLeituraDiaria(FUnidade.ID, Date));
    mtGraficoAneometro.Close;
    mtGraficoAneometro.LoadFromJSON(LJsonStream.DataString);
    mtGraficoAneometro.Open();

    If Assigned(FGrafico) Then
      FreeAndNil(FGrafico);

    FGrafico := TWebCharts.Create;
    FGrafico.NewProject.Charts._ChartType(line).Attributes.Name('Pluviometro')
      .ColSpan(12).DataSet.DataSet(mtGraficoAneometro)
      .textLabel('Velocidade do vento por hora do dia corrente').Fill(True)
      .LabelName('DATA_HORA').ValueName('VELOCIDADE').RGBName('0.0.0')
      .&End.&End.&End.&End.WebBrowser(wbAneometro).Generated;
  finally
    FreeAndNil(LJsonStream);
  end;
end;

procedure TFrmMenuInicial.GerarGraficoPluviometro;
var
  LJsonStream: TStringStream;
begin
  LJsonStream := TStringStream.Create
    (TPluviometro.getLeituraDiaria(FUnidade.ID, Date));
  try
    mtGraficoPluviometro.Close;
    mtGraficoPluviometro.LoadFromJSON(LJsonStream.DataString);
    mtGraficoPluviometro.Open();

    If Assigned(FGrafico) Then
      FreeAndNil(FGrafico);

    FGrafico := TWebCharts.Create;
    FGrafico.NewProject.Charts._ChartType(line).Attributes.Name('Pluviometro')
      .ColSpan(12).DataSet.DataSet(mtGraficoPluviometro)
      .textLabel('mm de chuva por hora do dia corrente').Fill(True)
      .LabelName('DATA_HORA').ValueName('MEDICAO').RGBName('0.0.0')
      .&End.&End.&End.&End.WebBrowser(wbPluviometro).Generated;
  finally
    FreeAndNil(LJsonStream);
  end;
end;

procedure TFrmMenuInicial.miGraficoPluviometroClick(Sender: TObject);
begin
  Pluviometro := TPluviometro.Create(nil);
  try
    Pluviometro.Unidade := FUnidade;
    Pluviometro.ShowModal;
  finally
    FreeAndNil(Pluviometro);
  end;
end;

procedure TFrmMenuInicial.miListaImagemClick(Sender: TObject);
begin
  Imagem := TImagem.Create(nil);
  try
    Imagem.Unidade := FUnidade;
    Imagem.ShowModal;
  finally
    FreeAndNil(Imagem);
  end;
end;

procedure TFrmMenuInicial.miSairClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMenuInicial.BuscarUnidade;
begin
  FrmUnidades := TFrmUnidades.Create(nil);
  try
    FrmUnidades.ShowModal;
    FUnidade.ID := FrmUnidades.mtUnidades.FieldByName('ID').AsString;
    FUnidade.CODIGO := FrmUnidades.mtUnidades.FieldByName('CODIGO').AsString;
    FUnidade.NOME := FrmUnidades.mtUnidades.FieldByName('NOME').AsString;
    FUnidade.CHAVE := FrmUnidades.mtUnidades.FieldByName('CHAVE').AsString;
    GerarGraficoPluviometro;
    GerarGraficoAneometro;
    AtualizarRodape;
  finally
    FreeAndNil(FrmUnidades);
  end;
end;

procedure TFrmMenuInicial.BtnRodapeUnidadesClick(Sender: TObject);
begin
  BuscarUnidade;
end;

end.
