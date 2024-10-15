program Client;

uses
  Vcl.Forms,
  View.MenuInicial in 'src\View.MenuInicial.pas' {FrmMenuInicial},
  View.Unidades in 'src\View.Unidades.pas' {FrmUnidades},
  Vcl.Themes,
  Vcl.Styles,
  Classe.Unidade in 'src\Classe.Unidade.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TFrmMenuInicial, FrmMenuInicial);
  Application.Run;
end.
