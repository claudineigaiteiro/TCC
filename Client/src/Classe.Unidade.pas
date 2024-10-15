unit Classe.Unidade;

interface

type

  TUnidade = class
  private
    FCODIGO: String;
    FID: String;
    FNOME: String;
    FCHAVE: String;
    procedure SetCHAVE(const Value: String);
    procedure SetCODIGO(const Value: String);
    procedure SetID(const Value: String);
    procedure SetNOME(const Value: String);
  public
    property ID: String read FID write SetID;
    property CODIGO: String read FCODIGO write SetCODIGO;
    property NOME: String read FNOME write SetNOME;
    property CHAVE: String read FCHAVE write SetCHAVE;
  end;

implementation


{ TUnidade }

procedure TUnidade.SetCHAVE(const Value: String);
begin
  FCHAVE := Value;
end;

procedure TUnidade.SetCODIGO(const Value: String);
begin
  FCODIGO := Value;
end;

procedure TUnidade.SetID(const Value: String);
begin
  FID := Value;
end;

procedure TUnidade.SetNOME(const Value: String);
begin
  FNOME := Value;
end;

end.
