PROCEDURE CorStructE
 IF MESSAGEBOX('ÂÛ ÕÎÒÈÒÅ ÏÐÎÂÅÑÒÈ '+CHR(13)+CHR(10)+;
               'ÊÎÐÐÅÊÒÈÐÎÂÊÓ ÑÒÐÓÊÒÓÐÛ ÁÄ?!'+CHR(13)+CHR(10)+;
               '',4+48,'') != 6
  RETURN 
 ENDIF 

 IF MESSAGEBOX('ÂÛ ÀÁÑÎËÞÒÍÎ ÓÂÅÐÅÍÛ Â ÑÂÎÈÕ ÄÅÉÑÒÂÈßÕ?',4+48,'') != 6
  RETURN 
 ENDIF 

 IF OpenFile(m.pBase+'\kms', 'kms', 'excl')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 

 SELECT kms
  
 IF FIELD('BLANC')!='BLANC'
  ALTER TABLE kms ADD COLUMN blanc c(11)
 ENDIF 

 IF USED('kms')
  USE IN kms
 ENDIF 

 IF fso.FileExists(m.pbase+'\kms.bak')
  fso.DeleteFile(m.pbase+'\kms.bak')
 ENDIF 
 IF fso.FileExists(m.pbase+'\kms.tbk')
  fso.DeleteFile(m.pbase+'\kms.tbk')
 ENDIF 

 MESSAGEBOX('OK!', 0+64, '')

RETURN 