unit View.Anemometro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.FormBaseDemonstracao, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls;

type
  TAnemometro = class(TfrmBaseDesmonstracao)
  private
    { Private declarations }
  public
    class function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
  end;

var
  Anemometro: TAnemometro;

implementation

uses
  RESTRequest4D, System.JSON;

{$R *.dfm}

{ TAnemometro }

class function TAnemometro.getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
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
