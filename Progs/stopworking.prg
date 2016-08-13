PROCEDURE StopWorking
 IF MESSAGEBOX('бш унрхре пюглеярхрэ сбеднлкемхе'+CHR(13)+CHR(10)+'н опейпюыемхх пюанрш б опнцпюлле?',4+32,'')=7
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
 
 poi = fso.CreateTextFile(m.lppath+'\ShutDown.txt')
 poi.WriteLine('оНФЮКСИЯРЮ, БШИДХРЕ ХГ ОПНЦПЮЛЛШ!')
 poi.Close
 
 MESSAGEBOX('сбеднлкемхе пюглеыемн!',0+64,'') 

RETURN 