PROCEDURE menu_pv
SET SYSMENU TO

DEFINE PAD mmenu_1 OF _MSYSMENU PROMPT '\<������ � ���' COLOR SCHEME 3 KEY ALT+A , "" MESSAGE "������������ ������"
DEFINE PAD mmenu_2 OF _MSYSMENU PROMPT '\<�������� �����' COLOR SCHEME 3 KEY ALT+B, ""
DEFINE PAD mmenu_4 OF _MSYSMENU PROMPT '\<������' COLOR SCHEME 3 KEY ALT+D , ""
DEFINE PAD mmenu_5 OF _MSYSMENU PROMPT '\<������' COLOR SCHEME 3 KEY ALT+E , ""
DEFINE PAD mmenu_7 OF _MSYSMENU PROMPT '\<�����������������' COLOR SCHEME 3 KEY ALT+F , ""
ON PAD mmenu_1 OF _MSYSMENU ACTIVATE POPUP popVvod
ON PAD mmenu_2 OF _MSYSMENU ACTIVATE POPUP pv2smo
ON PAD mmenu_4 OF _MSYSMENU ACTIVATE POPUP popOtchet
ON PAD mmenu_5 OF _MSYSMENU ACTIVATE POPUP popService
ON PAD mmenu_7 OF _MSYSMENU ACTIVATE POPUP popAdmin

DEFINE POPUP popVvod MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF popVvod PROMPT '������� ��������������' PICTURE 'DATABASE.ICO'
DEFINE BAR 2 OF popVvod PROMPT '\-'
DEFINE BAR 3 OF popVvod PROMPT '������������� ������'
DEFINE BAR 4 OF popVvod PROMPT '����������� ������' SKIP 
DEFINE BAR 5 OF popVvod PROMPT '\-'
DEFINE BAR 6 OF popVvod PROMPT '���������� �������������'
DEFINE BAR 7 OF popVvod PROMPT '���������� "����� ������"'
DEFINE BAR 8 OF popVvod PROMPT '\-'
DEFINE BAR 9 OF popVvod PROMPT '�����' PICTURE 'CLOSE.BMP' KEY ALT+F4, "ALT+F4"

ON SELECTION BAR 1 OF popVvod DO FORM V_KMS                          
ON SELECTION BAR 3 OF popVvod DO ArcData
ON SELECTION BAR 6 OF popVvod DO FORM SprUsers 
ON SELECTION BAR 7 OF popVvod DO FORM SprWrkPl
ON SELECTION BAR 9 OF popVvod CLEAR EVENTS

DEFINE POPUP pv2smo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF pv2smo PROMPT '������������ �������� ���� ��� ���' PICTURE 'EXIMP.BMP'
DEFINE BAR 2 OF pv2smo PROMPT '������� ��������� �����' PICTURE 'EXIMP.BMP'
DEFINE BAR 3 OF pv2smo PROMPT '\-'
DEFINE BAR 4 OF pv2smo PROMPT '������� �������� ���� �� ���' PICTURE 'EXIMP.BMP'
DEFINE BAR 5 OF pv2smo PROMPT '\-'
DEFINE BAR 6 OF pv2smo PROMPT '������� ���� ������������� �������' PICTURE 'EXIMP.BMP'

ON SELECTION BAR 1 OF pv2smo DO kms2efile
ON SELECTION BAR 2 OF pv2smo DO DelLstRep
ON SELECTION BAR 4 OF pv2smo DO ifile2kms
ON SELECTION BAR 6 OF pv2smo DO AppGZFilePV

DEFINE POPUP popOtchet MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF popOtchet PROMPT '���������� �������� �� JT' 
ON SELECTION BAR 1 OF popOtchet DO StatJT

DEFINE POPUP popService MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popService PROMPT '��������� ��������� �������' PICTURE 'TOOLS.BMP' SKIP 
DEFINE BAR 02 OF popService PROMPT '��������� ������� ����������' PICTURE 'PROVIDER.ICO'
DEFINE BAR 03 OF popService PROMPT '�������������� ������������' PICTURE 'TOOLS.BMP'
DEFINE BAR 04 OF popService PROMPT '�������������� ��� ��' PICTURE 'TOOLS.BMP'
DEFINE BAR 05 OF popService PROMPT '�������������� ���������' PICTURE 'TOOLS.BMP'
DEFINE BAR 06 OF popService PROMPT '�������������� ����-�����' PICTURE 'TOOLS.BMP'
DEFINE BAR 07 OF popService PROMPT '����� ������� � ��������'
DEFINE BAR 08 OF popService PROMPT '�������� ��������'
DEFINE BAR 09 OF popService PROMPT '\-'
DEFINE BAR 10 OF popService PROMPT '��������� ��������' PICTURE 'PRINT.BMP'
DEFINE BAR 11 OF popService PROMPT '\-'
DEFINE BAR 12 OF popService PROMPT '��������� �������' SKIP FOR qcod!='P2'
DEFINE BAR 13 OF popService PROMPT '\-'
DEFINE BAR 14 OF popService PROMPT '������������� ��'

*ON SELECTION BAR 01 OF popService DO FORM tuneup
ON SELECTION BAR 02 OF popService DO FORM TuneBase
ON SELECTION BAR 03 OF popservice DO ComReind
ON SELECTION BAR 04 OF popService OneBaseReind(pvid(1,1))
ON SELECTION BAR 05 OF popService DO OutsReindex
ON SELECTION BAR 06 OF popService DO StopReindex
ON SELECTION BAR 07 OF popService DO RecallKms
ON SELECTION BAR 08 OF popService DO PackKMS
ON SELECTION BAR 10 OF popService oApp.Setup_Printer
ON SELECTION BAR 12 OF popService DO FORM TuneShbl
ON SELECTION BAR 14 OF popService DO CorStruct
DEFINE POPUP popAdmin MARGIN RELATIVE SHADOW COLOR SCHEME 4

DEFINE BAR 01 OF popAdmin PROMPT '��������� � ����������� ������' PICTURE 'PROVIDER.ICO'
DEFINE BAR 02 OF popAdmin PROMPT '��������� � ������������� ������' PICTURE 'PROVIDER.ICO'
ON SELECTION BAR 01 OF popAdmin DO StopWorking
ON SELECTION BAR 02 OF popAdmin DO StartWorking

SET SYSMENU AUTOMATIC
SET SYSMENU ON