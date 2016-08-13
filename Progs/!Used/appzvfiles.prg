PROCEDURE AppZvFiles && «‡„ÛÁÍ‡ ÒÔËÒÍÓ‚ Ì‡ ËÁ„ÓÚÓ‚ÎÂÌËÂ

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

 nnFiles = 0 
 FOR EACH oFile IN oFiles
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
  IF FCOUNT('zfile')!=8
   lIsGoodStruct = .F.
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('enp')!='ENP'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('fam')!='FAM'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('im')!='IM'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('ot')!='OT'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('dr')!='DR'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('w')!='W'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('pv')!='PV'
    lIsGoodStruct = .F.
   ENDIF 
  ENDIF 
  IF lIsGoodStruct = .T.
   IF FIELD('vsn')!='VSN'
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
  
  MESSAGEBOX(oFile.Path,0+64,'')
  
  SELECT pv, coun(*) as cnt FROM zfile GROUP BY pv ORDER BY pv INTO CURSOR zpv
  
  SCAN 
   m.pv = pv
   IF !fso.FolderExists(pbase+'\'+m.pv)
    LOOP 
   ENDIF 
   IF !fso.FileExists(pbase+'\'+m.pv+'\kms.dbf')
    LOOP 
   ENDIF 
   calias = 'kms'+m.pv
   IF OpenFile(pbase+'\'+m.pv+'\kms', calias, 'shar', 'vs')>0
    IF USED('&calias')
     USE IN &calias
    ENDIF 
    SELECT zpv
   ENDIF 
  ENDSCAN 
  
  SELECT zfile
  SCAN 
   m.pv  = pv
   m.vs  = vsn
   m.enp = enp
   
   calias = 'kms'+m.pv 
   IF USED('&calias')
    IF SEEK(m.vs, '&calias')
     REPLACE enp WITH m.enp, status WITH 4, gz_data WITH DATE() IN &calias
    ENDIF 
   ENDIF 
   
  ENDSCAN 
  USE IN zfile

  SELECT zpv
  SCAN 
   m.pv = pv
   calias = 'kms'+m.pv
   IF USED('&calias')
    USE IN &calias
   ENDIF 
  ENDSCAN 
  USE IN zpv 
  
 ENDFOR 
 
 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ ‘¿…ÀŒ¬ «¿ ŒÕ◊≈Õ¿',0+64,'')
 
RETURN 
