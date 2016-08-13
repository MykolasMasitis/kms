PROCEDURE ifile2kms
 IF MESSAGEBOX("Вы действительно хотите"+CHR(13)+"загрузить обменный файл, полученный от СМО?", 4+32, '') != 6
	RETURN 
 ENDIF 

 tcOldDefDir = SYS(5)+SYS(2003)
 SET DEFAULT TO (pExpImp)
 ImpFile = GETFILE('dbf','','',0,'Укажите на обменный файл (i-файл)!')
 SET DEFAULT TO (tcOldDefDir)

 DO CASE 
 CASE EMPTY(ImpFile)
	MESSAGEBOX("Файл не выбран. Продолжение работы невозможно!",0+48,'Внимание!')
	RETURN 
 CASE UPPER(SUBSTR(ImpFile, RAT('\',ImpFile)+1, 4)) != 'I'+pvid(1,1)
    MESSAGEBOX('Это не обменный файл!',0+48,'')
	RETURN 
 OTHERWISE 
 ENDCASE 

 LenPath = AT('\', ImpFile,OCCURS('\', ImpFile))
 ExpFile = LEFT(ImpFile, lenpath)+'e'+SUBSTR(ImpFile,lenpath+2)
 
 TRY 
  USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms SHARED
  SELECT kms
  IsOpenedFiles = .t.
 CATCH
  IsOpenedFiles = .f.
 ENDTRY 

 IF !IsOpenedFiles
  oApp.CloseAllTable()
  MESSAGEBOX('Невозможно открыть kms!',0+16, '')
  RETURN 
 ENDIF 

 USE &PBase\&pvid(1,1)\error IN 0 ALIAS Error ORDER rec_id
 USE &ImpFile IN 0 ALIAS IFile EXCLUSIVE 
 SELECT IFile
 INDEX ON recid_pv TAG recid
 SET ORDER TO recid
 
 SELECT kms
 SET RELATION TO recid INTO IFile

 COUNT FOR !EMPTY(IFile.recid_pv) TO m.lnIsRelated
 IF m.lnIsRelated==0
  MESSAGEBOX("Файл не связался!",0+16,"")
  DO StopProc
  RETURN 
 ENDIF 

 COUNT FOR !EMPTY(IFile.recid_pv) TO m.lnFatalErrors
 IF m.lnFatalErrors != 0
  MESSAGEBOX("Файл связался по recid с различными vs!",0+16,"Продолжение работы невозможно!")
 ENDIF 
 
 m.lnIsInFile = RECCOUNT('IFile')
 IF m.lnIsRelated != m.lnIsInFile
  IF MESSAGEBOX("Количество записей в i-файле ( " + ALLTRIM(STR(m.lnIsInFile))+" )"+CHR(13)+;
   "не соответствует количеству связавшихся с kms записей ( " + ALLTRIM(STR(m.lnIsInFile))+" )!"+CHR(13)+;
   "Продолжить обработку?",4+32,"") != 6
    DO StopProc
    RETURN 
   ENDIF 
 ENDIF 
 
 COUNT FOR nz == IFile.nz TO m.lnIsWorked

 m.nGoodRecs = 0
 m.nBadRecs = 0 
 m.nNoBlocks = 0
 SCAN FOR !EMPTY(IFile.recid_pv)
  
  IF !EMPTY(IFile.err)
   m.nBadRecs = m.nBadRecs + 1
   m.rec_id = PADL(IFile.recid_pv,6,'0')
   m.err = IFile.err
   IF !SEEK(m.rec_id, 'error')
    INSERT INTO error (rec_id, err) VALUES (m.rec_id, m.err)
   ENDIF 
  ENDIF 

  m.nGoodRecs = m.nGoodRecs + 1
  REPLACE sn_card WITH IFile.sn_card, dp WITH IFile.dp
*  REPLACE nz WITH IFile.nz, status WITH 3, err WITH IFile.err, pos WITH IFile.pos
  REPLACE nz WITH IFile.nz, status WITH 3

  m.nNoBlocks = m.nNoBlocks + 1

 ENDSCAN 
 
 DO StopProc

 MESSAGEBOX("Записей в i-файле : "+STR(lnIsInFile,5)+CHR(13)+;
			"изготовлено КМС   : "+STR(nGoodRecs,5)+CHR(13)+;
			"забраковано МГФОМС: "+STR(nBadRecs,5)+CHR(13)+;
			"снято блокировок: "+STR(nNoBlocks,5),0,"Результат обработки:")

RETURN 

PROCEDURE StopProc
 SET RELATION OFF INTO IFile
 SELECT IFile
 SET ORDER TO 
 DELETE TAG ALL 
 oApp.CloseAllTable()
RETURN 