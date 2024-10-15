object FrmMenuInicial: TFrmMenuInicial
  Left = 0
  Top = 0
  Caption = 'FrmMenuInicial'
  ClientHeight = 360
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = memMenuPrincipal
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object PnlRodaPe: TPanel
    Left = 0
    Top = 327
    Width = 624
    Height = 33
    Align = alBottom
    TabOrder = 0
    DesignSize = (
      624
      33)
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 41
      Height = 15
      Caption = 'C'#243'digo:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 176
      Top = 8
      Width = 49
      Height = 15
      Caption = 'Unidade:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object LblCodigoRodape: TLabel
      Left = 55
      Top = 8
      Width = 3
      Height = 15
    end
    object LblUnidadeRodape: TLabel
      Left = 231
      Top = 8
      Width = 3
      Height = 15
    end
    object BtnRodapeUnidades: TButton
      Left = 540
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Unidades'
      TabOrder = 0
      OnClick = BtnRodapeUnidadesClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 327
    ActivePage = tbsPluviometro
    Align = alClient
    TabOrder = 1
    object tbsPluviometro: TTabSheet
      Caption = 'Pluvi'#244'metro'
      object PnlGraficoPluviometro: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 297
        Align = alClient
        TabOrder = 0
        object wbPluviometro: TWebBrowser
          Left = 1
          Top = 1
          Width = 614
          Height = 295
          Align = alClient
          TabOrder = 0
          ControlData = {
            4C000000753F00007D1E00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
    object tbsAneometro: TTabSheet
      Caption = 'Anem'#244'metro'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 297
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 216
        ExplicitTop = 128
        ExplicitWidth = 185
        ExplicitHeight = 41
        object wbAneometro: TWebBrowser
          Left = 1
          Top = 1
          Width = 614
          Height = 295
          Align = alClient
          TabOrder = 0
          ExplicitLeft = 280
          ExplicitTop = 136
          ExplicitWidth = 300
          ExplicitHeight = 150
          ControlData = {
            4C000000753F00007D1E00000000000000000000000000000000000000000000
            000000004C000000000000000000000001000000E0D057007335CF11AE690800
            2B2E126208000000000000004C0000000114020000000000C000000000000046
            8000000000000000000000000000000000000000000000000000000000000000
            00000000000000000100000000000000000000000000000000000000}
        end
      end
    end
  end
  object memMenuPrincipal: TMainMenu
    Left = 504
    Top = 224
    object Arquivo1: TMenuItem
      Caption = 'Arquivo'
      object miSair: TMenuItem
        Caption = 'Sair'
        OnClick = miSairClick
      end
    end
  end
  object mtGraficoPluviometro: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 504
    Top = 144
    object mtGraficoPluviometroID: TIntegerField
      FieldName = 'ID'
    end
    object mtGraficoPluviometroDATA_HORA: TDateTimeField
      FieldName = 'DATA_HORA'
    end
    object mtGraficoPluviometroMEDICAO: TCurrencyField
      FieldName = 'MEDICAO'
    end
    object mtGraficoPluviometroID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
  object mtGraficoAneometro: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 504
    Top = 64
    object mtGraficoAneometroID: TIntegerField
      FieldName = 'ID'
    end
    object mtGraficoAneometroDATA_HORA: TDateTimeField
      FieldName = 'DATA_HORA'
    end
    object mtGraficoAneometroVELOCIDADE: TCurrencyField
      FieldName = 'VELOCIDADE'
    end
    object mtGraficoAneometroID_UNIDADE: TIntegerField
      FieldName = 'ID_UNIDADE'
    end
  end
end
