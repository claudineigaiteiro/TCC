unit Services.Imagens;

interface

uses
  Conecxao_db.dmConecxao;

procedure postImagem(AJson: String);

implementation

uses
  System.Classes, System.SysUtils, System.JSON, Data.DB, Vcl.Imaging.jpeg;

procedure postImagem(AJson: String);
Const
  CSQL = 'INSERT INTO HISTORICO_IMAGENS (IMAGEM) VALUES (%s) ';
Var
  LObjeto: TJSONObject;
  LSQL, LImagem: String;
  LLista: TStringList;
  BinData: TBytes;
  MemoryStream: TMemoryStream;
Begin
  LObjeto := TJSONObject.Create;
  Try
    LObjeto := TJSONObject.ParseJSONValue(AJson) As TJSONObject;
    LImagem := LObjeto.Get('image').JsonValue.ToString;
    // LSQL := Format(CSQL, [LImagem]);

    LLista := TStringList.Create;
    Try
      LLista.Add(LSQL);
      // LLista.SaveToFile('D:\LogSQL\SaveSQL.png');
    Finally
      FreeAndNil(LLista);
    End;

    dmConecxao.FdqAneometro.SQL.Text :=
      'INSERT INTO HISTORICO_IMAGENS (IMAGEM) VALUES (:Imagem) ';

    SetLength(BinData, Length(LImagem) div 2);
    HexToBin(PChar(LImagem), PByte(BinData), Length(BinData));
    MemoryStream := TMemoryStream.Create;
    Try
      MemoryStream.WriteBuffer(BinData[0], Length(BinData));

      // Associa o parâmetro BLOB com o MemoryStream
      dmConecxao.FdqAneometro.ParamByName('Imagem')
        .LoadFromStream(MemoryStream, ftBlob);

      // Executa a query
      dmConecxao.FdqAneometro.ExecSQL;

    Finally
      FreeAndNil(MemoryStream);
    End;
    // dmConecxao.FdqAneometro.ExecSQL(LSQL);
  Finally
    FreeAndNil(LObjeto);
  End;
End;

end.
