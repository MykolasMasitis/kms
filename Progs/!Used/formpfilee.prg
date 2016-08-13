FUNCTION FormPFileE(TipRpt) && 1-ïî äàòå, 2-ïî ñòàòóñó

 #DEFINE BY_DATE   1
 #DEFINE BY_STATUS 2
 
 IF MESSAGEBOX("ÂÛ ÕÎÒÈÒÅ ÑÔÎÐÌÈÐÎÂÀÒÜ Î×ÅÐÅÄÍÓÞ ÇÀßÂÊÓ"+CHR(13)+CHR(10)+;
  IIF(TipRpt=1, "ÏÎ ÄÀÒÅ?", "ÏÎ ÑÒÀÒÓÑÓ?")+CHR(13)+CHR(10),4+32,'') == 7
  RETURN
 ENDIF
 
 IF TipRpt == BY_DATE
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
 IF OpFilesPv()>0
  =ClFiles()
  =ClFilesPv()
  RETURN 
 ENDIF 

 IF !fso.FileExists(PTempl+'\fiofile.dbf')
  =ClFiles()
  =ClFilesPv()
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË ØÀÁËÎÍÀ FIOFILE.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(PTempl+'\docfile.dbf')
  =ClFiles()
  =ClFilesPv()
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË ØÀÁËÎÍÀ DOCFILE.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(PTempl+'\adrfile.dbf')
  =ClFiles()
  =ClFilesPv()
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË ØÀÁËÎÍÀ ADRFILE.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 yearmmdd = STR(YEAR(DATE()),4) + PADL(MONTH(DATE()),2,'0') + PADL(DAY(DATE()),2,'0')
 ymmdd    = SUBSTR(yearmmdd,4)
	
 tcDirPath = POut + '\' + yearmmdd
	
 IF !fso.FolderExists(tcDirPath)
  fso.CreateFolder(tcDirPath)
 ENDIF 

 CREATE CURSOR wrkrslt (pv c(3), nrecs n(5), dat1 d, dat2 d)
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

 SELECT adr50
 SET RELATION TO np_c INTO CityType
 SET RELATION TO c_okato INTO okato ADDITIVE 
 SELECT kms
 SET ORDER TO pv
 SET RELATION TO jt INTO jt
 SET RELATION TO adr_id INTO adr77 ADDITIVE 
 SET RELATION TO adr50_id INTO adr50 ADDITIVE 
 SET RELATION TO enp2id INTO enp2 ADDITIVE 
 SET RELATION TO permid INTO permiss ADDITIVE 
 SET RELATION TO ofioid INTO ofio ADDITIVE 
 SET RELATION TO odocid INTO odoc ADDITIVE 
  SET RELATION TO osmoid INTO osmo ADDITIVE 	
	
 m.ppv  = 'xyz'  

 ZipName  = 'a' + m.qcod + ymmdd +'.zip'
 IF fso.FileExists(tcDirPath+'\'+ZipName)
  fso.DeleteFile(tcDirPath+'\'+ZipName)
 ENDIF 
 ZipOpen(ZipName, tcDirPath+'\', .T.)

 SCAN 
  IF !EMPTY(Fam) AND IIF(TipRpt=BY_STATUS, Status == 1, BETWEEN(dp, gdCurDat1, gdCurDat2))
  ELSE 
   LOOP 
  ENDIF 

  SCATTER MEMO MEMVAR
  
  IF !SEEK(m.pv, 'pvp2')
   LOOP 
  ENDIF 
  
  IF m.pv != m.ppv
   IF USED('fiofile')
    USE IN fiofile
    ZipFile(tcDirPath+'\'+m.fioFile, .T.)
    INSERT INTO wrkrslt (pv, nrecs, dat1, dat2) VALUES (m.ppv, m.nrecs, m.dat1, m.dat2)
   ENDIF 
   IF USED('docfile')
    USE IN docfile
    ZipFile(tcDirPath+'\'+m.docFile, .T.)
   ENDIF 
   IF USED('adrfile')
    USE IN adrfile
    ZipFile(tcDirPath+'\'+m.adrFile, .T.)
   ENDIF 
   
   m.fioFile = 'fio' + qcod + m.pv+ ymmdd + '.dbf'
   m.docFile = 'doc' + qcod + m.pv+ ymmdd + '.dbf'
   m.adrFile = 'adr' + qcod + m.pv+ ymmdd + '.dbf'

   IF FILE('&tcDirPath\&fioFile') AND FILE('&tcDirPath\&docFile') AND FILE('&tcDirPath\&adrFile')
	FOR tParam = 1 TO 999
	 bfioFile    = 'fio' + qcod + m.pv + ymmdd + '.'+PADL(tParam,3,'0')
	 IF !FILE('&tcDirPath\&bfioFile')
	  EXIT 
	 ENDIF 
	ENDFOR 
	RENAME &tcDirPath\&fioFile TO &tcDirPath\&bfioFile
	FOR tParam = 1 TO 999
	 bdocFile    = 'doc' + qcod + m.pv + ymmdd + '.'+PADL(tParam,3,'0')
	 IF !FILE('&tcDirPath\&bdocFile')
	  EXIT 
	 ENDIF 
	ENDFOR 
	RENAME &tcDirPath\&docFile TO &tcDirPath\&bdocFile
	FOR tParam = 1 TO 999
	 badrFile    = 'adr' + qcod + m.pv + ymmdd + '.'+PADL(tParam,3,'0')
	 IF !FILE('&tcDirPath\&badrFile')
	  EXIT 
	 ENDIF 
	ENDFOR 
	RENAME &tcDirPath\&adrFile TO &tcDirPath\&badrFile
   ENDIF

   fso.CopyFile(PTempl+'\fiofile.dbf', tcDirPath+'\'+m.fioFile)
   fso.CopyFile(PTempl+'\docfile.dbf', tcDirPath+'\'+m.docFile)
   fso.CopyFile(PTempl+'\adrfile.dbf', tcDirPath+'\'+m.adrFile)

   =OpenFile(tcDirPath+'\'+m.fioFile, 'fioFile', 'shar')
   =OpenFile(tcDirPath+'\'+m.docFile, 'docFile', 'shar')
   =OpenFile(tcDirPath+'\'+m.adrFile, 'adrFile', 'shar')
   
   m.ppv = m.pv
   m.nrecs = 0
   m.dat1 = {31.12.2999}
   m.dat2 = {01.01.1000}
  ENDIF 

  m.dt = IIF(m.dt={31.12.9999}, {31.12.2099}, m.dt)
   
  m.dat1 = MIN(m.dat1, m.dp)
  m.dat2 = MAX(m.dat2, m.dp)
	 
  m.recid = PADL(m.recid,6,'0')

  m.s_card = IIF(!EMPTY(m.sn_card), LEFT(sn_card,6), '')
  m.n_card = IIF(!EMPTY(m.sn_card), INT(VAL(SUBSTR(sn_card,8))), 0)

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

  m.lpu_id = IIF(SEEK(m.pv, 'pvp2'), pvp2.lpu_id, 0)
  m.predst = INT(val(m.predst))
  m.ul     = adr77.ul
  m.d      = adr77.d
  m.kor    = adr77.kor
  m.str    = adr77.str
  m.kv     = adr77.kv
  m.pricin = IIF(m.jt != 'r', m.pricin, '')
  m.tranz  = IIF(m.jt != 'r', m.tranz, '')
  m.dt     = IIF(m.dt != {31.12.2099} AND !BETWEEN(m.dt, DATE(), DATE()+5*365), {31.12.2099}, m.dt)
   
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
    
  m.ogrn_old  = IIF(m.IsReReg=1, osmo.ogrn, '')
  m.okato_old = IIF(m.IsReReg=1, osmo.okato, '')
  m.dp_old    = IIF(m.IsReReg=1, osmo.dp, {})
*  m.ogrn_old  = osmo.ogrn
*  m.okato_old = osmo.okato
*  m.dp_old    = osmo.dp

  m.nrecs = m.nrecs + 1	
   
  INSERT INTO curdata FROM MEMVAR 

  m.is2fio = IIF(m.pricin='Ï10' AND tranz='À24', '1', m.is2fio)

  IF m.is2fio='1' 
   IF m.pricin='Ï10' AND tranz='À24' && Îáúåäèíÿåì ïîëèñû!

    m.vs        = ''
    m.dt        = {}
*    m.jt        = 'z'
    m.dp        = m.dp_old
     
    IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
     INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
      ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
    ELSE 
     UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
      jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
    ENDIF 

    INSERT INTO fioFile FROM MEMVAR 

    m.s_card    = ''
    m.n_card    = 0

    m.enp       = enp2.enp
	m.dp_old    = enp2.dp
	m.dp        = m.dp_old
    m.okato_old = enp2.okato
    m.ogrn_old  = enp2.ogrn
    m.jt        = '0'
     
    && Äîáàâëåíî 12.12.13 ïî ïðîñüáå Ðåñî
    m.fam = IIF(!EMPTY(m.ofam), m.ofam, m.fam)
    m.im  = IIF(!EMPTY(m.oim), m.oim, m.im)
    m.ot  = IIF(!EMPTY(m.oot), m.oot, m.ot)
    m.w   = IIF(!EMPTY(m.ow), m.ow, m.w)
    m.dr  = IIF(!EMPTY(DTOS(m.odr)), DTOS(m.odr), m.dr)
    && Äîáàâëåíî 12.12.13 ïî ïðîñüáå Ðåñî

    INSERT INTO fioFile FROM MEMVAR 

   ELSE && IF m.pricin='Ï10' AND tranz='À24'

    IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
     INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
      ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
    ELSE 
     UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
      jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
    ENDIF 

    INSERT INTO fioFile FROM MEMVAR 

    m.fam = m.ofam
    m.im  = m.oim
    m.ot  = m.oot
    m.w   = m.ow
    m.dr  = DTOS(m.odr)
    
    && Âíåñåíî 24.10 äëÿ ïðàâèëüíîé ïîäà÷è êîëëèçèé!
    m.jt = '0'
    m.vs = ''
    && Âíåñåíî 24.10 äëÿ ïðàâèëüíîé ïîäà÷è êîëëèçèé!

    INSERT INTO fioFile FROM MEMVAR 

   ENDIF 

  ELSE && IF m.is2fio='1'
   
   IF m.jt == 'r'
    m.ogrn_old  = ''
    m.okato_old = ''
    m.dp_old    = {}
   ENDIF 

   IF !SEEK(PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid, 'moves')
    INSERT INTO moves (et,fname,mkdate,kmsid,frecid,vs,s_card,n_card,enp,dp,jt,pricin,tranz) VALUES ;
     ('1',UPPER(m.fiofile),DATETIME(),kms.recid,m.recid,m.vs,m.s_card,m.n_card,m.enp,m.dp,m.jt,m.pricin,m.tranz)
   ELSE 
    UPDATE moves SET et='1',mkdate=DATETIME(),vs=m.vs,s_card=m.s_card,n_card=m.n_card,enp=m.enp,dp=m.dp,;
     jt=m.jt,pricin=m.pricin,tranz=m.tranz WHERE PADR(UPPER(ALLTRIM(m.fiofile)),25)+m.recid=fname+frecid
   ENDIF 

   INSERT INTO fioFile FROM MEMVAR 

  ENDIF 
  
  m.is2doc = IIF(m.pricin='Ï10' AND tranz='À24', '1', m.is2doc)

  IF m.is2doc='1'
   INSERT INTO docfile (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
    (m.recid,m.c_doc,m.s_doc,m.n_doc,m.d_doc)
   INSERT INTO docfile (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
    (m.recid, m.oc_doc, m.os_doc, m.on_doc,m.od_doc)
  ELSE 
   INSERT INTO docfile FROM MEMVAR

   IF INLIST(m.kl, '45','73','99') AND m.c_perm>0
    INSERT INTO docfile (recid,c_doc,s_doc,n_doc,d_doc) VALUES ;
    (m.recid, m.c_perm, m.s_perm, m.n_perm, m.d_perm)
   ENDIF 

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
   INSERT INTO adrfile FROM MEMVAR 
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
 
 IF USED('fiofile') 
  USE IN fiofile
 ENDIF 
 IF USED('docfile')
  USE IN docfile
 ENDIF 
 IF USED('adrfile')
  USE IN adrfile
 ENDIF 

 ZipClose()
  
 =ClFiles()
 =ClFilesPv()

 INSERT INTO wrkrslt (pv, nrecs, dat1, dat2) VALUES (m.ppv, m.nrecs, m.dat1, m.dat2)
 
 SELECT curdata 
 GO TOP 
 DO FORM formpf

 SELECT wrkrslt
 USE 
* GO TOP 

* DO FORM rsfrm

RETURN 

FUNCTION OpFiles
 oprslt = 0 
 oprslt = oprslt + OpenFile(PBin+'\pvp2', 'pvp2', 'shar', 'codpv')
 oprslt = oprslt + OpenFile(PCommon+'\Jt', 'Jt', 'shar', 'jt')
 oprslt = oprslt + OpenFile(PCommon+'\citytype', 'CityType', 'shar', 'code')
 oprslt = oprslt + OpenFile(PCommon+'\okato', 'okato', 'shar', 'code')
 oprslt = oprslt + OpenFile(pcommon+'\sv5ppl', 'sv5ppl', 'shar', 'unval')
RETURN oprslt

FUNCTION OpFilesPv
 oprslt = 0 
 oprslt = oprslt + OpenFile(PBase+'\kms', 'kms', 'shar')
 oprslt = oprslt + OpenFile(PBase+'\adr77', 'adr77', 'shar', 'recid')
 oprslt = oprslt + OpenFile(PBase+'\adr50', 'adr50', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\e_ffoms', 'efoms', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\error', 'error', 'shar', 'rec_id')
 oprslt = oprslt + OpenFile(pbase+'\moves', 'moves', 'shar', 'unik')
 oprslt = oprslt + OpenFile(pbase+'\enp2', 'enp2', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\permiss', 'permiss', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\ofio', 'ofio', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\odoc', 'odoc', 'shar', 'recid')
 oprslt = oprslt + OpenFile(pbase+'\osmo', 'osmo', 'shar', 'recid')
RETURN oprslt

FUNCTION ClFiles
 IF USED('pvp2')
  USE IN pvp2
 ENDIF 
 IF USED('jt')
  USE IN jt
 ENDIF 
 IF USED('CityType')
  USE IN CityType
 ENDIF 
 IF USED('okato')
  USE IN okato
 ENDIF 
 IF USED('sv5ppl')
  USE IN sv5ppl
 ENDIF 
RETURN 

FUNCTION ClFilesPv
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