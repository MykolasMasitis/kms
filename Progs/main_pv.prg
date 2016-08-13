#INCLUDE INCLUDE\MAIN.H

PUSH KEY
CLEAR
CLEAR PROGRAM
CLOSE ALL
*SET SYSMENU TO

#IF DEBUGMODE
	SET RESOURCE ON
#ELSE
	SET RESOURCE OFF
	CLOSE DEBUGGER
	SET VIEW OFF
#ENDIF

DECLARE INTEGER GetPrivateProfileString IN Win32API  AS GetPrivStr ;
	STRING cSection, STRING cKey, STRING cDefault, STRING @cBuffer, ;
	INTEGER nBufferSize, STRING cINIFile
DECLARE INTEGER WritePrivateProfileString IN Win32API AS WritePrivStr ;
	STRING cSection, STRING cKey, STRING cValue, STRING cINIFile
DECLARE INTEGER GetSysColor IN User32.DLL INTEGER
DECLARE INTEGER ShellExecute IN shell32.dll ;
	INTEGER hndWin, STRING cAction, STRING cFileName, ;
	STRING cParams, STRING cDir, INTEGER nShowWin

&& ���������� ������� ���������� FreeImage.dll
DECLARE Long _FreeImage_Initialise@4 IN FreeImage.dll as FIInit
DECLARE Long _FreeImage_DeInitialise@0 IN FreeImage.dll as FIRelease
DECLARE Long _FreeImage_Allocate@24 IN FreeImage.dll as FIAllocateBitmap ;
 long Width, long Height, long BitsPerPixel, Long RedMask, Long GreenMask, Long BlueMask
DECLARE Long _FreeImage_Save@16 IN FreeImage.dll as FISaveBitmap2File;
 Long Format, Long BitMap, String FileName, Long Flags
DECLARE Long _FreeImage_Invert@4 IN FreeImage.dll as FIInvertBitmap;
 Long Bitmap
DECLARE Long _FreeImage_ConvertTo8Bits@4 IN FreeImage.dll as FIConvertTo8Bits ;
 long BitMap
DECLARE Long _FreeImage_Load@12 IN FreeImage.dll as FIImageLoad ;
 Long Format, String FileName, Long Flags 
DECLARE Long _FreeImage_Rescale@16 IN FreeImage.dll as FIImageRescale ;
 long Bitmap, Long Width, Long Height, Long Filter
DECLARE Long _FreeImage_Unload@4 IN FreeImage.dll as FIImageUnload ;
 Long Bitmap

&& ���������� ������� ���������� FreeImage.dll

PUBLIC fso AS SCRIPTING.FileSystemObject, wshell AS Shell.Application
fso    = CREATEOBJECT('Scripting.FileSystemObject')

PUBLIC oApp
PUBLIC gcOldDir, gcOldPath, gcOldClassLib, gcOldEscape, gcOldTalk

PUBLIC ARRAY mes_text[12], mes_main[12]
mes_text[1]="������"
mes_text[2]="�������"
mes_text[3]="�����"
mes_text[4]="������"
mes_text[5]="���"
mes_text[6]="����"
mes_text[7]="����"
mes_text[8]="�������"
mes_text[9]="��������"
mes_text[10]="�������"
mes_text[11]="������"
mes_text[12]="�������"

mes_main[1]="������" && ���� rmon
mes_main[2]="�������"
mes_main[3]="����"
mes_main[4]="������"
mes_main[5]="���"
mes_main[6]="����"
mes_main[7]="����"
mes_main[8]="������"
mes_main[9]="��������"
mes_main[10]="�������"
mes_main[11]="������"
mes_main[12]="�������"

PUBLIC User, kol_pv, IsExit, gdCurDat1, gdCurdat2, qcod, gnTipPolis, gnZayavka, gnZayavkaS

PUBLIC qcod, qname, qaddress, dir_dolgn, dir_fio, buh_dolgn, buh_fio, spec_dolgn, spec_fio, ;
 basavs, minvs, maxvs, mcod, tip_pv

PUBLIC paisoms, parc, pbase, pbin, pcommon, pout, plocal, pexpimp, pmail, ptempl

PUBLIC pExp1, pExp2, pExp3, pExp4, pExp5, pExp6, pExp7, pExp8, pExp9, pExp10 ,;
       minFam, maxFam, minIm, maxIm, minOt, maxOt && ��������� ����������

PUBLIC glIsNeedOutSSearch, glIsNeedStop1Search, glIsNeedStop2Search, gnLastLR

PUBLIC pvid(1,10)

PUBLIC IsSprIm, TipForm, OpFio

PUBLIC userfam, userim, userot, ucod

PUBLIC gdip as Object, usbdevs as Object , usbdev as Object, tablet as Object

PUBLIC m.DeadDate, m.IntDate
m.IntDate={04.09.2016}
m.DeadDate={01.01.2017}

m.userfam   = ''
m.userim    = ''
m.userot    = ''
m.ucod      = ''

m.opfio = ''

PUBLIC IsCheckInterval
m.IsCheckInterval = .F. && �� ��������� �������� ��

PUBLIC ARRAY VsInt(1,2)
VsInt=0

PUBLIC codcom
m.codcom = ''

#DEFINE NEW_FORM_TYPE 1
#DEFINE OLD_FORM_TYPE 2

TipForm = NEW_FORM_TYPE && 1 - ����� �����, 2 - ������ �����

m.glIsNeedOutSSearch  = .t.
m.glIsNeedStop1Search = .t.
m.glIsNeedStop2Search = .t.
*qcod = 'P2'
m.gnTipPolis = 1 && ���������� ������

PUBLIC dyear(15,1)
dyear(1,1)  = "1997"
dyear(2,1)  = "1998"
dyear(3,1)  = "1999"
dyear(4,1)  = "2000"
dyear(5,1)  = "2001"
dyear(6,1)  = "2002"
dyear(7,1)  = "2003"
dyear(8,1)  = "2004"
dyear(9,1)  = "2005"
dyear(10,1) = "2006"
dyear(11,1) = "2007"
dyear(12,1) = "2008"
dyear(13,1) = "2009"
dyear(14,1) = "2010"
dyear(15,1) = "2011"

m.gcCurYear   = STR(YEAR(DATE()))
m.gdCurDat1   = CTOD('01.'+STR(MONTH(DATE()),2)+'.'+STR(YEAR(DATE()),4))
m.gdCurdat2   = GOMONTH(m.gdCurDat1,1)-1
user     = 'USR010'

IF SET('TALK') = 'ON'
 SET TALK OFF
 gcOldTalk = 'ON'
ELSE
 gcOldTalk = 'OFF'
ENDIF

gcOldEscape     = SET('ESCAPE')
gcOldDir        = FULLPATH(CURDIR())
gcOldPath       = SET('PATH')
gcOldClassLib   = SET('CLASSLIB')
plOldFlagEnd    = .T.
plOldFirstStart = .T.

_TOOLTIPTIMEOUT = 0
_INCSEEK = 5
_dblclick = 1.5

LOCAL i, lcSys16
PUBLIC lcProgram


IF TYPE("_VFP.Projects.Count") = "N"
 FOR m.i = 1 TO _VFP.Projects.Count
  IF TYPE("_VFP.Projects(m.i)") = "O"
   _VFP.Projects(m.i).Close()
  ENDIF
 ENDFOR
ENDIF

*_screen.Visible = .t.
_SCREEN.Picture = 'kms.jpg'

  m.lcSys16 = SYS(16)
  m.lcProgram = SUBSTR(m.lcSys16, AT(":", m.lcSys16) - 1)
  CD LEFT(m.lcProgram, RAT("\", m.lcProgram))
  *-- ���� ���������� �� START.PRG, �� ��������� � �������� ����������
  IF (RIGHT(m.lcProgram, 3) == "FXP") OR (RIGHT(m.lcProgram, 3) == "PRG")
	CD ..
  ENDIF

  SET DEFAULT TO (SYS(5)+SYS(2003) + '\')

  SET PATH TO FORMS, CLASSES, REPORTS, PROGS, BITMAPS
  SET CLASSLIB TO MYCLASS,MYCONTROLS,SHUTDOWN
  SET PROCEDURE TO Utils, Util, LibOOo

  TRY 
   gdip=NEWOBJECT('gdipluswrapper','gdipluswrapper.vcx')
  CATCH 
   MESSAGEBOX('����� GdiPlusWrapper �� ������!',0+16,'GdiPlusWrapper.vcx')
  ENDTRY 

  oApp = NEWOBJECT("MAINCLASS", "CLASSES\MYCLASS.VCX")
  IF !ISNULL(oApp) AND TYPE("oApp") = "O"
   SET SYSMENU TO
   SET SYSMENU ON
   SET MESSAGE TO oApp.cMainWindCaption
   SET STATUS BAR ON 
   SET EXCLUSIVE ON 
   _Screen.Width      = 1024
   _Screen.Height     = 768-100
   * _SCREEN.WindowState = 2 
   _Screen.BackColor  = RGB(192,192,192)
   _Screen.Icon = 'cross.ico'
   _Screen.AutoCenter = .F. 
 
   IF oApp.CfgBase() = -1
    =ExitProg()
   ENDIF 

   SET LIBRARY TO vfpcompression.fll ADDITIVE 
*   SET LIBRARY TO vfpzip.fll ADDITIVE 

   IF oApp.pvBase() = -1
    =ExitProg()
   ENDIF 
   
   IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
    IF USED('pvp2')
     USE IN pvp2
    ENDIF 
    =ExitProg()
   ENDIF 
   
   SELECT pvp2
   COUNT FOR v != .f. TO kol_pv
   COPY FOR v != .f. FIELD codpv, name_pv, mcod, lpu_id, tip_pv TO ARRAY pvid
   m.mcod = pvid(1,3)
   m.tip_pv = pvid(1,5)
   USE 

   IF OpenFile("&PBin\smo", "smo", "shar")>0
    IF USED('smo')
     USE IN smo
    ENDIF 
    =ExitProg()
   ENDIF 

   SELECT smo 
   COUNT FOR v=.t. TO lnIsV
   DO CASE 
   CASE lnIsV <= 0
    MESSAGEBOX("�� ������� �� ���� ��������!"+CHR(13)+"����������� ������ ����������!",0+16,"����!")
    IF USED('smo')
     USE IN smo
    ENDIF 
    =ExitProg()
   CASE lnIsV == 1 && ��� ��
    LOCATE FOR v = .t.
    SCATTER FIELDS EXCEPT v, code, name, mcod MEMVAR 
    m.qcod = code
    m.qname = name
    m.qaddress = address
    m.mcod = IIF(EMPTY(m.mcod), mcod, m.mcod)
    USE IN smo 
   CASE lnIsV > 0
    MESSAGEBOX("������� ����� ����� ��������!"+CHR(13)+"����������� ������ ����������!",0+16,"����!")
    IF USED('smo')
     USE IN smo
    ENDIF 
    =ExitProg()
  ENDCASE 

  IF m.qcod='S6' AND DATE()>m.DeadDate
   =ExitProg()
  ENDIF 
 _screen.Visible = .t.
   
  oApp.ChkBase()

*  IF oApp.IsRestart() = -1
*   MESSAGEBOX('���������� ��� ��������. ��������� ������ ����������!',0+16,'')
*   =ExitProg()
*  ENDIF 
   
  m.llResponse = .F.
  ppath = pbase+'\'+pvid(1,1)
  DO FORM Login TO m.llResponse
  IF !m.llResponse
   =ExitProg()
  ENDIF 

  _SCREEN.Caption = '����� ������ ������ (' + ALLTRIM(UPPER(pvid(1,2))) +')'
		
 goPSD = CREATEOBJECT('PowerShutDownMS')
 goPSD.Interval = 60*1000 && �������� ������ ����� ShutDown.txt
* goPSD.Interval = 60 && �������� ������ ����� ShutDown.txt
 goPSD.SystemShutDownFile = m.pBase+'\ShutDown.txt'
 goPSD.ShutDownWaitTime = 60*1000 && ����� �������� �������� ������������
* goPSD.ShutDownWaitTime = 60 && ����� �������� �������� ������������
 goPSD.ShutDownHandler = 'ExitProg'
 goPSD.Enabled = .T.
* goPSD.Enabled = .F.

  DO menu_pv

  READ EVENT
 ENDIF

 =ExitProg()
  
RETURN 



FUNCTION ExitProg
 RELEASE m.oError && ???
 #IF DEBUGMODE
  _SCREEN.Caption = oApp.cOldWindCaption
  SET SYSMENU TO DEFAULT
  _SCREEN.TitleBar = 1
  _SCREEN.WindowState = 2
  _SCREEN.LockScreen = .F.
  _SCREEN.Picture = ''
  _SCREEN.BackColor = RGB(255,255,255)
  oApp.ShowToolBars()
  SET SYSMENU ON
 #ELSE
 _SCREEN.Caption = ""
 #ENDIF
 oApp.CloseAllTable()
 RELEASE m.oApp
 #IF !DEBUGMODE
  ON SHUTDOWN
  QUIT
 #ELSE
  ON SHUTDOWN
  _SCREEN.Icon =""
  _SCREEN.FirstStart = .T.
  *SET HELP TO
  CLEAR ALL
  CLOSE ALL
  CLEAR PROGRAM
  SET SYSMENU NOSAVE
  SET SYSMENU TO DEFAULT
  SET SYSMENU ON
 #ENDIF
RETURN 