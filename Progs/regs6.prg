PROCEDURE RegS6
 IF MESSAGEBOX('ЗАГРУЗИТЬ РЕГИСТР?',4+32,'')=7
  RETURN 
 ENDIF 

 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pBin)
 reestr = GETFILE('dbf','','',0,'Укажите на файл!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(reestr)
  MESSAGEBOX(CHR(13)+CHR(10)+'ВЫ НИЧЕГО НЕ ВЫБРАЛИ!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ENDIF 
 
 IF OpenFile(reestr, 'rr', 'excl')>0
  IF USED('rr')
   USE IN rr
  ENDIF 
  RETURN 
 ENDIF 
 
 IF OpenFile(pcommon+'\country', 'country', 'shar', 'cod')>0
  IF USED('country')
   USE IN country 
  ENDIF 
  USE IN rr
  RETURN 
 ENDIF 
 
 IF OpenFile(pcommon+'\okato', 'okato', 'shar', 'cod_ter')>0
  IF USED('okato')
   USE IN okato
  ENDIF 
  USE IN coutry
  USE IN rr
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\kms','kms','excl', 'recid')>0
  IF USED('kms')
   USE IN kms 
  ENDIF 
  USE IN coutry
  USE IN okato
  USE IN rr 
  RETURN 
 ENDIF 
 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\wrkpl','wrkpl','excl', 'name')>0
  IF USED('wrkpl')
   USE IN wrkpl
  ENDIF 
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\adr77','adr77','excl', 'unik')>0
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\adr50','adr50','excl', 'unik')>0
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\predst','predst','excl', 'fio')>0
  IF USED('predst')
   USE IN predst
  ENDIF 
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\odoc','odoc','excl', 'recid')>0
  IF USED('odoc')
   USE IN odoc
  ENDIF 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\permiss','permiss','excl', 'recid')>0
  IF USED('permiss')
   USE IN permiss
  ENDIF 
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\permis2','permis2','excl', 'recid')>0
  IF USED('permis2')
   USE IN permis2
  ENDIF 
  USE IN permiss
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\ofio','ofio','excl', 'recid')>0
  IF USED('ofio')
   USE IN ofio
  ENDIF 
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\moves','moves','excl', 'recid')>0
  IF USED('moves')
   USE IN moves
  ENDIF 
  USE IN ofio
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pcommon+'\kladr', 'kladr', 'shar', 'kladr')>0
  IF USED('kladr')
   USE IN kladr 
  ENDIF 
  USE IN ofio 
  USE IN moves
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pcommon+'\viddoc', 'viddoc', 'excl', 'code')>0
  IF USED('viddoc')
   USE IN viddoc
  ENDIF 
  USE IN kladr
  USE IN ofio 
  USE IN moves
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\enp2', 'enp2', 'excl', 'enp')>0
  IF USED('enp2')
   USE IN enp2
  ENDIF 
  USE IN kladr
  USE IN ofio 
  USE IN moves
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pcommon+'\outs', 'outs', 'excl', 'enp')>0
  IF USED('outs')
   USE IN outs
  ENDIF 
  USE IN kladr
  USE IN ofio 
  USE IN moves
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pcommon+'\sprlpuxx', 'sprlpu', 'shar', 'lpu_id')>0
  IF USED('sprlpu')
   USE IN sprlpu
  ENDIF 
  USE IN outs
  USE IN kladr
  USE IN ofio 
  USE IN moves
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\user', 'userr', 'excl')>0
  IF USED('userr')
   USE IN userr 
  ENDIF 
  USE IN sprlpu
  USE IN outs
  USE IN kladr
  USE IN ofio 
  USE IN moves
  USE IN permiss
  USE IN permis2
  USE IN odoc 
  USE IN predst
  USE IN adr50
  USE IN adr77
  USE IN country
  USE IN okato
  USE IN kms 
  USE IN rr 
  RETURN 
 ENDIF 

 SELECT wrkpl
 ZAP 
 SELECT adr77
 ZAP 
 SELECT adr50
 ZAP 
 SELECT predst
 ZAP 
 SELECT odoc
 ZAP 
 SELECT permiss
 ZAP
 SELECT permis2
 ZAP
 SELECT ofio
 ZAP 
 SELECT moves 
 ZAP 
 SELECT viddoc
 ZAP 
 SELECT enp2
 ZAP 
 SELECT userr
* ZAP
* INSERT INTO userr (pv, id, fam, im, ot, kadr) VALUES ;
  (pvid(1,1), '', 'Администратор', '', '', 1)
 INDEX on fam+im+ot TAG fio 
 SET ORDER TO fio 
 SELECT kms 
 SET RELATION TO permid INTO permiss 

 CREATE CURSOR curunid (unid i, recid i)
 INDEX on unid TAG unid 
 SET ORDER TO unid
 SELECT rr 
 WAIT "Обработка..." WINDOW NOWAIT 
 SCAN
  RELEASE ALL  
  m.unid = INT(VAL(ALLTRIM(f_001)))
  m.odocid = 0 
  m.permid = 0 
  m.ofioid = 0
  m.dt = {}
  m.jt = ''
  m.scn = ''
  m.vs = ''
  
  IF SEEK(m.unid, 'curunid')
   m.rrid = curunid.recid
   =SEEK(m.rrid, 'kms')

   DO CASE 
    CASE EMPTY(f_094)
    
    CASE f_094 = 'Временное свидет'
     IF CTOD(ALLTRIM(f_097))>kms.vs_data
      m.vs      = ALLTRIM(f_096)
      m.vs_data = IIF(!EMPTY(ALLTRIM(f_097)), CTOD(ALLTRIM(f_097)), CTOD(ALLTRIM(f_070)))
      m.dp = IIF(EMPTY(kms.dp), m.vs_data, kms.dp)
*      m.sn_card = 'S6'+ALLTRIM(f_081)+' '+m.vs
*      UPDATE kms SET vs=m.vs, sn_card=m.sn_card, vs_data=m.vs_data WHERE recid=m.rrid
      UPDATE kms SET vs=m.vs, vs_data=m.vs_data, dp=m.dp WHERE recid=m.rrid
     ENDIF 

    CASE f_094 = 'Полис ОМС единог'
     IF CTOD(ALLTRIM(f_098))>kms.dt
      m.dt = CTOD(ALLTRIM(f_098))
      UPDATE kms SET dt=m.dt WHERE recid=m.rrid
     ENDIF 
     IF !EMPTY(ALLTRIM(f_097)) AND CTOD(ALLTRIM(f_097))>kms.dp
      m.dp = CTOD(ALLTRIM(f_097))
      m.jt = 'r'
      m.scn = 'POK'
      UPDATE kms SET dp=m.dp, jt=m.jt,scn=m.scn WHERE recid=m.rrid
     ENDIF 

   ENDCASE 

   IF !INLIST(INT(VAL(f_015)),11,23,25) AND (ALLTRIM(f_018)!=ALLTRIM(kms.n_doc)) 
    m.nc_doc = INT(VAL(f_015))
    m.ns_doc = ALLTRIM(f_017)
    m.nn_doc = ALLTRIM(f_018)
    m.nd_doc = CTOD(ALLTRIM(f_020))
    IF kms.d_doc>CTOD(ALLTRIM(f_020))
     INSERT INTO odoc (c_doc,s_doc,n_doc,d_doc) VALUES (m.nc_doc,m.ns_doc,m.nn_doc,m.nd_doc)
     m.odocid = GETAUTOINCVALUE()
     UPDATE kms SET odocid=m.odocid WHERE recid=m.rrid
    ELSE 
     m.oc_doc = kms.c_doc
     m.os_doc = kms.s_doc
     m.on_doc = kms.n_doc
     m.od_doc = kms.d_doc
     INSERT INTO odoc (c_doc,s_doc,n_doc,d_doc) VALUES (m.oc_doc,m.os_doc,m.on_doc,m.od_doc)
     m.odocid = GETAUTOINCVALUE()
     UPDATE kms SET c_doc=m.nc_doc, s_doc=m.ns_doc,n_doc=m.nn_doc,d_doc=m.nd_doc WHERE recid=m.rrid
     UPDATE kms SET odocid=m.odocid WHERE recid=m.rrid
    ENDIF 
   ENDIF 
   
   m.c_t = PADL(INT(VAL(ALLTRIM(f_030))),3,'0')
   IF m.c_t='077' AND kms.adr_id=0
    m.kladr  = INT(VAL(ALLTRIM(f_040)))
    m.ul = IIF(SEEK(m.kladr, 'kladr'), kladr.foms, 0)
    m.d   = PADR(ALLTRIM(f_042),7)
    m.kor = PADR(ALLTRIM(f_043),5)
    m.str = PADR(ALLTRIM(f_044),5)
    m.kv  = PADR(ALLTRIM(f_045),5)

    m.unik = PADL(m.ul,5,'0') + m.d + m.kor + m.str + m.kv

    IF !SEEK(m.unik, 'adr77', 'unik')
     INSERT INTO adr77 (ul,d,kor,str,kv) VALUES ;
      (m.ul,m.d,m.kor,m.str,m.kv)
     m.adr_id = GETAUTOINCVALUE()
    ELSE 
     m.adr_id = adr77.recid
    ENDIF 
    UPDATE kms SET adr_id=m.adr_id WHERE recid=m.rrid

   ENDIF 

   IF m.c_t!='077' AND kms.adr50_id=0
    m.c_okato = IIF(SEEK(m.c_t, 'okato'), okato.code, '45000')
    m.ra_name = ALLTRIM(f_033)
    m.np_c    = IIF(!EMPTY(ALLTRIM(f_035)), '1', '9')
    m.np_name = IIF(!EMPTY(ALLTRIM(f_035)), ALLTRIM(f_035), ALLTRIM(f_038))
    m.ul_c    = '17'
    m.ul_name = ALLTRIM(f_041)
    m.dom = PADR(ALLTRIM(f_042),7)
    m.kor = PADR(ALLTRIM(f_043),5)
    m.str = PADR(ALLTRIM(f_044),5)
    m.kv  = PADR(ALLTRIM(f_045),5)

    m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom+m.kor+m.str+m.kv

    IF !SEEK(m.unik, 'adr50', 'unik')
     INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
      (m.c_okato, m.ra_name, m.np_c, m.np_name, m.ul_c, m.ul_name, m.dom, m.kor, m.str, m.kv)
     m.adr50_id = GETAUTOINCVALUE()
    ELSE 
     m.adr50_id = adr50.recid
    ENDIF 
    UPDATE kms SET adr50_id=m.adr50_id WHERE recid=m.rrid

   ENDIF 
   
   IF PROPER(ALLTRIM(f_003))!=ALLTRIM(kms.fam) AND EMPTY(ofioid)
    m.fam = PROPER(ALLTRIM(f_003))
    m.im  = PROPER(ALLTRIM(f_004))
    m.ot  = PROPER(ALLTRIM(f_005))
    m.dr = CTOD(ALLTRIM(f_006))
    m.w = IIF(ALLTRIM(f_008)='Мужской',1,2)
    
    INSERT INTO ofio (fam,im,ot,w,dr) VALUES (m.fam,m.im,m.ot,m.w,m.dr)
    m.ofioid = GETAUTOINCVALUE()
    UPDATE kms SET ofioid=m.ofioid WHERE recid=m.rrid
    
   ENDIF 

   IF INLIST(INT(VAL(f_015)),11,23,25) AND EMPTY(permid)
    m.c_perm = INT(VAL(f_015))
    m.s_perm = f_017
    m.n_perm = f_018
    m.d_perm = CTOD(ALLTRIM(f_022))
    m.e_perm = CTOD(ALLTRIM(f_023))
    m.sn_perm = m.s_perm+m.n_perm
    IF !SEEK(m.sn_perm, 'permiss', 'sn_perm')
     INSERT INTO permiss (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES ;
     (m.c_perm,m.s_perm,m.n_perm,m.d_perm,m.e_perm) 
     m.permid = GETAUTOINCVALUE()
    ELSE 
     m.permid = permiss.recid
    ENDIF 
    UPDATE kms SET permid=m.permid WHERE recid=m.rrid
   ENDIF 

   IF INLIST(INT(VAL(f_015)),11,23,25) AND (ALLTRIM(f_018)!=ALLTRIM(permiss.n_perm)) 
    m.c_perm = INT(VAL(f_015))
    m.s_perm = f_017
    m.n_perm = f_018
    m.d_perm = CTOD(ALLTRIM(f_022))
    m.e_perm = CTOD(ALLTRIM(f_023))
    IF permiss.d_perm>CTOD(ALLTRIM(f_022))
     INSERT INTO permis2 (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES ;
     (m.c_perm,m.s_perm,m.n_perm,m.d_perm,m.e_perm) 
     m.perm2id = GETAUTOINCVALUE()
     UPDATE kms SET perm2id=m.perm2id WHERE recid=m.rrid
    ELSE 
     m.oc_perm = permiss.c_perm
     m.os_perm = permiss.s_perm
     m.on_perm = permiss.n_perm
     m.od_perm = permiss.d_perm
     m.oe_perm = permiss.e_perm
     INSERT INTO permis2 (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES ;
     (m.oc_perm,m.os_perm,m.on_perm,m.od_perm,m.oe_perm) 
     m.perm2id = GETAUTOINCVALUE()
     UPDATE kms SET perm2id=m.perm2id WHERE recid=m.rrid
     INSERT INTO permiss (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES ;
     (m.c_perm,m.s_perm,m.n_perm,m.d_perm,m.e_perm) 
     m.permid = GETAUTOINCVALUE()
     UPDATE kms SET permid=m.permid WHERE recid=m.rrid
    ENDIF 
   ENDIF 

   IF CTOD(ALLTRIM(f_108))>kms.gz_data
    m.nz = ALLTRIM(f_107)
    m.gz_data = CTOD(ALLTRIM(f_108))
    m.dp = IIF(EMPTY(kms.dp), m.gz_data, kms.dp)
    UPDATE kms SET nz=m.nz, gz_data=m.gz_data, dp=m.dp WHERE recid=m.rrid
   ENDIF 

   LOOP 
  ENDIF 
  
  IF !EMPTY(ALLTRIM(f_051))

   m.predst   = IIF(!EMPTY(ALLTRIM(f_049)), ALLTRIM(f_049), '3')
   m.fam      = ALLTRIM(f_051)
   m.im       = ALLTRIM(f_052)
   m.ot       = ALLTRIM(f_053)
   m.dr       = CTOD(ALLTRIM(f_054))
   m.c_doc    = INT(VAL(f_055))
   m.s_doc    = ALLTRIM(f_057)
   m.n_doc    = ALLTRIM(f_058)
   m.d_doc    = CTOD(ALLTRIM(f_060))
   m.podr_doc = ALLTRIM(f_059)
   m.tel1     = ALLTRIM(f_067)
   m.tel2     = ALLTRIM(f_068)

   m.fio = LEFT(m.fam,25) + LEFT(m.im,3) + LEFT(m.ot,3)
   IF SEEK(m.fio, 'predst', 'fio')
    m.predstid = predst.recid
   ELSE 
    INSERT INTO Predst (Fam, Im, Ot, c_doc, s_doc, n_doc, d_doc, podr_doc) VALUES ;
    (m.fam, m.im, m.ot,m.c_doc, m.s_doc, m.n_doc, m.d_doc, m.podr_doc)
    m.predstid = GETAUTOINCVALUE()
   ENDIF 
  ELSE  
   m.predst = ''
   m.predstid = 0 
  ENDIF 

  m.nz = ALLTRIM(f_107)
  m.gz_data = CTOD(ALLTRIM(f_108))
  m.dp = IIF(EMPTY(kms.dp), m.gz_data, kms.dp)
  
  IF f_094 = 'Временное свидет'
   m.vs      = ALLTRIM(f_096)
   m.vs_data = IIF(!EMPTY(ALLTRIM(f_097)), CTOD(ALLTRIM(f_097)), CTOD(ALLTRIM(f_070)))
*   m.vs_data = CTOD(ALLTRIM(f_097))
   m.dp = IIF(EMPTY(kms.dp), m.vs_data, kms.dp)
*   m.sn_card = 'S6'+ALLTRIM(f_081)+' '+m.vs
  ENDIF 
  m.pv = ALLTRIM(f_081)
  m.enp = f_002
  IF f_094 = 'Полис ОМС единог'
   m.dt = CTOD(ALLTRIM(f_098))
   IF !EMPTY(ALLTRIM(f_097))
    m.dp = CTOD(ALLTRIM(f_097))
    m.jt = 'r'
    m.scn = 'POK'
   ENDIF 
  ENDIF 
  m.fam = PROPER(ALLTRIM(f_003))
  m.im  = PROPER(ALLTRIM(f_004))
  m.ot  = PROPER(ALLTRIM(f_005))
  m.dr = CTOD(ALLTRIM(f_006))
  m.true_dr = INT(VAL(f_007))
  m.w = IIF(ALLTRIM(f_008)='Мужской',1,2)
  m.cont = IIF(!EMPTY(f_047), ALLTRIM(f_047), ALLTRIM(f_046))
  IF !INLIST(INT(VAL(f_015)),11,23,25)
   m.c_doc = INT(VAL(f_015))
   m.s_doc = ALLTRIM(f_017)
   m.n_doc = ALLTRIM(f_018)
   m.d_doc = CTOD(ALLTRIM(f_020))
   m.podr_doc = ALLTRIM(f_019)
  ENDIF 
  m.ss = f_011
  m.codgr = PADL(ALLTRIM(f_013),3,'0')
  m.gr = IIF(SEEK(m.codgr, 'country'), country.code, 'RUS')
  m.dat_reg = CTOD(ALLTRIM(f_025))
  m.mr = ALLTRIM(f_066)
  m.spos = INT(VAL(ALLTRIM(f_071)))
  m.form = INT(VAL(f_075))
  m.status = 5
  m.dp = IIF(!EMPTY(ALLTRIM(f_097)), CTOD(ALLTRIM(f_097)),CTOD(ALLTRIM(f_070)))
  
  m.wrkcode = f_009
  m.wrkname = f_010
  IF !SEEK(m.wrkname, 'wrkpl')
   INSERT INTO wrkpl (code,name) VALUES (m.wrkcode,m.wrkname)
   m.wrkid = GETAUTOINCVALUE()
  ELSE 
   m.wrkid = wrkpl.recid
  ENDIF 
  
  m.c_t = PADL(INT(VAL(ALLTRIM(f_030))),3,'0')
  
  IF m.c_t='077'
   m.kladr  = INT(VAL(ALLTRIM(f_040)))
   m.ul = IIF(SEEK(m.kladr, 'kladr'), kladr.foms, 0)
   m.d   = PADR(ALLTRIM(f_042),7)
   m.kor = PADR(ALLTRIM(f_043),5)
   m.str = PADR(ALLTRIM(f_044),5)
   m.kv  = PADR(ALLTRIM(f_045),5)

   m.unik = PADL(m.ul,5,'0') + m.d + m.kor + m.str + m.kv

   IF !SEEK(m.unik, 'adr77', 'unik')
    INSERT INTO adr77 (ul,d,kor,str,kv) VALUES ;
     (m.ul,m.d,m.kor,m.str,m.kv)
    m.adr_id = GETAUTOINCVALUE()
   ELSE 
    m.adr_id = adr77.recid
   ENDIF 
   m.adr50_id = 0

  ELSE 
   
   m.c_okato = IIF(SEEK(m.c_t, 'okato'), okato.code, '45000')
   m.ra_name = ALLTRIM(f_033)
   m.np_c    = IIF(!EMPTY(ALLTRIM(f_035)), '1', '9')
   m.np_name = IIF(!EMPTY(ALLTRIM(f_035)), ALLTRIM(f_035), ALLTRIM(f_038))
   m.ul_c    = '17'
   m.ul_name = ALLTRIM(f_041)
   m.dom = PADR(ALLTRIM(f_042),7)
   m.kor = PADR(ALLTRIM(f_043),5)
   m.str = PADR(ALLTRIM(f_044),5)
   m.kv  = PADR(ALLTRIM(f_045),5)

   m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom+m.kor+m.str+m.kv

   IF !SEEK(m.unik, 'adr50', 'unik')
    INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
     (m.c_okato, m.ra_name, m.np_c, m.np_name, m.ul_c, m.ul_name, m.dom, m.kor, m.str, m.kv)
    m.adr50_id = GETAUTOINCVALUE()
   ELSE 
    m.adr50_id = adr50.recid
   ENDIF 
   m.adr_id = 0

  ENDIF 
  
  IF INLIST(INT(VAL(f_015)),11,23,25)
   m.c_perm = INT(VAL(f_015))
   m.s_perm = f_017
   m.n_perm = f_018
   m.d_perm = CTOD(ALLTRIM(f_022))
   m.e_perm = CTOD(ALLTRIM(f_023))
   m.sn_perm = m.s_perm+m.n_perm
   IF !SEEK(m.sn_perm, 'permiss', 'sn_perm')
    INSERT INTO permiss (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES ;
    (m.c_perm,m.s_perm,m.n_perm,m.d_perm,m.e_perm) 
    m.permid = GETAUTOINCVALUE()
   ELSE 
    m.permid = permiss.recid
   ENDIF 
  ENDIF 
  
  m.para001 = INT(VAL(f_015))
  m.para002 = ALLTRIM(f_016)
  IF m.para001>0 AND !SEEK(m.para001, 'viddoc')
   INSERT INTO viddoc (code, name) VALUES (m.para001, m.para002)
  ENDIF 
  RELEASE para001,para002

  IF !EMPTY(f_077)
   m.jtt = f_077
   DO CASE 
    CASE m.jtt = '1'
     m.jt = 'k'
    CASE m.jtt = '2'
     m.jt = '4'
    CASE m.jtt = '3'
     m.jt = 'b'
    CASE m.jtt = '4'
     m.jt = '3'
    CASE m.jtt = '5'
     m.jt = 'd'
    CASE m.jtt = '6'
     m.jt = '4'
    OTHERWISE 
     m.jt = ''
   ENDCASE 
  ELSE 
   m.jtt = f_073
   DO CASE 
    CASE m.jtt = '1'
     m.jt = '1'
    CASE m.jtt = '2'
     m.jt = 'z'
    CASE m.jtt = '3'
     m.jt = '2'
    OTHERWISE 
     m.jt = ''
   ENDCASE 
   
  ENDIF 
  
  IF EMPTY(m.vs)
   LOOP 
  ENDIF 

  m.sn_card = IIF(SEEK(m.enp, 'outs'), outs.s_card+' '+PADL(outs.n_card,10,'0'), '')
  m.vs = IIF(VARTYPE(m.vs)='C', m.vs, '')
  m.vs = IIF(SEEK(m.enp, 'outs'), IIF(!EMPTY(outs.vsn), outs.vsn, m.vs), m.vs)
  m.lpuid = IIF(SEEK(m.enp, 'outs'), outs.lpu_id, 0)
  m.mcod = IIF(SEEK(m.lpuid, 'sprlpu'), sprlpu.mcod, '')

  m.f079 = ALLTRIM(f_079)
  m.ffam = PROPER(SUBSTR(m.f079,1,AT(' ',m.f079,1)-1))
  m.fim  = PROPER(SUBSTR(m.f079,AT(' ',m.f079)+1,AT(' ',m.f079,2)-AT(' ',m.f079,1)-1))
  m.fot  = PROPER(SUBSTR(m.f079,AT(' ',m.f079,2)+1))
  m.kadr = 1
  m.ffio = PADR(m.ffam,25)+PADR(m.fim,20)+PADR(m.fot,20)
  
  IF !EMPTY(ALLTRIM(m.ffio)) AND !SEEK(m.ffio, 'userr')
   RELEASE ucod 
   INSERT INTO userr (fam,im,ot,kadr) VALUES (m.ffam,m.fim,m.fot,m.kadr)
   m.oper = GETAUTOINCVALUE()
  ELSE 
   m.oper = userr.ucod
  ENDIF 

  INSERT INTO kms FROM MEMVAR 
  m.recid = GETAUTOINCVALUE()
  INSERT INTO curunid FROM MEMVAR 
  RELEASE recid
 
 ENDSCAN 
 SET RELATION OFF INTO permiss
 WAIT CLEAR 
 
 WAIT "Расчет kl..." WINDOW NOWAIT 
 SELECT kms
 SET RELATION TO permid INTO permiss 
 SCAN 
  m.kl = 0 
  IF gr='RUS'
   IF EMPTY(adr50_id)
    m.kl = 0
   ELSE 
    m.kl = 77
   ENDIF 
  ELSE 
   DO CASE 
    CASE permiss.c_perm = 11
     m.kl = 45
    CASE permiss.c_perm = 23
     m.kl = 99
    CASE permiss.c_perm = 25 OR c_doc = 12
     m.kl = 73
    OTHERWISE 
   ENDCASE 
  ENDIF 
  REPLACE kl WITH m.kl
 ENDSCAN 
 SET RELATION OFF INTO permiss 
 WAIT CLEAR 
 
 WAIT "ЗАПОЛНЕНИЕ ИСТОРИИ..." WINDOW NOWAIT 
 CREATE CURSOR visits (visit c(10))
 INDEX on visit TAG visit 
 SET ORDER TO visit 
 SET ORDER TO enp IN kms 
 SELECT rr
 
 SCAN 
  m.visit = f_069
  IF EMPTY(m.visit)
   LOOP 
  ENDIF 
  m.enp = f_002
  IF EMPTY(m.enp)
   LOOP 
  ENDIF 
  IF !SEEK(m.enp, 'kms')
   LOOP 
  ENDIF 
  IF !SEEK(m.visit, 'visits')
   INSERT INTO visits (visit) VALUES (m.visit)
  ELSE 
   LOOP 
  ENDIF 
  
  m.kmsid = kms.recid
  m.frecid = PADL(m.kmsid,6,'0')
  m.dp = CTOD(ALLTRIM(f_070))

  IF f_094='Временное свидет'
   m.vs = ALLTRIM(f_096)
  ELSE 
   m.vs = ''
  ENDIF 
  
  IF !EMPTY(f_077)
   m.jtt = f_077
   DO CASE 
    CASE m.jtt = '1'
     m.jt = 'k'
    CASE m.jtt = '2'
     m.jt = '4'
    CASE m.jtt = '3'
     m.jt = 'b'
    CASE m.jtt = '4'
     m.jt = '3'
    CASE m.jtt = '5'
     m.jt = 'd'
    CASE m.jtt = '6'
     m.jt = '4'
    OTHERWISE 
     m.jt = ''
   ENDCASE 
  ELSE 
   m.jtt = f_073
   DO CASE 
    CASE m.jtt = '1'
     m.jt = '1'
    CASE m.jtt = '2'
     m.jt = 'z'
    CASE m.jtt = '3'
     m.jt = '2'
    OTHERWISE 
     m.jt = ''
   ENDCASE 
   
  ENDIF 
  
  INSERT INTO moves (kmsid,frecid,dp,vs,jt) VALUES (m.kmsid,m.frecid,m.dp,m.vs,m.jt)
 
 ENDSCAN 

 USE IN visits
 WAIT CLEAR 
 
 SELECT viddoc
 COPY TO &pcommon\tviddoc
 ZAP
 APPEND FROM &pcommon\tviddoc
 fso.DeleteFile(pcommon+'\tviddoc.dbf')
 USE IN viddoc
 USE IN country 
 USE IN okato 
 USE IN rr
 USE IN kms 
 USE IN wrkpl
 USE IN adr77
 USE IN adr50
 USE IN predst 
 USE IN odoc 
 USE IN permiss
 USE IN permis2
 USE IN kladr 
 USE IN ofio
 USE IN moves 
 USE IN curunid
 USE IN enp2
 USE IN outs
 USE IN sprlpu
 SELECT userr
 DELETE TAG fio 
 USE IN userr
 
* SELECT curunid
* COPY TO d:\s6\curunid
 
RETURN 