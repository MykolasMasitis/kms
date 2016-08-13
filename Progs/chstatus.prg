PROCEDURE ChStatus
 IF MESSAGEBOX('ÂÛ ÕÎÒÈÒÅ ÏÐÎÂÅÑÒÈ '+CHR(13)+CHR(10)+;
               'ÇÀÌÅÍÓ ÑÒÀÒÓÑÀ Ñ 4 ÍÀ 5?!'+CHR(13)+CHR(10)+;
               '',4+48,'') != 6
  RETURN 
 ENDIF 

 IF MESSAGEBOX('ÂÛ ÀÁÑÎËÞÒÍÎ ÓÂÅÐÅÍÛ Â ÑÂÎÈÕ ÄÅÉÑÒÂÈßÕ?',4+48,'') != 6
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  RETURN 
 ENDIF 
 
 SELECT pvp2
 SCAN
  m.codpv = codpv
  m.lcpath = pbase+'\'+m.codpv
  IF !fso.FolderExists(m.lcpath)
   LOOP 
  ENDIF 
  IF !fso.FileExists(m.lcpath+'\kms.dbf')
   LOOP
  ENDIF 
  IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
   LOOP 
  ENDIF 
  WAIT m.codpv+'...' WINDOW NOWAIT 
  
  SELECT kms
  
  SCAN 
   IF status=4 AND gz_data<{06.03.2014}
    REPLACE status WITH 5
   ENDIF 
  ENDSCAN 
  
  IF USED('kms')
   USE IN kms
  ENDIF 

  WAIT CLEAR 
 ENDSCAN 
 USE IN pvp2

 
 WAIT CLEAR 

 MESSAGEBOX('OK!', 0+64, '')

RETURN 