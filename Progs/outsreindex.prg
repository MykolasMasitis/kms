PROCEDURE OutsReindex
	WAIT "оепехмдейяюжхъ мнлепмхйю, фдхре..." WINDOW NOWAIT 
	USE &PCommon\OutS IN 0 ALIAS OutS EXCLUSIVE
	SELECT OutS
	WAIT "янгдюмхе рецю sn_card..." WINDOW NOWAIT 
	INDEX ON s_card+' '+PADL(n_card,10,'0') TAG sn_card
	WAIT "янгдюмхе рецю n_card..." WINDOW NOWAIT 
	INDEX ON n_card TAG n_card
	WAIT "янгдюмхе рецю enp..." WINDOW NOWAIT 
	INDEX ON enp TAG enp
	WAIT CLEAR 
	USE
	WAIT CLEAR 
RETURN
