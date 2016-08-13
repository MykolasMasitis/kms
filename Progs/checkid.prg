PROCEDURE CheckId
 IF MESSAGEBOX('опнбепхрэ смхйюкэмнярэ ID?',4+32,'')=7
  RETURN 
 ENDIF 

 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
  m.lppath = pBase
  m.kol_pv = 1
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
 ENDIF 

 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('нрясрябсер тюик PVP2.DBF',0+16,'')
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 

 SELECT pvp2
 SCAN 
  m.tip_pv = tip_pv
  IF m.tip_pv=2
   LOOP
  ENDIF 
  
  m.codpv = codpv
  
  IF !fso.FolderExists(pbase+'\'+m.codpv)
   LOOP 
  ENDIF 
  IF !fso.FileExists(pbase+'\'+m.codpv+'\kms.dbf')
   LOOP 
  ENDIF 
  IF OpenFile(pbase+'\'+m.codpv+'\kms', 'kms', 'shar')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
   SELECT pvp2
   LOOP 
  ENDIF 
   
  WAIT m.codpv+'...' WINDOW NOWAIT 
  
  m.nperm2 = 0 
  m.nodoc  = 0 
  m.nofio  = 0 
  m.nperm  = 0 
  m.nenp2  = 0 

  SELECT odocid as nid FROM kms WHERE !EMPTY(odocid) GROUP BY odocid HAVING COUNT(*)>1 INTO CURSOR curdbls
  INDEX on nid TAG nid
  SET ORDER TO nid
  IF RECCOUNT('curdbls')<=0
   USE IN curdbls
  ELSE 
   SELECT kms 
   SET RELATION TO odocid INTO curdbls
   SCAN FOR !EMPTY(curdbls.nid)
    m.nodoc = m.nodoc + 1
    REPLACE odocid WITH 0
   ENDSCAN 
   SET RELATION OFF INTO curdbls
   USE IN curdbls
  ENDIF 

  SELECT ofioid as nid FROM kms WHERE !EMPTY(ofioid) GROUP BY ofioid HAVING COUNT(*)>1 INTO CURSOR curdbls
  INDEX on nid TAG nid
  SET ORDER TO nid
  IF RECCOUNT('curdbls')<=0
   USE IN curdbls
  ELSE 
   SELECT kms 
   SET RELATION TO ofioid INTO curdbls
   SCAN FOR !EMPTY(curdbls.nid)
    m.nofio = m.nofio + 1
    REPLACE ofioid WITH 0
   ENDSCAN 
   SET RELATION OFF INTO curdbls
   USE IN curdbls
  ENDIF 

  SELECT permid as nid FROM kms WHERE !EMPTY(permid) GROUP BY permid HAVING COUNT(*)>1 INTO CURSOR curdbls
  INDEX on nid TAG nid
  SET ORDER TO nid
  IF RECCOUNT('curdbls')<=0
   USE IN curdbls
  ELSE 
   SELECT kms 
   SET RELATION TO permid INTO curdbls
   SCAN FOR !EMPTY(curdbls.nid)
    m.nperm = m.nperm + 1
    REPLACE permid WITH 0
   ENDSCAN 
   SET RELATION OFF INTO curdbls
   USE IN curdbls
  ENDIF 

  SELECT enp2id as nid FROM kms WHERE !EMPTY(enp2id) GROUP BY enp2id HAVING COUNT(*)>1 INTO CURSOR curdbls
  INDEX on nid TAG nid
  SET ORDER TO nid
  IF RECCOUNT('curdbls')<=0
   USE IN curdbls
  ELSE 
   SELECT kms 
   SET RELATION TO enp2id INTO curdbls
   SCAN FOR !EMPTY(curdbls.nid)
    m.nenp2 = m.nenp2 + 1
    REPLACE enp2id WITH 0
   ENDSCAN 
   SET RELATION OFF INTO curdbls
   USE IN curdbls
  ENDIF 

  USE IN kms

  IF m.nperm2>0 OR m.nodoc>0 OR m.nofio>0 OR m.nperm>0 OR m.nenp2>0
   WAIT CLEAR 
  
   m.stroka = IIF(m.nperm2>0,'дсакеи он PERM2ID'+TRANSFORM(m.nperm2,'999')+CHR(13)+CHR(10),'')+;
    IIF(m.nodoc>0,'дсакеи он ODOCID'+TRANSFORM(m.nodoc,'999')+CHR(13)+CHR(10),'')+;
    IIF(m.nofio>0,'дсакеи он OFIOID'+TRANSFORM(m.nofio,'999')+CHR(13)+CHR(10),'')

   m.stroka = m.stroka + ;
    IIF(m.nperm>0,'дсакеи он PERMID'+TRANSFORM(m.nperm,'999')+CHR(13)+CHR(10),'')+;
    IIF(m.nenp2>0,'дсакеи он ENP2ID'+TRANSFORM(m.nenp2,'999')+CHR(13)+CHR(10),'')
    
   MESSAGEBOX(m.stroka,0+64,m.codpv)
   
  ENDIF 
  
  WAIT CLEAR 
  
 ENDSCAN 
 USE IN pvp2 
 MESSAGEBOX('напюанрйю гюйнмвемю!',0+64,'')
RETURN 