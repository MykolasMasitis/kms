PROCEDURE AppIzgFiles && «‡„ÛÁÍ‡ ÔÓÎÛ˜ÂÌÌ˚ı ÔÓÎËÒÓ‚
 PUBLIC m.nNZ 
 m.nNZ = SPACE(3)

 IF MESSAGEBOX('¬€ ’Œ“»“≈ «¿√–”«»“‹'+CHR(13)+CHR(10)+;
  'Z-‘¿…À€?'+CHR(13)+CHR(10),4+32,'') == 7
  RETURN 
 ENDIF 
 
 ZFDir = fso.GetParentFolderName(pout)+'\GOZNAK'
 IF !fso.FolderExists(ZFDir)
  fso.CreateFolder(ZFDir)
  RELEASE ZFDir
  RETURN 
 ENDIF 

 oZFDir = fso.GetFolder(ZFDir)
 ZFDirName = oZFDir.Path+'\' 
 oFiles = oZFDir.Files
 nFiles = oFiles.Count
 
 IF nFiles=0
  RELEASE oZFDir, ZFDirName, oFiles, nFiles
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  RELEASE oZFDir, ZFDirName, oFiles, nFiles
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'ppvp2', 'shar')>0
  IF USED('ppvp2')
   USE IN ppvp2
  ENDIF 
  RELEASE oZFDir, ZFDirName, oFiles, nFiles
  RETURN 
 ENDIF 
 
 CREATE CURSOR pvp2 (codpv c(3))
 SELECT ppvp2
 SCAN 
  IF tip_pv!=1
   LOOP 
  ENDIF 

  m.pv = codpv 
  calias = 'kms'+m.pv
  
  IF !fso.FileExists(pbase+'\'+m.pv+'\kms.dbf')
   LOOP 
  ENDIF 

  IF OpenFile(pbase+'\'+m.pv+'\kms', calias, 'shar', 'vs')>0
   IF USED('&calias')
    USE IN &calias
   ENDIF
   LOOP 
  ELSE 
   SET STEP ON 
   INSERT INTO pvp2 (codpv) VALUES (m.pv) 
  ENDIF 

  SELECT ppvp2

 ENDSCAN 
 USE IN ppvp2

 IF m.qcod=='P2'
  DO FORM n_z
 ENDIF 

 nnFiles = 0 
 FOR EACH oFile IN oFiles
  m.nRelaced = 0
  ExtOfFile = RIGHT(LOWER(ALLTRIM(oFile.Name)),3)
  IF ExtOfFile!='dbf'
   LOOP 
  ENDIF 
  IF OpenFile(oFile.Path, 'zfile', 'shar')>0
   IF USED('zfile')
    USE IN zfile
   ENDIF 
   LOOP 
  ENDIF 
  SELECT zfile

  lIsGoodStruct = .T.
*  IF FCOUNT('zfile')!=11
*   lIsGoodStruct = .F.
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('recid')!='RECID'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('enp')!='ENP'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('fam')!='FAM'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('im')!='IM'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('ot')!='OT'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('w')!='W'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('dr')!='DR'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('ogrn')!='OGRN'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('dv')!='DV'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
*  IF lIsGoodStruct = .T.
*   IF FIELD('pv')!='PV'
*    lIsGoodStruct = .F.
*   ENDIF 
*  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('vs')!='VS'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
   
  IF lIsGoodStruct = .F.
   IF USED('zfile')
    USE IN zfile
   ENDIF 
   LOOP 
  ENDIF 
   
  nnFiles = nnFiles + 1
  
  IF RECCOUNT('zfile')<=0
   IF USED('zfile')
    USE IN zfile
   ENDIF 
   LOOP 
  ENDIF 
  
*  SELECT pv, coun(*) as cnt FROM zfile GROUP BY pv ORDER BY pv INTO CURSOR zpv
 
*  SCAN 
*   m.pv = pv
*   IF !fso.FolderExists(pbase+'\'+m.pv)
*    LOOP 
*   ENDIF 
*   IF !fso.FileExists(pbase+'\'+m.pv+'\kms.dbf')
*    LOOP 
*   ENDIF 
*   calias = 'kms'+m.pv
*   IF OpenFile(pbase+'\'+m.pv+'\kms', calias, 'shar', 'vs')>0
*    IF USED('&calias')
*     USE IN &calias
*    ENDIF 
*    SELECT zpv
*   ENDIF 
*  ENDSCAN 
  
  SELECT zfile
  SCAN 
*   m.pv  = pv
   m.vs  = vs
   m.enp = enp
   
   m.lIsFound = .f.

   SELECT pvp2
   SCAN 
    m.pv = codpv 
    calias = 'kms'+m.pv
    SELECT &calias
    IF SEEK(m.vs, '&calias')
*     REPLACE enp WITH m.enp, status WITH 5, gz_data WITH DATE() IN &calias
     m.nRelaced = m.nRelaced + 1
     m.lIsFound = .t.
     REPLACE enp WITH m.enp, status WITH 5, gz_data WITH DATE()
     IF m.qcod=='P2'
      REPLACE nz WITH m.nNZ
     ENDIF 
     SELECT zfile
     EXIT 
    ENDIF 
    SELECT pvp2
   ENDSCAN 

   IF m.lIsFound = .f.
    MESSAGEBOX('¬— '+m.vs+' Õ≈ Õ¿…ƒ≈Õ!',0+64,'')
   ENDIF 

   SELECT zfile
   
*   calias = 'kms'+m.pv 
*   IF USED('&calias')
*    IF SEEK(m.vs, '&calias')
*     REPLACE enp WITH m.enp, status WITH 5, gz_data WITH DATE() IN &calias
*     IF m.qcod=='P2'
*      REPLACE nz WITH m.nNZ
*     ENDIF 
*    ENDIF 
*   ENDIF 
   
  ENDSCAN 
  USE IN zfile

*  SELECT zpv
*  SCAN 
*   m.pv = pv
*   calias = 'kms'+m.pv
*   IF USED('&calias')
*    USE IN &calias
*   ENDIF 
*  ENDSCAN 
*  USE IN zpv 

 MESSAGEBOX('œŒ ƒ¿ÕÕ€Ã ‘¿…À¿ '+oFile.Path+CHR(13)+CHR(10)+;
  '«¿Ã≈Õ≈ÕŒ '+TRANSFORM(m.nRelaced,'99999')+' «¿œ»—≈…!',0+64,'')
  
 ENDFOR 
 
 SELECT pvp2
 SCAN 
  IF tip_pv!=1
   LOOP 
  ENDIF 
  m.pv = codpv 
  calias = 'kms'+m.pv
  IF USED('&calias')
   USE IN &calias
  ENDIF 
  SELECT pvp2
 ENDSCAN 
 USE IN pvp2

 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ ‘¿…ÀŒ¬ «¿ ŒÕ◊≈Õ¿',0+64,'')
 
RETURN 
