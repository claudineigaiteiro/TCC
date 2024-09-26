unit Controlers.Pluviometro;

interface

uses

  Horse, Horse.Jhonson, Horse.CORS, services.pluviometro;

procedure postPluviometro(Req: THorseRequest);

implementation


procedure postPluviometro(Req: THorseRequest);
var
  // LJson: TJSONObject;
  LText: String;
begin
  // LJson := TJSONObject.Create;
  Try
    LText := Req.Body;
    services.pluviometro.postPluviometro(LText);
    // LJson := StrTo
  Finally
    // LJson.Free;
  End;

end;

end.
