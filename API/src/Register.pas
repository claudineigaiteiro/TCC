unit Register;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Routers.Aneometro, Routers.Pluviometro,
  Routers.Imagem;

procedure registers;

implementation

procedure registers;
Begin
  THorse.Use(CORS);
  THorse.Use(Jhonson());

  RoutersAneometro;
  RoutersPluviometro;
  RoutersImagens;

  THorse.Listen(9000);
End;

end.
