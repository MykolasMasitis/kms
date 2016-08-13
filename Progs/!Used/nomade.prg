PROCEDURE NoMade
 IF MESSAGEBOX(CHR(13)+CHR(10)+'œŒ—◊»“¿“‹  ŒÀ-¬Œ "«¿ƒ≈–∆¿ÕÕ€’" œŒÀ»—Œ¬?'+CHR(13)+CHR(10),4+16,'')=7
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX(CHR(13)+CHR(10)+'Œ“—”“—¬”≈“ ‘¿…À PVP2.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 CREATE CURSOR cnomade ;
  (pv c(3), vs c(9), vs_data d, fam c(25), im c(25), ot c(25), dr d, w n(1), jt c(1)) 

 SELECT pvp2
 SCAN 
  m.pv = codpv
  ppath = pbase+'\'+m.pv
  IF !fso.FolderExists(ppath)
   LOOP 
  ENDIF 
  IF !fso.FileExists(ppath+'\kms.dbf')
   LOOP 
  ENDIF 
  IF OpenFile(ppath+'\kms', 'kms', 'shar')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
   SELECT pvp2
   LOOP
  ENDIF 
  
  WAIT m.pv+'...' WINDOW NOWAIT 
  SELECT kms
  SCAN 
   m.vs_data = vs_data
   m.status = status
   IF EMPTY(m.vs_data)
    LOOP 
   ENDIF 
   m.enddata = GoNWrkDays(m.vs_data,30)
   IF m.enddata >= DATE()
    LOOP 
   ENDIF 
   IF m.status!=2
    LOOP 
   ENDIF 
   
   m.vs      = vs
   m.fam     = fam
   m.im      = im
   m.ot      = ot
   m.dr      = dr
   m.w       = w
   m.jt      = jt
   
   INSERT INTO cnomade (pv,vs, vs_data,fam,im,ot,dr,w,jt) VALUES ;
    (m.pv,m.vs, m.vs_data,m.fam,m.im,m.ot,m.dr,m.w,m.jt)
 
  ENDSCAN
  USE  
  WAIT CLEAR 

  SELECT pvp2

 ENDSCAN 
 USE 
 
 SELECT cnomade
 flname = 'nmd'+DTOS(DATE())
 COPY TO &pout\&flname
 USE 

 IF 3=2
 PUBLIC oExcel AS Excel.Application
 WAIT "«‡ÔÛÒÍ MS Excel..." WINDOW NOWAIT 
 TRY 
  oExcel=GETOBJECT(,"Excel.Application")
 CATCH 
  oExcel=CREATEOBJECT("Excel.Application")
 ENDTRY 
 WAIT CLEAR 

 WAIT "‘Œ–Ã»–Œ¬¿Õ»≈ Œ“◊≈“¿..." WINDOW NOWAIT 

 oexcel.UseSystemSeparators = .F.
 oexcel.DecimalSeparator = '.'

 oexcel.ReferenceStyle= -4150  && xlR1C1
 
 oexcel.SheetsInNewWorkbook = 1
 oBook = oExcel.WorkBooks.Add
 oexcel.Cells.Font.Name='Calibri'
 oexcel.ActiveSheet.PageSetup.Orientation=2

 oSheet = oBook.WorkSheets(1)
 oSheet.Select

 oRange = oExcel.Range(oExcel.Cells(1,1), oExcel.Cells(1,14))
 oRange.Merge
 oExcel.Cells(1,1).Value='œË˜ËÌ˚ ÓÚÍ‡ÁÓ‚ ‚ ÓÙÓÏÂÎÌËË ÔÓÎËÒ‡ ŒÃ—'
 oExcel.Cells(1,1).HorizontalAlignment = -4108
 oExcel.Cells(1,1).Font.Size = 12
 oExcel.Cells(1,1).Font.Bold = .F.
 oExcel.Cells(1,1).Font.Italic = .T.

 oRange = oExcel.Range(oExcel.Cells(3,1), oExcel.Cells(3,14))
 oRange.Merge
 oExcel.Cells(3,1).Value='—ÃŒ '+ALLTRIM(m.qname)
 oExcel.Cells(3,1).HorizontalAlignment = -4108
 oExcel.Cells(3,1).Font.Size = 12
 oExcel.Cells(3,1).Font.Italic = .T.

 oRange = oExcel.Range(oExcel.Cells(5,1), oExcel.Cells(5,14))
 oRange.Merge
 oExcel.Cells(5,1).Value='ƒ‡Ú‡ '+PADL(DAY(DATE()),2,'0')+' '+LOWER(NameOfMonth2(MONTH(DATE())))+;
  ' '+STR(YEAR(DATE()),4)+' „Ó‰‡'
 oExcel.Cells(5,1).HorizontalAlignment = -4108
 oExcel.Cells(5,1).Font.Size = 12
 oExcel.Cells(5,1).Font.Italic = .T.

 oExcel.Cells(7,1).Value  = 'π Ô/Ô'
 oExcel.Cells(7,2).Value  = ''
 oExcel.Cells(7,3).Value  = ''
 oExcel.Cells(7,4).Value  = ''
 oExcel.Cells(7,13).Value = ''
 oExcel.Cells(7,14).Value = ''
 
 oExcel.Rows(7).RowHeight=25
 oExcel.Rows(7).VerticalAlignment = -4108

 oRange = oExcel.Range(oExcel.Cells(7,1), oExcel.Cells(7,17))
 oRange.Interior.ColorIndex = 42
 oRange = oExcel.Range(oExcel.Cells(7,4), oExcel.Cells(7,12))
 oRange.Merge

 nRow = 8
 nRnn = 1
 SCAN 
  oExcel.Cells(nRow,01).HorizontalAlignment = -4131
  oExcel.Cells(nRow,02).HorizontalAlignment = -4131
  oExcel.Cells(nRow,03).HorizontalAlignment = -4131
  oExcel.Cells(nRow,04).HorizontalAlignment = -4131
  oExcel.Cells(nRow,13).HorizontalAlignment = -4131
  oExcel.Cells(nRow,14).HorizontalAlignment = -4131
  oExcel.Cells(nRow,15).HorizontalAlignment = -4131
  oExcel.Cells(nRow,16).HorizontalAlignment = -4131
  oExcel.Cells(nRow,17).HorizontalAlignment = -4131

  oExcel.Rows(nRow).RowHeight=20
  oExcel.Rows(nRow).VerticalAlignment = -4108

  oExcel.Cells(nRow,1).Value = nRnn
  oExcel.Cells(nRow,2).Value = pv
  oExcel.Cells(nRow,3).Value = vs
  oExcel.Cells(nRow,4).Value = vs_data
  oExcel.Cells(nRow,13).Value = fam
  oExcel.Cells(nRow,14).Value = im 
  oExcel.Cells(nRow,15).Value = ot
  oExcel.Cells(nRow,16).Value = dr
  oExcel.Cells(nRow,17).Value = w 
  nRnn = nRnn + 1
  nRow = nRow + 1
 ENDSCAN 
 USE 

 WAIT CLEAR 

 BookName = 'ER'+m.qcod+PADL(DAY(DATE()),2,'0')+PADL(MONTH(DATE()),2,'0')
 IF fso.FileExists(pOut+'\'+BookName+'.xls')
  fso.DeleteFile(pOut+'\'+BookName+'.xls')
 ENDIF 

 oBook.SaveAs(pOut+'\'+BookName,18)
 oExcel.Visible = .T.
 ENDIF 
 
 MESSAGEBOX(CHR(13)+CHR(10)+'√Œ“Œ¬Œ!'+CHR(13)+CHR(10),0+64,'')
 
RETURN 