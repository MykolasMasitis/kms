PROCEDURE SqlBroker
 IF MESSAGEBOX('SQL Server Broker?',4+32,'')=7
  RETURN 
 ENDIF
 
 m.nHandl = SQLCONNECT("ruby")
 IF m.nHandl <= 0
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot make connection')
  RETURN 
 ENDIF

 IF SQLEXEC(m.nhandl, "use kms")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, '')
  RETURN 
 ENDIF 

 IF SQLEXEC(m.nhandl,;
  "SELECT is_broker_enabled AS IsRun FROM sys.databases WHERE NAME = 'kms'", 'curss')=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'IfRunOrNot')
  RETURN 
 ENDIF 
 m.IsRun = curss.IsRun
 USE IN curss
 MESSAGEBOX(IIF(m.IsRun,'ÁÐÎÊÅÐ ÇÀÏÓÙÅÍ!','ÁÐÎÊÅÐ ÎÑÒÀÍÎÂËÅÍ!'),0+64,'')
 
 IF m.IsRun
*  IF SQLEXEC(m.nhandl, "alter database kms set disable_broker")=-1
*   =AERROR(errarr)
*   =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot disable broker')
*  ENDIF 
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
 MESSAGEBOX(IIF(m.IsRun,'ÁÐÎÊÅÐ ÇÀÏÓÙÅÍ!','ÁÐÎÊÅÐ ÎÑÒÀÍÎÂËÅÍ!'),0+64,'')

 IF SQLEXEC(m.nhandl, "if exists (select 1 from sys.services where name = 'Michael') drop service Michael")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Service Michael')
 ENDIF 

 IF SQLEXEC(m.nhandl, "if exists (select 1 from sys.services where name = 'Olga') drop service Olga")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Service Olga')
 ENDIF 

 IF SQLEXEC(m.nhandl, "if exists(select 1 from sys.service_contracts where name = 'MyContract') ;
  drop contract [MyContract]")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Contract')
 ENDIF 

 IF SQLEXEC(m.nhandl, "if exists(select 1 from sys.service_message_types where name = 'MyType') ;
  drop message type [MyType]")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'MyType')
 ENDIF 

 IF SQLEXEC(m.nhandl, "create message type [MyType] validation = none")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'MyType')
 ENDIF 

 IF SQLEXEC(m.nhandl, "create contract [MyContract] ([MyType] sent by any)")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Create contract')
 ENDIF 

 IF SQLEXEC(m.nhandl, "if exists (select 1 from sys.service_queues where name = 'QueueMichael') ;
  begin drop queue QueueMichael; create queue QueueMichael; end else begin create queue QueueMichael; end")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'QueueMichael')
 ENDIF 

 IF SQLEXEC(m.nhandl, "if exists(select 1 from sys.service_queues where name = 'QueueOlga') ;
  begin drop queue QueueOlga; create queue QueueOlga; end else begin create queue QueueOlga; end")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'QueueOlga')
 ENDIF 

* IF SQLEXEC(m.nhandl, "if not exists(select 1 from sys.service_queues where name = 'QueueOlga') ;
*  create queue QueueOlga")=-1
*  =AERROR(errarr)
*  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'QueueOlga')
* ENDIF 

* IF SQLEXEC(m.nhandl, "if not exists(select 1 from sys.service_queues where name = 'QueueMichael') ;
*  create queue QueueMichael")=-1
*  =AERROR(errarr)
*  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'QueueMichael')
* ENDIF 

 IF SQLEXEC(m.nhandl, "create service Michael on queue QueueMichael ([MyContract])")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Service Michael')
 ENDIF 

 IF SQLEXEC(m.nhandl, "create service Olga on queue QueueOlga ([MyContract])")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Service Olga')
 ENDIF 

RETURN 

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
 IF SQLEXEC(m.nhandl, "declare @msg xml='Ïðèâåò!';;
  send on conversation ?m.ch message type [MyType] (@msg);end conversation ?m.ch")=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, '@ch')
 ENDIF 
* IF SQLEXEC(m.nhandl, "select @ch as ch", "curss")=-1
*  =AERROR(errarr)
*  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, '@ch')
* ELSE 
*  m.ch = curss.ch 
*  USE IN curss
* ENDIF 

 IF SQLDISCONNECT(m.nHandl)=-1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot disconnect')
 ENDIF 

RETURN