unit View.Unidades;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFrmUnidades = class(TForm)
    PgcUnidades: TPageControl;
    TsListagemUnidades: TTabSheet;
    PnlPesquisaUnidades: TPanel;
    LblFiltroPesquisa: TLabel;
    RgFiltroPesquisaUnidades: TRadioGroup;
    Edit1: TEdit;
    BtnPesquisarUnidade: TButton;
    TsCadastroUnidades: TTabSheet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmUnidades: TFrmUnidades;

implementation

{$R *.dfm}

end.
