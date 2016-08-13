PROCEDURE RecallKms
	FOR num_pv=1 TO kol_pv
		WAIT "Снятие пометок к удалению ПВ "+pvid(num_pv,1)+"..." WINDOW NOWAIT 
		USE &pBase\&pvid(num_pv,1)\kms IN 0 ALIAS kms EXCLUSIVE 
		SELECT kms
		RECALL ALL 
		oApp.CloseAllTable
		WAIT CLEAR 
	ENDFOR 
RETURN

