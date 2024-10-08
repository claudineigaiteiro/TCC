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
  Controlers.Pluviometro in 'src\controlers\Controlers.Pluviometro.pas',
  services.imagem in 'src\services\services.imagem.pas' {services_imagem: TDataModule},
  Controlers.Imagem in 'src\controlers\Controlers.Imagem.pas';

begin
  THorse.Use(Jhonson());

  Controlers.aneometro.Registry;
  Controlers.Pluviometro.Registry;
  Controlers.Imagem.Registry;

  THorse.Listen(9000);

end.
