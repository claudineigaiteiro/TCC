unit Controlers.Aneometro;

interface

procedure Registry;

implementation

uses Horse, services.Aneometro, System.JSON, DataSet.Serialize, System.SysUtils,
  System.Classes, System.DateUtils;

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

procedure ObterAneometroPeriodo(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
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

    Res.Send<TJSONArray>(LService.GetByPeriodo(LIdUnidade, LDataInicio,
      LDataFim).ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure ObterAneometroDia(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
var
  LService: Tservices_aneometro;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDateTime;
begin
  LService := Tservices_aneometro.Create(nil);
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

procedure ObterMediaDia(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_aneometro;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDateTime;
begin
  LService := Tservices_aneometro.Create(nil);
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

    If LService.GetMediaByDia(LIdUnidade, LDataInicio, LDataFim).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetMediaByDia(LIdUnidade, LDataInicio,
      LDataFim).ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure ObterMediaPeriodo(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
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

    If LService.GetMediaPeriodo(LIdUnidade, LDataInicio, LDataFim).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetMediaPeriodo(LIdUnidade, LDataInicio,
      LDataFim).ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/aneometros', SalvarAneometro);
  THorse.Get('/aneometros/:id/periodo', ObterAneometroPeriodo);
  THorse.Get('/aneometros/:id/dia', ObterAneometroDia);
  THorse.Get('/aneometros/:id/media/dia', ObterMediaDia);
  THorse.Get('/aneometros/:id/media/periodo', ObterMediaPeriodo);
end;

end.
