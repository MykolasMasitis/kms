PROCEDURE MakeOneKms
 
* setdel = SET("Deleted")
* MESSAGEBOX(setdel,0+64,'')
* RETURN 
 
 IF MESSAGEBOX('ÂÛ ÕÎÒÈÒÅ ÑÎÁÐÀÒÜ ÅÄÈÍÛÉ ÔÀÉË?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF !fso.FolderExists(pbase)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÄÈÐÅÊÒÎÐÈß'+CHR(13)+CHR(10)+UPPER(pbase)+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\adr50.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\ADR50.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\adr77.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\ADR77.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\answers.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\ANSWERS.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\e_ffoms.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\E_FFOMS.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\enp2.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\ENP2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\error.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\ERROR.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\kms.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\KMS.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\moves.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\MOVES.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\odoc.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\ODOC.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\ofio.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\OFIO.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\osmo.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\OSMO.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\permiss.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\PERMISS.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\permis2.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\PERMIS2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\predst.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\PREDST.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbin)+'\PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 IF OpFiles()>0
  =ClFiles()
 ENDIF 

 CREATE CURSOR curpv (pv c(3), recsinpv n(6), recsproc n(6))
 INDEX on pv TAG pv 
 SET ORDER TO pv 
 SELECT pvp2
 SCAN 
  IF tip_pv=2
   LOOP 
  ENDIF 
  
  m.codpv = codpv
  INSERT INTO curpv (pv,recsinpv,recsproc) VALUES (m.codpv,0,0)
  
  =AppOnePv(m.codpv)
  
 ENDSCAN 
 USE IN pvp2

 =ClFiles()

 SELECT curpv
 COPY TO &pbase\convresults
 BROWSE 
 USE 

 MESSAGEBOX('ÎÁÐÀÁÎÒÊÀ ÇÀÊÎÍ×ÅÍÀ!'+CHR(13)+CHR(10),0+64,'')

RETURN 

FUNCTION AppOnePv(para1)
 PRIVATE m.codpv
 m.codpv = para1
 
 IF !fso.FolderExists(pbase+'\'+m.codpv)
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\kms.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\KMS.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\adr50.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\ADR50.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\adr77.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\ADR77.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\answers.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\ANSWERS.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pBase\&codpv\Answers ;
   (recid c(6), "data" d, tiperz c(15), sn_pol c(17), enp c(16), s_card c(6), n_card n(10), ;
    date_b d, date_e d, q c(2), q_ogrn c(13), fam c(25), im c(25), ot c(25), dr c(8),;
    w n(1,0), ans_r c(3), snils c(14), doc_type c(2), doc_ser c(12), doc_num c(16), ;
    doc_date d, gr c(3), erz c(1), tip_d c(1), okato c(5), npp n(2), err c(150))
  INDEX ON INT(VAL(recid)) TAG recid
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\e_ffoms.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\E_FFOMS.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pbase\&codpv\e_ffoms (rid i, recid i, "data" d, err c(5), "comment" c(250), ;
   c_t c(5), pid c(16), ans_fl c(2), "step" c(4), dcor d, v l)
  INDEX ON recid TAG recid
  INDEX ON rid TAG rid CANDIDATE 
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\enp2.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\ENP2.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pbase\&codpv\enp2 (recid i AUTOINC, enp c(16), ogrn c(13), okato c(5), dp d)
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON enp TAG enp 
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\error.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\ERROR.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pbase\&codpv)\error ;
   (rid i, rec_id c(6), s_card c(6), n_card n(10), n_date d, q c(2), err c(2), err_text c(40), app_d d, ;
    v l, dcor d)
  INDEX ON rec_id TAG rec_id
  INDEX ON rid TAG rid CANDIDATE 
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\moves.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\MOVES.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pBase\&codpv\moves (et c(1), recid i autoinc, fname c(25), mkdate t, kmsid i, frecid c(6), ;
   vs c(9), s_card c(6), n_card n(10), c_okato c(5), enp c(16), dp d, jt c(1), ;
   pricin c(3), tranz c(3), q c(2), err c(5), err_text c(250), ans_fl c(2), nz n(3), n_kor n(6))
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON kmsid TAG kmsid
  INDEX FOR et='1' ON kmsid TAG fiorecid
  INDEX FOR et='2' ON kmsid TAG ffrecid
  INDEX ON fname+frecid TAG unik
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\odoc.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\ODOC.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pbase\&codpv\odoc (recid i AUTOINC, c_doc n(2), s_doc c(9), n_doc c(8), d_doc d)
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\ofio.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\OFIO.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pbase\&codpv\ofio (recid i AUTOINC, fam c(40), im c(40), ot c(40), dr d, w n(1))
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\osmo.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\OSMO.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pbase\&codpv\osmo (recid i AUTOINC, ogrn c(13), okato c(5), dp d)
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\permiss.dbf')
  CREATE TABLE &pbase\&codpv\permiss (recid i AUTOINC, c_perm n(2), s_perm c(9), n_perm c(8), d_perm d, e_perm d)
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON s_perm+n_perm TAG sn_perm
  USE 
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\PERMISS.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\permis2.dbf')
  CREATE TABLE &pbase\&codpv\permis2 (recid i AUTOINC, c_perm n(2), s_perm c(9), n_perm c(8), d_perm d, e_perm d)
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON s_perm+n_perm TAG sn_perm
  USE 
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\PERMISS.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
 ENDIF 
 IF !fso.FileExists(pbase+'\'+m.codpv+'\predst.dbf')
*  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË'+CHR(13)+CHR(10)+UPPER(pbase)+'\'+m.codpv+'\PREDST.DBF'+CHR(13)+CHR(10),0+16,'')
*  RETURN 
  CREATE TABLE &pBase\&codpv\predst ;
   (RecId i AUTOINC NEXTVALUE 1 STEP 1, KmsId i, Fam c(40), Im c(40), Ot c(40), ;
    c_doc n(2), s_doc c(9), n_doc c(8), d_doc d, podr_doc c(100), tel1 c(10), tel2 c(10), ;
    inf c(100) )
  INDEX ON recid TAG recid CANDIDATE 
  INDEX on KmsId TAG KmsId
  USE 
 ENDIF 

 IF OpFilesPv(m.codpv)>0
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÏÓÍÊÒ '+m.codpv+' ÏÐÎÏÓÙÅÍ!',0+64,'')
  SELECT pvp2
  RETURN 
 ENDIF 
 
 SELECT kmspv
 IF FIELD('adr_id')!='ADR_ID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ ADR_ID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('adr50_id')!='ADR50_ID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ ADR50_ID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('enp2id')!='ENP2ID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ ENP2ID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('permid')!='PERMID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ PERMID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('perm2id')!='PERM2ID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ PERM2ID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('ofioid')!='OFIOID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ OFIOID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('odocid')!='ODOCID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ ODOCID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 IF FIELD('osmoid')!='OSMOID'
  =ClFilesPv(m.codpv)
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÏÎËÅ OSMOID!'+CHR(13)+CHR(10),0+16,m.codpv)
  RETURN 
 ENDIF 
 
 CREATE CURSOR currid (orid i, nrid i)
 INDEX ON orid TAG orid
 SET ORDER TO orid 

 WAIT m.codpv WINDOW NOWAIT 
 SELECT predst
 IF FIELD('kmsid')='KMSID'
  SET ORDER TO kmsid
 ELSE
  SET ORDER TO recid 
 ENDIF 
 
 SELECT kmspv
 IF FIELD('predstid')='PREDSTID'
  SET RELATION TO predstid INTO predstpv 
 ELSE 
  SET RELATION TO recid INTO predstpv 
 ENDIF 
 SET RELATION TO adr_id INTO adr77pv ADDITIVE 
 SET RELATION TO adr50_id INTO adr50pv ADDITIVE 
 SET RELATION TO enp2id INTO enp2pv ADDITIVE 
 SET RELATION TO permid INTO permisspv ADDITIVE 
 SET RELATION TO perm2id INTO permis2pv ADDITIVE 
 SET RELATION TO ofioid INTO ofiopv ADDITIVE 
 SET RELATION TO odocid INTO odocpv ADDITIVE  
 SET RELATION TO osmoid INTO osmopv ADDITIVE  
 
 m.recsproc =  0
 SCAN 

  m.act = .t.
  
  SCATTER FIELDS EXCEPT recid,recid_chld,adr_id,adr50_id,ofioid,odocid,permid,perm2id,enp2id MEMO MEMVAR
  m.orid = recid
  m.pv   = m.codpv
  
  m.adr_id   = 0
  m.adr50_id = 0
  m.permid   = 0
  m.perm2id   = 0
  m.odocid   = 0
  m.ofioid   = 0
  m.predstid = 0

  m.ul  = adr77pv.ul
  m.d   = adr77pv.d
  m.kor = adr77pv.kor
  m.str = adr77pv.str
  m.kv  = adr77pv.kv
  
  m.unik = PADL(m.ul,5,'0')+m.d+m.kor+m.str+m.kv
  IF !SEEK(m.unik, 'adr77')
   INSERT INTO adr77 (ul,d,kor,str,kv) VALUES (m.ul,m.d,m.kor,m.str,m.kv)
   m.adr_id = GETAUTOINCVALUE()
  ELSE 
   m.adr_id = adr77.recid 
  ENDIF 
  
  m.c_okato = adr50pv.c_okato
  IF !EMPTY(m.c_okato)
   m.ra_name = UPPER(ALLTRIM(adr50pv.ra_name))
   m.np_c    = ALLTRIM(adr50pv.np_c)
   m.np_name = UPPER(ALLTRIM(adr50pv.np_name))
   m.ul_c    = ALLTRIM(adr50pv.ul_c)
   m.ul_name = UPPER(ALLTRIM(adr50pv.ul_name))
   m.dom2     = LOWER(PADR(ALLTRIM(adr50pv.dom),7))
   m.kor2     = LOWER(PADR(ALLTRIM(adr50pv.kor),5))
   m.str2     = LOWER(PADR(ALLTRIM(adr50pv.str),5))
   m.kv2      = LOWER(PADR(ALLTRIM(adr50pv.kv),5))
      
   m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom2+m.kor2+m.str2+m.kv2
   IF !SEEK(m.unik, 'adr50')
    INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
    (m.c_okato, m.ra_name, m.np_c, m.np_name, m.ul_c, m.ul_name, m.dom2, m.kor2, m.str2, m.kv2)
     m.adr50_id = GETAUTOINCVALUE()
   ELSE 
    m.adr50_id = adr50.recid 
   ENDIF 
  ENDIF 

  IF !EMPTY(permisspv.n_perm)
   m.c_perm = permisspv.c_perm
   m.s_perm = permisspv.s_perm
   m.n_perm = permisspv.n_perm
   m.d_perm = permisspv.d_perm
   m.e_perm = permisspv.e_perm
      
   INSERT INTO permiss (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES (m.c_perm,m.s_perm,m.n_perm,m.d_perm,m.e_perm)
   m.permid = GETAUTOINCVALUE()
  ENDIF 
      
  IF !EMPTY(permis2pv.n_perm)
   m.c_perm = permis2pv.c_perm
   m.s_perm = permis2pv.s_perm
   m.n_perm = permis2pv.n_perm
   m.d_perm = permis2pv.d_perm
   m.e_perm = permis2pv.e_perm
      
   INSERT INTO permis2 (c_perm,s_perm,n_perm,d_perm,e_perm) VALUES (m.c_perm,m.s_perm,m.n_perm,m.d_perm,m.e_perm)
   m.perm2id = GETAUTOINCVALUE()
  ENDIF 
      
  IF !EMPTY(ofiopv.recid)
   m.ofam = ofiopv.fam
   m.oim  = ofiopv.im
   m.oot  = ofiopv.ot
   m.odr  = ofiopv.dr
   m.ow   = ofiopv.w
      
   INSERT INTO ofio (fam,im,ot,dr,w) VALUES (m.ofam,m.oim,m.oot,m.odr,m.ow)
   m.ofioid = GETAUTOINCVALUE()
  ENDIF 

  IF !EMPTY(odocpv.recid)
   m.c_doc = odocpv.c_doc
   m.s_doc = odocpv.s_doc
   m.n_doc = odocpv.n_doc
   m.d_doc = odocpv.d_doc
   m.e_doc = odocpv.e_doc
      
   INSERT INTO odoc (c_doc,s_doc,n_doc,d_doc,e_doc) VALUES (m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
   m.odocid = GETAUTOINCVALUE()
  ENDIF 

  IF !EMPTY(enp2pv.recid)
   m.aaenp   = enp2pv.enp
   m.aaogrn  = enp2pv.ogrn
   m.aaokato = enp2pv.okato
   m.aadp    = enp2pv.dp
      
   INSERT INTO enp2 (enp,ogrn,okato,dp) VALUES (m.aaenp,m.aaogrn,m.aaokato,m.aadp)
   m.enp2id = GETAUTOINCVALUE()
  ENDIF 
  
  IF !EMPTY(osmopv.recid)
   m.ogrn_old  = osmopv.ogrn
   m.okato_old = osmopv.okato
   m.dp_old    = osmopv.dp
      
   INSERT INTO osmo (ogrn,okato,dp) VALUES (m.ogrn_old,m.okato_old,m.dp_old)
   m.osmoid = GETAUTOINCVALUE()
  ENDIF 

  IF LEN(ALLTRIM(predstpv.fam))>1

   m.p_fam      = UPPER(predstpv.fam)
   m.p_im       = UPPER(predstpv.im)
   m.p_ot       = UPPER(predstpv.ot)
   m.p_c_doc    = predstpv.c_doc
   m.p_s_doc    = predstpv.s_doc
   m.p_n_doc    = predstpv.n_doc
   m.p_d_doc    = predstpv.d_doc
   m.p_podr_doc = predstpv.podr_doc
   m.p_tel1     = predstpv.tel1
   m.p_tel2     = predstpv.tel2
   m.p_inf      = predstpv.inf
   
   m.fio = LEFT(m.p_Fam,25)+LEFT(m.p_Im,3)+LEFT(m.p_Ot,3)
   IF !SEEK(m.fio, 'predst', 'fio')
    INSERT INTO predst (fam,im,ot,c_doc,s_doc,n_doc,d_doc,podr_doc,tel1,tel2,inf) VALUES ;
    (m.p_fam,m.p_im,m.p_ot,m.p_c_doc,m.p_s_doc,m.p_n_doc,m.p_d_doc,m.p_podr_doc,m.p_tel1,m.p_tel2,m.p_inf)
    m.predstid = GETAUTOINCVALUE()
   ELSE 
    m.predstid = predst.recid
   ENDIF 

  ENDIF 
  
  INSERT INTO kms FROM MEMVAR 
  m.recsproc = m.recsproc + 1

  m.nrid = GETAUTOINCVALUE()

  INSERT INTO currid FROM MEMVAR 

  IF m.form=2
   m.fo_file = 'f'+PADL(m.orid,6,'0')
   m.fn_file = 'f'+PADL(m.nrid,6,'0')
   IF fso.FileExists(pbase+'\'+m.codpv+'\jpeg\'+m.fo_file+'.jpg')
    IF fso.FileExists(pbase+'\jpeg\'+m.fn_file+'.jpg')
     fso.DeleteFile(pbase+'\jpeg\'+m.fn_file+'.jpg')
    ENDIF 
    fso.CopyFile(pbase+'\'+m.codpv+'\jpeg\'+m.fo_file+'.jpg', pbase+'\jpeg\'+m.fn_file+'.jpg')
   ENDIF 

   m.so_file = 's'+PADL(m.orid,6,'0')
   m.sn_file = 's'+PADL(m.nrid,6,'0')
   IF fso.FileExists(pbase+'\'+m.codpv+'\jpeg\'+m.so_file+'.jpg')
    IF fso.FileExists(pbase+'\jpeg\'+m.sn_file+'.jpg')
     fso.DeleteFile(pbase+'\jpeg\'+m.sn_file+'.jpg')
    ENDIF 
    fso.CopyFile(pbase+'\'+m.codpv+'\jpeg\'+m.so_file+'.jpg', pbase+'\jpeg\'+m.sn_file+'.jpg')
   ENDIF 
  ENDIF 
  
 ENDSCAN 

 m.recsinpv = RECCOUNT('kmspv')
 UPDATE curpv SET recsinpv=m.recsinpv, recsproc=m.recsproc WHERE pv = m.codpv
 
 SET RELATION OFF INTO adr77pv
 SET RELATION OFF INTO adr50pv
 SET RELATION OFF INTO enp2pv
 SET RELATION OFF INTO permisspv
 SET RELATION OFF INTO permis2pv
 SET RELATION OFF INTO ofiopv
 SET RELATION OFF INTO odocpv
 SET RELATION OFF INTO osmopv
 
 SELECT movespv
 SCAN 
  SCATTER FIELDS EXCEPT recid,kmsid,frecid MEMVAR 

  m.okmsid = kmsid
  m.kmsid  = IIF(SEEK(m.okmsid, 'currid'), currid.nrid, 0)
  m.frecid = PADL(m.kmsid,6,'0')
  
  IF m.kmsid!=0
   INSERT INTO moves FROM MEMVAR 
  ENDIF 
  
 ENDSCAN 
 
 SELECT answerspv
 SCAN
  SCATTER FIELDS EXCEPT recid MEMVAR 
  m.orecid = INT(VAL(recid))
  m.recid  = IIF(SEEK(m.orecid, 'currid'), PADL(currid.nrid,6,'0'), '')
  
  IF !EMPTY(m.recid)
   INSERT INTO answers FROM MEMVAR 
  ENDIF 

 ENDSCAN 
 
 SELECT errorpv
 SCAN 
  SCATTER FIELDS EXCEPT rid,rec_id MEMVAR 

  m.orec_id = INT(VAL(rec_id))
  m.rec_id  = IIF(SEEK(m.orec_id, 'currid'), PADL(currid.nrid,6,'0'), '')
  
  IF !EMPTY(m.rec_id)
   INSERT INTO error FROM MEMVAR 
  ENDIF 
  
 ENDSCAN 
 
 SELECT efomspv
 SCAN 
  SCATTER FIELDS EXCEPT rid,recid MEMVAR 

  m.orecid = recid
  m.recid  = IIF(SEEK(m.orecid, 'currid'), currid.nrid, 0)
  
  IF m.recid!=0
   INSERT INTO efoms FROM MEMVAR 
  ENDIF 
  
 ENDSCAN 

 USE IN currid

 =ClFilesPv(m.codpv)
 WAIT CLEAR 
RETURN 

FUNCTION OpFiles
 tn_res = 0 
 tn_res = tn_res + OpenFile(pbase+'\kms', 'kms', 'shar')
 tn_res = tn_res + OpenFile(pbase+'\adr50', 'adr50', 'shar', 'unik')
 tn_res = tn_res + OpenFile(pbase+'\adr77', 'adr77', 'shar', 'unik')
 tn_res = tn_res + OpenFile(pbase+'\answers', 'answers', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\e_ffoms', 'efoms', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\enp2', 'enp2', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\error', 'error', 'shar', 'rec_id')
 tn_res = tn_res + OpenFile(pbase+'\moves', 'moves', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\odoc', 'odoc', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\ofio', 'ofio', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\osmo', 'osmo', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\permiss', 'permiss', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\permis2', 'permis2', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\predst', 'predst', 'shar')
RETURN tn_res

FUNCTION OpFilesPv(para1)
 PRIVATE m.codpv
 m.codpv = para1
 
 tn_res = 0 
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\kms', 'kmspv', 'shar')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\adr50', 'adr50pv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\adr77', 'adr77pv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\answers', 'answerspv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\e_ffoms', 'efomspv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\enp2', 'enp2pv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\error', 'errorpv', 'shar', 'rec_id')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\moves', 'movespv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\odoc', 'odocpv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\ofio', 'ofiopv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\osmo', 'osmopv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\permiss', 'permisspv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\permis2', 'permis2pv', 'shar', 'recid')
 tn_res = tn_res + OpenFile(pbase+'\'+m.codpv+'\predst', 'predstpv', 'shar')
RETURN tn_res

FUNCTION ClFiles
 IF USED('kms')
  USE IN kms
 ENDIF 
 IF USED('adr50')
  USE IN adr50
 ENDIF 
 IF USED('adr77')
  USE IN adr77
 ENDIF 
 IF USED('answers')
  USE IN answers
 ENDIF 
 IF USED('efoms')
  USE IN efoms
 ENDIF 
 IF USED('enp2')
  USE IN enp2
 ENDIF 
 IF USED('error')
  USE IN error
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 
 IF USED('odoc')
  USE IN odoc
 ENDIF 
 IF USED('ofio')
  USE IN ofio
 ENDIF 
 IF USED('osmo')
  USE IN osmo
 ENDIF 
 IF USED('permiss')
  USE IN permiss
 ENDIF 
 IF USED('permis2')
  USE IN permis2
 ENDIF 
 IF USED('predst')
  USE IN predst
 ENDIF 
RETURN 

FUNCTION ClFilesPv(para1)
 PRIVATE m.codpv
 m.codpv = para1
 IF USED('kmspv')
  USE IN kmspv
 ENDIF 
 IF USED('adr50pv')
  USE IN adr50pv
 ENDIF 
 IF USED('adr77pv')
  USE IN adr77pv
 ENDIF 
 IF USED('answerspv')
  USE IN answerspv
 ENDIF 
 IF USED('efomspv')
  USE IN efomspv
 ENDIF 
 IF USED('enp2pv')
  USE IN enp2pv
 ENDIF 
 IF USED('errorpv')
  USE IN errorpv
 ENDIF 
 IF USED('movespv')
  USE IN movespv
 ENDIF 
 IF USED('odocpv')
  USE IN odocpv
 ENDIF 
 IF USED('ofiopv')
  USE IN ofiopv
 ENDIF 
 IF USED('osmopv')
  USE IN osmopv
 ENDIF 
 IF USED('permisspv')
  USE IN permisspv
 ENDIF 
 IF USED('permis2pv')
  USE IN permis2pv
 ENDIF 
 IF USED('predstpv')
  USE IN predstpv
 ENDIF 
RETURN 