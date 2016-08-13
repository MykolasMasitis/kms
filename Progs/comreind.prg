PROCEDURE ComReind

pnResult=0
pnResult = OpenFile('&PBin\Smo', 'Smo', 'Excl')
IF pnResult==0
 SELECT smo
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\Jt', 'Jt', 'Excl')
IF pnResult==0
 SELECT jt
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON jt TAG jt
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\Scenario', 'Scn', 'Excl')
IF pnResult==0
 SELECT Scn
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON scn TAG scn
 INDEX ON jt TAG jt
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\Kl', 'Kl', 'Excl')
IF pnResult==0
 SELECT Kl
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON Kl TAG Kl
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\LpuAll', 'LpuAll', 'Excl')
IF pnResult==0
 SELECT LpuAll
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON lpu_id TAG lpu_id
 INDEX ON Mcod TAG Mcod
 INDEX ON s_name TAG s_name 
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\Smo', 'Smo', 'Excl')
IF pnResult==0
 SELECT Smo
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON smo TAG q
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\Street', 'Street', 'Excl')
IF pnResult==0
 SELECT Street
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON ul TAG ul
 INDEX ON UPPER(street) TAG name
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\OsoErz', 'OsoErz', 'Excl')
IF pnResult==0
 SELECT OsoErz
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON ans_r TAG ans_r
 USE 
ENDIF 

pnResult=0
pnResult = OpenFile('&PCommon\Country', 'Country', 'Excl')
IF pnResult==0
 SELECT Country
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 REPLACE ALL cod WITH PADL(INT(VAL(ALLTRIM(cod))),3,'0')
 INDEX ON cod TAG cod  
 INDEX ON code TAG code
 INDEX ON UPPER(name) TAG name
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\Okato', 'Okato', 'Excl')
IF pnResult==0
 SELECT Okato
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 INDEX on name TAG name COLLATE "russian"
 INDEX on cod_ter TAG cod_ter
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\CityType', 'CityType', 'Excl')
IF pnResult==0
 SELECT CityType
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 INDEX ON name TAG name
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\ktg', 'ktg', 'Excl')
IF pnResult==0
 SELECT ktg
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 INDEX ON name TAG name
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\StreetType', 'StreetType', 'Excl')
IF pnResult==0
 SELECT StreetType
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\CodFio', 'CodFio', 'Excl')
IF pnResult==0
 SELECT CodFio
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON CodFio TAG CodFio
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\Status', 'Status', 'Excl')
IF pnResult==0
 SELECT Status
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\VidDoc', 'VidDoc', 'Excl')
IF pnResult==0
 SELECT VidDoc
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\rereg', 'rereg', 'Excl')
IF pnResult==0
 SELECT rereg
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\spr_im', 'spr_im', 'Excl')
IF pnResult==0
 SELECT spr_im
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON recid TAG recid CANDIDATE 
 INDEX ON UPPER(name) TAG name 
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\spr_ot', 'spr_ot', 'Excl')
IF pnResult==0
 SELECT spr_ot
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON recid TAG recid CANDIDATE 
 INDEX ON UPPER(name) TAG name 
 INDEX FOR w=1 ON UPPER(name) TAG namem
 INDEX FOR w=2 ON UPPER(name) TAG namew
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\p_doc', 'p_doc', 'Excl')
IF pnResult==0
 SELECT p_doc
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\true_dr', 'true_dr', 'Excl')
IF pnResult==0
 SELECT true_dr
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\tersmo', 'tersmo', 'Excl')
IF pnResult==0
 SELECT tersmo
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON ALLTRIM(q_ogrn) TAG q_ogrn
 INDEX ON tf_okato TAG tf_okato
 INDEX ON tf_okato+q_ogrn TAG un_key
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\pricin', 'pricin', 'Excl')
IF pnResult==0
 SELECT pricin
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\tranz', 'tranz', 'Excl')
IF pnResult==0
 SELECT tranz
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\d_type4', 'd_type4', 'Excl')
IF pnResult==0
 SELECT d_type4
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\sv5', 'sv5', 'Excl')
IF pnResult==0
 SELECT sv5
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON pv TAG pv
 INDEX on tiperz TAG tiperz
 INDEX ON messageid TAG messageid
 INDEX ON sent TAG sent 
 INDEX ON accepted TAG accepted
 INDEX ON answered TAG answered
 INDEX ON tip TAG tip
 INDEX ON sterz TAG sterz
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\sv5ppl', 'sv5ppl', 'Excl')
IF pnResult==0
 SELECT sv5ppl
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 IF !EMPTY(CDX(1))
  DELETE TAG ALL 
 ENDIF 
* INDEX ON RecId_pv TAG recid_pv CANDIDATE 
 INDEX on tiperz TAG tiperz
 INDEX ON pv+PADL(recid_pv,6,'0') TAG unval
 INDEX ON pv TAG pv
 INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30))+DTOC(dr) TAG  fio COLLATE "Russian"
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\kadr', 'kadr', 'Excl')
IF pnResult==0
 SELECT kadr
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON cod TAG cod CANDIDATE 
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\docflag', 'docflag', 'Excl')
IF pnResult==0
 SELECT docflag
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\gzkflag', 'gzkflag', 'Excl')
IF pnResult==0
 SELECT gzkflag
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

pnResult = 0
pnResult = OpenFile('&PCommon\uekflag', 'uekflag', 'Excl')
IF pnResult==0
 SELECT uekflag
 WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
 INDEX ON code TAG code
 USE 
ENDIF 

IF fso.FileExists(pbin+'\mfc_pv.dbf')
 IF OpenFile(pbin+'\mfc_pv', 'mfcpv', 'excl')>0
  IF USED('mfcpv')
   USE IN mfcpv
  ENDIF 
 ELSE 
  SELECT mfcpv
  DELETE TAG ALL 
  INDEX on pv TAG pv 
  USE IN mfcpv
 ENDIF 
ENDIF 

 IF OpenFile("&pcommon\plants", "plants", "EXCLUSIVE")>0
  IF USED('plants')
   USE IN plants
  ENDIF 
 ELSE 
  WAIT "»Õƒ≈ —»–Œ¬¿Õ»≈ ‘¿…À¿ " + ALLTRIM(DBF())+' ...' WINDOW NOWAIT
  SELECT plants
  DELETE TAG ALL 
  INDEX ON recid TAG recid
  INDEX ON code TAG code
  USE 
  WAIT CLEAR 
 ENDIF 

WAIT CLEAR 

