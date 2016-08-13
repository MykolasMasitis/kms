PROCEDURE AppErrFiles

 IF MESSAGEBOX('¬€ ’Œ“»“≈ «¿√–”«»“‹ ERR-‘¿…À€'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 
 pRep = fso.GetParentFolderName(pbin)+'\REPS'
 IF !fso.FolderExists(pRep)
  fso.CreateFolder(pRep)
 ENDIF 
 
 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pRep)
 EFile = GETFILE('zip','','',0,'”Í‡ÊËÚÂ Ì‡ Ù‡ÈÎ!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(EFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'¬€ Õ»◊≈√Œ Õ≈ ¬€¡–¿À»!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ENDIF 
 
 m.tefile = STRTRAN(SUBSTR(UPPER(efile), RAT('\',UPPER(efile))+1), '.ZIP','')
 
 IF SUBSTR(m.tefile,1,3)!='ERR'
  MESSAGEBOX('‘¿…À '+m.tefile+' Õ≈ ﬂ¬Àﬂ≈“—ﬂ ‘¿…ÀŒÃ Œÿ»¡Œ !',0+16,'')
  RETURN 
 ENDIF 
 IF SUBSTR(m.tefile,4,2)!=UPPER(m.qcod)
  MESSAGEBOX('‘¿…À '+m.tefile+' Õ≈ ﬂ¬Àﬂ≈“—ﬂ ‘¿…ÀŒÃ Œÿ»¡Œ !',0+16,'')
  RETURN 
 ENDIF 
 
 m.fdata = CTOD(SUBSTR(m.tefile,9,2)+'.'+SUBSTR(m.tefile,7,2)+'.201'+SUBSTR(m.tefile,6,1))
 
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
 
 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('Œ“—”“—“¬≈“ ‘¿…À MFC_PV.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\mfc_pv', 'mfcpv', 'shar', 'pv')>0
  IF USED('mfcpv')
   USE IN mfcpv
  ENDIF 
  RETURN 
 ENDIF 

 IF UnzipOpen(EFile)==.T.
  CREATE CURSOR CursZip (EFile c(25))
  DIMENSION ZipArray(13)
  ZipArray = ''
  UnZipGotoTopFile()
  FOR FileInZip=0 TO FilesInZip-1
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))
   UnzipSetFolder(pRep)
   IF fso.FileExists(pRep+'\'+m.FileInZipName)
    fso.DeleteFile(pRep+'\'+m.FileInZipName)
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

 CREATE CURSOR curappgz (nrec n(5), pv c(3), vs c(9), fam c(25), im c(20), ot c(20), w n(1), dr d, ;
   enp c(16), err c(5), comment c(250), c_t c(5), pid c(16), ans_fl c(2), step c(4), isfnd l)

 SELECT CursZip
 SCAN
  m.FileName = ALLTRIM(EFile)
  IF fso.FileExists(pRep+'\'+m.FileName)
   =AppErrFile(m.FileName)
  ENDIF  
  SELECT CursZip
 ENDSCAN 
 USE 
 
 SELECT curappgz
 IF RECCOUNT()>0
  REPORT FORM AppDFile PREVIEW 
 ELSE 
  MESSAGEBOX('Õ≈ —¬ﬂ«¿À¿—‹ Õ» ŒƒÕ¿ «¿œ»—‹!',0+64,'')
 ENDIF 
 USE 
 USE IN mfcpv

RETURN 

FUNCTION AppErrFile(flname)
 LOCAL m.ofile, m.nEFileRecCount, m.IsMfc
 m.nEFileRecCount = 0
 m.onefile = STRTRAN(LOWER(ALLTRIM(flname)),'.dbf','')
 
 ErrFile = pRep+'\'+m.onefile
 
 IF !fso.FileExists(ErrFile+'.dbf')
  RETURN 
 ENDIF 

 =PutCodePage(ErrFile+'.dbf', 866, .t.)

 IF OpenFile(ErrFile+'.dbf', 'err', 'excl')>0
  IF USED('err')
   USE IN err
  ENDIF 
  SELECT CursZip
  RETURN 
 ENDIF 

 m.nEFileRecCount = RECCOUNT('Err')
 IF m.nEFileRecCount <= 0
  IF USED('err')
   USE IN err
  ENDIF 
  SELECT CursZip
  RETURN 
 ENDIF 

 SELECT Err 
 INDEX ON recid TAG rec_id
 SET ORDER TO rec_id 
 
 SELECT pv, COUNT(*) as cnt FROM err GROUP BY pv INTO CURSOR pvlist
 
 SELECT pvlist 
 SCAN 
  m.lpv = pv 
  m.IsMfc=IIF(SEEK(m.lPV, 'mfcpv'), .t., .f.)

 IF INLIST(SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1),'KMS.EXE','KMSPV.EXE')
   m.lppath = pBase
  ELSE 
   m.lppath = pBase+'\'+m.lpv
  ENDIF 
 
  IF !fso.FolderExists(m.lppath)
   LOOP 
  ENDIF 
  IF !fso.FileExists(m.lppath+'\kms.dbf')
   LOOP 
  ENDIF 
  IF !fso.FileExists(m.lppath+'\moves.dbf')
   LOOP 
  ENDIF 
  IF !fso.FileExists(m.lppath+'\e_ffoms.dbf')
   LOOP 
  ENDIF 

  IF OpenFile(m.lppath+'\kms', 'kms', 'shar')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
   SELECT pvlist
   LOOP 
  ENDIF 
  IF OpenFile(m.lppath+'\moves', 'moves', 'shar', 'unik')>0
   IF USED('moves')
    USE IN moves
   ENDIF 
   USE IN kms
   SELECT pvlist
   LOOP 
  ENDIF 
  IF OpenFile(m.lppath+'\e_ffoms', 'Error', 'shar', 'unik')>0
   IF USED('Error')
    USE IN Error
   ENDIF 
   USE IN moves
   USE IN kms
   SELECT pvlist
   LOOP 
  ENDIF 
  
  SELECT err 
  SCAN 
   IF pv!=m.lpv AND SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)!='KMS.EXE'
    LOOP 
   ENDIF 

   m.fname    = UPPER(m.flname)
   m.mkdate   = m.fdata
   m.kmsid    = INT(VAL(recid))
   m.recid    = m.kmsid
   m.frecid   = recid
   m.vs       = IIF(vid_docu='¬', ALLTRIM(nom_docu), '')
   m.dp       = m.mkdate
   m.err      = err_code
   m.comment  = err_text
   m.err_text = err_text
   m.c_okato  = ter_strah
   m.c_t      = ter_strah
   m.enp      = enp
   m.pid      = enp
*   m.ans_fl   = ans_fl
   m.fam      = ALLTRIM(fam)
   m.im       = ALLTRIM(im)
   m.ot       = ALLTRIM(ot)
   m.w        = w
   m.dr       = CTOD(SUBSTR(dr,7,2)+'.'+SUBSTR(dr,5,2)+'.'+SUBSTR(dr,1,4))
   m.enp      = enp
   m.data     = m.fdata 
   m.fam      = ALLTRIM(fam)
   m.im       = ALLTRIM(im)
   m.ot       = ALLTRIM(ot)
  
   IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
*    INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,dp,err,err_text,c_okato,enp,fam,im,ot,w,dr) VALUES ;
     ('4',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.dp,m.err,m.err_text,m.c_okato,m.enp,;
      m.fam,m.im,m.ot,m.w,m.dr)
    INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,dp,err,err_text,c_okato,enp,fam,im,ot,dr) VALUES ;
     ('4',m.fname,m.mkdate,m.kmsid,m.frecid,m.vs,m.dp,m.err,m.err_text,m.c_okato,m.enp,;
      m.fam,m.im,m.ot,m.dr)
   ENDIF 

   INSERT INTO curappgz (pv,vs,fam,im,ot,w,dr,enp,err,comment,c_t,pid,isfnd) VALUES ;
    (m.lpv,m.vs,m.fam,m.im,m.ot,m.w,m.dr,m.enp,m.err,m.err_text,m.c_okato,m.enp,.t.)
   
   IF !EMPTY(m.err)
    INSERT INTO error FROM MEMVAR 
   ENDIF 

  ENDSCAN 
 
  USE IN moves
  USE IN kms
  USE IN error

  SELECT pvlist 

 ENDSCAN 
 USE IN pvlist 
 SELECT err 
 SET ORDER TO 
 DELETE TAG ALL 
 USE
 SELECT CursZip 

 RETURN 



