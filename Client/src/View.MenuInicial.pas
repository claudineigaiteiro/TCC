unit View.MenuInicial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Classe.Unidade, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Menus, System.Threading, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.OleCtrls,
  SHDocVw, DataSet.Serialize, View.WebCharts, Vcl.ComCtrls;

type
  TFrmMenuInicial = class(TForm)
    PnlRodaPe: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LblCodigoRodape: TLabel;
    LblUnidadeRodape: TLabel;
    memMenuPrincipal: TMainMenu;
    Arquivo1: TMenuItem;
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
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AtualizarRodape;
    procedure BtnRodapeUnidadesClick(Sender: TObject);
  private
    FUnidade: TUnidade;
    FGrafico: TWebCharts;
    procedure GerarAtualizarGraficoPluviometroMenuPrincipal;
    procedure GerarGraficoPluviometro;
    procedure BuscarUnidade;
  public
    { Public declarations }
  end;

var
  FrmMenuInicial: TFrmMenuInicial;

implementation

{$R *.dfm}

uses
  View.Unidades, System.JSON, Classe.Pluviometro, Charts.Types;

procedure TFrmMenuInicial.AtualizarRodape;
begin
  LblCodigoRodape.Caption := FUnidade.CODIGO;
  LblUnidadeRodape.Caption := FUnidade.NOME;
end;

procedure TFrmMenuInicial.FormCreate(Sender: TObject);
begin
  BuscarUnidade;

  GerarAtualizarGraficoPluviometroMenuPrincipal;
end;

procedure TFrmMenuInicial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FUnidade);
  If Assigned(FGrafico) then
    FreeAndNil(FGrafico);
end;

procedure TFrmMenuInicial.GerarAtualizarGraficoPluviometroMenuPrincipal;
var
  LPluviometro: TPluviometro;
  LJsonStream: TStringStream;
begin
  TTask.Run(
    procedure
    begin
      while True do
      begin
        TThread.Synchronize(TThread.CurrentThread,
          procedure
          var
            LPluviometro: TPluviometro;
            LJsonStream: TStringStream;
          begin
            LPluviometro := TPluviometro.Create;
            Try
              LJsonStream := TStringStream.Create(LPluviometro.getLeituraDiaria
                (FUnidade.ID, Date));
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
              FreeAndNil(LPluviometro);
              FreeAndNil(LJsonStream);
            End;
          end);
        Sleep(60000);
      end;
    end);
end;

procedure TFrmMenuInicial.GerarGraficoPluviometro;
var
  LPluviometro: TPluviometro;
  LJsonStream: TStringStream;
begin
  LPluviometro := TPluviometro.Create;
  try
    LJsonStream := TStringStream.Create
      (LPluviometro.getLeituraDiaria(FUnidade.ID, Date));
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
    FreeAndNil(LPluviometro);
    FreeAndNil(LJsonStream);
  end;
end;

procedure TFrmMenuInicial.BuscarUnidade;
begin
  FrmUnidades := TFrmUnidades.Create(nil);
  try
    FrmUnidades.ShowModal;
    If Not Assigned(FUnidade) then
      FUnidade := TUnidade.Create;
    FUnidade.ID := FrmUnidades.mtUnidades.FieldByName('ID').AsString;
    FUnidade.CODIGO := FrmUnidades.mtUnidades.FieldByName('CODIGO').AsString;
    FUnidade.NOME := FrmUnidades.mtUnidades.FieldByName('NOME').AsString;
    FUnidade.CHAVE := FrmUnidades.mtUnidades.FieldByName('CHAVE').AsString;
    GerarGraficoPluviometro;
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
