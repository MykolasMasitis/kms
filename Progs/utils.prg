#INCLUDE	INCLUDE\MAIN.H

FUNCTION FOXData(m.para1)
 LOCAL m.FOXdata, InParam
 m.FOXdata = {}
 IF VARTYPE(m.para1)!='C'
  RETURN m.FOXdata
 ENDIF 
 m.InParam = ALLTRIM(m.para1)
 IF EMPTY(m.InParam)
  RETURN m.FOXdata
 ENDIF 
 IF LEN(m.InParam)!=10
  RETURN m.FOXdata
 ENDIF 
 IF SUBSTR(m.InParam,5,1)!='-' OR SUBSTR(m.InParam,8,1)!='-'
  RETURN m.FOXdata
 ENDIF 

 m.FOXdata = CTOD(SUBSTR(m.InParam,9,2)+'.'+SUBSTR(m.InParam,6,2)+'.'+SUBSTR(m.InParam,1,4))

RETURN m.FOXdata

FUNCTION SQLData(m.para1)
 LOCAL m.SQLdata, InParam
 m.SQLdata = ""
 IF VARTYPE(m.para1)!='D'
  RETURN m.SQLdata
 ENDIF 
 IF EMPTY(m.InParam)
  RETURN m.SQLdata
 ENDIF 

 m.SQLdata = LEFT(DTOS(m.InParam),4)+'-'+SUBSTR(DTOS(m.InParam),5,2)+'-'+SUBSTR(DTOS(m.InParam),7,2)

RETURN m.FOXdata

FUNCTION OpenBases
 lppath = pBase
 pnResult = 0
 pnResult = pnResult + OpenFile("&lppath\kms", "_kms", "SHARED", 'recid')
 pnResult = pnResult + OpenFile("&lppath\predst", "_predst", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\adr77", "_adr77", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\adr50", "_adr50", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\enp2", "_enp2", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\permiss", "_permiss", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\permis2", "_permis2", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\ofio", "_ofio", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\odoc", "_odoc", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\osmo", "_osmo", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\wrkpl", "_wrkpl", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\log", "_log", "SHARED", "recid")
RETURN pnResult

FUNCTION OpenBasesSt1
 lppath = pBase
 pnResult = 0
 pnResult = pnResult + OpenFile("&lppath\kms", "_kms", "SHARED", 'recid')
RETURN pnResult

FUNCTION OpenBasesSt2
 lppath = pBase
 pnResult = 0
 pnResult = pnResult + OpenFile("&lppath\predst", "_predst", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\adr77", "_adr77", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\adr50", "_adr50", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\enp2", "_enp2", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\permiss", "_permiss", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\permis2", "_permis2", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\ofio", "_ofio", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\odoc", "_odoc", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\osmo", "_osmo", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\wrkpl", "_wrkpl", "SHARED", "recid")
 pnResult = pnResult + OpenFile("&lppath\log", "_log", "SHARED", "recid")
RETURN pnResult

FUNCTION SetRelationOn
 SELECT _kms 
 SET RELATION TO predstid INTO _predst 
 SET RELATION TO adr_id INTO _adr77 ADDITIVE 
 SET RELATION TO adr50_id INTO _adr50 ADDITIVE 
 SET RELATION TO enp2id INTO _enp2 ADDITIVE 
 SET RELATION TO permid INTO _permiss ADDITIVE 
 SET RELATION TO perm2id INTO _permis2 ADDITIVE 
 SET RELATION TO ofioid INTO _ofio ADDITIVE 
 SET RELATION TO odocid INTO _odoc ADDITIVE 
 SET RELATION TO osmoid INTO _osmo ADDITIVE 
 SET RELATION TO wrkid INTO _wrkpl ADDITIVE 
RETURN 

FUNCTION SetRelationOff
 SELECT _kms 
 SET RELATION OFF INTO _predst 
 SET RELATION OFF INTO _adr77
 SET RELATION OFF INTO _adr50
 SET RELATION OFF INTO _enp2
 SET RELATION OFF INTO _permiss
 SET RELATION OFF INTO _permis2
 SET RELATION OFF INTO _ofio
 SET RELATION OFF INTO _odoc
 SET RELATION OFF INTO _osmo
 SET RELATION OFF INTO _wrkpl
RETURN 

FUNCTION CloseBases
 IF USED('_kms')
  USE IN _kms
 ENDIF 
 IF USED('_predst')
  USE IN _predst
 ENDIF 
 IF USED('_adr77')
  USE IN _adr77
 ENDIF 
 IF USED('_adr50')
  USE IN _adr50
 ENDIF 
 IF USED('_enp2')
  USE IN _enp2
 ENDIF 
 IF USED('_permiss')
  USE IN _permiss
 ENDIF 
 IF USED('_permis2')
  USE IN _permis2
 ENDIF 
 IF USED('_ofio')
  USE IN _ofio
 ENDIF 
 IF USED('_odoc')
  USE IN _odoc
 ENDIF 
 IF USED('_osmo')
  USE IN _osmo
 ENDIF 
 IF USED('_wrkpl')
  USE IN _wrkpl
 ENDIF 
 IF USED('_log')
  USE IN _log
 ENDIF 
RETURN 

FUNCTION GoNWrkDays(stday, ndays)
 PRIVATE m.stday, m.ndays
 
 m.IsUsedHolidays = .T.
 IF !USED('holidays')
  m.IsUsedHolidays = .F.
  IF OpenFile(pcommon+'\holidays', 'holidays', 'shar', 'day')>0
   IF USED('holidays')
    USE IN holidays
    RETURN {}
   ENDIF 
  ENDIF 
 ENDIF 
  
 m.curday  = m.stday
 m.wrkdays = 0
 DO WHILE m.wrkdays < m.ndays-1
  m.curday = m.curday + 1
  m.wrkdays = m.wrkdays + IIF(INLIST(DOW(m.curday,2),6,7) or ;
   SEEK(m.curday, 'holidays'),0,1)
 ENDDO 

 IF m.IsUsedHolidays = .F.
  USE IN holidays
 ENDIF 
 
RETURN m.curday

FUNCTION OpenFile
 LPARAMETERS lcFile, lcAlias, lcMode, lcOrder, lcAgain
 LOCAL loError AS Exception
 lcFile = IIF(OCCURS('.', lcFile)>0, lcFile, lcFile+".dbf")
 lcMode  = IIF(!EMPTY(lcMode), UPPER(lcMode), "SHARED")
 lcOrder = IIF(!EMPTY(lcOrder), "ORDER "+UPPER(lcOrder), "")
 lcAgain = IIF(!EMPTY(lcAgain), UPPER(lcAgain), "")
 
 IF !FILE(lcFile)
  MESSAGEBOX("����������� ���� "+lcFile,0+16,"")
  RETURN 1
 ENDIF 
 
 TRY
  USE (lcFile) IN 0 ALIAS (lcAlias) &lcMode &lcOrder &lcAgain
 CATCH TO loError
  MESSAGEBOX("������ ��� �������� ����� "+lcFile+"!"+CHR(13)+;
  loError.Message + "," + ALLTRIM(STR(loError.ErrorNo)), 0, "������ �������� �����!")
 ENDTRY

 IF	VARTYPE(m.loError) == "O"
  RETURN 1
 ELSE
  RETURN 0
 ENDIF
 


FUNCTION RChar
 PARAMETERS rc_par
 IF LEN(ALLTRIM(rc_par)) > 0
  FOR i=1 TO LEN(ALLTRIM(rc_par))
   sub_tmp = SUBSTR(ALLTRIM(rc_par),i,1)
    IF !Lower(sub_tmp) $ '*��������������������������������- '
     RETURN .f.
    ENDIF 
   NEXT  
  ENDIF 
RETURN .t.


FUNCTION EngToRus
 PARAMETERS string
 lowers = [qwertyuiop]+chr(91)+chr(93)+[asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]
 uppers = [����������������������������������������������������������������]
RETURN (chrtran(string,lowers,uppers))


FUNCTION RusToEng
 Para string
 lowers = [qwertyuiop]+chr(91)+chr(93)+[asdfghjkl;'zxcvbnm,.QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]
 uppers = [����������������������������������������������������������������]
* lowers = [qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM] + chr(241)
* uppers = [����������������������������������������������������] + chr(240)
RETURN (chrtran(string,uppers,lowers))


FUNCTION  cpr
PARAMETERS  _c
**  _c - ����� �� �����. �����������: �� 0 �� 999 ����������.
if _c<0
   return '����� �������, ��� ��� �������'
endif
if _c=0
   return '���� ������'
endif
if _c>=1000000000000000
   return '����� ������ �����'
endif
**  ����������� �������� � ����������:
**  m1(20,4), m2(5,3)
**  _p - �������� ����� �� ������.
set talk off
_c=1000*int(_c)+100*(round(_c,2)-int(_c))
_p=''
dime m1(20,4), m2(6,3)

m1(1,1)=''
m1(2,1)='����'
m1(3,1)='���'
m1(4,1)='���'
m1(5,1)='������'
m1(6,1)='����'
m1(7,1)='�����'
m1(8,1)='����'
m1(9,1)='������'
m1(10,1)='������'
m1(11,1)=''
m1(12,1)=''
m1(13,1)=''
m1(14,1)=''
m1(15,1)=''
m1(16,1)=''
m1(17,1)=''
m1(18,1)=''
m1(19,1)=''
m1(20,1)=''

m1(1,2)=''
m1(2,2)=''
m1(3,2)='��������'
m1(4,2)='��������'
m1(5,2)='�����'
m1(6,2)='���������'
m1(7,2)='����������'
m1(8,2)='���������'
m1(9,2)='�����������'
m1(10,2)='���������'
m1(11,2)='������'
m1(12,2)='�����������'
m1(13,2)='����������'
m1(14,2)='����������'
m1(15,2)='������������'
m1(16,2)='����������'
m1(17,2)='�����������'
m1(18,2)='����������'
m1(19,2)='������������'
m1(20,2)='������������'

m1(1,3)=''
m1(2,3)='���'
m1(3,3)='������'
m1(4,3)='������'
m1(5,3)='���������'
m1(6,3)='�������'
m1(7,3)='��������'
m1(8,3)='�������'
m1(9,3)='���������'
m1(10,3)='���������'
m1(11,3)=''
m1(12,3)=''
m1(13,3)=''
m1(14,3)=''
m1(15,3)=''
m1(16,3)=''
m1(17,3)=''
m1(18,3)=''
m1(19,3)=''
m1(20,3)=''

m1(1,4)=''
m1(2,4)='����'
m1(3,4)='���'
m1(4,4)='���'
m1(5,4)='������'
m1(6,4)='����'
m1(7,4)='�����'
m1(8,4)='����'
m1(9,4)='������'
m1(10,4)='������'
m1(11,4)=''
m1(12,4)=''
m1(13,4)=''
m1(14,4)=''
m1(15,4)=''
m1(16,4)=''
m1(17,4)=''
m1(18,4)=''
m1(19,4)=''
m1(20,4)=''

m2(1,1)='�������'
m2(2,1)='�����'
m2(3,1)='������'
m2(4,1)='�������'
m2(5,1)='��������'
m2(6,1)='��������'

m2(1,2)='�������'
m2(2,2)='�����'
m2(3,2)='������'
m2(4,2)='��������'
m2(5,2)='���������'
m2(6,2)='���������'

m2(1,3)='������'
m2(2,3)='������'
m2(3,3)='�����'
m2(4,3)='���������'
m2(5,3)='����������'
m2(6,3)='����������'

**  ��������!!!
for _i=1 to 6
   _tri=_c-1000*int(_c/1000)
   _c=int(_c/1000)
   _dva=_tri-100*int(_tri/100)
   if _dva>9.and._dva<20
      _sl2=m1(1+_dva,y(3*_i-1))+chr(32)+m2(_i,3)+chr(32)
      _sl1=m1(1+int(_tri/100),y(3*_i))+chr(32)
      _p=ltrim(_sl1)+ltrim(_sl2)+ltrim(_p)
   else
      _odin=_tri-10*int(_tri/10)
      _sl3=m1(1+_odin,y(3*_i-2))+chr(32)
      _sl2=m1(1+int(_dva/10),y(3*_i-1))+chr(32)
      _sl1=m1(1+int(_tri/100),y(3*_i))+chr(32)
      if len(alltrim(_sl3+_sl2+_sl1))>0
         _p=ltrim(_sl1)+ltrim(_sl2)+ltrim(_sl3);
            +m2(_i,iif(_odin=1,1,iif(_odin>1.and._odin<5,2,3)))+chr(32)+ltrim(_p)
      else
         if _i=2
            _p=m2(2,3)+chr(32)+ltrim(_p)
         endif
      endif
   endif
   if _c=0
      exit
   endif
endfor
*****wait wind _p
* set talk on
RETURN _p

FUNCTION  Y
PARAMETERS  _a
RETURN iif(_a=1 or _a=7,4,_a-3*int((_a-1)/3))


FUNCTION chk_nkms
 PARAMETERS pnkms
 n1  = val( subs( pnkms, 1, 1 ) )
 n2  = val( subs( pnkms, 2, 1 ) )
 n3  = val( subs( pnkms, 3, 1 ) )
 n4  = val( subs( pnkms, 4, 1 ) )
 n5  = val( subs( pnkms, 5, 1 ) )
 n6  = val( subs( pnkms, 6, 1 ) )
 n7  = val( subs( pnkms, 7, 1 ) )
 n8  = val( subs( pnkms, 8, 1 ) )
 n9  = val( subs( pnkms, 9, 1 ) )
 n10 = val( subs( pnkms,10, 1 ) )
 r1 = ( n2*2 + n3*8 + n4*6 + n5*3 + n6*5 + n7*4 + n8*2 + n9*1 + n10*7 ) % 10
RETURN iif(n1 = r1, .t., .f.)

FUNCTION chk_nenp
PARAMETERS lnENP

DO CASE 
	CASE VARTYPE(lnENP) = 'N'
		lcENP = STRTRAN(STR(lnENP,16,0),' ','0')
	CASE VARTYPE(lnENP) = 'C'
		lcENP = PADL(ALLTRIM(lnENP),16,'0')
	OTHERWISE
		lcENP = STRTRAN(SPACE(16),' ','0')
ENDCASE

VLast = RIGHT(lcENP,1)
V2 = LEFT(lcENP,LEN(lcENP)-1)

VA1 = ''
VB1 = ''

lMod = MOD(LEN(V2),2)

IF lMod = 1
	lModa = 0
	lModb = -1
ELSE
	lModb = 0
	lModa = -1
ENDIF

FOR NPos = LEN(V2) + lModa TO 1 STEP -2
	VA1 = VA1 + SUBSTR(V2,NPos,1)
ENDFOR

FOR NPos = LEN(V2) + lModb TO 1 STEP -2
	VB1 = VB1 + SUBSTR(V2,NPos,1)
ENDFOR

VA = ALLTRIM(STR(INT(VAL(VA1)) * 2))
VBA = VB1 + VA

VC = 0
FOR NPos = 1 TO LEN(VBA)
	VC = VC + VAL(SUBSTR(VBA,NPos,1))
ENDFOR

VD = (CEILING(VC/10) * 10) - VC

IF NOT VD = VAL(VLast)
	RETURN (.T.)
ELSE
	RETURN (.F.)
ENDIF


FUNCTION  pause
 PARAMETERS  arg
 wer = seco()
 DO  while seco() - wer <= arg
 ENDDO  
RETURN 


FUNCTION FSumm
 PARAMETERS Usl, STip, Kol
 If Seek(Usl, 'Tarif')
  Do Case
   Case Uppe(Tarif.Tip) = 'C' And InList(Stip,'0','�')
    Summa = iif(InList(People.c_a,0,50,77,99), iif(InfTip=1, Tarif.Price, Tarif.dPrice), iif(InfTip=1, Tarif.iPrice, Tarif.idPrice))
   Case Uppe(Tarif.Tip) = 'C' And !InList(Stip,'0','�')
    Summa = iif(Kol<Tarif.n_kd And !InList(Usl,83010,83020,83030,83040,83050), ;
     Roun(Roun(Kol/Tarif.n_kd,2) * iif(InList(People.c_a,0,50,77,99), iif(InfTip=1, Tarif.Price, Tarif.dPrice), iif(InfTip=1, Tarif.iPrice, Tarif.idPrice)),2), ;
     iif(InList(People.c_a,0,50,77,99), iif(InfTip=1, Tarif.Price, Tarif.dPrice), iif(InfTip=1, Tarif.iPrice, Tarif.idPrice)))
   Case Upper(Tarif.Tip)!='C' 
    Summa = iif(InList(People.c_a,0,50,77,99), iif(InfTip=1, tarif.Price, tarif.dPrice), iif(InfTip=1, tarif.iPrice, tarif.idPrice)) * Kol
   Othe
    Summa = 0
  EndC
 Else
  Summa = 0
 EndI
RETURN Summa

FUNCTION  DToH
 PARAMETERS  iDig
 oDig = Replicate(' ',8)
 x = Mod(iDig,16)
 i = 8
 oDig = stuff(oDig,i,1,TransA(x))
 Do While iDig > 0
  oDig = stuff(oDig,i,1,TransA(x))
  i = i-1
  iDig = Int(iDig/16)
  x = Mod(iDig,16)
 EndD
 oDig = iif(iDig>0, stuff(oDig,i,1,TransA(iDig)), oDig)
RETURN allt(oDig)

FUNCTION  TransA
PARAMETERS  Pt1
Do Case
 Case Pt1=0
  Pt2 = '0'
 Case Pt1=1
  Pt2 = '1'
 Case Pt1=2
  Pt2 = '2'
 Case Pt1=3
  Pt2 = '3'
 Case Pt1=4
  Pt2 = '4'
 Case Pt1=5
  Pt2 = '5'
 Case Pt1=6
  Pt2 = '6'
 Case Pt1=7
  Pt2 = '7'
 Case Pt1=8
  Pt2 = '8'
 Case Pt1=9
  Pt2 = '9'
 Case Pt1=10
  Pt2 = 'A'
 Case Pt1=11
  Pt2 = 'B'
 Case Pt1=12
  Pt2 = 'C'
 Case Pt1=13
  Pt2 = 'D'
 Case Pt1=14
  Pt2 = 'E'
 Case Pt1=15
  Pt2 = 'F'
EndC
RETURN  Pt2

FUNCTION  HToD
 PARAMETERS  iDig
 iDig = Uppe(allt(strt(iDig,' ')))
 dLen = len(iDig)
 oDig = 0
 For i=1 to dLen-1
  oDig = (oDig+TransT(Subs(iDig,i,1)))*16
 EndF
 oDig = oDig+TransT(Subs(iDig,i,1))
RETURN oDig

FUNCTION TransT
PARAMETERS Pt1
Do Case
 Case Pt1='0'
  Pt2 = 0
 Case Pt1='1'
  Pt2 = 1
 Case Pt1='2'
  Pt2 = 2
 Case Pt1='3'
  Pt2 = 3
 Case Pt1='4'
  Pt2 = 4
 Case Pt1='5'
  Pt2 = 5
 Case Pt1='6'
  Pt2 = 6
 Case Pt1='7'
  Pt2 = 7
 Case Pt1='8'
  Pt2 = 8
 Case Pt1='9'
  Pt2 = 9
 Case Pt1='A'
  Pt2 = 10
 Case Pt1='B'
  Pt2 = 11
 Case Pt1='C'
  Pt2 = 12
 Case Pt1='D'
  Pt2 = 13
 Case Pt1='E'
  Pt2 = 14
 Case Pt1='F'
  Pt2 = 15
EndC
RETURN Pt2

FUNCTION TransPol
LPARAMETERS tPolis, nVozvrat
tPolis = ALLTRIM(tPolis)
nVozvrat = IIF(EMPTY(nVozvrat), 1, nVozvrat)
DO CASE  
	CASE LEFT(tPolis,2) = '77'
 		DO CASE 
 			CASE INLIST(Upper(EngToRus(SUBSTR(tPolis,5,1))), '�', '�', '�')
	    		Pps = Upper(EngToRus(Left(tPolis,5)))
	    		Ppn = Int(Val(Subs(tPolis,6)))
	    		IF BETWEEN(ppn,1,999999)
	    		 tPolis = Pps + ' ' +Padl(Ppn,6,'0')
	    		ELSE 
	  	 		 tPolis = IIF(nVozvrat = 2, '', tPolis)
	    		ENDIF 

	  		CASE  BETWEEN(VAL(SUBSTR(tPolis,5,2)),0,27) OR ;
	  		 INLIST(SUBSTR(tPolis,5,2),'45','50','51','52','73','77','99')
	    		Pps   = LEFT(tPolis,6)
	    		Ppn   = INT(VAL(SUBSTR(tPolis,7)))
	    		IF BETWEEN(ppn, 1, 9999999999)
	    		 tPolis = Pps + ' ' +Padl(Ppn,10,'0')
	    		ELSE
	  	 		 tPolis = IIF(nVozvrat = 2, '', tPolis)
	    		ENDIF 
   
	  		OTHERWISE 
	  	 		tPolis = IIF(nVozvrat = 2, '', tPolis)
	  	 	    
  		ENDCASE 
      
	 CASE InList(Upper(RusToEng(Subs(tPolis,1,2))), 'I1', 'M1', 'M4', 'M6', 'R2', 'S2', 'S5', 'V2', 'P2','R4')
	 	tPolis = STRTRAN(ALLTRIM(tPolis)," ","")
	 	Pps = Uppe(RusToEng(Left(tPolis,5)))
	 	Ppn = Int(Val(Subs(tPolis,6)))
	 	tPolis = Pps + ' ' +Padl(Ppn,5,'0')
 
	 OTHERWISE 
		tPolis = IIF(nVozvrat = 2, '', tPolis)

ENDCASE 

RETURN PADR(ALLTRIM(tPolis),17)


FUNCTION SV
	PARAMETERS ppp,x,y,z
RETURN 

FUNCTION NV
PARAMETERS ppp,x,y,z

DO CASE 

 CASE EMPTY(ppp) && ������ �����
  RETURN 0

 CASE SUBSTR(ppp,1,3)='46-' && ��������� �����
  IF !INLIST(SUBSTR(ppp,4,3),'01 ','02 ','03 ','04 ','05 ','06 ','07 ','08 ','09 ','10 ','11 ','12 ','13 ','14 ','15 ','16 ','17 ','18 ','19 ','20 ','21 ','22 ','23 ','24 ')
   RETURN 1
  ENDIF   

  IF !BETWEEN(VAL(SUBSTR(ppp,7)),1,999999)
   =MESSAGEBOX("���-�� �� �� � ��������� �������!",0+48,"��������!")
   RETURN 2
  ENDIF 


 CASE SUBSTR(ppp,1,2) = '77'  && ���������� �����
  DO CASE 
   CASE INLIST(SUBSTR(ppp,5,1),'�','�','�') AND ;
    INLIST(SUBSTR(ppp,3,2),'01','02','03','04','05','06','07','08','09','10') AND  ;
    BETWEEN(INT(VAL(SUBSTR(ppp,7))),1,999999)

   CASE ISDIGIT(SUBSTR(ppp,3,1)) AND ISDIGIT(SUBSTR(ppp,4,1)) AND ISDIGIT(SUBSTR(ppp,5,1)) AND  ;
    ISDIGIT(Subs(ppp,6,1)) AND BETWEEN(VAL(SUBSTR(ppp,3,2)),0,9) AND (BETWEEN(VAL(SUBSTR(ppp,5,2)),0,27) ;
    OR INLIST(SUBSTR(ppp,5,2),'45','50','51','52','73','77','99')) AND VAL(SUBSTR(ppp,8))>0

    IF !chk_nkms(PADL(ALLTRIM(SUBSTR(ppp,8)),10,'0')) 
     RETURN 3
    ENDIF 

   OTHERWISE 
    RETURN 4
   
  ENDCASE 

 CASE INLIST(SUBSTR(ppp,1,2), 'I1', 'M1', 'M4', 'M6', 'R2', 'S2','S5', 'P2' ) && ���� �����������
  DO CASE     
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='I1' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),151,199)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='M1' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),200,399)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='M4' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),401,499)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='R4' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),051,075)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='P2' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),101,150)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='R2' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),501,699)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='S2' AND  BETWEEN(VAL(SUBSTR(ppp,3,3)),701,799)
   CASE  UPPER(RusToEng(SUBSTR(ppp,1,2)))='S5' AND  (BETWEEN(VAL(SUBSTR(ppp,3,3)),801,899) OR ;
		BETWEEN(VAL(SUBSTR(ppp,3,3)),951,980))
   OTHERWISE 
    RETURN 5
  ENDCASE 

  IF !BETWEEN(VAL(SUBSTR(ppp,7)), 1, 99999)
   RETURN 6
  ENDIF 
             
 OTHERWISE && ������ ����������

ENDCASE 

RETURN 10 && Ok!


FUNCTION NULLIF(LnSRC1)
	RETURN ICASE(VARTYPE(m.LnSRC1) ="X", 'NULL', EMPTY(m.LnSRC1), ;
		'NULL', VARTYPE(m.LnSRC1)=="C", ['] + ALLTRIM(m.LnSRC1) + ['], ;
		VARTYPE(m.LnSRC1)== "D", ['] + DTOC(m.LnSRC1) + ['], ;
		VARTYPE(m.LnSRC1)== "T", ['] + TTOC(m.LnSRC1) + ['], ;
		VARTYPE(m.LnSRC1)= "N" AND !EMPTY(m.LnSRC1), ALLTRIM(STR(m.LnSRC1)), 'NULL')
ENDFUNC

FUNCTION OnShutDown()
	IF VARTYPE(oApp) == "O"
		oApp.Exit_App()
	ELSE
		ON ERROR
		ON SHUTDOWN
		CLEAR EVENTS
	ENDIF
ENDFUNC

FUNCTION NEWOBJ
	LPARAMETERS tcClass, tuParm1, tuParm2, ;
		tuParm3, tuParm4
	LOCAL lcClass, ;
		lcLibrary, ;
		lnPos, ;
		loObject

	lcClass   = UPPER(tcClass)
	lcLibrary = ''
	IF ',' $ lcClass AND LEFT(lcClass, 1) <> ','
		lnPos     = AT(',', lcClass)
		lcLibrary = ALLTRIM(LEFT(lcClass, lnPos - 1))
		lcClass   = ALLTRIM(SUBSTR(lcClass, lnPos + 1))
		IF lcLibrary $ UPPER(SET('CLASSLIB'))
			lcLibrary = ''
		ELSE
			SET CLASSLIB TO (lcLibrary) ADDITIVE
		ENDIF
	ENDIF

	DO CASE
		CASE pcount() = 1
			loObject = CREATEOBJECT(lcClass)
		CASE pcount() = 2
			loObject = CREATEOBJECT(lcClass, @tuParm1)
		CASE pcount() = 3
			loObject = CREATEOBJECT(lcClass, @tuParm1, @tuParm2)
		CASE pcount() = 4
			loObject = CREATEOBJECT(lcClass, @tuParm1, @tuParm2, @tuParm3)
		CASE pcount() = 5
			loObject = CREATEOBJECT(lcClass, @tuParm1, @tuParm2, @tuParm3, ;
				@tuParm4)
	ENDCASE
	RETURN loObject
ENDFUNC

FUNCTION SetDSession
	*-- ����� ��������� ����� ���������� ���������
	SET ANSI ON 
	SET CENTURY ON 
	SET CENTURY TO 19 ROLLOVER 10
	SET CONFIRM OFF 
	SET DATE TO GERMAN 
*	SET DELETED ON
	SET DELETED OFF 
	SET EXACT OFF 
	SET EXCLUSIVE ON 
	SET HOURS TO 24
	SET LOCK OFF 
	SET MARK TO 
	SET MEMOWIDTH TO 120
	SET MULTILOCKS OFF
	SET NEAR ON 
	SET NULL OFF 
	SET POINT TO "."
	SET REPROCESS TO 3 SECONDS
	SET SAFETY OFF 
	SET SEPARATOR TO "`"
	SET SYSFORMATS OFF 
	SET TALK OFF 

	IF 3=2
	SET TALK OFF
	SET NOTIFY OFF
	SET COMPATIBLE OFF

	SET SYSFORMATS OFF
	SET CURRENCY TO '�'
	SET CURRENCY RIGHT
	SET CENTURY ON
	SET DATE TO GERMAN
	SET DECIMALS TO 2
	SET HOURS TO 24
	SET POINT TO "."
	SET SEPARATOR TO "`"
	SET FDOW  TO 2
	SET FWEEK TO 1

	=CURSORSETPROP("Buffering", 1, 0)
	SET MEMOWIDTH TO 120
	SET FDOW TO 2
	SET ANSI ON
	SET SAFETY OFF
	SET MEMOWIDTH TO 80
	SET MULTILOCKS OFF
*	SET DELETED ON
	SET DELETED OFF 
	SET EXCLUSIVE ON
	SET BELL OFF
	* SET NEAR OFF
	SET EXACT OFF
	SET EXACT ON
	SET INTENSITY OFF
	SET CONFIRM ON
	SET LOCK OFF
	SET REPROCESS TO 3 SECONDS
	SET NULL ON
	SET NULLDISPLAY TO " "
	CLEAR MACROS
	#IF DEBUGMODE
		SET RESOURCE TO FOXUSER.DBF
		SET RESOURCE ON
		SET DEBUG ON
		SET ESCAPE ON
	#ELSE
		SET RESOURCE OFF
		SET DEBUG OFF
		SET ESCAPE OFF
	#ENDIF
	SET ASSERTS OFF
	SET CPCOMPILE TO 1251
	ENDIF 

	RETURN .T.
ENDFUNC

FUNCTION ModifyColor
	*	��������� �����
	LPARAMETERS lnColor, lnDelta, lnIndex
	LOCAL ARRAY S_Rgb[3]
	*	���� ��� ��������� 0 - 16`777`216
	lnColor	= MIN( 16777216, MAX( 0, iif( VARTYPE( lnColor ) == 'N', lnColor, 0 )))
	*	��� ���� �������� 0 - ��� �����, 1-�������, 2-�������, 3-�����
	lnIndex	= MIN( 3, MAX( 0, iif( VARTYPE( lnIndex ) == 'N', lnIndex, 0 )))
	*	�� ������� ���� �������� ����
	lnDelta	= IIF( VARTYPE( lnDelta ) == 'N', lnDelta , 0 )

	S_Rgb[3]	= INT( lnColor/ 65536 )	&& �����
	lnColor		= lnColor- ( S_Rgb[3] * 65536 )
	S_Rgb[2]	= INT( lnColor/ 256 )	&& �������
	lnColor		= lnColor- ( S_Rgb[2] * 256 )
	S_Rgb[1]	= lnColor				&& �������

	IF lnIndex = 0	&& ��� �����
		RETURN ( rgb(;
			MAX( 0, MIN( 255,  S_Rgb[ 1 ] + lnDelta )),;
			MAX( 0, MIN( 255,  S_Rgb[ 2 ] + lnDelta )),;
			MAX( 0, MIN( 255,  S_Rgb[ 3 ] + lnDelta ))))
	ELSE			&& ���� ����
		RETURN ( MAX( 0, MIN( 255,  S_Rgb[ lnIndex ] + lnDelta )))
	ENDIF
ENDFUNC


*-- ��������� �������� ���������� ��� �������� ���������� � �������������� �� � ������
FUNCTION Revers
	LPARAMETERS luStr, lnPrecision, lnScale
	DO CASE
		CASE VARTYPE(m.luStr) = "T"
			RETURN Revers(TTOC(m.luStr,1))
		CASE VARTYPE(m.luStr) == "C"
			m.luStr = CHRTRAN(NVL(m.luStr, ""), ["�], [�"])
			RETURN CHRTRAN(m.luStr, " !#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~�����������������������������������������������������������������", ;
				"�����������������������������������������������������������������~}|{zyxwvutsrqponmlkjihgfedcba`_^]\[ZYWVUTSRQPONMLKJIHGFEDCBA@?>=<;:9876543210/.-,+*)('&%$#! ")
		CASE VARTYPE(m.luStr) == "N"
			m.lnPrecision = IIF(VARTYPE(m.lnPrecision)=="N", m.lnPrecision, 18)
			m.lnScale = IIF(VARTYPE(m.lnScale)=="N", m.lnScale, 2)
			RETURN Revers( NumToStr( m.luStr, m.lnPrecision, m.lnScale ))
		CASE VARTYPE(m.luStr) = "D"
			m.luStr = NVL(m.luStr, {})
			RETURN  STR(99999999 - VAL(DTOS(m.luStr)))
		OTHERWISE
			RETURN ""
	ENDCASE
ENDFUNC

FUNCTION NumToStr
	LPARAMETERS luStr, lnPrecision, lnScale
	luStr = NVL(luStr, 0)
	lnPrecision = IIF(VARTYPE(lnPrecision)=="N", lnPrecision, 18)
	lnScale = IIF(VARTYPE(lnScale)=="N", lnScale, 2)
	RETURN IIF(luStr < 0, 'A', 'Z') + ;
		IIF(luStr < 0, STR(-99999999999999.99 - luStr,lnPrecision,lnScale), STR(luStr,lnPrecision,lnScale))
ENDFUNC

FUNCTION SaveToINIFile
	LPARAMETERS lcName, lcRasdel, lcValue, lcIniFile
	*-- ������ ������ ��������� � INI - ����
	LOCAL lcEntry, lPath
	m.lcIniFile = IIF(VARTYPE(m.lcIniFile) == "C", m.lcIniFile, INIFILE)
	m.lPath = SYS(5)+SYS(2003) + '\'
	=WritePrivStr(m.lcRasdel, m.lcName, m.lcValue, m.lPath + m.lcIniFile)
ENDFUNC

FUNCTION ReadFromINIFile
	LPARAMETERS lcName, lcRasdel, lcIniFile
	*-- ������ ������ ��������� �� INI - �����
	LOCAL  lcBuffer, lcRetValue, lPath
	m.lcIniFile = IIF(VARTYPE(m.lcIniFile) == "C", m.lcIniFile, INIFILE)
	m.lPath = SYS(5)+SYS(2003) + '\'
	m.lcBuffer = SPACE(100) + CHR(0)
	*-- ������ ������� ���� �� INI �����
	m.lcRetValue = ""
	TRY
		IF GetPrivStr(m.lcRasdel, m.lcName, "", @m.lcBuffer, LEN(m.lcBuffer), ;
				m.lPath + m.lcIniFile) > 0
			m.lcRetValue = ALLTRIM(LEFT(m.lcBuffer, AT(CHR(0), m.lcBuffer)-1))
		ENDIF
	CATCH
		m.lcRetValue = ""
	ENDTRY
	RETURN (m.lcRetValue)
ENDFUNC

FUNCTION FormIsObject()
	LPARAMETERS NameForm
	*-- ���������� .T. ���� �������� ����� ������ (���- "O") � �����
	*-- ������� ����� "Form".
	IF PCOUNT() = 0 OR EMPTY(NameForm)
		RETURN (TYPE("_SCREEN.ActiveForm") == "O" AND ;
			UPPER(_SCREEN.ACTIVEFORM.BASECLASS) = "FORM")
	ELSE
		RETURN (TYPE("_SCREEN.ActiveForm") == "O" AND ;
			UPPER(_SCREEN.ACTIVEFORM.BASECLASS) = "FORM" ;
			AND UPPER(NameForm) == UPPER(_SCREEN.ACTIVEFORM.NAME))
	ENDIF
ENDFUNC

  
FUNCTION cKbLayOut
  LPARAMETERS lnNeedKeyboard  

  #DEFINE KEYBOARD_GERMAN_ST 	0x0407		&& �������� (��������)  
  #DEFINE KEYBOARD_ENGLISH_US 	0x0409		&& ���������� (����������� �����)  
  #DEFINE KEYBOARD_FRENCH_ST 	0x040c		&& ����������� (��������)  
  #DEFINE KEYBOARD_RUSSIAN 		0x0419		&& �������  
    
 * ������ ������� ��������� ����������  
  DECLARE INTEGER GetKeyboardLayout IN Win32API Integer  
  LOCAL lnCurrentKeyboard  
  lnCurrentKeyboard = GetKeyboardLayout(0)  
 * ��������� ������� ����� (������� 16 ��� �� 32)  
  lnCurrentKeyboard = BitRShift(m.lnCurrentKeyboard,16)  
    
 * ���� ������� ��������� ������� �� ������  
  IF m.lnCurrentKeyboard <> m.lnNeedKeyboard  
 	* ������� �������� ������ �������������� ������ ���������  
  	DECLARE INTEGER ActivateKeyboardLayout IN Win32API Integer, Integer  
  	LOCAL lnNewKeyboard  
  	lnNewKeyboard = ActivateKeyboardLayout(m.lnNeedKeyboard,0)  
    
  	IF m.lnNewKeyboard=0  
 		* ������ ��������� ���������� �� ������� � ������ �������������� ���������  
 		* ��������� ������ ���������  
  		DECLARE INTEGER LoadKeyboardLayout IN Win32API String, Integer  
 		* ��� ������ ��������� ���� ���������������� � ������ ���� "00000419"  
 		* �.�. ������ �� 8 ��������, ��� ������ 4 - ��� ����, � ��������� 4 ��� � 16-������ �������  
  		LOCAL lcNeedKeyboard  
  		lcNeedKeyboard = RIGHT(TRANSFORM(m.lnNeedKeyboard,"@0"),8)  
 		* ���������� ��������  
  		m.lnNewKeyboard = LoadKeyboardLayout(m.lcNeedKeyboard,1)  
 		* ��������� ������� ����� (������� 16 ��� �� 32)  
  		m.lnNewKeyboard = BitRShift(m.lnNewKeyboard,16)  
  		IF m.lnNewKeyboard <> m.lnNeedKeyboard  
 			* ��������� ������ ��������� �� �������  
  		ENDIF  
  	ENDIF  
  ENDIF
RETURN

FUNCTION whatKb
  #DEFINE KEYBOARD_GERMAN_ST 	0x0407		&& �������� (��������)  
  #DEFINE KEYBOARD_ENGLISH_US 	0x0409		&& ���������� (����������� �����)  
  #DEFINE KEYBOARD_FRENCH_ST 	0x040c		&& ����������� (��������)  
  #DEFINE KEYBOARD_RUSSIAN 		0x0419		&& �������  

 * ������ ������� ��������� ����������  
  DECLARE INTEGER GetKeyboardLayout IN Win32API Integer  
  LOCAL lnCurrentKeyboard  
  lnCurrentKeyboard = GetKeyboardLayout(0)  
 * ��������� ������� ����� (������� 16 ��� �� 32)  
  lnCurrentKeyboard = BitRShift(m.lnCurrentKeyboard,16)  
    
RETURN lnCurrentKeyboard


FUNCTION IsKms
	PARAMETERS tcPolis
	IsAllDig = .t.
	FOR i=1 TO 6 && ��� �� ������ ����� �������� - �����?
		tnPar = SUBSTR(tcPolis,i,1)
		IF ISDIGIT(tnPar)
		ELSE 
			IsAllDig = .f.
			EXIT 
		ENDIF 
	ENDFOR 
	IF IsAllDig = .f.
		RETURN .f.
	ENDIF 
	IF !(SUBSTR(tcPolis,1,2) == '77' AND (BETWEEN(VAL(SUBSTR(tcPolis,3,2)), 0, 27) OR INLIST(VAL(SUBSTR(tcPolis,3,2)),45,73,77,99,50,51,52)) AND ;
		BETWEEN(VAL(SUBSTR(tcPolis,5,2)), 0, 99))
		RETURN .f. 	
	ENDIF 
RETURN .t. 

FUNCTION IsPolis94
	PARAMETERS tcPolis
	IF !(SUBSTR(tcPolis,1,2) == '77' AND INLIST(SUBSTR(tcPolis,3,2),"01","02","03","04","05","06","07","08","09","10") ;
		AND INLIST(Upper(EngToRus(SUBSTR(tcPolis,5,1))), '�', '�', '�'))
		RETURN .f.
	ENDIF
RETURN .t.

FUNCTION IsListR
	PARAMETERS tcPolis
	IF !(INLIST(UPPER(RusToEng(SUBSTR(tcPolis,1,2))), ;
		'I1', 'M1', 'M4', 'M6', 'R2', 'S2', 'S5', 'V2', 'P2','R4'))
		RETURN .f.
	ENDIF 
RETURN .t.

FUNCTION IsOblPolis
	PARAMETERS tcPolis
	IF !(LEFT(tcPolis,3)=='46-' AND BETWEEN(VAL(SUBSTR(tcPolis,4,2)),1,50))
		RETURN .f.
	ENDIF 
RETURN .t.


Func SndWait
 Para BFile, EFile, DFile, Regim, lcUser
 lcUser = IIF(EMPTY(lcUser) ,m.User, lcUser)
 Regim = iif(Empty(Regim),0,1)
 Push Key Clea
 Set Escape On
 On Escape Do StopScan
 StopIt = .t.

 Do While File('&PAisOms\&lcUser\OutPut\&BFile') And StopIt
  Wait iif(Regim=0, "�������� �������� ��...", "�������� ��...") Wind Nowa  
 EndD

 On  Escape
 Set Escape Off
 Pop Key
 
  Do Case 
   Case !StopIt
    dele file &PAisOms\&lcUser\OutPut\&BFile
    dele file &PAisOms\&lcUser\OutPut\&DFile
    wait " �������� "+iif(Regim=0,"�������� ",'')+"��������! " wind nowa
    retu .f.
   Othe
    Do Case
     case file('&PAisOms\&lcUser\OutPut\&EFile')
      dele file &PAisOms\&lcUser\OutPut\&EFile
      dele file &PAisOms\&lcUser\OutPut\&DFile
      wait " ���������� ��������� ��! " wind nowa
      retu .f.
     case !file('&PAisOms\&lcUser\OutPut\&DFile')
      retu .t.
     Other
      wait "������������� ��������!" wind nowa
      retu .f.
    EndC
  EndC

PROCEDURE  StopScan
 Flag = MESSAGEBOX("���������� �������� ������?",4+48,"��������!")
 IF Flag == 6
  StopIt = .f.
 ELSE
  StopIt =  .t.
 ENDIF
RETURN
 

PROCEDURE StopScan2
Flag = MESSAGEBOX("���������� �������� ������?",4+48,"��������!")
IF Flag == 6
 StopIt = .f.
ELSE
 StopIt = .t.
ENDIF
RETURN 

Func ScanDir
 Para par0, par1, par2, par3
 
 par0 = allt(par0)
 par1 = allt(par1)
 par2 = allt(par2)
 par3 = allt(par3)

 * par0 - ���������� ������������ 
 * par1 - �������� 1-�� �����
 * par2 - Subject  1-�� �����
 * par3 - Resent-Message-Id 1-�� �����

 ikl = .f.
    
  _name = sys(2000, par0+'\'+par1)
  poi = fopen(par0+'\'+_name)
  if poi != -1
   x = ''
   =fseek(poi,0) && �������  � ������ �����
   do while !feof(poi)
    x=allt(fgets(poi))
    if iif(!empty(par2), x = 'Subject' and allt(subs(x, at(':',x)+1)) = par2, 1=1)
     =fseek(poi,0) && �������  � ������ �����
     if !empty(par3)
      y = ''
      do while !feof(poi)
       y=allt(fgets(poi))
       if y = 'Resent-Message-Id' and allt(subs(y, at(':',y)+1)) = par3
        wait "��������� ���� " + lower(_name) + " � ��������� �����������!" wind time 1
        =fclos(poi)
        retu _name
       else
       endi
      endd
     else
      =fseek(poi,0) && �������  � ������ �����
      y    = ''
      rmid = ''
      do while !feof(poi)
       y = allt(fgets(poi))
       if y = 'Resent-Message-Id'
        rmid = allt(subs(y, at(':',y)+1))
       else
       endi
      endd
      if empty(rmid)
       wait "��������� ���� " + lower(_name) wind time 1
       =fclos(poi)
       retu _name
      Else
       wait "��������� ���� " + lower(_name) wind time 1
       =fclos(poi)
       retu _name
      endi
     endi
    else
    endi
   endd
   =fclos(poi)
  else
  endi

  _name = sys(2000, par0+'\'+par1, 1)
  poi = fopen(par0+'\'+_name)
  do while  poi != -1
   x = ''
   =fseek(poi,0) && �������  � ������ �����
   do while !feof(poi)
    x=allt(fgets(poi))
    if iif(!empty(par2), x = 'Subject' and allt(subs(x, at(':',x)+1)) = par2, 1=1)
     =fseek(poi,0) && �������  � ������ �����
     if !empty(par3)
      y = ''
      do while !feof(poi)
       y=allt(fgets(poi))
       if y = 'Resent-Message-Id' and allt(subs(y, at(':',y)+1)) = par3
        wait "��������� ���� " + lower(_name) + "� ��������� �����������!" wind time 1
        =fclos(poi)
        retu _name
       else
       endi
      endd
     else
      =fseek(poi,0) && �������  � ������ �����
      y    = ''
      rmid = ''
      do while !feof(poi)
       y = allt(fgets(poi))
       if y = 'Resent-Message-Id'
        rmid = allt(subs(y, at(':',y)+1))
       else
       endi
      endd
      if empty(rmid)
       wait "��������� ���� " + lower(_name) wind time 1
       =fclos(poi)
       retu _name
      Else
       wait "��������� ���� " + lower(_name) wind time 1
       =fclos(poi)
       retu _name
      endi
     endi
    else
    endi
   endd
   =fclos(poi)
   _name = sys(2000, par0+'\'+par1, 1)
   poi = fopen(par0+'\'+_name)
  endd
  =fclos(poi)

Retu ''

FUNCTION TransKms
 LPARAMETERS tPolis, nVozvrat
 tPolis = ALLTRIM(tPolis)
 nVozvrat = IIF(EMPTY(nVozvrat), 1, nVozvrat)
 Pps   = LEFT(tPolis,6)
 Ppn   = INT(VAL(SUBSTR(tPolis,7)))
 IF BETWEEN(ppn, 1, 9999999999) AND chk_nkms(PADL(Ppn,10,'0')) 
  tPolis = Pps + ' ' +PADL(Ppn,10,'0')
*  tPolis = IIF(nVozvrat = 2, '', tPolis)
  RETURN PADR(ALLTRIM(tPolis),17)
 ELSE 
  MESSAGEBOX('�������� ���!',0+16,'������ � ���!')
  RETURN ''
 ENDIF 

FUNCTION TransENP
 LPARAMETERS tPolis, nVozvrat
 tPolis = ALLTRIM(tPolis)
 nVozvrat = IIF(EMPTY(nVozvrat), 1, nVozvrat)
 Pps   = LEFT(tPolis,6)
 Ppn   = INT(VAL(SUBSTR(tPolis,7)))
 IF BETWEEN(ppn, 1, 9999999999) AND chk_nenp(ALLTRIM(SUBSTR(tPolis,7)))
  tPolis = Pps + Padl(Ppn,10,'0')
 ELSE
  WAIT WINDOW "������ � ������ ���!" NOWAIT 
 ENDIF 
 tPolis = IIF(nVozvrat = 2, '', tPolis)
RETURN PADR(ALLTRIM(tPolis),17)

FUNCTION TransVS
 LPARAMETERS tPolis, nVozvrat
RETURN tPolis

FUNCTION chk_ogrn
PARAMETERS lvOGRN, tcOGRN

DO CASE 
 CASE VARTYPE(lvOGRN) = 'N'
  tcOGRN = PADL(lvOGRN,10)
 CASE VARTYPE(lvOGRN) = 'C'
  tcOGRN=PADL(ALLTRIM(lvOGRN),13)
 OTHERWISE 
  RETURN .f. 
ENDCASE

prt1 = INT(VAL(SUBSTR(tcOGRN,1,12)))
prt2 = INT(VAL(SUBSTR(tcOGRN,13,1)))
ttt = IIF(MOD(prt1,11)<10, MOD(prt1,11), 0)

IF ttt == prt2
 RETURN .t.
ELSE
 RETURN .f.
ENDIF 
 
RETURN .t.

DO CASE 
	CASE VARTYPE(lnENP) = 'N'
		lcENP = STRTRAN(STR(lnENP,16,0),' ','0')
	CASE VARTYPE(lnENP) = 'C'
		lcENP = PADL(ALLTRIM(lnENP),16,'0')
	OTHERWISE
		lcENP = STRTRAN(SPACE(16),' ','0')
ENDCASE

VLast = RIGHT(lcENP,1)
V2 = LEFT(lcENP,LEN(lcENP)-1)

VA1 = ''
VB1 = ''

lMod = MOD(LEN(V2),2)

IF lMod = 1
	lModa = 0
	lModb = -1
ELSE
	lModb = 0
	lModa = -1
ENDIF

FOR NPos = LEN(V2) + lModa TO 1 STEP -2
	VA1 = VA1 + SUBSTR(V2,NPos,1)
ENDFOR

FOR NPos = LEN(V2) + lModb TO 1 STEP -2
	VB1 = VB1 + SUBSTR(V2,NPos,1)
ENDFOR

VA = ALLTRIM(STR(INT(VAL(VA1)) * 2))
VBA = VB1 + VA

VC = 0
FOR NPos = 1 TO LEN(VBA)
	VC = VC + VAL(SUBSTR(VBA,NPos,1))
ENDFOR

VD = (CEILING(VC/10) * 10) - VC

IF NOT VD = VAL(VLast)
	RETURN (.T.)
ELSE
	RETURN (.F.)
ENDIF

FUNCTION chk_snils
 PARAMETERS lcSNILS && XXX-XXX-XXX YY ������ �����, ��� YY - ����������� �����
 tcSNILS = ALLTRIM(STRTRAN(SUBSTR(lcSNILS,1,11),'-',''))
 tnKC = INT(VAL(SUBSTR(lcSNILS,13,2)))
 
 IF EMPTY(lcSNILS)
  RETURN .t.
 ENDIF 

 IF VAL(tcSNILS) <= 1001998 && ��� ������� �������� �� �� �� �����������!
 ELSE
  tn_rslt = 0
  FOR npos=1 TO 9
   tn_rslt = tn_rslt + VAL(SUBSTR(tcSNILS,npos,1)) * (10-npos)
  ENDFOR 
  DO CASE 
   CASE tn_rslt < 100
    IF tn_rslt==tnKC
     RETURN .t.
    ELSE 
     RETURN .f. 
    ENDIF 
   CASE INLIST(tn_rslt, 100, 101)
    IF tnKC==0
     RETURN .t.
    ELSE 
     RETURN .f. 
    ENDIF 
   CASE tn_rslt > 101
    DO WHILE tn_rslt >= 102
     tn_rslt = tn_rslt - 101
    ENDDO 
    IF tn_rslt < 100
     IF tn_rslt==tnKC
      RETURN .t.
     ELSE 
      RETURN .f. 
     ENDIF 
    ELSE
     IF tnKC==0
      RETURN .t.
     ELSE 
      RETURN .f. 
     ENDIF 
    ENDIF 
   OTHERWISE 
    RETURN .f. 
  ENDCASE 
 ENDIF 

FUNCTION MakeZip(tcPath)
 poi = FCREATE(tcPath)
 IF poi != -1
  =FWRITE(poi, CHR(80))
  =FWRITE(poi, CHR(75))
  =FWRITE(poi, CHR(5))
  =FWRITE(poi, CHR(6))
  FOR iii = 1 TO 18
   =FWRITE(poi, CHR(0))
  ENDFOR 
 ENDIF 
 =FCLOSE(poi)
RETURN 

FUNCTION PutCodePage
parameter tcFileName,tnCodePage,tlCodePage1251

if not file(tcFileName)
	return
endif

if not vartype(tnCodePage) = 'N' and not inlist(tnCodePage,0,866,1251)
	return
else
	do case
	 	CASE tnCodePage = 0
	 	    lnCodePage = 0
		case tnCodePage = 866
			lnCodePage = 101
		case tnCodePage = 1251
			lnCodePage = 201
	endcase
endif

lnOpen = fopen(tcFileName,2)

IF lnOpen > 0
	= fseek(lnOpen,29)
	lcCurrentCodePage = fread(lnOpen,1)
	if asc(lcCurrentCodePage) = 0 or (asc(lcCurrentCodePage) = 201 and tlCodePage1251)
		= fseek(lnOpen,-1,1)
		= fwrite(lnOpen,CHR(lnCodePage))
	endif
	= fclose(lnOpen)
ENDIF

FUNCTION IsKms(tcPolis)
 IF LEN(ALLTRIM(tcPolis))!=17
  RETURN .f. 
 ENDIF 
 IF SUBSTR(tcPolis,7,1)!=' '
  RETURN .f.
 ENDIF 
 IF LEFT(tcPolis,2)!='77'
  RETURN .f.
 ENDIF 
 IF !ISDIGIT(SUBSTR(tcPolis,3,1)) OR !ISDIGIT(SUBSTR(tcPolis,4,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,5,1)) OR !ISDIGIT(SUBSTR(tcPolis,6,1))
  RETURN .f.
 ENDIF 
 IF !BETWEEN(VAL(SUBSTR(tcPolis,3,2)),0,99)
  RETURN .f.
 ENDIF 
 IF !BETWEEN(VAL(SUBSTR(tcPolis,5,2)),0,27) AND !INLIST(VAL(SUBSTR(tcPolis,5,2)),45,50,51,52,73,77,99)
  RETURN .f.
 ENDIF 
 IF !ISDIGIT(SUBSTR(tcPolis,8,1)) OR !ISDIGIT(SUBSTR(tcPolis,9,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,10,1)) OR !ISDIGIT(SUBSTR(tcPolis,11,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,12,1)) OR !ISDIGIT(SUBSTR(tcPolis,13,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,14,1)) OR !ISDIGIT(SUBSTR(tcPolis,15,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,16,1)) OR !ISDIGIT(SUBSTR(tcPolis,17,1))
  RETURN .f.
 ENDIF 
 IF !chk_nkms(SUBSTR(tcPolis,8,10))  
  RETURN .f.
 ENDIF 
RETURN .t. 

FUNCTION IsVs(tcPolis)
 IF LEN(ALLTRIM(tcPolis))!=14
  RETURN .f. 
 ENDIF 
 IF SUBSTR(tcPolis,6,1)!=' '
  RETURN .f.
 ENDIF 
 IF !INLIST(LEFT(tcPolis,2), 'I1','M1','M4','R2','S2','S5','R4','P2','I3','P3','S6','S7')
  RETURN .f.
 ENDIF 
 IF !ISDIGIT(SUBSTR(tcPolis,3,1)) OR !ISDIGIT(SUBSTR(tcPolis,4,1)) OR !ISDIGIT(SUBSTR(tcPolis,5,1))
  RETURN .f.
 ENDIF 
 IF !ISDIGIT(SUBSTR(tcPolis,7,1))  OR !ISDIGIT(SUBSTR(tcPolis,8,1))  OR ;
    !ISDIGIT(SUBSTR(tcPolis,9,1))  OR !ISDIGIT(SUBSTR(tcPolis,10,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,11,1)) OR !ISDIGIT(SUBSTR(tcPolis,12,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,13,1)) OR !ISDIGIT(SUBSTR(tcPolis,14,1))
  RETURN .f.
 ENDIF  
RETURN .t. 

FUNCTION IsENP(tcPolis)
 IF LEN(ALLTRIM(tcPolis))!=16
  RETURN .f. 
 ENDIF 
 IF !ISDIGIT(SUBSTR(tcPolis,1,1))  OR !ISDIGIT(SUBSTR(tcPolis,2,1))  OR ;
    !ISDIGIT(SUBSTR(tcPolis,3,1))  OR !ISDIGIT(SUBSTR(tcPolis,4,1))  OR ;
    !ISDIGIT(SUBSTR(tcPolis,5,1))  OR !ISDIGIT(SUBSTR(tcPolis,6,1))  OR ;
    !ISDIGIT(SUBSTR(tcPolis,7,1))  OR !ISDIGIT(SUBSTR(tcPolis,8,1))  OR ;
    !ISDIGIT(SUBSTR(tcPolis,9,1))  OR !ISDIGIT(SUBSTR(tcPolis,10,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,11,1)) OR !ISDIGIT(SUBSTR(tcPolis,12,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,13,1)) OR !ISDIGIT(SUBSTR(tcPolis,14,1)) OR ;
    !ISDIGIT(SUBSTR(tcPolis,15,1)) OR !ISDIGIT(SUBSTR(tcPolis,16,1))
  RETURN .f.
 ENDIF  
* IF chk_nenp(SUBSTR(tcPolis,7,10))
*  RETURN .f.
* ENDIF 
RETURN .t.

FUNCTION NameOfMonth
 PARAMETERS nmonth
 DO CASE 
  CASE nmonth == 1
   MonName = '������'
  CASE nmonth == 2
   MonName = '�������'
  CASE nmonth == 3
   MonName = '����'
  CASE nmonth == 4
   MonName = '������'
  CASE nmonth == 5
   MonName = '���'
  CASE nmonth == 6
   MonName = '����'
  CASE nmonth == 7
   MonName = '����'
  CASE nmonth == 8
   MonName = '������'
  CASE nmonth == 9
   MonName = '��������'
  CASE nmonth == 10
   MonName = '�������'
  CASE nmonth == 11
   MonName = '������'
  CASE nmonth == 12
   MonName = '�������'
  OTHERWISE 
   MonName = ''
 ENDCASE 
RETURN MonName

FUNCTION NameOfMonth2
 PARAMETERS nmonth
 DO CASE 
  CASE nmonth == 1
   MonName = '������'
  CASE nmonth == 2
   MonName = '�������'
  CASE nmonth == 3
   MonName = '�����'
  CASE nmonth == 4
   MonName = '������'
  CASE nmonth == 5
   MonName = '���'
  CASE nmonth == 6
   MonName = '����'
  CASE nmonth == 7
   MonName = '����'
  CASE nmonth == 8
   MonName = '�������'
  CASE nmonth == 9
   MonName = '��������'
  CASE nmonth == 10
   MonName = '�������'
  CASE nmonth == 11
   MonName = '������'
  CASE nmonth == 12
   MonName = '�������'
  OTHERWISE 
   MonName = ''
 ENDCASE 
RETURN MonName

PROCEDURE DelUnDel
 IF DELETED()
  RECALL 
 ELSE 
  DELETE 
 ENDIF 
RETURN 

*Definition of control class:

*  ITabletEvents = dispinterface
*    ['{2000C72A-E338-477E-B359-D6D00006D29E}']
*    procedure onGetReportException(const pException: ITabletEventsException); dispid 6913;
*    procedure onUnhandledReportData(pData: {??PSafeArray}OleVariant); dispid 6914;
*    procedure onPenData(const pPenData: IPenData); dispid 6915;
*    procedure onPenDataOption(const pPenDataOption: IPenDataOption); dispid 6916;
*    procedure onPenDataEncrypted(const pPenDataEncrypted: IPenDataEncrypted); dispid 6917;
*    procedure onPenDataEncryptedOption(const pPenDataEncryptedOption: IPenDataEncryptedOption); dispid 6918;
*    procedure onDevicePublicKey(pDevicePublicKey: {??PSafeArray}OleVariant); dispid 6919;
*  end;

DEFINE CLASS Ctrl as Session 
 *The IMPLEMENTS... line below is what makes Foxpro take control over the SendPercentDone,
 *ReadPercentDone and AbortCheck
 *NOTE - This path part of the IMPLEMENTS must point to the dll, so locate and correct it
 *before you are using the program.

 IMPLEMENTS ITabletEvents IN "wgssSTU.dll"

 rdy      = .f.
 sw       = 0 
 pressure = 0
 x        = 0
 y        = 0

 
 PROCEDURE Init
 ENDPROC 
 
 PROCEDURE ITabletEvents_onGetReportException(pException) AS VOID ;
  HELPSTRING "onGetReportException"
 ENDPROC 

 PROCEDURE ITabletEvents_onUnhandledReportData(pData) AS VOID ;
  HELPSTRING "onUnhandledReportData"
 ENDPROC 

 PROCEDURE ITabletEvents_onPenData(pPenData as Object) AS VOID ;
  HELPSTRING "onPenData"
  EXTERNAL ARRAY apoint
  this.rdy = pPenData.rdy
  this.sw  = pPendata.sw
  this.pressure = pPenData.pressure
  this.x = pPendata.x
  this.y = pPenData.y
  m.nrows = ALEN(apoint,1)
*  IF pPenData.pressure>0
  DIMENSION apoint (m.nrows+1,4) as Integer 
  apoint(m.nrows+1,1) = pPendata.x
  apoint(m.nrows+1,2) = pPenData.y
  apoint(m.nrows+1,3) = pPenData.pressure
  apoint(m.nrows+1,4) = pPenData.sw
*  WAIT "onPenData..."+STR(pPenData.sw) WINDOW NOWAIT 
*  ENDIF 
 ENDPROC 

 PROCEDURE ITabletEvents_onPenDataOption(pPenDataOption) AS VOID ;
  HELPSTRING "onPenDataOption"
 ENDPROC 

 PROCEDURE ITabletEvents_onPenDataEncrypted(pPenDataEncrypted) AS VOID ;
  HELPSTRING "onPenDataEncrypted"
 ENDPROC 

 PROCEDURE ITabletEvents_onPenDataEncryptedOption(pPenDataEncryptedOption) AS VOID ;
  HELPSTRING "onPenDataEncryptedOption"
 ENDPROC 

 PROCEDURE ITabletEvents_onDevicePublicKey(pDevicePublicKey) AS VOID ;
  HELPSTRING "onDevicePublicKey"
 ENDPROC 
 
 PROCEDURE destroy 
 ENDPROC 

ENDDEFINE 
