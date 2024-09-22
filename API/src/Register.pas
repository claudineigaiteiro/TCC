unit Register;

interface

uses
  Horse, Horse.Jhonson, Horse.CORS, Routers.Aneometro;

procedure registers;

implementation

procedure registers;
Begin
  THorse.Use(CORS);
  THorse.Use(Jhonson());

  RoutersAneometro;

  THorse.Listen(9000);
End;

end.
