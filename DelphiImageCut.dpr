program DelphiImageCut;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {frmMain},
  untImageCut in 'untImageCut.pas' {FrmImageCut};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
