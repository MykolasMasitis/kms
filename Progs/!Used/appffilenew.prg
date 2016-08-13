PROCEDURE AppFFileNew

 LOCAL m.nFFileRecCount
 m.nFFileRecCount = 0
	
 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pOut)
 FFile = GETFILE('zip','','',0,'Укажите на файл!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(ffile)
  MESSAGEBOX(CHR(13)+CHR(10)+'ВЫ НИЧЕГО НЕ ВЫБРАЛИ!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ENDIF 

 offile = fso.GetFile(ffile)
 IF offile.size >= 2
  fhandl = offile.OpenAsTextStream
  lcHead = fhandl.Read(2)
  fhandl.Close
 ELSE 
  lcHead = ''
 ENDIF 

 IF lcHead == 'PK' && Это zip-файл!
 ELSE 
  MESSAGEBOX('ЭТО НЕ ZIP-АРХИВ!',0+64,'')
 ENDIF 
 
 ShortName = UPPER(offile.name)
 PeriodDir = '201' + SUBSTR(ShortName,5,5)
 
 UnzipOpen(FFile)
 FilesInZip = UnZipFileCount()
 UnzipClose()
 
 IF FilesInZip <= 0
  MESSAGEBOX(CHR(13)+CHR(10)+'АРХИВ НЕ СОДЕРЖИТ НИ ОДНОГО ФАЙЛА!'+CHR(13)+CHR(10),0+64,'')
 ELSE 
  MESSAGEBOX(ALLTRIM(STR(FilesInZip))+ ' ФАЙЛОВ В АРХИВЕ!',0+64,'')
 ENDIF 
 
 IF UnzipOpen(FFile)==.T.
  CREATE CURSOR CursZip (FFile c(25))
  DIMENSION ZipArray(13)
  ZipArray = ''
  UnZipGotoTopFile()
  FOR FileInZip=1 TO FilesInZip
   UnzipAFileInfo("ZipArray")
   m.FileInZipName = ALLTRIM(ZipArray(1))

   INSERT INTO CursZip (FFile) VALUES (m.FileInZipName)

   UnzipGotoNextFile()
  ENDFOR  
  UnzipClose()
 ELSE 
  MESSAGEBOX('НЕ УДАЛОСЬ ОТКРЫТЬ ФАЙЛ'+CHR(13)+CHR(10)+FFILE,0+64,'')
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
  MESSAGEBOX('НЕ УДАЛОСЬ ОТКРЫТЬ ФАЙЛ'+CHR(13)+CHR(10)+FFILE,0+64,'')
  RETURN 
 ENDIF 
 
 SELECT CursZip
 
 SCAN
  m.FileName = ALLTRIM(FFile)
  IF fso.FileExists(pOut+'\'+PeriodDir+'\'+m.FileName)
  =OneAppFFile(m.FileName)
  ENDIF  
 ENDSCAN 
 
 USE 
 
 MESSAGEBOX('ОБРАБОТКА ЗАКОНЧЕНА!',0+64,'')

RETURN 

FUNCTION OneAppFFile(flname)

 ppath = pOut+'\'+PeriodDir
 m.lPV = SUBSTR(flname,4,3)
 
 IF !fso.FolderExists(pBase+'\'+m.lpv)
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pBase+'\'+m.lpv+'\kms.dbf')
  RETURN 
 ENDIF 

 shflname = LEFT(flname, AT('.',flname)-1)
 
 USE &ppath\&flname IN 0 ALIAS FondFile EXCLUSIVE 
 SELECT FondFile
	
 m.nFFileRecCount = RECCOUNT()
	
 IF m.nFFileRecCount == 0
  USE 
  RETURN 
 ENDIF 

 INDEX ON PADL(rec_id,6,'0') TAG rec_id
 SET ORDER TO rec_id
	
 USE &PBase\&lpv\kms IN 0 ALIAS kms SHARED
 SELECT kms
 SET RELATION TO PADL(recid,6,'0') INTO FondFile
	
 COUNT FOR !EMPTY(FondFile.s_pol) TO m.Related
	
 DO CASE 
  CASE m.Related == 0
   MESSAGEBOX("Файл не связался!",4+32, 'Пункт '+m.lpv)
   SET RELATION OFF INTO FondFile
   SELECT FondFile
   SET ORDER TO 
   DELETE TAG all
   USE 
   USE IN Kms
   RETURN 
 
  CASE m.Related == nFFileRecCount && Все ОК!
   MESSAGEBOX("Файл связался!",4+32,  'Пункт '+m.lpv)
			
  CASE m.Related != nFFileRecCount
   IF MESSAGEBOX("Файл связался частично " + CHR(13)+ ;
    "(" +ALLTRIM(STR(m.Related)) + "/" + ALLTRIM(STR(m.nFFileRecCount))+ ")" + CHR(13) + ;
    "Продолжить обработку?",4+32,  'Пункт '+m.lpv) != 6
    SET RELATION OFF INTO FondFile
    SELECT FondFile
    SET ORDER TO 
    DELETE TAG all
    USE 
    USE IN Kms
    RETURN 
   ENDIF 
 
  OTHERWISE 
   MESSAGEBOX("Нештатная ситуация при связке файлов!",4+32,  'Пункт '+m.lpv)
   SET RELATION OFF INTO FondFile
   SELECT FondFile
   SET ORDER TO 
   DELETE TAG all
   USE 
   USE IN Kms
   RETURN 
 ENDCASE 
	
 SELECT kms

 m.Worked = 0

 SCAN FOR !EMPTY(FondFile.s_pol)
  m.tsn_card = FondFile.s_card + ' ' + PADL(FondFile.n_card,10,'0')
  REPLACE sn_card WITH m.tsn_card, err WITH '', FFile WITH shflname
  IF m.qcod == 'R4'
   REPLACE  nz WITH PADL(FondFile.zz,5,'0')
  ENDIF 
  IF m.qcod == 'P2'
   REPLACE FondFile.prim WITH 'ДА'
  ENDIF 
  m.Worked = m.Worked + 1
  IF status != 3
   REPLACE status WITH 3
  ENDIF 
 ENDSCAN 
  
 IF m.Worked > 0
  MESSAGEBOX("Обработано " + ALLTRIM(STR(m.Worked))+ " записи(ей)!",0+64,  'Пункт '+m.lpv)
 ELSE
  MESSAGEBOX("Файл ошибок уже подкачан!",0+64,  'Пункт '+m.lpv)
 ENDIF 

 USE 
 USE IN FondFile
 
RETURN
