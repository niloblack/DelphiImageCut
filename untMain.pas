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

  dlgOpen.Filter := 'Arquivos JPG|*.jpg|Arquivos JPEG|.jpge|Arquivos Bitmap|*.bmp';
  if dlgOpen.Execute then
  begin
    FrmImageCut := TFrmImageCut.Create(Self);
    try
      FrmImageCut.ImageWidth   := 0; //500;
      FrmImageCut.ImageHeight  := 0; //250;
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
