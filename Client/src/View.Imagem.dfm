object Imagem: TImagem
  Left = 0
  Top = 0
  Caption = 'Imagem'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object PnlHeader: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 73
    Align = alTop
    TabOrder = 0
    DesignSize = (
      624
      73)
    object LblDataInicio: TLabel
      Left = 104
      Top = 8
      Width = 27
      Height = 15
      Caption = 'Data:'
    end
    object LblDataFim: TLabel
      Left = 224
      Top = 8
      Width = 48
      Height = 15
      Caption = 'Data fim:'
      Visible = False
    end
    object RgTipoBusca: TRadioGroup
      Left = 9
      Top = 2
      Width = 81
      Height = 65
      ItemIndex = 0
      Items.Strings = (
        'Diario'
        'Per'#237'odo')
      TabOrder = 0
      OnClick = RgTipoBuscaClick
    end
    object BtnGerarDados: TButton
      Left = 534
      Top = 8
      Width = 75
      Height = 56
      Anchors = [akTop, akRight]
      Caption = 'Gerar'
      TabOrder = 1
      OnClick = BtnGerarDadosClick
    end
    object tpDataInicio: TDateTimePicker
      Left = 104
      Top = 29
      Width = 89
      Height = 23
      Date = 45580.000000000000000000
      Time = 0.790501585644960900
      TabOrder = 2
    end
    object tpDataFim: TDateTimePicker
      Left = 224
      Top = 29
      Width = 89
      Height = 23
      Date = 45580.000000000000000000
      Time = 0.790501585644960900
      TabOrder = 3
      Visible = False
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 384
    Width = 624
    Height = 57
    Align = alBottom
    TabOrder = 1
    DesignSize = (
      624
      57)
    object lblContagem: TLabel
      Left = 301
      Top = 21
      Width = 17
      Height = 15
      Anchors = [akTop]
      Caption = '0/0'
    end
    object BtnVoltar: TButton
      Left = 208
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop]
      Caption = '<<'
      TabOrder = 0
      OnClick = BtnVoltarClick
    end
    object Button2: TButton
      Left = 336
      Top = 16
      Width = 75
      Height = 25
      Anchors = [akTop]
      Caption = '>>'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object dbiImagens: TDBImage
    Left = 0
    Top = 73
    Width = 624
    Height = 311
    Align = alClient
    DataField = 'IMAGEM'
    DataSource = dsImagens
    TabOrder = 2
  end
  object mtImagens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 424
    Top = 96
    object mtImagensID: TIntegerField
      FieldName = 'ID'
    end
    object mtImagensIMAGEM: TBlobField
      FieldName = 'IMAGEM'
    end
    object mtImagensUNIDADE: TIntegerField
      FieldName = 'UNIDADE'
    end
    object mtImagensDATA: TDateTimeField
      FieldName = 'DATA'
    end
  end
  object dsImagens: TDataSource
    DataSet = mtImagens
    Left = 328
    Top = 96
  end
end
