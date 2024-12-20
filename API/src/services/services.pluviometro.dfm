inherited services_pluviometro: Tservices_pluviometro
  Height = 335
  Width = 303
  object qryPluviometro: TFDQuery
    Active = True
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT *'
      '  FROM PLUVIOMETRO')
    Left = 168
    Top = 24
    object qryPluviometroID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryPluviometroMEDICAO: TFMTBCDField
      FieldName = 'MEDICAO'
      Origin = 'MEDICAO'
      Precision = 18
      Size = 2
    end
    object qryPluviometroID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
    end
    object qryPluviometroDATA_HORA: TSQLTimeStampField
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
      '       UNIDADES.ID'
      '  FROM UNIDADES')
    Left = 168
    Top = 96
  end
  object qryMedia: TFDQuery
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT'
      '    0 AS ID,'
      '    COALESCE(SUM(P.MEDICAO), 0)/24 AS MEDICAO_MEDIA'
      'FROM '
      '    PLUVIOMETRO P')
    Left = 168
    Top = 176
    object qryMediaID: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInKey]
      ReadOnly = True
    end
    object qryMediaMEDICAO_MEDIA: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'MEDICAO_MEDIA'
      Origin = 'MEDICAO_MEDIA'
      ProviderFlags = []
      ReadOnly = True
      Precision = 18
      Size = 2
    end
  end
  object qryTotal: TFDQuery
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT'
      '    0 AS ID,'
      '    COALESCE(SUM(P.MEDICAO), 0) AS MEDICAO_TOTAL'
      'FROM '
      '    PLUVIOMETRO P')
    Left = 168
    Top = 248
    object qryTotalID: TIntegerField
      AutoGenerateValue = arDefault
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInKey]
      ReadOnly = True
    end
    object qryTotalMEDICAO_TOTAL: TFMTBCDField
      AutoGenerateValue = arDefault
      FieldName = 'MEDICAO_TOTAL'
      Origin = 'MEDICAO_TOTAL'
      ProviderFlags = []
      ReadOnly = True
      Precision = 18
      Size = 2
    end
  end
end
