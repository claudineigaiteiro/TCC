unit Classe.Pluviometro;

interface

uses
  System.JSON;

type
  TPluviometro = class
  private
  public
    function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
  end;

implementation

{ TPluviometro }

uses RESTRequest4D, System.SysUtils;

function TPluviometro.getLeituraDiaria(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/dia';
var
  LResponse: IResponse;
  LUrl: String;
  //LJson: TJSONObject;
  LData: String;
begin
  LData := DateToStr(AData);
  LData := StringReplace(LData, '/', '.', [rfReplaceAll]);
  LUrl := Format(CUrl, [AIdUnidade]);
  LResponse := TRequest.New.BaseURL(LUrl)
   .AddBody(TJSONObject.Create.AddPair('data', LData))
   .Accept('application/json')
   .Get;

  Result := LResponse.Content;
end;

end.
