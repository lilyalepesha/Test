object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Labyrinth'
  ClientHeight = 700
  ClientWidth = 682
  Color = clCream
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object MediaPlayer1: TMediaPlayer
    Left = 472
    Top = 72
    Width = 57
    Height = 30
    ColoredButtons = [btPlay, btPause, btStop]
    EnabledButtons = [btPlay, btPause]
    VisibleButtons = [btPlay, btPause]
    DoubleBuffered = True
    Visible = False
    ParentDoubleBuffered = False
    TabOrder = 0
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 150
    OnTimer = Timer1Timer
    Left = 184
    Top = 72
  end
end
