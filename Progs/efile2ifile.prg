PROCEDURE efile2ifile
 IF MESSAGEBOX("Вы действительно хотите"+CHR(13)+"связать обменный файл пункта выдачи"+CHR(13)+;
 				"с файлами ответа МГФОМС (f- и e-файлами)?",4+32,'') != 6
	RETURN 
 ENDIF 

 tolddir = SYS(5)+SYS(2003)
 SET DEFAULT TO (pExpImp)
 
 IsErrFile = .T.
 IsFFile = .T.

 ExpFile = GETFILE('dbf','','',0,'Укажите на обменный файл (i-файл)!')

 DO CASE 
  CASE EMPTY(ExpFile)
   SET DEFAULT TO (tolddir)
   MESSAGEBOX("Файл не выбран. Продолжение работы невозможно!",0+48,'Внимание!')
   RETURN 
  CASE UPPER(SUBSTR(ExpFile, RAT('\',ExpFile)+1, 4)) != 'I'+pvid(1,1)
   SET DEFAULT TO (tolddir)
   MESSAGEBOX('Это не обменный файл!',0+48,'')
   RETURN 
  OTHERWISE 
 ENDCASE  

 FFile = GETFILE('dbf','','',0,'Укажите на f-файл!')

 DO CASE 
 CASE EMPTY(FFile)
  IsFFile = .F.
 CASE UPPER(SUBSTR(FFile, RAT('\',FFile)+1, 6)) != 'F'+qcod+pvid(1,1)
  SET DEFAULT TO (tolddir)
  MESSAGEBOX('Это не f-файл!'+CHR(13)+UPPER(SUBSTR(FFile, RAT('\',FFile)+1, 6))+CHR(13)+'F'+qcod+pvid(1,1),0+48,'')
  RETURN 
 OTHERWISE 
 ENDCASE  
 
 EFile = GETFILE('dbf','','',0,'Укажите на e-файл!')

 DO CASE 
  CASE EMPTY(EFile)
   IsErrFile = .F.
  CASE UPPER(SUBSTR(EFile, RAT('\',EFile)+1, 6)) != 'E'+qcod+pvid(1,1)
   SET DEFAULT TO (tolddir)
   MESSAGEBOX('Это не e-файл!',0+48,'')
   RETURN 
  OTHERWISE 
 ENDCASE  
 
 USE (ExpFile) IN 0 ALIAS IFile SHARED 
 IF IsFFile == .t.
  USE (FFile) IN 0 ALIAS FFile SHARED 
 ENDIF 
 IF IsErrFile == .t.
  USE (EFile) IN 0 ALIAS EFile SHARED 
 ENDIF 
 
 idat1 = CTOD(SUBSTR(ExpFile, RAT('\',ExpFile)+6, 2)+'.'+SUBSTR(ExpFile, RAT('\',ExpFile)+8, 2)+'.20'+SUBSTR(ExpFile, RAT('\',ExpFile)+10, 2))
 idat2 = CTOD(SUBSTR(ExpFile, RAT('\',ExpFile)+13, 2)+'.'+SUBSTR(ExpFile, RAT('\',ExpFile)+15, 2)+'.20'+SUBSTR(ExpFile, RAT('\',ExpFile)+17, 2))
 
 IF IsFFile == .T.
  SELECT FFile
  INDEX ON rec_id TO &PLocal\frec_id
  SET INDEX TO &PLocal\frec_id
 ENDIF 
 
 IF IsErrFile == .T.
  SELECT EFile
  INDEX ON rec_id TO &PLocal\erec_id
  SET INDEX TO &PLocal\erec_id
 ENDIF 
 
 SELECT IFile
 IF IsFFile =.t.
  SET RELATION TO PADL(recid_smo,6,'0') INTO FFile
 ENDIF 
 IF IsErrFile =.t.
  SET RELATION TO PADL(recid_smo,6,'0') INTO EFile ADDITIVE 
 ENDIF 
 
 nTotRecs  = RECCOUNT()
 nGoodRecs = 0
 nBadRecs  = 0

 SCAN 
  IF IsFFile == .t.
   IF !EMPTY(FFile.n_card)
    m.nGoodRecs = m.nGoodRecs + 1
    REPLACE sn_card WITH TransPol(FFile.s_card+' '+ALLTRIM(STR(FFile.n_card))), dt WITH FFile.dt
   ENDIF 
  ENDIF 
  
  IF IsErrFile == .t.
   IF !EMPTY(EFile.n_card)
    m.nBadRecs = m.nBadRecs + 1
    REPLACE err WITH EFile.err
   ENDIF 
  ENDIF 
 ENDSCAN  
 
 IF IsErrFile == .t.
  SET RELATION OFF INTO EFile
 ENDIF 
 IF IsFFile == .t.
  SET RELATION OFF INTO FFIle
 ENDIF 
 USE
 IF IsFFile == .t.
  SELECT FFile
  SET INDEX TO 
  DELETE FILE &PLOcal\frec_id.idx
  USE
 ENDIF 
 IF IsErrFile == .t.
  SELECT EFile
  SET INDEX TO 
  DELETE FILE &PLOcal\erec_id.idx
  USE
 ENDIF 

 SET DEFAULT TO (tolddir)
 
 MESSAGEBOX("Записей в i-файле : "+STR(nTotRecs,5)+CHR(13)+;
 			"изготовлено КМС   : "+STR(nGoodRecs,5)+CHR(13)+;
 			"забраковано МГФОМС: "+STR(nBadRecs,5),0,"Результат обработки:")
 
 
RETURN 