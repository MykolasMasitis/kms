PROCEDURE AppGZFiles
 IF MESSAGEBOX(CHR(13)+CHR(10)+PADC("Вы хотите загрузить",30)+CHR(13)+CHR(10)+;
  PADC("файлы сопровождения Гознака",30)+CHR(13)+CHR(10)+;
  PADC("(Z-файлы)?",30),4+32, "!") == 7
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  RETURN 
 ENDIF 
 
 CREATE CURSOR pvs (cpv c(3), alname c(6), nkms n(11))
 SELECT pvp2
 nPV = 0
 SCAN 
  IF tip_pv == 1
   cCodPV = CodPV
   IF fso.FolderExists(pbase+'\'+cCodPV)
    IF fso.FileExists(pbase+'\'+cCodPV+'\kms.dbf')
     IF OpenFile(pbase+'\'+cCodPV+'\kms', 'kms'+cCodPV, 'shar', 'vs')==0
      nPV = nPV+1
      INSERT INTO pvs (cPV, alname, nkms) VALUES (cCodPV, 'kms'+cCodPV, 0)
     ENDIF 
    ENDIF 
   ENDIF 
  ENDIF 
 ENDSCAN 
 USE 
 
 ZFDir = fso.GetParentFolderName(pout)+'\GOZNAK'
 IF !fso.FolderExists(ZFDir)
  fso.CreateFolder(ZFDir)
 ENDIF 

 oZFDir = fso.GetFolder(ZFDir)
 ZFDirName = oZFDir.Path+'\' 
 oFiles = oZFDir.Files
 nFiles = oFiles.Count

 nnFiles = 0 
 FOR EACH oFile IN oFiles
  ExtOfFile = RIGHT(LOWER(ALLTRIM(oFile.Name)),3)
  IF ExtOfFile == 'dbf'
  
   nnFiles = nnFiles + 1
   
   IF OpenFile(oFile.Path, 'zfile', 'shar')>0
    LOOP 
   ENDIF 
   SELECT zfile
   lIsGoodStruct = .T.
   
   IF FIELD('enp') != 'ENP'
    lIsGoodStruct = .F.
   ENDIF 
   IF FIELD('vs') != 'VS'
    lIsGoodStruct = .F.
   ENDIF 
   
   IF lIsGoodStruct = .F.
    USE 
    LOOP 
   ENDIF 
   
   SCAN 
    m.vs = vs
    m.enp = enp
    m.status = 4
    m.gz_data = DATE()
    
    SELECT pvs 
    SCAN 
     m.calias = alname
*     MESSAGEBOX(m.calias,0+64,'')
     IF SEEK(m.vs, m.calias)
      m.nkms = nkms
      m.nkms = m.nkms + 1
      REPLACE nkms WITH m.nkms
      SELECT (calias)
      REPLACE enp WITH m.enp, status WITH m.status, gz_data WITH m.gz_data
      SELECT pvs
      LOOP 
     ENDIF 
    ENDSCAN 
    SELECT zfile
    
   ENDSCAN 

   USE 

  ENDIF 

 ENDFOR 
 
 SELECT pvs 
 SCAN 
  m.calias = alname
  USE IN &calias
 ENDSCAN 

 BROWSE  
 USE 
 
RETURN 