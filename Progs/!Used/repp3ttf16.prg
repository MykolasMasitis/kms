PROCEDURE RepP3TTF16
 IF MESSAGEBOX('¬€ ’Œ“»“≈ —‘ŒÃ»–Œ¬¿“‹ Œ“◊≈“?',4+32, '')==7
  RETURN 
 ENDIF 
 
 tResult = .f.
 DO FORM TuneUp TO tResult
	
 IF !tResult
  RETURN 
 ENDIF 
 
 ocent = SET("Century")
 SET CENTURY ON 
  
 WAIT "œŒƒ Àﬁ◊≈Õ»≈ ¡¿« ƒ¿ÕÕ€’..." WINDOW NOWAIT 
 IF OpenFile("&pBase\kms", "kms", "shar")>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile("&pBase\adr50", "adr50", "SHARED", 'recid')>0
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile("&pBase\adr77", "adr77", "SHARED", 'recid')>0
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 

 =OpenFile(PCommon+'\citytype', 'CityType', 'SHARED', 'code')
 =OpenFile(PCommon+'\okato', 'okato', 'SHARED', 'code')
 =OpenFile("&PCommon\Street", "Street", "SHARED", "Ul")

 SELECT adr50
 SET RELATION TO np_c INTO CityType
 SET RELATION TO c_okato INTO okato ADDITIVE 
 SELECT kms
 SET RELATION TO adr_id INTO adr77
 SET RELATION TO adr50_id INTO adr50 ADDITIVE 
 
 CREATE CURSOR curdata (fam c(25), im c(20), ot c(20), vs c(9), enp c(16), tel c(25), d_enp c(10),;
  adr_reg c(150), fact_adr c(150))
 WAIT CLEAR 

 WAIT "Œ“¡Œ– ƒ¿ÕÕ€’ ¬  ”–—Œ–..." WINDOW NOWAIT 
 SELECT kms 
 SCAN FOR BETWEEN(gz_data, gdCurDat1, gdCurDat2) AND jt!='r'
  m.fam   = ALLTRIM(fam)
  m.im    = ALLTRIM(im)
  m.ot    = ALLTRIM(ot)
  m.vs    = vs
  m.enp   = enp
  m.tel   = ALLTRIM(cont)
  m.d_enp = DTOC(gz_data)

  m.msc_adr  = 'ÃÓÒÍ‚‡, '+IIF(SEEK(adr77.Ul,'Street'), ;
   ALLTRIM(Street.Street),'')+IIF(!EMPTY(adr77.d), ', ‰.'+ALLTRIM(adr77.D),'') +;
   IIF(!EMPTY(adr77.Kor), ', ÍÓÔ.'+ALLTRIM(adr77.Kor),'') + IIF(!EMPTY(adr77.Str), ', ÒÚ.'+ALLTRIM(adr77.Str),'') + ;
   IIF(!EMPTY(adr77.Kv), ', Í‚.'+ALLTRIM(adr77.Kv),'')

  m.adr_obl = UPPER(ALLTRIM(okato.name))
  m.adr_rjn = UPPER(ALLTRIM(adr50.ra_name))
  m.adr_gor = UPPER(ALLTRIM(CityType.name) + ' ' + ALLTRIM(adr50.np_name))
  m.adr_ul  = UPPER(ALLTRIM(adr50.ul_name))
  m.adr_dom = ALLTRIM(adr50.dom)
  m.adr_kor = ALLTRIM(adr50.kor)
  m.adr_str = ALLTRIM(adr50.str)
  m.adr_kvr = ALLTRIM(adr50.kv)

  m.obl_adr = PROPER(m.adr_obl) + IIF(!EMPTY(m.adr_rjn), ', -ÓÌ ' + PROPER(m.adr_rjn), '')+;
   IIF(!EMPTY(m.adr_gor), ', ' + PROPER(m.adr_gor), '') + IIF(!EMPTY(m.adr_ul), ', ' + PROPER(m.adr_ul), '')+;
   IIF(!EMPTY(m.adr_dom), ', ‰. ' + m.adr_dom, '')+IIF(!EMPTY(m.adr_kor), ', ÍÓÔ. ' + m.adr_kor, '')+;
   IIF(!EMPTY(m.adr_str), ', ÒÚ. ' + m.adr_str, '')+IIF(!EMPTY(m.adr_kvr), ', Í‚. ' + m.adr_kvr, '')
 
  m.adr_ter = IIF(BETWEEN(kl,0,27) or kl=45, 45, INT(VAL(LEFT(adr50.c_okato,2))))
  IF m.adr_ter != 45
   m.adr_reg  = m.obl_adr
   m.fact_adr = m.msc_adr
  ELSE 
   m.fact_adr = m.msc_adr
   m.adr_reg = m.msc_adr
  ENDIF 

 INSERT INTO curdata (fam,im,ot,vs,enp,tel,d_enp,adr_reg,fact_adr) VALUES ;
  (m.fam,m.im,m.ot,m.vs,m.enp,m.tel,m.d_enp,m.adr_reg,m.fact_adr)  

 ENDSCAN 
 SET RELATION OFF INTO adr50
 SET RELATION OFF INTO adr77
 USE IN kms 
 SELECT adr50 
 SET RELATION OFF INTO okato
 SET RELATION OFF INTO CityType
 USE IN adr50
 USE IN adr77
 USE IN okato
 USE IN CityType
 USE IN street 

 WAIT CLEAR 
 
 WAIT "‘Œ–Ã»–Œ¬¿Õ»≈ Œ“◊≈“¿..." WINDOW NOWAIT 
 SELECT curdata 
 
* PRIVATE m.pdDate1, m.pdDate2
* m.pdDate1 = {01/12/2012}
* m.pdDate2 = {31/12/2012}

 LOCAL m.lcTmpName, m.lcRepName, m.lcDbfName, m.llResult
 m.lcTmpName = ptempl+'\p3rep.xls'
 m.lcRepName = pOut+'\Jrn_'+DTOS(gdCurDat1)+'_'+DTOS(gdCurDat2)+'.xls'
 m.lcDbfName = 'curdata'

 m.llResult = X_Report(m.lcTmpName, m.lcRepName, .T.)
 WAIT CLEAR 

 IF m.llResult
*	= ShellExecute(0, "open", m.lcRepName, "", "", 1)
 ENDIF

 USE IN (m.lcDbfName)
 
* MESSAGEBOX('√Œ“Œ¬Œ!'+CHR(13)+CHR(10),0+64,'')
 
SET CENTURY &ocent

RETURN 