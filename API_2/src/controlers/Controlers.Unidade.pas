unit Controlers.Unidade;

interface

procedure Registry;

implementation

uses Horse, services.unidade, System.JSON, DataSet.Serialize;

procedure SalvarUnidade(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_unidade;
begin
  LService := Tservices_unidade.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/unidades', SalvarUnidade);
end;

end.
