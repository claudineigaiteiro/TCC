unit View.Imagem;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, Vcl.DBCtrls, Vcl.Mask, Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TImagem = class(TForm)
    PnlHeader: TPanel;
    LblDataInicio: TLabel;
    LblDataFim: TLabel;
    RgTipoBusca: TRadioGroup;
    BtnGerarDados: TButton;
    tpDataInicio: TDateTimePicker;
    tpDataFim: TDateTimePicker;
    pnlFooter: TPanel;
    DBImage1: TDBImage;
    mtImagens: TFDMemTable;
    dsImagens: TDataSource;
    mtImagensID: TIntegerField;
    mtImagensIMAGEM: TBlobField;
    mtImagensUNIDADE: TIntegerField;
    mtImagensDATA: TDateTimeField;
    BtnVoltar: TButton;
    Button2: TButton;
    lblContagem: TLabel;
    procedure BtnGerarDadosClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BtnVoltarClick(Sender: TObject);
  private
    FUnidade: TUnidade;
  public
    class function getLeituraDiaria(AIdUnidade: String; AData: TDate): String;

    property Unidade: TUnidade Write FUnidade;
  end;

var
  Imagem: TImagem;

implementation

{$R *.dfm}

uses RESTRequest4D, System.JSON, Charts.Types, DataSet.Serialize;

procedure TImagem.BtnGerarDadosClick(Sender: TObject);
var
  LJsonStream: TStringStream;
begin
  case RgTipoBusca.ItemIndex of
    0:
      begin
        LJsonStream := TStringStream.Create(getLeituraDiaria(FUnidade.ID,
          tpDataInicio.Date));
        Try
          mtImagens.Close;
          mtImagens.LoadFromJSON(LJsonStream.DataString);
          mtImagens.Open;
          lblContagem.Caption := IntToStr(mtImagens.RecNo) + '/' +
            IntToStr(mtImagens.RecordCount);
        Finally
          FreeAndNil(LJsonStream);
        End;
      end;
    1:
      begin

      end;
  end;
end;

procedure TImagem.BtnVoltarClick(Sender: TObject);
begin
  mtImagens.Prior;
  lblContagem.Caption := IntToStr(mtImagens.RecNo) + '/' +
    IntToStr(mtImagens.RecordCount);
end;

procedure TImagem.Button2Click(Sender: TObject);
begin
  mtImagens.Next;
  lblContagem.Caption := IntToStr(mtImagens.RecNo) + '/' +
    IntToStr(mtImagens.RecordCount);
end;

class function TImagem.getLeituraDiaria(AIdUnidade: String;
  AData: TDate): String;
const
  CUrl = 'http://localhost:9000/imagens/%s/dia';
var
  LResponse: IResponse;
  LUrl: String;
  LData: String;
begin
  LData := DateToStr(AData);
  LData := StringReplace(LData, '/', '.', [rfReplaceAll]);
  LUrl := Format(CUrl, [AIdUnidade]);
  LResponse := TRequest.New.BaseURL(LUrl)
    .AddBody(TJSONObject.Create.AddPair('data', LData))
    .Accept('application/json').Get;

  If LResponse.StatusCode = 200 then
    Result := LResponse.Content
  else
    ShowMessage('Registro não encontrado');
end;

end.
