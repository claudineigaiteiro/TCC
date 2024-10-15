unit Classe.Aneometro;

interface

type
  TAneometro = class
  private
  public
    function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
  end;

implementation

{ TAneometro }

uses
  RESTRequest4D, System.SysUtils, System.JSON;

function TAneometro.getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
const
  CUrl = 'http://localhost:9000/aneometros/%s/dia';
var
  LResponse: IResponse;
  LUrl: String;
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
