PROCEDURE AppDFile

 IF MESSAGEBOX('бш унрхре гюцпсгхрэ тюикш'+CHR(13)+CHR(10)+;
  'нрйкнмеммшу ттнля онкхянб?'+CHR(13)+CHR(10)+;
  '(D-тюикш)',4+32,'')=7
  RETURN 
 ENDIF 

 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('нрясрярбсер тюик MFC_PV.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 

 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 EFile = GETFILE('zip','','',0,'сЙЮФХРЕ МЮ ТЮИК!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(EFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'бш мхвецн ме бшапюкх!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ENDIF 

 oEFile = fso.GetFile(EFile)
 IF oEFile.size >= 2
  fhandl = oEFile.OpenAsTextStream
  lcHead = fhandl.Read(2)
  fhandl.Close
 ELSE 
  lcHead = ''
 ENDIF 

 IF lcHead != 'PK' && щРН zip-ТЮИК!
  MESSAGEBOX('щрн ме ZIP-юпухб!',0+64,'')
  RETURN 
 ENDIF 
 
 UnzipOpen(EFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'юпухб ме яндепфхр мх ндмнцн тюикю!'+CHR(13)+CHR(10),0+64, '')
  RETURN 
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' тюикнб б юпухбе!',0+64, '')
 ENDIF 
 
 IF UnzipOpen(EFile)==.T.
  CREATE CURSOR CursZip (EFile c(25))
  DIMENSION ZipArray(13)
  ZipArray = ''
  UnZipGotoTopFile()
  FOR FileInZip=0 TO FilesInZip-1
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))
   PeriodDir = '201' + SUBSTR(m.FileInZipName,7,5)
   UnzipSetFolder(pOut+'\'+PeriodDir)
   IF !fso.FolderExists(pOut+'\'+PeriodDir)
    fso.CreateFolder(pOut+'\'+PeriodDir)
   ENDIF 
   IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileInZipName)
    fso.DeleteFile(pOut+'\'+PeriodDir+'\'+m.FileInZipName)
   ENDIF 
   UnzipByIndex(FileInZip)
   INSERT INTO CursZip (EFile) VALUES (m.FileInZipName)

   UnzipGotoNextFile()
  ENDFOR  
  UnzipClose()
 ELSE 
  MESSAGEBOX('ме сдюкняэ нрйпшрэ тюик'+CHR(13)+CHR(10)+EFile,0+64,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\mfc_pv', 'mfc', 'shar', 'pv')>0
  IF USED('mfc')
   USE IN mfc
  ENDIF 
  RETURN 
 ENDIF 

 CREATE CURSOR curappgz (nrec n(5),pv c(3), vs c(9), fam c(25), im c(20), ot c(20), w n(1), dr d, ;
   enp c(16), err c(5), comment c(250), c_t c(5), pid c(16), ans_fl c(2), step c(4), isfnd l)

 SELECT CursZip
 SCAN
  m.FileName = ALLTRIM(EFile)
  PeriodDir = '201' + SUBSTR(m.FileName,7,5)
  IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileName)
   =OneAppDFile(m.FileName)
  ENDIF  
  SELECT CursZip
 ENDSCAN 
 USE 
 
 SELECT curappgz
 IF RECCOUNT()>0
  REPORT FORM AppDFile PREVIEW 
 ENDIF 
 USE 

 IF USED('mfc')
  USE IN mfc
 ENDIF 

* MESSAGEBOX('напюанрйю гюйнмвемю!',0+64,'')

RETURN 

FUNCTION OneAppDFile(flname)
 LOCAL m.nEFileRecCount, m.IsMfc
 m.nEFileRecCount = 0

 PeriodDir = '201' + SUBSTR(flname,7,5)
 ppath = pOut+'\'+PeriodDir
 m.lPV = SUBSTR(flname,4,3)
 
 IF !fso.FolderExists(pBase+'\'+m.lpv)
  MESSAGEBOX('нрясрярбсер дхпейрнпхъ об '+m.lpv+CHR(13)+CHR(10)+; 
   'тюик '+flname+' опносыем!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pBase+'\'+m.lpv+'\kms.dbf')
  MESSAGEBOX('нрясрярбсер тюик KMS.DBF б дхпейрнпхх об '+m.lpv+CHR(13)+CHR(10)+; 
   'тюик '+flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(PBase+'\'+m.lpv+'\moves.dbf')
  CREATE TABLE &PBase\&lpv\moves (et c(1), recid i autoinc, fname c(25), mkdate t, kmsid i, frecid c(6), ;
   vs c(9), s_card c(6), n_card n(10), c_okato c(5), enp c(16), dp d, jt c(1), ;
   pricin c(3), tranz c(3), q c(2), err c(5), err_text c(250), ans_fl c(2), nz n(3), n_kor n(6))
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON kmsid TAG kmsid
  INDEX ON fname+frecid TAG unik
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.lpv+'\e_ffoms.dbf')
  CREATE TABLE &PBase\&lpv\e_ffoms (v l, dcor d, recid i, data d, err c(5), ;
   "comment" c(250), c_t c(5), pid c(16), ans_fl c(2), step c(4))
  INDEX ON recid TAG recid
  USE 
 ENDIF 

 m.IsMfc=IIF(SEEK(m.lPV, 'mfc'), .t., .f.)

 shflname = LEFT(flname, AT('.',flname)-1)

 =PutCodePage(ppath+'\'+flname, 866, .t.)

 =OpenFile(ppath+'\'+flname, 'OutErrFile', 'excl')
 m.nEFileRecCount = RECCOUNT('OutErrFile')
	
 IF m.nEFileRecCount == 0
  MESSAGEBOX('б тюике ' + m.flname + ' мер мх ндмни гюохях!'+CHR(13)+CHR(10)+; 
   'тюик '+m.flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
  USE  IN OutErrFile
  SELECT CursZip
  RETURN 
 ENDIF 

 SELECT OutErrFile
 IF m.IsMfc
  INDEX ON vsn TAG rec_id
 ELSE 
  INDEX ON PADL(ALLTRIM(recid),6,'0') TAG rec_id
 ENDIF 
 SET ORDER TO rec_id
	
 IF OpenFile(PBase+'\'+lpv+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  USE IN OutErrFile
  SELECT CursZip
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\'+m.lpv+'\moves', 'moves', 'shar', 'unik')>0
  IF USED('moves')
   USE IN moves
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  USE IN OutErrFile
  SELECT CursZip
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\'+m.lpv+'\e_ffoms', 'Error', 'shar')>0
  IF USED('Error')
   USE IN Error
  ENDIF 
  IF USED('moves')
   USE IN moves
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  USE IN OutErrFile
  SELECT CursZip
  RETURN 
 ENDIF 

 SELECT OutErrFile
 SCAN 
  m.fname    = UPPER(m.flname)
  m.mkdate   = CTOD(SUBSTR(m.fname,10,2)+'.'+SUBSTR(m.fname,8,2)+'.201'+SUBSTR(m.fname,7,1))
  m.kmsid    = INT(VAL(recid))
  m.frecid   = recid
  m.vs       = vsn
  m.dp       = m.mkdate
  m.err      = err_code
  m.err_text = err_text
  m.c_okato  = ter_strah
  m.enp      = pid
  m.ans_fl   = ans_fl
  
  IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
   INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,dp,err,err_text,c_okato,enp,ans_fl) VALUES ;
    ('4',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.dp,m.err,m.err_text,m.c_okato,m.enp,m.ans_fl)
  ENDIF 
  
 ENDSCAN 

 SELECT kms
 IF m.IsMfc
  SET RELATION TO vs INTO OutErrFile
 ELSE 
  SET RELATION TO PADL(RecId,6,'0') INTO OutErrFile
 ENDIF 
	
 COUNT FOR !EMPTY(OutErrFile.recid) TO m.Related
	
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX('тюик '+m.flname+CHR(13)+CHR(10)+;
   ' ме ябъгюкяъ я тюикнл KMS.DBF об '+m.lpv+'!'+CHR(13)+CHR(10)+;
    'тюик '+m.flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO OutErrFile
   SELECT OutErrFile
   SET ORDER TO 
   DELETE TAG all
   USE IN OutErrFile
   USE IN kms
   USE IN moves
   USE IN Error
   SELECT CursZip
   RETURN 

  CASE m.Related == nEFileRecCount && бЯЕ нй!
*   MESSAGEBOX('тюик '+m.flname+CHR(13)+CHR(10)+;
    'ябъгюкяъ я тюикнл KMS.DBF об '+m.lpv+'!'+CHR(13)+CHR(10)+;
    'тюик '+m.flname+' напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
			
  CASE m.Related != nEFileRecCount
   IF MESSAGEBOX('тюик '+m.flname+CHR(13)+CHR(10)+;
    'ябъгюкяъ я тюикнл KMS.DBF об '+m.lpv+' вюярхвмн!'+CHR(13)+CHR(10)+ ;
    "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nEFileRecCount))+ ")" + CHR(13) + CHR(10)+;
    "опнднкфхрэ напюанрйс тюикю "+m.flname+"?",4+32,'') = 7 
    SET RELATION OFF INTO OutErrFile
    SELECT OutErrFile
    SET ORDER TO 
    DELETE TAG all
    USE  IN OutErrFile
    USE IN kms
    USE IN moves
    USE IN Error
    SELECT CursZip
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX('меьрюрмюъ яхрсюжхъ опх ябъгшбюмхх тюикю '+m.flname+CHR(13)+CHR(10)+;
    'я тюикнл KMS.DBF об '+m.lpv+'!'+CHR(13)+CHR(10)+;
    'тюик '+m.flname+' ме напюаюршбюеряъ!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO OutErrFile
   SELECT OutErrFile
   SET ORDER TO 
   DELETE TAG all
   USE  IN OutErrFile
   USE IN kms
   USE IN moves
   USE IN Error
   SELECT CursZip
   RETURN 
 ENDCASE 
 
 m.ddata = CTOD(SUBSTR(m.flname,10,2)+'.'+SUBSTR(m.flname,8,2)+'.201'+SUBSTR(m.flname,7,1))
 
 DELETE FROM error WHERE data=m.ddata
 
 SELECT kms
 m.Worked = 0
 SCAN FOR !EMPTY(OutErrFile.recid)

  m.recid    = recid
  m.data     = OutErrFile.file_date
  m.err      = OutErrFile.err_code
  m.comment  = OutErrFile.err_text
  m.c_t      = OutErrFile.ter_strah
  m.pid      = OutErrFile.pid
  m.ans_fl   = OutErrFile.ans_fl
  m.step     = OutErrFile.step
  
  m.vs  = vs
  m.fam = fam
  m.im  = im
  m.ot  = ot
  m.w   = w
  m.dr  = dr

  INSERT INTO curappgz (pv,vs,fam,im,ot,w,dr,enp,err,comment,c_t,pid,ans_fl,step,isfnd) VALUES ;
   (m.lpv,m.vs,m.fam,m.im,m.ot,m.w,m.dr,m.pid,m.err,m.comment,m.c_t,m.pid,m.ans_fl,m.step,.t.)

  INSERT INTO error FROM MEMVAR 

  m.Worked = m.Worked + 1
 ENDSCAN 
  
 IF m.Worked > 0
*  MESSAGEBOX("нАПЮАНРЮМН " + ALLTRIM(STR(m.Worked))+ " ГЮОХЯХ(ЕИ)!",0+64, 'оСМЙР '+m.lpv)
 ELSE
*  MESSAGEBOX("тЮИК НЬХАНЙ СФЕ ОНДЙЮВЮМ!",0+64, '')
 ENDIF 

 SET RELATION OFF INTO OutErrFile
 SELECT OutErrFile
 SET ORDER TO 
 DELETE TAG all
 USE  IN OutErrFile
 USE IN kms
 USE IN moves
 USE IN Error
 SELECT CursZip
RETURN 

