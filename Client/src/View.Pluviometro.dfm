inherited Pluviometro: TPluviometro
  Caption = 'Pluviometro'
  OnDestroy = FormDestroy
  TextHeight = 15
  inherited PnlHeader: TPanel
    inherited BtnGerarDados: TButton
      OnClick = BtnGerarDadosClick
    end
  end
  inherited PnlBody: TPanel
    ExplicitLeft = 0
    ExplicitTop = 73
    ExplicitWidth = 624
    ExplicitHeight = 311
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
    Left = 544
    Top = 152
    object mtGraficoID: TIntegerField
      FieldName = 'ID'
    end
    object mtGraficoMEDICAO: TCurrencyField
      FieldName = 'MEDICAO'
    end
    object mtGraficoID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
    object mtGraficoDATA_HORA: TDateTimeField
      FieldName = 'DATA_HORA'
    end
  end
  object mtMedia: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 544
    Top = 232
  end
end
