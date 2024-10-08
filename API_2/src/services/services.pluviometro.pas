unit services.pluviometro;

interface

uses
  System.SysUtils, System.Classes, providers.conecxaoDB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON;

type
  Tservices_pluviometro = class(TdmConecxao)
    qryPluviometro: TFDQuery;
    qryPluviometroID: TIntegerField;
    qryPluviometroMEDICAO: TFMTBCDField;
    qryPluviometroID_UNIDADE: TIntegerField;
    qryUnidade: TFDQuery;
    qryPluviometroDATA_HORA: TSQLTimeStampField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const APluviometro: TJSONObject): TFDQuery;
    function GetByPeriodo(const AId: Int64; ADataInicio, ADataFim: TDate): TFDQuery;
  end;

var
  services_pluviometro: Tservices_pluviometro;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses DataSet.Serialize;

{ TdmConecxao1 }

function Tservices_pluviometro.GetByPeriodo(const AId: Int64;
  ADataInicio, ADataFim: TDate): TFDQuery;
Const
  CSQL =
    'WITH RECURSIVE CALENDARIO AS ( ' + #13 +
    '   SELECT CAST(:data_inicio AS DATE) AS DATA ' + #13 +
    '     FROM RDB$DATABASE ' + #13 +
    '    UNION ALL' + #13 +
    '   SELECT DATA + 1 ' + #13 +
    '     FROM CALENDARIO ' + #13 +
    '    WHERE DATA < :data_fim ' + #13 +
    ')' + #13 +
    'SELECT 0 AS ID, ' + #13 +
    '       0 AS ID_UNIDADE, ' + #13 +
    '       CAST(C.DATA AS TIMESTAMP) AS DATA_HORA, ' + #13 +
    '       COALESCE(SUM(P.MEDICAO), 0) AS MEDICAO ' + #13 +
    '  FROM CALENDARIO C ' + #13 +
    '  LEFT JOIN PLUVIOMETRO P ON CAST(P.DATA_HORA AS DATE) = C.DATA ' + #13 +
    '       AND P.ID_UNIDADE = :id ' + #13 +
    ' GROUP BY C.DATA ' + #13 +
    ' ORDER BY C.DATA ';

begin
  result := qryPluviometro;
  qryPluviometro.SQL.Clear;;

  qryPluviometro.SQL.Add(CSQL);

  qryPluviometro.ParamByName('id').AsLargeInt := AId;
  qryPluviometro.ParamByName('data_inicio').AsDate := ADataInicio;
  qryPluviometro.ParamByName('data_fim').AsDate := ADataFim;
  qryPluviometro.Open();
end;

function Tservices_pluviometro.Insert(const APluviometro: TJSONObject)
  : TFDQuery;
var
  LUnidade: String;
begin
  LUnidade := APluviometro.get('chave').JsonValue.ToString;
  LUnidade := Copy(LUnidade, 2, Length(LUnidade) - 2);

  qryUnidade.SQL.Add('WHERE UNIDADES.CHAVE = ''' + LUnidade + '''');
  qryUnidade.Open();

  If qryUnidade.RecordCount > 0 then
  begin
    APluviometro.RemovePair('chave');
    APluviometro.AddPair('ID_UNIDADE', qryUnidade.FieldByName('ID').Text);

    Result := qryPluviometro;
    qryPluviometro.SQL.Add('WHERE 1 <> 1');
    qryPluviometro.Open();
    qryPluviometro.LoadFromJSON(APluviometro, False);
  end
end;

end.
