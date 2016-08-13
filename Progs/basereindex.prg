PROCEDURE BaseReindex

 IF !fso.FileExists(pbin+'\pvp2.dbf')
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT pvp2
 SELECT * FROM pvp2 INTO CURSOR curpvp2
 USE IN pvp2
 SELECT curpvp2
 
 SCAN 
  m.ppv=codpv
  IF !fso.FolderExists(pbase+'\'+m.ppv)
   LOOP 
  ENDIF 
  
  =OneBaseReind(m.ppv)
 ENDSCAN 
 
 USE

 MESSAGEBOX('оепехмдейяюжхъ гюйнмвемю!'+CHR(13)+CHR(10),0+64, '')

RETURN 

