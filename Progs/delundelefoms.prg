FUNCTION DelUnDelefoms(para1)
 PRIVATE recid
 m.recid = para1
 IF DELETED()
  RECALL 
  IF SEEK(m.recid, 'efoms')
   oal = ALIAS()
   SELECT efoms
   IF SEEK(m.recid, 'efoms')
    RECALL 
   ENDIF 
   SELECT (oal)
  ENDIF 
 ELSE 
  DELETE 
  IF SEEK(m.recid, 'efoms', 'rid')
   DELETE FROM efoms WHERE rid=m.recid
  ENDIF 
 ENDIF 
RETURN 