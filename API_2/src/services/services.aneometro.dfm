inherited services_aneometro: Tservices_aneometro
  Width = 263
  object qryAneometro: TFDQuery
    Active = True
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT * '
      '  FROM ANEOMETRO')
    Left = 136
    Top = 24
    object qryAneometroID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryAneometroVELOCIDADE: TFMTBCDField
      FieldName = 'VELOCIDADE'
      Origin = 'VELOCIDADE'
      Precision = 18
      Size = 2
    end
    object qryAneometroID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
    end
  end
end
