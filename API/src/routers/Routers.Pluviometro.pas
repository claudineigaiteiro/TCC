unit Routers.Pluviometro;

interface

uses
  Controlers.Pluviometro, Horse, Horse.Jhonson, Horse.CORS;

procedure RoutersPluviometro;

implementation

procedure RoutersPluviometro;
begin

  THorse.Post('/pluviometro', Controlers.Pluviometro.postPluviometro);

end;
end.
