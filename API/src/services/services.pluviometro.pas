unit services.pluviometro;

interface

uses
  Conecxao_db.dmConecxao;

procedure postPluviometro(AJson: String);

implementation

uses
  System.Classes, System.SysUtils, System.JSON;

procedure postPluviometro(AJson: String);
Const
  CSQL = 'INSERT INTO PLUVIOMETRO (MEDICAO) VALUES (%s) ';
Var
  LObjeto: TJSONObject;
  LSQL, LMedicao: String;
Begin
  LObjeto := TJSONObject.Create;
  Try
    LObjeto := TJSONObject.ParseJSONValue(AJson) As TJSONObject;
    LMedicao := LObjeto.Get('medicao').JsonValue.ToString;
    LSQL := Format(CSQL, [LMedicao]);

    dmConecxao.FdqAneometro.ExecSQL(LSQL);
  Finally
    FreeAndNil(LObjeto);
  End;
End;
end.
