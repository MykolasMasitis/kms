PROCEDURE ResetError
 IF !SEEK(recid, 'efoms')
  WAIT "������ ������ �� ����� ������!" WINDOW NOWAIT 
 ELSE 
  WAIT "������..." WINDOW NOWAIT 
  m.recid = recid
  DELETE FROM efoms WHERE recid = m.recid
  WAIT CLEAR 
 ENDIF 
 

* IF EMPTY(Error.Rec_id)
*  WAIT "������ ������ �� ����� ������!" WINDOW NOWAIT 
* ELSE 
*  m.recid = recid
*  DELETE FROM error WHERE rec_id = PADL(m.recid,6,'0')
**  SELECT Error
**  DELETE 
**  SELECT Kms
**  REPLACE err WITH ''
*  WAIT "������ ��������!" WINDOW NOWAIT 
* ENDIF 
RETURN 