unit View.Unidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls;

type
  TFrmUnidades = class(TForm)
    PgcUnidades: TPageControl;
    TsListagemUnidades: TTabSheet;
    PnlPesquisaUnidades: TPanel;
    LblFiltroPesquisa: TLabel;
    RgFiltroPesquisaUnidades: TRadioGroup;
    Edit1: TEdit;
    BtnPesquisarUnidade: TButton;
    TsCadastroUnidades: TTabSheet;
    dsUnidades: TDataSource;
    dgUnidades: TDBGrid;
    mtUnidades: TFDMemTable;
    mtUnidadesID: TLargeintField;
    mtUnidadesNOME: TStringField;
    mtUnidadesCHAVE: TStringField;
    mtUnidadesCODIGO: TStringField;
    LbUnidadeCadastroNome: TLabel;
    edtCadastroNome: TDBEdit;
    LbUnidadeCadastroChave: TLabel;
    edtCadastroChave: TDBEdit;
    LblCadastroCodigo: TLabel;
    EdtCadastroCodigo: TDBEdit;
    procedure BtnPesquisarUnidadeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RgFiltroPesquisaUnidadesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FTeste: TFDMemTable;
  end;

var
  FrmUnidades: TFrmUnidades;

implementation

{$R *.dfm}

uses RESTRequest4D, DataSet.Serialize, System.JSON;

procedure TFrmUnidades.BtnPesquisarUnidadeClick(Sender: TObject);
var
  LResponse: IResponse;
  LJsonStream: TStringStream;
begin
  LResponse := TRequest.New.BaseURL('http://localhost:9000')
    .Resource('unidades').Accept('application/json').Get;

  if LResponse.StatusCode = 200 then
  begin
    // Se a resposta for válida, use o conteúdo JSON
    LJsonStream := TStringStream.Create(LResponse.Content);
    try
      // Limpa o TFDMemTable e carrega o JSON
      mtUnidades.Close;
      mtUnidades.LoadFromJSON(LJsonStream.DataString);
      mtUnidades.Open;
    finally
      LJsonStream.Free;
    end;
  end;
end;

procedure TFrmUnidades.FormCreate(Sender: TObject);
var
  LResponse: IResponse;
  LJsonStream: TStringStream;
begin
  LResponse := TRequest.New.BaseURL('http://localhost:9000')
    .Resource('unidades').Accept('application/json').Get;

  if LResponse.StatusCode = 200 then
  begin
    // Se a resposta for válida, use o conteúdo JSON
    LJsonStream := TStringStream.Create(LResponse.Content);
    try
      // Limpa o TFDMemTable e carrega o JSON
      mtUnidades.Close;
      mtUnidades.LoadFromJSON(LJsonStream.DataString);
      mtUnidades.Open;
    finally
      LJsonStream.Free;
    end;
  end;
end;

procedure TFrmUnidades.RgFiltroPesquisaUnidadesClick(Sender: TObject);
begin
  LblFiltroPesquisa.Caption := RgFiltroPesquisaUnidades.Items
    [RgFiltroPesquisaUnidades.ItemIndex] + ':';
end;

end.
