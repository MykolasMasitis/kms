PROCEDURE menu_sk
SET SYSMENU TO

DEFINE PAD mmenu_1 OF _MSYSMENU PROMPT '\<������ � ���' COLOR SCHEME 3 KEY ALT+A , ""
DEFINE PAD mmenu_2 OF _MSYSMENU PROMPT '\<������� � ���' COLOR SCHEME 3 KEY ALT+B , ""
DEFINE PAD mmenu_3 OF _MSYSMENU PROMPT '\<�������� �����' COLOR SCHEME 3 KEY ALT+C, ""
DEFINE PAD mmenu_5 OF _MSYSMENU PROMPT '\<������' COLOR SCHEME 3 KEY ALT+E , ""
DEFINE PAD mmenu_6 OF _MSYSMENU PROMPT '\<������' COLOR SCHEME 3 KEY ALT+F , ""
DEFINE PAD mmenu_7 OF _MSYSMENU PROMPT '\<�����������' COLOR SCHEME 3 KEY ALT+G , ""
ON PAD mmenu_1 OF _MSYSMENU ACTIVATE POPUP popVvod
ON PAD mmenu_2 OF _MSYSMENU ACTIVATE POPUP popErz
ON PAD mmenu_3 OF _MSYSMENU ACTIVATE POPUP popFObmen
ON PAD mmenu_5 OF _MSYSMENU ACTIVATE POPUP popOtchet
ON PAD mmenu_6 OF _MSYSMENU ACTIVATE POPUP popService
ON PAD mmenu_7 OF _MSYSMENU ACTIVATE POPUP popDiags

DEFINE POPUP popVvod MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popVvod PROMPT '������� ��������������' PICTURE 'DATABASE.ICO' SKIP FOR kol_pv != 1
DEFINE BAR 02 OF popVvod PROMPT '\-'
DEFINE BAR 03 OF popVvod PROMPT '����� �� ���������' KEY ALT+N, "ALT+N"
DEFINE BAR 04 OF popVvod PROMPT '����� �� ����-�����' KEY ALT+S, "ALT+S"
DEFINE BAR 05 OF popVvod PROMPT '����� �� ���� �����' KEY ALT+Z, "ALT+Z"
DEFINE BAR 06 OF popVvod PROMPT '\-'
DEFINE BAR 07 OF popVvod PROMPT '������������� ������'
DEFINE BAR 08 OF popVvod PROMPT '�������������� �� ��' SKIP FOR kol_pv!=1
DEFINE BAR 09 OF popVvod PROMPT '\-'
DEFINE BAR 10 OF popVvod PROMPT '���������� �������������'
DEFINE BAR 11 OF popVvod PROMPT '���������� "����� ������"'
DEFINE BAR 12 OF popVvod PROMPT '\-'
DEFINE BAR 13 OF popVvod PROMPT '�����' PICTURE 'CLOSE.BMP' KEY ALT+F4, "ALT+F4"

IF kol_pv==1
IF INLIST(m.tip_pv,0,1)
 ON SELECTION BAR 01 OF popVvod DO FORM V_KMS                          
ELSE && ���� ������� �����
 ON SELECTION BAR 01 OF popVvod DO FORM V_KMS_SV                          
ENDIF 
ENDIF 
ON SELECTION BAR 03 OF popVvod DO FORM FndOutS
ON SELECTION BAR 04 OF popVvod DO FORM FndStopList
ON SELECTION BAR 05 OF popVvod DO FORM FndAllBases
ON SELECTION BAR 07 OF popVvod DO ArcData
ON SELECTION BAR 08 OF popVvod OneBaseReind(pvid(1,1))
ON SELECTION BAR 10 OF popVvod DO FORM SprUsers 
ON SELECTION BAR 11 OF popVvod DO FORM SprWrkPl
ON SELECTION BAR 13 OF popVvod CLEAR EVENTS

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
DEFINE BAR 01 OF popFObmen PROMPT '�������� ������������ ID'  PICTURE 'GROUP3.BMP'
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
DEFINE BAR 12 OF popFobmen PROMPT '\-'
DEFINE BAR 13 OF popFobmen PROMPT '��������� "�������� �����"' SKIP FOR m.qcod!='P2'

ON SELECTION BAR 01 OF popFObmen DO CheckId
ON BAR 03 OF popFObmen ACTIVATE POPUP smo2mgf
ON BAR 05 OF popFObmen ACTIVATE POPUP pv2smo
ON SELECTION BAR 07 OF popFObmen DO AppMfc
ON SELECTION BAR 08 OF popFObmen DO AppMfcR
ON SELECTION BAR 10 OF popFObmen DO AppNomP
ON SELECTION BAR 11 OF popFObmen DO AppStopList
ON SELECTION BAR 13 OF popFObmen DO App26

DEFINE POPUP smo2mgf MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF smo2mgf PROMPT '������������ ���� �������� ��� ������ (����,SCN)' PICTURE 'GROUP3.BMP'
DEFINE BAR 02 OF smo2mgf PROMPT '������������ ���� �������� ��� ������ (������,SCN)' PICTURE 'GROUP3.BMP'
DEFINE BAR 03 OF smo2mgf PROMPT '\-'
DEFINE BAR 04 OF smo2mgf PROMPT '��������� ���� �������� � ������������ �������' PICTURE 'GROUP2.BMP' SKIP 
DEFINE BAR 05 OF smo2mgf PROMPT '��������� ���� ����������� ������� (E-����)' PICTURE 'GROUP2.BMP' SKIP 
DEFINE BAR 06 OF smo2mgf PROMPT '\-'
DEFINE BAR 07 OF smo2mgf PROMPT '��������� ERR-�����' PICTURE 'GROUP2.BMP'
DEFINE BAR 08 OF smo2mgf PROMPT '��������� Z-�����' PICTURE 'GROUP2.BMP'
DEFINE BAR 09 OF smo2mgf PROMPT '��������� D-�����' PICTURE 'GROUP2.BMP' SKIP 
DEFINE BAR 10 OF smo2mgf PROMPT '��������� goznak-����� ' PICTURE 'GROUP2.BMP'

ON SELECTION BAR 01 OF smo2mgf FormPFileN(1)
ON SELECTION BAR 02 OF smo2mgf FormPFileN(2)
*ON SELECTION BAR 04 OF smo2mgf DO AppFFile
*ON SELECTION BAR 05 OF smo2mgf DO AppEFile
ON SELECTION BAR 07 OF smo2mgf DO AppErrFiles
ON SELECTION BAR 08 OF smo2mgf DO AppZFile
*ON SELECTION BAR 09 OF smo2mgf DO AppDFile
ON SELECTION BAR 10 OF smo2mgf DO AppGFile

DEFINE POPUP pv2smo MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 1 OF pv2smo PROMPT '������� �������� ���� �� ��' PICTURE 'EXIMP.BMP'
DEFINE BAR 2 OF pv2smo PROMPT '������� �������� ���� �� �� (������)' PICTURE 'EXIMP.BMP'
DEFINE BAR 3 OF pv2smo PROMPT '\-'
DEFINE BAR 4 OF pv2smo PROMPT '������� �������� ���� � ������� ������' PICTURE 'EXIMP.BMP' SKIP 
ON SELECTION BAR 1 OF pv2smo DO efile2kms
ON SELECTION BAR 2 OF pv2smo DO efile2kms0
*ON SELECTION BAR 4 OF pv2smo DO efile2ifile

DEFINE POPUP popOtchet MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popOtchet PROMPT '������ ���������������� �������' 
DEFINE BAR 02 OF popOtchet PROMPT '������ ���������������� ������� (� �������)' 
DEFINE BAR 03 OF popOtchet PROMPT '����� �� "����������" ���������'
DEFINE BAR 04 OF popOtchet PROMPT '\-'
DEFINE BAR 05 OF popOtchet PROMPT '����� �� ������� ������'

*ON SELECTION BAR 01 OF popOtchet DO NonDemandedEnp
*ON SELECTION BAR 02 OF popOtchet DO NonDemandedEnp2
ON SELECTION BAR 01 OF popOtchet DO prnNevostr
ON SELECTION BAR 02 OF popOtchet DO prnNevostr2
ON SELECTION BAR 03 OF popOtchet DO RepEmpVS
ON SELECTION BAR 05 OF popOtchet DO RepPv

DEFINE POPUP popService MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popService PROMPT '����� ���' PICTURE 'HELPTXT.BMP'
DEFINE BAR 02 OF popService PROMPT '���������� ������� ������' PICTURE 'SPRBOOK.BMP'
DEFINE BAR 03 OF popService PROMPT '\-'
DEFINE BAR 04 OF popService PROMPT '�������������� ��� ��' PICTURE 'TOOLS.BMP'
DEFINE BAR 05 OF popService PROMPT '�������� ��� ��'
DEFINE BAR 06 OF popService PROMPT '\-'
DEFINE BAR 07 OF popService PROMPT '������������� ��'
DEFINE BAR 08 OF popService PROMPT '\-'
DEFINE BAR 09 OF popService PROMPT '�������������� ������������' PICTURE 'TOOLS.BMP'
DEFINE BAR 10 OF popService PROMPT '�������������� ���������' PICTURE 'TOOLS.BMP'
DEFINE BAR 11 OF popService PROMPT '�������������� ����-�����' PICTURE 'TOOLS.BMP'
DEFINE BAR 12 OF popService PROMPT '\-'
DEFINE BAR 13 OF popService PROMPT '��������� ������� ����������' PICTURE 'PROVIDER.ICO'
DEFINE BAR 14 OF popService PROMPT '\-'
DEFINE BAR 15 OF popService PROMPT '������ � SQL SERVER' PICTURE 'PRINT.BMP'
DEFINE BAR 16 OF popService PROMPT '������� ������� ���� Z 'PICTURE 'PRINT.BMP'
DEFINE BAR 17 OF popService PROMPT '������� F-�����' SKIP FOR m.qcod!='P2'
DEFINE BAR 18 OF popService PROMPT '������� 3-�����' SKIP FOR m.qcod!='P2'
DEFINE BAR 19 OF popService PROMPT '\-' SKIP FOR m.qcod!='P2'
DEFINE BAR 20 OF popService PROMPT '��������� ��� �� RECID' SKIP FOR m.qcod!='P2'
DEFINE BAR 21 OF popService PROMPT '��������� ��� �� ���' SKIP FOR m.qcod!='P2'
DEFINE BAR 22 OF popService PROMPT '\-'
*DEFINE BAR 23 OF popService PROMPT '���� ������ ����' SKIP 
DEFINE BAR 24 OF popService PROMPT '����������� ���� S6'

ON SELECTION BAR 01 OF popService DO FORM SelSmo
ON SELECTION BAR 02 OF popService DO FORM TunePvid
ON SELECTION BAR 04 OF popService DO BaseReindex
ON SELECTION BAR 05 OF popService DO PackKMS
ON SELECTION BAR 07 OF popService DO CorStruct
ON SELECTION BAR 09 OF popservice DO ComReind
ON SELECTION BAR 10 OF popService DO OutsReindex
ON SELECTION BAR 11 OF popService DO StopReindex
ON SELECTION BAR 13 OF popService DO FORM TuneBase
ON SELECTION BAR 15 OF popService DO kms2sql
ON SELECTION BAR 16 OF popService DO MakeZsv
ON SELECTION BAR 17 OF popService DO PutFFiles
ON SELECTION BAR 18 OF popService DO Put3Files
ON SELECTION BAR 20 OF popService DO CmpBases1
ON SELECTION BAR 21 OF popService DO CmpBases2
*ON SELECTION BAR 23 OF popService DO MakeOneKms
ON SELECTION BAR 24 OF popService DO RegS6

DEFINE POPUP popDiags MARGIN RELATIVE SHADOW COLOR SCHEME 4
DEFINE BAR 01 OF popDiags PROMPT '����������� OFIOID' PICTURE  'TOOLS.BMP'
DEFINE BAR 02 OF popDiags PROMPT '����������� OFIOID' PICTURE  'TOOLS.BMP'
DEFINE BAR 03 OF popDiags PROMPT '\-'
DEFINE BAR 04 OF popDiags PROMPT '����������� ODOCID' PICTURE  'TOOLS.BMP'
DEFINE BAR 05 OF popDiags PROMPT '����������� ODOCID' PICTURE  'TOOLS.BMP'
DEFINE BAR 06 OF popDiags PROMPT '\-'
DEFINE BAR 07 OF popDiags PROMPT '����������� PERMID' PICTURE  'TOOLS.BMP'
DEFINE BAR 08 OF popDiags PROMPT '����������� PERMID' PICTURE  'TOOLS.BMP'

ON SELECTION BAR 01 OF popDiags DO OFioIdDbls
ON SELECTION BAR 02 OF popDiags DO OFioIdDbls�
ON SELECTION BAR 04 OF popDiags DO ODocIdDbls
ON SELECTION BAR 05 OF popDiags DO ODocIdDbls�
ON SELECTION BAR 07 OF popDiags DO OPermIdDbls
ON SELECTION BAR 08 OF popDiags DO OPermIdDbls�

SET SYSMENU AUTOMATIC
SET SYSMENU ON