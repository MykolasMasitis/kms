PROCEDURE ErMonitor
 IF MESSAGEBOX(CHR(13)+CHR(10)+'ВЫ ХОТИТЕ ПРОВЕСТИ МОНИТОРИНГ?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX(CHR(13)+CHR(10)+'ОТСУТСВУЕТ ФАЙЛ PVP2.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 CREATE CURSOR curerrs (ans_fl c(2), err c(5), "comment" c(250), k_u n(5), k_uok n(5))
 INDEX on ans_fl+err TAG ans_fl 
 SET ORDER TO ans_fl
 
 SELECT pvp2
 SCAN 
  m.pv = codpv
  ppath = pbase+'\'+m.pv
  IF !fso.FolderExists(ppath)
   LOOP 
  ENDIF 
  IF !fso.FileExists(ppath+'\e_ffoms.dbf')
   LOOP 
  ENDIF 
  IF OpenFile(ppath+'\e_ffoms', 'errs', 'shar')>0
   IF USED('errs')
    USE IN errs
   ENDIF 
   SELECT pvp2
   LOOP
  ENDIF 
  
  SELECT errs
  SCAN 
   m.ans_fl  = ans_fl 
   m.err     = err
   m.comment = comment
   m.v       = v
   m.dcor    = dcor

   IF !SEEK(m.ans_fl+m.err, 'curerrs')
    INSERT INTO curerrs (ans_fl, err, "comment", k_u, k_uok) ;
     VALUES ;
      (m.ans_fl, m.err, m.comment, 1, IIF(!EMPTY(m.dcor),1,0)) 
   ELSE 
    m.ok_u = curerrs.k_u
    m.ok_uok = curerrs.k_uok

    UPDATE curerrs SET k_u = m.ok_u + 1, k_uok = m.ok_uok + IIF(!EMPTY(m.dcor),1,0) ;
     WHERE ans_fl = m.ans_fl AND err=m.err
   
*    IF !EMPTY(m.dcor)
*     m.ok_uok = curerrs.k_uok
*     UPDATE curerrs SET k_uok = m.ok_uok + 1 WHERE ans_fl = m.ans_fl AND err=m.err
*    ENDIF 
   
   ENDIF 

  ENDSCAN
  USE  

  SELECT pvp2

 ENDSCAN 
 USE 
 
 SELECT curerrs
 INDEX on ans_fl TAG ans_fl
 SET ORDER TO ans_fl
 
 PUBLIC oExcel AS Excel.Application
 WAIT "Запуск MS Excel..." WINDOW NOWAIT 
 TRY 
  oExcel=GETOBJECT(,"Excel.Application")
 CATCH 
  oExcel=CREATEOBJECT("Excel.Application")
 ENDTRY 
 WAIT CLEAR 

 WAIT "ФОРМИРОВАНИЕ ОТЧЕТА..." WINDOW NOWAIT 

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
 oExcel.Cells(1,1).Value='Причины отказов в оформелнии полиса ОМС'
 oExcel.Cells(1,1).HorizontalAlignment = -4108
 oExcel.Cells(1,1).Font.Size = 12
 oExcel.Cells(1,1).Font.Bold = .F.
 oExcel.Cells(1,1).Font.Italic = .T.

 oRange = oExcel.Range(oExcel.Cells(3,1), oExcel.Cells(3,14))
 oRange.Merge
 oExcel.Cells(3,1).Value='СМО '+ALLTRIM(m.qname)
 oExcel.Cells(3,1).HorizontalAlignment = -4108
 oExcel.Cells(3,1).Font.Size = 12
 oExcel.Cells(3,1).Font.Italic = .T.

 oRange = oExcel.Range(oExcel.Cells(5,1), oExcel.Cells(5,14))
 oRange.Merge
 oExcel.Cells(5,1).Value='Дата '+PADL(DAY(DATE()),2,'0')+' '+LOWER(NameOfMonth2(MONTH(DATE())))+;
  ' '+STR(YEAR(DATE()),4)+' года'
 oExcel.Cells(5,1).HorizontalAlignment = -4108
 oExcel.Cells(5,1).Font.Size = 12
 oExcel.Cells(5,1).Font.Italic = .T.

 oExcel.Cells(7,1).Value  = '№ п/п'
 oExcel.Cells(7,2).Value  = 'ANS_FL'
 oExcel.Cells(7,3).Value  = 'ERR'
 oExcel.Cells(7,4).Value  = 'Расшифорвка ошибки'
 oExcel.Cells(7,13).Value = 'кол-во'
 oExcel.Cells(7,14).Value = 'Исправл.'
 
 oExcel.Rows(7).RowHeight=25
 oExcel.Rows(7).VerticalAlignment = -4108

 oRange = oExcel.Range(oExcel.Cells(7,1), oExcel.Cells(7,14))
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

  oExcel.Rows(nRow).RowHeight=20
  oExcel.Rows(nRow).VerticalAlignment = -4108

  oExcel.Cells(nRow,1).Value = nRnn
  oExcel.Cells(nRow,2).Value = ans_fl
  oExcel.Cells(nRow,3).Value = err
  oExcel.Cells(nRow,4).Value = comment
  oExcel.Cells(nRow,13).Value = k_u
  oExcel.Cells(nRow,14).Value = k_uok
  nRnn = nRnn + 1
  nRow = nRow + 1
 ENDSCAN 
 USE 
 
 oRange = oExcel.Range(oExcel.Cells(8,1), oExcel.Cells(nRow-1,14))
 oRange.Interior.ColorIndex = 8

 oRange = oExcel.Range(oExcel.Cells(7,1), oExcel.Cells(nRow-1,14))
 oRange.Borders(5).LineStyle   = -4142 && .Borders(xlDiagonalDown).LineStyle = xlNone
 oRange.Borders(6).LineStyle   = -4142 && .Borders(xlDiagonalUp).LineStyle = xlNone
 oRange.Borders(7).LineStyle   = 1     && .Borders(xlEdgeLeft).LineStyle = xlContinuous
 oRange.Borders(7).Weight      = 2     && .Borders(xlEdgeLeft).Weight = xlThin
 oRange.Borders(7).ColorIndex  = -4105 && .Borders(xlEdgeLeft).ColorIndex = xlAutomatic
 oRange.Borders(8).LineStyle   = 1     && .Borders(xlEdgeTop).LineStyle = xlContinuous
 oRange.Borders(8).Weight      = 2     && .Borders(xlEdgeTop).Weight = xlThin
 oRange.Borders(8).ColorIndex  = -4105 && .Borders(xlEdgeTop).ColorIndex = xlAutomatic
 oRange.Borders(9).LineStyle   = 1     && .Borders(xlEdgeBottom).LineStyle = xlContinuous
 oRange.Borders(9).Weight      = 2     && .Borders(xlEdgeBottom).Weight = xlThin
 oRange.Borders(9).ColorIndex  = -4105 && .Borders(xlEdgeBottom).ColorIndex = xlAutomatic
 oRange.Borders(10).LineStyle   = 1     && .Borders(xlEdgeRight).LineStyle = xlContinuous
 oRange.Borders(10).Weight      = 2     && .Borders(xlEdgeRight).Weight = xlThin
 oRange.Borders(10).ColorIndex  = -4105 && .Borders(xlEdgeRight).ColorIndex = xlAutomatic
 oRange.Borders(11).LineStyle   = 1     && .Borders(xlInsideVertical).LineStyle = xlContinuous
 oRange.Borders(11).Weight      = 2     && .Borders(xlInsideVertical).Weight = xlThin
 oRange.Borders(11).ColorIndex  = -4105 && .Borders(xlInsideVertical).ColorIndex = xlAutomatic
 oRange.Borders(12).LineStyle   = 1     && .Borders(xlInsideHorizontal).LineStyle = xlContinuous
 oRange.Borders(12).Weight      = 2     && .Borders(xlInsideHorizontal).Weight = xlThin
 oRange.Borders(12).ColorIndex  = -4105 && .Borders(xlInsideHorizontal).ColorIndex = xlAutomatic

 WAIT CLEAR 

 BookName = 'ER'+m.qcod+PADL(DAY(DATE()),2,'0')+PADL(MONTH(DATE()),2,'0')
 IF fso.FileExists(pOut+'\'+BookName+'.xls')
  fso.DeleteFile(pOut+'\'+BookName+'.xls')
 ENDIF 

 oBook.SaveAs(pOut+'\'+BookName,18)
 oExcel.Visible = .T.
 
RETURN 