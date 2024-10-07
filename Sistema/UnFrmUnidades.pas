unit UnFrmUnidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls;

type
  TFrmUnidades = class(TForm)
    PgcUnidades: TPageControl;
    TsListagemUnidades: TTabSheet;
    TsCadastroUnidades: TTabSheet;
    PnlPesquisaUnidades: TPanel;
    RgFiltroPesquisaUnidades: TRadioGroup;
    LblFiltroPesquisa: TLabel;
    Edit1: TEdit;
    BtnPesquisarUnidade: TButton;
    procedure RgFiltroPesquisaUnidadesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUnidades: TFrmUnidades;

implementation

{$R *.dfm}

procedure TFrmUnidades.RgFiltroPesquisaUnidadesClick(Sender: TObject);
begin
  LblFiltroPesquisa.Caption := RgFiltroPesquisaUnidades.Items
    [RgFiltroPesquisaUnidades.ItemIndex] + ':';
end;

end.
