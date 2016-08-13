PROCEDURE oo_z_dop
 PRIVATE m.fam, m.im, m.ot,;
  m.ul, m.d, m.kor, m.str, m.kv, m.kl, m.ul_name
 dotname = pTempl + "\z_dop.ott"
 
 m.vs       = vs
 m.Fam      = Fam
 m.Im       = Im
 m.Ot       = Ot
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

 m.Kl      = Kl
 
 m.c_okato = adr50.c_okato
 m.obl_name = IIF(SEEK(m.c_okato, "okato"), ALLTRIM(okato.name), "")
 m.ra_name  = ALLTRIM(adr50.ra_name)
 m.gor_name = ''
 m.np_c     = adr50.np_c
 m.np_name = ALLTRIM(adr50.np_name)
 m.ul_name = ALLTRIM(adr50.ul_name)
 m.dom2    = ALLTRIM(adr50.dom)
 m.kor2    = ALLTRIM(adr50.kor)
 m.str2    = ALLTRIM(adr50.str)
 m.kv2     = ALLTRIM(adr50.kv)

 m.fio2 = ALLTRIM(m.Fam)+' '+ALLTRIM(m.Im)+' '+ALLTRIM(m.Ot)
 m.tel2 = ALLTRIM(cont)

 m.pr_fam = ''
 m.pr_im  = ''
 m.pr_ot  = ''
 m.docpredst = 0
 m.doctypepredst = ''
 m.sdocpredst = ''
 m.ndocpredst = ''
 m.ddocpredst = {}
 m.podrdocpredst = ''
 m.tel1_pr = ''
 m.tel2_pr = ''
 
 m.pplfio = m.fam + ' ' + LEFT(m.im,1) + '.' + LEFT(m.ot,1) + '.'
 
 IF !EMPTY(predst.recid)
  m.pr_fam = ALLTRIM(predst.fam)
  m.pr_im  = ALLTRIM(predst.im)
  m.pr_ot  = ALLTRIM(predst.ot)
  m.docpredst     = predst.c_doc
  m.doctypepredst = IIF(SEEK(m.docpredst,"VidDoc"), ALLTRIM(VidDoc.Name), "")
  m.sdocpredst = predst.s_doc
  m.ndocpredst = predst.n_doc
  m.ddocpredst = predst.d_doc
  m.podrdocpredst = ALLTRIM(predst.podr_doc)

  m.pplfio = m.pr_fam + ' ' + LEFT(m.pr_im,1) + '.' + LEFT(m.pr_ot,1) + '.'

  m.tel1_pr = predst.tel1
  m.tel2_pr = predst.tel1
 ENDIF 

 m.c_doc2   = IIF(SEEK(permiss.c_perm,'viddoc'), ALLTRIM(viddoc.name), '')
 m.s_doc2   = ALLTRIM(permiss.s_perm)
 m.n_doc2   = ALLTRIM(permiss.n_perm)
 m.d_doc2   = DTOC(permiss.d_perm)
 
 m.d_start  = IIF(!EMPTY(permiss.d_perm), DTOC(permiss.d_perm), SPACE(10))
* m.d_stop   = IIF(!EMPTY(dt), DTOC(dt), SPACE(10))
 m.d_stop  = IIF(!EMPTY(permiss.e_perm), DTOC(permiss.e_perm), SPACE(10))

 odoc = OOoOpenfile('&dotname')
   
* m.fio_paz = ALLTRIM(m.fam) + ' ' + ALLTRIM(m.im) + ' ' + ALLTRIM(m.ot)
 m.fio_paz = IIF(EMPTY(m.pr_fam), ;
  ALLTRIM(m.fam) + ' ' + ALLTRIM(m.im) + ' ' + ALLTRIM(m.ot),; 
  ALLTRIM(m.pr_fam) + ' ' + ALLTRIM(m.pr_im) + ' ' + ALLTRIM(m.pr_ot))
 omark = odoc.GetBookMarks.GetByName('fio_paz').GetAnchor
 omark.SetString(ALLTRIM(m.fio_paz))

 omark = odoc.GetBookMarks.GetByName('smo_name').GetAnchor
 omark.SetString(ALLTRIM(m.qname))

 omark = odoc.GetBookMarks.GetByName('vs').GetAnchor
 omark.SetString(ALLTRIM(m.vs))

 omark = odoc.GetBookMarks.GetByName('fam').GetAnchor
 omark.SetString(m.fam)

 omark = odoc.GetBookMarks.GetByName('im').GetAnchor
 omark.SetString(m.im)

 omark = odoc.GetBookMarks.GetByName('ot').GetAnchor
 omark.SetString(m.ot)
 
 omark = odoc.GetBookMarks.GetByName('sex').GetAnchor
 omark.SetString(IIF(m.w=1,"мужской","женский"))

 omark = odoc.GetBookMarks.GetByName('dr').GetAnchor
 omark.SetString(m.dr)

 omark = odoc.GetBookMarks.GetByName('mr').GetAnchor
 omark.SetString(m.mr)
 
 omark = odoc.GetBookMarks.GetByName('c_doc').GetAnchor
 omark.SetString(m.viddoc)

 omark = odoc.GetBookMarks.GetByName('s_doc').GetAnchor
 omark.SetString(m.s_doc)

 omark = odoc.GetBookMarks.GetByName('n_doc').GetAnchor
 omark.SetString(m.n_doc)

 omark = odoc.GetBookMarks.GetByName('d_doc').GetAnchor
 omark.SetString(m.d_doc)

 omark = odoc.GetBookMarks.GetByName('gr').GetAnchor
 omark.SetString(m.grname)

 omark = odoc.GetBookMarks.GetByName('dat_reg').GetAnchor
 omark.SetString(DTOC(m.dat_reg))

 omark = odoc.GetBookMarks.GetByName('ss').GetAnchor
 omark.SetString(m.ss)

 omark = odoc.GetBookMarks.GetByName('cont').GetAnchor
 omark.SetString(m.cont)

 IF BETWEEN(m.kl,0,27) OR m.kl=45
 
  omark = odoc.GetBookMarks.GetByName('gor').GetAnchor
  omark.SetString('Москва')

  omark = odoc.GetBookMarks.GetByName('ul').GetAnchor
  omark.SetString(m.ulname)
 
  omark = odoc.GetBookMarks.GetByName('dom').GetAnchor
  omark.SetString(m.dom)

  omark = odoc.GetBookMarks.GetByName('korp').GetAnchor
  omark.SetString(IIF(!EMPTY(m.kor), 'корп.'+m.kor,' ')+IIF(!EMPTY(m.str), 'стр.'+m.str,''))

  omark = odoc.GetBookMarks.GetByName('kv').GetAnchor
  omark.SetString(m.kv)
 
 ELSE 

  omark = odoc.GetBookMarks.GetByName('obl').GetAnchor
  omark.SetString(m.obl_name)

  omark = odoc.GetBookMarks.GetByName('rn').GetAnchor
  omark.SetString(m.ra_name)

  omark = odoc.GetBookMarks.GetByName('gor').GetAnchor
  omark.SetString(IIF(ALLTRIM(m.np_c)='1', ALLTRIM(m.np_name), ''))

  omark = odoc.GetBookMarks.GetByName('np').GetAnchor
  omark.SetString(IIF(ALLTRIM(m.np_c) != '1', ALLTRIM(m.np_name), ''))

  omark = odoc.GetBookMarks.GetByName('ul').GetAnchor
  omark.SetString(m.ul_name)
 
  omark = odoc.GetBookMarks.GetByName('dom').GetAnchor
  omark.SetString(m.dom2)

  omark = odoc.GetBookMarks.GetByName('korp').GetAnchor
  omark.SetString(IIF(!EMPTY(m.kor2), 'корп.'+m.kor2,' ')+IIF(!EMPTY(m.str2), 'стр.'+m.str2,''))

  omark = odoc.GetBookMarks.GetByName('kv').GetAnchor
  omark.SetString(m.kv2)

  omark = odoc.GetBookMarks.GetByName('gor2').GetAnchor
  omark.SetString('Москва')

  omark = odoc.GetBookMarks.GetByName('ul2').GetAnchor
  omark.SetString(m.ulname)

  omark = odoc.GetBookMarks.GetByName('dom2').GetAnchor
  omark.SetString(m.dom)

  omark = odoc.GetBookMarks.GetByName('korp2').GetAnchor
  omark.SetString(IIF(!EMPTY(m.kor), 'корп.'+m.kor,' ')+IIF(!EMPTY(m.str), 'стр.'+m.str,''))

  omark = odoc.GetBookMarks.GetByName('kv2').GetAnchor
  omark.SetString(m.kv)
 ENDIF 

 omark = odoc.GetBookMarks.GetByName('pr_fam').GetAnchor
 omark.SetString(m.pr_fam)

 omark = odoc.GetBookMarks.GetByName('pr_im').GetAnchor
 omark.SetString(m.pr_im)

 omark = odoc.GetBookMarks.GetByName('pr_ot').GetAnchor
 omark.SetString(m.pr_ot)

 omark = odoc.GetBookMarks.GetByName('doctypepredst').GetAnchor
 omark.SetString(m.doctypepredst)

 omark = odoc.GetBookMarks.GetByName('sdocpredst').GetAnchor
 omark.SetString(m.sdocpredst)

 omark = odoc.GetBookMarks.GetByName('ndocpredst').GetAnchor
 omark.SetString(m.ndocpredst)

 omark = odoc.GetBookMarks.GetByName('ddocpredst').GetAnchor
 omark.SetString(DTOC(m.ddocpredst))

 omark = odoc.GetBookMarks.GetByName('fio2').GetAnchor
 omark.SetString(m.fio2)

 omark = odoc.GetBookMarks.GetByName('tel2').GetAnchor
 omark.SetString(m.tel2)
    
 omark = odoc.GetBookMarks.GetByName('c_doc2').GetAnchor
 omark.SetString(m.c_doc2)

 omark = odoc.GetBookMarks.GetByName('s_doc2').GetAnchor
 omark.SetString(m.s_doc2)

 omark = odoc.GetBookMarks.GetByName('n_doc2').GetAnchor
 omark.SetString(m.n_doc2)

 omark = odoc.GetBookMarks.GetByName('d_doc2').GetAnchor
 omark.SetString(m.d_doc2)

 omark = odoc.GetBookMarks.GetByName('d_start').GetAnchor
 omark.SetString(m.d_start)

 omark = odoc.GetBookMarks.GetByName('d_stop').GetAnchor
 omark.SetString(m.d_stop)

 omark = odoc.GetBookMarks.GetByName('tel1_pr').GetAnchor
 omark.SetString(m.tel1_pr)

 omark = odoc.GetBookMarks.GetByName('tel2_pr').GetAnchor
 omark.SetString(m.tel2_pr)


RETURN 

