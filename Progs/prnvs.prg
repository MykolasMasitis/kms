PROCEDURE prnvs
 PUBLIC m.ddr
 DO CASE 
  CASE true_dr == 1
   m.ddr = DTOC(dr)
  CASE true_dr == 2
   m.ddr = '00.' + PADL(MONTH(dr),2,'0') + '.' + STR(YEAR(dr),4)
   DO FORM chk_dr
  CASE true_dr == 3
   m.ddr = '00.00.' + STR(YEAR(dr),4)
   DO FORM chk_dr
  OTHERWISE 
  m.ddr = DTOC(dr)
 ENDCASE 
 
 m.dp = dp
 m.dvdata = GoNWrkDays(m.dp,30)
 m.vdata = PADL(DAY(m.dvdata),2,"0")+SPACE(5)+PADL(MONTH(m.dvdata),2,"0")+SPACE(10)+;
  SUBSTR(ALLTRIM(STR(YEAR(m.dvdata))),3,2)

 IF m.qcod=='R4'
  LABEL FORM prnVS_R4 PREVIEW RECORD RECNO()
 ELSE
  LABEL FORM prnVS PREVIEW RECORD RECNO()
 ENDIF 

 RELEASE ddr 
RETURN 