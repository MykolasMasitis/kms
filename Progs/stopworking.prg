PROCEDURE StopWorking
 IF MESSAGEBOX('�� ������ ���������� �����������'+CHR(13)+CHR(10)+'� ����������� ������ � ���������?',4+32,'')=7
  RETURN 
 ENDIF 
 
 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
  m.lppath = pBase
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
 ENDIF 

 IF !fso.FolderExists(m.lppath)
  MESSAGEBOX('����������� ���������� '+UPPER(m.lppath),0+16,'')
  RETURN 
 ENDIF 

 IF fso.FileExists(m.lppath+'\ShutDown.txt')
  fso.DeleteFile(m.lppath+'\ShutDown.txt')
 ENDIF 
 
 poi = fso.CreateTextFile(m.lppath+'\ShutDown.txt')
 poi.WriteLine('����������, ������� �� ���������!')
 poi.Close
 
 MESSAGEBOX('����������� ���������!',0+64,'') 

RETURN 