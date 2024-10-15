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
    ExplicitTop = 408
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
  end
end
