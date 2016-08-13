PROCEDURE ODocIdDblsя
 IF MESSAGEBOX('хяопюбхрэ детейрш он ODOCID?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF kol_pv<>1
  MESSAGEBOX('днкфем ашрэ бшапюм ндмх осмйр!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FolderExists(pbase+'\'+pvid(1,1))
  MESSAGEBOX('нрясрярбсер дхпейрнпхъ'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\kms.dbf')
  MESSAGEBOX('нрясрярбсер тюик'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+'\KMS.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF  
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\odoc.dbf')
  MESSAGEBOX('нрясрярбсер тюик'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+'\ODOC.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF  
 IF OpenFile(pbase+'\'+pvid(1,1)+'\kms', 'kms', 'excl')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\odoc', 'odoc', 'shar', 'recid')>0
  IF USED('odoc')
   USE IN odoc
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT kms 
 INDEX on odocid TAG odocid
 SET ORDER TO odocid
 
 m.nEmpty2 = 0
 SELECT odoc
 SET RELATION TO recid INTO kms
 SCAN 
  IF EMPTY(kms.odocid)
   DELETE 
   m.nEmpty2 = m.nEmpty2 + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO kms

 m.nEmpty=0
 SELECT kms
 SET ORDER TO 
 DELETE TAG odocid
 SET RELATION TO odocid INTO odoc
 SCAN 
  IF EMPTY(odocid)
   LOOP 
  ENDIF 
  IF EMPTY(odoc.recid)
   DELETE 
   m.nEmpty = m.nEmpty + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO odoc 
 
 SELECT recid, odocid FROM kms WHERE odocid in (SELECT odocid FROM kms WHERE !EMPTY(odocid) GROUP BY odocid HAVING coun(*)>1) INTO CURSOR curdbls
 m.nDbls = _tally
 INDEX on recid TAG recid 
 SET ORDER TO recid 
 
 m.nDbls2 = 0
 SELECT kms
 SET RELATION TO recid INTO curdbls
 SCAN
  IF EMPTY(curdbls.odocid)
   LOOP 
  ENDIF 
  m.status = status
  IF INLIST(m.status,1,2,3,9)
   m.nDbls2 = m.nDbls2 + 1
   REPLACE odocid WITH 0
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO curdbls
 
 USE IN kms
 USE IN odoc
 
 USE IN curdbls
 
 IF m.nEmpty2 <= 0
  MESSAGEBOX('мехяонкэгселшу гюохяеи ODOC ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('сдюкемн '+ALLTRIM(STR(m.nEmpty2))+' мехяонкэгселшу гюохяеи ODOC!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nEmpty<=0
  MESSAGEBOX('мехяонкэгселшу яяшкнй б KMS ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('сдюкемн '+ALLTRIM(STR(m.nEmpty))+' мехяонкэгселшу гюохяеи KMS!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nDbls<=0
  MESSAGEBOX('дсакеи ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('сдюкемн '+ALLTRIM(STR(m.nDbls2))+' дсакеи хг '+ALLTRIM(STR(m.nDbls))+'!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 
 
 
RETURN 