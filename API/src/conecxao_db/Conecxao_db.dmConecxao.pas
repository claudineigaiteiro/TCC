unit Conecxao_db.dmConecxao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Phys.FBDef, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.FB, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.IBBase, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TdmConecxao = class(TDataModule)
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FdConecxao: TFDConnection;
    FdqAneometro: TFDQuery;
    FdqAneometroID: TIntegerField;
    FdqAneometroDATA_HORA: TSQLTimeStampField;
    FdqAneometroVELOCIDADE: TFMTBCDField;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dmConecxao: TdmConecxao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmConecxao }



end.
