PROCEDURE OPermIdDbls
 IF MESSAGEBOX('онхяйюрэ дсакх он PERMID?'+CHR(13)+CHR(10),4+32,'')=7
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
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\permiss.dbf')
  MESSAGEBOX('нрясрярбсер тюик'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+'\PERMISS.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF  
 IF OpenFile(pbase+'\'+pvid(1,1)+'\kms', 'kms', 'excl')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\permiss', 'permiss', 'shar', 'recid')>0
  IF USED('permiss')
   USE IN permiss
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT kms 
 INDEX on permid TAG permid
 SET ORDER TO permid
 
 m.nEmpty2 = 0
 SELECT permiss
 SET RELATION TO recid INTO kms
 SCAN 
  IF EMPTY(kms.permid)
   m.nEmpty2 = m.nEmpty2 + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO kms

 m.nEmpty=0
 SELECT kms
 SET ORDER TO 
 DELETE TAG permid
 SET RELATION TO recid INTO permiss
 SCAN 
  IF EMPTY(permid)
   LOOP 
  ENDIF 
  IF EMPTY(permiss.recid)
   m.nEmpty = m.nEmpty + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO permiss
 
 SELECT permid FROM kms GROUP BY permid HAVING coun(*)>1 INTO CURSOR curdbls

 m.nDbls = _tally
 
 USE IN kms
 USE IN permiss
 
 USE IN curdbls
 
 IF m.nEmpty2 <= 0
  MESSAGEBOX('мехяонкэгселшу гюохяеи PERMISS ме намюпсфемн!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('намюпсфемн '+ALLTRIM(STR(m.nEmpty2))+' мехяонкэгселшу гюохяеи PERMISS!'+CHR(13)+CHR(10),0+64,'')
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