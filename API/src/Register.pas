unit Register;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Routers.Aneometro, Routers.Pluviometro;

procedure registers;

implementation

procedure registers;
Begin
  THorse.Use(CORS);
  THorse.Use(Jhonson());

  RoutersAneometro;
  RoutersPluviometro;

  THorse.Listen(9000);
End;

end.
