PROCEDURE StartDialog

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
 ELSE 
  MESSAGEBOX('ÁÐÎÊÅÐ ÎÑÒÀÍÎÂËÅÍ!',0+64,'')
  =SQLDISCONNECT(m.nhandl)
  RETURN 
 ENDIF 

 IF SQLEXEC(m.nhandl, "declare @ch uniqueidentifier;
  begin dialog conversation @ch from service Olga to service 'Michael' on ;
   contract [MyContract] with encryption = off; select @ch as ch", "curss")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, '@ch')
 ENDIF 
 IF USED('curss')
  m.ch = curss.ch
  USE IN curss
  MESSAGEBOX(m.ch,0+64,'')
 ENDIF 
* IF SQLEXEC(m.nhandl, "declare @msg xml='Ïðèâåò!';;
*  send on conversation ?m.ch message type [MyType] (@msg);end conversation ?m.ch")=-1
*  =AERROR(errarr)
*  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, '@ch')
* ENDIF 

RETURN 