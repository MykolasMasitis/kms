PROCEDURE AppEFileNew
 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 EFile = GETFILE('zip','','',0,'Укажите на файл!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(EFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'ВЫ НИЧЕГО НЕ ВЫБРАЛИ!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ENDIF 

 oEFile = fso.GetFile(EFile)
 IF oEFile.size >= 2
  fhandl = oEFile.OpenAsTextStream
  lcHead = fhandl.Read(2)
  fhandl.Close
 ELSE 
  lcHead = ''
 ENDIF 

 IF lcHead == 'PK' && Это zip-файл!
 ELSE 
  MESSAGEBOX('ЭТО НЕ ZIP-АРХИВ!',0+64,'')
 ENDIF 
 
 ShortName = UPPER(oEFile.name)
 PeriodDir = '201' + SUBSTR(ShortName,5,5)
 
 UnzipOpen(EFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'АРХИВ НЕ СОДЕРЖИТ НИ ОДНОГО ФАЙЛА!'+CHR(13)+CHR(10),0+64, ShortName)
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' ФАЙЛОВ В АРХИВЕ!',0+64, ShortName)
 ENDIF 
 
 IF UnzipOpen(EFile)==.T.
  CREATE CURSOR CursZip (EFile c(25))
  DIMENSION ZipArray(13)
  ZipArray = ''
  UnZipGotoTopFile()
  FOR FileInZip=1 TO FilesInZip
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))

   INSERT INTO CursZip (EFile) VALUES (m.FileInZipName)
   
   UnzipGotoNextFile()
  ENDFOR  
  UnzipClose()
 ELSE 
  MESSAGEBOX('НЕ УДАЛОСЬ ОТКРЫТЬ ФАЙЛ'+CHR(13)+CHR(10)+EFile,0+64, ShortName)
  RETURN 
 ENDIF 
 
 IF !fso.FolderExists(pOut+'\'+PeriodDir)
  fso.CreateFolder(pOut+'\'+PeriodDir)
 ENDIF 
 
 IF !fso.FileExists(pOut+'\'+PeriodDir+'\'+ShortName)
  fso.CopyFile(pOut + '\' + ShortName, pOut+'\'+PeriodDir+'\'+ShortName)
 ENDIF 

 IF UnzipOpen(pOut+'\'+PeriodDir+'\'+ShortName)==.T.
  DIMENSION ZipArray(13)
  ZipArray = ''
  UnzipSetFolder(pOut+'\'+PeriodDir)
  UnZipGotoTopFile()
  FOR FileInZip=0 TO FilesInZip
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))
   
   IF !fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileInZipName)
    UnzipByIndex(FileInZip)
   ENDIF 

   UnzipGotoNextFile()
  ENDFOR  
  UnzipClose()
 ELSE 
  MESSAGEBOX('НЕ УДАЛОСЬ ОТКРЫТЬ ФАЙЛ'+CHR(13)+CHR(10)+EFile,0+64,'')
  RETURN 
 ENDIF 
 
 SELECT CursZip
 GO TOP 
 
 SCAN
  m.FileName = ALLTRIM(EFile)
  IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileName)
   =OneAppEFile(m.FileName)
  ENDIF  
 ENDSCAN 
 
 USE 
 
 MESSAGEBOX('ОБРАБОТКА ЗАКОНЧЕНА!',0+64,'')

RETURN 

FUNCTION OneAppEFile(flname)
 LOCAL m.nEFileRecCount
 m.nEFileRecCount = 0

 ppath = pOut+'\'+PeriodDir
 m.lPV = SUBSTR(flname,4,3)
 
 IF !fso.FolderExists(pBase+'\'+m.lpv)
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pBase+'\'+m.lpv+'\kms.dbf')
  RETURN 
 ENDIF 

 shflname = LEFT(flname, AT('.',flname)-1)

 =PutCodePage(ppath+'\'+flname, 866, .t.)

 USE &ppath\&flname IN 0 ALIAS OutErrFile EXCLUSIVE 
 SELECT OutErrFile

 =PutCodePage('&ppath\&flname', 866, .t.)
	
 m.nEFileRecCount = RECCOUNT()
	
 IF m.nEFileRecCount == 0
  MESSAGEBOX('Файл ошибок пуст!',0+64,'Пункт '+m.lpv)
  USE  IN OutErrFile
  SELECT CursZip
  RETURN 
 ENDIF 

 INDEX ON PADL(ALLTRIM(rec_id),6,'0') TAG rec_id
 SET ORDER TO rec_id
	
 USE &PBase\&lpv\kms IN 0 ALIAS kms SHARED
 USE &PBase\&lpv\Error IN 0 ALIAS Error SHARED ORDER rec_id 
 SELECT kms
 SET RELATION TO PADL(RecId,6,'0') INTO OutErrFile
	
 COUNT FOR !EMPTY(OutErrFile.s_card) TO m.Related
	
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX("Файл не связался!",0+32,'Пункт '+m.lpv)
   SET RELATION OFF INTO OutErrFile
   SELECT OutErrFile
   SET ORDER TO 
   DELETE TAG all
   USE  IN OutErrFile
   USE IN kms
   USE IN Error
   SELECT CursZip
   RETURN 
 
  CASE m.Related == nEFileRecCount && Все ОК!
   MESSAGEBOX("Файл связался!",0+32, 'Пункт '+m.lpv)
			
  CASE m.Related != nEFileRecCount
   IF MESSAGEBOX("Файл связался частично " + CHR(13)+ ;
    "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nEFileRecCount))+ ")" + CHR(13) + ;
    "Продолжить обработку?",4+32, 'Пункт '+m.lpv) != 6
    SET RELATION OFF INTO OutErrFile
    SELECT OutErrFile
    SET ORDER TO 
    DELETE TAG all
    USE  IN OutErrFile
    USE IN kms
    USE IN Error
    SELECT CursZip
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX("Нештатная ситуация при связке файлов!",0+32, 'Пункт '+m.lpv)
   SET RELATION OFF INTO OutErrFile
   SELECT OutErrFile
   SET ORDER TO 
   DELETE TAG all
   USE  IN OutErrFile
   USE IN kms
   USE IN Error
   SELECT CursZip
   RETURN 
 ENDCASE 
 
 SELECT kms
 m.Worked = 0
 SCAN FOR !EMPTY(OutErrFile.s_card)
  m.e_rec_id   = ALLTRIM(OutErrFile.rec_id)
  m.e_s_card   = OutErrFile.s_card
  m.e_n_card   = OutErrFile.n_card
  m.e_n_date   = OutErrFile.n_date
  m.e_q        = OutErrFile.q
  m.e_err      = OutErrFile.err
  m.e_err_text = OutErrFile.err_text
  m.app_d      = DATE()
  IF !SEEK(PADL(m.e_rec_id,6,'0'), 'Error')
   INSERT INTO ERROR (rec_id, s_card, n_card, n_date, q, err, err_text, app_d) ;
    VALUES (PADL(m.e_rec_id,6,'0'), m.e_s_card, m.e_n_card, m.e_n_date, m.e_q, ;
     m.e_err, m.e_err_text, m.app_d)
  ENDIF 
*  REPLACE err WITH OutErrFile.err
  IF UPPER(LEFT(OutErrFile.err,2)) = 'E1'
   REPLACE sn_card WITH OutErrFile.s_card+' '+PADL(OutErrFile.n_card,10,'0'), ;
    jt WITH IIF(UPPER(OutErrFile.q)=qcod,'7','b'), dp WITH DATE(), p_doc WITH 1, status WITH 1
  ENDIF 
  m.Worked = m.Worked + 1
 ENDSCAN 
  
 IF m.Worked > 0
  MESSAGEBOX("Обработано " + ALLTRIM(STR(m.Worked))+ " записи(ей)!",0+64, 'Пункт '+m.lpv)
 ELSE
  MESSAGEBOX("Файл ошибок уже подкачан!",0+64, '')
 ENDIF 

 SET RELATION OFF INTO OutErrFile
 SELECT OutErrFile
 SET ORDER TO 
 DELETE TAG all
 USE  IN OutErrFile
 USE IN kms
 USE IN Error
 SELECT CursZip
RETURN 
