unit Controlers.Aneometro;

interface

procedure Registry;

implementation

uses Horse, services.Aneometro, System.JSON, DataSet.Serialize, System.SysUtils,
  System.Classes;

procedure SalvarAneometro(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_aneometro;
begin
  LService := Tservices_aneometro.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject())
      .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure ObterAneometroPeriodo(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_aneometro;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDate;
begin
  LService := Tservices_aneometro.Create(nil);
  try
    LIdUnidade := Req.Params.Items['id'].ToInt64;

    LJSON := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
    LAux := LJSON.Get('data_inicio').JsonValue.ToString;
    LAux := copy(LAux, 2, Length(LAux) - 2);
    LAux := StringReplace(LAux, '.', '/', [rfReplaceAll]);
    LDataInicio := StrToDate(LAux);

    LAux := LJSON.Get('data_fim').JsonValue.ToString;
    LAux := copy(LAux, 2, Length(LAux) - 2);
    LAux := StringReplace(LAux, '.', '/', [rfReplaceAll]);
    LDataFim := StrToDate(LAux);

    If LService.GetByPeriodo(LIdUnidade, LDataInicio, LDataFim).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetByPeriodo(LIdUnidade, LDataInicio, LDataFim)
      .ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/aneometros', SalvarAneometro);
  THorse.Get('/aneometros/:id/periodo', ObterAneometroPeriodo);
end;

end.
