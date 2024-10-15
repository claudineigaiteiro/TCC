program Client;

uses
  Vcl.Forms,
  View.MenuInicial in 'src\View.MenuInicial.pas' {FrmMenuInicial},
  View.Unidades in 'src\View.Unidades.pas' {FrmUnidades},
  Vcl.Themes,
  Vcl.Styles,
  Classe.Unidade in 'src\Classe.Unidade.pas',
  Classe.Pluviometro in 'src\Classe.Pluviometro.pas',
  Classe.Aneometro in 'src\Classe.Aneometro.pas',
  View.FormBaseDemonstracao in 'src\View.FormBaseDemonstracao.pas' {frmBaseDesmonstracao};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TFrmMenuInicial, FrmMenuInicial);
  Application.CreateForm(TfrmBaseDesmonstracao, frmBaseDesmonstracao);
  Application.Run;
end.
