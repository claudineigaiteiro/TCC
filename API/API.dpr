program API;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.HandleException,
  providers.conecxaoDB
    in 'src\providers\providers.conecxaoDB.pas' {dmConecxao: TDataModule} ,
  services.aneometro
    in 'src\services\services.aneometro.pas' {services_aneometro: TDataModule} ,
  Controlers.aneometro in 'src\controlers\Controlers.Aneometro.pas',
  services.pluviometro
    in 'src\services\services.pluviometro.pas' {services_pluviometro: TDataModule} ,
  Controlers.pluviometro in 'src\controlers\Controlers.Pluviometro.pas',
  services.imagem
    in 'src\services\services.imagem.pas' {services_imagem: TDataModule} ,
  Controlers.imagem in 'src\controlers\Controlers.Imagem.pas',
  services.unidade
    in 'src\services\services.unidade.pas' {services_unidade: TDataModule} ,
  Controlers.unidade in 'src\controlers\Controlers.Unidade.pas';

begin
  THorse
    .Use(Jhonson())
    .Use(HandleException());


  Controlers.aneometro.Registry;
  Controlers.pluviometro.Registry;
  Controlers.imagem.Registry;
  Controlers.unidade.Registry;

  THorse.Listen(9000);

end.
