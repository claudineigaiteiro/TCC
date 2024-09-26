unit Controlers.Imagens;

interface

uses

  Horse, Horse.Jhonson, Horse.CORS, services.Imagens;

procedure postImagem(Req: THorseRequest);

implementation


procedure postImagem(Req: THorseRequest);
var
  // LJson: TJSONObject;
  LText: String;
begin
  // LJson := TJSONObject.Create;
  Try
    LText := Req.Body;
    services.Imagens.postImagem(LText);
    // LJson := StrTo
  Finally
    // LJson.Free;
  End;

end;

end.
