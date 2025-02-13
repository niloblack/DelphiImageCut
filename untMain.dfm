object frmMain: TfrmMain
  Left = 0
  Top = 0
  ClientHeight = 409
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    635
    409)
  PixelsPerInch = 96
  TextHeight = 13
  object imgResult: TImage
    Left = 8
    Top = 39
    Width = 619
    Height = 362
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object btnLoadImage: TButton
    Left = 8
    Top = 8
    Width = 161
    Height = 25
    Caption = 'Load Image...'
    TabOrder = 0
    OnClick = btnLoadImageClick
  end
  object dlgOpen: TOpenDialog
    Left = 584
    Top = 8
  end
end
