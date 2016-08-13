PROCEDURE ODocIdDbls
 IF MESSAGEBOX('онхяйюрэ дсакх он ODOCID?'+CHR(13)+CHR(10),4+32,'')=7
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
   m.nEmpty = m.nEmpty + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO odoc 
 
 SELECT odocid FROM kms GROUP BY odocid HAVING coun(*)>1 INTO CURSOR curdbls

 m.nDbls = _tally
 
 USE IN kms
 USE IN odoc
 
 USE IN curdbls
 
 IF m.nEmpty2 <= 0
  MESSAGEBOX('мехяонкэгселшу гюохяеи ODOC ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('намюпсфемн '+ALLTRIM(STR(m.nEmpty2))+' мехяонкэгселшу гюохяеи ODOC!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nEmpty<=0
  MESSAGEBOX('мехяонкэгселшу яяшкнй б KMS ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('намюпсфемн '+ALLTRIM(STR(m.nEmpty))+' мехяонкэгселшу гюохяеи KMS!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nDbls<=0
  MESSAGEBOX('дсакеи ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('намюпсфемн '+ALLTRIM(STR(m.nDbls))+' дсакеи'+CHR(13)+CHR(10),0+64,'')
 ENDIF 
 
 
RETURN 