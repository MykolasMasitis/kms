PROCEDURE DelLstRep
 IF MESSAGEBOX("������ ������ ��������� ������� ��������� �������������� �����"+CHR(13)+;
  "� ������� ���� ��������� � ���������� ��� ������������ ���������."+CHR(13)+;
  "����������?", 4+32, "�������� ������...") == 6
 ELSE 
  RETURN 
 ENDIF 
 
 tcOldDefDir = SYS(5)+SYS(2003)
 SET DEFAULT TO (pExpImp)
 
 tnFound = 0 

 ExpFile    = SYS(2000, 'e'+pvid(1,1)+'*.dbf')
 ExpFileFpt = SYS(2000, 'e'+pvid(1,1)+'*.fpt')
 IF !EMPTY(ExpFile)
  ImpFile = SYS(2000, 'I'+SUBSTR(ExpFile,2))
  IF EMPTY(ImpFile) && �����!
   tnFound = tnFound + 1
   MESSAGEBOX("��������� �������������� ���� �������� "+LOWER(ALLTRIM(ExpFile))+"!",0+64,"��������� �����")
  ENDIF 
 ELSE 
  MESSAGEBOX("�� ���������� �� ������ ����� ��������!", 0+48, "������ �� ����������")
  RETURN 
 ENDIF 

 tExpFile = SYS(2000, 'e'+pvid(1,1)+'*.dbf', 1)
 DO WHILE !EMPTY(tExpFile)
  IF !EMPTY(tExpFile)
   ImpFile = SYS(2000, 'I'+SUBSTR(tExpFile,2))
   IF EMPTY(ImpFile) && �����!
    tnFound = tnFound + 1
    MESSAGEBOX("��������� �������������� ���� �������� "+LOWER(ALLTRIM(tExpFile))+"!",0+64,"��������� �����")
   ENDIF 
  ENDIF 
 ENDDO   
 
 IF tnFound > 1
  MESSAGEBOX("���������� "+ALLTRIM(STR(tnFound))+" �������������� �����(��) ��������!" + CHR(13) +;
  "����� ����������!",0+16,"��������")
 ELSE && �������� ������!
 
 SET DEFAULT TO (tcOldDEfDir)

 pnResult = 0
 pnResult = pnResult + OpenFile("&pBase\&pvid(1,1)\kms", "Kms", "SHARED", "", "")
 IF pnResult > 0
  oApp.CloseAllTable
  MESSAGEBOX("���������� ������� ���� kms.dbf!",0+16,"����!")
  RETURN .f.
 ELSE
  tnProceed = 0 
  USE &PExpImp\&ExpFile IN 0 ALIAS ExpFile EXCLUSIVE 
  SELECT ExpFile
  INDEX ON recid_pv TAG recid
  SET ORDER TO recid
  SELECT Kms
  SET RELATION TO recid INTO ExpFile
  SCAN 
   IF !EMPTY(ExpFile.recid_pv)
    IF Status == 2
     tnProceed = tnProceed + 1
     REPLACE Status WITH ExpFile.Status
    ENDIF 
   ENDIF 
  ENDSCAN 
  
  SET RELATION OFF INTO ExpFile
  SELECT ExpFile
  SET ORDER TO 
  DELETE TAG ALL 
  USE
  DELETE FILE &PExpImp\&ExpFile
  DELETE FILE &PExpImp\&ExpFileFpt
  USE IN kms 
 ENDIF
  
 ENDIF 

RETURN 