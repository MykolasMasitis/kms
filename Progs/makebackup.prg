PROCEDURE MakeBackUp
 IF MESSAGEBOX('янгдюрэ BACKUP ад?',4+32,'')=7
  RETURN 
 ENDIF 

 nHandl = SQLCONNECT("ruby", "sa", "")
 IF nHandl <= 0
  =AERROR(errarr)
  = MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'Cannot make connection')
  RETURN 
 ENDIF
 
 WAIT "янгдюмхе BACKUP..." WINDOW NOWAIT 
 m.arcname = pArc + '\kms.bak'
 IF SQLEXEC(nHandl,"BACKUP DATABASE kms TO DISK=?m.arcname") = -1
 ENDIF 
 WAIT CLEAR 

 =SQLDISCONNECT(nHandl)
RETURN 