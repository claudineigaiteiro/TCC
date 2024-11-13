inherited Anemometro: TAnemometro
  Caption = 'Anem'#244'metro'
  TextHeight = 15
  inherited PnlHeader: TPanel
    inherited BtnGerarDados: TButton
      Top = 11
      OnClick = BtnGerarDadosClick
      ExplicitTop = 11
    end
  end
  inherited pnlFooter: TPanel
    inherited edtMedia: TDBEdit
      DataField = 'VELOCIDADE_MEDIA'
      DataSource = dsMedia
    end
  end
  inherited PnlBody: TPanel
    object wbGrafico: TWebBrowser
      Left = 1
      Top = 1
      Width = 622
      Height = 309
      Align = alClient
      TabOrder = 0
      ControlData = {
        4C00000049400000F01F00000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object mtGrafico: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 488
    Top = 128
    object mtGraficoID: TIntegerField
      FieldName = 'ID'
    end
    object mtGraficoVELOVIDADE: TCurrencyField
      FieldName = 'VELOCIDADE'
    end
    object mtGraficoIDUNIDADE: TIntegerField
      FieldName = 'IDUNIDADE'
    end
    object mtGraficoDATAHORA: TDateTimeField
      FieldName = 'DATA_HORA'
    end
  end
  object dsMedia: TDataSource
    DataSet = mtMedia
    Left = 480
    Top = 208
  end
  object mtMedia: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 552
    Top = 208
    object mtMediaVELOCIDADE_MEDIA: TFloatField
      FieldName = 'VELOCIDADE_MEDIA'
    end
  end
end
