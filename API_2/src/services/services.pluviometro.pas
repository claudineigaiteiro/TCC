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
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const APluviometro: TJSONObject): TFDQuery;
  end;

var
  services_pluviometro: Tservices_pluviometro;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses DataSet.Serialize;

{ TdmConecxao1 }

function Tservices_pluviometro.Insert(const APluviometro: TJSONObject): TFDQuery;
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
