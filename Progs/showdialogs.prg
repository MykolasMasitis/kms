PROCEDURE showdialogs

 m.nHandl = SQLCONNECT("ruby")
 IF m.nHandl <= 0
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot make connection')
  RETURN 
 ENDIF

 IF SQLEXEC(m.nhandl, "use kms")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, '')
  =SQLDISCONNECT(m.nhandl)
  RETURN 
 ENDIF 

 cmd01  = 'select ce.conversation_handle, ce.conversation_id, s.name as sender, sq.name as queue, ce.is_initiator, '
 cmd02  = 'ce.state_desc from sys.conversation_endpoints ce join sys.services s on ce.service_id = s.service_id '
 cmd03  = 'join sys.service_queues sq on s.service_queue_id = sq.object_id order by ce.conversation_id, ce.is_initiator desc'
 cmdAll = cmd01 + cmd02 + cmd03
 IF SQLEXEC(m.nhandl, cmdAll, 'curss')=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'IfRunOrNot')
  =SQLDISCONNECT(m.nhandl)
  RETURN 
 ENDIF 
 
 SELECT curss
 BROWSE 
 USE 

 =SQLDISCONNECT(m.nhandl)
RETURN 