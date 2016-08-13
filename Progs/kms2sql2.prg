PROCEDURE kms2sql2
 IF MESSAGEBOX('ИМПОРТИРОВАТЬ БД В SQL?',4+32,'')=7
  RETURN 
 ENDIF 

 nHandl = SQLCONNECT("ruby")
 IF nHandl <= 0
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'Cannot make connection')
  RETURN 
 ENDIF
 
IF SQLEXEC(nHandl, "SET QUOTED_IDENTIFIER ON")<=0
 =AERROR(errarr)
 =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SET QUOTED_IDENTIFIER ON')
 RETURN 
ENDIF 
IF SQLEXEC(nHandl, "SET CONCAT_NULL_YIELDS_NULL ON")<=0
 =AERROR(errarr)
 =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SET CONCAT_NULL_YIELDS_NULL ON')
 RETURN 
ENDIF 
IF SQLEXEC(nHandl, "SET ANSI_NULLS ON")<=0
 =AERROR(errarr)
 =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SET ANSI_NULLS ON')
 RETURN 
ENDIF 
IF SQLEXEC(nHandl, "SET ANSI_PADDING ON")<=0
 =AERROR(errarr)
 =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SET ANSI_PADDING ON')
 RETURN 
ENDIF 
IF SQLEXEC(nHandl, "SET ANSI_WARNINGS ON")<=0
 =AERROR(errarr)
 =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SET ANSI_WARNINGS ON')
 RETURN 
ENDIF 
IF SQLEXEC(nHandl, "SET NUMERIC_ROUNDABORT OFF")<=0
 =AERROR(errarr)
 =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'SET NUMERIC_ROUNDABORT OFF')
 RETURN 
ENDIF 

 IF !CreateDataBase()
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms 
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\adr77', 'adr77', 'shar', 'recid')>0
  USE IN kms
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\adr50', 'adr50', 'shar', 'recid')>0
  USE IN kms
  USE IN adr77
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\ofio', 'ofio', 'shar', 'recid')>0
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('ofio')
   USE IN ofio
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\odoc', 'odoc', 'shar', 'recid')>0
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('odoc')
   USE IN odoc
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\osmo', 'osmo', 'shar', 'recid')>0
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('osmo')
   USE IN osmo
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\permiss', 'permiss', 'shar', 'recid')>0
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('permiss')
   USE IN permiss
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\permis2', 'permis2', 'shar', 'recid')>0
  USE IN permiss
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('permis2')
   USE IN permis2
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\enp2', 'enp2', 'shar', 'recid')>0
  USE IN permis2
  USE IN permiss
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('enp2')
   USE IN enp2
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\predst', 'predst', 'shar', 'recid')>0
  USE IN enp2
  USE IN permis2
  USE IN permiss
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  IF USED('predst')
   USE IN predst
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\moves', 'moves', 'shar')>0
  USE IN enp2
  USE IN permis2
  USE IN permiss
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  USE IN predst
  IF USED('moves')
   USE IN moves
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\answers', 'answers', 'shar')>0
  USE IN enp2
  USE IN permis2
  USE IN permiss
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  USE IN predst
  USE IN moves
  IF USED('answers')
   USE IN answers
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 IF OpenFile(pbase+'\e_ffoms', 'errors', 'shar')>0
  USE IN answers
  USE IN enp2
  USE IN permis2
  USE IN permiss
  USE IN osmo
  USE IN odoc
  USE IN ofio
  USE IN kms
  USE IN adr77
  USE IN adr50
  USE IN predst
  USE IN moves
  IF USED('errors')
   USE IN errors
  ENDIF 
  =SQLDISCONNECT(nHandl)
  RETURN 
 ENDIF 
 
 CREATE CURSOR transid (foxid i, sqlid i)
 INDEX ON foxid TAG foxid
 SET ORDER TO foxid

 SELECT kms
 SET RELATION TO adr_id INTO adr77
 SET RELATION TO adr50_id INTO adr50 ADDITIVE 
 SET RELATION TO ofioid INTO ofio ADDITIVE 
 SET RELATION TO odocid INTO odoc ADDITIVE 
 SET RELATION TO osmoid INTO osmo ADDITIVE 
 SET RELATION TO permid INTO permiss ADDITIVE 
 SET RELATION TO perm2id INTO permis2 ADDITIVE 
 SET RELATION TO enp2id INTO enp2 ADDITIVE 
 SET RELATION TO predstid INTO predst ADDITIVE 

 WAIT "Импорт..." WINDOW NOWAIT 

 lnGoodRecs = 0
 m.d_beg = SECONDS()
 m.cnt = 0
 SCAN 
  SCATTER FIELDS EXCEPT recid,adr_id,adr50_id,ofioid,odocid,osmoid,permid,perm2id,predstid MEMO MEMVAR 

  m.u_doc = ALLTRIM(m.podr_doc)
  m.mr    = ALLTRIM(m.mr)
  
  m.operpv = IIF(m.operpv>0, m.operpv, NULL)
  m.kl = IIF(m.kl>0, m.kl, NULL)
  m.e_doc = IIF(!EMPTY(m.e_doc), m.e_doc, NULL)
  m.d_doc = IIF(!EMPTY(m.d_doc), m.d_doc, NULL)
  m.dr = IIF(!EMPTY(m.dr), m.dr, NULL)
  m.dt = IIF(!EMPTY(m.dt), m.dt, NULL)
  m.dp = IIF(!EMPTY(m.dp), m.dp, NULL)
  m.gz_data = IIF(!EMPTY(m.gz_data), m.gz_data, NULL)
  m.vs_data = IIF(!EMPTY(m.vs_data), m.vs_data, NULL)
  m.d_reg = IIF(!EMPTY(m.dat_reg), m.dat_reg, NULL)
  m.snils = m.ss
  
  m.adr_id = 0
  m.ul  = IIF(!EMPTY(adr77.ul), adr77.ul, 0)
  m.dom = IIF(!EMPTY(adr77.d), UPPER(ALLTRIM(adr77.d)), '')
  m.kor = IIF(!EMPTY(adr77.kor), UPPER(ALLTRIM(adr77.kor)), '')
  m.str = IIF(!EMPTY(adr77.str), UPPER(ALLTRIM(adr77.str)), '')
  m.kv  = IIF(!EMPTY(adr77.kv), UPPER(ALLTRIM(adr77.kv)), '')
  
  m.adr50_id = 0
  m.c_okato = IIF(!EMPTY(adr50.c_okato), ALLTRIM(adr50.c_okato), '')
  m.ra_name = IIF(!EMPTY(adr50.ra_name), ALLTRIM(adr50.ra_name), '')
  m.np_c    = IIF(!EMPTY(adr50.np_c), ALLTRIM(adr50.np_c), '')
  m.np_name = IIF(!EMPTY(adr50.np_name), ALLTRIM(adr50.np_name), '')
  m.ul_c    = IIF(!EMPTY(adr50.ul_c), ALLTRIM(adr50.ul_c), '')
  m.ul_name = IIF(!EMPTY(adr50.ul_name), ALLTRIM(adr50.ul_name), '')
  m.dom50   = IIF(!EMPTY(adr50.dom), UPPER(ALLTRIM(adr50.dom)), '')
  m.kor50   = IIF(!EMPTY(adr50.kor), UPPER(ALLTRIM(adr50.kor)), '')
  m.str50   = IIF(!EMPTY(adr50.str), UPPER(ALLTRIM(adr50.str)), '')
  m.kv50    = IIF(!EMPTY(adr50.kv), UPPER(ALLTRIM(adr50.kv)), '')
  
  m.ofioid = 0
  m.ofam = IIF(!EMPTY(ofio.fam), ALLTRIM(ofio.fam), '')
  m.oim  = IIF(!EMPTY(ofio.im), ALLTRIM(ofio.im), '')
  m.oot  = IIF(!EMPTY(ofio.ot), ALLTRIM(ofio.ot), '')
  m.odr  = IIF(!EMPTY(ofio.dr), ofio.dr, NULL)
  m.ow   = IIF(!EMPTY(ofio.w), ofio.w, 0)
 
  m.odocid = 0
  m.oc_doc = IIF(!EMPTY(odoc.c_doc), odoc.c_doc, 0)
  m.os_doc = IIF(!EMPTY(odoc.s_doc), ALLTRIM(odoc.s_doc), '')
  m.on_doc = IIF(!EMPTY(odoc.n_doc), ALLTRIM(odoc.n_doc), '')
  m.od_doc = IIF(!EMPTY(odoc.d_doc), odoc.d_doc, NULL)
  m.oe_doc = IIF(!EMPTY(odoc.e_doc), odoc.e_doc, NULL)
  
  m.osmoid = 0
  m.oogrn  = IIF(!EMPTY(osmo.ogrn), osmo.ogrn, '')
  m.ookato = IIF(!EMPTY(osmo.okato), osmo.okato, '')
  m.odp    = IIF(!EMPTY(osmo.dp), osmo.dp, NULL)

  m.permid  = 0
  m.c_perm  = IIF(!EMPTY(permiss.c_perm), permiss.c_perm, 0)
  m.s_perm  = IIF(!EMPTY(permiss.s_perm), ALLTRIM(permiss.s_perm), '')
  m.n_perm  = IIF(!EMPTY(permiss.n_perm), ALLTRIM(permiss.n_perm), '')
  m.d_perm  = IIF(!EMPTY(permiss.d_perm), permiss.d_perm, NULL)
  m.e_perm  = IIF(!EMPTY(permiss.e_perm), permiss.e_perm, NULL)

  m.perm2id  = 0
  m.c_perm2  = IIF(!EMPTY(permis2.c_perm), permis2.c_perm, 0)
  m.s_perm2  = IIF(!EMPTY(permis2.s_perm), ALLTRIM(permis2.s_perm), '')
  m.n_perm2  = IIF(!EMPTY(permis2.n_perm), ALLTRIM(permis2.n_perm), '')
  m.d_perm2  = IIF(!EMPTY(permis2.d_perm), permis2.d_perm, NULL)
  m.e_perm2  = IIF(!EMPTY(permis2.e_perm), permis2.e_perm, NULL)

  m.enp2id = 0
  m.enp2   = IIF(!EMPTY(enp2.enp), enp2.enp, '')
  m.ogrn2  = IIF(!EMPTY(enp2.ogrn), enp2.ogrn, '')
  m.okato2 = IIF(!EMPTY(enp2.okato), enp2.okato, '')
  m.dp2    = IIF(!EMPTY(enp2.dp), enp2.dp, NULL)

  m.predstid = 0
  m.prfam    = IIF(!EMPTY(predst.fam), PROPER(predst.fam), '')
  m.prim     = IIF(!EMPTY(predst.im), PROPER(predst.im), '')
  m.prot     = IIF(!EMPTY(predst.ot), PROPER(predst.ot), '')
  m.prc_doc  = IIF(!EMPTY(predst.c_doc), predst.c_doc, 0)
  m.prs_doc  = IIF(!EMPTY(predst.s_doc), ALLTRIM(predst.s_doc), '')
  m.prn_doc  = IIF(!EMPTY(predst.n_doc), ALLTRIM(predst.n_doc), '')
  m.prd_doc  = IIF(!EMPTY(predst.d_doc), predst.d_doc, NULL)
  m.pru_doc  = IIF(!EMPTY(predst.podr_doc), ALLTRIM(predst.podr_doc), '')
  m.prtel1   = IIF(!EMPTY(predst.tel1), ALLTRIM(predst.tel1), '')
  m.prtel2   = IIF(!EMPTY(predst.tel2), ALLTRIM(predst.tel2), '')
  m.prinf    = IIF(!EMPTY(predst.inf), ALLTRIM(predst.inf), '')

  m.wrkid = 0

  IF m.ul>0 AND !EMPTY(m.dom) AND !EMPTY(m.kv) && конвертация московских адресов
   CmdAll = "{call seekadr77 (?m.ul, ?m.dom, ?m.kor, ?m.str, ?m.kv)}"  && "exec seekadr77 ?m.ul, ?m.dom, ?m.kor, ?m.str, ?m.kv"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_adr77 AS recid", "cursid")!=-1
        m.adr_id = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO adr77 (recid,ul,dom,kor,str,kv) VALUES (?m.adr_id,?m.ul,?m.dom,?m.kor,?m.str,?m.kv)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.adr_id = curss.recid

     CASE RECCOUNT('curss') > 1

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 
  
  IF !EMPTY(m.c_okato) AND !EMPTY(m.dom50) && конвертация иногородних адресов
   CmdAll = "{call seekadr50 (?m.c_okato, ?m.ra_name, ?m.np_name, ?m.ul_name, ?m.dom50, ?m.kor50, ?m.str50, ?m.kv50)}"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_adr50 AS recid", "cursid")!=-1
       m.adr50_id = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO adr50 (recid, c_okato,ra_name,np_c,np_name,ul_c,ul_name,dom,kor,str,kv) VALUES ;
       (?m.adr50_id,?m.c_okato,?m.ra_name,?m.np_c,?m.np_name,?m.ul_c,?m.ul_name,?m.dom50,?m.kor50,?m.str50,?m.kv50)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.adr50_id = curss.recid

     CASE RECCOUNT('curss') > 1

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 

  IF !EMPTY(m.oogrn) AND !EMPTY(m.ookato)
   CmdAll = "{call seekosmo (?m.oogrn, ?m.ookato)}"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_osmo AS recid", "cursid")!=-1
        m.osmoid = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO osmo (recid,ogrn,okato,dp) VALUES (?m.osmoid,?m.oogrn,?m.ookato,?m.odp)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.osmoid = curss.recid

     CASE RECCOUNT('curss') > 1

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 

  IF !EMPTY(m.ofam) OR !EMPTY(m.oim) OR!EMPTY(m.oot) OR!EMPTY(m.odr) OR!EMPTY(m.ow)
   IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_ofio AS recid", "cursid")!=-1
    m.ofioid = cursid.recid
    USE IN cursid
   ENDIF 
   IF SQLEXEC(nHandl, "INSERT INTO ofio (recid,fam, im, ot, dr, w) VALUES (?m.ofioid,?m.ofam, ?m.oim, ?m.oot, ?m.odr, ?m.ow)")!=-1
   ENDIF 
  ENDIF 

  IF !EMPTY(m.oc_doc)
   CmdAll = "{call seekodoc (?m.s_doc, ?m.n_doc)}"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_odoc AS recid", "cursid")!=-1
       m.odocid = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO odoc (recid,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES (?m.odocid,?m.c_doc,?m.s_doc,?m.n_doc,?m.d_doc,?m.e_doc)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.odocid = curss.recid

     CASE RECCOUNT('curss') > 1
      m.odocid = curss.recid

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 

  IF INLIST(m.c_perm,11,23)&& Только Вид на жительство или РВП!
   CmdAll = "{call seekpermiss (?m.s_perm, ?m.n_perm)}"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_permiss AS recid", "cursid")!=-1
       m.permid = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO permiss (recid,c_perm,s_perm,n_perm,d_perm,e_perm) VALUES (?m.permid,?m.c_perm,?m.s_perm,?m.n_perm,?m.d_perm,?m.e_perm)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.permid = curss.recid

     CASE RECCOUNT('curss') > 1

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 

  IF INLIST(m.c_perm2,11,23) && Только Вид на жительство или РВП!
   IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_permis2 AS recid", "cursid")!=-1
    m.perm2id = cursid.recid
    USE IN cursid
   ENDIF 
   IF SQLEXEC(nHandl, "INSERT INTO permis2 (recid,c_perm,s_perm,n_perm,d_perm,e_perm) VALUES (?m.perm2id,?m.c_perm2,?m.s_perm2,?m.n_perm2,?m.d_perm2,?m.e_perm2)")!=-1
   ENDIF 
  ENDIF 

  IF !EMPTY(m.enp2)
   CmdAll = "{call seekenp2 (?m.enp2)}"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_enp2 AS recid", "cursid")!=-1
       m.enp2id = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO enp2 (recid,enp,ogrn,okato,dp) VALUES (?m.enp2id,?m.enp2,?m.ogrn2,?m.okato2,?m.dp2)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.enp2id = curss.recid

     CASE RECCOUNT('curss') > 1

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 

  IF !EMPTY(m.prfam)
   CmdAll = "{call seekpredst (?m.prfam, ?m.prim, ?m.prot)}"
   IF SQLEXEC(nHandl, CmdAll, "curss") != -1
    DO CASE
     CASE RECCOUNT('curss') <= 0
      IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_enp2 AS recid", "cursid")!=-1
       m.predstid = cursid.recid
       USE IN cursid
      ENDIF 
      IF SQLEXEC(nHandl, "INSERT INTO predst (recid,fam,im,ot,c_doc,s_doc,n_doc,d_doc,u_doc,tel1,tel2,inf) VALUES ;
       (?m.predstid,?m.prfam,?m.prim,?m.prot,?m.prc_doc,?m.prs_doc,?m.prn_doc,?m.prd_doc,?m.pru_doc,?m.prtel1,?m.prtel2,?m.prinf)")!=-1
      ENDIF 

     CASE RECCOUNT('curss') == 1
      m.predstid = curss.recid

     CASE RECCOUNT('curss') > 1

     OTHERWISE 

    ENDCASE 
    USE IN curss
   ENDIF 
  ENDIF 

  cmd01 = 'INSERT INTO kms '
  cmd02 = '(recid,act,pv,nz,status,p_doc,p_doc2,vs,vs_data,sn_card,enp,gz_data,q,dp,dt,fam,d_type1,im,d_type2,ot,d_type3,'
  cmd03 = 'w,dr,true_dr,jt,scn,kl,cont,c_doc,s_doc,n_doc,d_doc,e_doc,x_doc,u_doc,snils,gr,mr,d_reg,form,predst,'
  cmd04 = 'spos,d_type4,coment,ktg,gzk_flag,doc_flag,uec_flag,s_card2,n_card2,is2fio,is2doc,mcod,oper,operpv,'
  cmd05 = 'adr_id, adr50_id, ofioid, odocid, osmoid, permid,perm2id,enp2id,predstid,wrkid)'
  cmd06 = 'VALUES '
  cmd07 = '(?m.sqlid,?m.act,?m.pv,?m.nz,?m.status,?m.p_doc,?m.p_doc2,?m.vs,?m.vs_data,?m.sn_card,?m.enp,?m.gz_data,?m.q,?m.dp,?m.dt,?m.fam,?m.d_type1,?m.im,?m.d_type2,?m.ot,?m.d_type3,'
  cmd08 = '?m.w,?m.dr,?m.true_dr,?m.jt,?m.scn,?m.kl,?m.cont,?m.c_doc,?m.s_doc,?m.n_doc,?m.d_doc,?m.e_doc,?m.x_doc,?m.u_doc,?m.snils,?m.gr,?m.mr,?m.d_reg,?m.form,?m.predst,'
  cmd09 = '?m.spos,?m.d_type4,?m.comment,?m.ktg,?m.gzk_flag,?m.doc_flag,?m.uec_flag,?m.s_card2,?m.n_card2,?m.is2fio,?m.is2doc,?m.mcod,?m.oper,?m.operpv,'
  cmd10 = '?m.adr_id, ?m.adr50_id, ?m.ofioid, ?m.odocid, ?m.osmoid, ?m.permid, ?m.perm2id, ?m.enp2id, ?m.predstid, ?m.wrkid)'
  cmdAll = cmd01+cmd02+cmd03+cmd04+cmd05+cmd06+cmd07+cmd08+cmd09+cmd10
  IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_kms AS recid", "cursid")!=-1
   m.sqlid = cursid.recid
   USE IN cursid
  ENDIF 
  IF SQLEXEC(nHandl, cmdAll)!=-1
   lnGoodRecs = lnGoodRecs + 1
  ENDIF 

  SELECT kms 
  m.foxid = recid
  
  INSERT INTO transid FROM MEMVAR 

 ENDSCAN 
 SET RELATION OFF INTO adr77
 SET RELATION OFF INTO adr50
 SET RELATION OFF INTO ofio
 SET RELATION OFF INTO odoc
 SET RELATION OFF INTO permiss
 SET RELATION OFF INTO permis2
 SET RELATION OFF INTO enp2
 SET RELATION OFF INTO predst
 USE 
 USE IN predst
 USE IN enp2
 USE IN adr77
 USE IN adr50
 USE IN ofio
 USE IN odoc 
 USE IN osmo
 USE IN permiss
 USE IN permis2
 
 SELECT moves
 SCAN 
  SCATTER FIELDS EXCEPT recid,kmsid,frecid MEMVAR 
  m.foxid  = kmsid
  m.kmsid  = IIF(SEEK(m.foxid, 'transid'), transid.sqlid, 0)
  IF m.kmsid<=0
   LOOP 
  ENDIF 
  m.frecid = PADL(m.kmsid,6,'0')
  m.n_card = IIF(m.n_card <= 9999999999, m.n_card, NULL)
  m.n_card = IIF(m.n_card>0, m.n_card, NULL)
  m.nz     = IIF(m.nz>0, m.nz, NULL)
  m.n_kor  = IIF(m.n_kor>0, m.n_kor, NULL)
  m.mkdate = IIF(!EMPTY(m.mkdate), m.mkdate, NULL)
  m.dr     = IIF(!EMPTY(m.dr), m.dr, NULL)
  m.c_doc  = IIF(m.c_doc>0, m.c_doc, NULL)
  m.d_doc  = IIF(!EMPTY(m.d_doc), m.d_doc, NULL)
  m.e_doc  = IIF(!EMPTY(m.e_doc), m.e_doc, NULL)
  
  cmd01 = 'INSERT INTO moves '
  cmd02 = '(recid,et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,c_okato,enp,dp,jt,scn,pricin,tranz,'
  cmd03 = 'q,err,err_text,ans_fl,nz,n_kor,fam,im,ot,w,dr,c_doc,s_doc,n_doc,d_doc,e_doc)'
  cmd04 = 'VALUES '
  cmd05 = '(?m.movesid,?m.et,?m.fname,?m.mkdate,?m.kmsid,?m.frecid,?m.vs,?m.s_card,?m.n_card,?m.c_okato,?m.enp,?m.dp,?m.jt,?m.scn,?m.pricin,?m.tranz,'
  cmd06 = '?m.q,?m.err,?m.err_text,?m.ans_fl,?m.nz,?m.n_kor,?m.fam,?m.im,?m.ot,?m.w,?m.dr,?m.c_doc,?m.s_doc,?m.n_doc,?m.d_doc,?m.e_doc)'
  cmdAll = cmd01+cmd02+cmd03+cmd04+cmd05+cmd06
  IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_moves AS recid", "cursid")!=-1
   m.movesid = cursid.recid
   USE IN cursid
  ENDIF 
  IF SQLEXEC(nHandl, cmdAll)!=-1
   lnGoodRecs = lnGoodRecs + 1
  ELSE 
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'Cannot make connection')
   =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot make connection')
   EXIT 
  ENDIF 
  
 ENDSCAN 
 USE IN moves 
 
 SELECT answers
 SCAN 
  SCATTER MEMVAR 
  m.foxid  = INT(VAL(recid))
  m.kmsid  = IIF(SEEK(m.foxid, 'transid'), transid.sqlid, 0)
  IF m.kmsid<=0
   LOOP 
  ENDIF 
  m.recid = PADL(m.kmsid,6,'0')

  cmd01 = 'INSERT INTO answers '
  cmd02 = '(recid,data,tiperz,sn_pol,enp,s_card,n_card,date_b,date_e,q,q_ogrn,fam,im,ot,dr,w,'
  cmd03 = 'ans_r,snils,doc_type,doc_ser,doc_num,doc_date,gr,erz,tip_d,okato,npp,err)'
  cmd04 = 'VALUES '
  cmd05 = '(?m.recid,?m.data,?m.tiperz,?m.sn_pol,?m.enp,?m.s_card,?m.n_card,?m.date_b,?m.date_e,?m.q,?m.q_ogrn,?m.fam,?m.im,?m.ot,?m.dr,?m.w,'
  cmd06 = '?m.ans_r,?m.snils,?m.doc_type,?m.doc_ser,?m.doc_num,?m.doc_date,?m.gr,?m.erz,?m.tip_d,?m.okato,?m.npp,?m.err)'
  cmdAll = cmd01+cmd02+cmd03+cmd04+cmd05+cmd06
  IF SQLEXEC(nHandl, cmdAll)!=-1
   lnGoodRecs = lnGoodRecs + 1
  ELSE 
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'Cannot make '+recid)
   =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot make '+recid)
   EXIT 
  ENDIF 
  
 ENDSCAN 
 USE IN answers

 SELECT errors
 SCAN 
  SCATTER MEMVAR 
  m.foxid  = recid
  m.kmsid  = IIF(SEEK(m.foxid, 'transid'), transid.sqlid, 0)
  IF m.kmsid<=0
   LOOP 
  ENDIF 
  m.recid = m.kmsid
  m.data  = IIF(!EMPTY(m.data), m.data, NULL)
  m.dcor  = IIF(!EMPTY(m.dcor), m.dcor, NULL)

  cmd01 = 'INSERT INTO errors '
  cmd02 = '(rid,recid,data,err,comment,c_t,pid,ans_fl,step,v,dcor,fname)'
  cmd03 = ''
  cmd04 = 'VALUES '
  cmd05 = '(?m.errorsid,?m.recid,?m.data,?m.err,?m.comment,?m.c_t,?m.pid,?m.ans_fl,?m.step,?m.v,?m.dcor,?m.fname)'
  cmd06 = ''
  cmdAll = cmd01+cmd02+cmd03+cmd04+cmd05+cmd06
  IF SQLEXEC(nHandl,"SELECT NEXT VALUE FOR sq_errors AS recid", "cursid")!=-1
   m.errorsid = cursid.recid
   USE IN cursid
  ENDIF 
  IF SQLEXEC(nHandl, cmdAll)!=-1
   lnGoodRecs = lnGoodRecs + 1
  ELSE 
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'Cannot make')
   =MESSAGEBOX(ALLTRIM(errarr(3)), 16, 'Cannot make')
   EXIT 
  ENDIF 
  
 ENDSCAN 
 USE IN errors

 m.d_end = SECONDS()
 WAIT CLEAR 
 
 USE IN transid
 
 MESSAGEBOX("ВРЕМЯ ОБРАБОТКИ: "+TRANSFORM(m.d_end-m.d_beg,'999999999') +' сек.',0+64,'')

 IF SQLEXEC(nHandl, "ALTER DATABASE kms SET MULTI_USER")==-1
  MESSAGEBOX("БД KMS НЕ УДАЛОСЬ ПЕРЕВЕСТИ"+CHR(13)+CHR(10)+;
  "В МНОГОПОЛЬЗОВАТЕЛЬСКИЙ РЕЖИМ!!", 0+64, "")
 ENDIF 
 =SQLDISCONNECT(nHandl)

RETURN 

FUNCTION CreateDataBase()

 IF SQLEXEC(nHandl, "USE kms") != -1
*  IF SQLEXEC(nHandl, "ALTER DATABASE kms SET SINGLE_USER")==-1
*  MESSAGEBOX("БД KMS НЕ УДАЛОСЬ ПЕРЕВЕСТИ"+CHR(13)+CHR(10)+;
*   "В ОДНОПОЛЬЗОВАТЕЛЬСКИЙ РЕЖИМ!!", 0+64, "")
*  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE kms") == -1
*   MESSAGEBOX("Таблица kms не удалена!", 0+64, "kms")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE adr50") == -1
*   MESSAGEBOX("Таблица adr50 не удалена!", 0+64, "adr50")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE adr77") == -1
*   MESSAGEBOX("Таблица adr77 не удалена!", 0+64, "adr77")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE answers") == -1
*   MESSAGEBOX("Таблица answers не удалена!", 0+64, "answers")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE errors") == -1
*   MESSAGEBOX("Таблица errors не удалена!", 0+64, "errors")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE enp2") == -1
*   MESSAGEBOX("Таблица enp2 не удалена!", 0+64, "enp")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE moves") == -1
*   MESSAGEBOX("Таблица moves не удалена!", 0+64, "moves")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE odoc") == -1
*   MESSAGEBOX("Таблица odoc не удалена!", 0+64, "odoc")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE ofio") == -1
*   MESSAGEBOX("Таблица ofio не удалена!", 0+64, "ofio")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE osmo") == -1
*   MESSAGEBOX("Таблица osmo не удалена!", 0+64, "osmo")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE permiss") == -1
*   MESSAGEBOX("Таблица permiss не удалена!", 0+64, "permiss")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE permis2") == -1
*   MESSAGEBOX("Таблица permis2 не удалена!", 0+64, "permis2")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE predst") == -1
*   MESSAGEBOX("Таблица predst не удалена!", 0+64, "predst")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE users") == -1
*   MESSAGEBOX("Таблица users не удалена!", 0+64, "users")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP TABLE wrkpl") == -1
*   MESSAGEBOX("Таблица wrkpl не удалена!", 0+64, "wrkpl")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP PROC kmsadd") == -1
*   MESSAGEBOX("Процедура kmsadd не удалена!", 0+64, "kmsadd")
  ENDIF 
  IF SQLEXEC(nHandl, "DROP PROC seekadr77") == -1
*   MESSAGEBOX("Процедура seekadr77 не удалена!", 0+64, "seekadr77")
  ENDIF 

  IF SQLEXEC(nHandl, "USE master") = -1
  ENDIF 

  IF SQLEXEC(nHandl, "DROP DATABASE kms") = -1
   MESSAGEBOX("НЕ УДАЛОСЬ УДАЛИТЬ БД kms!", 0+64, "")
  ENDIF 

 ENDIF 

 IF SQLEXEC(nHandl, "CREATE DATABASE kms ;
  ON (NAME = 'kms_db', FILENAME = 'd:\kms\base\kms.mdf', SIZE=50, FILEGROWTH=5);
  LOG ON (NAME = 'kms_log', FILENAME = 'd:\kms\base\kms.ldf', SIZE=10, FILEGROWTH=5)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("НЕ УДАЛОСЬ СОЗДАТЬ БД kms!", 0+64, "")
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "USE kms") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("БД kms СУЩЕСТВУЕТ!", 0+64, "")
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_adr50 AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_adr50')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_adr77 AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_adr77')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_enp2 AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_enp2')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_errors AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_errors')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_kms AS INT START WITH 1 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_kms')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_moves AS INT START WITH 1 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_moves')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_odoc AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_odoc')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_ofio AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_ofio')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_osmo AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_osmo')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_permiss AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_permiss')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_permis2 AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_permis2')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE SEQUENCE sq_predst AS INT START WITH 0 INCREMENT BY 1") = -1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'sq_predst')
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "CREATE TYPE Sex FROM TINYINT NOT NULL") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("ТИП Sex НЕ СОЗДАН!", 0+64, "")
  RETURN .F.
 ENDIF 

 cmd01  = 'CREATE TABLE [dbo].[adr50] ' && OK!
 cmd02  = '([recid] int not null, [c_okato] varchar(5), [ra_name] varchar(60), [np_c] varchar(2), [np_name] varchar(60), '
 cmd03  = '[ul_c] varchar(2), [ul_name] varchar(60), [dom] varchar(7), [kor] varchar(5), [str] varchar(5), [kv] varchar(5), ;
  [created] datetime default sysdatetime())'
 cmdAll = cmd01 + cmd02 + cmd03
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("НЕ УДАЛОСЬ СОЗДАТЬ ТАБЛИЦУ ADR50!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO adr50 (recid,c_okato,ra_name,np_c,np_name,ul_c,ul_name,dom,kor,str,kv) VALUES ;
   (0,'','','','','','','','','','')")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into adr50')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE adr50 ADD CONSTRAINT pk_adr50 PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_adr50 не создан!", 0+64, "adr50")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX unik ON adr50 (c_okato, ra_name, np_name, ul_name, dom, kor, str, kv)'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс unik не создан!", 0+64, "adr50")
  RETURN .F.
 ENDIF 

* cmd01  = "CREATE PROC seekadr50 (@c_okato varchar(5)='', @ra_name varchar(60)='', @np_name varchar(60)='',;
*  @ul_name varchar(60)='', @dom varchar(7)='', @kor varchar(5)='', @str varchar(5)='', @kv varchar(5)='', @recid int=NULL out) as "
* cmd02  = "BEGIN SET NOCOUNT ON; SELECT $identity FROM adr50 WHERE c_okato=@c_okato AND ra_name=@ra_name AND np_name=@np_name AND ul_name=@ul_name ;
*  AND dom=@dom AND kor=@kor AND str=@str AND kv=@kv; END"
 cmd01  = "CREATE PROC seekadr50 (@c_okato varchar(5)='', @ra_name varchar(60)='', @np_name varchar(60)='',;
  @ul_name varchar(60)='', @dom varchar(7)='', @kor varchar(5)='', @str varchar(5)='', @kv varchar(5)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM adr50 WHERE c_okato=@c_okato AND ra_name=@ra_name AND np_name=@np_name AND ul_name=@ul_name ;
  AND dom=@dom AND kor=@kor AND str=@str AND kv=@kv; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekadr50 не подготовлена!", 0+64, "seekadr50")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekadr50 не создана!", 0+64, "seekadr50")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE adr77 (recid int not null, ul dec(5), dom varchar(7), kor varchar(5), str varchar(5), ;
  kv varchar(5), created datetime default sysdatetime())' && OK!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица adr77 не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO adr77 (recid,ul,dom,kor,str,kv) VALUES (0,0,'','','','')")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into adr77')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE adr77 ADD CONSTRAINT pk_adr77 PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_adr77 не создан!", 0+64, "adr77")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX unik ON adr77 (ul, dom, kor, str, kv)'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс unik не создан!", 0+64, "adr77")
  RETURN .F.
 ENDIF 

* Процедура произвольного поиска
* cmd01 = "CREATE PROC seekadr77 (@ul numeric(5)=0, @dom varchar(7)='', @kor varchar(5)='', @str varchar(5)='', @kv varchar(5)='', @cnt int=0 out) as "
* cmd02 = "SELECT @cnt=COUNT(*) FROM adr77 WHERE dom LIKE CASE WHEN @dom!='' THEN @dom ELSE '%' END AND kor LIKE CASE WHEN @kor!='' THEN @kor ELSE '%' END "
* cmd03 = "AND str LIKE CASE WHEN @str!='' THEN @str ELSE '%' END AND kv LIKE CASE WHEN @kv!='' THEN @kv ELSE '%' END"
* Процедура произвольного поиска

 cmd01  = "CREATE PROC seekadr77 (@ul dec(5)=0, @dom varchar(7)='', @kor varchar(5)='', @str varchar(5)='', @kv varchar(5)='', @recid int=0 out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM adr77 WHERE ul=@ul AND dom=@dom AND kor=@kor AND str=@str AND kv=@kv; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekadr77 не подготовлена!", 0+64, "seekadr77")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekadr77 не создана!", 0+64, "seekadr77")
  RETURN .F.
 ENDIF 

 cmd01  = 'CREATE TABLE answers ' && OK с учетом типа индекса!
 cmd02  = '(recid char(6), data date, tiperz varchar(15), sn_pol varchar(17), enp varchar(16), s_card varchar(6), '
 cmd03  = 'n_card dec(10), date_b date, date_e date, q varchar(2), q_ogrn varchar(13), fam varchar(25), '
 cmd04  = 'im varchar(25), ot varchar(25), dr varchar(8), w Sex, ans_r varchar(3), snils varchar(14), doc_type varchar(2), '
 cmd05  = 'doc_ser varchar(12), doc_num varchar(16), doc_date date, gr varchar(3), erz varchar(1), tip_d varchar(1), '
 cmd06  = 'okato varchar(5), npp dec(2), err varchar(150), created datetime default sysdatetime())'
 cmdAll = cmd01 + cmd02 + cmd03 + cmd04 + cmd05 + cmd06
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица answers не создана!", 0+64, "")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX recid ON answers (recid)' && Внимание! В исходном файле INT(VAL(recid)) вот так!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс recid не создан!", 0+64, "answers")
  RETURN .F.
 ENDIF 

 cmd01  = 'CREATE TABLE errors ' && OK!
 cmd02  = '(rid int not null, recid int, data date, err varchar(5), comment varchar(250), '
 cmd03  = 'c_t varchar(5), pid varchar(16), ans_fl varchar(2), step varchar(4), v bit, dcor date, fname varchar(25), created datetime default sysdatetime())'
 cmdAll = cmd01 + cmd02 + cmd03
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица errors не создана!", 0+64, "")
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE errors ADD CONSTRAINT pk_errors PRIMARY KEY(rid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_errors не создан!", 0+64, "errors")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX recid ON errors (recid)'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс recid не создан!", 0+64, "errors")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX recidn ON errors (recid) WHERE dcor IS NOT NULL'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс recidn не создан!", 0+64, "errors")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX unik ON errors (fname, recid)'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс unik не создан!", 0+64, "errors")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE enp2 (recid int not null, enp varchar(16), ogrn varchar(13), okato varchar(5), dp date, created datetime default sysdatetime())' && OK!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица enp2 не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO enp2 (recid,enp,ogrn,okato,dp) values (0,'','','','')")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into enp2')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE enp2 ADD CONSTRAINT pk_enp2 PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_enp2 не создан!", 0+64, "enp2")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX enp ON enp2 (enp)'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс enp не создан!", 0+64, "enp")
  RETURN .F.
 ENDIF 

 cmd01  = "CREATE PROC seekenp2 (@enp varchar(16)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM enp2 WHERE enp=@enp; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekenp2 не подготовлена!", 0+64, "seekenp2")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekenp2 не создана!", 0+64, "seekenp2")
  RETURN .F.
 ENDIF 

 cmd01  = 'CREATE TABLE moves ' && OK!
 cmd02  = '(et varchar(1), recid int not null, fname varchar(25), mkdate smalldatetime, kmsid int, frecid varchar(6), '
 cmd03  = 'vs varchar(9), s_card varchar(6), n_card dec(10), c_okato varchar(5), enp varchar(16), dp date, jt varchar(1), '
 cmd04  = 'scn varchar(3), pricin varchar(3), tranz varchar(3), q varchar(2), err varchar(5), err_text varchar(250), '
 cmd05  = 'ans_fl varchar(2), nz dec(3), n_kor dec(6), fam varchar(25), im varchar(20), ot varchar(20), w Sex,  '
 cmd06  = 'dr date, c_doc dec(2), s_doc varchar(9), n_doc varchar(8), d_doc date, e_doc date, created datetime default sysdatetime())'
 cmdAll = cmd01 + cmd02 + cmd03 + cmd04 + cmd05 + cmd06
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица moves не создана!", 0+64, "")
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE moves ADD CONSTRAINT pk_moves PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_moves не создан!", 0+64, "moves")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE INDEX kmsid ON moves (kmsid)'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс kmsid не создан!", 0+64, "moves")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX fiorecid ON moves (kmsid) WHERE et='1'"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс fiorecid не создан!", 0+64, "moves")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX ffrecid ON moves (kmsid) WHERE et='2'"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс ffrecid не создан!", 0+64, "moves")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX unik ON moves (fname, frecid)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс unik не создан!", 0+64, "moves")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE odoc (recid int not null, c_doc dec(2), s_doc varchar(9), n_doc varchar(8), ;
  d_doc date, e_doc date, created datetime default sysdatetime())' && OK!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица odoc не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO odoc (recid,c_doc,s_doc,n_doc,d_doc,e_doc) values (0,0,'','',NULL,NULL)")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into odoc')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE odoc ADD CONSTRAINT pk_odoc PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_odoc не создан!", 0+64, "odoc")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX unik ON odoc (s_doc, n_doc)" && Добавлено, в исходной базе не было!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс unik не создан!", 0+64, "odoc")
  RETURN .F.
 ENDIF 

 cmd01  = "CREATE PROC seekodoc (@s_doc varchar(9)='', @n_doc varchar(8)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM odoc WHERE s_doc=@s_doc AND n_doc=@n_doc; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekodoc не подготовлена!", 0+64, "seekodoc")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekodoc не создана!", 0+64, "seekodoc")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE ofio (recid int not null, fam varchar(40), im varchar(40), ot varchar(40), dr date, ;
  w Sex, created datetime default sysdatetime())' && OK!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица ofio не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO ofio (recid,fam,im,ot,dr,w) values (0,'','','',NULL,0)")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into ofio')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE ofio ADD CONSTRAINT pk_ofio PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_ofio не создан!", 0+64, "ofio")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE osmo (recid int not null, ogrn varchar(13), okato varchar(5), dp date, created datetime default sysdatetime())'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица osmo не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO osmo (recid,ogrn,okato,dp) values (0,'','',NULL)")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into osmo')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE osmo ADD CONSTRAINT pk_osmo PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_osmo не создан!", 0+64, "osmo")
  RETURN .F.
 ENDIF 

 cmd01  = "CREATE PROC seekosmo (@ogrn varchar(13)='', @okato varchar(5)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM osmo WHERE ogrn=@ogrn AND okato=@okato; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekosmo не подготовлена!", 0+64, "seekosmo")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekosmo не создана!", 0+64, "seekosmo")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX unik ON osmo (ogrn,okato)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс unik не создан!", 0+64, "osmo")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE permiss (recid int not null, c_perm dec(2), s_perm varchar(9), n_perm varchar(8), ;
  d_perm date, e_perm date, created datetime default sysdatetime(), constraint unidoc unique (s_perm,n_perm))'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица permiss не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO permiss (recid,c_perm,s_perm,n_perm,d_perm,e_perm) values (0,0,'','',NULL,NULL)")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into permiss')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE permiss ADD CONSTRAINT pk_permiss PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_permiss не создан!", 0+64, "permiss")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX sn_perm ON permiss (s_perm, n_perm)" && Добавлено, в исходной базе не было!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс sn_perm не создан!", 0+64, "permiss")
  RETURN .F.
 ENDIF 

 cmd01  = "CREATE PROC seekpermiss (@s_perm varchar(9)='', @n_perm varchar(8)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM permiss WHERE s_perm=@s_perm AND n_perm=@n_perm; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekpermiss не подготовлена!", 0+64, "seekpermiss")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekpermiss не создана!", 0+64, "seekpermiss")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE permis2 (recid int not null, c_perm dec(2), s_perm varchar(9), n_perm varchar(8), ;
  d_perm date, e_perm date, created datetime default sysdatetime())'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица permiss не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO permis2 (recid,c_perm,s_perm,n_perm,d_perm,e_perm) values (0,0,'','',NULL,NULL)")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into permiss')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE permis2 ADD CONSTRAINT pk_permis2 PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_permis2 не создан!", 0+64, "permis2")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX sn_perm ON permis2 (s_perm, n_perm)" && Добавлено, в исходной базе не было!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс sn_perm не создан!", 0+64, "permis2")
  RETURN .F.
 ENDIF 

 cmd01  = "CREATE PROC seekpermis2 (@s_perm varchar(9)='', @n_perm varchar(8)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM permis2 WHERE s_perm=@s_perm AND n_perm=@n_perm; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekpermis2 не подготовлена!", 0+64, "seekpermis2")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekpermis2 не создана!", 0+64, "seekpermis2")
  RETURN .F.
 ENDIF 

 cmd01  = 'CREATE TABLE predst ' && OK!
 cmd02  = '(recid int not null, fam varchar(40), im varchar(40), ot varchar(40), c_doc dec(2), '
 cmd03  = 's_doc varchar(9), n_doc varchar(8), d_doc date, u_doc varchar(100), tel1 varchar(10), '
 cmd04  = 'tel2 varchar(10), inf varchar(100), created datetime default sysdatetime())'
 cmdAll = cmd01 + cmd02 + cmd03 + cmd04
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица predst не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO predst (recid,fam,im,ot,c_doc,s_doc,n_doc,d_doc,u_doc,tel1,tel2,inf) values ;
   (0,'','','',0,'','',NULL,NULL,'','','')")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into predst')
  ENDIF 
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE predst ADD CONSTRAINT pk_predst PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_predst не создан!", 0+64, "predst")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX fio ON predst (fam,im,ot)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс fio не создан!", 0+64, "predst")
  RETURN .F.
 ENDIF 

 cmd01  = "CREATE PROC seekpredst (@fam varchar(40)='', @im varchar(40)='', @ot varchar(40)='', @recid int=NULL out) as "
 cmd02  = "BEGIN SET NOCOUNT ON; SELECT recid FROM predst WHERE fam=@fam AND im=@im AND ot=@ot; END"
 cmdAll = cmd01 + cmd02

 IF SQLPREPARE(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekpredst не подготовлена!", 0+64, "seekpredst")
  RETURN .F.
 ENDIF 
 IF SQLEXEC(nHandl) =  -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура seekpredst не создана!", 0+64, "seekpredst")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE users (pv varchar(3), ucod int, id varchar(8), fam varchar(25), im varchar(20), ot varchar(20), ;
  kadr dec(1), created datetime default sysdatetime())' && OK!
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица users не создана!", 0+64, "")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX ucod ON users (ucod)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс ucod не создан!", 0+64, "users")
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE TABLE wrkpl (recid int identity(0,1) primary key, code varchar(3), name varchar(100), ;
  created datetime default sysdatetime())'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица wrkpl не создана!", 0+64, "")
  RETURN .F.
 ELSE 
  IF SQLEXEC(nHandl, "INSERT INTO wrkpl (code,name) values ('','')")=-1
   =AERROR(errarr)
   =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'insert into wrkpl')
  ENDIF 
 ENDIF 

 cmdAll = "CREATE INDEX name ON wrkpl (name)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс name не создан!", 0+64, "wrkpl")
  RETURN .F.
 ENDIF 

 cmd01  = 'CREATE TABLE kms '
 cmd02  = '(recid int not null, rrid int, act bit, pv varchar(3), nz varchar(5), status dec(1), p_doc dec(1), p_doc2 dec(1), '
 cmd03  = 'vs varchar(9), vs_data date, sn_card varchar(17), enp varchar(16), gz_data date, q varchar(2), dp date, dt date,  '
 cmd04  = 'fam varchar(40), d_type1 varchar(1), im varchar(40), d_type2 varchar(1), ot varchar(40), d_type3 varchar(1),'
 cmd05  = 'w Sex , check (w between 1 and 2), dr date, true_dr dec(1), adr_id int foreign key references adr77(recid),adr50_id int foreign key references adr50(recid),'
 cmd06  = 'jt varchar(1), scn varchar(3), kl dec(2), cont varchar(40), c_doc dec(2), s_doc varchar(9), n_doc varchar(8), d_doc date,'
 cmd07  = 'e_doc date, x_doc dec(1), u_doc varchar(250), snils varchar(14), gr varchar(3), mr varchar(250), d_reg date, form dec(1),'
 cmd08  = 'predst varchar(1), spos dec(1), d_type4 dec(1), coment varchar(250), ktg varchar(1), gzk_flag dec(1), doc_flag dec(1), uec_flag varchar(1),'
 cmd09  = 's_card2 varchar(12), n_card2 varchar(32), is2fio varchar(1), ofioid int foreign key references ofio(recid), is2doc varchar(1),'
 cmd10  = 'odocid int foreign key references odoc(recid), mcod varchar(7), oper int, operpv int, isrereg dec(1), osmoid int foreign key references osmo(recid),'
 cmd11  = 'permid int foreign key references permiss(recid), perm2id int foreign key references permis2(recid), enp2id int foreign key references enp2(recid), '
 cmd12  = 'predstid int foreign key references predst(recid), wrkid int, plant varchar(5), dpok date, blanc varchar(11), created datetime default sysdatetime())'
 cmdAll = cmd01 + cmd02 + cmd03 + cmd04 + cmd05 + cmd06+ cmd07 + cmd08 + cmd09 + cmd10 + cmd11 + cmd12

 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Таблица kms не создана!", 0+64, "")
  RETURN .F.
 ENDIF 

 IF SQLEXEC(nHandl, "ALTER TABLE kms ADD CONSTRAINT pk_kms PRIMARY KEY(recid)") = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Первичный ключ pk_kms не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX snils ON kms (snils)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс snils не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX fio ON kms (fam,im,ot)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс fio не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX adr_id ON kms (adr_id)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс adr_id не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX adr50_id ON kms (adr50_id)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс adr_id не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX ofioid ON kms (ofioid)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс ofioid не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX odocid ON kms (odocid)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс odocid не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX osmoid ON kms (osmoid)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс osmoid не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX permid ON kms (permid)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс permid не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX perm2id ON kms (perm2id)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс perm2id не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX enp2id ON kms (enp2id)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс enp2id не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmdAll = "CREATE INDEX predstid ON kms (predstid)"
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Индекс predstid не создан!", 0+64, "kms")
  RETURN .F.
 ENDIF 

 cmd01= "CREATE VIEW kmsview AS SELECT a.recid, a.act,a.pv,a.nz,a.status,a.p_doc,a.p_doc2,a.vs,a.vs_data,a.sn_card,a.enp,a.gz_data,a.q,a.dp,a.dt,a.fam,a.d_type1,"
 cmd02= "a.im,a.d_type2,a.ot,a.d_type3,a.w,a.dr,a.true_dr,a.adr_id,a.adr50_id,a.jt,a.scn,a.kl,a.cont,a.c_doc,a.s_doc,a.n_doc,a.d_doc,a.e_doc,a.x_doc,a.u_doc,"
 cmd03= "a.snils,a.gr,a.mr,a.d_reg,a.form,a.predst,a.spos,a.d_type4,a.coment,a.ktg,a.gzk_flag,a.doc_flag,a.uec_flag,a.s_card2,a.n_card2,a.is2fio,a.ofioid,"
 cmd04= "a.is2doc,a.odocid,a.mcod,a.oper,a.operpv,a.isrereg,a.osmoid,a.permid,a.perm2id,a.enp2id,a.predstid,a.wrkid,a.plant,a.dpok,a.blanc,"
 cmd05= "b.ul, b.dom, b.kor, b.str, b.kv, "
 cmd06= "c.c_okato as c_okato, c.ra_name as ra_name, c.np_c as np_c, c.np_name as np_name, c.ul_c as ul_c, c.ul_name as ul_name, "
 cmd07= "c.dom as dom2, c.kor as kor2, c.str as str2, c.kv as kv2, "
 cmd08= "d.fam as prfam, d.im as prim, d.ot as prot, d.c_doc as prc_doc, d.s_doc as prs_doc, d.n_doc as prn_doc, d.d_doc as prd_doc, "
 cmd09= "d.u_doc as prpodr, d.tel1 as prtel1, d.tel2 as prtel2, d.inf as prpinf, "
 cmd10= "e.enp as enp2, e.ogrn as ogrn_old2, e.okato as okato_old2, e.dp as dp_old2, "
 cmd11= "f.c_doc as oc_doc, f.s_doc as os_doc, f.n_doc as on_doc, f.d_doc as od_doc, f.e_doc as oe_doc, "
 cmd12= "g.fam as ofam, g.im as oim, g.ot as oot, g.w as ow, g.dr as odr, "
 cmd13= "h.ogrn as ogrn_old, h.okato as okato_old, h.dp as dp_old, "
 cmd14= "i.c_perm, i.s_perm, i.n_perm, i.d_perm, i.e_perm, "
 cmd15= "j.c_perm as c_perm2, j.s_perm as s_perm2, j.n_perm as n_perm2, j.d_perm as d_perm2, j.e_perm as e_perm2, "
 cmd16= "k.code as wrkcode, k.name as wrkname "
 cmd17= "FROM dbo.kms a "
 cmd18= "INNER JOIN dbo.adr77 b ON a.adr_id=b.recid INNER JOIN dbo.adr50 c ON a.adr50_id=c.recid "
 cmd19= "INNER JOIN dbo.predst d ON a.predstid=d.recid INNER JOIN dbo.enp2 e ON a.enp2id=e.recid "
 cmd20= "INNER JOIN dbo.odoc f ON a.odocid=f.recid INNER JOIN dbo.ofio g ON a.ofioid=g.recid "
 cmd21= "INNER JOIN dbo.osmo h ON a.osmoid=h.recid INNER JOIN dbo.permiss i ON a.permid=i.recid "
 cmd22= "INNER JOIN dbo.permis2 j ON a.perm2id=j.recid INNER JOIN dbo.wrkpl k ON a.wrkid=k.recid "
 
 CmdAll = cmd01+cmd02+cmd03+cmd04+cmd05+cmd06+cmd07+cmd08+cmd09+cmd10+;
  cmd11+cmd12+cmd13+cmd14+cmd15+cmd16+cmd17+cmd18+cmd19+cmd20+cmd21+cmd22

 IF SQLEXEC(nHandl, cmdAll) = -1
  =AERROR(errarr)
  =MESSAGEBOX(ALLTRIM(errarr(2)), 16, 'Cannot create view')
  =SQLDISCONNECT(nHandl)
  RETURN .F.
 ENDIF 

 cmdAll = 'CREATE PROC kmsAdd (@fam varchar(40), @im varchar(40), @ot varchar(40)) as ;
 BEGIN SET NOCOUNT ON; insert into kms (fam,im,ot) values (@fam, @im, @ot); END'
 IF SQLEXEC(nHandl, cmdAll) = -1
  =SQLDISCONNECT(nHandl)
  MESSAGEBOX("Процедура kmsAdd не создана!", 0+64, "")
  RETURN .F.
 ENDIF 

RETURN .T.