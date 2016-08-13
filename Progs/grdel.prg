PROCEDURE GrDel
	IF MESSAGEBOX('Это процедура группового удаления отобранных записей!'+CHR(13)+;
		'Это то, что вы действительно хотите?',4+32,'Подтвердите свио действия!') = 7
		RETURN 
	ENDIF 
	IF v_kms.IsFilt != .t.
		MESSAGEBOX('Ничего не отобрано,'+CHR(13)+'нечего удалять!',0+48,'Внимание!')
		RETURN 
	ENDIF 
	IF v_kms.AllFilt==0
		MESSAGEBOX('Отобрано 0 (ноль) записей,'+CHR(13)+'нечего удалять!',0+48,'Внимание!')
		RETURN 
	ENDIF 
	IF MESSAGEBOX('Сейчас будет удалено '+ALLTRIM(STR(v_kms.AllFilt))+' записей!'+CHR(13)+;
		'Это то, что вы действительно хотите?',4+32,'Подтвердите свои действия!') = 7
		RETURN 
	ENDIF 
	IF MESSAGEBOX('Сейчас будет удалено '+ALLTRIM(STR(v_kms.AllFilt))+' записей!'+CHR(13)+;
		'Вы абсолютно уверены в своих действиях?',4+32,'Подтвердите свои действия!') = 7
		RETURN 
	ENDIF 
	
	DELETE ALL
	
	RETURN 
	
	
RETURN 