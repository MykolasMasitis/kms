PROCEDURE selNoOuts

 WAIT "нрахпючряъ гюохях, нрясрябсчыхе б мнлепмхйе..." WINDOW NOWAIT 

 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON recid tag recid OF &Plocal\flt
 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON nz TAG nz OF &Plocal\flt
 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON dp TAG dp OF &Plocal\flt
 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON dt TAG dt OF &Plocal\flt
 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON mcod TAG mcod OF &Plocal\flt
 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON INT(VAL(SUBSTR(sn_card, AT(' ',sn_card)+1))) TAG n_card OF &Plocal\flt
 INDEX FOR !SEEK(INT(VAL(ALLTRIM(SUBSTR(sn_card,8,10)))), 'OutS') ON UPPER(fam + SUBSTR(im,1,1) + SUBSTR(ot,1,1)) TAG  fio OF &Plocal\flt

 IF _tally > 0
  v_kms.IsFilt = .t.
  v_kms.AllFilt = _tally
  COUNT FOR w == 1 TO v_kms.MenFilt
  COUNT FOR w == 2 TO v_kms.WomFilt
  GO TOP 
  SET INDEX TO &PLocal\flt.cdx ADDITIVE 
  WAIT 'нрнапюмн!' WINDOW NOWAIT 

 ELSE 
  v_kms.IsFilt = .f.
  v_kms.AllFilt = 0
  v_kms.MenFilt = 0
  v_kms.WomFilt = 0
  SET INDEX TO 
  GO (oldRec)
  DELETE FILE &PLOcal\Flt.cdx
  WAIT 'мхвецн ме нрнапюмн!' WINDOW NOWAIT 
 ENDIF 

 WAIT CLEAR 

RETURN 