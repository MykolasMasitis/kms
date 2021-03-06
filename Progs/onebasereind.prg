FUNCTION OneBaseReind(ppv)

  IF PARAMETERS()<=0
   m.ppv = ''
  ELSE 
   m.ppv = ppv
  ENDIF 

  IF INLIST(SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1),'KMS.EXE','KMSPV.EXE')
   m.lppath = pBase
   m.kol_pv = 1
  ELSE 
   m.lppath = pBase+'\'+m.ppv
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", ADR50.DBF..." WINDOW NOWAIT 

  IF OpenFile(pbin+'\pvp2', 'pvp2', 'excl')>0
   IF USED('pvp2')
    USE IN pvp2
   ENDIF 
  ELSE 
   SELECT pvp2
   INDEX ON codpv TAG codpv
   INDEX ON name_pv TAG name_pv
   USE 
  ENDIF 
  
  IF OpenFile(pbin+'\smo', 'smo', 'excl')>0
   IF USED('smo')
    USE IN smo
   ENDIF 
  ELSE 
   SELECT smo 
   INDEX ON code TAG code 
   USE 
  ENDIF 
  
  IF OpenFile("&lppath\adr50", "adr50", "EXCLUSIVE")>0
   IF USED('adr50')
    USE IN adr50
   ENDIF 
  ELSE 
   SELECT adr50
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON c_okato+LEFT(ra_name,10)+LEFT(np_name,10)+LEFT(ul_name,10)+dom+kor+str+kv TAG unik 
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", ADR77.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\adr77", "adr77", "EXCLUSIVE")>0
   IF USED('adr77')
    USE IN adr77
   ENDIF 
  ELSE 
   SELECT adr77
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON PADL(ul,5,'0')+d+kor+str+kv TAG unik 
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", ANSWERS.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\Answers", "Answers", "EXCLUSIVE")>0
   IF USED('answers')
    USE IN answers
   ENDIF 
  ELSE 
   SELECT answers
   DELETE TAG ALL 
   INDEX ON INT(VAL(recid)) TAG recid
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", E_FFOMS.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\e_ffoms", "Errord", "EXCLUSIVE")>0
   IF USED('errord')
    USE IN errord
   ENDIF 
  ELSE 
   SELECT errord
   DELETE TAG ALL 
   INDEX ON recid TAG recid
   INDEX for EMPTY(dcor) on recid tag recidn
   INDEX ON rid TAG rid CANDIDATE 
   INDEX ON fname+PADL(recid,6,'0') TAG unik
   USE 
  ENDIF 
		
  WAIT "�������������� ��� �� "+ppv+", ENP2.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\enp2", "enp2", "EXCLUSIVE")>0
   IF USED('')
    USE IN 
   ENDIF 
  ELSE 
   SELECT enp2
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON enp TAG enp 
   USE 
  ENDIF 
		
  WAIT "�������������� ��� �� "+ppv+", ERROR.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\Error", "Error", "EXCLUSIVE")>0
   IF USED('error')
    USE IN error
   ENDIF 
  ELSE 
   SELECT error
   DELETE TAG ALL 
   INDEX ON rec_id TAG rec_id
   INDEX on rec_id + DTOS(app_d) TAG unik
   INDEX ON rid TAG rid CANDIDATE 
   USE 
  ENDIF 
		
  WAIT "�������������� ��� �� "+ppv+", KMS.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\kms", "kms", "EXCLUSIVE")>0
   IF USED('kms')
    USE IN kms
   ENDIF 
  ELSE 
   SELECT kms
   DELETE TAG ALL 
   INDEX ON RecId TAG recid CANDIDATE 
   IF !INLIST(SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1),'KMS.EXE','KMSPV.EXE')
    INDEX ON pv+STR(recid_chld,10) TAG recid_chld
   ENDIF 
   IF m.qcod!='S6'
    MESSAGEBOX('!S6',0+64,'')
    INDEX ON nz TAG nz
   ELSE 
    MESSAGEBOX('S6',0+64,'')
    INDEX ON nz TAG nnz
   ENDIF 
*   INDEX ON sn_card FOR !EMPTY(sn_card) TAG un_ks
   INDEX ON vs TAG vs 
   INDEX ON enp TAG enp
   INDEX ON sn_card TAG sn_card
   INDEX ON INT(VAL(SUBSTR(sn_card, AT(' ',sn_card)+1))) TAG n_card
   INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30))+DTOC(dr) TAG  fio COLLATE "Russian"
*   INDEX ON MCOD+' '+UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30)) TAG fio_mcod COLLATE "Russian"
*   INDEX ON mcod TAG mcod
   INDEX ON dp TAG dp
   INDEX ON dt TAG dt
   INDEX ON plant TAG plant
   INDEX ON ss TAG ss
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", MOVES.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\moves", "moves", "EXCLUSIVE")>0
   IF USED('moves')
    USE IN moves
   ENDIF 
  ELSE 
   SELECT moves 
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON kmsid TAG kmsid
   INDEX FOR et='1' ON kmsid TAG fiorecid
   INDEX FOR et='2' ON kmsid TAG ffrecid
   INDEX ON fname+frecid TAG unik
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", PERMISS.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\permiss", "permiss", "EXCLUSIVE")>0
   IF USED('permiss')
    USE IN permiss
   ENDIF 
  ELSE 
   SELECT permiss 
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON s_perm+n_perm TAG sn_perm
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", PERMIS2.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\permis2", "permiss", "EXCLUSIVE")>0
   IF USED('permiss')
    USE IN permiss
   ENDIF 
  ELSE 
   SELECT permiss 
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON s_perm+n_perm TAG sn_perm
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", OFIO.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\ofio", "ofio", "EXCLUSIVE")>0
   IF USED('ofio')
    USE IN ofio
   ENDIF 
  ELSE 
   SELECT ofio 
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", OSMO.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\osmo", "osmo", "EXCLUSIVE")>0
   IF USED('osmo')
    USE IN osmo
   ENDIF 
  ELSE 
   SELECT osmo 
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", ODOC.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\odoc", "odoc", "EXCLUSIVE")>0
   IF USED('odoc')
    USE IN odoc
   ENDIF 
  ELSE 
   SELECT odoc
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", PREDST.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\predst", "predst", "EXCLUSIVE")>0
   IF USED('predst')
    USE IN predst
   ENDIF 
  ELSE 
   SELECT predst
   DELETE TAG ALL 
   INDEX ON RecId TAG RecId CANDIDATE 
   INDEX ON LEFT(Fam,25)+LEFT(Im,3)+LEFT(Ot,3) TAG fio
   USE 
  ENDIF 
		
  WAIT "�������������� ��� �� "+ppv+", USER.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\User", "User", "EXCLUSIVE")>0
   IF USED('user')
    USE IN user
   ENDIF 
  ELSE 
   SELECT user
   DELETE TAG ALL 
   INDEX ON ucod TAG ucod
   USE 
  ENDIF 
		
  WAIT "�������������� ��� �� "+ppv+", STOP.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\Stop", "Stop", "EXCLUSIVE")>0
   IF USED('stop')
    USE IN stop
   ENDIF 
  ELSE 
   SELECT stop
   DELETE TAG ALL 
   INDEX ON recid TAG recid CANDIDATE 
   INDEX ON sn_card TAG sn_card 
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", STOP.DBF..." WINDOW NOWAIT 
  IF OpenFile("&lppath\WrkPl", "wrkpl", "EXCLUSIVE")>0
   IF USED('wrkpl')
    USE IN wrkpl
   ENDIF 
  ELSE 
   SELECT wrkpl
   DELETE TAG ALL 
   INDEX ON recid TAG recid
   INDEX ON LEFT(name,50) TAG name
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", PLANTS.DBF..." WINDOW NOWAIT 
  IF OpenFile("&pcommon\plants", "plants", "EXCLUSIVE")>0
   IF USED('plants')
    USE IN plants
   ENDIF 
  ELSE 
   SELECT plants
   DELETE TAG ALL 
   INDEX ON recid TAG recid
   INDEX ON code TAG code
   USE 
  ENDIF 

  WAIT "�������������� ��� �� "+ppv+", LOG.DBF..." WINDOW NOWAIT 
  IF fso.FileExists(pbase+'\log.dbf')
  IF OpenFile(pbase+'\log', "log", "EXCLUSIVE")>0
   IF USED('log')
    USE IN log
   ENDIF 
  ELSE 
   SELECT log 
   DELETE TAG ALL 
   INDEX on recid TAG recid CANDIDATE 
   INDEX on kmsid TAG kmsid
   USE 
  ENDIF 
  ENDIF 

  WAIT CLEAR 

RETURN 