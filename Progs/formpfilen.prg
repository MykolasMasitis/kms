FUNCTION FormPFileN(TipRpt) && 1-ïî äàòå, 2-ïî ñòàòóñó
 
 IF MESSAGEBOX("ÂÛ ÕÎÒÈÒÅ ÑÔÎÐÌÈÐÎÂÀÒÜ Î×ÅÐÅÄÍÓÞ ÇÀßÂÊÓ"+CHR(13)+CHR(10)+;
  IIF(TipRpt=1, "ÏÎ ÄÀÒÅ?", "ÏÎ ÑÒÀÒÓÑÓ?")+CHR(13)+CHR(10),4+32,'') == 7
  RETURN
 ENDIF
 
 IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
  m.lppath = pBase
  m.kol_pv = 1
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
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

 m.persfile = 'pers' + qcod + ymmdd + '.dbf'
 m.docufile = 'docu' + qcod + ymmdd + '.dbf'
 m.addrfile = 'addr' + qcod + ymmdd + '.dbf'

 tcDirPath = POut + '\' + yearmmdd
	
 IF !fso.FolderExists(tcDirPath)
  fso.CreateFolder(tcDirPath)
 ENDIF 

 IF FILE('&tcDirPath\&persfile') AND FILE('&tcDirPath\&docufile') AND FILE('&tcDirPath\&addrfile')
  FOR tParam = 1 TO 999
   bfioFile    = 'pers' + qcod + ymmdd + '.'+PADL(tParam,3,'0')
   IF !FILE('&tcDirPath\&bfioFile')
    EXIT 
   ENDIF 
  ENDFOR 

  RENAME &tcDirPath\&persfile TO &tcDirPath\&bfioFile

  FOR tParam = 1 TO 999
   bdocFile    = 'docu' + qcod + ymmdd + '.'+PADL(tParam,3,'0')
   IF !FILE('&tcDirPath\&bdocFile')
	EXIT 
   ENDIF 
  ENDFOR 

  RENAME &tcDirPath\&docufile TO &tcDirPath\&bdocFile

  FOR tParam = 1 TO 999
   badrFile    = 'addr' + qcod + ymmdd + '.'+PADL(tParam,3,'0')
   IF !FILE('&tcDirPath\&badrFile')
	EXIT 
   ENDIF 
  ENDFOR 

  RENAME &tcDirPath\&addrfile TO &tcDirPath\&badrFile

 ENDIF

 fso.CopyFile(PTempl+'\persqqymmdd.dbf', tcDirPath+'\'+m.persfile)
 fso.CopyFile(PTempl+'\docuqqymmdd.dbf', tcDirPath+'\'+m.docufile)
 fso.CopyFile(PTempl+'\addrqqymmdd.dbf', tcDirPath+'\'+m.addrfile)

 oprslt = 0
 oprslt = oprslt + OpenFile(tcDirPath+'\'+m.persfile, 'persfile', 'shar')
 oprslt = oprslt + OpenFile(tcDirPath+'\'+m.docufile, 'docufile', 'shar')
 oprslt = oprslt + OpenFile(tcDirPath+'\'+m.addrfile, 'addrfile', 'shar')
 IF oprslt>0
  IF USED('persfile')
   USE IN persfile
  ENDIF 
  IF USED('docufile')
   USE IN docufile
  ENDIF 
  IF USED('addrfile')
   USE IN addrfile
  ENDIF 
  =ClFiles()
  RETURN 
 ENDIF 
 
 CREATE CURSOR wrkrslt (pv c(3), nrecs n(11,2), dat1 d, dat2 d)
 
 CREATE CURSOR curid (recid c(6)) 
 INDEX on recid TAG recid
 SET ORDER TO recid
 
 CREATE CURSOR curjpeg (names c(25))

 CREATE CURSOR curdata (rcid i AUTOINC, pv c(3), vs c(9),sn_card c(17),enp c(16),scn c(3),;
  fam c(25), im c(20), ot c(20), dp d) 
 INDEX on rcid TAG rcid CANDIDATE 
 INDEX ON pv TAG pv 
 INDEX ON vs TAG vs
 INDEX ON sn_card TAG sn_card
 INDEX ON enp TAG enp 
 INDEX ON scn TAG scn
 INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30)) TAG  fio COLLATE "Russian"
 INDEX ON dp TAG dp

 FOR num_pv=1 TO kol_pv

  IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)!='KMS.EXE'
   m.lppath = pBase+'\'+pvid(num_pv,1)
  ENDIF 

  WAIT "ÔÎÐÌÈÐÎÂÀÍÈÅ ÎÒ×ÅÒÀ ÏÎ ÏÂ "+pvid(num_pv,1)+"..." WINDOW NOWAIT 
  
  IF OpFilesPv(num_pv)>0
   =ClFilesPv(num_pv)
   LOOP 
  ENDIF 

  SELECT adr50
  SET RELATION TO np_c INTO CityType
  SET RELATION TO c_okato INTO okato ADDITIVE 

  SELECT kms
  SET RELATION TO adr_id INTO adr77 ADDITIVE 
  SET RELATION TO adr50_id INTO adr50 ADDITIVE 
  SET RELATION TO enp2id INTO enp2 ADDITIVE 
  SET RELATION TO permid INTO permiss ADDITIVE 
  SET RELATION TO ofioid INTO ofio ADDITIVE 
  SET RELATION TO odocid INTO odoc ADDITIVE 
  SET RELATION TO osmoid INTO osmo ADDITIVE 	
	
  m.nrecs = 0
  m.dat1  = {31.12.2999}
  m.dat2  = {01.01.1000}
  
  m.nepodb = 0
  m.IsNeedR = .F.
  m.IsChkd = .f.
  COUNT FOR !EMPTY(Scn) AND IIF(TipRpt==2, Status == 1, BETWEEN(dp, gdCurDat1, gdCurDat2)) TO m.nepodb
  IF m.nepodb = 0
   IF MESSAGEBOX('ÍÅ ÎÁÍÀÐÓÆÅÍÎ ÍÈ ÎÄÍÎÃÎ ÏÎËÈÑÀ ÍÀ ÈÇÃÎÒÎÂËÅÍÈÅ!'+CHR(13)+CHR(10)+;
    'ÎÒÎÁÐÀÒÜ Â ÎÒ×ÅÒ ÂÛÄÀÍÍÛÅ ÍÀ ÐÓÊÈ ÏÎËÈÑÛ',4+32,'')=6
    m.IsNeedR = .T.
    m.IsChkd = .f.
    DO FORM TuneUp TO m.IsChkd
   ENDIF 
  ENDIF 
  
  SCAN FOR IIF(m.IsChkd = .f., !EMPTY(Scn) AND ;
   IIF(TipRpt==2, Status == 1, BETWEEN(dp, gdCurDat1, gdCurDat2)), ;
   (scn='POK' OR Status=6) AND BETWEEN(dp, gdCurDat1, gdCurDat2))

   SCATTER FIELDS EXCEPT fiofile MEMVAR memo 

   m.dt = IIF(m.dt={31.12.9999}, {31.12.2099}, m.dt)
   
   m.dat1 = MIN(m.dat1, m.dp)
   m.dat2 = MAX(m.dat2, m.dp)
	 
   m.recid  = PADL(m.recid,6,'0')
   m.orecid = m.recid
   IF !SEEK(m.recid, 'curid')
    m.nrecid = ''
    INSERT INTO curid FROM MEMVAR 
   ELSE && äóáëü ïî recid!
    m.nrecid = 'h'+dtoh(INT(VAL(m.recid)))
    IF !SEEK(m.nrecid, 'curid')
     m.recid = m.nrecid
     INSERT INTO curid FROM MEMVAR 
    ELSE 
     m.nrecid = 'H'+dtoh(INT(VAL(m.recid)))
     IF !SEEK(m.nrecid, 'curid')
      m.recid = m.nrecid
      INSERT INTO curid FROM MEMVAR 
     ELSE 
     
     ENDIF 
    ENDIF 
   ENDIF 
   
   m.pv = IIF(EMPTY(m.pv), pvid(num_pv,1), m.pv)

   IF m.form=2
    m.fo_file = 'f'+m.orecid
    m.fn_file = 'f'+m.recid
    IF fso.FileExists(m.lppath+'\jpeg\'+m.fo_file+'.jpg')
     IF fso.FileExists(tcDirPath+'\'+m.fn_file+'.jpg')
      fso.DeleteFile(tcDirPath+'\'+m.fn_file+'.jpg')
     ENDIF 
     fso.CopyFile(m.lppath+'\jpeg\'+m.fo_file+'.jpg', tcDirPath+'\'+m.fn_file+'.jpg')
     INSERT INTO curjpeg (names) VALUES (m.fn_file+'.jpg')
    ENDIF 

    m.so_file = 's'+m.orecid
    m.sn_file = 's'+m.recid
    IF fso.FileExists(m.lppath+'\jpeg\'+m.so_file+'.jpg')
     IF fso.FileExists(tcDirPath+'\'+m.sn_file+'.jpg')
      fso.DeleteFile(tcDirPath+'\'+m.sn_file+'.jpg')
     ENDIF 
     fso.CopyFile(m.lppath+'\jpeg\'+m.so_file+'.jpg', tcDirPath+'\'+m.sn_file+'.jpg')
     INSERT INTO curjpeg (names) VALUES (m.sn_file+'.jpg')
    ENDIF 
   ENDIF 

   IF IsKms(m.sn_card)
    m.s_card = IIF(!EMPTY(m.sn_card), LEFT(sn_card,6), '')
    m.n_card = IIF(!EMPTY(m.sn_card), PADL(INT(VAL(SUBSTR(sn_card,8))),10,'0'), 0)
   ELSE 
    m.s_card = ''
    m.n_card = ''
   ENDIF 
   
   IF INLIST(m.scn,'PI','PRI','PR','CP')
    m.vid_docu ='Ñ'
    m.ser_docu = m.s_card
    m.nom_docu = m.n_card
   ELSE 
    m.vid_docu ='Ñ'
    m.ser_docu = ''
    m.nom_docu = m.vs
   ENDIF 

   m.kl = PADL(m.kl,2,'0')
   
   m.ddr = m.dr
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
   m.spos = IIF(m.predst=0,1,2)
   m.ul     = adr77.ul
   m.d      = adr77.d
   m.kor    = adr77.kor
   m.str    = adr77.str
   m.kv     = adr77.kv
   m.adr_msk = adr77.ul
   m.dt     = IIF(m.dt != {31.12.2099} AND !BETWEEN(m.dt, DATE(), DATE()+5*365), {31.12.2099}, m.dt)
   
   m.c_perm = permiss.c_perm
   m.s_perm = permiss.s_perm
   m.n_perm = permiss.n_perm
   m.d_perm = permiss.d_perm
   m.e_perm = permiss.e_perm
   
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
     
*   m.vid_docu = IIF(SEEK(m.p_doc, 'pdoc'), pdoc.vid_docu, '')
   m.scenario = m.scn
   
   m.d_fam = m.d_type1
   m.d_im  = m.d_type2
   m.d_ot  = m.d_type3
   
   m.d_gzk = m.d_type4
   
   m.snils = m.ss
   
   INSERT INTO curdata FROM MEMVAR  

   m.nrecs = m.nrecs + 1	
   
   IF !INLIST(m.scn,'NB','DP','CLR','POK','AD') AND Status!=6

     m.vs        = ''
*     m.dt        = {}
     m.dp        = m.dp_old
     
     IF !SEEK(PADR(UPPER(ALLTRIM(m.persfile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,scn,fam,im,ot,dr,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
       ('1',UPPER(m.persfile),DATETIME(),kms.recid,m.recid,m.vs,m.ser_docu,VAL(m.nom_docu),m.enp,m.dp,m.scn,;
        m.fam,m.im,m.ot,m.ddr,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.ser_docu,n_card=VAL(m.nom_docu),enp=m.enp,dp=m.dp;
       WHERE PADR(UPPER(ALLTRIM(m.persfile)),25)+m.recid=fname+frecid
     ENDIF 

     m.fnpp = 1

     IF !INLIST(m.scn,'RD','MP')
      m.dp = vs_data
     ENDIF 
     
     IF INLIST(m.scn,'PRI','PI')
      m.vid_docu = 'Â'
      m.ser_docu = ''
      m.nom_docu = vs
      m.ogrn = ''
      m.okato = ''
     ENDIF 
     
     IF !INLIST(m.scn,'CT')     
     IF INLIST(m.kl,'45','99')
      m.o_dt = m.dt
      m.dt = permiss.e_perm
     ENDIF 
     IF INLIST(m.kl,'73')
      m.o_dt = m.dt
      m.dt = kms.e_doc
     ENDIF 
     ENDIF 
     IF INLIST(m.scn, 'NB','PI','PT','RI','RT','PRI','PRT','DP','CP','PR')
      m.vid_docu = 'Â'
      m.ser_docu = ''
      m.nom_docu = vs
      m.ogrn = ''
      m.okato = ''
     ENDIF 
     IF INLIST(m.scn, 'CR', 'CT', 'CI')
      IF !EMPTY(vs)
       m.vid_docu = 'Â'
       m.ser_docu = ''
       m.nom_docu = vs
       m.ogrn = ''
       m.okato = ''
      ELSE 
       m.vid_docu = 'Ï'
       m.ser_docu = ''
       m.nom_docu = enp
       m.ogrn = ''
       m.okato = ''
      ENDIF 
     ENDIF 
     IF m.scn='CT'
      m.ogrn = ''
      m.okato = ''
      m.dp = dp
      m.vid_docu = IIF(EMPTY(vs), 'Ï', 'Â')
      m.nom_docu = IIF(EMPTY(vs), enp, vs)
     ENDIF 
     
     IF m.scn='CI'
      m.vid_docu = IIF(EMPTY(vs), 'Ï', 'Â')
      m.nom_docu = IIF(EMPTY(vs), enp, vs)
      m.ogrn  = osmo.ogrn
      m.okato = osmo.okato 
     ENDIF 

     IF m.scn='PT'
      m.vid_docu = 'Â'
      m.ogrn = ''
      m.okato = ''
     ENDIF 

     IF m.scn='RI'
      m.vid_docu = 'Â'
      m.ogrn = ''
      m.okato = ''
     ENDIF 

     IF m.scn='RT'
      m.vid_docu = 'Â'
      m.ogrn = ''
      m.okato = ''
     ENDIF 

     IF m.scn='CP'
*      m.form = 1
     ENDIF 

     IF m.scn='PR'
*      m.form = 1
     ENDIF 
     
     IF m.scn = 'CD'
      m.vid_docu = 'Ï'
      m.nom_docu = enp
      m.ogrn = ''
      m.okato = ''
      m.dp = dp 
      m.dt = {}
     ENDIF 

     IF m.scn = 'MP'
      m.vid_docu = 'Ï'
      m.ser_docu = ''
      m.nom_docu = enp
      m.form = 0
      m.predst = 0
      m.spos = 0
      m.d_gzk = 0
      m.ogrn  = osmo.ogrn
      m.okato = osmo.okato
      m.dp    = osmo.dp
      m.enp   = enp
      m.vid_docu = ''
      DO CASE 
       CASE p_doc=1
        m.vid_docu = 'Ñ'
        m.ser_docu = SUBSTR(ALLTRIM(sn_card),1,RAT(' ',ALLTRIM(sn_card))-1)
        m.nom_docu = SUBSTR(ALLTRIM(sn_card),RAT(' ',ALLTRIM(sn_card))+1)
       CASE p_doc=3
        m.vid_docu = 'Ï'
        m.ser_docu = ''
*        m.nom_docu = ALLTRIM(sn_card)
        m.nom_docu = ALLTRIM(enp)
       CASE p_doc=4
        m.vid_docu = 'Ê'
        m.ser_docu = SUBSTR(ALLTRIM(sn_card),1,RAT(' ',ALLTRIM(sn_card))-1)
        m.nom_docu = SUBSTR(ALLTRIM(sn_card),RAT(' ',ALLTRIM(sn_card))+1)
       OTHERWISE 
      ENDCASE 
*      m.ser_docu = ''
*      m.nom_docu = ''
     ENDIF 

     INSERT INTO persfile FROM MEMVAR 

     DO CASE 
      CASE INLIST(m.kl,'45','99')
       m.dnpp = 1
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
       m.dnpp = 2
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,permiss.c_perm,permiss.s_perm,permiss.n_perm,permiss.d_perm,permiss.e_perm)
      CASE INLIST(m.kl,'73')
      OTHERWISE 
       m.dnpp = 1
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
     ENDCASE 

	 m.enp       = enp2.enp
	 m.dp_old    = enp2.dp
	 m.dp        = m.dp_old
     m.okato_old = enp2.okato
     m.okato     = IIF(!EMPTY(m.okato_old), m.okato_old, m.okato)
     m.ogrn_old  = enp2.ogrn
     m.ogrn      = IIF(!EMPTY(m.ogrn_old), m.ogrn_old, m.ogrn)
     
     && Äîáàâëåíî 12.12.13 ïî ïðîñüáå Ðåñî
     IF !EMPTY(m.ofam)
      m.fam = m.ofam
      m.im  = m.oim
      m.ot  = m.oot
      m.w   = m.ow
      m.dr  = DTOS(m.odr)
     ELSE 
      m.fam = m.fam
      m.im  = m.im
      m.ot  = m.ot
      m.w   = m.w
      m.dr  = m.dr
     ENDIF 
     && Äîáàâëåíî 12.12.13 ïî ïðîñüáå Ðåñî

     IF !SEEK(PADR(UPPER(ALLTRIM(m.persfile)),25)+m.recid, 'moves')
      INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,scn,fam,im,ot,dr,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
       ('1',UPPER(m.persfile),DATETIME(),kms.recid,m.recid,m.vs,m.ser_docu,VAL(m.nom_docu),m.enp,m.dp,m.scn,;
        m.fam,m.im,m.ot,m.ddr,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
     ELSE 
      UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.ser_docu,n_card=VAL(m.nom_docu),enp=m.enp,dp=m.dp;
       WHERE PADR(UPPER(ALLTRIM(m.persfile)),25)+m.recid=fname+frecid
     ENDIF 

     m.fnpp = 2
     IF !INLIST(m.scn,'CD','RD','MP')
      m.vid_docu = ''
      m.ser_docu = ''
      m.nom_docu = ''
     ENDIF 
     * Äëÿ ñöåíàðèåâ PI, PRI, PR, CP â äî÷åðíåé çàïèñè ôàéëà pers äîëæíî áûòü Ser_docu=s_card, Nom_docu=n_card.
     IF m.scn='CD'
      m.dp = m.dp_old
     ENDIF 
*     m.scenario = IIF(m.qcod='R4', '', m.scenario)

     IF m.scn='PRI'
      m.vid_docu = IIF(SEEK(m.p_doc2, 'pdoc'), pdoc.vid_docu, '')
      m.ser_docu = ALLTRIM(s_card2)
      m.nom_docu = ALLTRIM(n_card2)
*      m.form = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn='PI'
      m.enp = ''
      m.vid_docu = 'Ñ'
      m.ser_docu = ALLTRIM(s_card2)
      m.nom_docu = ALLTRIM(n_card2)
  	  m.enp      = enp2.enp
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF !INLIST(m.scn,'CT')     
     IF INLIST(m.kl,'45','99')
      m.dt = m.o_dt
     ENDIF 
     IF INLIST(m.kl,'73')
      m.dt = m.o_dt
     ENDIF 
     ENDIF 
     
     IF m.scn = 'PT'
      m.vid_docu = 'Ñ'
      m.ser_docu = m.s_card
      m.nom_docu = m.n_card
     ENDIF 

     IF m.scn='CT'
      m.vid_docu = 'Ï'
      m.ser_docu = ''
      m.nom_docu = enp2.enp
      m.form = 0
      m.predst = 0
      m.spos = 0 
      m.d_gzk = 0
     ENDIF 
     
     IF m.scn='CI'
      m.vid_docu = 'Ï'
      m.nom_docu = enp2.enp
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn='PT'
      m.vid_docu = 'Ñ'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
      m.enp = ''
     ENDIF 

     IF m.scn='RI'
      m.vid_docu = 'Ï'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
   	  m.enp      = enp2.enp
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn='RT'
      m.vid_docu = 'Ï'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn='CP'
      m.vid_docu = 'Ñ'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
      m.dp = enp2.dp
      m.ogrn = ''
      m.okato = ''
      m.enp = ''
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn='PR'
      m.vid_docu = 'Ñ'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn='PRT'
      m.vid_docu = 'Ñ'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 
    
     IF m.scn='CR'
      m.vid_docu = 'Ï'
      m.ser_docu = s_card2
      m.nom_docu = n_card2
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn = 'CD'
      m.vid_docu = 'Ï'
      m.nom_docu = ''
      m.ogrn = ''
      m.okato = ''
      m.dp = dp 
      m.dt = {}
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
     ENDIF 

     IF m.scn = 'CPV'
      m.vid_docu = 'Ï'
     ENDIF 

     IF m.scn = 'MP'
      m.vid_docu = 'Ï'
      m.ser_docu = ''
      m.nom_docu = enp
      m.form = 0
      m.spos = 0
      m.predst = 0
      m.d_gzk = 0
      m.ogrn  = enp2.ogrn
      m.okato = enp2.okato
      m.dp    = enp2.dp
      m.enp   = enp2.enp
      m.vid_docu = ''
      DO CASE 
       CASE p_doc2=1
        m.vid_docu = 'Ñ'
       CASE p_doc2=3
        m.vid_docu = 'Ï'
       CASE p_doc2=4
        m.vid_docu = 'Ê'
       OTHERWISE 
      ENDCASE 
      m.ser_docu = s_card2
      m.nom_docu = n_card2
     ENDIF 

     INSERT INTO persfile FROM MEMVAR 

     DO CASE 
      CASE INLIST(m.kl,'45','99')
       m.dnpp = 1
       IF !EMPTY(odoc.c_doc)
        INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
         (m.recid,m.fnpp,m.dnpp,odoc.c_doc,odoc.s_doc,odoc.n_doc,odoc.d_doc,odoc.e_doc)
       ELSE 
        INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
         (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
        m.dnpp = 2
        INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
         (m.recid,m.fnpp,m.dnpp,permiss.c_perm,permiss.s_perm,permiss.n_perm,permiss.d_perm,permiss.e_perm)
       ENDIF 
      CASE INLIST(m.kl,'73')
       m.dnpp = 1
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
       m.dnpp = 2
       IF !EMPTY(odoc.c_doc)
        INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
         (m.recid,m.fnpp,m.dnpp,odoc.c_doc,odoc.s_doc,odoc.n_doc,odoc.d_doc,odoc.e_doc)
       ELSE 
        INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
         (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
       ENDIF 
      OTHERWISE 
       m.dnpp = 1
       IF m.qcod='R4'
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,odoc.c_doc,odoc.s_doc,odoc.n_doc,odoc.d_doc,odoc.e_doc)
       ELSE 
       IF INLIST(m.scn,'CR','PRT','PRI','MP')
        INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
         (m.recid,m.fnpp,m.dnpp,odoc.c_doc,odoc.s_doc,odoc.n_doc,odoc.d_doc,odoc.e_doc)
       ELSE 
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
       ENDIF
       ENDIF  
     ENDCASE 

   ELSE && INLIST(m.scn,'NB','DP','CLR','POK','AD') - îäíà çàïèñü â pers!
   
    IF m.scn == 'POK' AND Status!=6
     m.vid_docu = 'Ï'
     m.ser_docu = ''
     m.nom_docu = m.enp
     m.ogrn = ''
     m.okato = ''
    ENDIF 
    IF !INLIST(m.scn,'AD','POK','CLR','RD','MP') AND Status!=6
     m.dp = vs_data
    ENDIF 
    IF m.scn = 'NB'
     m.vid_docu = 'Â'
     m.ogrn = ''
     m.okato = ''
    ENDIF 
    IF m.scn = 'DP'
     m.vid_docu = 'Â'
     m.ogrn = ''
     m.okato = ''
    ENDIF 
    IF m.scn='CLR'
     m.vid_docu = 'Ï'
     m.nom_docu = enp
     m.dp = osmo.dp
     m.dt = dt
     m.form = 0
     m.spos = 0
     m.predst = 0
     m.d_gzk = 0
    ENDIF 
    IF m.scn='AD'
     m.vid_docu = 'Ï'
     m.nom_docu = enp
    ENDIF 

    IF !SEEK(PADR(UPPER(ALLTRIM(m.persfile)),25)+m.recid, 'moves')
     INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,scn,fam,im,ot,dr,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
      ('1',UPPER(m.persfile),DATETIME(),kms.recid,m.recid,m.vs,m.ser_docu,VAL(m.nom_docu),m.enp,m.dp,m.scn,;
        m.fam,m.im,m.ot,m.ddr,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
    ELSE 
     UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.ser_docu,n_card=VAL(m.nom_docu),enp=m.enp,dp=m.dp;
      WHERE PADR(UPPER(ALLTRIM(m.persfile)),25)+m.recid=fname+frecid 
    ENDIF 

    m.fnpp = 1
    INSERT INTO persfile FROM MEMVAR 
    
    DO CASE 
     CASE INLIST(m.kl,'45','99')
      m.dnpp = 1
      INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
       (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
      IF m.scn!='CLR'
       m.dnpp = 2
       INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
        (m.recid,m.fnpp,m.dnpp,permiss.c_perm,permiss.s_perm,permiss.n_perm,permiss.d_perm,permiss.e_perm)
      ENDIF 

     CASE INLIST(m.kl,'73')
      m.dnpp = 1
      INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
       (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)

     OTHERWISE && ìîñêâè÷è
      m.dnpp = 1
      INSERT INTO docufile (recid,fnpp,dnpp,c_doc,s_doc,n_doc,d_doc,e_doc) VALUES ;
       (m.recid,m.fnpp,m.dnpp,m.c_doc,m.s_doc,m.n_doc,m.d_doc,m.e_doc)
    ENDCASE 

   ENDIF 
  
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

   m.adr_ter = IIF(BETWEEN(VAL(m.kl),0,27) or m.kl='45', '45', LEFT(adr50.c_okato,2))
   IF !EMPTY(m.adr_ter) AND m.adr_ter != '45'
*    m.adr_type = "P"
    m.adr_type = "R"
 
*    m.adr_ter = IIF(BETWEEN(VAL(m.kl),0,27) or m.kl='45', '45', LEFT(adr50.c_okato,2))
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

    m.fnpp = 1
    INSERT INTO addrfile FROM MEMVAR 
    
*    m.adr_type = "R"
    m.adr_type = "P"
    m.dat_reg = {}
    
    m.adr_ter = '45'
    m.adr_reg = '000'

    m.adr_obl = ''
    m.adr_rjn = ''
    m.adr_gor = 'Ã. ÌÎÑÊÂÀ'
    m.adr_ul  = IIF(SEEK(adr77.ul, 'street'), UPPER(ALLTRIM(street.street)), '')
    m.adr_dom = ALLTRIM(adr77.d)
    m.adr_kor = ALLTRIM(adr77.kor)
    m.adr_str = ALLTRIM(adr77.str)
    m.adr_kvr = ALLTRIM(adr77.kv)
    m.adr_adr = m.adr_gor + IIF(!EMPTY(m.adr_ul), ', ' + m.adr_ul, '')+;
	 IIF(!EMPTY(m.adr_dom), ', ä. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', êîðï. ' + m.adr_kor, '')+;
	 IIF(!EMPTY(m.adr_str), ', ñòð. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', êâ. ' + m.adr_kvr, '')

    m.fnpp = 1
    INSERT INTO addrfile FROM MEMVAR 

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
    m.adr_kor = ALLTRIM(adr77.kor)
    m.adr_str = ALLTRIM(adr77.str)
    m.adr_kvr = ALLTRIM(adr77.kv)
    m.adr_adr = m.adr_gor + IIF(!EMPTY(m.adr_ul), ', ' + m.adr_ul, '')+;
	 IIF(!EMPTY(m.adr_dom), ', ä. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', êîðï. ' + m.adr_kor, '')+;
	 IIF(!EMPTY(m.adr_str), ', ñòð. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', êâ. ' + m.adr_kvr, '')

    m.fnpp = 1
    INSERT INTO addrfile FROM MEMVAR 
   
   ENDIF 
		
  ENDSCAN
  
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
  USE IN answers 
  
  INSERT INTO wrkrslt (pv, nrecs, dat1, dat2) VALUES (pvid(num_pv,1), m.nrecs, m.dat1, m.dat2)
  
  RELEASE fiofile

  WAIT CLEAR 
	
 ENDFOR

 =ClFiles()
 
 ZipClose()

 USE IN persfile
 USE IN docufile
 USE IN addrfile

 ZipName = 'g' + m.qcod + ymmdd +'.zip'
 ZipOpen(ZipName, tcDirPath+'\', .T.)
 ZipFile(tcDirPath+'\'+m.persfile, .T.)
 ZipFile(tcDirPath+'\'+m.docufile, .T.)
 ZipFile(tcDirPath+'\'+m.addrfile, .T.)
 IF RECCOUNT('curjpeg')>0
  SELECT curjpeg
  SCAN 
   m.jpgname = ALLTRIM(names)
   IF fso.FileExists(tcDirPath+'\'+m.jpgname)
    ZipFile(tcDirPath+'\'+m.jpgname, .T.)
   ENDIF 
  ENDSCAN 
 ENDIF 
 
 ZipClose()

 SELECT curdata 
 GO TOP 
 USE 

 SELECT wrkrslt
 GO TOP 
 DO FORM rsfrm
 USE 
 
 USE IN curid 
 USE IN curjpeg

RETURN 

FUNCTION OpFiles
 oprslt = 0 
 oprslt = oprslt + OpenFile(PCommon+'\Scenario', 'Scenario', 'shar', 'scn')
 oprslt = oprslt + OpenFile(PCommon+'\citytype', 'CityType', 'shar', 'code')
 oprslt = oprslt + OpenFile(PCommon+'\okato', 'okato', 'shar', 'code')
 oprslt = oprslt + OpenFile(pcommon+'\sv5ppl', 'sv5ppl', 'shar', 'unval')
 oprslt = oprslt + OpenFile(pcommon+'\p_doc', 'pdoc', 'shar', 'code')
 oprslt = oprslt + OpenFile(pcommon+'\street', 'street', 'shar', 'ul')
RETURN oprslt

FUNCTION OpFilesPv(numpv)
 oprslt = 0 
 oprslt = oprslt + OpenFile(m.lppath+'\kms', 'kms', 'shar')
 oprslt = oprslt + OpenFile(m.lppath+'\adr77', 'adr77', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\adr50', 'adr50', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\e_ffoms', 'efoms', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\error', 'error', 'shar', 'rec_id')
 oprslt = oprslt + OpenFile(m.lppath+'\moves', 'moves', 'shar', 'unik')
 oprslt = oprslt + OpenFile(m.lppath+'\enp2', 'enp2', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\permiss', 'permiss', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\ofio', 'ofio', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\odoc', 'odoc', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\osmo', 'osmo', 'shar', 'recid')
 oprslt = oprslt + OpenFile(m.lppath+'\Answers', 'Answers', 'SHARED', 'recid')
RETURN oprslt

FUNCTION ClFiles
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