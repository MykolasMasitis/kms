PROCEDURE GrDel
	IF MESSAGEBOX('��� ��������� ���������� �������� ���������� �������!'+CHR(13)+;
		'��� ��, ��� �� ������������� ������?',4+32,'����������� ���� ��������!') = 7
		RETURN 
	ENDIF 
	IF v_kms.IsFilt != .t.
		MESSAGEBOX('������ �� ��������,'+CHR(13)+'������ �������!',0+48,'��������!')
		RETURN 
	ENDIF 
	IF v_kms.AllFilt==0
		MESSAGEBOX('�������� 0 (����) �������,'+CHR(13)+'������ �������!',0+48,'��������!')
		RETURN 
	ENDIF 
	IF MESSAGEBOX('������ ����� ������� '+ALLTRIM(STR(v_kms.AllFilt))+' �������!'+CHR(13)+;
		'��� ��, ��� �� ������������� ������?',4+32,'����������� ���� ��������!') = 7
		RETURN 
	ENDIF 
	IF MESSAGEBOX('������ ����� ������� '+ALLTRIM(STR(v_kms.AllFilt))+' �������!'+CHR(13)+;
		'�� ��������� ������� � ����� ���������?',4+32,'����������� ���� ��������!') = 7
		RETURN 
	ENDIF 
	
	DELETE ALL
	
	RETURN 
	
	
RETURN 