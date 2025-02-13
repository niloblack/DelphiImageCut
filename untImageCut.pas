unit untImageCut;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Imaging.JPEG,
  Vcl.ExtCtrls, Vcl.Dialogs, System.UITypes;

type
  TFrmImageCut = class(TForm)
    pnlMenu: TPanel;
    LblTitle: TLabel;
    ImgOriginal: TImage;
    BtnClear: TButton;
    BtnImport: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImgOriginalMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImgOriginalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtnImportClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure ImgOriginalMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private
    { Private declarations }
    FImageHeight: Integer;
    FImageWidth: Integer;
    FOriginalPath: String;
    FStream: TMemoryStream;

    PathBackupResized: String;
    StartX: Integer;
    StartY: Integer;
    EndX:   Integer;
    EndY:   Integer;
    Selecting: Boolean;

    ImgBackup: TImage;
    ImgCropped: TImage;

    procedure LoadImage();
    procedure ResizeImage(Origem: String; Destino: String; Largura,
      Altura: Integer);
    procedure ImportClipping();
    procedure Translate();

  published
    { Published declarations }
    property ImageHeight: Integer read FImageHeight write FImageHeight;
    property ImageWidth: Integer read FImageWidth write FImageWidth;
    property OriginalPath: String read FOriginalPath write FOriginalPath;
    property Stream: TMemoryStream read FStream write FStream;

  public
    { Public declarations }
  end;

implementation

var
  Text_MsgErro: String = 'There was a problem, try again!';

{$R *.dfm}

function GetTmpDir():string;
var
  Pc : PChar;
begin
  Pc := StrAlloc(MAX_PATH + 1);
  GetTempPath(MAX_PATH, Pc);
  Result := string(Pc);
  StrDispose(Pc);
end;

procedure TFrmImageCut.FormCreate(Sender: TObject);
begin
  Self.ImageHeight  := 0;
  Self.ImageWidth   := 0;
  Self.OriginalPath := '';
  Self.Stream := TMemoryStream.Create;

  PathBackupResized := EmptyStr;
  Selecting := False;
  StartX := 0;
  StartY := 0;
  EndX   := 0;
  EndY   := 0;

  ImgBackup := TImage.Create(Self);
  ImgBackup.Height := ImgOriginal.Height;
  ImgBackup.Width  := ImgOriginal.Width;
  ImgBackup.Top    := ImgOriginal.Top;
  ImgBackup.Left   := Self.Width + 10;
  ImgBackup.Transparent := True;

  ImgCropped := TImage.Create(Self);
  ImgCropped.Height := 250;
  ImgCropped.Width  := 500;
  ImgCropped.Top    := ImgOriginal.Top;
  ImgCropped.Left   := Self.Width + 10;
  ImgCropped.Transparent := True;

  Translate();
end;

procedure TFrmImageCut.Translate();
begin
  case SysLocale.PriLangID of
    LANG_PORTUGUESE : //Português (Brazil)
      begin
        LblTitle.Caption  := 'RECORTAR IMAGEM';
        BtnClear.Caption  := 'Limpar Seleção';
        BtnImport.Caption := 'Importar';
        Text_MsgErro      := 'Ocorreu um erro, tente novamente!';
      end;

    LANG_SPANISH: //Espanhol
      begin
        LblTitle.Caption  := 'RECORTAR IMAGEN';
        BtnClear.Caption  := 'Borrar selección';
        BtnImport.Caption := 'Importar';
        Text_MsgErro      := 'Se produjo un error, ¡inténtalo de nuevo!';
      end;

    else
      begin
        LblTitle.Caption  := 'IMAGE CUT';
        BtnClear.Caption  := 'Clear Selection';
        BtnImport.Caption := 'Import';
      end;
  end;
end;

procedure TFrmImageCut.FormDestroy(Sender: TObject);
begin
  FreeAndNil(ImgCropped);
  FreeAndNil(ImgBackup);
  FreeAndNil(FStream);
end;

procedure TFrmImageCut.FormShow(Sender: TObject);
begin
  try
    LoadImage();
  except
    on E:Exception do
    begin
      MessageDlg(E.Message, mtError, [mbOk], 0);
      PostMessage(Handle, WM_CLOSE, 0, 0);
    end;
  end;
end;

procedure TFrmImageCut.ImgOriginalMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    StartX := X;
    StartY := Y;
    Selecting := True;
  end;
end;

procedure TFrmImageCut.ImgOriginalMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  TempBitmap: TBitmap;
  JpegImage: TJPEGImage;
begin
  if ssLeft in Shift then
  begin
    if (not Selecting) then
      Exit;

    TempBitmap := TBitmap.Create;
    JpegImage  := TJPEGImage.Create;
    try
      JpegImage.Assign(ImgBackup.Picture.Graphic);
      TempBitmap.Assign(JpegImage);

      TempBitmap.Canvas.Pen.Color := clRed;
      TempBitmap.Canvas.Pen.Width := 2;
      TempBitmap.Canvas.Brush.Style := bsClear;
      TempBitmap.Canvas.Rectangle(StartX, StartY, X, Y);

      ImgOriginal.Picture.Assign(TempBitmap);
    finally
      JpegImage.Free;
      TempBitmap.Free;
    end;
  end;
end;

procedure TFrmImageCut.ImgOriginalMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Selecting := False;
  EndX := X;
  EndY := Y;
end;

procedure TFrmImageCut.BtnImportClick(Sender: TObject);
begin
  if EndX = 0 then
    Exit;

  ImportClipping();
end;

procedure TFrmImageCut.BtnClearClick(Sender: TObject);
begin
  if PathBackupResized = EmptyStr then
    Exit;

  Selecting := False;
  StartX    := 0;
  StartY    := 0;
  EndX      := 0;
  EndY      := 0;

  ImgOriginal.Picture.LoadFromFile(PathBackupResized);
  ImgBackup.Picture.LoadFromFile(PathBackupResized);
end;

procedure TFrmImageCut.LoadImage();
var
  Extensao  : String;
  PathBackup : String;
begin
  Extensao  := ExtractFileExt(Self.OriginalPath);
  PathBackup := GetTmpDir() + 'Rec'+FormatDateTime('ddHHmmss', Now) + Extensao;

  if CopyFile(PWideChar(Self.OriginalPath), PWideChar(PathBackup), True) then
  begin
    PathBackupResized := GetTmpDir() + 'Red'+FormatDateTime('ddHHmmss', Now) + '.bmp';
    ResizeImage(PathBackup, PathBackupResized, ImgOriginal.Width, ImgOriginal.Height);

    ImgOriginal.Picture.LoadFromFile(PathBackupResized);
    ImgBackup.Picture.LoadFromFile(PathBackupResized);
  end
    else
    begin
      raise Exception.Create(Text_MsgErro);
    end
end;

procedure TFrmImageCut.ResizeImage(Origem: String; Destino: String; Largura: Integer; Altura: Integer);
var
  ImgOrigem, ImgRedimensionada: TBitmap;
  JpgOrigem: TJPEGImage;
begin
  JpgOrigem := TJPEGImage.Create;
  try
    ImgOrigem := TBitmap.Create;
    try
      ImgRedimensionada := TBitmap.Create;
      try
        JpgOrigem.LoadFromFile(Origem);
        ImgOrigem.Assign(JpgOrigem);

        ImgRedimensionada.SetSize(Largura, Altura);
        ImgRedimensionada.Canvas.StretchDraw(Rect(0, 0, Largura, Altura), ImgOrigem);

        ImgRedimensionada.SaveToFile(Destino);
      finally
        ImgRedimensionada.Free;
      end;
    finally
      ImgOrigem.Free;
    end;
  finally
    JpgOrigem.Free;
  end;
end;

procedure TFrmImageCut.ImportClipping();
var
  Bitmap, ResizedBitmap: TBitmap;
  DestRect: TRect;
begin
  Bitmap := TBitmap.Create;
  ResizedBitmap := TBitmap.Create;
  try
    Bitmap.Width := EndX - StartX;
    Bitmap.Height := EndY - StartY;
    Bitmap.Canvas.CopyRect(Rect(0, 0, Bitmap.Width, Bitmap.Height),
      ImgBackup.Picture.Bitmap.Canvas,
      Rect(StartX, StartY, EndX, EndY));

    if (ImageWidth > 0) And (ImageHeight > 0) then
    begin
      ResizedBitmap.Width := ImageWidth;
      ResizedBitmap.Height := ImageHeight;
      DestRect := Rect(0, 0, ImageWidth, ImageHeight);
      ResizedBitmap.Canvas.StretchDraw(DestRect, Bitmap);

      ImgCropped.Picture.Assign(ResizedBitmap);
    end
    else
      ImgCropped.Picture.Assign(Bitmap);
  finally
    Bitmap.Free;
    ResizedBitmap.Free;
  end;

  ImgCropped.Picture.Graphic.SaveToStream(Self.Stream);
  FStream.Position := 0;
  Self.ModalResult := mrOK;
end;

end.
