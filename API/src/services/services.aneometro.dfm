inherited services_aneometro: Tservices_aneometro
  Height = 290
  Width = 263
  object qryAneometro: TFDQuery
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT *'
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
    object qryAneometroDATA_HORA: TSQLTimeStampField
      FieldName = 'DATA_HORA'
      Origin = 'DATA_HORA'
      ReadOnly = True
    end
  end
  object qryUnidade: TFDQuery
    Active = True
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT FIRST 1'
      '       UNIDADES.ID '
      '  FROM UNIDADES')
    Left = 136
    Top = 96
  end
  object qryMedia: TFDQuery
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT'
      '    COALESCE(SUM(A.VELOCIDADE), 0)/24 AS VELOCIDADE_MEDIA'
      'FROM '
      '    ANEOMETRO A')
    Left = 136
    Top = 168
    object qryMediaID: TIntegerField
      FieldName = 'ID'
    end
    object qryMediaVELOCIDADE_MEDIA: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'VELOCIDADE_MEDIA'
      Origin = 'VELOCIDADE_MEDIA'
      ProviderFlags = []
      ReadOnly = True
      Precision = 18
      Size = 2
    end
  end
end
