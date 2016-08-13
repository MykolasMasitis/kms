PROCEDURE AppStopList
 IF MESSAGEBOX(CHR(13)+CHR(10)+'¬€ ’Œ“»“≈ «¿√–”«»“‹ ƒ¿ÕÕ€≈ —“Œœ-À»—“¿?',4+64,'')=7
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pcommon+'\sprsmo.dbf')
  MESSAGEBOX('Œ“—”“—¬”≈“ ‘¿…À SPRSMO.DBF',0+16,'COMMON')
  RETURN 
 ENDIF 
 
 IF OpenFile(pcommon+'\sprsmo', 'sprsmo', 'shar', 'smo_id')>0
  IF USED('sprsmo')
   USE IN sprsmo
  ENDIF 
  RETURN 
 ENDIF 

 pUpdDir = fso.GetParentFolderName(pbin)+'\UPDATE'
 IF !fso.FolderExists(pUpdDir)
  fso.CreateFolder(pUpdDir)
 ENDIF 
 
 SET DEFAULT TO (pUpdDir)
 ZipFile = ''
 ZipFile = GETFILE('zip')
 IF EMPTY(ZipFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'¬€ Õ»◊≈√Œ Õ≈ ¬€¡–¿À»!'+CHR(13)+CHR(10),0+16,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 
 
 oZipFile = fso.GetFile(ZipFile)
 IF LOWER(LEFT(oZipFile.name,4)) != 'stop'
  MESSAGEBOX(CHR(13)+CHR(10)+'›“Œ Õ≈ ¿–’»¬ —“Œœ-À»—“¿!'+CHR(13)+CHR(10),0+16,'')
  RELEASE ZipFile
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

 IF oZipFile.size >= 2
  fhandl = oZipFile.OpenAsTextStream
  lcHead = fhandl.Read(2)
  fhandl.Close
 ELSE 
  MESSAGEBOX(CHR(13)+CHR(10)+'–¿«Ã≈– ‘¿…À¿ Ã≈Õ≈≈ 2 ¡»“!'+CHR(13)+CHR(10),0+16,'')
  RELEASE oZipFile
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

 IF lcHead!='PK' && ›ÚÓ zip-Ù‡ÈÎ!
  MESSAGEBOX(CHR(13)+CHR(10)+'›“Œ Õ≈ ZIP-¿–’»¬!'+CHR(13)+CHR(10),0+16,'')
  RELEASE oZipFile
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

 inZipFile = STRTRAN(oZipFile.name,'.zip','.dbf')
 UnzipOpen(ZipFile)
 IF UnzipGotoFileByName(inZipFile)
  llIsOneZip = .t.
  UnzipClose()
 ENDIF 
 UnzipClose()
 RELEASE oZipFile
 
 IF !llIsOneZip
  MESSAGEBOX(CHR(13)+CHR(10)+'¿–’»¬ Õ≈ —Œƒ≈–∆»“ ‘¿…À'+CHR(13)+CHR(10)+;
  '— Œ∆»ƒ¿≈Ã€Ã Õ¿«¬¿Õ»≈Ã '+UPPER(inZipFile)+'!'+CHR(13)+CHR(10),0+16,'') 
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

 IF fso.FileExists(pUpdDir+'\'+inZipFile)
  fso.DeleteFile(pUpdDir+'\'+inZipFile)
 ENDIF 
 
 WAIT "–¿«¿–’»¬»–”ﬁ..." WINDOW NOWAIT 
 UnzipOpen(ZipFile)
 UnzipGotoFileByName(inZipFile)
 UnzipFile(pUpdDir)
 UnzipClose()
 WAIT CLEAR 
 
 IF !fso.FileExists(pUpdDir+'\'+inZipFile)
  MESSAGEBOX('Õ≈ ”ƒ¿ÀŒ—‹ »«¬À≈◊‹ ‘¿…À »« ¿–’»¬¿!'+CHR(13)+CHR(10),0+64,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

 oApp.CodePage(pUpdDir+'\'+inZipFile, 866, .t.)
 
 IF OpenFile(pUpdDir+'\'+inZipFile, 'stop', 'excl')>0
  IF USED('stop')
   USE IN stop
  ENDIF 
  SET DEFAULT TO &pbin
  RETURN   
 ENDIF 
 
 WAIT "œ–≈ƒ¬¿–»“≈À‹Õ¿ﬂ Œ¡–¿¡Œ“ ¿ —“Œœ-À»—“¿..." WINDOW NOWAIT 
 SELECT stop 
 INDEX ON s_card+' '+PADL(n_card,10,'0') TAG sn_card
 INDEX ON s_cardz+' '+PADL(n_cardz,10,'0') TAG sn_cardz
 ALTER TABLE stop ADD COLUMN procd l
 IF VARTYPE(q)='C'
 ELSE 
  ALTER table stop ADD COLUMN Qn c(2)
  ALTER table stop ADD COLUMN QZn c(2)
  REPLACE ALL qn WITH IIF(SEEK(q, 'sprsmo'), sprsmo.qq, '')
  REPLACE ALL qzn WITH IIF(SEEK(qz, 'sprsmo'), sprsmo.qq, '')
  ALTER TABLE stop drop COLUMN q
  ALTER table stop drop COLUMN qz 
  ALTER table stop  rename COLUMN qn to q 
  ALTER table stop  rename COLUMN qzn to qz
 ENDIF  
 DELETE FOR q!=m.qcod
 PACK 
 bakFile = STRTRAN(inZipFile,'.dbf','.bak')
 IF fso.FileExists(pUpdDir+'\'+bakFile)
  fso.DeleteFile(pUpdDir+'\'+bakFile)
 ENDIF 
 WAIT CLEAR 
 COPY TO &pcommon\StopList CDX 
 DELETE TAG ALL 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À'+CHR(13)+CHR(10)+UPPER(pbin)+'\PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

* IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
*  IF USED('pvp2')
*   USE IN pvp2
*  ENDIF 
*  USE IN stop 
*  SET DEFAULT TO &pbin
*  RETURN 
* ENDIF 
 
* SELECT pvp2
* SCAN 
*  m.codpv = codpv
  
*  IF !fso.FolderExists(pbase+'\'+m.codpv)
*   LOOP 
*  ENDIF 
*  IF !fso.FileExists(pbase+'\'+m.codpv+'\kms.dbf')
*   LOOP 
*  ENDIF 
*  IF !fso.FileExists(pbase+'\'+m.codpv+'\stop.dbf')
*   LOOP 
*  ENDIF 
*  IF OpenFile(pbase+'\'+m.codpv+'\kms', 'kms', 'shar', 'sn_card')>0
*   IF USED('kms')
*    USE IN kms
*   ENDIF 
*   SELECT pvp2
*   LOOP 
*  ENDIF 
*  IF OpenFile(pbase+'\'+m.codpv+'\stop', 'stoppv', 'shar', 'sn_card')>0
*   IF USED('kms')
*    USE IN kms
*   ENDIF 
*   IF USED('stoppv')
*    USE IN stoppv
*   ENDIF 
*   SELECT pvp2
*   LOOP 
*  ENDIF 
  
*  WAIT m.codpv WINDOW NOWAIT 
  
*  SELECT stop
*  SCAN 
*   SCATTER MEMVAR 
*   m.sn_card  = IIF(m.n_card>0, m.s_card+' '+PADL(m.n_card,10,'0'), '')
*   m.sn_cardz = IIF(m.n_cardz>0, m.s_cardz+' '+PADL(m.n_cardz,10,'0'), '')
*   m.vs       = vsn
*   RELEASE s_card,n_card,s_cardz,n_cardz,vsn
   
*   IF SEEK(m.sn_card, 'kms')
*    REPLACE procd WITH .t.
*    IF kms.act=.t.
*     REPLACE act WITH .f. IN kms 
*    ENDIF 
*    IF !SEEK(m.sn_card, 'stoppv')
*     INSERT INTO stoppv FROM MEMVAR
*    ENDIF  
*   ENDIF 
   
*  ENDSCAN 
  
*  IF USED('kms')
*   USE IN kms
*  ENDIF 
*  IF USED('stoppv')
*   USE IN stoppv
*  ENDIF 
*  SELECT pvp2
  
*  WAIT CLEAR 
  
* ENDSCAN 
* USE IN pvp2
 USE IN stop 
 USE IN sprsmo

 SET DEFAULT TO &pbin

 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!'+CHR(13)+CHR(10),0+64,'')
 
RETURN 