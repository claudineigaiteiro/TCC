unit Controlers.Aneometro;

interface

uses

  Horse, Horse.Jhonson, Horse.CORS, services.aneometro;

procedure postAneometro(Req: THorseRequest);

implementation


procedure postAneometro(Req: THorseRequest);
var
  // LJson: TJSONObject;
  LText: String;
begin
  // LJson := TJSONObject.Create;
  Try
    LText := Req.Body;
    services.aneometro.postAneometro(LText);
    // LJson := StrTo
  Finally
    // LJson.Free;
  End;

end;

end.
