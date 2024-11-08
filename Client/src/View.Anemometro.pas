unit View.Anemometro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.FormBaseDemonstracao, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.ComCtrls;

type
  TAnemometro = class(TfrmBaseDesmonstracao)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Anemometro: TAnemometro;

implementation

{$R *.dfm}

end.
