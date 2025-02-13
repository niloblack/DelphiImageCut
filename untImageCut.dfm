object FrmImageCut: TFrmImageCut
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  ClientHeight = 740
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    525
    740)
  PixelsPerInch = 96
  TextHeight = 13
  object ImgOriginal: TImage
    Left = 0
    Top = 40
    Width = 525
    Height = 700
    Anchors = [akLeft, akTop, akRight, akBottom]
    Transparent = True
    OnMouseDown = ImgOriginalMouseDown
    OnMouseMove = ImgOriginalMouseMove
    OnMouseUp = ImgOriginalMouseUp
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 0
    Width = 525
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 16305873
    DoubleBuffered = True
    ParentBackground = False
    ParentDoubleBuffered = False
    TabOrder = 0
    DesignSize = (
      525
      40)
    object LblTitle: TLabel
      Left = 15
      Top = 9
      Width = 72
      Height = 19
      Caption = 'IMAGE CUT'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Roboto Cn'
      Font.Style = []
      ParentFont = False
    end
    object BtnClear: TButton
      Left = 309
      Top = 8
      Width = 100
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Clear Selection'
      TabOrder = 0
      OnClick = BtnClearClick
    end
    object BtnImport: TButton
      Left = 413
      Top = 8
      Width = 100
      Height = 25
      Cursor = crHandPoint
      Anchors = [akTop, akRight]
      Caption = 'Import'
      TabOrder = 1
      OnClick = BtnImportClick
    end
  end
end
