PROCEDURE OutsReindex
	WAIT "�������������� ���������, �����..." WINDOW NOWAIT 
	USE &PCommon\OutS IN 0 ALIAS OutS EXCLUSIVE
	SELECT OutS
	WAIT "�������� ���� sn_card..." WINDOW NOWAIT 
	INDEX ON s_card+' '+PADL(n_card,10,'0') TAG sn_card
	WAIT "�������� ���� n_card..." WINDOW NOWAIT 
	INDEX ON n_card TAG n_card
	WAIT "�������� ���� enp..." WINDOW NOWAIT 
	INDEX ON enp TAG enp
	WAIT CLEAR 
	USE
	WAIT CLEAR 
RETURN
