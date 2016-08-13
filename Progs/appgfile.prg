PROCEDURE AppGFile
 PUBLIC m.nNZ
 m.nNZ = SPACE(3)

 IF MESSAGEBOX("ВЫ ХОТИТЕ ЗАГРУЗИТЬ"+CHR(13)+CHR(10)+;
  "ФАЙЛЫ СОПРОВОЖДЕНИЯ ГОЗНАКА?"+CHR(13)+CHR(10),4+32, "") == 7
  RETURN 
 ENDIF 
 
 IF m.qcod=='P2'
  DO FORM n_z
 ENDIF 

 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('ОТСУТСТВУЕТ ФАЙЛ MFC_PV.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\mfc_pv', 'mfcpv', 'shar', 'pv')>0
  IF USED('mfcpv')
   USE IN mfcpv
  ENDIF 
  RETURN 
 ENDIF 

 ZFDir = fso.GetParentFolderName(pout)+'\GOZNAK'
 IF !fso.FolderExists(ZFDir)
  fso.CreateFolder(ZFDir)
 ENDIF 

 oZFDir    = fso.GetFolder(ZFDir)
 ZFDirName = oZFDir.Path+'\' 
 oFiles    = oZFDir.Files
 nFiles    = oFiles.Count

 CREATE CURSOR curappgz (nrec n(5),pv c(3), vs c(9), fam c(25), im c(20), ot c(20), w n(1), dr d, enp c(16), isfnd l)

 nnFiles = 0 
 FOR EACH oFile IN oFiles
  ExtOfFile = RIGHT(LOWER(ALLTRIM(oFile.Name)),3)
  IF ExtOfFile != 'dbf'
   LOOP 
  ENDIF 
  IF LOWER(LEFT(oFile.Name,6))!='goznak'
   LOOP 
  ENDIF 
  IF UPPER(SUBSTR(oFile.Name,8,2))!=m.qcod
   LOOP 
  ENDIF 
  m.fdata = CTOD(SUBSTR(oFile.Name,15,2)+'.'+SUBSTR(oFile.Name,13,2)+'.20'+SUBSTR(oFile.Name,11,2))
  IF !BETWEEN(m.fdata,{01.01.2001},DATE())
   LOOP 
  ENDIF 
  
  MESSAGEBOX(ofile.name,0+64,'')
   
  nnFiles = nnFiles + 1
   
  IF OpenFile(oFile.Path, 'zfile', 'shar')>0
   LOOP 
  ENDIF 
  SELECT zfile
  lIsGoodStruct = .T.
   
  IF FIELD('enp') != 'ENP'
   lIsGoodStruct = .F.
  ENDIF 
  IF FIELD('vs') != 'VS'
   lIsGoodStruct = .F.
  ENDIF 
  
  IF lIsGoodStruct = .F.
   USE 
   LOOP 
  ENDIF 

  IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
   m.IsKms = .T.
*   m.lppath = pBase
  ELSE 
   m.IsKms = .F.
*   m.lppath = pBase+'\'+m.lpv
  ENDIF 

  SELECT pv AS codpv FROM zfile GROUP BY pv INTO CURSOR pvp2
  IF !USED('pvs') 
   CREATE CURSOR pvs (cpv c(3), kmsname c(6), mvsname c(8), nkms n(11))
   INDEX on cpv TAG cpv
   SET ORDER TO cpv 
  ENDIF 

  IF m.IsKms = .F.

  SELECT pvp2
  SCAN 
   m.cCodPV = PADL(ALLTRIM(CodPV),3,'0')

   IF fso.FolderExists(pBase+'\'+m.cCodPV)
    IF !fso.FileExists(pBase+'\'+m.cCodPV+'\kms.dbf')
     LOOP 
    ENDIF 
    IF !fso.FileExists(PBase+'\'+cCodPV+'\moves.dbf')
     CREATE TABLE &PBase\&cCodPV\moves (et c(1), recid i autoinc, fname c(25), mkdate t, kmsid i, frecid c(6), ;
      vs c(9), s_card c(6), n_card n(10), c_okato c(5), enp c(16), dp d, jt c(1), ;
      pricin c(3), tranz c(3), q c(2), err c(5), err_text c(250), ans_fl c(2), nz n(3), n_kor n(6))
     INDEX ON recid TAG recid CANDIDATE 
     INDEX ON kmsid TAG kmsid
     INDEX ON fname+frecid TAG unik
     USE 
    ENDIF 
    IF OpenFile(PBase+'\'+cCodPV+'\moves', 'moves'+cCodPV, 'shar', 'unik')>0
     m.mlp='moves'+cCodPV
     IF USED('&mlp')
      USE IN &mlp
     ENDIF 
     LOOP 
    ENDIF 
    IF OpenFile(pbase+'\'+cCodPV+'\kms', 'kms'+cCodPV, 'shar', 'vs')>0
     m.alp='kms'+cCodPV
     IF USED('&alp')
      USE IN &alp
     ENDIF 
     IF USED('&mlp')
      USE IN &mlp
     ENDIF 
     LOOP 
    ENDIF 
    IF !SEEK(cCodPV, 'pvs')
     INSERT INTO pvs (cPV, kmsname, mvsname, nkms) VALUES (cCodPV, 'kms'+cCodPV, 'moves'+cCodPV,0)
    ENDIF 
   ENDIF 
  ENDSCAN 
  USE 
  
  ELSE 

   SELECT pvp2
   SCAN 
    m.cCodPV = PADL(ALLTRIM(CodPV),3,'0')
    IF !SEEK(cCodPV, 'pvs')
     INSERT INTO pvs (cPV, kmsname, mvsname, nkms) VALUES (cCodPV, 'kms'+cCodPV, 'moves'+cCodPV,0)
    ENDIF 
   ENDSCAN 
   USE 

   IF OpenFile(PBase+'\moves', 'moves', 'shar', 'unik')>0
    IF USED('moves')
     USE IN moves
    ENDIF 
    LOOP 
   ENDIF 
   IF OpenFile(pbase+'\kms', 'kms', 'shar', 'vs')>0
    USE IN moves
    IF USED('kms')
     USE IN kms
    ENDIF 
    LOOP 
   ENDIF 
  
  ENDIF 
  
  SELECT zfile
  SCAN 
   m.pvv = PADL(ALLTRIM(pv),3,'0')
   IF !SEEK(m.pvv, 'pvs')
    LOOP 
   ENDIF 

   m.vs      = vs
   m.enp     = enp
   m.gz_data = DATE()
   
   m.fam = fam
   m.im  = im
   m.ot  = ot
   m.w   = w
   m.dr  = CTOD(SUBSTR(dr,7,2)+'.'+SUBSTR(dr,5,2)+'.'+SUBSTR(dr,1,4))
    
   m.kmsalias = IIF(m.IsKms, 'kms', IIF(SEEK(m.pvv, 'pvs'), pvs.kmsname, ''))
   m.mvsalias = IIF(m.IsKms, 'moves', IIF(SEEK(m.pvv, 'pvs'), pvs.mvsname, ''))
   m.nkms   = IIF(SEEK(m.pvv, 'pvs'), pvs.nkms, 0)
   m.fname  = UPPER(ofile.name)
   m.mkdate = data_fond
   m.vs     = vs
   m.enp    = enp
   m.nz     = nz
   m.n_kor  = n_kor
   m.blanc  = blanc
   m.dp     = CTOD(SUBSTR(dat_u,7,2)+'.'+SUBSTR(dat_u,5,2)+'.'+SUBSTR(dat_u,1,4))
   m.kmsid  = IIF(SEEK(m.vs, m.kmsalias, 'vs'), &kmsalias..recid, 0)
   m.frecid = IIF(m.kmsid>=0, PADL(m.kmsid,6,'0'), '')
 
   IF SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, m.mvsalias)
    DELETE FROM &mvsalias WHERE fname+frecid=PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid
   ENDIF 
   IF !SEEK(PADR(UPPER(ALLTRIM(m.fname)),25)+m.frecid, m.mvsalias)
    INSERT INTO &mvsalias (et,fname,mkdate,dp,kmsid,frecid,vs,enp,nz,n_kor) VALUES ;
     ('6',m.fname,m.mkdate,m.dp,m.kmsid,m.frecid,m.vs,m.enp,m.nz,m.n_kor)
   ENDIF 
   
   m.isfnd = .f.   

   IF SEEK(m.vs, m.kmsalias)
    m.isfnd = .t.   
    m.nkms = m.nkms + 1
    UPDATE pvs SET nkms=m.nkms WHERE cpv=m.pvv
    SELECT (kmsalias)
    REPLACE enp WITH m.enp, gz_data WITH m.gz_data, blanc WITH m.blanc
    IF status<5
     REPLACE status WITH 5
    ENDIF 
    IF m.qcod=='P2'
     REPLACE nz WITH m.nNZ
    ENDIF 
    SELECT zfile
   ENDIF 
    
   INSERT INTO curappgz (pv,vs,fam,im,ot,w,dr,enp,isfnd) VALUES ;
    (m.pvv,m.vs,m.fam,m.im,m.ot,m.w,m.dr,m.enp,m.isfnd)

  ENDSCAN 

  USE 

  SELECT pvs 
  SCAN 
   m.kmsalias = kmsname
   m.mvsalias = mvsname
   IF USED('&kmsalias')
    USE IN &kmsalias
   ENDIF 
   IF USED('&mvsalias')
    USE IN &mvsalias
   ENDIF 
  ENDSCAN 

 ENDFOR 
 
 SELECT curappgz
 IF RECCOUNT()<=0
  USE 
  USE IN mfcpv
  MESSAGEBOX('НЕ ОБНАРУЖЕНО НИ ОДНОЙ ЗАПИСИ!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ENDIF 
 INDEX ON pv TAG pv
 SET ORDER TO pv

 PUBLIC oExcel AS Excel.Application
 WAIT "Запуск MS Excel..." WINDOW NOWAIT 
 TRY 
  oExcel=GETOBJECT(,"Excel.Application")
 CATCH 
  oExcel=CREATEOBJECT("Excel.Application")
 ENDTRY 
 WAIT CLEAR 
 
 m.BookName = m.qcod+DTOS(DATE())
 m.nOpBooks = oExcel.Workbooks.Count 
 IF m.nOpBooks>0
  FOR m.nBook=1 TO m.nOpBooks
   m.cBookName = LOWER(ALLTRIM(oExcel.Workbooks.Item(m.nBook).Name))
   IF m.cBookName=m.BookName+'.xls'
    oExcel.Workbooks.Item(m.nBook).Close 
   ENDIF 
  NEXT 
 ENDIF 

 oExcel.SheetsInNewWorkbook = RECCOUNT('pvs')
 oBook  = oExcel.WorkBooks.Add

 m.ppvv = ''
 m.nnpv = 0
 m.kol  = 0
 SCAN 
  IF m.ppvv != pv
   IF m.nnpv > 0
   WITH oExcel.Range(oExcel.Cells(5,1), oExcel.Cells(5+m.kol,7))
    .Borders(07).LineStyle = 1 
    .Borders(08).LineStyle = 1
    .Borders(09).LineStyle = 1
    .Borders(10).LineStyle = 1
    .Borders(11).LineStyle = 1
    .Borders(12).LineStyle = 1
   ENDWITH 
   ENDIF 
   m.kol  = 0
   m.ppvv = pv
   m.nnpv = m.nnpv + 1
   oExcel.Sheets(m.nnpv).Select
   oSheet = oexcel.ActiveSheet
   oSheet.PageSetup.Orientation=2
   oSheet.name =  m.ppvv

   WITH oExcel
    .Rows(1).RowHeight=25
    .Columns(1).NumberFormat  = ''
    .Columns(1).ColumnWidth   = 5
    .Columns(2).NumberFormat  = '@'
    .Columns(2).ColumnWidth   = 35
    .Columns(3).NumberFormat  = '@'
    .Columns(3).ColumnWidth   = 10
    .Columns(4).NumberFormat  = '@'
    .Columns(4).ColumnWidth   = 17
    .Columns(5).NumberFormat  = '@'
    .Columns(5).ColumnWidth   = 15
    .Columns(6).NumberFormat  = '@'
    .Columns(6).ColumnWidth   = 19
    .Columns(7).NumberFormat  = '@'
    .Columns(7).ColumnWidth   = 19
   .Cells(1,1) = 'Книга регистрации выдачи полисов ОМС страховой компании '+ALLTRIM(m.qname)+;
     ', ПУНКТ ВЫДАЧИ '+ m.ppvv
    .Cells(2,1)='Дата отправки: '+DTOC(DATE())
    .Cells(3,1)='Номер коробки: '+DTOC(DATE())
    .Range(.Cells(1,1),.Cells(1,7)).Merge
    .Rows(5).VerticalAlignment = -4108
    .Rows(5).RowHeight =30
    .Rows(5).WrapText = .t.
    .Cells(5,1) =	'№№'
    .Cells(5,2) = 'ФИО застрахованного лица'
    .Cells(5,3) = 'Номер ВС'
    .Cells(5,4) = 'Номер полиса'
    .Cells(5,5) = 'Дата выдачи полиса ОМС'
    .Cells(5,6) = 'Подпись застрахованного лица'
    .Cells(5,7) = 'Подпись сотрудника МФЦ'
   ENDWITH 

  ENDIF 
   
  WITH oExcel
   .Cells(6+m.kol,1) = m.kol+1
   .Cells(6+m.kol,2) = ALLTRIM(fam)+' '+ALLTRIM(im)+' '+ALLTRIM(ot)
   .Cells(6+m.kol,3) = vs
   .Cells(6+m.kol,4) = enp
  ENDWITH 
   
  m.kol = m.kol + 1
  
 ENDSCAN 
 WITH oExcel.Range(oExcel.Cells(5,1), oExcel.Cells(5+m.kol,7))
  .Borders(07).LineStyle = 1 
  .Borders(08).LineStyle = 1
  .Borders(09).LineStyle = 1
  .Borders(10).LineStyle = 1
  .Borders(11).LineStyle = 1
  .Borders(12).LineStyle = 1
 ENDWITH 
 oExcel.Sheets(1).Select

 IF fso.FileExists(pout+'\'+m.BookName+'.xls')
  TRY 
   fso.DeleteFile(pout+'\'+m.BookName+'.xls')
   oBook.SaveAs(pout+'\'+m.BookName,18)
  CATCH  
   MESSAGEBOX('ФАЙЛ '+m.BookName+'.XLS ОКТРЫТ!',0+64,'')
  ENDTRY 
 ELSE 
  oBook.SaveAs(pout+'\'+m.BookName,18)
 ENDIF 
 oExcel.Visible = .t.

* REPORT FORM AppGFile PREVIEW 

 USE 
 
 IF USED('pvs')
  SELECT pvs
*  FlName = ZFDir+'\PVS'+DTOS(DATE())
*  COPY TO &FlName
*  BROWSE
  USE 
 ENDIF 
 USE IN mfcpv

*oExcel.Quit 

RETURN 