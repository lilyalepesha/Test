unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.MPlayer, unit2, unit4;

type
  TKn = record
  X,Y,HP,Rotate,Anim,Score,Level,Time, Speed:Integer;
  end;
  TGhost = record
  X,Y,Rotate:Integer;
  Visible, Angry:Boolean;
  end;
  TForm1 = class(TForm)
    Timer1: TTimer;
    MediaPlayer1: TMediaPlayer;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  path:String;
  map:array[0..27, 0..32] of integer;
  Buf, Wall, Wall2, Bg, Wall3, freeze:TBitmap;
  i,j:integer;
  Power:array[1..13] of TBitmap;
  Kn:array[1..4, 1..3] of TBitmap;
  Gh:array[0..3] of TGhost;
  Ghosts:array[0..3, 1..5] of TBitmap;
  Knight:TKn;
  procedure lvl2;
  procedure lvl3;
implementation
uses unit5;
{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Application.Terminate;
MediaPlayer1.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  path:=extractFileDir(Application.ExeName);//��������� ���� � �����
  MediaPlayer1.FileName:= (path+'\img\pixel.mp3');
  MediaPlayer1.Open;
  MediaPlayer1.AutoRewind := True;
  MediaPlayer1.Play;
  //�������� ������
  Buf:=TBitmap.Create;
  Buf.Width:=672;
  Buf.Height:=792;
  //���
  Bg:=TBitmap.Create;
  Bg.Transparent:=True;
  Bg.LoadFromFile(path+'\img\bg.bmp');
  Wall3:=TBitmap.Create;
  Wall3.LoadFromFile(path+'\img\wall3.bmp');
  //�������� �����
  Wall:=TBitmap.Create;
  Wall.LoadFromFile(path+'\img\wall.bmp');
  //��������� �����
  freeze:=TBitmap.Create;
  freeze.LoadFromFile(path+'\img\wall4.bmp');
  //����� ������� ������
  Wall2:=TBitmap.Create;
  Wall2.LoadFromFile(path+'\img\wall2.bmp');
  //�������� ���� ����� ����
  for i := 1 to 13 do
  begin
    Power[i]:=TBitmap.Create;
    Power[i].LoadFromFile(path+'\img\'+inttostr(i)+'.bmp');
    Power[i].Transparent:=True;
  end;
  for i := 1 to 4 do
  for j := 1 to 3 do
  begin
    Kn[i,j]:=TBitmap.Create;
    Kn[i,j].Transparent:=True;
    Kn[i,j].LoadFromFile(path+'\img\k'+inttostr(i)+inttostr(j)+'.bmp');
  end;
  for i := 0 to 3 do
  for j := 1 to 5 do
  begin
    Ghosts[i,j]:=TBitmap.Create;
    Ghosts[i,j].Transparent:=True;
    Ghosts[i,j].LoadFromFile(path+'\img\p'+inttostr(i)+inttostr(j)+'.bmp');
  end;
  //������
  Knight.X:=13;
  Knight.Y:=25;
  Knight.HP:=2;
  Knight.Rotate:=1;
  Knight.Anim:=1;
  Knight.Score:=0;
  Knight.Level:=1;
  Knight.Time:=-1;
  Knight.Speed:=Timer1.Interval;
  //��������
  for i := 0 to 3 do
  begin
  Gh[i].Rotate:=2;
  Gh[i].Visible:=True;
  Gh[i].Angry:=True;
  end;
  Gh[0].X:=11;
  Gh[0].Y:=11;
  Gh[1].X:=12;
  Gh[1].Y:=11;
  Gh[2].X:=15;
  Gh[2].Y:=11;
  Gh[3].X:=16;
  Gh[3].Y:=11;
  begin
  //��������� ���� ����� 0
  for i := 0 to 27 do
  for j := 0 to 32 do
  map[i,j]:=0;
  //�������� ������� ������(������� ����� � ������)
  for i := 0 to 27 do
  begin
  //������� �����������
  map[i,0]:=-1;
  //������ �����������
  map[i,32]:=-1;
  end;
  for j := 0 to 9 do
  begin
  //������� ����������
  map[0,j]:=-1;
  map[27,j]:=-1;
  end;
  for j := 0 to 11 do
  begin
  //������ ����������
  map[0,32-j]:=-1;
  map[27,32-j]:=-1;
  end;
  for i := 0 to 5 do
  begin
  //����� �� �����������
  map[i,9]:=-1;
  map[27-i,9]:=-1;
  map[i,14]:=-1;
  map[27-i,14]:=-1;

  map[i,21]:=-1;
  map[27-i,21]:=-1;
  map[i,16]:=-1;
  map[27-i,16]:=-1;
  end;
  for j := 0 to 5 do
  begin
  //������� ���������
    map[5,j+9]:=-1;
    map[22,j+9]:=-1;

    map[5,j+16]:=-1;
    map[22,j+16]:=-1;

    map[7,j+16]:=-1;
    map[8,j+16]:=-1;
    map[20,j+16]:=-1;
    map[19,j+16]:=-1;
  end;
  //
  //��������� �����
  for i:=0 to 1 do
  for j:=1 to 4 do
  map[i+13,j]:=-1;
  //����� � ������ �������(���������)
  for i := 0 to 3 do
  for j := 0 to 2 do
  begin
  map[i+2,j+2]:=-1;
  map[25-i,j+2]:=-1;
  end;
  //�������� �������
  for i := 0 to 4 do
  for j := 0 to 2 do
  begin
  map[i+7,j+2]:=-1;
  map[20-i,j+2]:=-1;
  end;
  //�������� ������
  for i := 0 to 3 do
  for j := 0 to 1 do
  begin
  map[i+2,j+6]:=-1;
  map[25-i,j+6]:=-1;
  end;
  //��������
  for j := 0 to 8 do
  for i := 0 to 1 do
  begin
  map[i+7,j+6]:=-1;
  map[i+19,j+6]:=-1;
  end;
  for i := 0 to 2 do
  for j := 0 to 1 do
  begin
  map[i+9,j+9]:=-1;
  map[18-i,j+9]:=-1;
  end;
  //������� ����� �� ������
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,j+6]:=-1;
  end;
  //������ �����
  for i := 0 to 9 do
  for j := 0 to 1 do
  begin
    map[i+2,30-j]:=-1;
    map[25-i,30-j]:=-1;
  end;
  //��������� ����� �
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+7,28-j]:=-1;
    map[20-i,28-j]:=-1;
  end;
  //����� �
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,21-j]:=-1;
    map[i+10,27-j]:=-1;
  end;
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+13,24-j]:=-1;
    map[i+13,30-j]:=-1;
  end;
  //������� ����� �� 1 �����
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+1,j+26]:=-1;
    map[26-i,j+26]:=-1;
  end;
  //����� �
  for i := 0 to 1 do
  for j := 0 to 4 do
  begin
    map[i+4,j+23]:=-1;
    map[23-i,j+23]:=-1;
  end;
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+2,j+23]:=-1;
    map[25-i,j+23]:=-1;
  end;
  //������ ����� �� �����������
  for i := 0 to 4 do
  for j := 0 to 1 do
  begin
    map[i+7,j+23]:=-1;
    map[20-i,j+23]:=-1;
  end;
  //�����
  for i := 0 to 7 do
  begin
    map[i+10,j+16]:=-1;
  end;
  //������� ����� ������
  for j := 0 to 4 do
  begin
    map[10,j+13]:=-1;
    map[17,j+13]:=-1;
  end;
  //����� ������
  for i := 0 to 2 do
  begin
    map[i+10,12]:=-1;
    map[i+15,12]:=-1;
  end;
  //���� ����
  for i := 0 to 27 do
  for j := 0 to 32 do
  if map[i,j]=0 then map[i,j]:=1;
  //�������� �����
  for i := 7 to 20 do
  for j := 9 to 21 do
  if map[i,j]>0 then map[i,j]:=0;
  for i := 0 to 5 do
  for j := 9 to 21 do
  begin
  if map[i,j]>0 then map[i,j]:=0;
  if map[27-i,j]>0 then map[27-i,j]:=0;
  end;
  //���� ����
  map[1,3]:=3;
  map[26,3]:=2;
  map[13,8]:=4;
  map[26,25]:=3;
  map[26,25]:=3;
  map[6,18]:=5;
  map[13,31]:=7;
  map[21,15]:=7;
  map[21,18]:=3;
  map[9,5]:=2;
  end;
end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Up then Knight.Rotate:=2;  //�����
  if Key = VK_Down then Knight.Rotate:=1; //����
  if Key = VK_Left then Knight.Rotate:=3; //�����
  if Key = VK_Right then Knight.Rotate:=4; //������
end;
//������� 2
  procedure lvl2;
  begin
  //�������� ������� ������(������� ����� � ������)
  for i := 0 to 27 do
  begin
  //������� �����������
  map[i,0]:=-2;
  //������ �����������
  map[i,32]:=-2;
  end;
  for j := 0 to 9 do
  begin
  //������� ����������
  map[0,j]:=-2;
  map[27,j]:=-2;
  end;
  for j := 0 to 11 do
  begin
  //������ ����������
  map[0,32-j]:=-2;
  map[27,32-j]:=-2;
  end;
  for i := 0 to 5 do
  begin
  //����� �� �����������
  map[i,9]:=-2;
  map[27-i,9]:=-2;
  map[i,14]:=-2;
  map[27-i,14]:=-2;

  map[i,21]:=-2;
  map[27-i,21]:=-2;
  map[i,16]:=-2;
  map[27-i,16]:=-2;
  end;
  for j := 0 to 5 do
  begin
  //������� ���������
    map[5,j+9]:=-2;
    map[22,j+9]:=-2;

    map[5,j+16]:=-2;
    map[22,j+16]:=-2;

    map[7,j+16]:=-2;
    map[8,j+16]:=-2;
    map[20,j+16]:=-2;
    map[19,j+16]:=-2;
  end;
  //
  //��������� �����
  for i:=0 to 1 do
  for j:=1 to 4 do
  map[i+13,j]:=-2;
  //����� � ������ �������(���������)
  for i := 0 to 3 do
  for j := 0 to 2 do
  begin
  map[i+2,j+2]:=-2;
  map[25-i,j+2]:=-2;
  end;
  //�������� �������
  for i := 0 to 4 do
  for j := 0 to 2 do
  begin
  map[i+7,j+2]:=-2;
  map[20-i,j+2]:=-2;
  end;
  //�������� ������
  for i := 0 to 3 do
  for j := 0 to 1 do
  begin
  map[i+2,j+6]:=-2;
  map[25-i,j+6]:=-2;
  end;
  //��������
  for j := 0 to 8 do
  for i := 0 to 1 do
  begin
  map[i+7,j+6]:=-2;
  map[i+19,j+6]:=-2;
  end;
  for i := 0 to 2 do
  for j := 0 to 1 do
  begin
  map[i+9,j+9]:=-2;
  map[18-i,j+9]:=-2;
  end;
  //������� ����� �� ������
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,j+6]:=-2;
  end;
  //������ �����
  for i := 0 to 9 do
  for j := 0 to 1 do
  begin
    map[i+2,30-j]:=-2;
    map[25-i,30-j]:=-2;
  end;
  //��������� ����� �
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+7,28-j]:=-2;
    map[20-i,28-j]:=-2;
  end;
  //����� �
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,21-j]:=-2;
    map[i+10,27-j]:=-2;
  end;
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+13,24-j]:=-2;
    map[i+13,30-j]:=-2;
  end;
  //������� ����� �� 1 �����
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+1,j+26]:=-2;
    map[26-i,j+26]:=-2;
  end;
  //����� �
  for i := 0 to 1 do
  for j := 0 to 4 do
  begin
    map[i+4,j+23]:=-2;
    map[23-i,j+23]:=-2;
  end;
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+2,j+23]:=-2;
    map[25-i,j+23]:=-2;
  end;
  //������ ����� �� �����������
  for i := 0 to 4 do
  for j := 0 to 1 do
  begin
    map[i+7,j+23]:=-2;
    map[20-i,j+23]:=-2;
  end;
  //�����
  for i := 0 to 7 do
  begin
    map[i+10,j+16]:=-2;
  end;
  //������� ����� ������
  for j := 0 to 4 do
  begin
    map[10,j+13]:=-2;
    map[17,j+13]:=-2;
  end;
  //����� ������
  for i := 0 to 2 do
  begin
    map[i+10,12]:=-2;
    map[i+15,12]:=-2;
  end;
  //���� ����
  for i := 0 to 27 do
  for j := 0 to 32 do
  if map[i,j]=0 then map[i,j]:=6;
  //�������� �����
  for i := 7 to 20 do
  for j := 9 to 21 do
  if map[i,j]>0 then map[i,j]:=0;
  for i := 0 to 5 do
  for j := 9 to 21 do
  begin
  if map[i,j]>0 then map[i,j]:=0;
  if map[27-i,j]>0 then map[27-i,j]:=0;
  end;
  map[1,3]:=2;
  map[26,3]:=5;
  map[13,8]:=7;
  map[26,25]:=8;
  map[26,25]:=3;
  map[6,18]:=13;
  map[13,31]:=7;
  map[21,18]:=9;
  end;
//������� 3
  procedure lvl3;
  begin
  //�������� ������� ������(������� ����� � ������)
  for i := 0 to 27 do
  begin
  //������� �����������
  map[i,0]:=-3;
  //������ �����������
  map[i,32]:=-3;
  end;
  for j := 0 to 9 do
  begin
  //������� ����������
  map[0,j]:=-3;
  map[27,j]:=-3;
  end;
  for j := 0 to 11 do
  begin
  //������ ����������
  map[0,32-j]:=-3;
  map[27,32-j]:=-3;
  end;
  for i := 0 to 5 do
  begin
  //����� �� �����������
  map[i,9]:=-3;
  map[27-i,9]:=-3;
  map[i,14]:=-3;
  map[27-i,14]:=-3;

  map[i,21]:=-3;
  map[27-i,21]:=-3;
  map[i,16]:=-3;
  map[27-i,16]:=-3;
  end;
  for j := 0 to 5 do
  begin
  //������� ���������
    map[5,j+9]:=-3;
    map[22,j+9]:=-3;

    map[5,j+16]:=-3;
    map[22,j+16]:=-3;

    map[7,j+16]:=-3;
    map[8,j+16]:=-3;
    map[20,j+16]:=-3;
    map[19,j+16]:=-3;
  end;
  //
  //��������� �����
  for i:=0 to 1 do
  for j:=1 to 4 do
  map[i+13,j]:=-3;
  //����� � ������ �������(���������)
  for i := 0 to 3 do
  for j := 0 to 2 do
  begin
  map[i+2,j+2]:=-3;
  map[25-i,j+2]:=-3;
  end;
  //�������� �������
  for i := 0 to 4 do
  for j := 0 to 2 do
  begin
  map[i+7,j+2]:=-3;
  map[20-i,j+2]:=-3;
  end;
  //�������� ������
  for i := 0 to 3 do
  for j := 0 to 1 do
  begin
  map[i+2,j+6]:=-3;
  map[25-i,j+6]:=-3;
  end;
  //��������
  for j := 0 to 8 do
  for i := 0 to 1 do
  begin
  map[i+7,j+6]:=-3;
  map[i+19,j+6]:=-3;
  end;
  for i := 0 to 2 do
  for j := 0 to 1 do
  begin
  map[i+9,j+9]:=-3;
  map[18-i,j+9]:=-3;
  end;
  //������� ����� �� ������
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,j+6]:=-3;
  end;
  //������ �����
  for i := 0 to 9 do
  for j := 0 to 1 do
  begin
    map[i+2,30-j]:=-3;
    map[25-i,30-j]:=-3;
  end;
  //��������� ����� �
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+7,28-j]:=-3;
    map[20-i,28-j]:=-3;
  end;
  //����� �
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,21-j]:=-3;
    map[i+10,27-j]:=-3;
  end;
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+13,24-j]:=-3;
    map[i+13,30-j]:=-3;
  end;
  //������� ����� �� 1 �����
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+1,j+26]:=-3;
    map[26-i,j+26]:=-3;
  end;
  //����� �
  for i := 0 to 1 do
  for j := 0 to 4 do
  begin
    map[i+4,j+23]:=-3;
    map[23-i,j+23]:=-3;
  end;
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+2,j+23]:=-3;
    map[25-i,j+23]:=-3;
  end;
  //������ ����� �� �����������
  for i := 0 to 4 do
  for j := 0 to 1 do
  begin
    map[i+7,j+23]:=-3;
    map[20-i,j+23]:=-3;
  end;
  //�����
  for i := 0 to 7 do
  begin
    map[i+10,j+16]:=-3;
  end;
  //������� ����� ������
  for j := 0 to 4 do
  begin
    map[10,j+13]:=-3;
    map[17,j+13]:=-3;
  end;
  //����� ������
  for i := 0 to 2 do
  begin
    map[i+10,12]:=-3;
    map[i+15,12]:=-3;
  end;
  //���� ����
  for i := 0 to 27 do
  for j := 0 to 32 do
  if map[i,j]=0 then map[i,j]:=10;
  //�������� �����
  for i := 7 to 20 do
  for j := 9 to 21 do
  if map[i,j]>0 then map[i,j]:=0;
  for i := 0 to 5 do
  for j := 9 to 21 do
  begin
  if map[i,j]>0 then map[i,j]:=0;
  if map[27-i,j]>0 then map[27-i,j]:=0;
  end;
  map[1,3]:=4;
  map[26,3]:=5;
  map[13,8]:=8;
  map[26,25]:=2;
  map[26,25]:=3;
  map[6,18]:=4;
  map[13,31]:=9;
  map[21,18]:=13;
  map[6,13]:=11;
  end;
//����� ��������� �����
  procedure chcolor;
  begin
  for i := 0 to 27 do
  begin
  //������� �����������
  map[i,0]:=-4;
  //������ �����������
  map[i,32]:=-4;
  end;
  for j := 0 to 9 do
  begin
  //������� ����������
  map[0,j]:=-4;
  map[27,j]:=-4;
  end;
  for j := 0 to 11 do
  begin
  //������ ����������
  map[0,32-j]:=-4;
  map[27,32-j]:=-4;
  end;
  for i := 0 to 5 do
  begin
  //����� �� �����������
  map[i,9]:=-4;
  map[27-i,9]:=-4;
  map[i,14]:=-4;
  map[27-i,14]:=-4;

  map[i,21]:=-4;
  map[27-i,21]:=-4;
  map[i,16]:=-4;
  map[27-i,16]:=-4;
  end;
  for j := 0 to 5 do
  begin
  //������� ���������
    map[5,j+9]:=-4;
    map[22,j+9]:=-4;

    map[5,j+16]:=-4;
    map[22,j+16]:=-4;

    map[7,j+16]:=-4;
    map[8,j+16]:=-4;
    map[20,j+16]:=-4;
    map[19,j+16]:=-4;
  end;
  //
  //��������� �����
  for i:=0 to 1 do
  for j:=1 to 4 do
  map[i+13,j]:=-4;
  //����� � ������ �������(���������)
  for i := 0 to 3 do
  for j := 0 to 2 do
  begin
  map[i+2,j+2]:=-4;
  map[25-i,j+2]:=-4;
  end;
  //�������� �������
  for i := 0 to 4 do
  for j := 0 to 2 do
  begin
  map[i+7,j+2]:=-4;
  map[20-i,j+2]:=-4;
  end;
  //�������� ������
  for i := 0 to 3 do
  for j := 0 to 1 do
  begin
  map[i+2,j+6]:=-4;
  map[25-i,j+6]:=-4;
  end;
  //��������
  for j := 0 to 8 do
  for i := 0 to 1 do
  begin
  map[i+7,j+6]:=-4;
  map[i+19,j+6]:=-4;
  end;
  for i := 0 to 2 do
  for j := 0 to 1 do
  begin
  map[i+9,j+9]:=-4;
  map[18-i,j+9]:=-4;
  end;
  //������� ����� �� ������
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,j+6]:=-4;
  end;
  //������ �����
  for i := 0 to 9 do
  for j := 0 to 1 do
  begin
    map[i+2,30-j]:=-4;
    map[25-i,30-j]:=-4;
  end;
  //��������� ����� �
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+7,28-j]:=-4;
    map[20-i,28-j]:=-4;
  end;
  //����� �
  for i := 0 to 7 do
  for j := 0 to 1 do
  begin
    map[i+10,21-j]:=-4;
    map[i+10,27-j]:=-4;
  end;
  for i := 0 to 1 do
  for j := 0 to 2 do
  begin
    map[i+13,24-j]:=-4;
    map[i+13,30-j]:=-4;
  end;
  //������� ����� �� 1 �����
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+1,j+26]:=-4;
    map[26-i,j+26]:=-4;
  end;
  //����� �
  for i := 0 to 1 do
  for j := 0 to 4 do
  begin
    map[i+4,j+23]:=-4;
    map[23-i,j+23]:=-4;
  end;
  for i := 0 to 1 do
  for j := 0 to 1 do
  begin
    map[i+2,j+23]:=-4;
    map[25-i,j+23]:=-4;
  end;
  //������ ����� �� �����������
  for i := 0 to 4 do
  for j := 0 to 1 do
  begin
    map[i+7,j+23]:=-4;
    map[20-i,j+23]:=-4;
  end;
  //�����
  for i := 0 to 7 do
  begin
    map[i+10,j+16]:=-4;
  end;
  //������� ����� ������
  for j := 0 to 4 do
  begin
    map[10,j+13]:=-4;
    map[17,j+13]:=-4;
  end;
  //����� ������
  for i := 0 to 2 do
  begin
    map[i+10,12]:=-4;
    map[i+15,12]:=-4;
  end;
  //���� ����
  for i := 0 to 27 do
  for j := 0 to 32 do
  if map[i,j]=0 then map[i,j]:=12;
  //�������� �����
  for i := 7 to 20 do
  for j := 9 to 21 do
  if map[i,j]>0 then map[i,j]:=0;
  for i := 0 to 5 do
  for j := 9 to 21 do
  begin
  if map[i,j]>0 then map[i,j]:=0;
  if map[27-i,j]>0 then map[27-i,j]:=0;
  end;
  end;
  procedure TForm1.Timer1Timer(Sender: TObject);
var win,m:boolean;
begin
//���������� �������
if Knight.Time>0 then dec(Knight.Time);
if Knight.Time=0 then
begin
  for i := 0 to 3 do
  Gh[i].Angry:=True;
  Knight.Time:=-1;
end;

//���
Buf.Canvas.Brush.Color:=clBlack;
Buf.Canvas.Rectangle(0,0, 672, 792);
for i := 0 to 27 do
for j := 0 to 32 do
begin
if map[i,j]=0 then Buf.Canvas.StretchDraw(Rect(i*24, j*24, i*24+24, j*24+24),Bg);
if map[i,j]<0 then Buf.Canvas.StretchDraw(Rect(i*24, j*24, i*24+24, j*24+24),Wall);
if map[i,j]=-2 then Buf.Canvas.StretchDraw(Rect(i*24, j*24, i*24+24, j*24+24),Wall2);
if map[i,j]=-3 then Buf.Canvas.StretchDraw(Rect(i*24, j*24, i*24+24, j*24+24),Wall3);
if map[i,j]>=1 then Buf.Canvas.StretchDraw(Rect(i*24, j*24, i*24+24, j*24+24),Power[map[i,j]]);
if map[i,j]=-4 then Buf.Canvas.StretchDraw(Rect(i*24, j*24, i*24+24, j*24+24),freeze);
end;
//�������
for i := 0 to 3 do
begin
  if Gh[i].Angry = True then
  Buf.Canvas.StretchDraw(Rect(Gh[i].X*24, Gh[i].Y*24, Gh[i].X*24+24, Gh[i].Y*24+24), Ghosts[i, Gh[i].Rotate])
  else
  Buf.Canvas.StretchDraw(Rect(Gh[i].X*24, Gh[i].Y*24, Gh[i].X*24+24, Gh[i].Y*24+24), Ghosts[i,5]);
  m:=false;
  //�������� ���������
  case Gh[i].Rotate of
  1:if map[Gh[i].X, Gh[i].Y+1]>=0 then begin Gh[i].Y:=Gh[i].Y+1; m:=True; end;
  2:if map[Gh[i].X, Gh[i].Y-1]>=0 then begin Gh[i].Y:=Gh[i].Y-1; m:=true; end;
  3:if map[Gh[i].X-1, Gh[i].Y]>=0 then begin Gh[i].X:=Gh[i].X-1; m:=true; end;
  4:if map[Gh[i].X+1, Gh[i].Y]>=0 then begin Gh[i].X:=Gh[i].X+1; m:=true; end;
end;
  if m=False then Gh[i].Rotate:=Random(4)+1;
end;
//���������� ������
Buf.Canvas.StretchDraw(Rect(Knight.X*24, Knight.Y*24, Knight.X*24+24, Knight.Y*24+24),Kn[Knight.Rotate, Knight.Anim]);
Inc(Knight.Anim);
case Knight.Rotate of
  1:if map[Knight.X, Knight.Y+1]>=0 then Knight.Y:=Knight.Y+1;
  2:if map[Knight.X, Knight.Y-1]>=0 then Knight.Y:=Knight.Y-1;
  3:if map[Knight.X-1, Knight.Y]>=0 then Knight.X:=Knight.X-1;
  4:if map[Knight.X+1, Knight.Y]>=0 then Knight.X:=Knight.X+1;
end;
if Knight.Anim>3 then Knight.Anim:=1;
//������������� ���������
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=2 then
  begin
    for i := 0 to 3 do
    begin
    Gh[i].Angry:=false;
    Knight.time:=50;
    end;
  end;
//���������� hp
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=5 then
  Knight.HP:=Knight.HP+5;
end;
//���������� ����� �� 20
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=3 then
  Knight.Score:=Knight.Score+20;
end;
//���������� ����� �� 50
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=4 then
  begin
  Knight.Score:=Knight.Score+50;
  end;
//���������� ����� � 2 ����
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=7 then
  Knight.Score:=Knight.Score*2;
end;
//�����
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=8 then
  begin
  Gh[0].X:=1;
  Gh[0].Y:=1;
  Gh[1].X:=26;
  Gh[1].Y:=1;
  Gh[2].X:=1;
  Gh[2].Y:=31;
  Gh[3].X:=26;
  Gh[3].Y:=31;
  Knight.Score:=Knight.Score+10;
  end;
//����������
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=9 then
  Timer1.Interval:=200;
end;
//��������� �����
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=11 then
  chcolor;
end;
if map[Knight.X,Knight.Y]>0 then
begin
  if map[Knight.X, Knight.Y]=13 then
  Timer1.Interval:=100;
end;
map[Knight.X, Knight.Y]:=0;
Knight.Score:=Knight.Score+1;
end;
end;
end;
form1.Caption:='������� = ' +inttostr(Knight.Level) + ' | ' + '���-�� HP= '  + inttostr(Knight.HP) + ' | ' + '���������� ����� = ' + inttostr(Knight.Score);
//�������� �� ������
win:=True;
for i := 0 to 27 do
for j := 0 to 32 do
if map[i,j]>0 then win:=False;
if win=True then
begin
inc(Knight.Level);
if Knight.Level=2 then lvl2;
Timer1.Interval:=170;
Knight.X:=13;
Knight.Y:=25;
Knight.Rotate:=1;
Knight.Anim:=1;
  Gh[0].X:=11;
  Gh[0].Y:=11;
  Gh[1].X:=12;
  Gh[1].Y:=11;
  Gh[2].X:=15;
  Gh[2].Y:=11;
  Gh[3].X:=16;
  Gh[3].Y:=11;
if Knight.Level=3 then lvl3;
Timer1.Interval:=130;
Knight.X:=13;
Knight.Y:=25;
Knight.Rotate:=1;
Knight.Anim:=1;
  Gh[0].X:=11;
  Gh[0].Y:=11;
  Gh[1].X:=12;
  Gh[1].Y:=11;
  Gh[2].X:=15;
  Gh[2].Y:=11;
  Gh[3].X:=16;
  Gh[3].Y:=11;
if Knight.Level=2 then
begin
ShowMessage('�� �������! ������� 2 ����������');
end;
if Knight.Level=3 then
begin
ShowMessage('�������! ��� ��� ��������? ������� 3');
end;
if Knight.Level>3 then
begin
Timer1.Enabled:=False;
if LogAndPass<>'' then
begin
ShowMessage(Log+'.'+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� ������� '+IntToStr(Knight.Level-1));
SaveTxt.Add(Log+' '+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� ������� '+IntToStr(Knight.Level-1));
SaveTxt.SaveToFile(ExtractFilePath(Application.ExeName)+'RegEdit.txt');
end
else
begin
ShowMessage(LoginUsr+'.'+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� ������� '+IntToStr(Knight.Level-1));
SaveTxt.Add(LoginUsr+' '+PassUsr+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� ������� '+IntToStr(Knight.Level-1));
SaveTxt.SaveToFile(ExtractFilePath(Application.ExeName)+'RegEdit.txt')
end;
Form1.Close;
end;
end;

form1.Canvas.StretchDraw(Rect(0,0,Form1.ClientWidth, Form1.ClientHeight),Buf);
//���������
for i := 0 to 3 do
begin
if (Gh[i].X=Knight.X) and (Gh[i].Y=Knight.Y) and (Gh[i].Angry=True) and (Timer1.Enabled=true) then
Knight.HP:=Knight.HP-1;
if Knight.HP<=0 then
begin
Timer1.Enabled:=False;
if LogAndPass<>'' then
begin
ShowMessage(Log+'.'+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� ������� '+IntToStr(Knight.Level));
end
else
begin
ShowMessage(LoginUsr+'.'+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� �������'+IntToStr(Knight.Level));
SaveTxt.Add(LoginUsr+' '+PassUsr+' �� ������� �����: '+IntToStr(Knight.Score)+' ��� ������� '+IntToStr(Knight.Level));
SaveTxt.SaveToFile(ExtractFilePath(Application.ExeName)+'RegEdit.txt');
end;
ShowMessage('�� ���������������! ������ ������� �� �������');
Form1.Close;
end;
end;
//���� ������� �� ����, �� ������ ��� �������
if (Gh[i].X=Knight.X) and (Gh[i].Y=Knight.Y) and (Gh[i].Angry=False) then
begin
Gh[i].X:=13;
Gh[i].Y:=25;
Knight.Score:=Knight.Score+5;
end;
end;
end.
