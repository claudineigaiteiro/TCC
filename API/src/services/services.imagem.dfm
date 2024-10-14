inherited services_imagem: Tservices_imagem
  Height = 176
  Width = 286
  object qryImagem: TFDQuery
    Active = True
    Connection = fdConecxao
    SQL.Strings = (
      'SELECT * '
      '  FROM HISTORICO_IMAGENS')
    Left = 176
    Top = 24
    object qryImagemID: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'ID'
      Origin = 'ID'
      ReadOnly = True
    end
    object qryImagemIMAGEM: TBlobField
      FieldName = 'IMAGEM'
      Origin = 'IMAGEM'
    end
    object qryImagemID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
      Origin = 'ID_UNIDADE'
    end
    object qryImagemDATA: TSQLTimeStampField
      FieldName = 'DATA'
      Origin = '"DATA"'
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
    Left = 184
    Top = 104
    object qryUnidadeID: TIntegerField
      FieldName = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
  end
end
