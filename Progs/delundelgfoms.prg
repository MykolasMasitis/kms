FUNCTION DelUnDelgfoms(para1)
 PRIVATE recid
 m.recid = para1
 IF DELETED()
  RECALL 
  IF SEEK(m.recid, 'error')
   oal = ALIAS()
   SELECT error
   IF SEEK(m.recid, 'error')
    RECALL 
   ENDIF 
   SELECT (oal)
  ENDIF 
 ELSE 
  DELETE 
  IF SEEK(m.recid, 'error', 'rid')
   DELETE FROM error WHERE rid=m.recid
  ENDIF 
 ENDIF 
RETURN 