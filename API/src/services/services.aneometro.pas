unit services.aneometro;

interface

uses
  System.SysUtils, System.Classes, providers.conecxaoDB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON;

type
  Tservices_aneometro = class(TdmConecxao)
    qryAneometro: TFDQuery;
    qryAneometroID: TIntegerField;
    qryAneometroVELOCIDADE: TFMTBCDField;
    qryAneometroID_UNIDADE: TIntegerField;
    qryUnidade: TFDQuery;
    qryAneometroDATA_HORA: TSQLTimeStampField;
    qryMedia: TFDQuery;
    qryMediaVELOCIDADE_MEDIA: TFMTBCDField;
    qryMediaID: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const AAneometro: TJSONObject): TFDQuery;
    function GetByPeriodo(const AId: Int64; ADataInicio, ADataFim: TDate)
      : TFDQuery;
    function GetByDia(const AId: Int64; AHoraInicio, AHoraFim: TDateTime)
      : TFDQuery;
    function GetMediaByDia(const AId: Int64; AHoraInicio, AHoraFim: TDateTime)
      : TFDQuery;
    function GetMediaPeriodo(const AId: Int64; ADataInicio, ADataFim: TDateTime)
      : TFDQuery;
  end;

var
  services_aneometro: Tservices_aneometro;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}
{ Tservices_aneometro }

uses DataSet.Serialize;

function Tservices_aneometro.GetByDia(const AId: Int64;
  AHoraInicio, AHoraFim: TDateTime): TFDQuery;
const
  CSQL = 'WITH RECURSIVE HORAS AS ( ' + #13 +
    '   SELECT CAST(:hora_inicio AS TIMESTAMP) AS DATA_HORA ' + #13 +
    '     FROM RDB$DATABASE ' + #13 + '    UNION ALL ' + #13 +
    '   SELECT DATEADD(1 HOUR TO DATA_HORA) ' + #13 + '     FROM HORAS ' + #13 +
    '    WHERE DATA_HORA < CAST(:hora_fim AS TIMESTAMP) ' + #13 + ') ' + #13 +
    'SELECT 0 AS ID, ' + #13 + '       H.DATA_HORA, ' + #13 +
    '       COALESCE(AVG(A.VELOCIDADE), 0) AS VELOCIDADE, ' + #13 +
    '       0 AS ID_UNIDADE ' + #13 + '  FROM HORAS H ' + #13 +
    '  LEFT JOIN ANEOMETRO A ' + #13 +
    '    ON A.DATA_HORA BETWEEN H.DATA_HORA AND DATEADD(1 HOUR TO H.DATA_HORA) '
    + #13 + '       AND A.ID_UNIDADE = :id ' + #13 + ' GROUP BY H.DATA_HORA ' +
    #13 + ' ORDER BY H.DATA_HORA ';

begin
  Result := qryAneometro;
  qryAneometro.SQL.Clear;
  qryAneometro.SQL.Add(CSQL);
  qryAneometro.ParamByName('hora_inicio').AsDateTime := AHoraInicio;
  qryAneometro.ParamByName('hora_fim').AsDateTime := AHoraFim;
  qryAneometro.ParamByName('id').AsLargeInt := AId;
  qryAneometro.Open();
end;

function Tservices_aneometro.GetByPeriodo(const AId: Int64;
  ADataInicio, ADataFim: TDate): TFDQuery;
Const
  CSQL = 'WITH RECURSIVE CALENDARIO AS ( ' + #13 +
    '   SELECT CAST(:data_inicio AS DATE) AS DATA ' + #13 +
    '     FROM RDB$DATABASE ' + #13 + '    UNION ALL' + #13 +
    '   SELECT DATA + 1 ' + #13 + '     FROM CALENDARIO ' + #13 +
    '    WHERE DATA < :data_fim ' + #13 + ')' + #13 + 'SELECT 0 AS ID, ' + #13 +
    '       0 AS ID_UNIDADE, ' + #13 +
    '       CAST(C.DATA AS TIMESTAMP) AS DATA_HORA, ' + #13 +
    '       COALESCE(AVG(A.VELOCIDADE), 0) AS VELOCIDADE ' + #13 +
    '  FROM CALENDARIO C ' + #13 +
    '  LEFT JOIN ANEOMETRO A ON CAST(A.DATA_HORA AS DATE) = C.DATA ' + #13 +
    '       AND A.ID_UNIDADE = :id ' + #13 + ' GROUP BY C.DATA ' + #13 +
    ' ORDER BY C.DATA ';

begin
  Result := qryAneometro;
  qryAneometro.SQL.Clear;;

  qryAneometro.SQL.Add(CSQL);

  qryAneometro.ParamByName('id').AsLargeInt := AId;
  qryAneometro.ParamByName('data_inicio').AsDate := ADataInicio;
  qryAneometro.ParamByName('data_fim').AsDate := ADataFim;
  qryAneometro.Open();
end;

function Tservices_aneometro.GetMediaByDia(const AId: Int64;
  AHoraInicio, AHoraFim: TDateTime): TFDQuery;
const
  CSQL = 'SELECT 0 AS ID, ' + #13 +
    '       COALESCE(SUM(A.VELOCIDADE), 0)/24 AS VELOCIDADE_MEDIA ' + #13 +
    '  FROM ANEOMETRO A ' + #13 +
    ' WHERE A.DATA_HORA >= CAST(:hora_inicio AS TIMESTAMP) ' + #13 +
    '   AND A.DATA_HORA < CAST(:hora_fim AS TIMESTAMP) ' + #13 +
    '   AND A.ID_UNIDADE = :id ';
begin
  Result := qryMedia;

  qryMedia.SQL.Clear;
  qryMedia.SQL.Add(CSQL);

  qryMedia.ParamByName('id').AsLargeInt := AId;
  qryMedia.ParamByName('hora_inicio').AsDateTime := AHoraInicio;
  qryMedia.ParamByName('hora_fim').AsDateTime := AHoraFim;

  qryMedia.Open;
end;

function Tservices_aneometro.GetMediaPeriodo(const AId: Int64; ADataInicio, ADataFim: TDateTime): TFDQuery;
const
  CSQL =
    'WITH RECURSIVE HORAS AS ( ' + #13 +
    ' SELECT CAST(:data_inicio AS TIMESTAMP) AS DATA_HORA ' + #13 +
    '   FROM RDB$DATABASE ' + #13 +
    '  UNION ALL ' + #13 +
    ' SELECT DATEADD(1 HOUR TO DATA_HORA) ' + #13 +
    '   FROM HORAS ' + #13 +
    '  WHERE DATA_HORA < CAST(:data_fim AS TIMESTAMP) ' + #13 + ') ' + #13 +
    'SELECT 0 AS ID, ' + #13 +
    'COALESCE(SUM(A.VELOCIDADE), 0) / COUNT(DISTINCT CAST(H.DATA_HORA AS DATE)) AS VELOCIDADE_MEDIA '
    + #13 + '  FROM HORAS H ' + #13 + '  LEFT JOIN ANEOMETRO A ' + #13 +
    '    ON A.DATA_HORA >= H.DATA_HORA ' + #13 +
    '   AND A.DATA_HORA < DATEADD(1 HOUR TO H.DATA_HORA) ' + #13 +
    '   AND A.ID_UNIDADE = :id_unidade ';
begin
  Result := qryMedia;
  qryMedia.SQL.Clear;;

  qryMedia.SQL.Add(CSQL);

  qryMedia.ParamByName('id_unidade').AsLargeInt := AId;
  qryMedia.ParamByName('data_inicio').AsDate := ADataInicio;
  qryMedia.ParamByName('data_fim').AsDate := ADataFim;
  qryMedia.Open();
end;

function Tservices_aneometro.Insert(const AAneometro: TJSONObject): TFDQuery;
var
  LUnidade: String;
begin
  LUnidade := AAneometro.get('chave').JsonValue.ToString;
  LUnidade := Copy(LUnidade, 2, Length(LUnidade) - 2);

  qryUnidade.SQL.Add('WHERE UNIDADES.CHAVE = ''' + LUnidade + '''');
  qryUnidade.Open();

  If qryUnidade.RecordCount > 0 then
  begin
    AAneometro.RemovePair('chave');
    AAneometro.AddPair('ID_UNIDADE', qryUnidade.FieldByName('ID').Text);

    Result := qryAneometro;
    qryAneometro.SQL.Add('WHERE 1 <> 1');
    qryAneometro.Open();
    qryAneometro.LoadFromJSON(AAneometro, False);
  end
end;

end.
