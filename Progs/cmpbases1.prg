PROCEDURE CmpBases1
 IF MESSAGEBOX('¬€ ’Œ“»“≈ —–¿¬Õ»“‹ ¡¿«€ œŒ RECID?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 CmpDir = fso.GetParentFolderName(pbin)+'\BASE02'
 IF !fso.FolderExists(CmpDir)
  fso.CreateFolder(CmpDir)
 ENDIF 
 RsltDir = fso.GetParentFolderName(pbin)+'\FNDLOST'
 IF !fso.FolderExists(RsltDir)
  fso.CreateFolder(RsltDir)
 ENDIF 
 
 oDir = fso.GetFolder(CmpDir)
 oFolders = oDir.SubFolders
 nFolders = oFolders.Count
 
 IF nFolders<=0
  RELEASE oDir, oFolders, nFolders
  MESSAGEBOX('¬ ƒ»–≈ “Œ–»» —–¿¬Õ≈Õ»ﬂ'+CHR(13)+CHR(10)+;
   UPPER(CmpDir)+CHR(13)+CHR(10)+;
   'Õ≈ Œ¡Õ¿–”∆≈ÕŒ Õ» ŒƒÕŒ… ƒ»–≈ “Œ–»» œ¬!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar', 'codpv')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RELEASE oDir, oFolders, nFolders
  RETURN 
 ENDIF 
 
 FOR EACH oFolder IN oFolders
  cFolder = oFolder.Name
  
  IF !SEEK(cFolder, 'pvp2')
   LOOP 
  ENDIF 
  IF !fso.FolderExists(pbase+'\'+cFolder)
   LOOP 
  ENDIF 

  IF !fso.FileExists(oFolder.Path+'\kms.dbf')
   LOOP 
  ENDIF 
  IF !fso.FileExists(pbase+'\'+cFolder+'\kms.dbf')
   LOOP 
  ENDIF 

  IF OpenFile(oFolder.Path+'\kms', 'kms02', 'shar')>0
   IF USED('kms02')
    USE IN kms02
   ENDIF
   LOOP  
  ENDIF 
  IF OpenFile(pbase+'\'+cFolder+'\kms', 'kms01', 'shar')>0
   IF USED('kms01')
    USE IN kms01
   ENDIF
   IF USED('kms02')
    USE IN kms02
   ENDIF
   LOOP  
  ENDIF 

  IF RECCOUNT('kms02')<=0
   IF USED('kms01')
    USE IN kms01
   ENDIF
   IF USED('kms02')
    USE IN kms02
   ENDIF
   LOOP  
  ENDIF 
  
  IF RECCOUNT('kms01')<=0
   IF USED('kms02')
    USE IN kms02
   ENDIF
   IF USED('kms01')
    USE IN kms01
   ENDIF
   LOOP  
  ENDIF 
  
*  SELECT fam,im,ot,w,dr,vs_data FROM kms01 INTO CURSOR kms99 READWRITE 
*  INDEX ON LEFT(fam,25)+LEFT(im,20)+LEFT(ot,20)+DTOS(dr)+DTOS(vs_data) TAG unik 
*  SET ORDER TO unik 
  
*  USE IN kms01
  
  && —Ó·ÒÚ‚ÂÌÌÓ ‡Î„ÓËÚÏ!
  rsfile = cFolder+DTOS(DATE())
  IF fso.FileExists(RsltDir+'\'+rsfile+'.dbf')
   fso.DeleteFile(RsltDir+'\'+rsfile+'.dbf')
  ENDIF 
  IF fso.FileExists(RsltDir+'\'+rsfile+'.fpt')
   fso.DeleteFile(RsltDir+'\'+rsfile+'.fpt')
  ENDIF 
  
  SELECT kms02
  COPY STRUCTURE TO &RsltDir\&rsfile
  
  IF OpenFile(RsltDir+'\'+rsfile, 'rsfile', 'excl')>0
   IF USED('rsfile')
    USE IN rsfile
   ENDIF 
   IF USED('kms02')
    USE IN kms02
   ENDIF
*   IF USED('kms99')
*    USE IN kms99
*   ENDIF
   IF USED('kms01')
    USE IN kms01
   ENDIF
   LOOP 
  ENDIF 
  
  ALTER TABLE rsfile ADD COLUMN c_err c(02)
  ALTER TABLE rsfile alter COLUMN recid i
  IF fso.FileExists(RsltDir+'\'+rsfile+'.bak')
   fso.DeleteFile(RsltDir+'\'+rsfile+'.bak')
  ENDIF 
  IF fso.FileExists(RsltDir+'\'+rsfile+'.tbk')
   fso.DeleteFile(RsltDir+'\'+rsfile+'.tbk')
  ENDIF 
  
  osetdel = SET("Deleted")
  SET DELETED ON 
*  SET ORDER TO recid IN kms99
  SET ORDER TO recid IN kms01
  SELECT kms02
  SCAN 
*   m.vir = LEFT(fam,25)+LEFT(im,20)+LEFT(ot,20)+DTOS(dr)+DTOS(vs_data)
*   IF !SEEK(m.vir, 'kms99')
*    SCATTER MEMVAR 
*    m.c_err = '03'
*    INSERT INTO rsfile FROM MEMVAR 
*   ENDIF 
*   ELSE 
   m.recid =  recid
   m.fam = fam 
   IF !SEEK(m.recid, 'kms01')
    SCATTER MEMVAR 
    m.c_err = '01'
    INSERT INTO rsfile FROM MEMVAR 
   ELSE 
    IF fam != kms01.fam
     SCATTER MEMVAR 
     m.c_err = '02'
     INSERT INTO rsfile FROM MEMVAR 
    ENDIF 
   ENDIF 

  ENDSCAN 
  
*  SELECT kms99
*  SET ORDER TO 
*  INDEX ON LEFT(fam,25)+LEFT(im,20)+LEFT(ot,20)+DTOS(dr) TAG unik 
*  SET ORDER TO unik 
  
*  SELECT rsfile
*  SCAN 
*   m.vir = LEFT(fam,25)+LEFT(im,20)+LEFT(ot,20)
*   IF SEEK(m.vir, 'kms99') AND vs_data > GOMONTH(kms99.vs_data,1)
*    DELETE 
*   ENDIF 
*  ENDSCAN 
  
  SET DELETED &osetdel
  
  && —Ó·ÒÚ‚ÂÌÌÓ ‡Î„ÓËÚÏ!

  IF USED('kms02')
   USE IN kms02
  ENDIF
*  IF USED('kms99')
*   USE IN kms99
*  ENDIF
  IF USED('kms01')
   USE IN kms01
  ENDIF
  IF USED('rsfile')
   USE IN rsfile
  ENDIF 
  MESSAGEBOX(cFolder,0+64,'')
 NEXT 
 
 IF USED('pvp2')
  USE IN pvp2
 ENDIF 
 RELEASE oDir, oFolders, nFolders
 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!',0+64,'')
RETURN 