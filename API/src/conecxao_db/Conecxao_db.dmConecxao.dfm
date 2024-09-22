object dmConecxao: TdmConecxao
  Height = 480
  Width = 640
  object FDPhysFBDriverLink1: TFDPhysFBDriverLink
    VendorLib = 'C:\Program Files\Firebird\Firebird_3_0\WOW64\fbclient.dll'
    Left = 544
    Top = 408
  end
  object FdConecxao: TFDConnection
    Params.Strings = (
      'Database=D:\Projetos\TCC\API\DB\ESTACAO_MET.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=ISO8859_1'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 40
    Top = 16
  end
  object FdqAneometro: TFDQuery
    Active = True
    Connection = FdConecxao
    SQL.Strings = (
      'SELECT *'
      '  FROM ANEOMETRO')
    Left = 144
    Top = 16
    object FdqAneometroID: TIntegerField
      FieldName = 'ID'
      KeyFields = 'ID'
      Origin = 'ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object FdqAneometroDATA_HORA: TSQLTimeStampField
      FieldName = 'DATA_HORA'
      Origin = 'DATA_HORA'
    end
    object FdqAneometroVELOCIDADE: TFMTBCDField
      FieldName = 'VELOCIDADE'
      Origin = 'VELOCIDADE'
      Precision = 18
      Size = 2
    end
  end
end
