unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls, unit1,
  Vcl.Samples.Gauges, ShellAPI, Vcl.Menus, Vcl.OleCtrls, SHDocVw;

type
  TForm3 = class(TForm)
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    Image5: TImage;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure Image2Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image5Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation
{$R *.dfm}
uses unit6;


procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
end;

procedure TForm3.Image2Click(Sender: TObject);
begin
ShowMessage('Игра началась! Уровень первый');
Form1.Timer1.Enabled:=True;
Form1.Show;
Form3.Hide;
end;

procedure TForm3.Image3Click(Sender: TObject);
begin
  ShellExecute(0,PChar('Open'), PChar('Delphi.chm'), nil, nil, SW_SHOW);
end;

procedure TForm3.Image4Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm3.Image5Click(Sender: TObject);
begin
Form3.Hide;
Form6.Show;
end;

procedure TForm3.N2Click(Sender: TObject);
begin
   ShellExecute(0,PChar('Open'), PChar('Delphi.chm'), nil, nil, SW_SHOW);
end;

procedure TForm3.N3Click(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm3.N4Click(Sender: TObject);
begin
ShowMessage('Игра началась! Уровень первый');
Form1.Timer1.Enabled:=True;
Form1.Show;
Form3.Hide;
end;

end.
