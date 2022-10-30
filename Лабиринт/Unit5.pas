unit Unit5;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TForm5 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    MaskEdit1: TMaskEdit;
    Image1: TImage;
    Image2: TImage;
    procedure Image2Click(Sender: TObject);
    procedure FormClose(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form5: TForm5;
  SaveTxt:TStringList;
  LoginUsr, PassUsr:string;
implementation
uses unit3, unit1;
{$R *.dfm}

procedure TForm5.FormClose(Sender: TObject);
begin
Application.Terminate;
end;

procedure TForm5.Image2Click(Sender: TObject);
begin
SaveTxt:=TStringList.Create;
SaveTxt.LoadFromFile(ExtractFilePath(Application.ExeName)+'RegEdit.txt');
if (Edit1.Text<>'') and (MaskEdit1.Text<>'') and (Length(MaskEdit1.Text)>=4) then
begin
  LoginUsr:=Edit1.Text;
  PassUsr:=MaskEdit1.Text;
  SaveTxt.Add(LoginUsr+' '+PassUsr);
  SaveTxt.SaveToFile(ExtractFilePath(Application.ExeName)+'RegEdit.txt');
  ShowMessage('�� ������� ����������������!');
  Form3.Show;
  Form5.Hide;
end
  else
  begin
  ShowMessage('������� ������ �����, �������� ������ ���� ������ 3 ��������');
  Edit1.Clear;
  MaskEdit1.Clear;
  end;
end;
end.
