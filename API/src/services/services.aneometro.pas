unit services.aneometro;

interface

uses
  Conecxao_db.dmConecxao;

procedure postAneometro(AJson: String);

implementation

uses
  System.Classes, System.SysUtils, System.JSON;

procedure postAneometro(AJson: String);
Const
  CSQL = 'INSERT INTO ANEOMETRO (VELOCIDADE) VALUES (%s) ';
Var
  LObjeto: TJSONObject;
  LSQL, LVelocidade: String;
  // LVelocidade: Double;
Begin
  LObjeto := TJSONObject.Create;
  Try
    LObjeto := TJSONObject.ParseJSONValue(AJson) As TJSONObject;
    LVelocidade := LObjeto.Get('speedwind_kph').JsonValue.ToString;
    LSQL := Format(CSQL, [LVelocidade]);

    dmConecxao.FdqAneometro.ExecSQL(LSQL);
  Finally
    FreeAndNil(LObjeto);
  End;
End;

end.
