unit Visor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TFrmVisor = class(TForm)
    mmVisor: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmVisor: TFrmVisor;

implementation

{$R *.dfm}

end.
