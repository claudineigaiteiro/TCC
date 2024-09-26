program Front;

uses
  Vcl.Forms,
  MenuPrincipal in 'MenuPrincipal.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
