program Client;

uses
  Vcl.Forms,
  View.MenuInicial in 'src\View.MenuInicial.pas' {FrmMenuInicial},
  View.Unidades in 'src\View.Unidades.pas' {FrmUnidades},
  Vcl.Themes,
  Vcl.Styles,
  Classe.Aneometro in 'src\Classe.Aneometro.pas',
  View.FormBaseDemonstracao in 'src\View.FormBaseDemonstracao.pas' {frmBaseDesmonstracao},
  View.Pluviometro in 'src\View.Pluviometro.pas' {Pluviometro},
  Types in 'src\Types.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TFrmMenuInicial, FrmMenuInicial);
  Application.Run;
end.
