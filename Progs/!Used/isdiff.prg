FUNCTION IsDiff
LPARAMETERS alias_1, alias_2, iskl1, iskl2, iskl3, iskl4, iskl5 && ѕередаем два алиаса, в которых открыты сравниваемые таблицы

iskl1 = IIF(!EMPTY(iskl1), UPPER(ALLTRIM(iskl1)), ' ')
iskl2 = IIF(!EMPTY(iskl2), UPPER(ALLTRIM(iskl2)), ' ')
iskl3 = IIF(!EMPTY(iskl3), UPPER(ALLTRIM(iskl3)), ' ')
iskl4 = IIF(!EMPTY(iskl4), UPPER(ALLTRIM(iskl4)), ' ')
iskl5 = IIF(!EMPTY(iskl5), UPPER(ALLTRIM(iskl5)), ' ')

t_result = 0 && 0 - нет результата, 1 - строки идентичны, 2 - строки различаютс€
 
IF SELECT('&alias_1')<=0 OR SELECT('&alias_1')<=0
 t_result = 0 
 RETURN t_result
ENDIF 
 
DIMENSION tabl_1(2,2), tabl_2(2,2)

fld_1 = AFIELDS(tabl_1, '&alias_1') && 1 столбец - название, 2 - тип,  3 - размерность, 4 - нулей после зап€той
fld_2 = AFIELDS(tabl_2, '&alias_2')

n_same_flds = 0
FOR n_fld = 1 TO fld_1
 fld_name  = tabl_1(n_fld,1)
 fld_type  = tabl_1(n_fld,2)
 fld_width = tabl_1(n_fld,3)
* n_element = ASCAN(tabl_2, fld_name,1,fld_1,1,6)
 n_element = ASCAN(tabl_2, fld_name,1,fld_2,1,6)
 IF !INLIST(UPPER(ALLTRIM(fld_name)), iskl1, iskl2, iskl3, iskl4, iskl5) AND fld_type!='M' && Ќе находитс€ ли поле в списке исключений?
  IF n_element > 0
   IF fld_type == tabl_2(n_element+1)
    IF fld_type == 'C'
     IF fld_width == tabl_2(n_element+2)
      n_same_flds = n_same_flds + 1
      tabl_1(n_fld,5) = .T.
     ELSE 
      tabl_1(n_fld,5) = .F.
     ENDIF 
    ELSE 
     n_same_flds = n_same_flds + 1
     tabl_1(n_fld,5) = .T.
    ENDIF 
   ELSE && ѕоле есть, но не такого типа
    tabl_1(n_fld,5) = .F.
   ENDIF 
  ELSE && Ќет такого пол€ во второй таблице
   tabl_1(n_fld,5) = .F.
  ENDIF 
 ELSE 
  tabl_1(n_fld,5) = .F.
 ENDIF 
ENDFOR 

t_result = 1
FOR n_fld = 1 TO fld_1
 IF tabl_1(n_fld,5) == .T. && ≈сли это совпадающее поле, совпадает ли значение пол€?
  fld_name  = tabl_1(n_fld,1)
  fldname1 = ALLTRIM(alias_1) + '.' + ALLTRIM(fld_name)
  fldname2 = ALLTRIM(alias_2) + '.' + ALLTRIM(fld_name)
  IF &fldname1 != &fldname2
   dim_flds(1, n_fld) = '1'
   t_result = 2
*   EXIT 
  ENDIF 
 ENDIF 
ENDFOR 

RETURN t_result
 
