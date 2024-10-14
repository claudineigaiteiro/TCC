object FrmUnidades: TFrmUnidades
  Left = 0
  Top = 0
  Caption = 'Unidades'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object PgcUnidades: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    ActivePage = TsCadastroUnidades
    Align = alClient
    TabOrder = 0
    object TsListagemUnidades: TTabSheet
      Caption = 'Listagem'
      object PnlPesquisaUnidades: TPanel
        Left = 0
        Top = 0
        Width = 616
        Height = 97
        Align = alTop
        TabOrder = 0
        DesignSize = (
          616
          97)
        object LblFiltroPesquisa: TLabel
          Left = 104
          Top = 8
          Width = 36
          Height = 15
          Caption = 'Nome:'
        end
        object RgFiltroPesquisaUnidades: TRadioGroup
          Left = 8
          Top = 8
          Width = 81
          Height = 81
          ItemIndex = 0
          Items.Strings = (
            'Nome'
            'C'#243'digo')
          TabOrder = 0
          OnClick = RgFiltroPesquisaUnidadesClick
        end
        object Edit1: TEdit
          Left = 104
          Top = 29
          Width = 497
          Height = 23
          Anchors = [akLeft, akTop, akRight]
          TabOrder = 1
        end
        object BtnPesquisarUnidade: TButton
          Left = 526
          Top = 64
          Width = 75
          Height = 25
          Anchors = [akTop, akRight]
          Caption = 'Pesquisar'
          TabOrder = 2
          OnClick = BtnPesquisarUnidadeClick
        end
      end
      object dgUnidades: TDBGrid
        Left = 0
        Top = 97
        Width = 616
        Height = 314
        Align = alClient
        DataSource = dsUnidades
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -12
        TitleFont.Name = 'Segoe UI'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'CODIGO'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CHAVE'
            Visible = True
          end>
      end
    end
    object TsCadastroUnidades: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
      DesignSize = (
        616
        411)
      object LbUnidadeCadastroNome: TLabel
        Left = 16
        Top = 70
        Width = 36
        Height = 15
        Caption = 'Nome:'
      end
      object LbUnidadeCadastroChave: TLabel
        Left = 16
        Top = 126
        Width = 36
        Height = 15
        Caption = 'Chave:'
      end
      object LblCadastroCodigo: TLabel
        Left = 16
        Top = 16
        Width = 42
        Height = 15
        Caption = 'C'#243'digo:'
      end
      object edtCadastroNome: TDBEdit
        Left = 16
        Top = 88
        Width = 585
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        DataField = 'NOME'
        DataSource = dsUnidades
        TabOrder = 0
      end
      object edtCadastroChave: TDBEdit
        Left = 16
        Top = 142
        Width = 585
        Height = 23
        Anchors = [akLeft, akTop, akRight]
        DataField = 'CHAVE'
        DataSource = dsUnidades
        TabOrder = 1
      end
      object EdtCadastroCodigo: TDBEdit
        Left = 16
        Top = 35
        Width = 297
        Height = 23
        DataField = 'CODIGO'
        DataSource = dsUnidades
        TabOrder = 2
      end
    end
  end
  object dsUnidades: TDataSource
    DataSet = mtUnidades
    Left = 544
    Top = 216
  end
  object mtUnidades: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 528
    Top = 304
    object mtUnidadesID: TLargeintField
      FieldName = 'ID'
      ReadOnly = True
    end
    object mtUnidadesNOME: TStringField
      FieldName = 'NOME'
      Size = 100
    end
    object mtUnidadesCHAVE: TStringField
      FieldName = 'CHAVE'
      Size = 50
    end
    object mtUnidadesCODIGO: TStringField
      FieldName = 'CODIGO'
      Size = 10
    end
  end
end