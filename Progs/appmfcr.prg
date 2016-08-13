PROCEDURE AppMfcR
 IF MESSAGEBOX('��������� ����� ������ ���?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
  m.lppath = pBase
  m.kol_pv = 1
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
 ENDIF 

 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('����������� ���� PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('����������� ���� MFC_PV.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 IF !fso.FolderExists(pMFC)
  fso.CreateFolder(pMFC)
  MESSAGEBOX(CHR(13)+CHR(10)+'���-������ �� ����������!',0+64,'')
  RETURN 
 ENDIF 
 
 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pMFC)
 EFile = GETFILE('dbf','','',0,'������ �� ����!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(EFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'�� ������ �� �������!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ELSE 
  MESSAGEBOX('�� ������� '+m.efile+CHR(13)+CHR(10),0+48,'')
 ENDIF 
 
 IF OpenFile(m.EFile, 'efile', 'excl')>0
  IF USED('efile')
   USE IN efile
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT efile
 IF FIELD('enp')!='ENP'
  MESSAGEBOX('� ��������� ����� ��� ���� ENP!'+CHR(13)+CHR(10),0+48,'')
  USE 
  RETURN 
 ENDIF 
 IF FIELD('vsn')!='VSN'
  MESSAGEBOX('� ��������� ����� ��� ���� VSN!'+CHR(13)+CHR(10),0+48,'')
  USE 
  RETURN 
 ENDIF 
 IF FIELD('date_v')!='DATE_V'
  MESSAGEBOX('� ��������� ����� ��� ���� DATE_V!'+CHR(13)+CHR(10),0+48,'')
  USE 
  RETURN 
 ENDIF 

 IF FIELD('pv')='PV'
  IF MESSAGEBOX('���� ������������� �����.'+CHR(13)+CHR(10)+'��������� ���������?'+CHR(13)+CHR(10),4+32,'')=6 && Yes!
   REPLACE ALL pv WITH ''
  ELSE 
   USE 
   RETURN 
  ENDIF 
 ELSE 
  ALTER TABLE efile ADD COLUMN pv c(3)
 ENDIF 

 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'

  m.lppath = pBase
  m.kol_pv = 1

  t_beg = SECONDS()
 
  IF !fso.FileExists(pbase+'\kms.dbf')
   USE IN efile
   RETURN 
  ENDIF 
  IF OpenFile(pbase+'\kms', 'kms', 'shar', 'vs')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
   USE IN efile
   RETURN 
  ENDIF 
  
  WAIT m.pvv WINDOW NOWAIT 
   
  SELECT efile
  SCAN 
   m.vs  = vsn
   m.enp = enp
   m.dp  = date_v
 
   m.pv  = ''

   IF SEEK(m.vs, 'kms')
    m.pv = m.pvv
    REPLACE pv WITH m.pv
    SELECT kms
    IF m.qcod!='S6'
     REPLACE jt WITH 'r', scn WITH 'POK', dp WITH m.dp, pricin WITH '', tranz WITH '', status WITH 3
    ELSE 
     REPLACE dpok WITH m.dp, status WITH 6
    ENDIF 
    SELECT efile
    LOOP 
   ENDIF 

  ENDSCAN 
  
  USE IN kms
  
  WAIT CLEAR 

  t_end = SECONDS()
  t_last = ROUND((t_end - t_beg)/60,2)

 ELSE && IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
 
  m.lppath = pBase+'\'+pvid(1,1)

  IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
   IF USED('efile')
    USE IN efile
   ENDIF 
   IF USED('pvp2')
    USE IN pvp2
   ENDIF 
   RETURN 
  ENDIF 
  IF OpenFile(pbin+'\mfc_pv', 'mfcpv', 'shar', 'pv')>0
   IF USED('efile')
    USE IN efile
   ENDIF 
   IF USED('pvp2')
    USE IN pvp2
   ENDIF 
   IF USED('mfcpv')
    USE IN mfcpv
   ENDIF 
   RETURN 
  ENDIF 
 
  t_beg = SECONDS()
 
  SELECT pvp2
  SET RELATION TO codpv INTO mfcpv
  SCAN 
*   IF EMPTY(mfcpv.pv)
*    LOOP 
*   ENDIF 
   m.pvv = codpv
   IF !fso.FolderExists(pbase+'\'+m.pvv)
    LOOP 
   ENDIF 
   IF !fso.FileExists(pbase+'\'+m.pvv+'\kms.dbf')
    LOOP 
   ENDIF 
   IF OpenFile(pbase+'\'+m.pvv+'\kms', 'kms', 'shar', 'vs')>0
    IF USED('kms')
     USE IN kms
    ENDIF 
    SELECT pvp2
    LOOP
   ENDIF 
  
   WAIT m.pvv WINDOW NOWAIT 
   
   SELECT efile
   SCAN 
    m.vs  = vsn
    m.enp = enp
    m.dp  = date_v
  
    m.pv  = ''

    IF SEEK(m.vs, 'kms')
     m.pv = m.pvv
     REPLACE pv WITH m.pv
     SELECT kms
     IF m.qcod!='S6'
      REPLACE jt WITH 'r', scn WITH 'POK', dp WITH m.dp, pricin WITH '', tranz WITH '', status WITH 3
     ELSE 
      REPLACE dpok WITH m.dp, status WITH 6
     ENDIF 
     SELECT efile
     LOOP 
    ENDIF 

   ENDSCAN 
  
   USE IN kms
  
   WAIT CLEAR 

  ENDSCAN 
 
  t_end = SECONDS()
  t_last = ROUND((t_end - t_beg)/60,2)

  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  IF USED('mfcpv')
   USE IN mfcpv
  ENDIF 

 ENDIF 

 USE IN efile

 MESSAGEBOX('����� ��������� '+TRANSFORM(t_last,'99999.99'),0+64,'')

RETURN 

