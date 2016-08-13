PROCEDURE RepVsNoEnp
 IF !fso.FileExists(pbin+'\Reports\RepVsStat.frx')
  MESSAGEBOX(CHR(13)+CHR(10)+'���������� ���� ������'+CHR(13)+CHR(10)+;
   pbin+'\Reports\RepVsStat.frx', 0+16, '')
  RETURN 
 ENDIF 

 IF MESSAGEBOX(CHR(13)+CHR(10)+'�� ������ ������������ �����'+CHR(13)+CHR(10)+;
  '�� �������� ��������� ��������������?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 
 IF kol_pv!=1
  MESSAGEBOX(CHR(13)+CHR(10)+'������� ����� ������ ������!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 IF !fso.FolderExists(pbase+'\'+pvid(1,1))
  MESSAGEBOX(CHR(13)+CHR(10)+'����������� ���������� ��!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\kms.dbf')
  MESSAGEBOX(CHR(13)+CHR(10)+'����������� ���� KMS.DBF!'+CHR(13)+CHR(10),0+16,PVID(1,1))
  RETURN 
 ENDIF 
 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
 ENDIF 

 SELECT pv AS pv, SPACE(25) as pvname, coun(*) as k_u FROM kms ;
 	WHERE !EMPTY(vs) AND EMPTY(enp) ;
 	GROUP BY pv INTO CURSOR pvsvd READWRITE 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF
 ELSE 
  SELECT * FROM pvp2 INTO CURSOR curpv READWRITE 
  SELECT curpv
  INDEX on codpv TAG codpv
  SET ORDER TO codpv
  
  SELECT pvsvd
  SET RELATION TO pv INTO curpv
  REPLACE ALL pvname WITH curpv.name_pv
  SET RELATION OFF INTO curpv
  
  SELECT curpv
  SET ORDER TO 
  USE
  
 ENDIF 
 
 USE IN kms
 IF USED('pvp2')
  USE IN pvp2
 ENDIF
 
 SELECT pvsvd
 REPORT FORM RepVsStat PREVIEW  
 USE 
 
RETURN 