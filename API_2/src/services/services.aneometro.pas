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
  private
    { Private declarations }
  public
    { Public declarations }
    function Insert(const AAneometro: TJSONObject): TFDQuery;
  end;

var
  services_aneometro: Tservices_aneometro;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}
{$R *.dfm}
{ Tservices_aneometro }

uses DataSet.Serialize;

function Tservices_aneometro.Insert(const AAneometro: TJSONObject): TFDQuery;
begin
  Result := qryAneometro;
  qryAneometro.SQL.Add('WHERE 1 <> 1');
  qryAneometro.Open();
  qryAneometro.LoadFromJSON(AAneometro, False);
end;

end.
