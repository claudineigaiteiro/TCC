unit View.Unidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids, Vcl.Mask, Vcl.DBCtrls,
  FireDAC.Stan.Async, FireDAC.DApt;

type
  TFrmUnidades = class(TForm)
    PgcUnidades: TPageControl;
    TsListagemUnidades: TTabSheet;
    PnlPesquisaUnidades: TPanel;
    LblFiltroPesquisa: TLabel;
    RgFiltroPesquisaUnidades: TRadioGroup;
    EdtFiltroPesquisa: TEdit;
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
    pnlFoodListagem: TPanel;
    btnEntrar: TButton;
    PnlFoodCadastro: TPanel;
    BtnSalvar: TButton;
    BtnNovo: TButton;
    BtnCancelar: TButton;
    BtnExcluir: TButton;
    procedure BtnPesquisarUnidadeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RgFiltroPesquisaUnidadesClick(Sender: TObject);
    procedure dgUnidadesCellClick(Column: TColumn);
    procedure BtnCancelarClick(Sender: TObject);
    procedure BtnNovoClick(Sender: TObject);
    procedure TsCadastroUnidadesExit(Sender: TObject);
    procedure BtnExcluirClick(Sender: TObject);
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

procedure TFrmUnidades.BtnCancelarClick(Sender: TObject);
begin
  mtUnidades.Cancel;
  PgcUnidades.ActivePage := TsListagemUnidades;
end;

procedure TFrmUnidades.BtnExcluirClick(Sender: TObject);
var
  LResponse: IResponse;
begin
  LResponse := TRequest.New.BaseURL('http://localhost:9000')
    .Resource('unidades').ResourceSuffix(mtUnidades.FieldByName('ID')
    .AsString).Delete;

  if LResponse.StatusCode = 204 then
    mtUnidades.Delete;

  PgcUnidades.ActivePage := TsListagemUnidades;
end;

procedure TFrmUnidades.BtnNovoClick(Sender: TObject);
begin
  mtUnidades.Insert;
end;

procedure TFrmUnidades.BtnPesquisarUnidadeClick(Sender: TObject);
const
  CRecursoAll = 'unidades';
  CRecursoNome = 'unidades/nome';
  CRecursoCodigo = 'unidades/codigo';
var
  LResponse: IResponse;
  LJsonStream: TStringStream;
  LRecurso: String;
  LJSON: TJSONObject;
begin
  if EdtFiltroPesquisa.Text = EmptyStr then
  begin
    LRecurso := CRecursoAll;
  end
  else if RgFiltroPesquisaUnidades.ItemIndex = 0 then
  begin
    LRecurso := CRecursoNome;
    LJSON := TJSONObject.Create;
    LJSON.AddPair('nome', EdtFiltroPesquisa.Text);
  end
  else if RgFiltroPesquisaUnidades.ItemIndex = 1 then
  begin
    LRecurso := CRecursoCodigo;
    LJSON := TJSONObject.Create;
    LJSON.AddPair('codigo', EdtFiltroPesquisa.Text);
  end;

  if Assigned(LJSON) then
  begin
    LResponse := TRequest.New.BaseURL('http://localhost:9000')
      .Resource(LRecurso).AddBody(LJSON).Accept('application/json').Get;
  end
  else
  Begin
    LResponse := TRequest.New.BaseURL('http://localhost:9000')
      .Resource(LRecurso).Accept('application/json').Get;
  End;

  if LResponse.StatusCode = 200 then
  begin
    LJsonStream := TStringStream.Create(LResponse.Content);
    try
      mtUnidades.Close;
      mtUnidades.LoadFromJSON(LJsonStream.DataString);
      mtUnidades.Open;
    finally
      LJsonStream.Free;
    end;
  end;
end;

procedure TFrmUnidades.dgUnidadesCellClick(Column: TColumn);
begin
  PgcUnidades.ActivePage := TsCadastroUnidades;
end;

procedure TFrmUnidades.FormCreate(Sender: TObject);
var
  LResponse: IResponse;
  LJsonStream: TStringStream;
begin
  ReportMemoryLeaksOnShutdown := True;

  LResponse := TRequest.New.BaseURL('http://localhost:9000')
    .Resource('unidades').Accept('application/json').Get;

  if LResponse.StatusCode = 200 then
  begin
    // Se a resposta for v�lida, use o conte�do JSON
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

  EdtFiltroPesquisa.Text := EmptyStr;
end;

procedure TFrmUnidades.TsCadastroUnidadesExit(Sender: TObject);
begin
  mtUnidades.Cancel;
end;

end.
