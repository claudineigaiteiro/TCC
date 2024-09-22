unit Routers.Aneometro;

interface

uses
  Controlers.Aneometro, Horse, Horse.Jhonson, Horse.CORS;

procedure RoutersAneometro;

implementation

procedure RoutersAneometro;
begin

  THorse.Post('/aneometro', Controlers.Aneometro.postAneometro);

end;

end.
