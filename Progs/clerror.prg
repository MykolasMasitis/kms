PROCEDURE CLError
 IF MESSAGEBOX('�� ������ �������� ���� "Err"', 4+32,;
  '����������� ���� ��������!') == 7
	RETURN 
 ENDIF 
 
 WAIT "���������� ����, �����..." WINDOW NOWAIT 
 lnOREC = RECNO()
 REPLACE ALL err WITH ""
 GO (lnOREC)
 WAIT CLEAR 

RETURN 