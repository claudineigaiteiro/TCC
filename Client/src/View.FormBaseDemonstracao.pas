unit View.FormBaseDemonstracao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.WinXPickers, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls;

type
  TfrmBaseDesmonstracao = class(TForm)
    PnlHeader: TPanel;
    LblDataInicio: TLabel;
    RgTipoBusca: TRadioGroup;
    BtnGerarDados: TButton;
    tpDataInicio: TDateTimePicker;
    LblDataFim: TLabel;
    tpDataFim: TDateTimePicker;
    pnlFooter: TPanel;
    lblMedia: TLabel;
    edtMedia: TDBEdit;
    LblTotal: TLabel;
    edtTotal: TDBEdit;
    PnlBody: TPanel;
    procedure RgTipoBuscaClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBaseDesmonstracao: TfrmBaseDesmonstracao;

implementation

{$R *.dfm}

procedure TfrmBaseDesmonstracao.RgTipoBuscaClick(Sender: TObject);
begin
  case RgTipoBusca.ItemIndex of
    0:
      begin
        LblDataInicio.Caption := 'Data:';
        LblDataFim.Visible := False;
        tpDataFim.Visible := False;
        lblMedia.Caption := 'Média/Hora:';
      end;
    1:
      begin
        LblDataInicio.Caption := 'Data inicio:';
        LblDataFim.Visible := True;
        tpDataFim.Visible := True;
        lblMedia.Caption := 'Média/Dia:';
      end;
  end;
end;

end.
