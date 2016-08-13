PROCEDURE FindDFilesE

 IF MESSAGEBOX(CHR(13)+CHR(10)+'¬€ ’Œ“»“≈ «¿√–”«»“‹ D-‘¿…À€?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 oDir            = fso.GetFolder(pExpImp)
 DirName         = oDir.Path
 oFilesInMailDir = oDir.Files
 nFilesInMailDir = oFilesInMailDir.Count

 IF nFilesInMailDir<=0
  MESSAGEBOX(CHR(13)+CHR(10)+'¬ ƒ»–≈ “Œ–»» '+UPPER(pexpimp)+'Õ≈ Œ¡Õ¿–”∆≈ÕŒ Õ» ŒƒÕŒ√Œ ‘¿…À¿!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ENDIF 

 m.PrFile       = 0
 m.ProceedBefore = 0
 m.nIsDFiles    = 0
 m.nEmptyDFiles = 0
 m.nCantFindPV  = 0

 FOR EACH oFileInMailDir IN oFilesInMailDir
  m.FileName  = oFileInMailDir.Path
  m.bname     = oFileInMailDir.Name
  m.recieved  = oFileInMailDir.DateLastModified
  
  IF LEN(m.bname)<>15
   LOOP 
  ENDIF 
  IF RIGHT(UPPER(m.bname),3) != 'DBF'
   LOOP 
  ENDIF 
  IF LEFT(UPPER(m.bname),3) != UPPER('D'+m.qcod)
   LOOP 
  ENDIF 
 
  oApp.CodePage(m.FileName, 866, .t.)

  IF OpenFile(m.FileName, 'dfile', 'excl')>0
   IF USED('dfile')
    USE IN dfile
   ENDIF
   LOOP  
  ENDIF 

  m.nIsDFiles = m.nIsDFiles + 1

  SELECT dfile
  m.RecsInDFile = RECCOUNT()
  IF m.RecsInDFile <= 0
   m.nEmptyDFiles = m.nEmptyDFiles + 1
   IF USED('dfile')
    USE IN dfile
   ENDIF
   LOOP  
  ENDIF 

  m.pv     = SUBSTR(m.bname,4,3)
  m.f_data = file_date
  
  m.lIsUsedPv = .t.
  
  IF m.lIsUsedPv = .t.
   IF !fso.FolderExists(pbase+'\'+m.pv)
    m.lIsUsedPv = .f.
   ENDIF 
  ENDIF 
  IF m.lIsUsedPv = .t.
   IF !fso.FileExists(pbase+'\'+m.pv+'\kms.dbf')
    m.lIsUsedPv = .f.
   ENDIF 
  ENDIF 
  IF m.lIsUsedPv = .t.
   IF OpenFile(pbase+'\'+m.pv+'\kms', 'kms', 'shar', 'vs')>0
    m.lIsUsedPv = .f.
    IF USED('kms')
     USE IN kms
    ENDIF 
   ENDIF 
  ENDIF 
  
  IF !m.lIsUsedPv
   m.nCantFindPV = m.nCantFindPV + 1
   IF USED('dfile')
    USE IN dfile
   ENDIF
   IF USED('kms')
    USE IN kms
   ENDIF 
   MESSAGEBOX(CHR(13)+CHR(10)+'¬Õ»Ã¿Õ»≈!'+CHR(13)+CHR(10)+;
    'Õ≈ Õ¿…ƒ≈Õ¿ ƒ»–≈ “Œ–»ﬂ '+CHR(13)+CHR(10)+m.pv+' œ”Õ “¿ ¬€ƒ¿◊»!'+CHR(13)+CHR(10)+;
    'D-‘¿…À '+m.bname+' œ–Œ»√ÕŒ–»–Œ¬¿Õ!',0+64,'')
   LOOP  
  ENDIF 
  
  IF !fso.FileExists(pbase+'\'+m.pv+'\e_ffoms.dbf')
   CREATE TABLE &ppath\e_ffoms (v l, dcor d, recid i, data d, err c(5), ;
    "comment" c(250), c_t c(5), pid c(16), ans_fl c(2), step c(4))
   INDEX ON recid TAG recid
   USE 
  ENDIF 
  
  IF OpenFile(pbase+'\'+m.pv+'\e_ffoms', 'errors', 'shar')>0
   IF USED('errors')
    USE IN errors
   ENDIF
   IF USED('dfile')
    USE IN dfile
   ENDIF
   IF USED('kms')
    USE IN kms
   ENDIF 
   LOOP 
  ENDIF 
  
  SELECT * FROM errors WHERE data=m.f_data INTO CURSOR curpv
  m.RecsInErrors = RECCOUNT('curpv')
  USE IN curpv
  
  IF m.RecsInErrors==m.RecsInDFile
   m.ProceedBefore = m.ProceedBefore + 1
   IF USED('errors')
    USE IN errors
   ENDIF
   IF USED('dfile')
    USE IN dfile
   ENDIF
   IF USED('kms')
    USE IN kms
   ENDIF 
   LOOP 
  ENDIF 

  SELECT dfile
  SCAN 

   SCATTER MEMVAR
   
   m.recid    = VAL(m.recid)
   m.c_t      = m.ter_strah
   m.enp      = m.pid
   m.vs       = m.vsn
   m.data     = file_date
   m.err      = m.err_code
   m.recid_pv = IIF(SEEK(m.vsn, 'kms'), kms.recid, 0)
   m.comment  = m.err_text

   INSERT INTO errors FROM MEMVAR 

  ENDSCAN 

  USE IN dfile
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('errors')
   USE IN errors
  ENDIF 
  
  m.PrFile = m.PrFile + 1
  
 ENDFOR 

 MESSAGEBOX(CHR(13)+CHR(10)+'Œ¡–¿¡Œ“¿ÕŒ '+TRANSFORM(m.PrFile,'9999')+' ‘¿…À¿(Œ¬)!'+CHR(13)+CHR(10)+;
  'Œ¡–¿¡Œ“¿ÕŒ –¿Õ≈≈ '+TRANSFORM(m.ProceedBefore,'9999')+' ‘¿…À¿(Œ¬)!'+CHR(13)+CHR(10),0+64,'')
 
RETURN 