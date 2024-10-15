unit View.Pluviometro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.FormBaseDemonstracao, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls;

type
  TPluviometro = class(TfrmBaseDesmonstracao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPluviometro: TPluviometro;

implementation

{$R *.dfm}

end.
