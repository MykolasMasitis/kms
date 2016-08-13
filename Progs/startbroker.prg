PROCEDURE StartBroker

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

 IF SQLEXEC(m.nhandl,;
  "SELECT is_broker_enabled AS IsRun FROM sys.databases WHERE NAME = 'kms'", 'curss')=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'IfRunOrNot')
  =SQLDISCONNECT(m.nhandl)
  RETURN 
 ENDIF 
 m.IsRun = curss.IsRun
 USE IN curss
 MESSAGEBOX(IIF(m.IsRun,'������ ��� �������!','������ ����������!'),0+64,'')
 
 IF m.IsRun 
  RETURN 
 ELSE 
  IF SQLEXEC(m.nhandl, "alter database kms set enable_broker with rollback immediate")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot enable broker')
  ENDIF 
 ENDIF 

 IF SQLEXEC(m.nhandl,;
  "SELECT is_broker_enabled AS IsRun FROM sys.databases WHERE NAME = 'kms'", 'curss')=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'IfRunOrNot')
 ENDIF 
 m.IsRun = curss.IsRun
 USE IN curss
 =SQLDISCONNECT(m.nhandl)
 MESSAGEBOX(IIF(m.IsRun,'������ �������!','������ ����������!'),0+64,'')

RETURN 