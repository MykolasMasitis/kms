PROCEDURE AppGFileE
 PUBLIC m.nNZ
 m.nNZ = SPACE(3)

 IF MESSAGEBOX("ÂÛ ÕÎÒÈÒÅ ÇÀÃÐÓÇÈÒÜ"+CHR(13)+CHR(10)+;
  "ÔÀÉËÛ ÑÎÏÐÎÂÎÆÄÅÍÈß ÃÎÇÍÀÊÀ?"+CHR(13)+CHR(10),4+32, "") == 7
  RETURN 
 ENDIF 
 
 IF OpenFile(pbase+'\kms', 'kms', 'shar', 'vs')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(PBase+'\moves', 'moves', 'shar', 'unik')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('moves')
   USE IN moves
  ENDIF 
  RETURN 
 ENDIF 

 CREATE CURSOR curappgz (nrec n(5),pv c(3), vs c(9), fam c(25), im c(20), ot c(20), w n(1), dr d, enp c(16), isfnd l)

 IF m.qcod=='P2'
  DO FORM n_z
 ENDIF 

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
  IF ExtOfFile != 'dbf'
   LOOP 
  ENDIF 
  IF LOWER(LEFT(oFile.Name,6))!='goznak'
   LOOP 
  ENDIF 
  IF UPPER(SUBSTR(oFile.Name,8,2))!=m.qcod
   LOOP 
  ENDIF 
  m.fdata = CTOD(SUBSTR(oFile.Name,15,2)+'.'+SUBSTR(oFile.Name,13,2)+'.20'+SUBSTR(oFile.Name,11,2))
  IF !BETWEEN(m.fdata,{01.01.2001},DATE())
   LOOP 
  ENDIF 
  
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
  
  SELECT zfile
  SCAN 
   m.pvv = PADL(ALLTRIM(pv),3,'0')
   
   m.vs      = vs
   m.enp     = enp
   m.status  = 5
   m.gz_data = DATE()
   
   m.fam = fam
   m.im  = im
   m.ot  = ot
   m.w   = w
   m.dr  = CTOD(SUBSTR(dr,7,2)+'.'+SUBSTR(dr,5,2)+'.'+SUBSTR(dr,1,4))
    
   m.fname  = UPPER(ofile.name)
   m.mkdate = data_fond
   m.vs     = vs
   m.enp    = enp
   m.nz     = nz
   m.n_kor  = n_kor
   m.dp     = CTOD(SUBSTR(dat_u,7,2)+'.'+SUBSTR(dat_u,5,2)+'.'+SUBSTR(dat_u,1,4))
   m.kmsid  = IIF(SEEK(m.vs, 'kms', 'vs'), kms.recid, 0)
   m.frecid = IIF(m.kmsid>=0, PADL(m.kmsid,6,'0'), '')
 
   IF SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
    DELETE FROM moves WHERE fname+frecid=PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid
   ENDIF 
   IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, 'moves')
    INSERT INTO moves (et,fname,mkdate,dp,kmsid,frecid,vs,enp,nz,n_kor) VALUES ;
     ('6',m.fname,m.mkdate,m.dp,m.kmsid,m.frecid,m.vs,m.enp,m.nz,m.n_kor)
   ENDIF 
   
   m.isfnd = .f.   

   IF SEEK(m.vs, 'kms')
    m.isfnd = .t.   
    SELECT kms
    REPLACE enp WITH m.enp, status WITH m.status, gz_data WITH m.gz_data
    IF m.qcod=='P2'
     REPLACE nz WITH m.nNZ
    ENDIF 
    SELECT zfile
   ENDIF 
    
   INSERT INTO curappgz (pv,vs,fam,im,ot,w,dr,enp,isfnd) VALUES ;
    (m.pvv,m.vs,m.fam,m.im,m.ot,m.w,m.dr,m.enp,m.isfnd)

  ENDSCAN 

  USE 

 ENDFOR 

 IF USED('kms')
  USE IN kms
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 
 
 SELECT curappgz
 IF RECCOUNT('curappgz')>0
  REPORT FORM AppGFile PREVIEW 
 ENDIF 
 USE 
 
RETURN 