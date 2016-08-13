PROCEDURE AppDFileE

 IF MESSAGEBOX('¬€ ’Œ“»“≈ «¿√–”«»“‹ ‘¿…À€'+CHR(13)+CHR(10)+;
  'Œ“ ÀŒÕ≈ÕÕ€’ ‘‘ŒÃ— œŒÀ»—Œ¬?'+CHR(13)+CHR(10)+;
  '(D-‘¿…À€)',4+32,'')=7
  RETURN 
 ENDIF 

 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À MFC_PV.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\kms.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À BASE\KMS.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\moves.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À BASE\MOVES.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 

 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 EFile = GETFILE('zip','','',0,'”Í‡ÊËÚÂ Ì‡ Ù‡ÈÎ!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(EFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'¬€ Õ»◊≈√Œ Õ≈ ¬€¡–¿À»!'+CHR(13)+CHR(10),0+48,'')
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

 IF lcHead != 'PK' && ›ÚÓ zip-Ù‡ÈÎ!
  MESSAGEBOX('›“Œ Õ≈ ZIP-¿–’»¬!',0+64,'')
  RETURN 
 ENDIF 
 
 UnzipOpen(EFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'¿–’»¬ Õ≈ —Œƒ≈–∆»“ Õ» ŒƒÕŒ√Œ ‘¿…À¿!'+CHR(13)+CHR(10),0+64, '')
  RETURN 
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' ‘¿…ÀŒ¬ ¬ ¿–’»¬≈!',0+64, '')
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
  MESSAGEBOX('Õ≈ ”ƒ¿ÀŒ—‹ Œ“ –€“‹ ‘¿…À'+CHR(13)+CHR(10)+EFile,0+64,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\mfc_pv', 'mfc', 'shar', 'pv')>0
  IF USED('mfc')
   USE IN mfc
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\moves', 'moves', 'shar', 'unik')>0
  IF USED('moves')
   USE IN moves
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\e_ffoms', 'Error', 'shar')>0
  IF USED('Error')
   USE IN Error
  ENDIF 
  IF USED('moves')
   USE IN moves
  ENDIF 
  IF USED('kms')
   USE IN kms
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
 IF USED('Error')
  USE IN Error
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 
 IF USED('kms')
  USE IN kms
 ENDIF 

RETURN 

FUNCTION OneAppDFile(flname)
 LOCAL m.nEFileRecCount, m.IsMfc
 m.nEFileRecCount = 0

 PeriodDir = '201' + SUBSTR(flname,7,5)
 ppath = pOut+'\'+PeriodDir
 m.lPV = SUBSTR(flname,4,3)
 
 m.IsMfc=IIF(SEEK(m.lPV, 'mfc'), .t., .f.)

 shflname = LEFT(flname, AT('.',flname)-1)

 =PutCodePage(ppath+'\'+flname, 866, .t.)

 =OpenFile(ppath+'\'+flname, 'OutErrFile', 'excl')
 m.nEFileRecCount = RECCOUNT('OutErrFile')
	
 IF m.nEFileRecCount == 0
  MESSAGEBOX('¬ ‘¿…À≈ ' + m.flname + ' Õ≈“ Õ» ŒƒÕŒ… «¿œ»—»!'+CHR(13)+CHR(10)+; 
   '‘¿…À '+m.flname+' Õ≈ Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
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

 SELECT kms
 IF m.IsMfc
  SET RELATION TO vs INTO OutErrFile
 ELSE 
  SET RELATION TO PADL(RecId,6,'0') INTO OutErrFile
 ENDIF 
	
 COUNT FOR !EMPTY(OutErrFile.recid) TO m.Related
	
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX('‘¿…À '+m.flname+CHR(13)+CHR(10)+;
   ' Õ≈ —¬ﬂ«¿À—ﬂ — ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+'!'+CHR(13)+CHR(10)+;
    '‘¿…À '+m.flname+' Õ≈ Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO OutErrFile
   SELECT OutErrFile
   SET ORDER TO 
   DELETE TAG all
   USE IN OutErrFile
   SELECT CursZip
   RETURN 

  CASE m.Related == nEFileRecCount && ¬ÒÂ Œ !
*   MESSAGEBOX('‘¿…À '+m.flname+CHR(13)+CHR(10)+;
    '—¬ﬂ«¿À—ﬂ — ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+'!'+CHR(13)+CHR(10)+;
    '‘¿…À '+m.flname+' Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
			
  CASE m.Related != nEFileRecCount
   IF MESSAGEBOX('‘¿…À '+m.flname+CHR(13)+CHR(10)+;
    '—¬ﬂ«¿À—ﬂ — ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+' ◊¿—“»◊ÕŒ!'+CHR(13)+CHR(10)+ ;
    "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nEFileRecCount))+ ")" + CHR(13) + CHR(10)+;
    "œ–ŒƒŒÀ∆»“‹ Œ¡–¿¡Œ“ ” ‘¿…À¿ "+m.flname+"?",4+32,'') = 7 
    SET RELATION OFF INTO OutErrFile
    SELECT OutErrFile
    SET ORDER TO 
    DELETE TAG all
    USE  IN OutErrFile
    SELECT CursZip
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX('Õ≈ÿ“¿“Õ¿ﬂ —»“”¿÷»ﬂ œ–» —¬ﬂ«€¬¿Õ»» ‘¿…À¿ '+m.flname+CHR(13)+CHR(10)+;
    '— ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+'!'+CHR(13)+CHR(10)+;
    '‘¿…À '+m.flname+' Õ≈ Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO OutErrFile
   SELECT OutErrFile
   SET ORDER TO 
   DELETE TAG all
   USE  IN OutErrFile
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

  m.fname    = UPPER(m.flname)
  m.mkdate   = CTOD(SUBSTR(m.fname,10,2)+'.'+SUBSTR(m.fname,8,2)+'.201'+SUBSTR(m.fname,7,1))
  m.kmsid    = recid
  m.frecid   = PADL(recid,6,'0')
  m.vs       = OutErrFile.vsn
  m.dp       = m.mkdate
  m.err      = OutErrFile.err_code
  m.err_text = OutErrFile.err_text
  m.c_okato  = OutErrFile.ter_strah
  m.enp      = OutErrFile.pid
  m.ans_fl   = OutErrFile.ans_fl
  
  IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
   INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,dp,err,err_text,c_okato,enp,ans_fl) VALUES ;
    ('4',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.dp,m.err,m.err_text,m.c_okato,m.enp,m.ans_fl)
  ENDIF 

  m.Worked = m.Worked + 1
 ENDSCAN 
  
 SET RELATION OFF INTO OutErrFile
 SELECT OutErrFile
 SET ORDER TO 
 DELETE TAG all
 USE  IN OutErrFile
 SELECT CursZip
RETURN 

