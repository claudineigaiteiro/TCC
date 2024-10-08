unit Controlers.Imagem;

interface

procedure Registry;

implementation

uses Horse, services.imagem, System.JSON, DataSet.Serialize;

procedure SalvarImagem(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_imagem;
begin
  LService := Tservices_imagem.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/imagens', SalvarImagem);
end;

end.
