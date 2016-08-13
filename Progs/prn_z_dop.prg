PROCEDURE prn_z_dop
 PRIVATE m.fam, m.im, m.ot,;
  m.ul, m.d, m.kor, m.str, m.kv, m.kl, m.ul_name
 dotname = pTempl + "\z_dop.dot"
 docname = pLocal + "\z_dop"
 
 m.dp       = DTOC(dp)
 m.fioinsp  = ALLTRIM(m.userfam)+ ' ' + LEFT(ALLTRIM(m.userim),1)+'.'+LEFT(ALLTRIM(m.userot),1)+'.'
 m.vs       = vs
 m.Fam      = ALLTRIM(Fam)
 m.Im       = ALLTRIM(Im)
 m.Ot       = ALLTRIM(Ot)
 m.w        = w
 m.dr       = DTOC(dr)
 m.mr       = ALLTRIM(mr)
 m.c_doc    = c_doc
 m.viddoc   = IIF(SEEK(m.c_doc,"VidDoc"), ALLTRIM(VidDoc.Name), "")
 m.s_doc    = ALLTRIM(s_doc)
 m.n_doc    = ALLTRIM(n_doc)
 m.d_doc    = DTOC(d_doc)
 m.podr_doc = ALLTRIM(podr_doc)
 m.gr       = gr
 m.grname   = IIF(SEEK(m.gr, "country"), ALLTRIM(country.name), "")
 m.Ul      = adr77.Ul
 m.ulname  = IIF(SEEK(m.Ul, 'street'), ALLTRIM(street.street), '')
 m.dom     = ALLTRIM(adr77.d)
 m.kor     = ALLTRIM(adr77.kor)
 m.str     = ALLTRIM(adr77.str)
 m.kv      = ALLTRIM(adr77.kv)
 m.dat_reg = dat_reg
 m.ss      = ss
 m.cont    = ALLTRIM(cont)

 m.pplfio = m.fam + ' ' + LEFT(m.im,1) + '.' + LEFT(m.ot,1) + '.'

 m.Kl      = Kl
 
 m.c_okato  = adr50.c_okato
 m.obl_name = IIF(SEEK(m.c_okato, "okato"), ALLTRIM(okato.name), "")
 m.ra_name  = ALLTRIM(adr50.ra_name)
 m.gor_name = ''
 m.np_c     = adr50.np_c
 m.np_name  = ALLTRIM(adr50.np_name)
 m.ul_name  = ALLTRIM(adr50.ul_name)
 m.dom2     = ALLTRIM(adr50.dom)
 m.kor2     = ALLTRIM(adr50.kor)
 m.str2     = ALLTRIM(adr50.str)
 m.kv2      = ALLTRIM(adr50.kv)

 m.c_doc2   = IIF(SEEK(permiss.c_perm,'viddoc'), ALLTRIM(viddoc.name), '')
 m.s_doc2   = ALLTRIM(permiss.s_perm)
 m.n_doc2   = ALLTRIM(permiss.n_perm)
 m.d_doc2   = DTOC(permiss.d_perm)

 m.d_start  = IIF(!EMPTY(permiss.d_perm), DTOC(permiss.d_perm), SPACE(10))
 m.d_stop   = IIF(!EMPTY(dt), DTOC(dt), SPACE(10))

 m.pr_fam = ''
 m.pr_im  = ''
 m.pr_ot  = ''
 m.docpredst = 0
 m.doctypepredst = ''
 m.sdocpredst = ''
 m.ndocpredst = ''
 m.ddocpredst = {}
 m.podrdocpredst = ''

 IF !EMPTY(predst.recid)
  m.pr_fam = predst.fam
  m.pr_im  = predst.im
  m.pr_ot  = predst.ot
  m.docpredst     = predst.c_doc
  m.doctypepredst = IIF(SEEK(m.docpredst,"VidDoc"), ALLTRIM(VidDoc.Name), "")
  m.sdocpredst = predst.s_doc
  m.ndocpredst = predst.n_doc
  m.ddocpredst = predst.d_doc
  m.podrdocpredst = ALLTRIM(predst.podr_doc)

  m.pplfio = m.pr_fam + ' ' + LEFT(m.pr_im,1) + '.' + LEFT(m.pr_ot,1) + '.'
  
 ENDIF 
 
 m.ofam = ''
 m.oim  = ''
 m.oot  = ''
 m.odr  = ''
 m.ow   = 0
 IF !EMPTY(ofio.recid)
  m.ofam = ofio.fam
  m.oim  = ofio.im
  m.oot  = ofio.ot
  m.odr  = DTOC(ofio.dr)
  m.ow   = ofio.w
 ENDIF 

 TRY 
  oWord=GETOBJECT(,"Word.Application")
 CATCH 
  oWord=CREATEOBJECT("Word.Application")
 ENDTRY 
 oDoc = oWord.Documents.Add(dotname)
    
 oDoc.Bookmarks('smo_name').Select  
 oWord.Selection.TypeText(ALLTRIM(m.qname))

* m.fio_paz = ALLTRIM(m.fam) + ' ' + ALLTRIM(m.im) + ' ' + ALLTRIM(m.ot)
 m.fio_paz = IIF(EMPTY(m.pr_fam), ;
  ALLTRIM(m.fam) + ' ' + ALLTRIM(m.im) + ' ' + ALLTRIM(m.ot),; 
  ALLTRIM(m.pr_fam) + ' ' + ALLTRIM(m.pr_im) + ' ' + ALLTRIM(m.pr_ot))
 oDoc.Bookmarks('fio_paz').Select  
 oWord.Selection.TypeText(m.fio_paz)

 oDoc.Bookmarks('vs').Select  
 oWord.Selection.TypeText(m.vs)

 oDoc.Bookmarks('fam').Select  
 oWord.Selection.TypeText(m.fam)

 oDoc.Bookmarks('im').Select  
 oWord.Selection.TypeText(m.im)

 oDoc.Bookmarks('ot').Select  
 oWord.Selection.TypeText(m.ot)
 
 oDoc.Bookmarks('Sex').Select  
 oWord.Selection.TypeText(IIF(m.w=1,"мужской","женский"))

 oDoc.Bookmarks('Dr').Select  
 oWord.Selection.TypeText(m.dr)

 oDoc.Bookmarks('Mr').Select  
 oWord.Selection.TypeText(m.mr)
 
 oDoc.Bookmarks('c_doc').Select  
 oWord.Selection.TypeText(m.viddoc)

 oDoc.Bookmarks('s_doc').Select  
 oWord.Selection.TypeText(m.s_doc)

 oDoc.Bookmarks('n_doc').Select  
 oWord.Selection.TypeText(m.n_doc)

 oDoc.Bookmarks('d_doc').Select  
 oWord.Selection.TypeText(m.d_doc+', выдан '+m.podr_doc)

 oDoc.Bookmarks('gr').Select  
 oWord.Selection.TypeText(m.grname)

 oDoc.Bookmarks('dat_reg').Select  
 oWord.Selection.TypeText(DTOC(m.dat_reg))

 oDoc.Bookmarks('ss').Select  
 oWord.Selection.TypeText(m.ss)

 oDoc.Bookmarks('cont').Select  
 oWord.Selection.TypeText(m.cont)

 oDoc.Bookmarks('dp1').Select  
 oWord.Selection.TypeText(m.dp)

 oDoc.Bookmarks('dp2').Select  
 oWord.Selection.TypeText(m.dp)

 oDoc.Bookmarks('fioinsp').Select  
 oWord.Selection.TypeText(m.fioinsp)

 oDoc.Bookmarks('fampredst').Select  
 oWord.Selection.TypeText(m.pr_fam)

 oDoc.Bookmarks('impredst').Select  
 oWord.Selection.TypeText(m.pr_im)

 oDoc.Bookmarks('otpredst').Select  
 oWord.Selection.TypeText(m.pr_ot)

 oDoc.Bookmarks('doctypepredst').Select  
 oWord.Selection.TypeText(m.doctypepredst)

 oDoc.Bookmarks('s_docpredst').Select  
 oWord.Selection.TypeText(m.sdocpredst)

 oDoc.Bookmarks('n_docpredst').Select  
 oWord.Selection.TypeText(m.ndocpredst)

 oDoc.Bookmarks('d_docpredst').Select  
 oWord.Selection.TypeText(DTOC(m.ddocpredst))

* IF BETWEEN(m.kl,0,27) OR m.kl=45
 IF BETWEEN(m.kl,0,27)
 
  oDoc.Bookmarks('gor').Select  
  oWord.Selection.TypeText('Москва')

  oDoc.Bookmarks('ul').Select  
  oWord.Selection.TypeText(m.ulname)
 
  oDoc.Bookmarks('dom').Select  
  oWord.Selection.TypeText(m.dom)

  oDoc.Bookmarks('korp').Select  
  oWord.Selection.TypeText(IIF(!EMPTY(m.kor), 'корп.'+m.kor,' ')+IIF(!EMPTY(m.str), 'стр.'+m.str,''))

  oDoc.Bookmarks('kv').Select  
  oWord.Selection.TypeText(m.kv)
 
 ELSE 

  oDoc.Bookmarks('obl').Select  
  oWord.Selection.TypeText(m.obl_name)

  oDoc.Bookmarks('rn').Select  
  oWord.Selection.TypeText(m.ra_name)

  oDoc.Bookmarks('gor').Select  
  oWord.Selection.TypeText(IIF(ALLTRIM(m.np_c)='1', ALLTRIM(m.np_name), ''))

  oDoc.Bookmarks('np').Select  
  oWord.Selection.TypeText(IIF(ALLTRIM(m.np_c) != '1', ALLTRIM(m.np_name), ''))

  oDoc.Bookmarks('ul').Select  
  oWord.Selection.TypeText(m.ul_name)
 
  oDoc.Bookmarks('dom').Select  
  oWord.Selection.TypeText(m.dom2)

  oDoc.Bookmarks('korp').Select  
  oWord.Selection.TypeText(IIF(!EMPTY(m.kor2), 'корп.'+m.kor2,' ')+IIF(!EMPTY(m.str2), 'стр.'+m.str2,''))

  oDoc.Bookmarks('kv').Select  
  oWord.Selection.TypeText(m.kv2)

  oDoc.Bookmarks('gor2').Select  
  oWord.Selection.TypeText('Москва')

  oDoc.Bookmarks('ul2').Select  
  oWord.Selection.TypeText(m.ulname)

  oDoc.Bookmarks('dom2').Select  
  oWord.Selection.TypeText(m.dom)

  oDoc.Bookmarks('korp2').Select  
  oWord.Selection.TypeText(IIF(!EMPTY(m.kor), 'корп.'+m.kor,' ')+IIF(!EMPTY(m.str), 'стр.'+m.str,''))

  oDoc.Bookmarks('kv2').Select  
  oWord.Selection.TypeText(m.kv)

 ENDIF 

 oDoc.Bookmarks('c_doc2').Select  
 oWord.Selection.TypeText(m.c_doc2)

 oDoc.Bookmarks('s_doc2').Select  
 oWord.Selection.TypeText(m.s_doc2)

 oDoc.Bookmarks('n_doc2').Select  
 oWord.Selection.TypeText(m.n_doc2)

 oDoc.Bookmarks('d_doc2').Select  
 oWord.Selection.TypeText(m.d_doc2)

 oDoc.Bookmarks('d_start').Select  
 oWord.Selection.TypeText(m.d_start)

 oDoc.Bookmarks('d_stop').Select  
 oWord.Selection.TypeText(m.d_stop)

 oDoc.Bookmarks('pplfio').Select  
 oWord.Selection.TypeText(m.pplfio)

 oDoc.Bookmarks('pplfio2').Select  
 oWord.Selection.TypeText(m.pplfio)

 oDoc.Bookmarks('ofam').Select  
 oWord.Selection.TypeText(m.ofam)

 oDoc.Bookmarks('oim').Select  
 oWord.Selection.TypeText(m.oim)

 oDoc.Bookmarks('oot').Select  
 oWord.Selection.TypeText(m.oot)

 oDoc.Bookmarks('odr').Select  
 oWord.Selection.TypeText(m.odr)

 oDoc.Bookmarks('oSex').Select  
 oWord.Selection.TypeText(IIF(m.ow=1,"мужской","женский"))

 oWord.Visible = .t.
 
RETURN 

