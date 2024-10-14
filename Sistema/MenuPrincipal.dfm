object Form2: TForm2
  Left = 0
  Top = 0
  Caption = 'Form2'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    624
    441)
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 362
    Align = alCustom
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Panel1'
    TabOrder = 0
    object WebBrowser1: TWebBrowser
      Left = 1
      Top = 1
      Width = 622
      Height = 360
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = 2
      ControlData = {
        4C00000049400000352500000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126209000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object Button1: TButton
    Left = 549
    Top = 368
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=D:\Projetos\TCC\DB\ESTACAO_MET.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=iSO8859_1'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 304
    Top = 224
  end
  object FDQuery1: TFDQuery
    Active = True
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT PLUVIOMETRO.DATA_HORA,'
      '       PLUVIOMETRO.MEDICAO,'
      '       '#39'128,0,0'#39' AS RGB'
      '  FROM PLUVIOMETRO')
    Left = 432
    Top = 232
    object FDQuery1DATA_HORA: TSQLTimeStampField
      FieldName = 'DATA_HORA'
      Origin = 'DATA_HORA'
    end
    object FDQuery1MEDICAO: TFMTBCDField
      FieldName = 'MEDICAO'
      Origin = 'MEDICAO'
      Precision = 18
      Size = 2
    end
    object FDQuery1RGB: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'RGB'
      Origin = 'RGB'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 5
    end
  end
end
