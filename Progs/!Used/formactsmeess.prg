PROCEDURE FormActsMEEss
 IF MESSAGEBOX(CHR(13)+CHR(10)+'ВЫ ХОТИТЕ СФОРМИРОВАТЬ'+CHR(13)+CHR(10)+;
  'АКТЫ МЭЭ СТРАХОВОГО СЛУЧАЯ?'+CHR(13)+CHR(10),4+32,'')==7
  RETURN 
 ENDIF 

 DotName = 'Акт_МЭЭ_СС.dot'

 IF !fso.FileExists(pTempl+'\'+DotName)
  MESSAGEBOX('ОТСУТСТВУЕТ ФАЙЛ ШАБЛОН ОТЧЕТА'+CHR(13)+CHR(10)+;
   'Акт_МЭЭ_СС.dot',0+32,'')
  RETURN 
 ENDIF 
 
 MeeDir = fso.GetParentFolderName(pbin)+'\MEE'
 IF !fso.FolderExists(MeeDir)
  fso.CreateFolder(MeeDir)
 ENDIF 

 IF OpenFile(pCommon+'\tarifn', 'tarif', 'shared', 'cod')>0
  RETURN 
 ENDIF 

 WAIT "ЗАПУСК WORD..." WINDOW NOWAIT 
 TRY 
  oWord = GETOBJECT(,"Word.Application")
 CATCH 
  oWord = CREATEOBJECT("Word.Application")
 ENDTRY 
 WAIT CLEAR 
 
 oDoc = oWord.Documents.Add(pTempl+'\'+DotName)

 m.exp_dat1 = '01.'+PADL(tMonth,2,'0')+'.'+STR(tYear,4)
 m.exp_dat2 = DTOC(GOMONTH(CTOD(m.exp_dat1),1)-1)

 SELECT aisoms
 SCAN 
  IF s_pred-sum_flk <= 0
   LOOP 
  ENDIF 
  
  m.mcod  = mcod 
  m.lpuid = lpuid
  m.IsVed   = IIF(LEFT(m.mcod,1) == '0', .F., .T.)

  WAIT m.mcod WINDOW NOWAIT 
  ExpView.Refresh

  pPath = pBase+'\'+gcPeriod+'\'+m.mcod
  IF OpenFile(pPath+'\Talon', 'Talon', 'SHARED', 'sn_pol')>0
   LOOP 
  ENDIF 
  
  m.IsExpMee = .f.
  m.checked_tot = 0
  m.bad_kol = 0
  m.bad_sum = 0
  m.opl_tot = 0
  m.vzaim_tot = 0
  nRow      = 4

  
  SELECT talon 
  SCAN 
   IF m.IsExpMee = .f. AND !EMPTY(err_mee)
    m.IsExpMee = .t.
    m.lpuname = IIF(SEEK(m.lpuid, 'sprlpu'), ALLTRIM(sprlpu.name)+', '+m.mcod, '')

    m.n_akt = mcod + m.qcod + PADL(tMonth,2,'0') + RIGHT(STR(tYear,4),1)
    oDoc.Bookmarks('n_akt').Select  
    oWord.Selection.TypeText(m.n_akt)
    m.d_akt = DTOC(DATE())
    oDoc.Bookmarks('d_akt').Select  
    oWord.Selection.TypeText(m.d_akt)
    oDoc.Bookmarks('smo_name').Select  
    oWord.Selection.TypeText(m.qname)
    oDoc.Bookmarks('lpu_name').Select  
    oWord.Selection.TypeText(m.lpuname)
    oDoc.Bookmarks('exp_dat1').Select  
    oWord.Selection.TypeText(m.exp_dat1)
    oDoc.Bookmarks('exp_dat2').Select  
    oWord.Selection.TypeText(m.exp_dat2)

   ENDIF 
   
   IF !EMPTY(err_mee)
    m.checked_tot = m.checked_tot + 1
    IF err_mee != 'W0'
     m.bad_kol = m.bad_kol + 1
     oDoc.Tables(1).Cell(nRow,1).Select 
     oWord.Selection.InsertRows
     oWord.Selection.TypeText(STR(m.bad_kol,3))
     oDoc.Tables(1).Cell(nRow,2).Select && Полис
     oWord.Selection.TypeText(ALLTRIM(sn_pol))
     oDoc.Tables(1).Cell(nRow,3).Select && Карта
     oWord.Selection.TypeText(ALLTRIM(c_i))
     oDoc.Tables(1).Cell(nRow,4).Select && Начало обращения
     oWord.Selection.TypeText(DTOC(d_u))
     oDoc.Tables(1).Cell(nRow,5).Select && Конец обращения
     oWord.Selection.TypeText(DTOC(d_u))
     oDoc.Tables(1).Cell(nRow,6).Select && Код МКБ
     oWord.Selection.TypeText(ALLTRIM(ds))
     oDoc.Tables(1).Cell(nRow,8).Select && Код дефекто по Пр.230
     oDoc.Tables(1).Cell(nRow,9).Select && Код ошибки
     oWord.Selection.TypeText(err_mee)
     
     m.ns_all = 0
     m.delta  = 0
     
     IF EMPTY(e_cod) AND EMPTY(e_tip) AND EMPTY(e_ku) && Полное снятие!
      m.bad_sum = m.bad_sum + s_all
     ELSE 
      IF (!EMPTY(e_cod) AND cod != e_cod) OR ;
         (!EMPTY(e_ku) AND k_u != e_ku) OR ;
         (!EMPTY(e_tip) AND e_tip != tip)
       m.ns_all = fsumm(e_cod, e_tip, e_ku, m.IsVed)
       m.delta = s_all - m.ns_all
       m.bad_sum = m.bad_sum + m.delta
       m.opl_tot   = m.opl_tot + m.ns_all
       m.vzaim_tot = m.vzaim_tot + m.delta
      ENDIF 
     ENDIF 

     oDoc.Tables(1).Cell(nRow,7).Select && Оплачено за услуги
     oWord.Selection.TypeText(TRANSFORM(m.ns_all, '9999999.99'))
     oDoc.Tables(1).Cell(nRow,10).Select && Размер взаимозачета
     oWord.Selection.TypeText(TRANSFORM(m.delta, '9999999.99'))
     
     nRow = nRow + 1

    ENDIF 
   ENDIF 
    
  ENDSCAN 
  USE IN talon 
  SELECT aisoms
  
  IF m.IsExpMee = .t.
   oDoc.Bookmarks('checked_tot').Select  
   oWord.Selection.TypeText(TRANSFORM(m.checked_tot,'99999'))
   oDoc.Bookmarks('bad_kol').Select  
   oWord.Selection.TypeText(TRANSFORM(m.bad_kol, '9999999'))
   oDoc.Bookmarks('bad_sum').Select  
   oWord.Selection.TypeText(TRANSFORM(m.bad_sum, '9999999.99'))

   oDoc.Bookmarks('opl_tot').Select  
   oWord.Selection.TypeText(TRANSFORM(m.opl_tot,'9999999.99'))
   oDoc.Bookmarks('vzaim_tot').Select  
   oWord.Selection.TypeText(TRANSFORM(m.vzaim_tot,'9999999.99'))
  
   oDoc.SaveAs(DocName,0)
  ENDIF 
  
  WAIT CLEAR 
 ENDSCAN 
 GO TOP 
 ExpView.Refresh
 
 WAIT "ОСТАНОВКА WORD..." WINDOW NOWAIT 
 oWord.Quit
 WAIT CLEAR 

 USE IN tarif 

RETURN 