PROCEDURE PrnNeVostr

 IF MESSAGEBOX('ВЫ ХОТИТЕ СФОМИРОВАТЬ ЖУРНАЛ?',4+32, '')==7
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'ppvp2', 'shar')>0
  IF USED('ppvp2')
   USE IN ppvp2
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
 oBook  = oExcel.WorkBooks.Add
 oSheet = oExcel.ActiveSheet

 PRIVATE n_pv, k_pv
 m.k_pv=0
 m.k_pv = RECCOUNT('ppvp2')

 DIMENSION dimppvp2(m.k_pv)
 SELECT ppvp2

 SCAN 
  dimppvp2(RECNO('ppvp2')) = codpv
 ENDSCAN 
 USE 

 FOR m.n_pv=1 TO m.k_pv
  IF !fso.FolderExists(pBase+'\'+dimppvp2(n_pv))
   LOOP 
  ENDIF 
  IF !fso.FileExists(pBase+'\'+dimppvp2(n_pv)+'\kms.dbf')
   LOOP 
  ENDIF 
  IF OpenFile(pBase+'\'+dimppvp2(m.n_pv)+'\kms', "kms", "SHARED", "vs")>0
   IF USED('kms')
    USE IN kms 
   ENDIF 
   LOOP 
  ENDIF 
  IF OpenFile(pBase+'\'+dimppvp2(m.n_pv)+'\wrkpl', "wrkpl", "shar", "recid")>0
   IF USED('kms')
    USE IN kms 
   ENDIF 
   IF USED('wrkpl')
    USE IN wrkpl
   ENDIF 
   LOOP 
  ENDIF 
  
  WAIT "ФОРМИРОВАНИЕ ЛИСТА ПО ПВ " + dimppvp2(n_pv) WINDOW NOWAIT 
  =prnVsEnpOne(dimppvp2(n_pv))
  oSheetprev = oSheet
  oSheet =  oBook.WorkSheets.Add(,oSheetprev)
  RELEASE oSheetprev
  WAIT CLEAR 
 ENDFOR
 RELEASE dimppvp2,n_pv,k_pv

 oBook.WorkSheets(1).Select

 IF fso.FileExists(pOut+'\Журнал невостребованных ЕНП.xls')
  fso.DeleteFile(pOut+'\Журнал невостребованных ЕНП.xls')
 ENDIF 

 BookName = pOut+'\Журнал невостребованных ЕНП'
 oBook.SaveAs(BookName)
 oExcel.Visible=.t.
 
RETURN 

FUNCTION prnVsEnpOne(punktv)

 oSheet.Select
 oSheet.name = punktv
 
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
  .cells(1,11).Value2  = 'Место работы'
 ENDWITH 
 
 SELECT kms 
 SET RELATION TO wrkid INTO wrkpl
 nCell = 1
* SCAN FOR !EMPTY(enp) AND TYPE(enp)='N' AND jt!='r' AND INLIST(status,4,5)
 SCAN FOR !EMPTY(enp) AND TYPE(enp)='N' AND jt!='r' AND status=5

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
  m.gz_data = gz_data
*  m.dvdata = GoNWrkDays(m.gz_data,30)
  m.wrkplace = ALLTRIM(wrkpl.name)

  IF m.gz_data + 45 < DATE()
  WITH oExcel.ActiveSheet
   .cells(nCell,1).Value2  = STR(nCell,6)
   .cells(nCell,2).Value2  = punktv
   .cells(nCell,3).Value2  = m.nz
   .cells(nCell,4).Value2  = m.vs
   .cells(nCell,5).Value2  = m.d_beg
   .cells(nCell,6).Value2  = m.enp
   .cells(nCell,7).Value2  = m.d_enp
   .cells(nCell,8).Value2  = m.fio
   .cells(nCell,9).Value2  = m.dr
   .cells(nCell,10).Value2 = m.tel
   .cells(nCell,11).Value2 = m.wrkplace
  ENDWITH 
  ENDIF 

 ENDSCAN 
 SET RELATION OFF INTO wrkpl
 USE IN kms 
 USE IN wrkpl

 FOR iii=1 TO 11
  oexcel.Columns(iii).AutoFit
 ENDFOR 

RETURN 