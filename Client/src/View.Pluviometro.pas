unit View.Pluviometro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.FormBaseDemonstracao, Vcl.StdCtrls,
  Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls, System.Sensors, System.Sensors.Components;

type
  TPluviometro = class(TfrmBaseDesmonstracao)
  private
    { Private declarations }
  public
    class function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;
  end;

var
  Pluviometro: TPluviometro;

implementation

{$R *.dfm}
{ TPluviometro }

uses RESTRequest4D, System.JSON;

class function TPluviometro.getLeituraDiaria(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/pluviometros/%s/dia';
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
    .Accept('application/json').Get;

  Result := LResponse.Content;
end;

end.
