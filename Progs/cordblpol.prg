PROCEDURE CorDBLPol
WAIT "Œ¡–¿¡Œ“ ¿, œŒƒŒ∆ƒ»“≈..." WINDOW NOWAIT 
*OPEN DATABASE &PBase\&pvid(1,1)\kms SHARED 
*SET DATABASE TO kms
USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms SHARED ORDER sn_card
USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms_pol SHARED ORDER sn_card AGAIN 
USE &PBase\&pvid(1,1)\kms IN 0 alia kms_prim SHARED AGAIN 
SELECT kms_prim
INDEX ON LEFT(prim,17) TO &PLocal\prim
SET INDEX TO &PLocal\prim
SELECT kms

GO TOP 
DO WHILE !EOF()
 m.polis = ''
 vir = sn_card
 SKIP 
 DO WHILE sn_card == vir
  FOR iii=1 TO 999999
   m.polis = TransPol(qcod+pvid(1,1) + ' ' + ALLTRIM(STR(iii)))
   IF !SEEK(m.polis, 'kms_pol') AND !SEEK(m.polis, 'kms_prim')
    EXIT 
   ENDIF 
  ENDFOR 
  REPLACE prim WITH m.polis
  SKIP 
 ENDDO 
ENDDO 
REPLACE FOR !EMPTY(prim) sn_card WITH prim
REPLACE FOR !EMPTY(prim) prim WITH ''

SELECT kms_prim
SET INDEX TO 
DELETE FILE &PLocal\prim.idx
USE
CLOSE TABLES ALL 
WAIT CLEAR 
RETURN
