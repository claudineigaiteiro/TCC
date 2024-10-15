object frmBaseDesmonstracao: TfrmBaseDesmonstracao
  Left = 0
  Top = 0
  Caption = 'frmBaseDesmonstracao'
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
    object lblMedia: TLabel
      Left = 9
      Top = 7
      Width = 67
      Height = 15
      Caption = 'M'#233'dia/Hora:'
    end
    object LblTotal: TLabel
      Left = 153
      Top = 7
      Width = 28
      Height = 15
      Caption = 'Total:'
    end
    object edtMedia: TDBEdit
      Left = 9
      Top = 24
      Width = 121
      Height = 23
      TabOrder = 0
    end
    object edtTotal: TDBEdit
      Left = 153
      Top = 24
      Width = 121
      Height = 23
      TabOrder = 1
    end
  end
  object PnlBody: TPanel
    Left = 0
    Top = 73
    Width = 624
    Height = 311
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 232
    ExplicitTop = 224
    ExplicitWidth = 185
    ExplicitHeight = 41
  end
end
