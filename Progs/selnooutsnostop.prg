PROCEDURE selNoOutSNoStop

 WAIT "���������� ������, ������������� � � ��������� � � ����-�����..." WINDOW NOWAIT 

 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON recid tag recid OF &Plocal\flt
 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON nz TAG nz OF &Plocal\flt
 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON dp TAG dp OF &Plocal\flt
 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON dt TAG dt OF &Plocal\flt
 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON INT(VAL(SUBSTR(sn_card, AT(' ',sn_card)+1))) TAG n_card OF &Plocal\flt
 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON UPPER(fam + SUBSTR(im,1,1) + SUBSTR(ot,1,1)) TAG  fio OF &Plocal\flt
 INDEX FOR !SEEK(ALLTRIM(sn_card), 'Stop') AND !SEEK(ALLTRIM(sn_card), 'OutS') ;
 	ON mcod TAG mcod OF &Plocal\flt

 IF _tally > 0
  v_kms.IsFilt = .t.
  v_kms.AllFilt = _tally
  COUNT FOR w == 1 TO v_kms.MenFilt
  COUNT FOR w == 2 TO v_kms.WomFilt
  GO TOP 
  SET INDEX TO &PLocal\flt.cdx ADDITIVE 
  WAIT '��������!' WINDOW NOWAIT 

 ELSE 
  v_kms.IsFilt = .f.
  v_kms.AllFilt = 0
  v_kms.MenFilt = 0
  v_kms.WomFilt = 0
  SET INDEX TO 
  GO (oldRec)
  DELETE FILE &PLOcal\Flt.cdx
  WAIT '������ �� ��������!' WINDOW NOWAIT 
 ENDIF 

 WAIT CLEAR 

RETURN 	
