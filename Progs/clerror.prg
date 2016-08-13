PROCEDURE CLError
 IF MESSAGEBOX('бш унрхре намскхрэ онке "Err"', 4+32,;
  'оНДРБЕПДХРЕ ЯБНХ ДЕИЯРБХЪ!') == 7
	RETURN 
 ENDIF 
 
 WAIT "янамскемхе онкъ, фдхре..." WINDOW NOWAIT 
 lnOREC = RECNO()
 REPLACE ALL err WITH ""
 GO (lnOREC)
 WAIT CLEAR 

RETURN 