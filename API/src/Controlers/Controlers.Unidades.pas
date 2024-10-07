unit Controlers.Unidades;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Services.Unidades, System.JSON;

Function GetUnidades(Req: THorseRequest): TJSONArray;

implementation

Function GetUnidades(Req: THorseRequest): TJSONArray;
Begin
  THorse.Use(Jhonson());

  Result := Services.Unidades.getUnidade(Req.Body).ToJSONArray();
End;

end.
