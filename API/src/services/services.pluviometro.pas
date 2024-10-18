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
    qryMediaDia: TFDQuery;
    qryMediaDiaID: TIntegerField;
    qryMediaDiaMEDICAO_MEDIA: TFMTBCDField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const APluviometro: TJSONObject): TFDQuery;
    function GetByPeriodo(const AId: Int64; ADataInicio, ADataFim: TDate)
      : TFDQuery;
    function GetByDia(const AId: Int64; AHoraInicio, AHoraFim: TDateTime)
      : TFDQuery;
    function GetMediaDia(const AId: Int64; AHoraInicio, AHoraFim: TDateTime)
      : TFDQuery;
  end;

var
  services_pluviometro: Tservices_pluviometro;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses DataSet.Serialize;

{ TdmConecxao1 }

function Tservices_pluviometro.GetByDia(const AId: Int64;
  AHoraInicio, AHoraFim: TDateTime): TFDQuery;
const
  CSQL = 'WITH RECURSIVE HORAS AS ( ' + #13 +
    '   SELECT CAST(:hora_inicio AS TIMESTAMP) AS DATA_HORA ' + #13 +
    '     FROM RDB$DATABASE ' + #13 + '    UNION ALL ' + #13 +
    '   SELECT DATEADD(1 HOUR TO DATA_HORA) ' + #13 + '     FROM HORAS ' + #13 +
    '    WHERE DATA_HORA < CAST(:hora_fim AS TIMESTAMP) ' + #13 + ') ' + #13 +
    'SELECT 0 AS ID, ' + #13 + '       H.DATA_HORA, ' + #13 +
    '       COALESCE(SUM(P.MEDICAO), 0) AS MEDICAO, ' + #13 +
    '       0 AS ID_UNIDADE ' + #13 + '  FROM HORAS H ' + #13 +
    '  LEFT JOIN PLUVIOMETRO P ' + #13 +
    '    ON P.DATA_HORA BETWEEN H.DATA_HORA AND DATEADD(1 HOUR TO H.DATA_HORA) '
    + #13 + '       AND P.ID_UNIDADE = :id ' + #13 + ' GROUP BY H.DATA_HORA ' +
    #13 + ' ORDER BY H.DATA_HORA ';

begin
  Result := qryPluviometro;
  qryPluviometro.SQL.Clear;
  qryPluviometro.SQL.Add(CSQL);
  qryPluviometro.ParamByName('hora_inicio').AsDateTime := AHoraInicio;
  qryPluviometro.ParamByName('hora_fim').AsDateTime := AHoraFim;
  qryPluviometro.ParamByName('id').AsLargeInt := AId;
  qryPluviometro.Open();
end;

function Tservices_pluviometro.GetByPeriodo(const AId: Int64;
  ADataInicio, ADataFim: TDate): TFDQuery;
Const
  CSQL = 'WITH RECURSIVE CALENDARIO AS ( ' + #13 +
    '   SELECT CAST(:data_inicio AS DATE) AS DATA ' + #13 +
    '     FROM RDB$DATABASE ' + #13 + '    UNION ALL' + #13 +
    '   SELECT DATA + 1 ' + #13 + '     FROM CALENDARIO ' + #13 +
    '    WHERE DATA < :data_fim ' + #13 + ')' + #13 + 'SELECT 0 AS ID, ' + #13 +
    '       0 AS ID_UNIDADE, ' + #13 +
    '       CAST(C.DATA AS TIMESTAMP) AS DATA_HORA, ' + #13 +
    '       COALESCE(SUM(P.MEDICAO), 0) AS MEDICAO ' + #13 +
    '  FROM CALENDARIO C ' + #13 +
    '  LEFT JOIN PLUVIOMETRO P ON CAST(P.DATA_HORA AS DATE) = C.DATA ' + #13 +
    '       AND P.ID_UNIDADE = :id ' + #13 + ' GROUP BY C.DATA ' + #13 +
    ' ORDER BY C.DATA ';

begin
  Result := qryPluviometro;
  qryPluviometro.SQL.Clear;;

  qryPluviometro.SQL.Add(CSQL);

  qryPluviometro.ParamByName('id').AsLargeInt := AId;
  qryPluviometro.ParamByName('data_inicio').AsDate := ADataInicio;
  qryPluviometro.ParamByName('data_fim').AsDate := ADataFim;
  qryPluviometro.Open();
end;

function Tservices_pluviometro.GetMediaDia(const AId: Int64; AHoraInicio, AHoraFim: TDateTime): TFDQuery;
const
  CSql =
    'SELECT 0 AS ID, ' + #13 +
    'COALESCE(SUM(P.MEDICAO), 0)/24 AS MEDICAO_MEDIA ' + #13 +
    '  FROM PLUVIOMETRO P ' + #13 +
    ' WHERE P.DATA_HORA >= CAST(:hora_inicio AS TIMESTAMP) ' + #13 +
    '   AND P.DATA_HORA < CAST(:hora_fim AS TIMESTAMP) ' + #13 +
    '   AND P.ID_UNIDADE = :id ';
begin
  Result := qryMediaDia;

  qryMediaDia.SQL.Clear;
  qryMediaDia.SQL.Add(CSQL);

  qryMediaDia.ParamByName('id').AsLargeInt := AId;
  qryMediaDia.ParamByName('hora_inicio').AsDateTime := AHoraInicio;
  qryMediaDia.ParamByName('hora_fim').AsDateTime := AHoraFim;

  qryMediaDia.Open;
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
