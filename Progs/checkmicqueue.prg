PROCEDURE CheckMicQueue

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

 IF SQLEXEC(m.nhandl, 'select * from queuemichael', 'curss')=-1
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