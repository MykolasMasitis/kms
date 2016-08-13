PROCEDURE PrnNeVostrE
 IF MESSAGEBOX('ВЫ ХОТИТЕ СФОМИРОВАТЬ ЖУРНАЛ?',4+32, '')==7
  RETURN 
 ENDIF 

 IF OpenFile(pBase+'\kms', 'kms', 'shar', "vs")>0
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
 
 WAIT "ФОРМИРОВАНИЕ ОТЧЕТА..." WINDOW NOWAIT 
 oSheet.Select
 
 FOR iii=1 TO 10
  oexcel.Columns(iii).NumberFormat='@'
 ENDFOR 

 WITH oExcel.ActiveSheet
  .cells(1,1).Value2   = '№ п/п'
  .cells(1,2).Value2   = 'ПВ'
  .cells(1,3).Value2   = 'Заявка'
  .cells(1,4).Value2   = 'ВС'
  .cells(1,5).Value2   = 'Дата ВС'
  .cells(1,6).Value2   = 'ЕНП'
  .cells(1,7).Value2   = 'Дата ЕНП'
  .cells(1,8).Value2   = 'ФИО'
  .cells(1,9).Value2   = 'Дата рождения'
  .cells(1,10).Value2  = 'Телефон'
 ENDWITH 
 
 SELECT kms 
 nCell = 1
 SCAN FOR !EMPTY(enp) AND TYPE(enp)='N' AND jt!='r' AND INLIST(status,4,5)
  nCell = nCell + 1
  m.pv  = pv
  m.vs  = vs
  m.nz  = nz
  m.d_beg = IIF(m.qcod='P2', DTOC(dp), DTOC(vs_data))
  m.enp = enp
  m.d_enp = DTOC(gz_data)
  m.fio = ALLTRIM(fam)+' '+LEFT(im,1)+'.'+LEFT(ot,1)+'.'
  m.dr = DTOC(dr)
  m.tel = ALLTRIM(cont)

  WITH oExcel.ActiveSheet
   .cells(nCell,1).Value2 = STR(nCell,6)
   .cells(nCell,2).Value2 = punktv
   .cells(nCell,3).Value2 = m.nz
   .cells(nCell,4).Value2 = m.vs
   .cells(nCell,5).Value2 = m.d_beg
   .cells(nCell,6).Value2 = m.enp
   .cells(nCell,7).Value2 = m.d_enp
   .cells(nCell,8).Value2 = m.fio
   .cells(nCell,9).Value2 = m.dr
   .cells(nCell,10).Value2 = m.tel
  ENDWITH 

 ENDSCAN 
 USE IN kms 

 FOR iii=1 TO 10
  oexcel.Columns(iii).AutoFit
 ENDFOR 
 WAIT CLEAR 

 
 oBook.WorkSheets(1).Select

 IF fso.FileExists(pOut+'\Журнал невостребованных ЕНП.xls')
  fso.DeleteFile(pOut+'\Журнал невостребованных ЕНП.xls')
 ENDIF 

 BookName = pOut+'\Журнал невостребованных ЕНП'
 oBook.SaveAs(BookName)
 oExcel.Visible=.t.
 
RETURN 

