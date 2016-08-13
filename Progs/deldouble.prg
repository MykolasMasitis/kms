PROCEDURE DelDouble

FOR num_pv=1 TO kol_pv

WAIT "Перевод дублей в архив ПВ " + pvid(num_pv,1) + "..." WINDOW NOWAIT 

USE &PBase\&pvid(num_pv,1)\kms IN 0 SHARED ALIAS kms1
USE &PBase\&pvid(num_pv,1)\kms IN 0 SHARED ALIAS kms2 ORDER sn_card AGAIN 
USE &PBase\&pvid(num_pv,1)\arckms IN 0 SHARED ALIAS ArcKms 

SELECT kms1
SCAN 
	m.sn_card = sn_card
	IF IsKms(m.sn_card)
		IF SEEK(m.sn_card, 'kms2')
			SELECT kms2
			SCATTER MEMVAR memo 
			INSERT INTO arckms FROM MEMVAR 
			DELETE
			SELECT kms1
		ENDIF 
	ENDIF 
ENDSCAN 

oApp.CloseAllTable()
WAIT CLEAR 

ENDFOR 

RETURN
