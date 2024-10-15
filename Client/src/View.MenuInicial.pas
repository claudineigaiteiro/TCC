unit View.MenuInicial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Classe.Unidade, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Menus;

type
  TFrmMenuInicial = class(TForm)
    PnlRodaPe: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    LblCodigoRodape: TLabel;
    LblUnidadeRodape: TLabel;
    memMenuPrincipal: TMainMenu;
    Arquivo1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AtualizarRodape;
  private
    FUnidade: TUnidade;
  public
    { Public declarations }
  end;

var
  FrmMenuInicial: TFrmMenuInicial;

implementation

{$R *.dfm}

uses
  View.Unidades, System.JSON;

procedure TFrmMenuInicial.AtualizarRodape;
begin
  LblCodigoRodape.Caption := FUnidade.CODIGO;
  LblUnidadeRodape.Caption := FUnidade.NOME;
end;

procedure TFrmMenuInicial.FormCreate(Sender: TObject);
begin
  FrmUnidades := TFrmUnidades.Create(nil);
  Try
    FrmUnidades.ShowModal;

    FUnidade := TUnidade.Create;
    FUnidade.ID := FrmUnidades.mtUnidades.FieldByName('ID').AsString;
    FUnidade.CODIGO := FrmUnidades.mtUnidades.FieldByName('CODIGO').AsString;
    FUnidade.NOME := FrmUnidades.mtUnidades.FieldByName('NOME').AsString;
    FUnidade.CHAVE := FrmUnidades.mtUnidades.FieldByName('CHAVE').AsString;

    AtualizarRodape;
  Finally
    FreeAndNil(FrmUnidades);
  End;
end;

procedure TFrmMenuInicial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FUnidade);
end;

end.
