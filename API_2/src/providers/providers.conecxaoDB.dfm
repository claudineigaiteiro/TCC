object dmConecxao: TdmConecxao
  Height = 106
  Width = 146
  object fdConecxao: TFDConnection
    Params.Strings = (
      'Database=D:\Projetos\TCC\API\DB\ESTACAO_MET.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'CharacterSet=ISO8859_1'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Left = 48
    Top = 24
  end
end
