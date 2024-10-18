unit Controlers.Pluviometro;

interface

procedure Registry;

implementation

uses Horse, services.Pluviometro, System.JSON, DataSet.Serialize,
  System.SysUtils, System.DateUtils;

procedure SalvarAneometro(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_pluviometro;
begin
  LService := Tservices_pluviometro.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject())
      .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure ObterPluviometroPeriodo(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
var
  LService: Tservices_pluviometro;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDate;
begin
  LService := Tservices_pluviometro.Create(nil);
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

procedure ObterPluviometro(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_pluviometro;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDateTime;
begin
  LService := Tservices_pluviometro.Create(nil);
  try
    LIdUnidade := Req.Params.Items['id'].ToInt64;

    LJSON := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
    LAux := LJSON.Get('data').JsonValue.ToString;
    LAux := copy(LAux, 2, Length(LAux) - 2);
    LAux := StringReplace(LAux, '.', '/', [rfReplaceAll]);
    LDataInicio := StrToDate(LAux);
    LDataFim := LDataInicio;
    LDataInicio := LDataInicio + EncodeTime(0, 0, 0, 0);
    LDataFim := LDataFim + EncodeTime(23, 59, 0, 0);

    If LService.GetByDia(LIdUnidade, LDataInicio, LDataFim).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetByDia(LIdUnidade, LDataInicio, LDataFim)
      .ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure ObterMediaDia(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
var
  LService: Tservices_pluviometro;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDateTime;
begin
  LService := Tservices_pluviometro.Create(nil);
  try
    LIdUnidade := Req.Params.Items['id'].ToInt64;

    LJSON := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
    LAux := LJSON.Get('data').JsonValue.ToString;
    LAux := copy(LAux, 2, Length(LAux) - 2);
    LAux := StringReplace(LAux, '.', '/', [rfReplaceAll]);
    LDataInicio := StrToDate(LAux);
    LDataFim := IncDay(LDataInicio);
    LDataInicio := LDataInicio + EncodeTime(0, 0, 0, 0);
    LDataFim := LDataFim + EncodeTime(0, 0, 0, 0);

    If LService.GetMediaDia(LIdUnidade, LDataInicio, LDataFim).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetMediaDia(LIdUnidade, LDataInicio, LDataFim)
      .ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/pluviometros', SalvarAneometro);
  THorse.Get('/pluviometros/:id/periodo', ObterPluviometroPeriodo);
  THorse.Get('/pluviometros/:id/dia', ObterPluviometro);
  THorse.Get('/pluviometros/:id/media/dia', ObterMediaDia);
end;

end.
