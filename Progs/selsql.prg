PROCEDURE SelSQL
 
m.Fam = ''
m.Im  = ''
m.Ot  = ''
m.dr  = {}
m.snils  = ''
* m.snils  = '029-813-931 77'
 
m.lResponse = .f.
 
DO FORM SelSql TO m.lResponse

m.fam = IIF(OCCURS('*', m.fam)=0, m.fam, STRTRAN(m.fam,'*','')+'%')
m.im  = IIF(OCCURS('*', m.im)=0, m.im, STRTRAN(m.im,'*','')+'%')
m.ot  = IIF(OCCURS('*', m.ot)=0, m.ot, STRTRAN(m.ot,'*','')+'%')

IF m.lResponse = .f.
 RETURN 
ENDIF 
 
 IF EMPTY(m.fam) AND EMPTY(m.im) AND EMPTY(m.ot) AND EMPTY(m.dr) AND EMPTY(m.snils)
  RETURN 
 ENDIF 
 
* IF !EMPTY(m.fam) AND (EMPTY(m.im) OR EMPTY(m.ot) OR EMPTY(m.dr))
 IF !EMPTY(m.fam) AND (EMPTY(m.im) OR EMPTY(m.ot))
*  MESSAGEBOX('Õ≈ «¿œŒÀÕ≈ÕŒ Œƒ»Õ »À» Õ≈— ŒÀ‹ Œ –≈ ¬»«»“Œ¬!',0+64,'')
*  RETURN 
 ENDIF 
* IF !EMPTY(m.im) AND (EMPTY(m.fam) OR EMPTY(m.ot) OR EMPTY(m.dr))
 IF !EMPTY(m.im) AND (EMPTY(m.fam) OR EMPTY(m.ot))
*  MESSAGEBOX('Õ≈ «¿œŒÀÕ≈ÕŒ Œƒ»Õ »À» Õ≈— ŒÀ‹ Œ –≈ ¬»«»“Œ¬!',0+64,'')
*  RETURN 
 ENDIF 
* IF !EMPTY(m.ot) AND (EMPTY(m.fam) OR EMPTY(m.im) OR EMPTY(m.dr))
 IF !EMPTY(m.ot) AND (EMPTY(m.fam) OR EMPTY(m.im))
*  MESSAGEBOX('Õ≈ «¿œŒÀÕ≈ÕŒ Œƒ»Õ »À» Õ≈— ŒÀ‹ Œ –≈ ¬»«»“Œ¬!',0+64,'')
*  RETURN 
 ENDIF 
* IF !EMPTY(m.dr) AND (EMPTY(m.fam) OR EMPTY(m.im) OR EMPTY(m.ot))
* IF !EMPTY(m.dr) AND (EMPTY(m.fam) OR EMPTY(m.im) OR EMPTY(m.ot))
*  MESSAGEBOX('Õ≈ «¿œŒÀÕ≈ÕŒ Œƒ»Õ »À» Õ≈— ŒÀ‹ Œ –≈ ¬»«»“Œ¬!',0+64,'')
*  RETURN 
* ENDIF 
 
 m.indVir = ""

 m.ss_seek  = .f.
 m.fio_seek = .f. 

 IF !EMPTY(m.snils) && œËÓËÚÂÚ —Õ»À—!
  m.ss_seek = .t.
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "a.snils=?m.snils"
  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "snils=?m.snils"
 ELSE 
  m.fio_seek = .t. 

 IF !EMPTY(m.fam)
  m.fam = ALLTRIM(m.fam)
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "left(a.fam,LEN(m.fam)) = m.fam"
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + IIF(OCCURS('%', m.fam)=0, "a.fam=?m.fam", "a.fam like ?m.fam")
  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + IIF(OCCURS('%', m.fam)=0, "fam=?m.fam", "fam like ?m.fam")
 ENDIF 
 IF !EMPTY(m.im)
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "left(a.im,LEN(ALLTRIM(m.im))) = ALLTRIM(m.im)"
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + IIF(OCCURS('%', m.im)=0, "a.im=?m.im", "a.im like ?m.im")
  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + IIF(OCCURS('%', m.im)=0, "im=?m.im", "im like ?m.im")
 ENDIF 
 IF !EMPTY(m.ot)
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "left(a.ot,LEN(ALLTRIM(m.ot))) = ALLTRIM(m.ot)"
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + IIF(OCCURS('%', m.ot)=0, "a.ot=?m.ot", "a.ot like ?m.ot")
  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + IIF(OCCURS('%', m.ot)=0, "ot=?m.ot", "ot like ?m.ot")
 ENDIF 
 IF !EMPTY(m.dr)
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "a.dr=m.dr"
*  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "a.dr=?m.dr"
  m.indVir = m.indVir + IIF(!EMPTY(m.indVir), " AND ", "") + "dr=?m.dr"
 ENDIF 
 
 ENDIF  

WAIT "Œ“¡Œ– ƒ¿ÕÕ€’" WINDOW NOWAIT  

*cmd01= "SELECT a.*, b.*, "
*cmd02= "c.c_okato as c_okato, c.ra_name as ra_name, c.np_c as np_c, c.np_name as np_name, c.ul_c as ul_c, c.ul_name as ul_name, "
*cmd03= "c.dom as dom2, c.kor as kor2, c.str as str2, c.kv as kv2, "
*cmd04= "d.fam as prfam, d.im as prim, d.ot as prot, d.c_doc as prc_doc, d.s_doc as prs_doc, d.n_doc as prn_doc, d.d_doc as prd_doc, "
*cmd05= "d.u_doc as prpodr, d.tel1 as prtel1, d.tel2 as prtel2, d.inf as prpinf, "
*cmd06= "e.enp as enp2, e.ogrn as ogrn_old2, e.okato as okato_old2, e.dp as dp_old2, "
*cmd07= "f.c_doc as oc_doc, f.s_doc as os_doc, f.n_doc as on_doc, f.d_doc as od_doc, f.e_doc as oe_doc, "
*cmd08= "g.fam as ofam, g.im as oim, g.ot as oot, g.w as ow, g.dr as odr, "
*cmd09= "h.ogrn as ogrn_old, h.okato as okato_old, h.dp as dp_old, "
*cmd10= "i.c_perm, i.s_perm, i.n_perm, i.d_perm, i.e_perm, "
*cmd11= "j.c_perm as c_perm2, j.s_perm as s_perm2, j.n_perm as n_perm2, j.d_perm as d_perm2, j.e_perm as e_perm2, "
*cmd12= "k.code as wrkcode, k.name as wrkname "
*cmd13= "FROM kms a "
*cmd14= "LEFT JOIN adr77 b ON a.adr_id=b.recid LEFT JOIN adr50 c ON a.adr50_id=c.recid "
*cmd15= "LEFT JOIN predst d ON a.predstid=d.recid LEFT JOIN enp2 e ON a.enp2id=e.recid "
*cmd16= "LEFT JOIN odoc f ON a.odocid=f.recid LEFT JOIN ofio g ON a.ofioid=g.recid "
*cmd17= "LEFT JOIN osmo h ON a.osmoid=h.recid LEFT JOIN permiss i ON a.permid=i.recid "
*cmd18= "LEFT JOIN permis2 j ON a.perm2id=j.recid LEFT JOIN wrkpl k ON a.wrkid=k.recid "
*cmd19= "WHERE "+m.indvir
 
* CmdAll = cmd01+cmd02+cmd03+cmd04+cmd05+cmd06+cmd07+cmd08+cmd09+cmd10+;
  cmd11+cmd12+cmd13+cmd14+cmd15+cmd16+cmd17+cmd18+cmd19

 CmdAll = "SELECT * FROM kmsview WHERE " + m.indvir
 m.d_beg = SECONDS()
 WAIT "Œ“¡Œ–..." WINDOW NOWAIT 
 IF SQLEXEC(nHandl, CmdAll, "temp") = -1
  WAIT CLEAR 
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SELECT')
  RETURN 
 ELSE 
  DO CASE 
   CASE RECCOUNT('temp')<=0
    MESSAGEBOX('«¿œ»—≈…, ”ƒŒ¬À≈“¬Œ–ﬂﬁŸ»’ «¿ƒ¿ÕÕŒÃ”'+CHR(13)+CHR(10)+' –»“≈–»ﬁ, Õ≈ Œ¡Õ¿–”∆≈ÕŒ!',0+64,'')
   CASE RECCOUNT('temp')=1 && Œ‰ËÌ :-(
   CASE RECCOUNT('temp')>1 && ÃÌÓ„Ó :-)
   OTHERWISE 
  ENDCASE 
 ENDIF 
 m.d_end = SECONDS()
 m.d_last = m.d_end - m.d_beg
 MESSAGEBOX(TRANSFORM(m.d_last,'99999')+' ÒÂÍ.',0+64,'')
 WAIT CLEAR 

 SELECT kms
 ZAP 
 
 SELECT temp

 SCAN 
  SCATTER MEMVAR memo 
*  m.recid = recid_a
  m.isrereg = STR(m.isrereg,1)
  
  m.dr      = FOXData(m.dr)
  m.vs_data = FOXData(m.vs_data)
  m.gz_data = FOXData(m.gz_data)
  m.dp      = FOXData(m.dp)
  m.dt      = FOXData(m.dt)
  m.d_doc   = FOXData(m.d_doc)
  m.e_doc   = FOXData(m.e_doc)
  m.d_reg   = FOXData(m.d_reg)
  m.dpok    = FOXData(m.dpok)
  m.prd_doc = FOXData(m.prd_doc)
  m.dp_old2 = FOXData(m.dp_old2)
  m.od_doc  = FOXData(m.od_doc)
  m.oe_doc  = FOXData(m.oe_doc)
  m.odr     = FOXData(m.odr)
  m.dp_old  = FOXData(m.dp_old)
  m.d_perm  = FOXData(m.d_perm)
  m.e_perm  = FOXData(m.e_perm)
  m.d_perm2 = FOXData(m.d_perm2)
  m.e_perm2 = FOXData(m.e_perm2)
  
  m.u_doc  = ALLTRIM(m.u_doc)
  m.coment = ALLTRIM(m.coment)
  m.kl     = IIF(!ISNULL(m.kl), m.kl, 0)
  m.operpv = IIF(!ISNULL(m.operpv), m.operpv, 0)
  m.isrereg = IIF(!ISNULL(m.isrereg), m.isrereg, '')
  m.plant   = IIF(!ISNULL(m.plant), m.plant, '')
  m.blanc   = IIF(!ISNULL(m.blanc), m.blanc, '')
  m.adr_id = IIF(!ISNULL(m.adr_id), m.adr_id, 0)
  m.adr50_id = IIF(!ISNULL(m.adr50_id), m.adr50_id, 0)
  m.ofioid = IIF(!ISNULL(m.ofioid), m.ofioid, 0)
  m.odocid = IIF(!ISNULL(m.odocid), m.odocid, 0)
  m.osmoid = IIF(!ISNULL(m.osmoid), m.osmoid, 0)
  m.permid = IIF(!ISNULL(m.permid), m.permid, 0)
  m.perm2id = IIF(!ISNULL(m.perm2id), m.perm2id, 0)
  m.enp2id = IIF(!ISNULL(m.enp2id), m.enp2id, 0)
  m.predstid = IIF(!ISNULL(m.predstid), m.predstid, 0)
  m.wrkid = IIF(!ISNULL(m.wrkid), m.wrkid, 0)
  
  m.ul     = IIF(!ISNULL(m.ul), m.ul, 0)
  m.dom    = IIF(!ISNULL(m.dom), m.dom, '')
  m.kor    = IIF(!ISNULL(m.kor), m.kor, '')
  m.str    = IIF(!ISNULL(m.str), m.str, '')
  m.kv     = IIF(!ISNULL(m.kv), m.kv, '')
  
  m.c_okato = IIF(!ISNULL(m.c_okato), m.c_okato, '')
  m.ra_name = IIF(!ISNULL(m.ra_name), m.ra_name, '')
  m.np_c    = IIF(!ISNULL(m.np_c), m.np_c, '')
  m.np_name = IIF(!ISNULL(m.np_name), m.np_name, '')
  m.ul_c    = IIF(!ISNULL(m.ul_c), m.ul_c, '')
  m.ul_name = IIF(!ISNULL(m.ul_name), m.ul_name, '')
  m.dom2    = IIF(!ISNULL(m.dom2), m.dom2, '')
  m.kor2    = IIF(!ISNULL(m.kor2), m.kor2, '')
  m.str2    = IIF(!ISNULL(m.str2), m.str2, '')
  m.kv2     = IIF(!ISNULL(m.kv2), m.kv2, '')

  m.prfam   =  IIF(!ISNULL(m.prfam), m.prfam, '')
  m.prim    =  IIF(!ISNULL(m.prim), m.prim, '')
  m.prot    =  IIF(!ISNULL(m.prot), m.prot, '')
  m.prc_doc =  IIF(!ISNULL(m.prc_doc), m.prc_doc, 0)
  m.prs_doc =  IIF(!ISNULL(m.prs_doc), m.prs_doc, '')
  m.prn_doc =  IIF(!ISNULL(m.prn_doc), m.prn_doc, '')
  m.prd_doc =  IIF(!ISNULL(m.prd_doc), m.prd_doc, {})
  m.prpodr  =  IIF(!ISNULL(m.prpodr), ALLTRIM(m.prpodr), '')
  m.prtel1  =  IIF(!ISNULL(m.prtel1), m.prtel1, '')
  m.prtel2  =  IIF(!ISNULL(m.prtel2), m.prtel2, '')
  m.prpinf  =  IIF(!ISNULL(m.prpinf), m.prpinf, '')
  
  m.enp2       = IIF(!ISNULL(m.enp2), m.enp2, '')
  m.ogrn_old2  = IIF(!ISNULL(m.ogrn_old2), m.ogrn_old2, '')
  m.okato_old2 = IIF(!ISNULL(m.okato_old2), m.okato_old2, '')
  m.dp_old2    = IIF(!ISNULL(m.dp_old2), m.dp_old2, {})

  m.oc_doc = IIF(!ISNULL(m.oc_doc), m.oc_doc, 0)
  m.os_doc = IIF(!ISNULL(m.os_doc), m.os_doc, '')
  m.on_doc = IIF(!ISNULL(m.on_doc), m.on_doc, '')
  m.od_doc = IIF(!ISNULL(m.od_doc), m.od_doc, {})
  m.oe_doc = IIF(!ISNULL(m.oe_doc), m.oe_doc, {})

  m.ofam = IIF(!ISNULL(m.ofam), m.ofam, '')
  m.oim  = IIF(!ISNULL(m.oim), m.oim, '')
  m.oot  = IIF(!ISNULL(m.oot), m.oot, '')
  m.ow   = IIF(!ISNULL(m.ow), m.ow, 0)
  m.odr  = IIF(!ISNULL(m.odr), m.odr, {})
  
  m.ogrn_old  = IIF(!ISNULL(m.ogrn_old), m.ogrn_old, '')
  m.okato_old = IIF(!ISNULL(m.okato_old), m.okato_old, '')
  m.dp_old    = IIF(!ISNULL(m.dp_old), m.dp_old, {})
  
  m.c_perm = IIF(!ISNULL(m.c_perm), m.c_perm, 0)
  m.s_perm = IIF(!ISNULL(m.s_perm), m.s_perm, '')
  m.n_perm = IIF(!ISNULL(m.n_perm), m.n_perm, '')
  m.d_perm = IIF(!ISNULL(m.d_perm), m.d_perm, {})
  m.e_perm = IIF(!ISNULL(m.e_perm), m.e_perm, {})

  m.c_perm2 = IIF(!ISNULL(m.c_perm2), m.c_perm2, 0)
  m.s_perm2 = IIF(!ISNULL(m.s_perm2), m.s_perm2, '')
  m.n_perm2 = IIF(!ISNULL(m.n_perm2), m.n_perm2, '')
  m.d_perm2 = IIF(!ISNULL(m.d_perm2), m.d_perm2, {})
  m.e_perm2 = IIF(!ISNULL(m.e_perm2), m.e_perm2, {})
  
  m.wrkcode = IIF(!ISNULL(m.wrkcode), m.wrkcode, '')
  m.wrkname = IIF(!ISNULL(m.wrkname), m.wrkname, '')
  
*  RELEASE vs_data,gz_data,dp,dt,d_doc,e_doc,d_reg,dpok,prd_doc,dp_old2,od_doc,oe_doc,odr,;
   dp_old,d_perm,e_perm,d_perm2,e_perm2

  INSERT INTO kms FROM MEMVAR 
  INSERT INTO _kms FROM MEMVAR 

  m.fotofile = 'f'+PADL(m.recid,6,'0')+'.jpg'
  IF !fso.FileExists(m.plocal+'\'+m.fotofile)
   IF fso.FileExists(m.pbase+'\jpeg\'+m.fotofile)
    fso.CopyFile(m.pbase+'\jpeg\'+m.fotofile, m.plocal+'\'+m.fotofile, .t.)
   ENDIF 
  ENDIF 
  m.signfile = 's'+PADL(m.recid,6,'0')+'.jpg'
  IF !fso.FileExists(m.plocal+'\'+m.signfile)
   IF fso.FileExists(m.pbase+'\jpeg\'+m.signfile)
    fso.CopyFile(m.pbase+'\jpeg\'+m.signfile, m.plocal+'\'+m.signfile, .t.)
   ENDIF 
  ENDIF   

 ENDSCAN 
 WAIT CLEAR 

* WAIT "Œ“ Àﬁ◊≈Õ»≈ Œ“ ¡ƒ..." WINDOW NOWAIT 
* =SetRelationOff()
* =CloseBases()
 
 ADDPROPERTY(oApp, 'indvir', m.indvir)
* WAIT CLEAR 

 USE IN temp 

 SELECT kms 
 
RETURN 

