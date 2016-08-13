PROCEDURE AppEFileE
 IF MESSAGEBOX('¬€ ’Œ“»“≈ «¿√–”«»“‹ ‘¿…À€'+CHR(13)+CHR(10)+'Œ“ ÀŒÕ≈ÕÕ€’ Ã√‘ŒÃ— œŒÀ»—Œ¬?',4+32,'')=7
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
 
 ShortName = UPPER(oEFile.name)
 PeriodDir = '201' + SUBSTR(ShortName,5,5)
 
 UnzipOpen(EFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'¿–’»¬ Õ≈ —Œƒ≈–∆»“ Õ» ŒƒÕŒ√Œ ‘¿…À¿!'+CHR(13)+CHR(10),0+64, ShortName)
  RETURN 
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' ‘¿…ÀŒ¬ ¬ ¿–’»¬≈!',0+64, ShortName)
 ENDIF 
 
 IF !fso.FolderExists(pOut+'\'+PeriodDir)
  fso.CreateFolder(pOut+'\'+PeriodDir)
 ENDIF 
 
 IF fso.FileExists(pOut+'\'+PeriodDir+'\'+ShortName)
  fso.DeleteFile(pOut+'\'+PeriodDir+'\'+ShortName)
 ENDIF 
 fso.CopyFile(m.EFile, pOut+'\'+PeriodDir+'\'+ShortName)

 IF UnzipOpen(pOut+'\'+PeriodDir+'\'+ShortName)==.T.
  CREATE CURSOR CursZip (EFile c(25))
  DIMENSION ZipArray(13)
  ZipArray = ''
  UnzipSetFolder(pOut+'\'+PeriodDir)
  UnZipGotoTopFile()
  FOR FileInZip=0 TO FilesInZip-1
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))
   
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
 IF OpenFile(pbase+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('mfc')
   USE IN mfc
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
  IF USED('mfc')
   USE IN mfc
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\Error', 'Error', 'shar', 'rec_id')>0
  IF USED('error')
   USE IN error
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('moves')
   USE IN moves
  ENDIF 
  IF USED('mfc')
   USE IN mfc
  ENDIF 
  RETURN 
 ENDIF 

 CREATE CURSOR curappgz (nrec n(5),pv c(3), vs c(9), s_card c(6), n_card n(10), q c(20),;
  fam c(25), im c(20), ot c(20), w n(1), dr d, err c(5), comment c(250), isfnd l)
 SELECT CursZip
 SCAN
  m.FileName = ALLTRIM(EFile)
  IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileName)
   =OneAppEFile(m.FileName)
  ENDIF  
 ENDSCAN 
 USE 
 
 SELECT curappgz
 IF RECCOUNT()>0
  REPORT FORM AppEFile PREVIEW 
 ENDIF 
 USE 

 IF USED('mfc')
  USE IN mfc
 ENDIF 
 IF USED('kms')
  USE IN kms
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 
 IF USED('error')
  USE IN error
 ENDIF 

RETURN 

FUNCTION OneAppEFile(flname)
 LOCAL m.nEFileRecCount, m.IsMfc
 m.nEFileRecCount = 0

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
  INDEX ON PADL(n_card,9,'0') TAG rec_id
 ELSE 
  INDEX ON PADL(ALLTRIM(rec_id),6,'0') TAG rec_id
 ENDIF 
 SET ORDER TO rec_id
	
 SELECT OutErrFile
 SCAN 
  m.fname    = UPPER(m.flname)
  m.mkdate   = CTOD(SUBSTR(m.fname,10,2)+'.'+SUBSTR(m.fname,8,2)+'.201'+SUBSTR(m.fname,7,1))
  m.kmsid    = INT(VAL(rec_id))
  m.frecid   = rec_id
  m.s_card   = s_card
  m.n_card   = n_card
  m.dp       = n_date
  m.q        = q
  m.err      = err
  m.err_text = err_text
  
  IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
   INSERT INTO moves (et,fname,mkdate,kmsid,frecid,s_card,n_card,dp,q,err,err_text) VALUES ;
    ('3',m.fname,m.mkdate,m.kmsid,m.frecid,m.s_card,m.n_card,m.dp,m.q,m.err,m.err_text)
  ENDIF 
  
 ENDSCAN 

 SELECT kms
 IF m.IsMfc
  SET RELATION TO vs INTO OutErrFile
 ELSE 
  SET RELATION TO PADL(RecId,6,'0') INTO OutErrFile
 ENDIF 
	
 COUNT FOR !EMPTY(OutErrFile.rec_id) TO m.Related
	
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
 
 SELECT kms
 m.Worked = 0
 SCAN FOR !EMPTY(OutErrFile.rec_id)
  m.e_rec_id   = ALLTRIM(OutErrFile.rec_id)
  m.e_s_card   = OutErrFile.s_card
  m.e_n_card   = OutErrFile.n_card
  m.e_n_date   = OutErrFile.n_date
  m.e_q        = OutErrFile.q
  m.e_err      = OutErrFile.err
  m.e_err_text = OutErrFile.err_text
  m.app_d      = m.mkdate   

  IF !SEEK(PADL(m.e_rec_id,6,'0'), 'Error')
   INSERT INTO ERROR (rec_id, s_card, n_card, n_date, q, err, err_text, app_d) ;
    VALUES (PADL(m.e_rec_id,6,'0'), m.e_s_card, m.e_n_card, m.e_n_date, m.e_q, ;
     m.e_err, m.e_err_text, m.app_d)
  ENDIF 

  IF UPPER(LEFT(OutErrFile.err,2)) = 'E1'
   IF jt='2' && ≈ÒÎË ÔÂÂÂ„ËÒÚ‡ˆËˇ!
    REPLACE sn_card WITH OutErrFile.s_card+' '+PADL(OutErrFile.n_card,10,'0'), ;
    dp WITH DATE(), status WITH 1
   ELSE 
    IF m.qcod != 'R4'
     REPLACE sn_card WITH OutErrFile.s_card+' '+PADL(OutErrFile.n_card,10,'0'), ;
      jt WITH IIF(UPPER(OutErrFile.q)=qcod,'7','z'), dp WITH DATE(), p_doc WITH 1, status WITH 1
    ELSE 
     REPLACE sn_card WITH OutErrFile.s_card+' '+PADL(OutErrFile.n_card,10,'0'), ;
      jt WITH 'b', dp WITH DATE(), p_doc WITH 1, status WITH 1
    ENDIF 
   ENDIF 

  ENDIF 

  INSERT INTO curappgz (pv,vs,s_card,n_card,q,fam,im,ot,w,dr,err,comment,isfnd) VALUES ;
  (m.lpv,kms.vs,m.e_s_card,m.e_n_card, m.e_q,kms.fam,kms.im,kms.ot,;
   kms.w,kms.dr,m.e_err,m.e_err_text,.t.)

  m.Worked = m.Worked + 1
 ENDSCAN 

 SET RELATION OFF INTO OutErrFile
 SELECT OutErrFile
 SET ORDER TO 
 DELETE TAG all
 USE  IN OutErrFile
 SELECT CursZip
RETURN 
