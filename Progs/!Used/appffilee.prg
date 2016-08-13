PROCEDURE AppFFileE
 IF MESSAGEBOX('¬€ ’Œ“»“≈ «¿√–”«»“‹ ‘¿…À€'+CHR(13)+CHR(10)+'œ–»Õﬂ“€’   »«√Œ“Œ¬À≈Õ»ﬁ Ã√‘ŒÃ— œŒÀ»—Œ¬?',4+32,'')=7
  RETURN 
 ENDIF 

 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À BIN\MFC_PV.DBF!'+CHR(13)+CHR(10),0+16,'')
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
 FFile = GETFILE('zip','','',0,'¬˚·ÂËÚÂ Ù‡ÈÎ:')
 SET DEFAULT TO (oal)
 
 IF EMPTY(ffile)
  MESSAGEBOX(CHR(13)+CHR(10)+'¬€ Õ»◊≈√Œ Õ≈ ¬€¡–¿À»!'+CHR(13)+CHR(10),0+48,'')
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

 IF lcHead != 'PK' && ›ÚÓ zip-Ù‡ÈÎ!
  MESSAGEBOX('›“Œ Õ≈ ZIP-¿–’»¬!',0+64,'')
  RETURN 
 ENDIF 
 
 ShortName = UPPER(offile.name)
 PeriodDir = '201' + SUBSTR(ShortName,5,5)
 
 UnzipOpen(FFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'¿–’»¬ Õ≈ —Œƒ≈–∆»“ Õ» ŒƒÕŒ√Œ ‘¿…À¿!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' ‘¿…ÀŒ¬ ¬ ¿–’»¬≈!',0+64,'')
 ENDIF 

 LOCAL m.nFFileRecCount
 m.nFFileRecCount = 0

 IF !fso.FolderExists(pOut+'\'+PeriodDir)
  fso.CreateFolder(pOut+'\'+PeriodDir)
 ENDIF 
 
 IF fso.FileExists(pOut+'\'+PeriodDir+'\'+ShortName)
  fso.DeleteFile(pOut+'\'+PeriodDir+'\'+ShortName)
 ENDIF 
 fso.CopyFile(m.ffile, pOut+'\'+PeriodDir+'\'+ShortName)

 IF UnzipOpen(pOut+'\'+PeriodDir+'\'+ShortName)==.T.
  DIMENSION ZipArray(13)
  CREATE CURSOR CursZip (FFile c(25))
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
   INSERT INTO CursZip (FFile) VALUES (m.FileInZipName)
   
   UnzipGotoNextFile()
  ENDFOR  
  UnzipClose()
 ELSE 
  MESSAGEBOX('Õ≈ ”ƒ¿ÀŒ—‹ Œ“ –€“‹ ‘¿…À'+CHR(13)+CHR(10)+FFILE,0+64,'')
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

 CREATE CURSOR curappgz (nrec n(5),pv c(3),vs c(9),s_pol c(6),n_pol n(10),s_card c(6),n_card n(10),;
  fam c(25),im c(20),ot c(20),w n(1), dr d, isfnd l) 
 SELECT CursZip
 
 SCAN
  m.FileName = ALLTRIM(FFile)
  IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileName)
   =OneAppFFile(m.FileName)
  ENDIF  
 ENDSCAN 
 USE 
 
 SELECT curappgz
 IF RECCOUNT()>0
  REPORT FORM AppFFile PREVIEW 
 ENDIF 
 USE 

 IF USED('mfc')
  USE IN mfc
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 
 IF USED('kms')
  USE IN kms
 ENDIF 

RETURN 

FUNCTION OneAppFFile(flname)

 ppath = pOut+'\'+PeriodDir
 m.lPV = SUBSTR(flname,4,3)
 
 m.IsMfc=IIF(SEEK(m.lPV, 'mfc'), .T., .F.)

 shflname = LEFT(flname, AT('.',flname)-1)
 
 =OpenFile(ppath+'\'+flname, 'FondFile', 'excl') 
	
 m.nFFileRecCount = RECCOUNT('FondFile')
	
 IF m.nFFileRecCount == 0
  MESSAGEBOX('¬ ‘¿…À≈ ' + m.flname + ' Õ≈“ Õ» ŒƒÕŒ… «¿œ»—»!'+CHR(13)+CHR(10)+; 
   '‘¿…À '+m.flname+' Õ≈ Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
  USE IN FondFile
  SELECT CursZip
  RETURN 
 ENDIF 
 
 SELECT FondFile
 SCAN 
  m.fname  = UPPER(flname)
  m.mkdate   = CTOD(SUBSTR(m.fname,10,2)+'.'+SUBSTR(m.fname,8,2)+'.201'+SUBSTR(m.fname,7,1))
  m.kmsid  = INT(VAL(rec_id))
  m.frecid = rec_id
  m.vs     = IIF(LEFT(s_pol,2)=m.qcod, PADL(n_pol,9,'0'), '')
  m.s_card = s_card
  m.n_card = n_card
  m.dp     = dp
  m.jt     = jt
  
  IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
   INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,dp,jt) VALUES ;
    ('2',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.s_card,m.n_card,m.dp,m.jt)
  ENDIF 
  
 ENDSCAN 

 IF m.IsMfc
  INDEX ON PADR(ALLTRIM(s_pol)+' '+;
   IIF(s_pol='77', PADL(n_pol,10,'0'), PADL(n_pol,9,'0')),17) TAG rec_id
 ELSE 
  INDEX ON PADL(rec_id,6,'0') TAG rec_id
 ENDIF 
 SET ORDER TO rec_id
	
 SELECT kms

 IF m.IsMfc
  SET RELATION TO sn_card INTO FondFile
 ELSE 
  SET RELATION TO PADL(recid,6,'0') INTO FondFile
 ENDIF 
	
 COUNT FOR !EMPTY(FondFile.s_pol) TO m.Related
 
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX('‘¿…À '+m.flname+CHR(13)+CHR(10)+;
   ' Õ≈ —¬ﬂ«¿À—ﬂ — ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+'!'+CHR(13)+CHR(10)+;
    '‘¿…À '+m.flname+' Õ≈ Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO FondFile
   SELECT FondFile
   SET ORDER TO 
   DELETE TAG all
   USE 
   RETURN 

  CASE m.Related == nFFileRecCount && ¬ÒÂ Œ !
   MESSAGEBOX('‘¿…À '+m.flname+CHR(13)+CHR(10)+;
    '—¬ﬂ«¿À—ﬂ — ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+'!'+CHR(13)+CHR(10)+;
    '‘¿…À '+m.flname+' Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')

  CASE m.Related != nFFileRecCount
   IF MESSAGEBOX('‘¿…À '+m.flname+CHR(13)+CHR(10)+;
    '—¬ﬂ«¿À—ﬂ — ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+' ◊¿—“»◊ÕŒ!'+CHR(13)+CHR(10)+ ;
    "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nFFileRecCount))+ ")" + CHR(13) + CHR(10)+;
    "œ–ŒƒŒÀ∆»“‹ Œ¡–¿¡Œ“ ” ‘¿…À¿ "+m.flname+"?",4+32,'') = 7 
    SET RELATION OFF INTO FondFile
    SELECT FondFile
    SET ORDER TO 
    DELETE TAG all
    USE 
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX('Õ≈ÿ“¿“Õ¿ﬂ —»“”¿÷»ﬂ œ–» —¬ﬂ«€¬¿Õ»» ‘¿…À¿ '+m.flname+CHR(13)+CHR(10)+;
    '— ‘¿…ÀŒÃ KMS.DBF œ¬ '+m.lpv+'!'+CHR(13)+CHR(10)+;
    '‘¿…À '+m.flname+' Õ≈ Œ¡–¿¡¿“€¬¿≈“—ﬂ!'+CHR(13)+CHR(10),0+64,'')
   SET RELATION OFF INTO FondFile
   SELECT FondFile
   SET ORDER TO 
   DELETE TAG all
   USE 
   RETURN 
 ENDCASE 
	
 SELECT kms

 m.Worked = 0

 SCAN FOR !EMPTY(FondFile.s_pol)
  m.tsn_card = FondFile.s_card + ' ' + PADL(FondFile.n_card,10,'0')
  REPLACE sn_card WITH m.tsn_card
  IF m.qcod == 'R4'
   REPLACE  nz WITH PADL(FondFile.zz,5,'0')
  ENDIF 
  IF m.qcod == 'P2'
   REPLACE FondFile.prim WITH 'ƒ¿'
  ENDIF 
  m.Worked = m.Worked + 1
  IF status != 3
   REPLACE status WITH 3
  ENDIF 
  
  m.vs     = vs
  m.s_pol  = FondFile.s_pol
  m.n_pol  = FondFile.n_pol
  m.s_card = FondFile.s_card
  m.n_card = FondFile.n_card
  m.fam    = fam
  m.im     = im
  m.ot     = ot
  m.w      = w
  m.dr     = dr

  INSERT INTO curappgz (pv,vs,s_pol,n_pol,s_card,n_card,fam,im,ot,w,dr,isfnd) VALUES ;
  (m.lpv,m.vs,m.s_pol,m.n_pol,m.s_card,m.n_card,m.fam,m.im,m.ot,m.w,m.dr,.t.)

 ENDSCAN 
 
 SET RELATION OFF INTO FondFile
 SELECT FondFile
 SET ORDER TO 
 DELETE TAG all
 USE 

RETURN
