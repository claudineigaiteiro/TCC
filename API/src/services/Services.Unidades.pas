unit Services.Unidades;

interface

uses
  Conecxao_db.dmConecxao, FireDAC.Comp.Client;

function getUnidade(ANome: String): TFDQuery;

implementation

uses
  System.JSON, System.SysUtils;

function getUnidade(ANome: String): TFDQuery;
const
  LSQL = 'SELECT * ' + #13 + '  FROM UNIDADES ' + #13 +
    ' WHERE UPPER(UNIDADES.NOME) CONTAINING '':nome'' ';
var
  I: Integer;
  LObjeto: TJSONObject;
  LNome: String;
Begin
  LObjeto := TJSONObject.ParseJSONValue(ANome) As TJSONObject;
  Try
    LNome := LObjeto.Get('nome').JsonValue.ToString;
    LNome := Copy(LNome, 2, Length(LNome) -1);
  Finally
    FreeAndNil(LObjeto);
  End;

  dmConecxao.FdqUnidade.Close;
  dmConecxao.FdqUnidade.SQL.Text := LSQL;
  dmConecxao.FdqUnidade.ParamByName('nome').AsString := ANome;
  dmConecxao.FdqUnidade.Open;

  Result := dmConecxao.FdqUnidade;
End;

end.
