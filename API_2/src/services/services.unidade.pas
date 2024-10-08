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
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const AUnidade: TJSONObject): TFDQuery;
  end;

var
  services_unidade: Tservices_unidade;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}

uses DataSet.Serialize;

{ Tservices_unidade }

function Tservices_unidade.Insert(const AUnidade: TJSONObject): TFDQuery;
begin
  Result := qryUnidade;
  qryUnidade.SQL.Add('WHERE 1 <> 1');
  qryUnidade.Open();
  qryUnidade.LoadFromJSON(AUnidade, False);
end;

end.
