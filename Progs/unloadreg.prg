PROCEDURE UnLoadReg
 IF MESSAGEBOX('¬€ ’Œ“»“≈ ¬€√–”«»“‹ –≈√»—“–?',4+32,'')=7
  RETURN 
 ENDIF 
 IF !fso.FileExists(pBase+'\kms.dbf')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pBase+'\adr77.dbf')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pBase+'\adr50.dbf')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pCommon+'\outs.dbf')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pCommon+'\street.dbf')
  RETURN 
 ENDIF 
 
 IF OpenFile(pBase+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms 
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pCommon+'\outs', 'outs', 'shar', 'enp')>0
  USE IN kms 
  IF USED('outs')
   USE IN outs
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pCommon+'\street', 'street', 'shar', 'ul')>0
  USE IN kms 
  USE IN outs 
  IF USED('street')
   USE IN street
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pBase+'\adr77', 'adr77', 'shar', 'recid')>0
  USE IN street 
  USE IN kms 
  USE IN outs 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pBase+'\adr50', 'adr50', 'shar', 'recid')>0
  USE IN street 
  USE IN kms 
  USE IN outs 
  USE IN adr77
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pCommon+'\okato', 'okato', 'shar', 'code')>0
  USE IN adr50
  USE IN street 
  USE IN kms 
  USE IN outs 
  USE IN adr77
  IF USED('okato')
   USE IN okato
  ENDIF 
  RETURN 
 ENDIF 
 
 CREATE CURSOR curreg (enp c(16), q c(2), fam c(25),im c(20),ot c(20),w n(1),dr d,mr c(100),gr c(3),;
  c_doc n(2),s_doc c(9),n_doc c(8),d_doc d, pllive c(150), plreg c(150), d_reg d, snils c(14), date_in d)
 INDEX on enp TAG enp 
 SET ORDER TO enp 
 
 SELECT kms 
 SET RELATION TO enp INTO outs 
 SET RELATION TO adr_id INTO adr77 ADDITIVE 
 SET RELATION TO adr50_id INTO adr50 ADDITIVE 
 WAIT "Œ¡–¿¡Œ“ ¿..." WINDOW NOWAIT 
 SCAN 
  IF EMPTY(outs.enp)
   LOOP 
  ENDIF 
  m.enp = enp 
  IF SEEK(m.enp, 'curreg')
   LOOP 
  ENDIF 

  SCATTER MEMO MEMVAR 
 
  m.q       = m.qcod
  m.mr      = ALLTRIM(m.mr)
  m.snils   = m.ss
  m.date_in = outs.date_in
  
  m.ul  = adr77.ul
  m.ulname = IIF(SEEK(m.ul, 'street'), ALLTRIM(street.street), '')
  m.dom = adr77.d
  m.kor = adr77.kor
  m.str = adr77.str
  m.kv  = adr77.kv

  m.plreg = m.ulname+iif(!Empty(m.dom), ', ‰.'+Allt(m.dom),'') +;
    iif(!Empty(m.Kor), ', ÍÓÔ.'+Allt(m.Kor),'') + iif(!Empty(m.Str), ', ÒÚ.'+Allt(m.Str),'') + ;
    iif(!Empty(m.Kv), ', Í‚.'+Allt(m.Kv),'')
  m.d_reg = dat_reg
  
  m.okato = adr50.c_okato
  m.c_t = IIF(!EMPTY(m.okato) and SEEK(m.okato, 'okato'), ALLTRIM(okato.name), '')
  m.ra_name = ALLTRIM(adr50.ra_name)
  m.np_name = ALLTRIM(adr50.np_name)
  m.ul_name = ALLTRIM(adr50.ul_name)
  m.dom2 = ALLTRIM(adr50.dom)
  m.kor2 = ALLTRIM(adr50.kor)
  m.str2 = ALLTRIM(adr50.str)
  m.kv2  = ALLTRIM(adr50.kv)
  
  m.pllive = ALLTRIM(m.c_t+','+m.ra_name+','+m.np_name+','+m.ul_name+','+m.dom2+','+m.kor2+','+m.str2+','+m.kv2)
  m.pllive = IIF(!EMPTY(STRTRAN(m.pllive,',','')), m.pllive, m.plreg)

  INSERT INTO curreg FROM MEMVAR 

 ENDSCAN 
 SET RELATION OFF INTO outs 
 SET RELATION OFF INTO adr77
 SET RELATION OFF INTO adr50
 WAIT CLEAR 
 
 USE IN kms 
 USE IN outs 
 USE IN street 
 USE IN adr50
 USE IN adr77
 USE IN okato 
 
 SELECT curreg
 SET ORDER TO 
 COPY TO &pOut\allreg
 
 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!',0+64,'')
 
RETURN 