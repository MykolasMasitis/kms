PROCEDURE PrnChoice
 PUBLIC m.ddr
 DO CASE 
  CASE true_dr == 1
   m.ddr = DTOC(dr)
  CASE true_dr == 2
   m.ddr = '00.' + PADL(MONTH(dr),2,'0') + '.' + STR(YEAR(dr),4)
  CASE true_dr == 3
   m.ddr = '00.00.' + STR(YEAR(dr),4)
  OTHERWISE 
 ENDCASE 
 
 LABEL FORM PrnChoice preview reco RECNO()
 
 RELEASE ddr 
RETURN  
