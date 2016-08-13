PROCEDURE RepPanazE
 IF MESSAGEBOX('ВЫ ХОТИТЕ СФОМИРОВАТЬ ОТЧЕТ?',4+32, '')==7
  RETURN 
 ENDIF 
 
 tResult = .f.
 DO FORM TuneUp TO tResult
	
 IF !tResult
  RETURN 
 ENDIF 
  
 IF OpenFile("&pBase\kms", "kms", "SHARED", "vs")>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile("&pBase\adr50", "adr50", "SHARED", 'recid')>0
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile("&pBase\adr77", "adr77", "SHARED", 'recid')>0
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 

 =OpenFile(PCommon+'\citytype', 'CityType', 'SHARED', 'code')
 =OpenFile(PCommon+'\okato', 'okato', 'SHARED', 'code')
 =OpenFile("&PCommon\Street", "Street", "SHARED", "Ul")

 SELECT adr50
 SET RELATION TO np_c INTO CityType
 SET RELATION TO c_okato INTO okato ADDITIVE 
 SELECT kms
 SET RELATION TO adr_id INTO adr77
 SET RELATION TO adr50_id INTO adr50 ADDITIVE 

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

 BookName = pOut+'\Jrn_'+DTOS(gdCurDat1)+'_'+DTOS(gdCurDat2)
 oSheet = oBook.WorkSheets(1)
 oSheet.Select
 
 FOR iii=1 TO 16
  oexcel.Columns(iii).NumberFormat='@'
 ENDFOR 

 WITH oExcel.Sheets(1)
  .cells(1,1).Value2   = 'Фамилия'
  .cells(1,2).Value2   = 'Имя'
  .cells(1,3).Value2   = 'Отчество'
  .cells(1,4).Value2   = 'Свидетельство'
  .cells(1,5).Value2   = 'Ф. полис'
  .cells(1,6).Value2   = 'Телефон'
  .cells(1,7).Value2   = 'Сл. тел.'
  .cells(1,8).Value2   = 'e_mail'
  .cells(1,9).Value2   = 'Факт. индекс'
  .cells(1,10).Value2  = 'Факт. адрес'
  .cells(1,11).Value2  = 'Индекс рег.'
  .cells(1,12).Value2  = 'Адрес регистрации'
  .cells(1,13).Value2  = '№ Акта (пачки)'
  .cells(1,14).Value2  = 'Дата акта'
  .cells(1,15).Value2  = 'notif'
  .cells(1,16).Value2  = 'date_notig'
 ENDWITH 
 
 SELECT kms 
 nCell = 1
 SCAN FOR BETWEEN(gz_data, gdCurDat1, gdCurDat2) AND jt!='r'
  nCell = nCell + 1
  m.fam = ALLTRIM(fam)
  m.im = ALLTRIM(im)
  m.ot = ALLTRIM(ot)
  m.vs = vs
  m.enp = enp
  m.tel = ALLTRIM(cont)
  m.d_enp = DTOC(gz_data)
*  m.n_kor = IIF(n_kor>0, ALLTRIM(STR(n_kor)), 'Нет данных')

  m.msc_adr  = 'Москва, '+IIF(SEEK(adr77.Ul,'Street'), ;
   ALLTRIM(Street.Street),'')+IIF(!EMPTY(adr77.d), ', д.'+ALLTRIM(adr77.D),'') +;
   IIF(!EMPTY(adr77.Kor), ', корп.'+ALLTRIM(adr77.Kor),'') + IIF(!EMPTY(adr77.Str), ', стр.'+ALLTRIM(adr77.Str),'') + ;
   IIF(!EMPTY(adr77.Kv), ', кв.'+ALLTRIM(adr77.Kv),'')

  m.adr_obl = UPPER(ALLTRIM(okato.name))
  m.adr_rjn = UPPER(ALLTRIM(adr50.ra_name))
  m.adr_gor = UPPER(ALLTRIM(CityType.name) + ' ' + ALLTRIM(adr50.np_name))
  m.adr_ul  = UPPER(ALLTRIM(adr50.ul_name))
  m.adr_dom = ALLTRIM(adr50.dom)
  m.adr_kor = ALLTRIM(adr50.kor)
  m.adr_str = ALLTRIM(adr50.str)
  m.adr_kvr = ALLTRIM(adr50.kv)

  m.obl_adr = PROPER(m.adr_obl) + IIF(!EMPTY(m.adr_rjn), ', р-он ' + PROPER(m.adr_rjn), '')+;
   IIF(!EMPTY(m.adr_gor), ', ' + PROPER(m.adr_gor), '') + IIF(!EMPTY(m.adr_ul), ', ' + PROPER(m.adr_ul), '')+;
   IIF(!EMPTY(m.adr_dom), ', д. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', корп. ' + m.adr_kor, '')+;
   IIF(!EMPTY(m.adr_str), ', стр. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', кв. ' + m.adr_kvr, '')
 
  m.adr_ter = IIF(BETWEEN(kl,0,27) or kl=45, 45, INT(VAL(LEFT(adr50.c_okato,2))))
  IF m.adr_ter != 45
   m.adr_reg  = m.obl_adr
   m.fact_adr = m.msc_adr
  ELSE 
   m.fact_adr = m.msc_adr
   m.adr_reg = m.msc_adr
  ENDIF 

  WITH oExcel.Sheets(1)
   .cells(nCell,1).Value2  = m.fam
   .cells(nCell,2).Value2  = m.im
   .cells(nCell,3).Value2  = m.ot
   .cells(nCell,4).Value2  = m.vs
   .cells(nCell,5).Value2  = m.enp
   .cells(nCell,6).Value2  = m.tel
   .cells(nCell,10).Value2 = m.fact_adr
   .cells(nCell,12).Value2 = m.adr_reg
*   .cells(nCell,13).Value2 = m.n_kor
   .cells(nCell,14).Value2 = m.d_enp
  ENDWITH 

 ENDSCAN 
 SET RELATION OFF INTO adr50
 SET RELATION OFF INTO adr77
 USE IN kms 
 SELECT adr50 
 SET RELATION OFF INTO okato
 SET RELATION OFF INTO CityType
 USE IN adr50
 USE IN adr77
 USE IN okato
 USE IN CityType
 USE IN street 

 FOR iii=1 TO 16
  oexcel.Columns(iii).AutoFit
 ENDFOR 

 IF fso.FileExists(BookName+'.xls')
  fso.DeleteFile(BookName+'.xls')
 ENDIF 
 IF fso.FileExists(BookName+'.xlx')
  fso.DeleteFile(BookName+'.xlx')
 ENDIF 
 oBook.SaveAs(BookName)
 oBook.Close
 oExcel.Quit
 
 MESSAGEBOX('ГОТОВО!'+CHR(13)+CHR(10),0+64,'')
 

RETURN 