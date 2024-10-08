unit Controlers.Pluviometro;

interface

procedure Registry;

implementation

uses Horse, services.pluviometro, System.JSON, DataSet.Serialize;

procedure SalvarAneometro(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_pluviometro;
begin
  LService := Tservices_pluviometro.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/pluviometros', SalvarAneometro);
end;

end.
