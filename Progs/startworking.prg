PROCEDURE StartWorking
 IF MESSAGEBOX('бш унрхре сдюкхрэ сбеднлкемхе'+CHR(13)+CHR(10)+'н опейпюыемхх пюанрш б опнцпюлле?',4+32,'')=7
  RETURN 
 ENDIF 
 
 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
  m.lppath = pBase
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
 ENDIF 

 IF !fso.FolderExists(m.lppath)
  MESSAGEBOX('нрясрярбсер дхпейрнпхъ '+UPPER(m.lppath),0+16,'')
  RETURN 
 ENDIF 

 IF fso.FileExists(m.lppath+'\ShutDown.txt')
  fso.DeleteFile(m.lppath+'\ShutDown.txt')
 ENDIF 
 
 MESSAGEBOX('сбеднлкемхе сдюкемн!',0+64,'') 
RETURN 