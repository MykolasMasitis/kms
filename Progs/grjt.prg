PROCEDURE GrJt
	IF MESSAGEBOX('Это процедура групповой замены признака jt на "r" отобранных записей!'+CHR(13)+;
		'Это то, что вы действительно хотите?',4+32,'') = 7
		RETURN 
	ENDIF 
	IF v_kms.IsFilt != .t.
		MESSAGEBOX('Ничего не отобрано,'+CHR(13)+'нечего менять!',0+48,'')
		RETURN 
	ENDIF 
	IF v_kms.AllFilt==0
		MESSAGEBOX('Отобрано 0 (ноль) записей,'+CHR(13)+'нечего менять!',0+48,'')
		RETURN 
	ENDIF 
	IF MESSAGEBOX('Сейчас будет модифицировано '+ALLTRIM(STR(v_kms.AllFilt))+' записей!'+CHR(13)+;
		'Это то, что вы действительно хотите?',4+32,'') = 7
		RETURN 
	ENDIF 
	IF MESSAGEBOX('Сейчас будет модифицировано '+ALLTRIM(STR(v_kms.AllFilt))+' записей!'+CHR(13)+;
		'Вы абсолютно уверены в своих действиях?',4+32,'') = 7
		RETURN 
	ENDIF 
	
	REPLACE ALL jt WITH 'r', dp WITH DATE()
	
	MESSAGEBOX('Заменен признак движения у '+ALLTRIM(STR(_tally))+' записей!',0+48,'')

RETURN 