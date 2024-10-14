unit services.unidade;

interface

uses
  System.SysUtils, System.Classes, providers.conecxaoDB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON;

type
  Tservices_unidade = class(TdmConecxao)
    qryUnidade: TFDQuery;
    qryUnidadeID: TIntegerField;
    qryUnidadeNOME: TStringField;
    qryUnidadeCHAVE: TStringField;
    qryUnidadeCODIGO: TStringField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const AUnidade: TJSONObject): TFDQuery;
    function GetAll: TFDQuery;
    function GetByName(ANome: String): TFDQuery;
    function GetByCodigo(ACodigo: String): TFDQuery;
  end;

var
  services_unidade: Tservices_unidade;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses DataSet.Serialize;

{ Tservices_unidade }

function Tservices_unidade.GetAll: TFDQuery;
begin
  Result := qryUnidade;
  qryUnidade.Open();
end;

function Tservices_unidade.GetByCodigo(ACodigo: String): TFDQuery;
const
  CSQL =
    'SELECT UNIDADES.ID, ' + #13 +
    '       UNIDADES.CODIGO, ' + #13 +
    '       UNIDADES.NOME, ' + #13 +
    '       UNIDADES.CHAVE ' + #13 + '  FROM UNIDADES ' + #13 +
    ' WHERE UNIDADES.CODIGO CONTAINING :codigo ';
begin
  Result := qryUnidade;
  qryUnidade.sql.Clear;
  qryUnidade.sql.Add(CSQL);
  qryUnidade.ParamByName('codigo').AsString := ACodigo;
  qryUnidade.Open();
end;

function Tservices_unidade.GetByName(ANome: String): TFDQuery;
const
  CSQL =
    'SELECT UNIDADES.ID, ' + #13 +
    '       UNIDADES.CODIGO, ' + #13 +
    '       UNIDADES.NOME, ' + #13 +
    '       UNIDADES.CHAVE ' + #13 + '  FROM UNIDADES ' + #13 +
    ' WHERE UNIDADES.NOME CONTAINING :nome ';
begin
  Result := qryUnidade;
  qryUnidade.sql.Clear;
  qryUnidade.sql.Add(CSQL);
  qryUnidade.ParamByName('nome').AsString := ANome;
  qryUnidade.Open();
end;

function Tservices_unidade.Insert(const AUnidade: TJSONObject): TFDQuery;
begin
  Result := qryUnidade;
  qryUnidade.sql.Add('WHERE 1 <> 1');
  qryUnidade.Open();
  qryUnidade.LoadFromJSON(AUnidade, False);
end;

end.
