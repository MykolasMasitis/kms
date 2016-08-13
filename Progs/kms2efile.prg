PROCEDURE kms2efile
 IF MESSAGEBOX("ÂÛ ÕÎÒÈÒÅ ÑÔÎÐÌÈÐÎÂÀÒÜ ÎÁÌÅÍÍÍÛÉ ÔÀÉË?"+CHR(13)+CHR(10),4+32,"") == 7
  RETURN
 ENDIF

 IF OpenFile(pBase+'\'+pvid(1,1)+'\kms', 'kms', 'shar', 'recid')>0
  CLOSE TABLES ALL 
  RETURN 
 ENDIF 
 IF OpenFile(pBase+'\'+pvid(1,1)+'\ofio', 'ofio', 'shar', 'recid')>0
  CLOSE TABLES ALL 
  RETURN 
 ENDIF 
 IF OpenFile(pBase+'\'+pvid(1,1)+'\odoc', 'odoc', 'shar', 'recid')>0
  CLOSE TABLES ALL 
  RETURN 
 ENDIF 
 m.lIsAdr77 = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\adr77.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\adr77', 'adr77', 'shar', 'recid')>0
  ELSE 
   m.lIsAdr77 = .t.
  ENDIF 
 ENDIF 
 m.lIsAdr50 = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\adr50.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\adr50', 'adr50', 'shar', 'recid')>0
  ELSE 
   m.lIsAdr50 = .t.
  ENDIF 
 ENDIF 
 m.lIsEnp2 = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\enp2.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\enp2', 'enp2', 'shar', 'recid')>0
  ELSE 
   m.lIsEnp2 = .t.
  ENDIF 
 ENDIF 
 m.lIsPermiss = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\permiss.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\permiss', 'permiss', 'shar', 'recid')>0
  ELSE 
   m.lIsPermiss = .t.
  ENDIF 
 ENDIF 
 m.lIsPermis2 = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\permis2.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\permis2', 'permis2', 'shar', 'recid')>0
  ELSE 
   m.lIsPermiss = .t.
  ENDIF 
 ENDIF 
 m.lIsOSMO = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\osmo.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\osmo', 'osmo', 'shar', 'recid')>0
  ELSE 
   m.lIsOSMO = .t.
  ENDIF 
 ENDIF 
 m.lIsPredst = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\predst.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\predst', 'predst', 'shar', 'recid')>0
  ELSE 
   m.lIsPredst = .t.
  ENDIF 
 ENDIF 
 m.lIsWrkPl = .f.
 IF fso.FileExists(pBase+'\'+pvid(1,1)+'\wrkpl.dbf')
  IF OpenFile(pBase+'\'+pvid(1,1)+'\wrkpl', 'wrkpl', 'shar', 'recid')>0
  ELSE 
   m.lIsWrkPl = .t.
  ENDIF 
 ENDIF 

 SELECT kms
 IF m.lIsAdr77 = .t.
  SET RELATION TO adr_id INTO adr77
 ENDIF 
 IF m.lIsAdr50 = .t.
  SET RELATION TO adr50_id INTO adr50 ADDITIVE 
 ENDIF 
 IF m.lIsEnp2 = .t.
  SET RELATION TO enp2id INTO enp2 ADDITIVE 
 ENDIF 
 IF m.lIsPermiss = .t.
  SET RELATION TO permid INTO permiss ADDITIVE 
 ENDIF 
 IF m.lIsPermis2 = .t.
  SET RELATION TO perm2id INTO permis2 ADDITIVE 
 ENDIF 
 IF m.lIsOSMO = .t.
  SET RELATION TO osmoid INTO osmo ADDITIVE 
 ENDIF 
 IF m.lIsPredst = .t.
  SET RELATION TO predstid INTO predst ADDITIVE 
 ENDIF 
 IF m.lIsWrkPl = .t.
  SET RELATION TO wrkid INTO wrkpl ADDITIVE 
 ENDIF 
 SET RELATION TO ofioid INTO ofio ADDITIVE 
 SET RELATION TO odocid INTO odoc ADDITIVE 
 
* CALCULATE FOR Status == 1 AND jt!='r' MIN(dp), MAX(dp) TO m.t_gdCurDat1, m.t_gdCurDat2
 CALCULATE FOR Status == 1 AND scn!='POK' AND !EMPTY(dp) MIN(dp), MAX(dp) TO m.t_gdCurDat1, m.t_gdCurDat2
 m.t_count = _tally
 
 IF m.t_count>0

 ELSE 
  IF MESSAGEBOX('ÍÅ ÎÁÍÀÐÓÆÅÍÎ ÍÈ ÎÄÍÎÃÎ ÏÎËÈÑÀ ÍÀ ÈÇÃÎÒÎÂËÅÍÈÅ!'+CHR(13)+CHR(10)+;
   'ÎÒÎÁÐÀÒÜ Â ÎÒ×ÅÒ ÂÛÄÀÍÍÛÅ ÍÀ ÐÓÊÈ ÏÎËÈÑÛ?',4+32,'')=6
   CALCULATE FOR Status == 1 AND scn='POK' AND !EMPTY(dp) MIN(dp), MAX(dp) TO m.t_gdCurDat1, m.t_gdCurDat2
*   m.IsChkd = .f.
*   DO FORM TuneUp TO m.IsChkd
*   IF m.IsChkd = .f.
*    CLOSE TABLES ALL 
*    RETURN 
*   ELSE 
*    m.t_gdCurDat1 = gdCurDat1
*    m.t_gdCurDat2 = gdCurDat2
*   ENDIF 
  ELSE 
   CLOSE TABLES ALL 
   RETURN 
  ENDIF 
 ENDIF 

* COUNT FOR jt='r' AND BETWEEN(dp, m.t_gdCurDat1, m.t_gdCurDat2) TO m.nKolOfR
* COUNT FOR scn='POK' AND BETWEEN(dp, m.t_gdCurDat1, m.t_gdCurDat2) TO m.nKolOfR
 COUNT FOR Status=1 AND scn='POK' TO m.nKolOfR
 m.t_count = m.t_count + m.nKolOfR

* MESSAGEBOX(TRANSFORM(m.nKolOfR,'999999'),0+64,'')
 
 IF m.t_count > 0
  m.gdCurDat1 = m.t_gdCurDat1
  m.gdCurDat2 = m.t_gdCurDat2
  =MESSAGEBOX("ÎÁÍÀÐÓÆÅÍÎ "+ALLTRIM(STR(m.t_count))+" ÍÅÏÎÄÀÍÍÛÕ ÇÀÏÈÑÅÉ"+CHR(13)+;
   "ÇÀ ÏÅÐÈÎÄ Ñ " + DTOC(m.t_gdCurDat1) + " ÏÎ " + DTOC(m.t_gdCurDat2)+".",0+64,"")
 ELSE 
  =MESSAGEBOX("ÍÅ ÎÁÍÀÐÓÆÅÍÎ ÍÅÏÎÄÀÍÍÛÕ ÐÀÍÅÅ ÇÀÏÈÑÅÉ!", 0+64, "")
  CLOSE TABLES ALL 
  RETURN 
 ENDIF 
 
 ExpFileName = 'e'+pvid(1,1)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat1),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat1),'.',''),2)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat2),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat2),'.',''),2)
 DbfFileName = 'e'+pvid(1,1)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat1),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat1),'.',''),2)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat2),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat2),'.',''),2)+'.dbf'
 BakFileName = 'e'+pvid(1,1)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat1),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat1),'.',''),2)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat2),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat2),'.',''),2)+'.bak'
 TbkFileName = 'e'+pvid(1,1)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat1),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat1),'.',''),2)+'_'+;
  LEFT(STRTRAN(DTOC(m.gdCurDat2),'.',''),4)+RIGHT(STRTRAN(DTOC(m.gdCurDat2),'.',''),2)+'.tbk'

 IF FILE('&PExpImp\&DbfFileName ')
  IF MESSAGEBOX("Ôàéë ýêñïîðòà çà äàííûé ïåðèîä óæå ñôîðìèðîâàí!"+CHR(13)+;
  "Õîòèòå ñôîðìèðîâàòü åãî çàíîâî?",4+32,"") != 6
   CLOSE TABLES ALL 
   RETURN
  ENDIF
 ENDIF 

 WAIT "ÔÎÐÌÈÐÓÅÒÑß ÔÀÉË ÝÊÑÏÎÐÒÀ, ÆÄÈÒÅ..." WINDOW NOWAIT 

 CREATE CURSOR curfiles (names c(20))
 
 SELECT kms
 COPY STRUCTURE TO &PExpImp\&ExpFileName 
 
 =OpenFile(PExpImp+'\'+ExpFileName+'.dbf', 'expkms', 'excl')
 SELECT expkms
 ALTER TABLE expkms DROP COLUMN recid
 ALTER TABLE expkms DROP COLUMN ofioid
 ALTER TABLE expkms DROP COLUMN odocid
 ALTER TABLE expkms DROP COLUMN osmoid
 ALTER TABLE expkms DROP COLUMN enp2id
 ALTER TABLE expkms DROP COLUMN permid
 ALTER TABLE expkms DROP COLUMN perm2id
 ALTER TABLE expkms DROP COLUMN predstid
 ALTER TABLE expkms DROP COLUMN wrkid
 ALTER TABLE expkms DROP COLUMN adr_id
 ALTER TABLE expkms DROP COLUMN adr50_id
 ALTER TABLE expkms ADD COLUMN recid_pv i
 ALTER TABLE expkms ADD COLUMN recid_smo i
 IF FIELD('ul')!='UL'
  ALTER TABLE expkms ADD COLUMN ul n(5)
 ENDIF 
 IF FIELD('d')!='D'
  ALTER TABLE expkms ADD COLUMN d c(7)
 ENDIF 
 IF FIELD('kor')!='KOR'
  ALTER TABLE expkms ADD COLUMN kor c(5)
 ENDIF 
 IF FIELD('str')!='STR'
  ALTER TABLE expkms ADD COLUMN str c(5)
 ENDIF 
 IF FIELD('kv')!='KV'
  ALTER TABLE expkms ADD COLUMN kv c(5)
 ENDIF 
 IF FIELD('c_okato')!='C_OKATO'
  ALTER TABLE expkms ADD COLUMN c_okato c(5)
 ENDIF 
 IF FIELD('ra_name')!='RA_NAME'
  ALTER TABLE expkms ADD COLUMN ra_name c(60)
 ENDIF 
 IF FIELD('np_c')!='NP_C'
  ALTER TABLE expkms ADD COLUMN np_c c(2)
 ENDIF 
 IF FIELD('np_name')!='NP_NAME'
  ALTER TABLE expkms ADD COLUMN np_name c(60)
 ENDIF 
 IF FIELD('ul_c')!='UL_C'
  ALTER TABLE expkms ADD COLUMN ul_c c(2)
 ENDIF 
 IF FIELD('ul_name')!='UL_NAME'
  ALTER TABLE expkms ADD COLUMN ul_name c(60)
 ENDIF 
 IF FIELD('dom2')!='DOM2'
  ALTER TABLE expkms ADD COLUMN dom2 c(7)
 ENDIF 
 IF FIELD('kor2')!='KOR2'
  ALTER TABLE expkms ADD COLUMN kor2 c(5)
 ENDIF 
 IF FIELD('str2')!='STR2'
  ALTER TABLE expkms ADD COLUMN str2 c(5)
 ENDIF 
 IF FIELD('kv2')!='KV2'
  ALTER TABLE expkms ADD COLUMN kv2 c(5)
 ENDIF 
 IF FIELD('enp2')!='ENP2'
  ALTER TABLE expkms ADD COLUMN enp2 c(16)
 ENDIF 
 IF FIELD('ogrn_old2')!='OGRN_OLD2'
  ALTER TABLE expkms ADD COLUMN ogrn_old2 c(13)
 ENDIF 
 IF FIELD('okato_old2')!='OKATO_OLD2'
  ALTER TABLE expkms ADD COLUMN okato_old2 c(5)
 ENDIF 
 IF FIELD('dp_old2')!='DP_OLD2'
  ALTER TABLE expkms ADD COLUMN dp_old2 d
 ENDIF 
 IF FIELD('c_perm')!='C_PERM'
  ALTER TABLE expkms ADD COLUMN c_perm n(2)
 ENDIF 
 IF FIELD('s_perm')!='S_PERM'
  ALTER TABLE expkms ADD COLUMN s_perm c(9)
 ENDIF 
 IF FIELD('n_perm')!='N_PERM'
  ALTER TABLE expkms ADD COLUMN n_perm c(8)
 ENDIF 
 IF FIELD('d_perm')!='D_PERM'
  ALTER TABLE expkms ADD COLUMN d_perm d
 ENDIF 
 IF FIELD('c_perm2')!='C_PERM2'
  ALTER TABLE expkms ADD COLUMN c_perm2 n(2)
 ENDIF 
 IF FIELD('s_perm2')!='S_PERM2'
  ALTER TABLE expkms ADD COLUMN s_perm2 c(9)
 ENDIF 
 IF FIELD('n_perm2')!='N_PERM2'
  ALTER TABLE expkms ADD COLUMN n_perm2 c(8)
 ENDIF 
 IF FIELD('d_perm2')!='D_PERM2'
  ALTER TABLE expkms ADD COLUMN d_perm2 d
 ENDIF 
 IF FIELD('ogrn_old')!='OGRN_OLD'
  ALTER TABLE expkms ADD COLUMN ogrn_old c(13)
 ENDIF 
 IF FIELD('okato_old')!='OKATO_OLD'
  ALTER TABLE expkms ADD COLUMN okato_old c(5)
 ENDIF 
 IF FIELD('dp_old')!='DP_OLD'
  ALTER TABLE expkms ADD COLUMN dp_old d
 ENDIF 
 IF FIELD('ofam')!='OFAM'
  ALTER TABLE expkms ADD COLUMN ofam c(40)
 ENDIF 
 IF FIELD('oim')!='OIM'
  ALTER TABLE expkms ADD COLUMN oim c(40)
 ENDIF 
 IF FIELD('oot')!='OOT'
  ALTER TABLE expkms ADD COLUMN oot c(40)
 ENDIF 
 IF FIELD('odr')!='ODR'
  ALTER TABLE expkms ADD COLUMN odr d
 ENDIF 
 IF FIELD('ow')!='OW'
  ALTER TABLE expkms ADD COLUMN ow n(1)
 ENDIF 
 IF FIELD('oc_doc')!='OC_DOC'
  ALTER TABLE expkms ADD COLUMN oc_doc n(2)
 ENDIF 
 IF FIELD('os_doc')!='OS_DOC'
  ALTER TABLE expkms ADD COLUMN os_doc c(9)
 ENDIF 
 IF FIELD('on_doc')!='ON_DOC'
  ALTER TABLE expkms ADD COLUMN on_doc c(8)
 ENDIF 
 IF FIELD('od_doc')!='OD_DOC'
  ALTER TABLE expkms ADD COLUMN od_doc d
 ENDIF 
 ALTER TABLE expkms ADD COLUMN prfam c(40)
 ALTER TABLE expkms ADD COLUMN "prim" c(40)
 ALTER TABLE expkms ADD COLUMN "prot" c(40)
 ALTER TABLE expkms ADD COLUMN prc_doc n(2)
 ALTER TABLE expkms ADD COLUMN prs_doc c(9)
 ALTER TABLE expkms ADD COLUMN prn_doc c(8)
 ALTER TABLE expkms ADD COLUMN prd_doc d
 ALTER TABLE expkms ADD COLUMN prpodr c(100)
 ALTER TABLE expkms ADD COLUMN prtel1 c(10)
 ALTER TABLE expkms ADD COLUMN prtel2 c(10)
 ALTER TABLE expkms ADD COLUMN prpinf c(100)
 ALTER TABLE expkms ADD COLUMN wrkcode c(3)
 ALTER TABLE expkms ADD COLUMN wrkname c(100)
 
 DELETE FILE &PExpImp\&BakFileName
 DELETE FILE &PExpImp\&TbkFileName

 SELECT kms
 SCAN
  SCATTER MEMVAR MEMO 
  m.recid_pv = m.recid
  m.ofam = ofio.fam
  m.oim  = ofio.im
  m.oot  = ofio.ot 
  m.odr  = ofio.dr
  m.ow   = ofio.w
  m.oc_doc = odoc.c_doc
  m.os_doc = odoc.s_doc
  m.on_doc = odoc.n_doc
  m.od_doc = odoc.d_doc
  IF m.lIsAdr77 = .t.
   m.ul  = adr77.ul
   m.d   = adr77.d
   m.kor = adr77.kor
   m.str = adr77.str
   m.kv  = adr77.kv
  ENDIF 
  IF m.lIsAdr50 = .t.
   m.c_okato  = adr50.c_okato
   m.ra_name  = ALLTRIM(adr50.ra_name)
   m.np_c     = adr50.np_c
   m.np_name  = ALLTRIM(adr50.np_name)
   m.ul_name  = ALLTRIM(adr50.ul_name)
   m.dom2     = ALLTRIM(adr50.dom)
   m.kor2     = ALLTRIM(adr50.kor)
   m.str2     = ALLTRIM(adr50.str)
   m.kv2      = ALLTRIM(adr50.kv)
  ENDIF 
  IF m.lIsEnp2 = .t.
   m.enp2       = enp2.enp
   m.ogrn_old2  = enp2.ogrn
   m.okato_old2 = enp2.okato
   m.dp_old2    = enp2.dp
  ENDIF 
  IF m.lIsPermiss = .t.
   m.c_perm = permiss.c_perm
   m.s_perm = permiss.s_perm
   m.n_perm = permiss.n_perm
   m.d_perm = permiss.d_perm
  ENDIF 
  IF m.lIsPermis2 = .t.
   m.c_perm2 = permis2.c_perm
   m.s_perm2 = permis2.s_perm
   m.n_perm2 = permis2.n_perm
   m.d_perm2 = permis2.d_perm
  ENDIF 
  IF m.lIsOSMO = .t.
   m.ogrn_old  = osmo.ogrn
   m.okato_old = osmo.okato
   m.dp_old    = osmo.dp
  ENDIF 
  IF m.lIsPredst = .t.
   m.prfam = predst.fam
   m.prim = predst.im
   m.prot = predst.ot
   m.prc_doc = predst.c_doc
   m.prs_doc = predst.s_doc
   m.prn_doc = predst.n_doc
   m.prd_doc = predst.d_doc
   m.prpodr  = predst.podr_doc
   m.prtel1 = predst.tel1
   m.prtel2 = predst.tel2
  ENDIF 
  IF m.lIsWrkPl = .t.
   m.wrkcode = wrkpl.code
   m.wrkname = wrkpl.name
  ENDIF 
*  IF (Status == 1 AND jt!='r') OR (jt='r' AND BETWEEN(dp, m.t_gdCurDat1, m.t_gdCurDat2))
*  IF (Status == 1 AND scn!='POK') OR (scn='POK' AND BETWEEN(dp, m.t_gdCurDat1, m.t_gdCurDat2))
  IF (Status == 1 AND scn!='POK') OR (scn='POK' AND Status == 1)

   IF m.form=2
    m.pv = pvid(1,1)
    m.f_file = 'f'+PADL(m.recid,6,'0')
    IF fso.FileExists(pbase+'\'+m.pv+'\jpeg\'+m.f_file+'.jpg')
     IF fso.FileExists(pExpImp+'\'+m.f_file+'.jpg')
      fso.DeleteFile(PExpImp+'\'+m.f_file+'.jpg')
     ENDIF 
     fso.CopyFile(pbase+'\'+m.pv+'\jpeg\'+m.f_file+'.jpg', PExpImp+'\'+m.f_file+'.jpg')
     INSERT INTO curfiles (names) VALUES (m.f_file+'.jpg')
    ENDIF 

    m.s_file = 's'+PADL(m.recid,6,'0')
    IF fso.FileExists(pbase+'\'+m.pv+'\jpeg\'+m.s_file+'.jpg')
     IF fso.FileExists(PExpImp+'\'+m.s_file+'.jpg')
      fso.DeleteFile(PExpImp+'\'+m.s_file+'.jpg')
     ENDIF 
     fso.CopyFile(pbase+'\'+m.pv+'\jpeg\'+m.s_file+'.jpg', PExpImp+'\'+m.s_file+'.jpg')
     INSERT INTO curfiles (names) VALUES (m.s_file+'.jpg')
    ENDIF 
   ENDIF 

   INSERT INTO expkms FROM MEMVAR 
   REPLACE Status WITH 2
  ENDIF 


 ENDSCAN 
 SET RELATION OFF INTO ofio
 SET RELATION OFF INTO odoc
 IF m.lIsAdr77 = .t.
  SET RELATION OFF INTO adr77
 ENDIF 
 IF m.lIsAdr50 = .t.
  SET RELATION OFF INTO adr50
 ENDIF 
 IF m.lIsEnp2 = .t.
  SET RELATION OFF INTO enp2
 ENDIF 
 IF m.lIsPermiss = .t.
  SET RELATION OFF INTO permiss
 ENDIF 
 IF m.lIsPermis2 = .t.
  SET RELATION OFF INTO permis2
 ENDIF 
 IF m.lIsWrkPl = .t.
  SET RELATION OFF INTO wrkpl
 ENDIF 
 IF m.lIsOSMO = .t.
  SET RELATION OFF INTO osmo
 ENDIF 
 IF m.lIsPredst = .t.
  SET RELATION OFF INTO predst
 ENDIF 
 USE 
 IF USED('adr77')
  USE IN adr77
 ENDIF 
 IF USED('adr50')
  USE IN adr50
 ENDIF 
 IF USED('enp2')
  USE IN enp2
 ENDIF 
 IF USED('permiss')
  USE IN permiss
 ENDIF 
 IF USED('permis2')
  USE IN permis2
 ENDIF 
 IF USED('wrkpl')
  USE IN wrkpl
 ENDIF 
 IF USED('osmo')
  USE IN osmo
 ENDIF 
 IF USED('predst')
  USE IN predst
 ENDIF 
 
 ExpUser = pExpImp+'\User'+pvid(1,1)
 CREATE TABLE (ExpUser) ;
 (pv c(3), ucod i, id c(8), fam c(25), im c(20), ot c(20), kadr n(1))
 USE 
 IF !USED('user')
 =OpenFile(pbase+'\'+pvid(1,1)+'\User', 'User', 'shar')
 ENDIF 
 =OpenFile(pExpImp+'\User'+pvid(1,1)+'.dbf', 'UUser', 'shar')
 
 SELECT User
 SCAN 
  SCATTER MEMVAR 
  INSERT INTO UUser FROM MEMVAR 
 ENDSCAN 
 USE 
 USE IN UUser
 
 SELECT jt, coun(*) AS cnt GROUP BY jt FROM expkms INTO CURSOR cur_st
 USE IN expkms

 ZipName = m.ExpFileName +'.zip'
 ZipOpen(ZipName, pExpImp+'\', .T.)
 ZipFile(pExpImp+'\'+m.ExpFileName+'.dbf', .T.)
 ZipFile(pExpImp+'\'+m.ExpFileName+'.fpt', .T.)
 ZipFile(pExpImp+'\User'+pvid(1,1)+'.dbf', .T.)
 IF RECCOUNT('curfiles')>0
  SELECT curfiles
*  BROWSE 
  SCAN 
   m.jpgname = ALLTRIM(names)
   IF fso.FileExists(pExpImp+'\'+m.jpgname)
    ZipFile(pExpImp+'\'+m.jpgname, .T.)
   ENDIF 
  ENDSCAN 
 ENDIF 
 ZipClose()

 USE &PCommon\jt IN 0 SHARE ALIAS jt_spr ORDER jt 
 SELECT cur_st
 SET RELATION TO jt INTO jt_spr
 
 SUM cnt TO total_recs
 SUM FOR jt_spr.izgt = .t. TO total_izgt
 
 REPORT FORM expfpsp PREVIEW  
 
 SET RELATION OFF INTO jt_spr
 USE 
 USE IN jt_spr

 CLOSE TABLES ALL 

 WAIT CLEAR 

RETURN 