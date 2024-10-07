program API_2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  providers.conecxaoDB in 'src\providers\providers.conecxaoDB.pas' {dmConecxao: TDataModule} ,
  services.aneometro in 'src\services\services.aneometro.pas' {services_aneometro: TDataModule} ,
  Controlers.aneometro in 'src\controlers\Controlers.Aneometro.pas';

begin
  THorse.Use(Jhonson());

  Controlers.aneometro.Registry;

  THorse.Listen(9000);

end.
