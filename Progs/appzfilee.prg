PROCEDURE AppZFileE && �������� ������� �� ������������

 IF MESSAGEBOX('�� ������ ��������� �����'+CHR(13)+CHR(10)+;
  '���������� �� ������������ �������?'+CHR(13)+CHR(10)+;
  '(Z-�����)',4+32,'')=7
  RETURN 
 ENDIF 

 IF !fso.FileExists(pbase+'\kms.dbf')
  MESSAGEBOX('����������� ���� BASE\KMS.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\moves.dbf')
  MESSAGEBOX('����������� ���� BASE\MOVES.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 

 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 FFile = GETFILE('zip','','',0,'�������� ����:')
 SET DEFAULT TO (oal)
 
 IF EMPTY(ffile)
  MESSAGEBOX(CHR(13)+CHR(10)+'�� ������ �� �������!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ENDIF 

 offile = fso.GetFile(ffile)
 IF offile.size >= 2
  fhandl = offile.OpenAsTextStream
  lcHead = fhandl.Read(2)
  fhandl.Close
 ELSE 
  lcHead = ''
 ENDIF 

 IF lcHead != 'PK' && ��� zip-����!
  MESSAGEBOX('��� �� ZIP-�����!',0+64,'')
  RETURN 
 ENDIF 
 
 ShortName = UPPER(offile.name)
 PeriodDir = '201' + SUBSTR(ShortName,5,5)
 
 UnzipOpen(FFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'����� �� �������� �� ������ �����!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' ������ � ������!',0+64,'')
 ENDIF 

 IF OpenFile(pbase+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\moves', 'moves', 'shar', 'unik')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('moves')
   USE IN moves
  ENDIF 
  RETURN 
 ENDIF 

 LOCAL m.nFFileRecCount
 m.nFFileRecCount = 0

 IF UnzipOpen(FFile)==.T.
  DIMENSION ZipArray(13)
  CREATE CURSOR CursZip (FFile c(25))
  ZipArray = ''
  UnZipGotoTopFile()
  FOR FileInZip=0 TO FilesInZip-1
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))
   PeriodDir = '201' + SUBSTR(m.FileInZipName,4,5)
   UnzipSetFolder(pOut+'\'+PeriodDir)
   IF !fso.FolderExists(pOut+'\'+PeriodDir)
    fso.CreateFolder(pOut+'\'+PeriodDir)
   ENDIF 
   IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileInZipName)
    fso.DeleteFile(pOut+'\'+PeriodDir+'\'+m.FileInZipName)
   ENDIF 
   UnzipByIndex(FileInZip)

   INSERT INTO CursZip (FFile) VALUES (m.FileInZipName)
   
   UnzipGotoNextFile()
  ENDFOR  
  UnzipClose()
 ELSE 
  MESSAGEBOX('�� ������� ������� ����'+CHR(13)+CHR(10)+FFILE,0+64,'')
  RETURN 
 ENDIF 

 CREATE CURSOR curappgz (nrec n(5),pv c(3), vs c(9), fam c(25), im c(20), ot c(20), w n(1), dr d, enp c(16), isfnd l)

 SELECT CursZip
 SCAN
  m.FileName = ALLTRIM(FFile)
  PeriodDir = '201' + SUBSTR(m.FileName,4,5)
  IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileName)
   =OneAppZFile(m.FileName)
   SELECT CursZip
  ENDIF  
 ENDSCAN 
 USE 
 
 IF USED('kms')
  USE IN kms
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 

 SELECT curappgz
 IF RECCOUNT()>0
  REPORT FORM AppZFile PREVIEW 
 ENDIF 
 USE 

RETURN 

FUNCTION OneAppZFile(flname)
 LOCAL m.nFFileRecCount
 m.nFFileRecCount = 0

 PeriodDir = '201' + SUBSTR(flname,4,5)
 ppath = pOut+'\'+PeriodDir
 
 IF OpenFile(ppath+'\'+flname, 'FondFile', 'shar')>0
  IF USED('FondFile')
   USE IN FondFile
  ENDIF 
  RETURN 
 ENDIF 
 m.nFFileRecCount = RECCOUNT('FondFile')
 
 SELECT FondFile
 INDEX ON vsn TAG vsn
 SET ORDER TO vsn
	
 SELECT kms
 SET RELATION TO vs INTO FondFile
 COUNT FOR !EMPTY(FondFile.enp) TO m.Related
 
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX('���� '+m.flname+CHR(13)+CHR(10)+;
   ' �� �������� � ������ KMS.DBF!'+CHR(13)+CHR(10)+;
    '���� '+m.flname+' �� ��������������!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO FondFile
   SELECT FondFile
   SET ORDER TO 
   USE 
   RETURN 

  CASE m.Related == nFFileRecCount && ��� ��!
*    MESSAGEBOX('���� '+m.flname+CHR(13)+CHR(10)+;
     '�������� � ������ KMS.DBF ��!'+CHR(13)+CHR(10)+;
     '���� '+m.flname+' ��������������!'+CHR(13)+CHR(10),0+64,'')

  CASE m.Related != nFFileRecCount
    IF MESSAGEBOX('���� '+m.flname+CHR(13)+CHR(10)+;
     '�������� � ������ KMS.DBF ��������!'+CHR(13)+CHR(10)+ ;
     "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nFFileRecCount))+ ")" + CHR(13) + CHR(10)+;
     "���������� ��������� ����� "+m.flname+"?",4+32,'') = 7 
     SET RELATION OFF INTO FondFile
     SELECT FondFile
     SET ORDER TO 
     USE 
     RETURN 
    ENDIF 
 
  OTHERWISE 
    MESSAGEBOX('��������� �������� ��� ���������� ����� '+m.flname+CHR(13)+CHR(10)+;
     '� ������ KMS.DBF!'+CHR(13)+CHR(10)+;
     '���� '+m.flname+' �� ��������������!'+CHR(13)+CHR(10),0+64,'')
    SET RELATION OFF INTO FondFile
    SELECT FondFile
    SET ORDER TO 
    USE 
    RETURN 
 ENDCASE 
	
 SELECT kms

 m.Worked = 0

 SCAN FOR !EMPTY(FondFile.enp)
  REPLACE enp WITH FondFile.enp, status WITH 4, gz_data WITH DATE()
  m.Worked = m.Worked + 1

  m.fam = fam
  m.im  = im
  m.ot  = ot
  m.w   = w
  m.dr  = dr
  m.lpv = FondFile.pv

  INSERT INTO curappgz (pv,vs,fam,im,ot,w,dr,enp,isfnd) VALUES ;
   (m.lpv,FondFile.vsn,m.fam,m.im,m.ot,m.w,m.dr,FondFile.enp,.t.)

  m.fname  = UPPER(flname)
  m.mkdate = CTOD(SUBSTR(m.fname,7,2)+'.'+SUBSTR(m.fname,5,2)+'.201'+SUBSTR(m.fname,4,1))
  m.vs     = FondFile.vsn
  m.enp    = FondFile.enp
  m.kmsid  = recid
  m.frecid = IIF(m.kmsid>=0, PADL(m.kmsid,6,'0'), '')
  
  IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
   INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,enp) VALUES ;
    ('5',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.enp)
  ENDIF 

 ENDSCAN 
 
 SET RELATION OFF INTO FondFile
 SELECT FondFile
 SET ORDER TO 
 USE 

RETURN
