PROCEDURE PrnNeVostr2
 IF kol_pv!=1
  MESSAGEBOX('ДЛЯ ФОРМИРОВАНИЯ ЖУРНАЛА'+CHR(13)+CHR(10)+;
   'НЕОБХОДИМО, ЧТОБЫ БЫЛ ВЫБРАН ОДНИ ПУНКТ',0+16, '')
  RETURN 
 ENDIF 
 
 IF MESSAGEBOX('ВЫ ХОТИТЕ СФОМИРОВАТЬ ЖУРНАЛ?',4+32, '')==7
  RETURN 
 ENDIF 
 
 IF OpenFile("&pBase\&pvid(1,1)\kms", "kms", "SHARED", "vs")>0
  RETURN 
 ENDIF 
 
 m.nz = ''
 m.comment = ''

 DO FORM TuneNvstr
 
 m.nz = ALLTRIM(m.nz)
 m.comment = ALLTRIM(m.comment)

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

 BookName = pOut+'\Журнал невостребованных ЕНП'
 oSheet = oBook.WorkSheets(1)
 oSheet.Select
 
 FOR iii=1 TO 11
  oexcel.Columns(iii).NumberFormat='@'
 ENDFOR 

 WITH oExcel.Sheets(1)
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
  .cells(1,11).Value2  = 'Комментарий'
 ENDWITH 

 
 SELECT kms 
 nCell = 1
 SCAN FOR !EMPTY(enp) AND TYPE(enp)='N' AND jt!='r' AND IIF(!EMPTY(m.nz), nz=m.nz, 1=1) ;
  AND IIF(!EMPTY(m.comment), comment=m.comment, 1=1)
  nCell = nCell + 1
  m.pv = pvid(1,1)
  m.vs  = vs
  m.nz = nz
  m.d_beg = IIF(m.qcod='P2', DTOC(dp), DTOC(vs_data))
  m.enp = enp
  m.d_enp = DTOC(gz_data)
  m.fio = ALLTRIM(fam)+' '+LEFT(im,1)+'.'+LEFT(ot,1)+'.'
  m.dr = DTOC(dr)
  m.tel = ALLTRIM(cont)
  m.coment = ALLTRIM(comment)
  

  WITH oExcel.Sheets(1)
   .cells(nCell,1).Value2 = STR(nCell,6)
   .cells(nCell,2).Value2 = m.pv
   .cells(nCell,3).Value2 = m.nz
   .cells(nCell,4).Value2 = m.vs
   .cells(nCell,5).Value2 = m.d_beg
   .cells(nCell,6).Value2 = m.enp
   .cells(nCell,7).Value2 = m.d_enp
   .cells(nCell,8).Value2 = m.fio
   .cells(nCell,9).Value2 = m.dr
   .cells(nCell,10).Value2 = m.tel
   .cells(nCell,11).Value2 = m.coment
  ENDWITH 

 ENDSCAN 
 USE IN kms 

 FOR iii=1 TO 11
  oexcel.Columns(iii).AutoFit
 ENDFOR 

 oBook.SaveAs(BookName)
 oBook.Close
 oExcel.Quit
 

RETURN 