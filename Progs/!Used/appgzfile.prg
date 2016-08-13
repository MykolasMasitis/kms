PROCEDURE AppGZFile
 PUBLIC m.nNZ
 m.nNZ = SPACE(3)
 LOCAL m.nZFileRecCount
 m.nZFileRecCount = 0

 tcOldDefDir = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 ZFile = GETFILE('dbf','','',0,'Укажите на файл!')
 SET DEFAULT TO (tcOldDefDir)

 USE (ZFile) IN 0 ALIAS ZFile EXCLUSIVE 
 SELECT ZFile

 IF VARTYPE(enp) != 'C' AND (VARTYPE(vs) != 'C' AND VARTYPE(vsn) != 'C') && Неизвестный формат!
  oApp.CloseAllTable()
  MESSAGEBOX('НЕИЗВЕСТНЫЙ ФОРМАТ!',0+48,'Внимание!')
  RELEASE m.nNZ
  RETURN
 ENDIF 
	
 m.nZFileRecCount = RECCOUNT()
	
 IF m.nZFileRecCount == 0
  MESSAGEBOX('Файл пуст!',0+64,'Внимание!')
  oApp.CloseAllTable()
  RELEASE m.nNZ
  RETURN 
 ENDIF 

 DO CASE 
  CASE VARTYPE(vs)=='C'
   INDEX ON vs TAG vs
  CASE VARTYPE(vsn)=='C'
   INDEX ON vsn TAG vs
  OTHERWISE 
   oApp.CloseAllTable()
   MESSAGEBOX('НЕИЗВЕСТНЫЙ ФОРМАТ (НЕТ НИ VS НИ VSN)!',0+48,'Внимание!')
   RELEASE m.nNZ
   RETURN
 ENDCASE 

 SET ORDER TO vs
	
 USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms SHARED
 SELECT kms
 SET RELATION TO vs INTO ZFile
	
 COUNT FOR !EMPTY(ZFile.enp) TO m.Related
	
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX("ФАЙЛ НЕ СВЯЗАЛСЯ!",0+32, '')
   SET RELATION OFF INTO ZFile
   SELECT ZFile
   SET ORDER TO 
   DELETE TAG all
   oApp.CloseAllTable()
   RELEASE m.nNZ
   RETURN 
 
  CASE m.Related == nZFileRecCount && Все ОК!
   MESSAGEBOX("ФАЙЛ СВЯЗАЛСЯ!",0+32, '')
			
  CASE m.Related != nZFileRecCount
   IF MESSAGEBOX("Файл связался частично " + CHR(13)+ ;
    "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nZFileRecCount))+ ")" + CHR(13) + ;
    "Продолжить обработку?",4+32, '') != 6
    SET RELATION OFF INTO ZFile
    SELECT ZFile
    SET ORDER TO 
    DELETE TAG all
    oApp.CloseAllTable()
    RELEASE m.nNZ
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX("Нештатная ситуация при связке файлов!",0+32, '')
   SET RELATION OFF INTO ZFile
   SELECT ZFile
   SET ORDER TO 
   DELETE TAG all
   oApp.CloseAllTable()
   RELEASE m.nNZ
   RETURN 
 ENDCASE 

 IF m.qcod=='P2'
  DO FORM n_z
 ENDIF 

 SELECT kms

 m.Worked = 0
 SCAN FOR !EMPTY(ZFile.enp)
*  REPLACE status WITH 4, enp WITH ZFile.enp, dp WITH DATE()
  REPLACE status WITH 4, enp WITH ZFile.enp, gz_data WITH DATE()
  IF m.qcod=='P2'
   REPLACE nz WITH m.nNZ
  ENDIF 
  m.Worked = m.Worked + 1
 ENDSCAN 
  
 IF m.Worked > 0
  MESSAGEBOX("Обработано " + ALLTRIM(STR(m.Worked))+ " записи(ей)!",0+64, '')
 ELSE
  MESSAGEBOX("Файл ошибок уже подкачан!",0+64, '')
 ENDIF 
 
 oApp.CloseAllTable()
 RELEASE m.nNZ
RETURN
