unit View.MenuInicial;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TFrmMenuInicial = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMenuInicial: TFrmMenuInicial;

implementation

{$R *.dfm}

uses
  View.Unidades;

procedure TFrmMenuInicial.FormCreate(Sender: TObject);
begin
  FrmUnidades := TFrmUnidades.Create(nil);
  Try
    FrmUnidades.ShowModal;
  Finally
    FreeAndNil(FrmUnidades);
  End;
end;

end.
