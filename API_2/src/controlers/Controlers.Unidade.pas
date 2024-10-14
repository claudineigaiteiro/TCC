unit Controlers.Unidade;

interface

procedure Registry;

implementation

uses Horse, services.Unidade, System.JSON, DataSet.Serialize, System.SysUtils, Data.DB;

procedure SalvarUnidade(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_unidade;
begin
  LService := Tservices_unidade.Create(nil);
  try
    Res.Send<TJSONObject>(LService.Insert(Req.Body<TJSONObject>).ToJSONObject())
      .Status(THTTPStatus.Created);
  finally
    LService.Free;
  end;
end;

procedure ObterUnidadeNome(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
var
  LService: Tservices_unidade;
  LNome: String;
  LJSON: TJSONObject;
begin
  LService := Tservices_unidade.Create(nil);
  try
    LJSON := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
    LNome := LJSON.Get('nome').JsonValue.ToString;
    LNome := copy(LNome, 2, Length(LNome) - 2);

    If LService.GetByName(LNome).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetByName(LNome).ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure ObterUnidade(Req: THorseRequest; Res: THorseResponse; Proc: TProc);
var
  LService: Tservices_unidade;
begin
  LService := Tservices_unidade.Create(nil);
  try
    If LService.GetAll.IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetAll.ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure ObterUnidadeCodigo(Req: THorseRequest; Res: THorseResponse;
  Proc: TProc);
var
  LService: Tservices_unidade;
  LCodigo: String;
  LJSON: TJSONObject;
begin
  LService := Tservices_unidade.Create(nil);
  try
    LJSON := TJSONObject.ParseJSONValue(Req.Body) As TJSONObject;
    LCodigo := LJSON.Get('codigo').JsonValue.ToString;
    LCodigo := copy(LCodigo, 2, Length(LCodigo) - 2);

    If LService.GetByCodigo(LCodigo).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');

    Res.Send<TJSONArray>(LService.GetByCodigo(LCodigo).ToJSONArray());
  finally
    LService.Free;
  end;
end;

procedure DeletarUnidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdUnidade: Int64;
  LService: Tservices_unidade;
begin
  LService := Tservices_unidade.Create(nil);
  try
    LIdUnidade := Req.Params.Items['id'].ToInt64;
    if LService.GetById(LIdUnidade).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);

  finally
    LService.Free;
  end;
end;

procedure AlterarUnidade(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LIdUnidade: Int64;
  LService: Tservices_unidade;
begin
  LService := Tservices_unidade.Create(nil);
  try
    LIdUnidade := Req.Params.Items['id'].ToInt64;
    if LService.GetById(LIdUnidade).IsEmpty then
      raise EHorseException.New.Status(THTTPStatus.NotFound)
        .Error('Registro não encontrado');
    if LService.Delete then
      Res.Status(THTTPStatus.NoContent);

  finally
    LService.Free;
  end;
end;

procedure Registry;
begin
  THorse.Post('/unidades', SalvarUnidade);
  THorse.Get('/unidades', ObterUnidade);
  THorse.Get('/unidades/nome', ObterUnidadeNome);
  THorse.Get('/unidades/codigo', ObterUnidadeCodigo);
  THorse.Delete('/unidades/:id', DeletarUnidade);
  THorse.Put('/unidades/:id', AlterarUnidade);
end;

end.
