PROCEDURE CorStruct
 IF MESSAGEBOX('¬€ ’Œ“»“≈ œ–Œ¬≈—“» '+CHR(13)+CHR(10)+;
               ' Œ––≈ “»–Œ¬ ” —“–” “”–€ ¡ƒ?!'+CHR(13)+CHR(10)+;
               '',4+48,'') != 6
  RETURN 
 ENDIF 

 IF MESSAGEBOX('¬€ ¿¡—ŒÀﬁ“ÕŒ ”¬≈–≈Õ€ ¬ —¬Œ»’ ƒ≈…—“¬»ﬂ’?',4+48,'') != 6
  RETURN 
 ENDIF 
 
 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ‘¿…À MFC_PV.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\mfc_pv', 'mfc', 'shar', 'pv')>0
  IF USED('mfc')
   USE IN mfc
  ENDIF 
  RETURN 
 ENDIF 

 SELECT pvp2
 SCAN
  m.codpv = codpv
  m.lcpath = pbase+'\'+m.codpv
  IF !fso.FolderExists(m.lcpath)
   LOOP 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\kms.dbf')
   LOOP
  ENDIF 

 IF !fso.FileExists(m.lcpath+'\stop.dbf')
  m.lIsNeedReind = .t.
  CREATE TABLE &lcpath\stop (recid i autoinc, jt c(1), sn_card c(17), q c(2), ;
   sn_cardz c(17), qz c(2), date_end d, date_arc d, ist c(1), enp c(16), vs c(9))
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON sn_card TAG sn_card 
  USE 
 ENDIF 
 
 IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  LOOP 
 ENDIF 

  m.IsMfc=IIF(SEEK(m.codpv, 'mfc'), .T., .F.)

  WAIT m.codpv+'...' WINDOW NOWAIT 
  
  SELECT kms
  
  IF FIELD('OBL_NAME')=='OBL_NAME'
   ALTER TABLE kms DROP COLUMN obl_name
  ENDIF 
  IF FIELD('POS')=='POS'
   ALTER TABLE kms DROP COLUMN pos
  ENDIF 

  IF FIELD('recid_chld')!='RECID_CHLD'
   ALTER TABLE kms ADD COLUMN recid_chld i 
  ENDIF 
  IF FIELD('pv')!='PV'
   ALTER TABLE kms ADD COLUMN pv c(3)
  ENDIF 
  IF FIELD('SCN')!='SCN'
   ALTER TABLE kms ADD COLUMN scn c(3)
  ENDIF 
  IF FIELD('GZK_FLAG')!='GZK_FLAG'
   ALTER TABLE kms ADD COLUMN gzk_flag n(1)
  ENDIF 
  IF FIELD('DOC_FLAG')!='DOC_FLAG'
   ALTER TABLE kms ADD COLUMN doc_flag n(1)
  ENDIF 
  IF FIELD('UEC_FLAG')!='UEC_FLAG'
   ALTER TABLE kms ADD COLUMN uec_flag c(1)
  ENDIF 
  IF FIELD('E_DOC')!='E_DOC'
   ALTER TABLE kms ADD COLUMN e_doc d
  ENDIF 
  IF FIELD('ktg')!='KTG'
   ALTER TABLE kms ADD COLUMN ktg c(1)
  ENDIF 

  IF FIELD('oper')!='OPER'
   ALTER TABLE kms ADD COLUMN oper i
   IF fso.FileExists(m.lcpath+'\user.dbf')
    IF OpenFile(m.lcpath+'\user', 'uusr', 'shar')<=0
     IF RECCOUNT('uusr')>0
      SELECT uusr
      GO TOP 
      m.oper = ucod
      SELECT kms 
      REPLACE ALL oper WITH m.oper
     ENDIF 
     IF USED('uusr')
      USE IN uusr
     ENDIF 
    ELSE 
     IF USED('uusr')
      USE IN uusr
     ENDIF 
    ENDIF 
   ENDIF 
  ENDIF 
  
  IF FIELD('predstid') != 'PREDSTID'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ PREDST.DBF..." WINDOW NOWAIT 
    IF fso.FileExists(m.lcpath+'\predst.dbf')
     IF OpenFile(m.lcpath+'\predst', 'predst', 'excl')<=0
      ALTER table kms ADD COLUMN predstid i 
      SET ORDER TO recid IN kms 

      USE IN predst
      fso.CopyFile(m.lcpath+'\predst.dbf', m.lcpath+'\_predst.dbf')
      fso.CopyFile(m.lcpath+'\predst.cdx', m.lcpath+'\_predst.cdx')
      fso.DeleteFile(m.lcpath+'\predst.dbf')
      fso.DeleteFile(m.lcpath+'\predst.cdx')

      =OpenFile(m.lcpath+'\_predst', 'prdst', 'shar')
      
      CREATE TABLE &lcpath\predst ;
      (RecId i AUTOINC NEXTVALUE 1 STEP 1, Fam c(40), Im c(40), Ot c(40), ;
       c_doc n(2), s_doc c(9), n_doc c(8), d_doc d, podr_doc c(100), tel1 c(10), tel2 c(10), ;
       inf c(100) )
      INDEX ON RecId TAG RecId CANDIDATE 
      INDEX ON LEFT(Fam,25)+LEFT(Im,3)+LEFT(Ot,3) TAG fio
      SET ORDER TO fio
      
      SELECT prdst
      SCAN 
       IF EMPTY(fam)
        LOOP 
       ENDIF 

       SCATTER FIELDS EXCEPT recid MEMVAR 
       m.fio = LEFT(m.fam,25)+LEFT(m.im,3)+LEFT(m.ot,3)
       m.predstid = 0
       IF !SEEK(m.fio, 'predst')
        INSERT INTO predst FROM MEMVAR 
        m.predstid = GETAUTOINCVALUE()
       ELSE 
        m.predstid = predst.recid
       ENDIF 
       
       UPDATE kms SET predstid=m.predstid WHERE recid=m.kmsid
       
      ENDSCAN 
      USE IN prdst 
      USE IN predst 
      USE IN kms 
      fso.DeleteFile(m.lcpath+'\_predst.dbf')
      fso.DeleteFile(m.lcpath+'\_predst.cdx')
      =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
     ENDIF 
    ENDIF 
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('wrkid')!='WRKID'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN wrkid i 
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    CREATE TABLE &lcpath\wrkpl (recid i AUTOINC, code c(3), name c(100))
    INDEX ON recid TAG recid 
    INDEX ON LEFT(name,50) TAG name 
    USE 
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('act')!='ACT'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN act l
    REPLACE ALL act WITH .t.
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('X_DOC')!='X_DOC'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN x_doc n(1)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('p_doc2')!='P_DOC2'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN p_doc2 n(1)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('S_CARD2')!='S_CARD2'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN s_card2 c(12)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('N_CARD2')!='N_CARD2'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN n_card2 c(32)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('S_CARD')!='S_CARD'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN s_card c(12)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('operpv')!='OPERPV'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN operpv i
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('plant')!='PLANT'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN plant c(5)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('blanc')!='BLANC'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN blanc c(11)
    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF FIELD('N_CARD')!='N_CARD'
   USE IN kms
   IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
    WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ KMS.DBF..." WINDOW NOWAIT 
    SELECT kms
    ALTER TABLE kms ADD COLUMN n_card c(32)
    SCAN 
    IF EMPTY(sn_card)
     LOOP 
    ENDIF 
    
    DO CASE 
     CASE IsKms(sn_card)
      m.s_card = IIF(!EMPTY(sn_card), LEFT(sn_card,6), '')
      m.n_card = IIF(!EMPTY(sn_card), PADL(INT(VAL(SUBSTR(sn_card,8))),10,'0'), '')
     CASE IsVs(sn_card)
      m.s_card = IIF(!EMPTY(sn_card), LEFT(sn_card,5), '')
      m.n_card = IIF(!EMPTY(sn_card), PADL(INT(VAL(SUBSTR(sn_card,7))),9,'0'), 0)
     OTHERWISE 
      m.sn_card = ALLTRIM(sn_card)
      m.nspace = AT(m.sn_card, ' ')
      m.s_card = IIF(!EMPTY(sn_card), LEFT(sn_card, m.nspace-1), '')
      m.n_card = IIF(!EMPTY(sn_card), SUBSTR(sn_card,m.nspace+1), '')
    ENDCASE 
    REPLACE s_card WITH m.s_card, n_card WITH m.n_card
    ENDSCAN 

    USE IN kms
    =OpenFile(m.lcpath+'\kms', 'kms', 'shar')
    WAIT CLEAR 
   ENDIF 
  ENDIF 

  IF USED('kms')
   USE IN kms
  ENDIF 

  IF fso.FileExists(m.lcpath+'\kms.bak')
   fso.DeleteFile(m.lcpath+'\kms.bak')
  ENDIF 
  IF fso.FileExists(m.lcpath+'\kms.tbk')
   fso.DeleteFile(m.lcpath+'\kms.tbk')
  ENDIF 

  IF OpenFile(m.lcpath+'\e_ffoms', 'error', 'shar')>0
   IF USED('error')
    USE IN error
   ENDIF 
  ELSE 
   SELECT error 

   IF FIELD('fname')!='FNAME'
    IF USED('error')
     USE IN error
    ENDIF 
    IF OpenFile(m.lcpath+'\e_ffoms', 'error', 'excl')>0
     IF USED('error')
      USE IN error
     ENDIF 
    ELSE 
     SELECT error 
     ALTER TABLE error add COLUMN fname c(25)
     USE 
     =OpenFile(m.lcpath+'\e_ffoms', 'error', 'shar')
     SELECT error
    ENDIF 
   ENDIF 

   IF FIELD(1)!='RID'
    IF USED('error')
     USE IN error
    ENDIF 
    IF OpenFile(m.lcpath+'\e_ffoms', 'error', 'excl')>0
     IF USED('error')
      USE IN error
     ENDIF 
    ELSE 
     SELECT error 
     DELETE TAG ALL 
     ALTER TABLE error drop COLUMN rid
     USE 
     fso.CopyFile(m.lcpath+'\e_ffoms.dbf', m.lcpath+'\_e_ffoms.dbf')
     fso.DeleteFile(m.lcpath+'\e_ffoms.dbf')
     CREATE TABLE &lcpath\e_ffoms (rid i AUTOINC, recid i, data d, err c(5), comment c(250), c_t c(5), ;
      pid c(16), ans_fl c(2), step c(4), dcor d, v l)
     INDEX ON rid TAG rid CANDIDATE 
     INDEX ON recid TAG recid
     USE 
     =OpenFile(m.lcpath+'\e_ffoms', 'error', 'shar')>0
   
     IF OpenFile(m.lcpath+'\_e_ffoms', 'errold', 'shar')>0
      IF USED('errold')
       USE IN errold
      ENDIF 
      IF USED('error')
       USE IN error
      ENDIF
     ELSE 
      SELECT errold
      SCAN 
       SCATTER MEMVAR 
       INSERT INTO error FROM MEMVAR 
      ENDSCAN 
      IF USED('errold')
       USE IN errold
      ENDIF 
      IF USED('error')
       USE IN error
      ENDIF
      fso.DeleteFile(m.lcpath+'\_e_ffoms.dbf')
     ENDIF 
    ENDIF 
   ELSE 
    IF USED('error')
     USE IN error
    ENDIF
   ENDIF 
  ENDIF 
  IF USED('error')
   USE IN error
  ENDIF
  IF fso.FileExists(m.lcpath+'\e_ffoms.bak')
   fso.DeleteFile(m.lcpath+'\e_ffoms.bak')
  ENDIF 

  IF OpenFile(m.lcpath+'\error', 'error', 'shar')>0
   IF USED('error')
    USE IN error
   ENDIF 
  ELSE 
   SELECT error 
   IF FIELD(1)!='RID'
    IF USED('error')
     USE IN error
    ENDIF 
    IF OpenFile(m.lcpath+'\error', 'error', 'excl')>0
     IF USED('error')
      USE IN error
     ENDIF 
    ELSE 
     SELECT error 
     DELETE TAG ALL 
     ALTER TABLE error drop COLUMN rid
     USE 
     fso.CopyFile(m.lcpath+'\error.dbf', m.lcpath+'\_error.dbf')
     fso.DeleteFile(m.lcpath+'\error.dbf')
     CREATE TABLE &lcpath\error (rid i autoinc, rec_id c(6), s_card c(6), n_card n(10), n_date d, q c(2), err c(2),;
      err_text c(40), app_d d, v l, dcor d)
     INDEX on rid TAG rid CANDIDATE 
     INDEX on rec_id TAG rec_id 
     SET ORDER TO rid 
     USE 
     =OpenFile(m.lcpath+'\error', 'error', 'shar')>0
   
     IF OpenFile(m.lcpath+'\_error', 'errold', 'shar')>0
      IF USED('errold')
       USE IN errold
      ENDIF 
      IF USED('error')
       USE IN error
      ENDIF
     ELSE 
      SELECT errold
      SCAN 
       SCATTER MEMVAR 
       INSERT INTO error FROM MEMVAR 
      ENDSCAN 
      IF USED('errold')
       USE IN errold
      ENDIF 
      IF USED('error')
       USE IN error
      ENDIF
      fso.DeleteFile(m.lcpath+'\_error.dbf')
     ENDIF 
    ENDIF 
   ELSE 
    IF USED('error')
     USE IN error
    ENDIF
   ENDIF 
  ENDIF 
  IF USED('error')
   USE IN error
  ENDIF
  IF fso.FileExists(m.lcpath+'\error.bak')
   fso.DeleteFile(m.lcpath+'\error.bak')
  ENDIF 

  IF OpenFile(m.lcpath+'\moves', 'moves', 'shar')>0
  ELSE 
   SELECT moves
   IF FIELD('scn')!='SCN'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN scn c(3)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('fam')!='FAM'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN fam c(25)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('im')!='IM'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN im c(20)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('ot')!='OT'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN ot c(20)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('dr')!='DR'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN dr d 
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('c_doc')!='C_DOC'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN c_doc n(2)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('s_doc')!='S_DOC'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN s_doc c(9)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('n_doc')!='N_DOC'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN n_doc c(8)
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('d_doc')!='D_DOC'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN d_doc d
     USE 
    ENDIF 
   ELSE 
   ENDIF 

   IF FIELD('e_doc')!='E_DOC'
    IF USED('moves')
     USE IN moves
    ENDIF 
    IF OpenFile(m.lcpath+'\moves', 'moves', 'excl')>0
    ELSE 
     SELECT moves
     ALTER TABLE moves ADD COLUMN e_doc d
     USE 
    ENDIF 
   ELSE 
   ENDIF 

  ENDIF 
  IF USED('moves')
   USE IN moves
  ENDIF
  IF fso.FileExists(m.lcpath+'\moves.bak')
   fso.DeleteFile(m.lcpath+'\moves.bak')
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\adr77.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ ADR77.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\adr77 (recid i AUTOINC, ul n(5), d c(7), kor c(5), str c(5), kv c(5))
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON PADL(ul,5,'0')+d+kor+str+kv TAG unik 
   SET ORDER TO unik 
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('adr_id')!='ADR_ID'
      ALTER TABLE kms ADD COLUMN ADR_ID i 
     ENDIF 
     
     SCAN  
      m.ul  = ul
      m.d   = LOWER(PADR(ALLTRIM(d),7))
      m.kor = LOWER(PADR(ALLTRIM(kor),5))
      m.str = LOWER(PADR(ALLTRIM(str),5))
      m.kv  = LOWER(PADR(ALLTRIM(kv),5))
      
      m.unik = PADL(m.ul,5,'0') + m.d + m.kor + m.str + m.kv
      IF !SEEK(m.unik, 'adr77')
       INSERT INTO adr77 (ul,d,kor,str,kv) VALUES (m.ul,m.d,m.kor,m.str,m.kv)
       m.adr_id = GETAUTOINCVALUE()
      ELSE 
       m.adr_id = adr77.recid 
      ENDIF 
      REPLACE adr_id WITH m.adr_id
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN ul 
     ALTER TABLE kms DROP COLUMN d
     ALTER TABLE kms DROP COLUMN kor 
     ALTER TABLE kms DROP COLUMN str
     ALTER TABLE kms DROP COLUMN kv
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('adr77')
     USE IN adr77
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\adr50.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ ADR50.DBF..." WINDOW NOWAIT 

   CREATE TABLE &lcpath\adr50 (recid i AUTOINC, c_okato c(5), ra_name c(60), np_c c(2), ;
    np_name c(60), ul_c c(2), ul_name c(60), dom c(7), kor c(5), str c(5), kv c(5))
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON c_okato+LEFT(ra_name,10)+LEFT(np_name,10)+LEFT(ul_name,10)+dom+kor+str+kv TAG unik 
   SET ORDER TO unik 
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('adr50_id')!='ADR50_ID'
      ALTER TABLE kms ADD COLUMN ADR50_ID i 
     ENDIF 
     
     SCAN  
      m.c_okato = c_okato
      IF EMPTY(m.c_okato)
       LOOP 
      ENDIF 
      m.ra_name = UPPER(ALLTRIM(ra_name))
      m.np_c    = np_c
      m.np_name = UPPER(ALLTRIM(np_name))
      m.ul_c    = ul_c
      m.ul_name = UPPER(ALLTRIM(ul_name))
      m.dom     = LOWER(PADR(ALLTRIM(dom2),7))
      m.kor     = LOWER(PADR(ALLTRIM(kor2),5))
      m.str     = LOWER(PADR(ALLTRIM(str2),5))
      m.kv      = LOWER(PADR(ALLTRIM(kv2),5))
      
      m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom+m.kor+m.str+m.kv
      IF !SEEK(m.unik, 'adr50')
       INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
        (m.c_okato, m.ra_name, m.np_c, m.np_name, m.ul_c, m.ul_name, m.dom, m.kor, m.str, m.kv)
       m.adr50_id = GETAUTOINCVALUE()
      ELSE 
       m.adr50_id = adr50.recid 
      ENDIF 
      REPLACE adr50_id WITH m.adr50_id
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN c_okato
     ALTER TABLE kms DROP COLUMN ra_name
     ALTER TABLE kms DROP COLUMN np_c 
     ALTER TABLE kms DROP COLUMN np_name
     ALTER TABLE kms DROP COLUMN ul_c
     ALTER TABLE kms DROP COLUMN ul_name 
     ALTER TABLE kms DROP COLUMN dom2
     ALTER TABLE kms DROP COLUMN kor2 
     ALTER TABLE kms DROP COLUMN str2
     ALTER TABLE kms DROP COLUMN kv2
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('adr50')
     USE IN adr50
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\enp2.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ ENP2.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\enp2 (recid i AUTOINC, enp c(16), ogrn c(13), okato c(5), dp d)
   INDEX ON recid TAG recid CANDIDATE 
   INDEX on enp TAG enp 
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('en2id')!='ENP2ID'
      ALTER TABLE kms ADD COLUMN ENP2ID i 
     ENDIF 
     
     SCAN  
      IF EMPTY(enp2)
       LOOP 
      ENDIF 
      
      m.enp   = enp2
      m.ogrn  = ogrn_old2
      m.okato = okato_old2
      m.dp    = dp_old2
      
      INSERT INTO enp2 (enp,ogrn,okato,dp) VALUES (m.enp,m.ogrn,m.okato,m.dp)
      m.enp2id = GETAUTOINCVALUE()
      REPLACE enp2id WITH m.enp2id
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN enp2
     ALTER TABLE kms DROP COLUMN ogrn_old2
     ALTER TABLE kms DROP COLUMN okato_old2
     ALTER TABLE kms DROP COLUMN dp_old2
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('enp2')
     USE IN enp2
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\permiss.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ PERMISS.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\permiss (recid i AUTOINC, c_perm n(2), s_perm c(9), n_perm c(8), d_perm d)
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON s_perm+n_perm TAG sn_perm
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('permid')!='PERMID'
      ALTER TABLE kms ADD COLUMN PERMID i 
     ENDIF 
     
     IF FIELD('c_perm')='C_PERM'
     SCAN  
      IF EMPTY(n_perm)
       LOOP 
      ENDIF 
      
      m.c_perm = c_perm
      m.s_perm = s_perm
      m.n_perm = n_perm
      m.d_perm = d_perm
      
      INSERT INTO permiss (c_perm,s_perm,n_perm,d_perm) VALUES (m.c_perm,m.s_perm,m.n_perm,m.d_perm)
      m.permid = GETAUTOINCVALUE()
      REPLACE permid WITH m.permid
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN c_perm
     ALTER TABLE kms DROP COLUMN s_perm
     ALTER TABLE kms DROP COLUMN n_perm
     ALTER TABLE kms DROP COLUMN d_perm
     ENDIF 
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('permiss')
     USE IN permiss
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ELSE 
   =OpenFile(m.lcpath+'\permiss', 'permiss', 'shar')
   SELECT permiss
   IF FIELD('E_PERM')!='E_PERM'
    USE IN permiss
    IF OpenFile(m.lcpath+'\permiss', 'permiss', 'excl')<=0
     WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ PERMISS.DBF..." WINDOW NOWAIT 
     SELECT permiss
     ALTER TABLE permiss ADD COLUMN e_perm d
     USE IN permiss
*     =OpenFile(m.lcpath+'\odoc', 'odoc', 'shar')
     WAIT CLEAR 
    ENDIF 
   ENDIF 
   IF USED('permiss')
    USE IN permiss
   ENDIF 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\permis2.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ PERMIS2.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\permis2 (recid i AUTOINC, c_perm n(2), s_perm c(9), n_perm c(8), d_perm d, e_perm d)
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON s_perm+n_perm TAG sn_perm
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('perm2id')!='PERM2ID'
      ALTER TABLE kms ADD COLUMN PERM2ID i 
     ENDIF 
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('permis2')
     USE IN permis2
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ELSE 

  ENDIF 

  IF !fso.FileExists(m.lcpath+'\ofio.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ OFIO.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\ofio (recid i AUTOINC, fam c(40), im c(40), ot c(40), dr d, w n(1))
   INDEX ON recid TAG recid CANDIDATE 
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('ofioid')!='OFIOID'
      ALTER TABLE kms ADD COLUMN OFIOID i 
     ENDIF 
     
     IF FIELD('ofam')='OFAM'
     SCAN  
      IF EMPTY(ofam) AND EMPTY(oim) AND EMPTY(oot) AND EMPTY(odr) AND EMPTY(ow)
       LOOP 
      ENDIF 
      
      m.fam = ofam
      m.im = oim
      m.ot = oot
      m.dr = odr
      m.w = ow
      
      INSERT INTO ofio (fam,im,ot,w,dr) VALUES (m.fam,m.im,m.ot,m.w,m.dr)
      m.ofioid = GETAUTOINCVALUE()
      REPLACE ofioid WITH m.ofioid
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN ofam
     ALTER TABLE kms DROP COLUMN oim
     ALTER TABLE kms DROP COLUMN oot
     ALTER TABLE kms DROP COLUMN odr
     ALTER TABLE kms DROP COLUMN ow
     ENDIF 
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('ofio')
     USE IN ofio
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\odoc.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ ODOC.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\odoc (recid i AUTOINC, c_doc n(2), s_doc c(9), n_doc c(8), d_doc d)
   INDEX ON recid TAG recid CANDIDATE 
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('odocid')!='ODOCID'
      ALTER TABLE kms ADD COLUMN ODOCID i 
     ENDIF 
     
     IF FIELD('oc_doc')='OC_DOC'
     SCAN  
      IF EMPTY(oc_doc)
       LOOP 
      ENDIF 
      
      m.c_doc = oc_doc
      m.s_doc = os_doc
      m.n_doc = on_doc
      m.d_doc = od_doc
      
      INSERT INTO odoc (c_doc,s_doc,n_doc,d_doc) VALUES (m.c_doc,m.s_doc,m.n_doc,m.d_doc)
      m.odocid = GETAUTOINCVALUE()
      REPLACE odocid WITH m.odocid
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN oc_doc
     ALTER TABLE kms DROP COLUMN os_doc
     ALTER TABLE kms DROP COLUMN on_doc
     ALTER TABLE kms DROP COLUMN od_doc
     ENDIF 
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('odoc')
     USE IN odoc
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ELSE 
   =OpenFile(m.lcpath+'\odoc', 'odoc', 'shar')
   SELECT odoc
   IF FIELD('X_DOC')!='X_DOC'
    USE IN odoc
    IF OpenFile(m.lcpath+'\odoc', 'odoc', 'excl')<=0
     WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ ODOC.DBF..." WINDOW NOWAIT 
     SELECT odoc
     ALTER TABLE odoc ADD COLUMN x_doc n(1)
     USE IN odoc
*     =OpenFile(m.lcpath+'\odoc', 'odoc', 'shar')
     WAIT CLEAR 
    ENDIF 
   ELSE 
    USE IN odoc 
   ENDIF 
   =OpenFile(m.lcpath+'\odoc', 'odoc', 'shar')
   SELECT odoc
   IF FIELD('E_DOC')!='E_DOC'
    USE IN odoc
    IF OpenFile(m.lcpath+'\odoc', 'odoc', 'excl')<=0
     WAIT " Œ––≈ “»–Œ¬ ¿ —“–” “”–€ ODOC.DBF..." WINDOW NOWAIT 
     SELECT odoc
     ALTER TABLE odoc ADD COLUMN e_doc d
     USE IN odoc
*     =OpenFile(m.lcpath+'\odoc', 'odoc', 'shar')
     WAIT CLEAR 
    ENDIF 
   ELSE 
    USE IN odoc 
   ENDIF 
   IF USED('odoc')
    USE IN odoc
   ENDIF 
  ENDIF 

  IF !fso.FileExists(m.lcpath+'\osmo.dbf')
   WAIT "—Œ«ƒ¿Õ»≈ ‘¿…À¿ OSMO.DBF..." WINDOW NOWAIT 
   CREATE TABLE &lcpath\osmo (recid i AUTOINC, ogrn c(13), okato c(5), dp d)
   INDEX ON recid TAG recid CANDIDATE 
   IF fso.FileExists(m.lcpath+'\kms.dbf')
    IF OpenFile(m.lcpath+'\kms', 'kms', 'excl')<=0
     SELECT kms 
     IF FIELD('osmoid')!='OSMOID'
      ALTER TABLE kms ADD COLUMN OSMOID i 
     ENDIF 
     
     SCAN  
      IF EMPTY(ogrn_old) OR EMPTY(okato_old) OR EMPTY(dp_old)
       LOOP 
      ENDIF 
      
      m.ogrn  = ogrn_old
      m.okato = okato_old
      m.dp    = dp_old
      
      INSERT INTO osmo (ogrn,okato,dp) VALUES (m.ogrn,m.okato,m.dp)
      m.osmoid = GETAUTOINCVALUE()
      REPLACE osmoid WITH m.osmoid
      
     ENDSCAN 
     
     ALTER TABLE kms DROP COLUMN ogrn_old
     ALTER TABLE kms DROP COLUMN okato_old
     ALTER TABLE kms DROP COLUMN dp_old
     
     IF fso.FileExists(m.lcpath+'\kms.bak')
      fso.DeleteFile(m.lcpath+'\kms.bak')
     ENDIF 

     IF fso.FileExists(m.lcpath+'\kms.tbk')
      fso.DeleteFile(m.lcpath+'\kms.tbk')
     ENDIF 
    ELSE 
    ENDIF 
    IF USED('kms')
     USE IN kms
    ENDIF 
    IF USED('osmo')
     USE IN osmo
    ENDIF 
   ENDIF 
   WAIT CLEAR 
  ENDIF 

  WAIT CLEAR 
 ENDSCAN 

 USE IN pvp2

 IF USED('mfc')
  USE IN mfc
 ENDIF 
 
 WAIT CLEAR 

 MESSAGEBOX('OK!', 0+64, '')

RETURN 