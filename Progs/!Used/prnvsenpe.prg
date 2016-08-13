PROCEDURE PrnVSENPE
 IF MESSAGEBOX('ВЫ ХОТИТЕ СФОМИРОВАТЬ ЖУРНАЛ?',4+32, '')==7
  RETURN 
 ENDIF 
 
 IF OpenFile(pBase+'\kms', "kms", "SHARED", "vs")>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 
 PUBLIC oExcel AS Excel.Application

 WAIT "Запуск MS Excel..." WINDOW NOWAIT 
 TRY 
  oExcel=GETOBJECT(,"Excel.Application")
 CATCH 
  oExcel=CREATEOBJECT("Excel.Application")
 ENDTRY 
 WAIT CLEAR 

 oexcel.SheetsInNewWorkbook=1
 oBook = oExcel.WorkBooks.Add
 oSheet = oExcel.ActiveSheet
  
 WAIT "ФОРМИРОВАНИЕ ОТЧЕТА... " WINDOW NOWAIT 

 oSheet.Select
 
 FOR iii=1 TO 8
  oexcel.Columns(iii).NumberFormat='@'
 ENDFOR 
 
 SELECT kms 
 nCell = 0
 SCAN FOR !EMPTY(vs)
  nCell = nCell + 1
  m.vs = vs
  m.d_beg = DTOC(vs_data)
  m.d_end = DTOC(vs_data + 38)
  m.fio = ALLTRIM(fam)+' '+LEFT(im,1)+'.'+LEFT(ot,1)+'.'
  m.tel = ALLTRIM(cont)
  m.enp = enp
  m.d_enp = DTOC(gz_data)

  WITH oExcel.ActiveSheet
   .cells(nCell,1).Value2 = STR(nCell,6)
   .cells(nCell,2).Value2 = m.vs
   .cells(nCell,3).Value2 = m.d_beg
   .cells(nCell,4).Value2 = m.d_end
   .cells(nCell,5).Value2 = m.fio
   .cells(nCell,6).Value2 = m.tel
   .cells(nCell,7).Value2 = m.enp
   .cells(nCell,8).Value2 = m.d_enp
   .cells(nCell,9).Value2 = m.tel
  ENDWITH 

 ENDSCAN 

 FOR iii=1 TO 8
  oexcel.Columns(iii).AutoFit
 ENDFOR 

 WAIT CLEAR 

 oBook.WorkSheets(1).Select

 IF fso.FileExists(pOut+'\Журнал учета ВС.xls')
  fso.DeleteFile(pOut+'\Журнал учета ВС.xls')
 ENDIF 

 BookName = pOut+'\Журнал учета ВС'
 oBook.SaveAs(BookName)
 oExcel.Visible = .T. 
* oBook.Close
* oExcel.Quit
 
RETURN 

