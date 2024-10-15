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
    qryPluviometro: TFDQuery;
    qryPluviometroID: TIntegerField;
    qryPluviometroDATA_HORA: TDateTimeField;
    qryPluviometroMEDICAO: TVariantField;
    qryPluviometroID_UNIDADE: TIntegerField;
    FDMemTable1: TFDMemTable;
    PageControl1: TPageControl;
    tbsPluviometro: TTabSheet;
    PnlGraficoPluviometro: TPanel;
    wbPluviometro: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AtualizarRodape;
  private
    FUnidade: TUnidade;
    FGrafico: TWebCharts;
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
var
  LPluviometro: TPluviometro;
  LJsonStream: TStringStream;
begin
  FrmUnidades := TFrmUnidades.Create(nil);
  Try
    FrmUnidades.ShowModal;

    FUnidade := TUnidade.Create;
    FUnidade.ID := FrmUnidades.mtUnidades.FieldByName('ID').AsString;
    FUnidade.CODIGO := FrmUnidades.mtUnidades.FieldByName('CODIGO').AsString;
    FUnidade.NOME := FrmUnidades.mtUnidades.FieldByName('NOME').AsString;
    FUnidade.CHAVE := FrmUnidades.mtUnidades.FieldByName('CHAVE').AsString;

    // TTask.Run(
    // procedure
    // begin
    //
    // end
    // );

    LPluviometro := TPluviometro.Create;
    try
      LJsonStream := TStringStream.Create(LPluviometro.getLeituraDiaria(FUnidade.ID, Date));
      FDMemTable1.LoadFromJSON(LJsonStream.DataString);
      FDMemTable1.Open();

      FGrafico := TWebCharts.create;
      FGrafico
        .NewProject
          .Charts
            ._ChartType(line)
            .Attributes
              .Name('Pluviometro')
              .ColSpan(12)
              .DataSet
                .DataSet(FDMemTable1)
                .LabelName('DATA_HORA')
                .ValueName('MEDICAO')
                .RGBName('0.0.0')
              .&End
            .&End
          .&End
        .&End
        .WebBrowser(wbPluviometro)
        .Generated;
    finally
      FreeAndNil(LPluviometro);
      FreeAndNil(LJsonStream);
    end;

    AtualizarRodape;

  Finally
    FreeAndNil(FrmUnidades);
  End;
end;

procedure TFrmMenuInicial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FUnidade);
end;

end.
