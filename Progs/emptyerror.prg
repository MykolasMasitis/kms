PROCEDURE EmptyError
	FOR num_pv=1 TO kol_pv
		WAIT "Обнуление файла ошибок ПВ "+pvid(num_pv,1)+"..." WINDOW NOWAIT 
		USE &PBase\&pvid(num_pv,1)\Error IN 0 ALIAS error EXCLUSIVE 
		SELECT error
		ZAP
		oApp.CloseAllTable()
		WAIT CLEAR 
	ENDFOR 
RETURN
