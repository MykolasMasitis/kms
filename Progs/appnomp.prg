PROCEDURE AppNomP
 IF MESSAGEBOX(CHR(13)+CHR(10)+'¬€ ’Œ“»“≈ «¿√–”«»“‹ ƒ¿ÕÕ€≈ ÕŒÃ≈–Õ» ¿?',4+64,'')=7
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
 
 IF OpenFile(pUpdDir+'\'+inZipFile, 'outs', 'excl')>0
  IF USED('outs')
   USE IN outs
  ENDIF 
  SET DEFAULT TO &pbin
  RETURN   
 ENDIF 
 
 WAIT "œ–≈ƒ¬¿–»“≈À‹Õ¿ﬂ Œ¡–¿¡Œ“ ¿ —“Œœ-À»—“¿..." WINDOW NOWAIT 
 SELECT outs 
 DELETE FOR q!=m.qcod
 PACK 
 WAIT "—Œ«ƒ¿Õ»≈ “≈√¿ sn_card..." WINDOW NOWAIT 
 INDEX ON s_card+' '+PADL(n_card,10,'0') TAG sn_card
 WAIT "—Œ«ƒ¿Õ»≈ “≈√¿ n_card..." WINDOW NOWAIT 
 INDEX ON n_card TAG n_card
 WAIT "—Œ«ƒ¿Õ»≈ “≈√¿ enp..." WINDOW NOWAIT 
 INDEX ON enp TAG enp
 WAIT CLEAR 
 ALTER TABLE outs ADD COLUMN procd l
 SET ORDER TO sn_card
 bakFile = STRTRAN(inZipFile,'.dbf','.bak')
 IF fso.FileExists(pUpdDir+'\'+bakFile)
  fso.DeleteFile(pUpdDir+'\'+bakFile)
 ENDIF 
 IF fso.FileExists(pcommon+'\OutS.dbf')
  fso.DeleteFile(pcommon+'\OutS.dbf')
 ENDIF 
 IF fso.FileExists(pcommon+'\OutS.cdx')
  fso.DeleteFile(pcommon+'\OutS.cdx')
 ENDIF 
 COPY TO &pcommon\OutS CDX 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À'+CHR(13)+CHR(10)+UPPER(pbin)+'\PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

* IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
*  IF USED('pvp2')
*   USE IN pvp2
*  ENDIF 
*  USE IN outs 
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
*  IF OpenFile(pbase+'\'+m.codpv+'\kms', 'kms', 'shar')>0
*   IF USED('kms')
*    USE IN kms
*   ENDIF 
*   SELECT pvp2
*   LOOP 
*  ENDIF 
  
*  WAIT m.codpv WINDOW NOWAIT 
  
*  SELECT kms
*  IF VARTYPE(act)='L'
*  SCAN 
*   m.sn_card = sn_card
*   IF EMPTY(m.sn_card)
*    LOOP 
*   ENDIF 
   
*   IF SEEK(m.sn_card, 'outs')
*    REPLACE act WITH .t.
*   ELSE 
*    REPLACE act WITH .f.
*   ENDIF 
   
*  ENDSCAN 
*  ENDIF 
  
*  IF USED('kms')
*   USE IN kms
*  ENDIF 
*  SELECT pvp2
  
*  WAIT CLEAR 
  
* ENDSCAN 
* USE IN pvp2
 SELECT outs
 SET ORDER TO 
 DELETE TAG ALL 
 USE

 SET DEFAULT TO &pbin

 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!'+CHR(13)+CHR(10),0+64,'')
 
RETURN 