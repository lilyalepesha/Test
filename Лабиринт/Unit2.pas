unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Samples.Gauges, Vcl.Imaging.jpeg, unit4,
  Vcl.ExtCtrls, Vcl.MPlayer;

type
  TForm2 = class(TForm)
    Image1: TImage;
    Gauge1: TGauge;
    TimerImage1: TTimer;
    procedure TimerImage1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
      var
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses unit3, unit1;
{$R *.dfm}
procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TForm2.TimerImage1Timer(Sender: TObject);
begin
Gauge1.Progress:=Gauge1.Progress+1;
if (Gauge1.Progress=100) then
begin
TimerImage1.Enabled:=False;
Form4.Show;
Form2.Hide;
end;
end;
end.
