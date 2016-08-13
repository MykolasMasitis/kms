DEFINE CLASS alarmwindow AS form
Height = 218
Width = 298
Desktop = .T.
DoCreate = .T.
AutoCenter = .T.
BorderStyle = 2
Caption = "Remote Shutdown"
TitleBar = 1
AlwaysOnTop = .T.
BackColor = RGB(255,255,128)
MaxValue = (this.Progress.Width)
CurrentValue = 0
lightFlash = 0
Name = "alarmwindow"
ParentRef = .F.

    ADD OBJECT label1 AS label WITH ;
    FontBold = .F., ;
    FontSize = 9, ;
    WordWrap = .T., ;
    Alignment = 2, ;
    BackStyle = 0, ;
    Caption = "Attantion! "+;
              "This application will have been shutdowned. "+;
              "Save data and exit!", ;
    Height = 33, ;
    Left = 26, ;
    Top = 5, ;
    Width = 265, ;
    Name = "Label1"

** Изображение включенного индикатора
ADD OBJECT lighton AS image WITH ;
    Picture = "red.bmp", ;
    BackStyle = 0, ;
    Height = 12, ;
    Left = 11, ;
    Top = 8, ;
    Width = 12, ;
    Name = "LightOn"

** Изображение отключенного индикатора
ADD OBJECT lightoff AS image WITH ;
    Picture = "grey.bmp", ;
    BackStyle = 0, ;
    Enabled = .T., ;
    Height = 12, ;
    Left = 11, ;
    Top = 8, ;
    Visible = .F., ;
    Width = 12, ;
    Name = "LightOff"

** Таймер времени ожидания пользователя
ADD OBJECT timer AS timer WITH ;
    Top = 11, ;
    Left = 270, ;
    Height = 23, ;
    Width = 23, ;
    Enabled = .F., ;
    Interval = 500, ;
    Name = "Timer"

** Объект индикатора процесса
ADD OBJECT progress AS progressbar WITH ;
         Top = 45, ;
         Left = 6, ;
         Width = 285, ;
         Height = 20, ;
         Name = "Progress", ;
         Border.DefHeight = "", ;
         Border.DefWidth = "", ;
         Border.BackStyle = 0, ;
         Border.Name = "Border", ;
         Bar.DefHeight = "", ;
         Bar.Name = "Bar"
     ADD OBJECT inform AS editbox WITH ;
         FontBold = .F., ;
         Alignment = 0, ;
         BackStyle = 1, ;
         BorderStyle = 1, ;
         Enabled = .F., ;
         Height = 138, ;
         Left = 6, ;
         ReadOnly = .F., ;
         Top = 78, ;
         Width = 288, ;
         DisabledBackColor = RGB(255,255,128), ;
         DisabledForeColor = RGB(0,0,0), ;
         Name = "Inform"
     PROCEDURE maxvalue_access
          RETURN THIS.Progress.MaxValue
     ENDPROC
     PROCEDURE maxvalue_assign
         LPARAMETERS vNewVal 
         THIS.Progress.MaxValue = m.vNewVal
     ENDPROC
     PROCEDURE currentvalue_access
         RETURN THIS.Progress.CurrentValue
     ENDPROC
     PROCEDURE currentvalue_assign
         LPARAMETERS vNewVal
         THIS.Progress.CurrentValue = m.vNewVal
     ENDPROC
     PROCEDURE start
         this.Timer.Enabled=.T.
     ENDPROC
     PROCEDURE getcaption
         if type('gcVersion')='C'
             return allt(gcVersion)
         else
             return 'Attention'
         endif
     ENDPROC
     PROCEDURE Init
         LPARAMETERS lnTimeOut
         if type('lnTimeOut')!='N'
             this.MaxValue=lnTimeOut
         endif
     ENDPROC
     PROCEDURE timer.Timer
         this.parent.LightOn.Visible=!this.parent.LightOn.Visible
         this.parent.LightOff.Visible=!this.parent.LightOff.Visible
         local lnLightFlash
         lnLightFlash=this.parent.LightFlash
         this.parent.LightFlash=this.parent.LightFlash+1
         this.parent.CurrentValue=this.parent.CurrentValue+this.Interval
         if this.parent.CurrentValue>=this.parent.MaxValue
             local loShutDown
             loShutDown=this.parent.ParentRef
             loShutDown.TimeOut()
             this.parent.Release()
         endif
     ENDPROC
     PROCEDURE inform.Init
         this.Value='The application will have been unload to update it!'
     ENDPROC
ENDDEFINE
