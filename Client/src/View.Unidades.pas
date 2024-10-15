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
  FireDAC.Stan.Async, FireDAC.DApt, System.JSON;

type
  TStatus = (tsInsert, tsEdit, tsNavegacao);

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
    procedure TsCadastroUnidadesEnter(Sender: TObject);
    procedure BtnSalvarClick(Sender: TObject);
  private
    FStatus: TStatus;
    procedure InserirRegistro(AJSON: TJSONObject);
    procedure Pesquisar;
    procedure EditarRegistro(AJSON: TJSONObject);
  public
    { Public declarations }
    FTeste: TFDMemTable;
  end;

var
  FrmUnidades: TFrmUnidades;

implementation

{$R *.dfm}

uses RESTRequest4D, DataSet.Serialize;

procedure TFrmUnidades.BtnCancelarClick(Sender: TObject);
begin
  mtUnidades.Cancel;
  PgcUnidades.ActivePage := TsListagemUnidades;
  FStatus := tsNavegacao;
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
  FStatus := tsInsert;
end;

procedure TFrmUnidades.BtnPesquisarUnidadeClick(Sender: TObject);
begin
  Pesquisar;
end;

procedure TFrmUnidades.BtnSalvarClick(Sender: TObject);
var
  LJSON: TJSONObject;
begin
  LJSON := TJSONObject.Create.AddPair('NOME', edtCadastroNome.Text)
    .AddPair('CODIGO', EdtCadastroCodigo.Text)
    .AddPair('CHAVE', edtCadastroChave.Text);

  if FStatus = tsInsert then
    InserirRegistro(LJSON)
  else if FStatus = tsEdit then
    EditarRegistro(LJSON);

  mtUnidades.Cancel;
  FStatus := tsNavegacao;

  PgcUnidades.ActivePage := TsListagemUnidades;

  Pesquisar;
end;

procedure TFrmUnidades.dgUnidadesCellClick(Column: TColumn);
begin
  PgcUnidades.ActivePage := TsCadastroUnidades;
end;

procedure TFrmUnidades.EditarRegistro(AJSON: TJSONObject);
begin
    TRequest.New.BaseURL('http://localhost:9000')
    .Resource('unidades')
    .ResourceSuffix(mtUnidades.FieldByName('ID').AsString)
    .ContentType('application/json')
    .AddBody(AJSON).Put;
end;

procedure TFrmUnidades.FormCreate(Sender: TObject);
var
  LResponse: IResponse;
  LJsonStream: TStringStream;
begin
  ReportMemoryLeaksOnShutdown := True;

  FStatus := tsNavegacao;

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

procedure TFrmUnidades.InserirRegistro(AJSON: TJSONObject);
begin
  TRequest.New.BaseURL('http://localhost:9000').Resource('unidades')
    .ContentType('application/json').AddBody(AJSON).Post;
end;

procedure TFrmUnidades.Pesquisar;
const
  CRecursoAll = 'unidades';
  CRecursoNome = 'unidades/nome';
  CRecursoCodigo = 'unidades/codigo';
var
  LRecurso: string;
  LResponse: IResponse;
  LJsonStream: TStringStream;
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
  begin
    LResponse := TRequest.New.BaseURL('http://localhost:9000')
      .Resource(LRecurso).Accept('application/json').Get;
  end;
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

procedure TFrmUnidades.RgFiltroPesquisaUnidadesClick(Sender: TObject);
begin
  LblFiltroPesquisa.Caption := RgFiltroPesquisaUnidades.Items
    [RgFiltroPesquisaUnidades.ItemIndex] + ':';

  EdtFiltroPesquisa.Text := EmptyStr;
end;

procedure TFrmUnidades.TsCadastroUnidadesEnter(Sender: TObject);
begin
  FStatus := tsEdit;
  mtUnidades.Edit;
end;

procedure TFrmUnidades.TsCadastroUnidadesExit(Sender: TObject);
begin
  mtUnidades.Cancel;
  FStatus := tsNavegacao;
end;

end.
