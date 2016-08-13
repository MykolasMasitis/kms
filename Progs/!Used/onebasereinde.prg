FUNCTION OneBaseReindE

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, ADR50.DBF..." WINDOW NOWAIT 

 IF OpenFile("&pBase\adr50", "adr50", "EXCLUSIVE")>0
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

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, ADR77.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\adr77", "adr77", "EXCLUSIVE")>0
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

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, ANSWERS.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\Answers", "Answers", "EXCLUSIVE")>0
  IF USED('answers')
   USE IN answers
  ENDIF 
 ELSE 
  SELECT answers
  DELETE TAG ALL 
  INDEX on INT(VAL(recid)) TAG recid
  INDEX on sn_pol TAG sn_pol
  USE 
 ENDIF 
		
 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, E_FFOMS.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\e_ffoms", "Errord", "EXCLUSIVE")>0
  IF USED('errord')
   USE IN errord
  ENDIF 
 ELSE 
  SELECT errord
  DELETE TAG ALL 
  INDEX  on rid tag rid CANDIDATE 
  INDEX ON recid TAG recid
  USE 
 ENDIF 
		
 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, ENP2.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\enp2", "enp2", "EXCLUSIVE")>0
  IF USED('enp2')
   USE IN enp2
  ENDIF 
 ELSE 
  SELECT enp2
  DELETE TAG ALL 
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON enp TAG enp 
  USE 
 ENDIF 
		
 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, ERROR.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\Error", "Error", "EXCLUSIVE")>0
  IF USED('error')
   USE IN error
  ENDIF 
 ELSE 
  SELECT error
  DELETE TAG ALL 
  INDEX on rid TAG rid CANDIDATE 
  INDEX ON rec_id TAG rec_id
  USE 
 ENDIF 
		
 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, KMS.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\kms", "kms", "EXCLUSIVE")>0
  IF USED('kms')
   USE IN kms
  ENDIF 
 ELSE 
  SELECT kms
  DELETE TAG ALL 
  INDEX ON RecId TAG recid CANDIDATE 
*  INDEX ON pv+STR(recid_chld,10) TAG recid_chld 
  INDEX ON nz TAG nz
  INDEX ON sn_card FOR !EMPTY(sn_card) TAG un_ks
  INDEX ON vs TAG vs 
  INDEX ON enp TAG enp
  INDEX ON sn_card TAG sn_card
  INDEX ON INT(VAL(SUBSTR(sn_card, AT(' ',sn_card)+1))) TAG n_card
  INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30))+DTOC(dr) TAG  fio COLLATE "Russian"
  INDEX ON MCOD+' '+UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30)) TAG fio_mcod COLLATE "Russian"
  INDEX ON mcod TAG mcod
  INDEX ON dp TAG dp
  INDEX ON dt TAG dt
  INDEX on pv TAG pv
  USE 
 ENDIF 

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, MOVES.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\moves", "moves", "EXCLUSIVE")>0
  IF USED('moves')
   USE IN moves
  ENDIF 
 ELSE 
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON kmsid TAG kmsid
  INDEX FOR et='1' ON kmsid TAG fiorecid
  INDEX FOR et='2' ON kmsid TAG ffrecid
  INDEX ON fname+frecid TAG unik
  USE 
 ENDIF 

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, PERMISS.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\permiss", "permiss", "EXCLUSIVE")>0
  IF USED('permiss')
   USE IN permiss
  ENDIF 
 ELSE 
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON s_perm+n_perm TAG sn_perm
  USE 
 ENDIF 

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, OFIO.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\ofio", "ofio", "EXCLUSIVE")>0
  IF USED('ofio')
   USE IN ofio
  ENDIF 
 ELSE 
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, ODOC.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\odoc", "odoc", "EXCLUSIVE")>0
  IF USED('odoc')
   USE IN odoc
  ENDIF 
 ELSE 
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, OSMO.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\osmo", "osmo", "EXCLUSIVE")>0
  IF USED('osmo')
   USE IN osmo
  ENDIF 
 ELSE 
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 

 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, PREDST.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\predst", "predst", "EXCLUSIVE")>0
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
		
 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, USER.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\User", "User", "EXCLUSIVE")>0
  IF USED('user')
   USE IN user
  ENDIF 
 ELSE 
  SELECT user
  DELETE TAG ALL 
  INDEX ON ucod TAG ucod CANDIDATE 
  USE 
 ENDIF 
		
 WAIT "ÏÅÐÅÈÍÄÅÊÑÀÖÈß ÁÀÇ ÏÂ, WRKPL.DBF..." WINDOW NOWAIT 
 IF OpenFile("&pBase\wrkpl", "wrkpl", "EXCLUSIVE")>0
  IF USED('wrkpl')
   USE IN wrkpl
  ENDIF 
 ELSE 
  SELECT wrkpl
  DELETE TAG ALL 
  INDEX on recid TAG recid 
  INDEX on LEFT(name,50) TAG name 
  USE 
 ENDIF 

 WAIT CLEAR 

RETURN 