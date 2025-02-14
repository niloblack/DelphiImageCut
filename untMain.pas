unit untMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TfrmMain = class(TForm)
    btnLoadImage: TButton;
    imgResult: TImage;
    dlgOpen: TOpenDialog;
    procedure btnLoadImageClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  untImageCut;

{$R *.dfm}

procedure TfrmMain.btnLoadImageClick(Sender: TObject);
var
  FrmImageCut : TFrmImageCut;
begin
  inherited;

  dlgOpen.Filter := 'Files JPG|*.jpg|Files JPEG|.jpge';
  if dlgOpen.Execute then
  begin
    FrmImageCut := TFrmImageCut.Create(Self);
    try
      FrmImageCut.FixedSelectionSize := True;
      FrmImageCut.SizeFixedX := 300;
      FrmImageCut.SizeFixedY := 150;
      FrmImageCut.ImageWidthResize   := 500; //Pass 0 to not resize
      FrmImageCut.ImageHeightResize  := 250; //Pass 0 to not resize
      FrmImageCut.OriginalPath := dlgOpen.FileName;
      if FrmImageCut.ShowModal = mrOk then
      begin
        if Assigned(FrmImageCut.Stream) then
        begin
          imgResult.Picture.LoadFromStream(FrmImageCut.Stream);
        end;
      end;
    finally
      FreeAndNil(FrmImageCut);
    end;
  end;
end;

end.
