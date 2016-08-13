PROCEDURE PutFFiles
 IF MESSAGEBOX('бш унрхре янапюрэ F-тюикш?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 pffiles = fso.GetParentFolderName(pBin)+'\FFILES'
 IF !fso.FolderExists(pffiles)
  fso.CreateFolder(pffiles)
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('нрясрябсер тюик'+CHR(13)+CHR(10)+pbin+'\PVP2.DBF',0+16,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar', 'codpv')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 IF fso.FileExists(pffiles+'\kms.dbf')
  fso.DeleteFile(pffiles+'\kms.dbf')
 ENDIF 
 IF fso.FileExists(pffiles+'\kms.cdx')
  fso.DeleteFile(pffiles+'\kms.cdx')
 ENDIF 
 
 CREATE TABLE &pffiles\kms (recid i, pv c(3), sn_card c(17), jt c(1), kl c(2), dp d, dt d, ;
  fam c(40), im c(40), ot c(40), w n(1), dr d, ul n(5), dom c(7), kor c(5), "str" c(5), kv c(5))
 INDEX ON recid TAG recid 
 USE 
 
 IF OpenFile(pffiles+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 WAIT "напюанрйю..." WINDOW NOWAIT 
 
 oZFDir    = fso.GetFolder(pffiles)
 ZFDirName = oZFDir.Path+'\' 
 oFiles    = oZFDir.Files
 nFiles    = oFiles.Count

 nnFiles = 0 
 FOR EACH oFile IN oFiles
  IF UPPER(SUBSTR(oFile.Name,1,1))!='F'
   LOOP 
  ENDIF 
  IF UPPER(SUBSTR(oFile.Name,2,2))!=m.qcod
   LOOP 
  ENDIF 
  m.pvcod = SUBSTR(oFile.Name,4,3)
  IF !SEEK(m.pvcod, 'pvp2')
   LOOP 
  ENDIF 
  
  =PutCodePage(oFile.Path, 866, .t.)

  IF OpenFile(oFile.Path, 'ffile', 'shar')>0
   IF USED('ffile')
    USE IN ffile
   ENDIF 
   LOOP 
  ENDIF 
  
  SELECT ffile
  SCAN 
   SCATTER MEMVAR 
   m.recid = INT(VAL(rec_id))
   m.sn_card =m.s_card + ' ' + PADL(m.n_card,10,'0')
   m.dr = CTOD(SUBSTR(m.dr,7,2)+'.'+SUBSTR(m.dr,5,2)+'.'+SUBSTR(m.dr,1,4))
   
   INSERT INTO kms FROM MEMVAR 
   
  ENDSCAN 
  USE IN ffile
  
*  MESSAGEBOX(oFile.Name,0+64,'')
   
  nnFiles = nnFiles + 1

 ENDFOR 
 
 USE IN kms
 
 WAIT CLEAR 
 
 MESSAGEBOX('напюанрйю гюйнмвемю.'+CHR(13)+CHR(10)+;
  'напюанрюмн '+ALLTRIM(STR(nnFiles))+' тюикнб.',0+64,'')

RETURN 