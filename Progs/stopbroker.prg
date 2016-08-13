PROCEDURE StopBroker

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
 
 IF m.IsRun
  IF SQLEXEC(m.nhandl, "alter database kms set disable_broker with ROLLBACK IMMEDIATE")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot disable broker')
  ELSE 
   MESSAGEBOX('������ ����������!',0+64,'')
  ENDIF 
 ELSE 
  MESSAGEBOX(IIF(m.IsRun,'������ �������!','������ �� ��� �������!'),0+64,'')
  =SQLDISCONNECT(m.nhandl)
  RETURN 
 ENDIF 

 =SQLDISCONNECT(m.nhandl)
RETURN 