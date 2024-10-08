program API_2;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  providers.conecxaoDB in 'src\providers\providers.conecxaoDB.pas' {dmConecxao: TDataModule},
  services.aneometro in 'src\services\services.aneometro.pas' {services_aneometro: TDataModule},
  Controlers.Aneometro in 'src\controlers\Controlers.Aneometro.pas',
  services.pluviometro in 'src\services\services.pluviometro.pas' {services_pluviometro: TDataModule},
  Controlers.Pluviometro in 'src\controlers\Controlers.Pluviometro.pas';

begin
  THorse.Use(Jhonson());

  Controlers.aneometro.Registry;
  Controlers.Pluviometro.Registry;

  THorse.Listen(9000);

end.
