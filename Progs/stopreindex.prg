PROCEDURE StopReindex
	WAIT "оепехмдейяюжхъ ярно-кхярю, фдхре..." WINDOW NOWAIT 
	USE &PCommon\StopList IN 0 ALIAS sTOP EXCLUSIVE
	SELECT sTOP
	INDEX ON s_card+' '+PADL(n_card,10,'0') TAG sn_card
	INDEX ON s_cardz+' '+PADL(n_cardz,10,'0') TAG sn_cardz
	USE
	WAIT CLEAR 
RETURN
