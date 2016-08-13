PROCEDURE AppZFile && гЮЦПСГЙЮ ЯОХЯЙНБ МЮ ХГЦНРНБКЕМХЕ

 IF MESSAGEBOX('бш унрхре гюцпсгхрэ тюикш'+CHR(13)+CHR(10)+;
  'оепедюммшу мю хгцнрнбкемхе онкхянб?'+CHR(13)+CHR(10)+;
  '(Z-тюикш)',4+32,'')=7
  RETURN 
 ENDIF 

 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
  m.lppath = pBase
  m.kol_pv = 1
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
 ENDIF 

 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 FFile = GETFILE('zip','','',0,'бШАЕПХРЕ ТЮИК:')
 SET DEFAULT TO (oal)
 
 IF EMPTY(ffile)
  MESSAGEBOX(CHR(13)+CHR(10)+'бш мхвецн ме бшапюкх!'+CHR(13)+CHR(10),0+48,'')
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

 IF lcHead != 'PK' && щРН zip-ТЮИК!
  MESSAGEBOX('щрн ме ZIP-юпухб!',0+64,'')
  RETURN 
 ENDIF 
 
 ShortName = UPPER(offile.name)
 PeriodDir = '201' + SUBSTR(ShortName,5,5)
 
 UnzipOpen(FFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'юпухб ме яндепфхр мх ндмнцн тюикю!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' тюикнб б юпухбе!',0+64,'')
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
  MESSAGEBOX('ме сдюкняэ нрйпшрэ тюик'+CHR(13)+CHR(10)+FFILE,0+64,'')
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
 
 SELECT curappgz
* BROWSE 
 IF RECCOUNT()>0
  REPORT FORM AppZFile PREVIEW 
 ENDIF 
 USE 

RETURN 

FUNCTION OneAppZFile(flname)
 PeriodDir = '201' + SUBSTR(flname,4,5)
 ppath = pOut+'\'+PeriodDir
 
 IF OpenFile(ppath+'\'+flname, 'ffname', 'shar')>0
  IF USED('ffname')
   USE IN ffname
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT pv AS pv, coun(*) as cnt FROM ffname GROUP BY pv INTO CURSOR curpv ORDER BY pv 
 
 SELECT curpv
 SCAN 
  m.cnt = cnt 
  IF m.cnt <= 0
   LOOP 
  ENDIF 

  m.lPV = pv
  m.nFFileRecCount = cnt
 
  IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
   m.lppath = pBase
  ELSE 
   m.lppath = pBase+'\'+m.lpv
  ENDIF 

  IF !fso.FolderExists(m.lppath)
   MESSAGEBOX('нрясрярбсер дхпейрнпхъ об '+m.lppath+CHR(13)+CHR(10)+;
    'тюик '+flname+' опносыем!'+CHR(13)+CHR(10),0+64,'') 
   LOOP 
  ENDIF 
 
  IF !fso.FileExists(m.lppath+'\kms.dbf')
   MESSAGEBOX('нрясрярбсер тюик KMS.DBF б дхпейрнпхх об '+m.lpv+CHR(13)+CHR(10)+;
    'тюик '+flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
   LOOP 
  ENDIF 

  IF !fso.FileExists(m.lppath+'\moves.dbf')
   CREATE TABLE &lppath\moves (et c(1), recid i autoinc, fname c(25), mkdate t, kmsid i, frecid c(6), ;
    vs c(9), s_card c(6), n_card n(10), c_okato c(5), enp c(16), dp d, jt c(1), ;
    pricin c(3), tranz c(3), q c(2), err c(5), err_text c(250), ans_fl c(2), nz n(3), n_kor n(6))
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON kmsid TAG kmsid
   INDEX ON fname+frecid TAG unik
   USE 
  ENDIF 

  *shflname = LEFT(flname, AT('.',flname)-1)
  
  SELECT * FROM ffname WHERE pv = m.lpv INTO CURSOR FondFile READWRITE 
	
  IF OpenFile(m.lppath+'\kms', 'kms', 'shar')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
   USE IN FondFile
   SELECT curpv
   LOOP 
  ENDIF 
  IF OpenFile(m.lppath+'\moves', 'moves', 'shar', 'unik')>0
   IF USED('moves')
    USE IN moves
   ENDIF 
   IF USED('kms')
    USE IN kms
   ENDIF 
   USE IN FondFile
   SELECT CurPv
   LOOP 
  ENDIF 
 
  SELECT FondFile
  SCAN 
   m.fname  = UPPER(flname)
   m.mkdate = CTOD(SUBSTR(m.fname,7,2)+'.'+SUBSTR(m.fname,5,2)+'.201'+SUBSTR(m.fname,4,1))
   m.vs     = vsn
   m.enp    = enp
   m.kmsid  = IIF(SEEK(m.vs, 'kms', 'vs'), kms.recid, 0)
   m.frecid = IIF(m.kmsid>=0, PADL(m.kmsid,6,'0'), '')
  
   IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
    INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,enp) VALUES ;
     ('5',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.enp)
   ENDIF 
  
  ENDSCAN 

  INDEX ON vsn TAG rec_id
  SET ORDER TO rec_id
	
  SELECT kms
  SET RELATION TO vs INTO FondFile
  COUNT FOR !EMPTY(FondFile.enp) TO m.Related
 
  DO CASE 
   CASE m.Related == 0
    MESSAGEBOX('тюик '+m.flname+CHR(13)+CHR(10)+;
    ' ме ябъгюкяъ я тюикнл KMS.DBF об '+m.lpv+'!'+CHR(13)+CHR(10)+;
     'тюик '+m.flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
    SET RELATION OFF INTO FondFile
    SELECT FondFile
    SET ORDER TO 
    USE 
    USE IN Kms
    USE IN moves
    SELECT CurPv
    LOOP 

   CASE m.Related == nFFileRecCount && бЯЕ нй!
*    MESSAGEBOX('тюик '+m.flname+CHR(13)+CHR(10)+;
     'ябъгюкяъ я тюикнл KMS.DBF об '+m.lpv+'!'+CHR(13)+CHR(10)+;
     'тюик '+m.flname+' напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')

   CASE m.Related != nFFileRecCount
    IF MESSAGEBOX('тюик '+m.flname+CHR(13)+CHR(10)+;
     'ябъгюкяъ я тюикнл KMS.DBF об '+m.lpv+' вюярхвмн!'+CHR(13)+CHR(10)+ ;
     "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nFFileRecCount))+ ")" + CHR(13) + CHR(10)+;
     "опнднкфхрэ напюанрйс тюикю "+m.flname+"?",4+32,'') = 7 
     SET RELATION OFF INTO FondFile
     SELECT FondFile
     SET ORDER TO 
     USE 
     USE IN Kms
     USE IN moves
     SELECT CurPv
     LOOP 
    ENDIF 
 
   OTHERWISE 
    MESSAGEBOX('меьрюрмюъ яхрсюжхъ опх ябъгшбюмхх тюикю '+m.flname+CHR(13)+CHR(10)+;
     'я тюикнл KMS.DBF об '+m.lpv+'!'+CHR(13)+CHR(10)+;
     'тюик '+m.flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
    SET RELATION OFF INTO FondFile
    SELECT FondFile
    SET ORDER TO 
    USE 
    USE IN Kms
    USE IN moves
    SELECT CurPv
    LOOP 
  ENDCASE 
	
  SELECT kms

  m.Worked = 0

  SCAN FOR !EMPTY(FondFile.enp)

   REPLACE enp WITH FondFile.enp, gz_data WITH DATE()
   IF status<4
    REPLACE status WITH 4
   ENDIF 
   
   m.Worked = m.Worked + 1

   m.fam = fam
   m.im  = im
   m.ot  = ot
   m.w   = w
   m.dr  = dr
   
   INSERT INTO curappgz (pv,vs,fam,im,ot,w,dr,enp,isfnd) VALUES ;
    (m.lpv,FondFile.vsn,m.fam,m.im,m.ot,m.w,m.dr,FondFile.enp,.t.)

  ENDSCAN 
 
  SET RELATION OFF INTO FondFile
  USE 
  SELECT FondFile
  SET ORDER TO 
  USE 
  USE IN moves
  SELECT CurPv

  IF m.Worked > 0
*   MESSAGEBOX("напюанрюмн " + ALLTRIM(STR(m.Worked))+ " гюохях(еи)!",0+64,  'оСМЙР '+m.lpv)
  ELSE
*   MESSAGEBOX("тЮИК СФЕ ОНДЙЮВЮМ!",0+64,  'оСМЙР '+m.lpv)
  ENDIF 
 ENDSCAN 
 
 USE IN ffname
 USE IN CurPv

RETURN
