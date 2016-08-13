PROCEDURE OPermIdDbls—
 IF MESSAGEBOX('»—œ–¿¬»“‹ œŒ PERMID?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF kol_pv<>1
  MESSAGEBOX('ƒŒÀ∆≈Õ ¡€“‹ ¬€¡–¿Õ ŒƒÕ» œ”Õ “!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FolderExists(pbase+'\'+pvid(1,1))
  MESSAGEBOX('Œ“—”“—“¬”≈“ ƒ»–≈ “Œ–»ﬂ'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\kms.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+'\KMS.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF  
 IF !fso.FileExists(pbase+'\'+pvid(1,1)+'\permiss.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À'+CHR(13)+CHR(10)+pbase+'\'+pvid(1,1)+'\PERMISS.DBF!'+CHR(13)+CHR(10),0+16,'')
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

 m.nDbls = 0
 SELECT kms
 SET RELATION TO permid INTO permiss
 SCAN 
  IF EMPTY(permid)
   LOOP 
  ENDIF 
  IF gr='RUS'
   REPLACE permid WITH 0
   m.nDbls = m.nDbls + 1
  ENDIF 
 ENDSCAN 
 
 m.nEmpty=0
 SELECT kms
 SCAN 
  IF EMPTY(permid)
   LOOP 
  ENDIF 
  IF EMPTY(permiss.recid)
   REPLACE permid WITH 0
   m.nEmpty = m.nEmpty + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO permiss

 SELECT kms 
 INDEX on permid TAG permid
 SET ORDER TO permid
 
 m.nEmpty2 = 0
 SELECT permiss
 SET RELATION TO recid INTO kms
 SCAN 
  IF EMPTY(kms.permid)
   DELETE 
   m.nEmpty2 = m.nEmpty2 + 1
  ENDIF 
 ENDSCAN 
 SET RELATION OFF INTO kms
 SELECT kms
 SET ORDER TO 
 DELETE TAG permid

 USE IN kms
 USE IN permiss
 
 IF m.nEmpty2 <= 0
  MESSAGEBOX('Õ≈»—œŒÀ‹«”≈Ã€’ «¿œ»—≈… PERMISS Õ≈ Œ¡Õ¿–”∆≈ÕŒ!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('”ƒ¿À≈ÕŒ '+ALLTRIM(STR(m.nEmpty2))+' Õ≈»—œŒÀ‹«”≈Ã€’ «¿œ»—≈… PERMISS!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nEmpty<=0
  MESSAGEBOX('Õ≈»—œŒÀ‹«”≈Ã€’ ——€ÀŒ  ¬ KMS Õ≈ Œ¡Õ¿–”∆≈ÕŒ!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('”ƒ¿À≈ÕŒ '+ALLTRIM(STR(m.nEmpty))+' Õ≈»—œŒÀ‹«”≈Ã€’ «¿œ»—≈… KMS!'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 IF m.nDbls<=0
  MESSAGEBOX('ƒ”¡À≈… Õ≈ Œ¡Õ¿–”∆≈ÕŒ!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX('Œ¡Õ¿–”∆≈ÕŒ '+ALLTRIM(STR(m.nDbls))+' ƒ”¡À≈…'+CHR(13)+CHR(10),0+64,'')
 ENDIF 
 
 
RETURN 