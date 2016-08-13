PROCEDURE OFioIdDblsя
 IF MESSAGEBOX('хяопюбхрэ он OFIOID?'+CHR(13)+CHR(10),4+32,'')=7
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
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\ofio.dbf')
  MESSAGEBOX('нрясрярбсер тюик'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+'\OFIO.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF  
 IF OpenFile(pbase+'\'+pvid(1,1)+'\kms', 'kms', 'excl')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\ofio', 'ofio', 'shar', 'recid')>0
  IF USED('ofio')
   USE IN ofio
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 

 m.nDbls = 0
 SELECT kms
 SET RELATION TO ofioid INTO ofio
 SCAN 
  IF EMPTY(ofioid)
   LOOP 
  ENDIF 
  IF dr!=ofio.dr AND ot!=ofio.ot AND im!=ofio.im AND fam!=ofio.fam
   REPLACE ofioid WITH 0
   m.nDbls = m.nDbls + 1
  ENDIF 
 ENDSCAN 
 
 m.nEmpty=0
 SELECT kms
 SCAN 
  IF EMPTY(ofioid)
   LOOP 
  ENDIF 
  IF EMPTY(ofio.recid)
   REPLACE ofioid WITH 0
   m.nEmpty = m.nEmpty + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO ofio 

 SELECT kms 
 INDEX on ofioid TAG ofioid
 SET ORDER TO ofioid
 
 m.nEmpty2 = 0
 SELECT ofio
 SET RELATION TO recid INTO kms
 SCAN 
  IF EMPTY(kms.ofioid)
   DELETE 
   m.nEmpty2 = m.nEmpty2 + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO kms
 SELECT kms
 SET ORDER TO 
 DELETE TAG ofioid

* SELECT ofioid FROM kms GROUP BY ofioid HAVING coun(*)>1 INTO CURSOR curdbls
* m.nDbls = _tally
 
 USE IN kms
 USE IN ofio
 
* USE IN curdbls
 
 IF m.nEmpty2 <= 0
  MESSAGEBOX('мехяонкэгселшу гюохяеи OFIO ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('сдюкемн '+ALLTRIM(STR(m.nEmpty2))+' мехяонкэгселшу гюохяеи OFIO!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nEmpty<=0
  MESSAGEBOX('мехяонкэгселшу яяшкнй б KMS ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('сдюкемн '+ALLTRIM(STR(m.nEmpty))+' мехяонкэгселшу гюохяеи KMS!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nDbls<=0
  MESSAGEBOX('дсакеи ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('намюпсфемн '+ALLTRIM(STR(m.nDbls))+' дсакеи'+CHR(13)+CHR(10),0+64,'')
 ENDIF 
 
 
RETURN 