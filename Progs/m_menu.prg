PROCEDURE m_menu
SET SYSMENU TO

DEFINE PAD mmenu_1 OF _MSYSMENU PROMPT '\<������ � ���' COLOR SCHEME 3 KEY ALT+A , ""
DEFINE PAD mmenu_2 OF _MSYSMENU PROMPT '\<������� � ���' COLOR SCHEME 3 KEY ALT+B , ""
DEFINE PAD mmenu_4 OF _MSYSMENU PROMPT '\<�������� �����' COLOR SCHEME 3 KEY ALT+C, ""
DEFINE PAD mmenu_5 OF _MSYSMENU PROMPT '\<������' COLOR SCHEME 3 KEY ALT+E , ""
DEFINE PAD mmenu_6 OF _MSYSMENU PROMPT '\<������' COLOR SCHEME 3 KEY ALT+F , ""
DEFINE PAD mmenu_7 OF _MSYSMENU PROMPT '\<�����������������' COLOR SCHEME 3 KEY ALT+F , ""
ON PAD mmenu_1 OF _MSYSMENU ACTIVATE POPUP popVvod
ON PAD mmenu_2 OF _MSYSMENU ACTIVATE POPUP popErz
ON PAD mmenu_4 OF _MSYSMENU ACTIVATE POPUP popFObmen
ON PAD mmenu_5 OF _MSYSMENU ACTIVATE POPUP popOtchet
ON PAD mmenu_6 OF _MSYSMENU ACTIVATE POPUP popService
ON PAD mmenu_7 OF _MSYSMENU ACTIVATE POPUP popAdmin

DEFINE POPUP popVvod MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popVvod PROMPT '������� ��������������' PICTURE 'DATABASE.ICO'
DEFINE BAR 02 OF popVvod PROMPT '\-'
DEFINE BAR 03 OF popVvod PROMPT '����� �� ���������' KEY ALT+N, "ALT+N"
DEFINE BAR 04 OF popVvod PROMPT '����� �� ����-�����' KEY ALT+S, "ALT+S"
DEFINE BAR 05 OF popVvod PROMPT '����� �� ���� �����' KEY ALT+Z, "ALT+Z"
DEFINE BAR 06 OF popVvod PROMPT '\-'
DEFINE BAR 07 OF popVvod PROMPT '������������� ������'
DEFINE BAR 08 OF popVvod PROMPT '�������������� �� ��' SKIP FOR kol_pv!=1
DEFINE BAR 09 OF popVvod PROMPT '������� �� ��' SKIP FOR kol_pv!=1
DEFINE BAR 10 OF popVvod PROMPT '\-'
DEFINE BAR 11 OF popVvod PROMPT '���������� �������������'
DEFINE BAR 12 OF popVvod PROMPT '���������� "����� ������"'
DEFINE BAR 13 OF popVvod PROMPT '���������� �����������'
DEFINE BAR 14 OF popVvod PROMPT '\-'
DEFINE BAR 15 OF popVvod PROMPT '�����' PICTURE 'CLOSE.BMP' KEY ALT+F4, "ALT+F4"

ON SELECTION BAR 01 OF popVvod DO FORM v_kms
ON SELECTION BAR 03 OF popVvod DO FORM FndOutS
ON SELECTION BAR 04 OF popVvod DO FORM FndStopList
ON SELECTION BAR 05 OF popVvod DO FORM FndAllBases
ON SELECTION BAR 07 OF popVvod DO ArcData
ON SELECTION BAR 08 OF popVvod OneBaseReind()
ON SELECTION BAR 09 OF popVvod DO PackKms
ON SELECTION BAR 11 OF popVvod DO FORM SprUsers 
ON SELECTION BAR 12 OF popVvod DO FORM SprWrkPl
ON SELECTION BAR 13 OF popVvod DO FORM SprPlants
ON SELECTION BAR 15 OF popVvod CLEAR EVENTS

DEFINE POPUP popErz MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF popErz PROMPT '�� ������-5' PICTURE 'DATABASE.ICO'
DEFINE BAR 2 OF popErz PROMPT '�� ������-6' PICTURE 'DATABASE.ICO'
DEFINE BAR 3 OF popErz PROMPT '\-'
DEFINE BAR 4 OF popErz PROMPT '�������������� ������-5' PICTURE 'DATABASE.ICO'
DEFINE BAR 5 OF popErz PROMPT '�������������� ������-6' PICTURE 'DATABASE.ICO'
ON SELECTION BAR 1 OF popErz DO FORM ViewIPs                   
ON SELECTION BAR 2 OF popErz DO FORM ViewIPs6
ON SELECTION BAR 4 OF popErz DO FORM ViewPaz                        
ON SELECTION BAR 5 OF popErz DO FORM ViewPaz6

DEFINE POPUP popFObmen MARGIN RELATIVE shadow COLOR SCHEME 4
DEFINE BAR 01 OF popFObmen PROMPT '�������� ������������ ID'  PICTURE 'GROUP3.BMP' SKIP 
DEFINE BAR 02 OF popFObmen PROMPT '\-'
DEFINE BAR 03 OF popFObmen PROMPT '�������� ����� � ������' PICTURE 'EXIMP.BMP' ;
	MESSAGE '������������ ������� � ������ � ��������� ����������� ��������� ������'
DEFINE BAR 04 OF popFobmen PROMPT '\-'
DEFINE BAR 05 OF popFobmen PROMPT '�������� ����� ����� �� � ���' PICTURE 'EXIMP.BMP' ;
	MESSAGE '�������� ����� ����� ������� ������ � ��������� ���������'
DEFINE BAR 06 OF popFobmen PROMPT '\-'
DEFINE BAR 07 OF popFobmen PROMPT '��������� ����� ���'
DEFINE BAR 08 OF popFobmen PROMPT '��������� ������ ���'
DEFINE BAR 09 OF popFobmen PROMPT '\-'
DEFINE BAR 10 OF popFobmen PROMPT '��������� ��������'
DEFINE BAR 11 OF popFobmen PROMPT '��������� ����-����'

ON SELECTION BAR 01 OF popFObmen DO CheckId
ON BAR 03 OF popFObmen ACTIVATE POPUP smo2mgf
ON BAR 05 OF popFObmen ACTIVATE POPUP pv2smo
ON SELECTION BAR 07 OF popFObmen DO AppMfc
ON SELECTION BAR 08 OF popFObmen DO AppMfcR
ON SELECTION BAR 10 OF popFObmen DO AppNomP
ON SELECTION BAR 11 OF popFObmen DO AppStopList

DEFINE POPUP smo2mgf MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF smo2mgf PROMPT '������������ ���� �������� ��� ������ (����)' PICTURE 'GROUP3.BMP'
DEFINE BAR 02 OF smo2mgf PROMPT '������������ ���� �������� ��� ������ (������)' PICTURE 'GROUP3.BMP'
DEFINE BAR 03 OF smo2mgf PROMPT '\-'
DEFINE BAR 04 OF smo2mgf PROMPT '��������� ERR-�����' PICTURE 'GROUP2.BMP'
DEFINE BAR 05 OF smo2mgf PROMPT '��������� Z-�����' PICTURE 'GROUP2.BMP'
DEFINE BAR 06 OF smo2mgf PROMPT '��������� goznak-����� ' PICTURE 'GROUP2.BMP'

ON SELECTION BAR 01 OF smo2mgf FormPFileN(1)
ON SELECTION BAR 02 OF smo2mgf FormPFileN(2)
ON SELECTION BAR 04 OF smo2mgf DO AppErrFiles
ON SELECTION BAR 05 OF smo2mgf DO AppZFile
ON SELECTION BAR 06 OF smo2mgf DO AppGFile

DEFINE POPUP pv2smo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF pv2smo PROMPT '������� �������� ���� �� ��' PICTURE 'EXIMP.BMP'
DEFINE BAR 2 OF pv2smo PROMPT '\-'
DEFINE BAR 3 OF pv2smo PROMPT '������� �������� ���� � ������� ������' PICTURE 'EXIMP.BMP' SKIP 
ON SELECTION BAR 1 OF pv2smo DO efile2kms
*ON SELECTION BAR 3 OF pv2smo DO efile2ifilee

DEFINE POPUP popOtchet MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popOtchet PROMPT '������ ���������������� �������' 
DEFINE BAR 02 OF popOtchet PROMPT '������ ���������������� ������� (� �������)' 
DEFINE BAR 03 OF popOtchet PROMPT '����� �� "����������" ���������'
DEFINE BAR 04 OF popOtchet PROMPT '\-'
DEFINE BAR 05 OF popOtchet PROMPT '�������� �������� ��� �����C'

ON SELECTION BAR 01 OF popOtchet DO NonDemandedEnp
ON SELECTION BAR 02 OF popOtchet DO NonDemandedEnp2
ON SELECTION BAR 03 OF popOtchet DO RepEmpVS
ON SELECTION BAR 05 OF popOtchet DO UnLoadReg

DEFINE POPUP popService MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popService PROMPT '����� ������ ������' PICTURE 'PROVIDER.ICO'
DEFINE BAR 02 OF popService PROMPT '��������� ������� ����������' PICTURE 'PROVIDER.ICO'
DEFINE BAR 03 OF popService PROMPT '��������� ���' PICTURE 'HELPTXT.BMP'
DEFINE BAR 04 OF popService PROMPT '\-'
DEFINE BAR 05 OF popService PROMPT '�������������� ������������' PICTURE 'TOOLS.BMP'
DEFINE BAR 06 OF popService PROMPT '�������������� ���������' PICTURE 'TOOLS.BMP'
DEFINE BAR 07 OF popService PROMPT '�������������� ����-�����' PICTURE 'TOOLS.BMP'
DEFINE BAR 08 OF popService PROMPT '\-'
DEFINE BAR 09 OF popService PROMPT '���� ������ ����'
DEFINE BAR 10 OF popService PROMPT '������������� ��'

ON SELECTION BAR 01 OF popService DO FORM TunePvid
ON SELECTION BAR 02 OF popService DO FORM TuneBase
ON SELECTION BAR 03 OF popService DO FORM SelSmo
ON SELECTION BAR 05 OF popservice DO ComReind
ON SELECTION BAR 06 OF popService DO OutsReindex
ON SELECTION BAR 07 OF popService DO StopReindex
ON SELECTION BAR 09 OF popService DO MakeOneKms
ON SELECTION BAR 10 OF popService DO CorStructE

DEFINE POPUP popAdmin MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popAdmin PROMPT '��������� � ����������� ������' PICTURE 'PROVIDER.ICO'
DEFINE BAR 02 OF popAdmin PROMPT '��������� � ������������� ������' PICTURE 'PROVIDER.ICO'
ON SELECTION BAR 01 OF popAdmin DO StopWorking
ON SELECTION BAR 02 OF popAdmin DO StartWorking

SET SYSMENU AUTOMATIC
SET SYSMENU ON