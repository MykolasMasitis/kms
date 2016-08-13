FUNCTION FormPFile(TipRpt) && 1-ïî äàòå, 2-ïî ñòàòóñó
 
 IF MESSAGEBOX("ÂÛ ÕÎÒÈÒÅ ÑÔÎÐÌÈÐÎÂÀÒÜ Î×ÅÐÅÄÍÓÞ ÇÀßÂÊÓ"+CHR(13)+CHR(10)+;
  IIF(TipRpt=1, "ÏÎ ÄÀÒÅ?", "ÏÎ ÑÒÀÒÓÑÓ?")+CHR(13)+CHR(10),4+32,'') == 7
  RETURN
 ENDIF
 
 IF TipRpt==1
  tResult = .f.
  DO FORM TuneUp TO tResult
  IF !tResult
   RETURN 
  ENDIF 
 ENDIF 
 
 IF OpFiles()>0
  =ClFiles()
  RETURN 
 ENDIF 

 yearmmdd = STR(YEAR(DATE()),4) + PADL(MONTH(DATE()),2,'0') + PADL(DAY(DATE()),2,'0')
 ymmdd    = SUBSTR(yearmmdd,4)

 m.fioFilen = 'pers' + qcod + ymmdd + '.dbf'
 m.docFilen = 'docu' + qcod + ymmdd + '.dbf'
 m.adrFilen = 'addr' + qcod + ymmdd + '.dbf'

 tcDirPath = POut + '\' + yearmmdd
	
 IF !fso.FolderExists(tcDirPath)
  fso.CreateFolder(tcDirPath)
 ENDIF 

 IF FILE('&tcDirPath\&fioFilen') AND FILE('&tcDirPath\&docFilen') AND FILE('&tcDirPath\&adrFilen')
  FOR tParam = 1 TO 999
   bfioFile    = 'pers' + qcod + ymmdd + '.'+PADL(tParam,3,'0')
   IF !FILE('&tcDirPath\&bfioFile')
    EXIT 
   ENDIF 
  ENDFOR 

  RENAME &tcDirPath\&fioFilen TO &tcDirPath\&bfioFile

  FOR tParam = 1 TO 999
   bdocFile    = 'docu' + qcod + ymmdd + '.'+PADL(tParam,3,'0')
   IF !FILE('&tcDirPath\&bdocFile')
	EXIT 
   ENDIF 
  ENDFOR 

  RENAME &tcDirPath\&docFilen TO &tcDirPath\&bdocFile

  FOR tParam = 1 TO 999
   badrFile    = 'addr' + qcod + ymmdd + '.'+PADL(tParam,3,'0')
   IF !FILE('&tcDirPath\&badrFile')
	EXIT 
   ENDIF 
  ENDFOR 

  RENAME &tcDirPath\&adrFilen TO &tcDirPath\&badrFile

 ENDIF

 fso.CopyFile(PTempl+'\persqqymmdd.dbf', tcDirPath+'\'+m.fioFilen)
 fso.CopyFile(PTempl+'\docuqqymmdd.dbf', tcDirPath+'\'+m.docFilen)
 fso.CopyFile(PTempl+'\addrqqymmdd.dbf', tcDirPath+'\'+m.adrFilen)

 oprslt = 0
 oprslt = oprslt + OpenFile(tcDirPath+'\'+m.fioFilen, 'fioFilen', 'shar')
 oprslt = oprslt + OpenFile(tcDirPath+'\'+m.docFilen, 'docFilen', 'shar')
 oprslt = oprslt + OpenFile(tcDirPath+'\'+m.adrFilen, 'adrFilen', 'shar')
 IF oprslt>0
  IF USED('fioFilen')
   USE IN fioFilen
  ENDIF 
  IF USED('docFilen')
   USE IN docFilen
  ENDIF 
  IF USED('adrFilen')
   USE IN adrFilen
  ENDIF 
  =ClFiles()
  RETURN 
 ENDIF 

 ZipName  = 'a' + m.qcod + ymmdd +'.zip'
 ZipNameN = 'g' + m.qcod + ymmdd +'.zip'
 
 ZipOpen(ZipName, tcDirPath+'\', .T.)
 
 CREATE CURSOR wrkrslt (pv c(3), nrecs n(11,2), dat1 d, dat2 d)
 CREATE CURSOR curdata (rcid i AUTOINC, pv c(3), vs c(9),sn_card c(17),enp c(16),jt c(1),;
  fam c(25), im c(20), ot c(20), dp d) 
 INDEX on rcid TAG rcid CANDIDATE 
 INDEX ON pv TAG pv 
 INDEX ON vs TAG vs
 INDEX ON sn_card TAG sn_card
 INDEX ON enp TAG enp 
 INDEX ON jt TAG jt
 INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30)) TAG  fio COLLATE "Russian"
 INDEX ON dp TAG dp

 FOR num_pv=1 TO kol_pv

  WAIT "ÔÎÐÌÈÐÎÂÀÍÈÅ ÎÒ×ÅÒÀ ÏÎ ÏÂ "+pvid(num_pv,1)+"..." WINDOW NOWAIT 
  
  IF !fso.FileExists(PBase+'\'+pvid(num_pv,1)+'\moves.dbf')
   CREATE TABLE &PBase\&pvid(num_pv,1)\moves (et c(1), recid i autoinc, fname c(25), mkdate t, kmsid i, frecid c(6), ;
    vs c(9), s_card c(6), n_card n(10), c_okato c(5), enp c(16), dp d, jt c(1), ;
    pricin c(3), tranz c(3), q c(2), err c(5), err_text c(250), ans_fl c(2), nz n(3), n_kor n(6))
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON kmsid TAG kmsid
   INDEX ON fname+frecid TAG unik
   USE 
  ENDIF

  IF OpFilesPv(num_pv)>0
   =ClFilesPv(num_pv)
   LOOP 
  ENDIF 

  m.fioFile = 'fio' + qcod + pvid(num_pv,1)+ ymmdd + '.dbf'
  m.docFile = 'doc' + qcod + pvid(num_pv,1)+ ymmdd + '.dbf'
  m.adrFile = 'adr' + qcod + pvid(num_pv,1)+ ymmdd + '.dbf'

  IF FILE('&tcDirPath\&fioFile') AND FILE('&tcDirPath\&docFile') AND FILE('&tcDirPath\&adrFile')
   IF MESSAGEBOX("Äàííûé îò÷åò óæå ôîðìèðîâàëñÿ!"+CHR(13)+"Ñôîðìèðîâàòü åãî çàíîâî?",4+32,;
	              "Ïîäòâåðäèòå Âàøè äåéñòâèÿ!") == 7
    RETURN 
   ELSE
	FOR tParam = 1 TO 999
	 bfioFile    = 'fio' + qcod + pvid(num_pv,1) + ymmdd + '.'+PADL(tParam,3,'0')
	 IF !FILE('&tcDirPath\&bfioFile')
	  EXIT 
	 ENDIF 
	ENDFOR 

	RENAME &tcDirPath\&fioFile TO &tcDirPath\&bfioFile

	FOR tParam = 1 TO 999
	 bdocFile    = 'doc' + qcod + pvid(num_pv,1) + ymmdd + '.'+PADL(tParam,3,'0')
	 IF !FILE('&tcDirPath\&bdocFile')
	  EXIT 
	 ENDIF 
	ENDFOR 

	RENAME &tcDirPath\&docFile TO &tcDirPath\&bdocFile

	FOR tParam = 1 TO 999
	 badrFile    = 'adr' + qcod + pvid(num_pv,1) + ymmdd + '.'+PADL(tParam,3,'0')
	 IF !FILE('&tcDirPath\&badrFile')
	  EXIT 
	 ENDIF 
	ENDFOR 

	RENAME &tcDirPath\&adrFile TO &tcDirPath\&badrFile

   ENDIF 
  ENDIF

  fso.CopyFile(PTempl+'\fiofile.dbf', tcDirPath+'\'+m.fioFile)
  fso.CopyFile(PTempl+'\docfile.dbf', tcDirPath+'\'+m.docFile)
  fso.CopyFile(PTempl+'\adrfile.dbf', tcDirPath+'\'+m.adrFile)
	
  oprslt = 0
  oprslt = oprslt + OpenFile(tcDirPath+'\'+m.fioFile, 'fioFile', 'shar')
  oprslt = oprslt + OpenFile(tcDirPath+'\'+m.docFile, 'docFile', 'shar')
  oprslt = oprslt + OpenFile(tcDirPath+'\'+m.adrFile, 'adrFile', 'shar')
  IF oprslt>0
   IF USED('fioFile')
    USE IN fioFile
   ENDIF 
   IF USED('docFile')
    USE IN docFile
   ENDIF 
   IF USED('adrFile')
    USE IN adrFile
   ENDIF 
   LOOP 
  ENDIF 

  SELECT adr50
  SET RELATION TO np_c INTO CityType
  SET RELATION TO c_okato INTO okato ADDITIVE 
  SELECT kms
  SET RELATION TO jt INTO jt ADDITIVE 
  SET RELATION TO adr_id INTO adr77 ADDITIVE 
  SET RELATION TO adr50_id INTO adr50 ADDITIVE 
  SET RELATION TO enp2id INTO enp2 ADDITIVE 
  SET RELATION TO permid INTO permiss ADDITIVE 
  SET RELATION TO ofioid INTO ofio ADDITIVE 
  SET RELATION TO odocid INTO odoc ADDITIVE 
  SET RELATION TO osmoid INTO osmo ADDITIVE 	
	
  m.nrecs = 0
  m.dat1 = {31.12.2999}
  m.dat2 = {01.01.1000}
  
  m.nepodb = 0
  m.IsNeedR = .F.
  m.IsChkd = .f.
  COUNT FOR !EMPTY(Fam) AND IIF(TipRpt==2, Status == 1, BETWEEN(dp, gdCurDat1, gdCurDat2)) TO m.nepodb
  IF m.nepodb = 0
   IF MESSAGEBOX('ÍÅ ÎÁÍÀÐÓÆÅÍÎ ÍÈ ÎÄÍÎÃÎ ÏÎËÈÑÀ ÍÀ ÈÇÃÎÒÎÂËÅÍÈÅ!'+CHR(13)+CHR(10)+;
    'ÎÒÎÁÐÀÒÜ Â ÎÒ×ÅÒ ÂÛÄÀÍÍÛÅ ÍÀ ÐÓÊÈ ÏÎËÈÑÛ',4+32,'')=6
    m.IsNeedR = .T.
    m.IsChkd = .f.
    DO FORM TuneUp TO m.IsChkd
   ENDIF 
  ENDIF 
  
  SCAN FOR IIF(m.IsChkd = .f., !EMPTY(Fam) AND ;
   IIF(TipRpt==2, Status == 1, BETWEEN(dp, gdCurDat1, gdCurDat2)), ;
   jt='r' AND BETWEEN(dp, gdCurDat1, gdCurDat2))

   SCATTER FIELDS EXCEPT fiofile MEMVAR memo 

   m.dt = IIF(m.dt={31.12.9999}, {31.12.2099}, m.dt)
   
   m.dat1 = MIN(m.dat1, m.dp)
   m.dat2 = MAX(m.dat2, m.dp)
	 
   m.recid = PADL(m.recid,6,'0')
   m.pv    = pvid(num_pv,1)

   IF LEFT(m.sn_card,2)=m.qcod
    m.s_card = IIF(!EMPTY(m.sn_card), LEFT(sn_card,5), '')
    m.n_card = IIF(!EMPTY(m.sn_card), INT(VAL(SUBSTR(sn_card,7))), 0)
   ELSE 
    m.s_card = IIF(!EMPTY(m.sn_card), LEFT(sn_card,6), '')
    m.n_card = IIF(!EMPTY(m.sn_card), INT(VAL(SUBSTR(sn_card,8))), 0)
   ENDIF 

   m.kl = PADL(m.kl,2,'0')
   m.q  = qcod
    
   DO CASE 
    CASE m.true_dr == 1
     m.dr = DTOS(m.dr)
    CASE m.true_dr == 2
     m.dr = STR(YEAR(m.dr),4) + PADL(MONTH(m.dr),2,'0')
    CASE m.true_dr == 3
     m.dr = STR(YEAR(m.dr),4)
    OTHERWISE 
     m.dr = DTOS(m.dr)
   ENDCASE 

   m.lpu_id = pvid(num_pv,4)
   m.predst = INT(val(m.predst))
   m.ul     = adr77.ul
   m.d      = adr77.d
   m.kor    = adr77.kor
   m.str    = adr77.str
   m.kv     = adr77.kv
   m.adr_msk = adr77.ul
   m.pricin = IIF(m.jt != 'r', m.pricin, '')
   m.tranz  = IIF(m.jt != 'r', m.tranz, '')
   IF m.jt!='d'
    m.dt     = IIF(m.dt != {31.12.2099} AND !BETWEEN(m.dt, DATE(), DATE()+5*365), {31.12.2099}, m.dt)
   ENDIF 
   
   m.c_perm = permiss.c_perm
   m.s_perm = permiss.s_perm
   m.n_perm = permiss.n_perm
   m.d_perm = permiss.d_perm
   
   m.ofam = ofio.fam
   m.oim  = ofio.im
   m.oot  = ofio.ot
   m.odr  = ofio.dr
   m.ow   = ofio.w
     
   m.oc_doc = odoc.c_doc
   m.os_doc = odoc.s_doc
   m.on_doc = odoc.n_doc
   m.od_doc = odoc.d_doc
   
   m.okato = m.q_okato
   m.ogrn  = m.q_ogrn

   m.ogrn_old  = IIF(m.IsReReg=1, osmo.ogrn, '')
   m.ogrn      = IIF(!EMPTY(m.ogrn_old), m.ogrn_old, m.ogrn)
   m.okato_old = IIF(m.IsReReg=1, osmo.okato, '')
   m.okato     = IIF(!EMPTY(m.okato_old), m.okato_old, m.okato)
   m.dp_old    = IIF(m.IsReReg=1, osmo.dp, {})
     
   m.vid_docu = IIF(SEEK(m.p_doc, 'pdoc'), pdoc.vid_docu, '')
   m.tscn     = IIF(!EMPTY(m.jt), IIF(SEEK(m.jt, 'scenario', 'jt'), scenario.scn, ''), '')
   m.scenario = IIF(!EMPTY(m.scn), m.scn, m.tscn)
   
   m.d_fam = m.d_type1
   m.d_im  = m.d_type2
   m.d_ot  = m.d_type3
   
   m.d_gzk = m.d_type4
   
   m.snils = m.ss
   
   m.ser_docu = m.s_card
   m.nom_docu = ALLTRIM(STR(m.n_card))

   INSERT INTO curdata FROM MEMVAR  

   m.nrecs = m.nrecs + 1	
   
   m.is2fio = IIF(m.pricin='Ï10' AND tranz='À24', '1', m.is2fio)

   IF m.is2fio='1' 
    IF m.pricin='Ï10' AND tranz='À24' && Îáúåäèíÿåì ïîëèñû!

     m.vs        = ''
     m.dt        = {}
*     m.jt        = 'z'
*     m.okato_old = '45000'
     m.dp        = m.dp_old
     
     IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
       ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
       jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
     ENDIF 

     INSERT INTO fioFile FROM MEMVAR 
     m.fnpp = 1
     INSERT INTO fioFilen FROM MEMVAR 

     m.s_card    = ''
     m.n_card    = 0

	 m.enp       = enp2.enp
	 m.dp_old    = enp2.dp
	 m.dp        = m.dp_old
     m.okato_old = enp2.okato
     m.okato     = IIF(!EMPTY(m.okato_old), m.okato_old, m.okato)
     m.ogrn_old  = enp2.ogrn
     m.ogrn      = IIF(!EMPTY(m.ogrn_old), m.ogrn_old, m.ogrn)
     m.jt        = '0'
     
     && Äîáàâëåíî 12.12.13 ïî ïðîñüáå Ðåñî
     m.fam = IIF(!EMPTY(m.ofam), m.ofam, m.fam)
     m.im  = IIF(!EMPTY(m.oim), m.oim, m.im)
     m.ot  = IIF(!EMPTY(m.oot), m.oot, m.ot)
     m.w   = IIF(!EMPTY(m.ow), m.ow, m.w)
     m.dr  = IIF(!EMPTY(DTOS(m.odr)), DTOS(m.odr), m.dr)
     && Äîáàâëåíî 12.12.13 ïî ïðîñüáå Ðåñî

     IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
       ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
       jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
     ENDIF 

     INSERT INTO fioFile FROM MEMVAR 
     m.fnpp = 2
     INSERT INTO fioFilen FROM MEMVAR 

    ELSE && IF m.pricin='Ï10' AND tranz='À24'

     IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
       ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
       jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
     ENDIF 

     INSERT INTO fioFile FROM MEMVAR 
     m.fnpp = 1
     INSERT INTO fioFilen FROM MEMVAR 

     m.fam = m.ofam
     m.im  = m.oim
     m.ot  = m.oot
     m.w   = m.ow
     m.dr  = DTOS(m.odr)
    
     && Âíåñåíî 24.10 äëÿ ïðàâèëüíîé ïîäà÷è êîëëèçèé!
     m.jt = '0'
     m.vs = ''
     && Âíåñåíî 24.10 äëÿ ïðàâèëüíîé ïîäà÷è êîëëèçèé!

     IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
       ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
       jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
     ENDIF 

     INSERT INTO fioFile FROM MEMVAR 
     m.fnpp = 2
     INSERT INTO fioFilen FROM MEMVAR 

    ENDIF 

   ELSE && IF m.is2fio='1'
   
    IF m.jt == 'r'
     m.ogrn_old  = ''
     m.okato_old = ''
     m.dp_old    = {}
*     m.enp       = ''
    ENDIF 

     IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
       ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
       jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
     ENDIF 

    INSERT INTO fioFile FROM MEMVAR 
     m.fnpp = 1
    INSERT INTO fioFilen FROM MEMVAR 

   ENDIF 
  
   m.is2doc = IIF(m.pricin='Ï10' AND tranz='À24', '1', m.is2doc)
   IF m.is2doc='1'
    INSERT INTO docfile (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
     (m.recid,m.c_doc,m.s_doc,m.n_doc,m.d_doc)
    INSERT INTO docfile (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
     (m.recid, m.oc_doc, m.os_doc, m.on_doc,m.od_doc)
    
    m.dnpp = 1
    INSERT INTO docfilen (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
     (m.recid,m.c_doc,m.s_doc,m.n_doc,m.d_doc)
    m.dnpp = 2
    INSERT INTO docfilen (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
     (m.recid, m.oc_doc, m.os_doc, m.on_doc,m.od_doc)
   ELSE 
    INSERT INTO docfile FROM MEMVAR
    m.dnpp = 1
    INSERT INTO docfilen FROM MEMVAR

    IF INLIST(m.kl, '45','73','99') AND m.c_perm>0
     INSERT INTO docfile (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
     (m.recid, m.c_perm, m.s_perm, m.n_perm, m.d_perm)
     m.dnpp = 2
     INSERT INTO docfilen (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
     (m.recid, m.c_perm, m.s_perm, m.n_perm, m.d_perm)
    ENDIF 

   ENDIF 
   

*   REPLACE status WITH 2, fiofile WITH STRTRAN(LOWER(m.fiofile),'.dbf',''), err WITH ''
   REPLACE status WITH 2
   
   IF SEEK(m.recid, 'error')
    oal = ALIAS()
    SELECT error
    SCAN 
     IF rec_id=m.recid
      REPLACE v WITH .t., dcor WITH DATE()
     ENDIF 
    ENDSCAN 
    SELECT &oal
   ENDIF 

   IF SEEK(INT(VAL(m.recid)), 'efoms')
    oal = ALIAS()
    SELECT efoms
    SCAN 
     IF recid = INT(VAL(m.recid))
      REPLACE v WITH .t., dcor WITH DATE()
     ENDIF 
    ENDSCAN 
    SELECT &oal
   ENDIF 
   
*   REPLACE err WITH ''
	 
   m.adr_ter = IIF(BETWEEN(VAL(m.kl),0,27) or m.kl='45', '45', LEFT(adr50.c_okato,2))
   m.adr_reg = IIF(BETWEEN(VAL(m.kl),0,27) or m.kl='45', '000', RIGHT(adr50.c_okato,3))

   m.adr_obl = UPPER(ALLTRIM(okato.name))
   m.adr_rjn = UPPER(ALLTRIM(adr50.ra_name))
   m.adr_gor = UPPER(ALLTRIM(CityType.name) + ' ' + ALLTRIM(adr50.np_name))
   m.adr_ul  = UPPER(ALLTRIM(adr50.ul_name))
   m.adr_dom = ALLTRIM(adr50.dom)
   m.adr_kor = ALLTRIM(adr50.kor)
   m.adr_str = ALLTRIM(adr50.str)
   m.adr_kvr = ALLTRIM(adr50.kv)
   m.adr_adr = UPPER(m.adr_obl + IIF(!EMPTY(m.adr_rjn), ', ð-îí ' + m.adr_rjn, '')+;
	IIF(!EMPTY(m.adr_gor), ', ' + m.adr_gor, '') + IIF(!EMPTY(m.adr_ul), ', ' + m.adr_ul, '')+;
	IIF(!EMPTY(m.adr_dom), ', ä. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', êîðï. ' + m.adr_kor, '')+;
	IIF(!EMPTY(m.adr_str), ', ñòð. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', êâ. ' + m.adr_kvr, ''))

   IF !EMPTY(m.adr_ter) AND m.adr_ter != '45'
    m.adr_type = "R"
    INSERT INTO adrfile FROM MEMVAR 
    INSERT INTO adrfilen FROM MEMVAR 
    
    m.dat_reg = {}
    
    m.adr_ter = '45'
    m.adr_reg = '000'

    m.adr_obl = ''
    m.adr_rjn = ''
    m.adr_gor = 'Ã. ÌÎÑÊÂÀ'
    m.adr_ul  = IIF(SEEK(adr77.ul, 'street'), UPPER(ALLTRIM(street.street)), '')
    m.adr_dom = ALLTRIM(adr77.d)
    m.adr_kor = ALLTRIM(adr50.kor)
    m.adr_str = ALLTRIM(adr50.str)
    m.adr_kvr = ALLTRIM(adr50.kv)
    m.adr_adr = m.adr_gor + IIF(!EMPTY(m.adr_ul), ', ' + m.adr_ul, '')+;
	 IIF(!EMPTY(m.adr_dom), ', ä. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', êîðï. ' + m.adr_kor, '')+;
	 IIF(!EMPTY(m.adr_str), ', ñòð. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', êâ. ' + m.adr_kvr, '')

    m.adr_type = "P"
    INSERT INTO adrfilen FROM MEMVAR 
   ELSE 
    m.adr_type = "R"
    m.dat_reg = {}
    
    m.adr_ter = '45'
    m.adr_reg = '000'

    m.adr_obl = ''
    m.adr_rjn = ''
    m.adr_gor = 'Ã. ÌÎÑÊÂÀ'
    m.adr_ul  = IIF(SEEK(adr77.ul, 'street'), UPPER(ALLTRIM(street.street)), '')
    m.adr_dom = ALLTRIM(adr77.d)
    m.adr_kor = ALLTRIM(adr50.kor)
    m.adr_str = ALLTRIM(adr50.str)
    m.adr_kvr = ALLTRIM(adr50.kv)
    m.adr_adr = m.adr_gor + IIF(!EMPTY(m.adr_ul), ', ' + m.adr_ul, '')+;
	 IIF(!EMPTY(m.adr_dom), ', ä. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', êîðï. ' + m.adr_kor, '')+;
	 IIF(!EMPTY(m.adr_str), ', ñòð. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', êâ. ' + m.adr_kvr, '')

    INSERT INTO adrfile FROM MEMVAR 
    INSERT INTO adrfilen FROM MEMVAR 
   
   ENDIF 
		
  ENDSCAN
  
  SET RELATION OFF INTO jt
  SET RELATION OFF INTO adr77
  SET RELATION OFF INTO adr50
  SET RELATION OFF INTO enp2
  SET RELATION OFF INTO ofio 
  SET RELATION OFF INTO odoc 
  SET RELATION OFF INTO osmo
  USE 
  USE IN adr77 
  SELECT adr50
  SET RELATION OFF INTO okato
  SET RELATION OFF INTO CityType
  USE IN adr50
  USE IN efoms
  USE IN error
  USE IN moves
  USE IN enp2
  USE IN permiss
  USE IN ofio 
  USE IN odoc
  USE IN osmo 
  
  USE IN fiofile
  USE IN docfile
  USE IN adrfile
	
  ZipFile(tcDirPath+'\'+m.fioFile, .T.)
  ZipFile(tcDirPath+'\'+m.docFile, .T.)
  ZipFile(tcDirPath+'\'+m.adrFile, .T.)
  
  INSERT INTO wrkrslt (pv, nrecs, dat1, dat2) VALUES (pvid(num_pv,1), m.nrecs, m.dat1, m.dat2)
  
  RELEASE fiofile

  WAIT CLEAR 
	
 ENDFOR

 =ClFiles()
 
 ZipClose()

 USE IN fiofilen
 USE IN docfilen
 USE IN adrfilen

 ZipOpen(ZipNameN, tcDirPath+'\', .T.)
 ZipFile(tcDirPath+'\'+m.fioFilen, .T.)
 ZipFile(tcDirPath+'\'+m.docFilen, .T.)
 ZipFile(tcDirPath+'\'+m.adrFilen, .T.)
 ZipClose()

 SELECT curdata 
 GO TOP 
* DO FORM formpf
 USE 

 SELECT wrkrslt
 GO TOP 
 DO FORM rsfrm
 USE 

RETURN 

FUNCTION OpFiles
 oprslt = 0 
 oprslt = oprslt + OpenFile(PCommon+'\Jt', 'Jt', 'shar', 'jt')
 oprslt = oprslt + OpenFile(PCommon+'\Scenario', 'Scenario', 'shar', 'jt')
 oprslt = oprslt + OpenFile(PCommon+'\citytype', 'CityType', 'shar', 'code')
 oprslt = oprslt + OpenFile(PCommon+'\okato', 'okato', 'shar', 'code')
 oprslt = oprslt + OpenFile(pBase+'\'+pvid(1,1)+'\Answers', 'Answers', 'SHARED', 'recid')
 oprslt = oprslt + OpenFile(pcommon+'\sv5ppl', 'sv5ppl', 'shar', 'unval')
 oprslt = oprslt + OpenFile(pcommon+'\p_doc', 'pdoc', 'shar', 'code')
 oprslt = oprslt + OpenFile(pcommon+'\street', 'street', 'shar', 'ul')
RETURN oprslt

FUNCTION OpFilesPv(numpv)
 oprslt = 0 
 oprslt = oprslt + OpenFile(PBase+'\'+pvid(numpv,1)+'\kms', 'kms', 'shar')
 oprslt = oprslt + OpenFile(PBase+'\'+pvid(numpv,1)+'\adr77', 'adr77', 'shar', 'recid')
 oprslt = oprslt + OpenFile(PBase+'\'+pvid(numpv,1)+'\adr50', 'adr50', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\e_ffoms', 'efoms', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\error', 'error', 'shar', 'rec_id')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\moves', 'moves', 'shar', 'unik')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\enp2', 'enp2', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\permiss', 'permiss', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\ofio', 'ofio', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\odoc', 'odoc', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\'+pvid(numpv,1)+'\osmo', 'osmo', 'shar', 'recid')
RETURN oprslt

FUNCTION ClFiles
 IF USED('jt')
  USE IN jt
 ENDIF 
 IF USED('Scenario')
  USE IN Scenario
 ENDIF 
 IF USED('CityType')
  USE IN CityType
 ENDIF 
 IF USED('okato')
  USE IN okato
 ENDIF 
 IF USED('Answers')
  USE IN Answers
 ENDIF 
 IF USED('sv5ppl')
  USE IN sv5ppl
 ENDIF 
 IF USED('pdoc')
  USE IN pdoc
 ENDIF 
 IF USED('street')
  USE IN street
 ENDIF 
RETURN 

FUNCTION ClFilesPv(numpv)
 IF USED('kms')
  USE IN kms
 ENDIF 
 IF USED('adr77')
  USE IN adr77
 ENDIF 
 IF USED('adr50')
  USE IN adr50
 ENDIF 
 IF USED('efoms')
  USE IN efoms
 ENDIF 
 IF USED('error')
  USE IN error
 ENDIF 
 IF USED('moves')
  USE IN moves
 ENDIF 
 IF USED('enp2')
  USE IN enp2
 ENDIF 
 IF USED('permiss')
  USE IN permiss
 ENDIF 
 IF USED('ofio')
  USE IN ofio
 ENDIF 
 IF USED('odoc')
  USE IN odoc
 ENDIF 
 IF USED('osmo')
  USE IN osmo
 ENDIF 
RETURN 