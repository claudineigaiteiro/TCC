unit Controlers.Aneometro;

interface

procedure Registry;

implementation

uses Horse, services.Aneometro, System.JSON, DataSet.Serialize;

procedure SalvarAneometro(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_aneometro;
begin
  LService := Tservices_aneometro.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject()).Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/aneometros', SalvarAneometro);
end;

end.
