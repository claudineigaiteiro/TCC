inherited services_pluviometro: Tservices_pluviometro
  Height = 181
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
end
