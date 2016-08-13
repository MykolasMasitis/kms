PROCEDURE PutIntoArc

FOR num_pv=1 TO kol_pv

WAIT "Перевод погашенных полисов в архив ПВ " + pvid(num_pv,1) + "..." WINDOW NOWAIT 

USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms SHARED 
USE &PBase\&pvid(1,1)\arckms IN 0 ALIAS arckms SHARED 
USE &PCommon\StopList IN 0 ALIAS Stop SHARED ORDER sn_card

SELECT kms
SET RELATION TO sn_card INTO Stop

SCAN FOR !EMPTY(stop.s_card)
	SCATTER MEMVAR 
	INSERT INTO arckms FROM MEMVAR 
	DELETE 
ENDSCAN 
SET RELATION OFF INTO Stop

oApp.CloseAllTable()
WAIT CLEAR 

ENDFOR 

RETURN
