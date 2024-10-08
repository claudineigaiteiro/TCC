unit services.imagem;

interface

uses
  System.SysUtils, System.Classes, providers.conecxaoDB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.ConsoleUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, System.JSON, Vcl.Imaging.jpeg,
  System.NetEncoding;

type
  Tservices_imagem = class(TdmConecxao)
    qryImagem: TFDQuery;
    qryUnidade: TFDQuery;
    qryImagemID: TIntegerField;
    qryImagemIMAGEM: TBlobField;
    qryImagemID_UNIDADE: TIntegerField;
    qryUnidadeID: TIntegerField;
    qryImagemDATA: TSQLTimeStampField;
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const AImagem: TJSONObject): TFDQuery;
    function GetByPeriodo(const AId: Int64; ADataInicio, ADataFim: TDate): TFDQuery;
  end;

var
  services_imagem: Tservices_imagem;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

{ TdmConecxao1 }

Uses DataSet.Serialize;

function Tservices_imagem.GetByPeriodo(const AId: Int64; ADataInicio,
  ADataFim: TDate): TFDQuery;
Const
  CSQL =
    'SELECT HISTORICO_IMAGENS.ID, ' + #13 +
    '       HISTORICO_IMAGENS.DATA, ' + #13 +
    '       HISTORICO_IMAGENS.IMAGEM, ' + #13 +
    '       HISTORICO_IMAGENS.ID_UNIDADE ' + #13 +
    '  FROM HISTORICO_IMAGENS ' + #13 +
    ' WHERE HISTORICO_IMAGENS.ID_UNIDADE = :id' + #13 +
    '   AND HISTORICO_IMAGENS.DATA BETWEEN :data_inicio AND :data_fim ';

begin
  result := qryImagem;
  qryImagem.SQL.Clear;;

  qryImagem.SQL.Add(CSQL);

  qryImagem.ParamByName('id').AsLargeInt := AId;
  qryImagem.ParamByName('data_inicio').AsDate := ADataInicio;
  qryImagem.ParamByName('data_fim').AsDate := ADataFim;
  qryImagem.Open();
end;

function Tservices_imagem.Insert(const AImagem: TJSONObject): TFDQuery;
var
  LUnidade: String;
begin
  LUnidade := AImagem.get('chave').JsonValue.ToString;
  LUnidade := Copy(LUnidade, 2, Length(LUnidade) - 2);

  qryUnidade.SQL.Add('WHERE UNIDADES.CHAVE = ''' + LUnidade + '''');
  qryUnidade.Open();

  If qryUnidade.RecordCount > 0 then
  begin
    AImagem.RemovePair('chave');
    AImagem.AddPair('ID_UNIDADE', qryUnidade.FieldByName('ID').Text);

    Result := qryImagem;
    qryImagem.SQL.Add('WHERE 1 <> 1');
    qryImagem.Open();
    qryImagem.LoadFromJSON(AImagem, False);
  end
end;

end.
