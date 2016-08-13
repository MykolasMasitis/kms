PROCEDURE ResetError
 IF !SEEK(recid, 'efoms')
  WAIT "дюммюъ гюохяэ ме хлеер ньхайх!" WINDOW NOWAIT 
 ELSE 
  WAIT "сдюкъч..." WINDOW NOWAIT 
  m.recid = recid
  DELETE FROM efoms WHERE recid = m.recid
  WAIT CLEAR 
 ENDIF 
 

* IF EMPTY(Error.Rec_id)
*  WAIT "дюммюъ гюохяэ ме хлеер ньхайх!" WINDOW NOWAIT 
* ELSE 
*  m.recid = recid
*  DELETE FROM error WHERE rec_id = PADL(m.recid,6,'0')
**  SELECT Error
**  DELETE 
**  SELECT Kms
**  REPLACE err WITH ''
*  WAIT "ньхайю яапньемю!" WINDOW NOWAIT 
* ENDIF 
RETURN 