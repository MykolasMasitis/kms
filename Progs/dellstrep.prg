PROCEDURE DelLstRep
 IF MESSAGEBOX("Данный модуль позволяет удалить последний сформированный отчет"+CHR(13)+;
  "с откатом всех сделанных в результате его формирования изменений."+CHR(13)+;
  "Продолжить?", 4+32, "Удаление отчета...") == 6
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
  IF EMPTY(ImpFile) && Нашли!
   tnFound = tnFound + 1
   MESSAGEBOX("Обнаружен необработанный файл экспорта "+LOWER(ALLTRIM(ExpFile))+"!",0+64,"Обнаружен отчет")
  ENDIF 
 ELSE 
  MESSAGEBOX("Не обнаружено ни одного файла экспорта!", 0+48, "Файлов не обнаружено")
  RETURN 
 ENDIF 

 tExpFile = SYS(2000, 'e'+pvid(1,1)+'*.dbf', 1)
 DO WHILE !EMPTY(tExpFile)
  IF !EMPTY(tExpFile)
   ImpFile = SYS(2000, 'I'+SUBSTR(tExpFile,2))
   IF EMPTY(ImpFile) && Нашли!
    tnFound = tnFound + 1
    MESSAGEBOX("Обнаружен необработанный файл экспорта "+LOWER(ALLTRIM(tExpFile))+"!",0+64,"Обнаружен отчет")
   ENDIF 
  ENDIF 
 ENDDO   
 
 IF tnFound > 1
  MESSAGEBOX("Обнаружено "+ALLTRIM(STR(tnFound))+" необработанных файла(ов) экспорта!" + CHR(13) +;
  "Откат невозможен!",0+16,"Внимание")
 ELSE && Начинаем работу!
 
 SET DEFAULT TO (tcOldDEfDir)

 pnResult = 0
 pnResult = pnResult + OpenFile("&pBase\&pvid(1,1)\kms", "Kms", "SHARED", "", "")
 IF pnResult > 0
  oApp.CloseAllTable
  MESSAGEBOX("Невозможно открыть файл kms.dbf!",0+16,"Стоп!")
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