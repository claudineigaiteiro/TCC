unit Controlers.Imagem;

interface

procedure Registry;

implementation

uses Horse, services.Imagem, System.JSON, DataSet.Serialize, System.SysUtils;

procedure SalvarImagem(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_imagem;
begin
  LService := Tservices_imagem.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject())
      .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure ObterImagemPeriodo(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
var
  LService: Tservices_imagem;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDate;
begin
  LService := Tservices_imagem.Create(nil);
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

procedure ObterImagemDia(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_imagem;
  LIdUnidade: Int64;
  LAux: String;
  LJSON: TJSONObject;
  LDataInicio, LDataFim: TDateTime;
begin
  LService := Tservices_imagem.Create(nil);
  try
    LIdUnidade := Req.Params.Items['id'].ToInt64;

    LJSON := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
    LAux := LJSON.Get('data').JsonValue.ToString;
    LAux := copy(LAux, 2, Length(LAux) - 2);
    LAux := StringReplace(LAux, '.', '/', [rfReplaceAll]);
    LDataInicio := StrToDate(LAux);

    If LService.GetByDia(LIdUnidade, LDataInicio).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetByDia(LIdUnidade, LDataInicio)
      .ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/imagens', SalvarImagem);
  THorse.Get('/imagens/:id/periodo', ObterImagemPeriodo);
  THorse.Get('/imagens/:id/dia', ObterImagemDia);
end;

end.
