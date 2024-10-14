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
  TextHeight = 15
  object PgcUnidades: TPageControl
    Left = 0
    Top = 0
    Width = 624
    Height = 441
    ActivePage = TsListagemUnidades
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
        end
      end
    end
    object TsCadastroUnidades: TTabSheet
      Caption = 'Cadastro'
      ImageIndex = 1
    end
  end
end
