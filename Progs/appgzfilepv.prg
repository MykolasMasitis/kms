PROCEDURE AppGZFilePV
 m.nNZ = SPACE(3)
 LOCAL m.nZFileRecCount
 m.nZFileRecCount = 0

 tcOldDefDir = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 ZFile = GETFILE('dbf','','',0,'Укажите на файл!')
 SET DEFAULT TO (tcOldDefDir)

 oApp.CodePage(ZFile, 866, .t.)
 USE (ZFile) IN 0 ALIAS ZFile EXCLUSIVE 
 SELECT ZFile
 
 IsGoodFile = .t.
 IsVS  = .f.
 IsVSN = .f.

 IF VARTYPE(Fam) != 'C'
  IsGoodFile = .F.
 ENDIF 
 IF VARTYPE(Im) != 'C'
  IsGoodFile = .F.
 ENDIF 
 IF VARTYPE(Ot) != 'C'
  IsGoodFile = .F.
 ENDIF 
 IF VARTYPE(W) != 'N'
  IsGoodFile = .F.
 ENDIF 
 IF !INLIST(VARTYPE(DR), 'C', 'D')
  IsGoodFile = .F.
 ENDIF 
 IF VARTYPE(PV) != 'C'
  IsGoodFile = .F.
 ENDIF 
 IF VARTYPE(vs) != 'C' AND VARTYPE(vsn) != 'C'
  IsGoodFile = .F.
 ENDIF 
 IF VARTYPE(enp) != 'C'
  IsGoodFile = .F.
 ENDIF 
 
 IF IsGoodFile == .F.
  USE IN ZFile
  MESSAGEBOX('НЕВЕРНАЯ СТРУКТУРА ФАЙЛА ГОЗНАКА!',0+16,'')
  SET DEFAULT TO (tcOldDefDir)
  RETURN 
 ENDIF 

 IF VARTYPE(vs) == 'C'
  IsVS  = .t.
 ELSE 
  IsVSN = .t.
 ENDIF 
 
 m.nZFileRecCount = RECCOUNT()
	
 IF m.nZFileRecCount == 0
  USE IN ZFile
  MESSAGEBOX('ФАЙЛ ПУСТ!',0+64,'')
  SET DEFAULT TO (tcOldDefDir)
  RETURN 
 ENDIF 
 
 COUNT FOR pv=pvid(1,1) TO m.nZFileRecCount
 IF m.nZFileRecCount == 0
  USE IN ZFile
  MESSAGEBOX(CHR(13)+CHR(10)+'В ВЫБРАННОМ ФАЙЛЕ'+CHR(13)+CHR(10)+;
   'ОТСУТСТВУЮТ ЗАПИСИ, '+CHR(13)+CHR(10)+;
   'ОТНОСЯЩИЕСЯ К ТЕКУЩЕМУ ПУНКТУ ВЫДАЧИ!'+CHR(13)+CHR(10), 0+64, '')
  SET DEFAULT TO (tcOldDefDir)
  RETURN 
 ENDIF 

 IF IsVS  = .T.
  INDEX FOR pv=pvid(1,1) ON vs TAG vs
 ELSE 
  INDEX FOR pv=pvid(1,1) ON vsn TAG vs
 ENDIF 

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
   SET DEFAULT TO (tcOldDefDir)
   USE 
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
    SET DEFAULT TO (tcOldDefDir)
    USE 
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX("Нештатная ситуация при связке файлов!",0+32, '')
   SET RELATION OFF INTO ZFile
   SELECT ZFile
   SET ORDER TO 
   DELETE TAG all
   SET DEFAULT TO (tcOldDefDir)
   USE 
   RETURN 
 ENDCASE 

 IF m.qcod=='P2'
  DO FORM n_z TO m.nnz
 ENDIF 

 SELECT kms

 m.IsNew = 0

 SCAN FOR !EMPTY(ZFile.enp)
  IsChanged = .F.

  m.ZFDr = IIF(VARTYPE(zfile.dr)=='C', ;
   CTOD(SUBSTR(zfile.dr,7,2)+'.'+SUBSTR(zfile.dr,5,2)+'.'+SUBSTR(zfile.dr,1,4)), zfile.dr)

  IF enp != ZFile.enp
   IsChanged = .T.
   REPLACE enp WITH ZFile.enp
  ENDIF 
  IF Fam != ZFile.Fam
   IsChanged = .T.
   REPLACE Fam WITH ZFile.Fam
  ENDIF 
  IF Im != ZFile.Im
   IsChanged = .T.
   REPLACE Im WITH ZFile.Im
  ENDIF 
  IF Ot != ZFile.Ot
   IsChanged = .T.
   REPLACE Ot WITH ZFile.Ot
  ENDIF 
  IF W != ZFile.W
   IsChanged = .T.
   REPLACE w WITH ZFile.w
  ENDIF 
  IF DR != m.ZFDr
   IsChanged = .T.
   REPLACE dr WITH m.ZFDr
  ENDIF 
  IF IsChanged = .T.
   REPLACE status WITH 4, gz_data WITH DATE()
   m.IsNew = m.IsNew + 1
   IF m.qcod=='P2'
    REPLACE nz WITH m.nNZ
   ENDIF 
  ENDIF 
  
 ENDSCAN 
  
 IF m.IsNew > 0
  MESSAGEBOX("ОБНОВЛЕНО " + ALLTRIM(STR(m.Worked))+ " ЗАПИСИ(ЕЙ)!",0+64, '')
 ELSE
  MESSAGEBOX("ФАЙЛ ГОЗНАКА ОБРАБОТАН РАНЕЕ!",0+64, '')
 ENDIF 
 
 oApp.CloseAllTable()
RETURN
