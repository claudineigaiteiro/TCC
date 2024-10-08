inherited services_unidade: Tservices_unidade
  Width = 287
  object qryUnidade: TFDQuery
    Active = True
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT *'
      '  FROM UNIDADES')
    Left = 152
    Top = 24
    object qryUnidadeID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryUnidadeNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 100
    end
    object qryUnidadeCHAVE: TStringField
      FieldName = 'CHAVE'
      Origin = 'CHAVE'
      Size = 100
    end
  end
end
