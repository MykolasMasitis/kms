PROCEDURE StatJTPeriodE

 IF MESSAGEBOX('—‘Œ–Ã»–Œ¬¿“‹ Œ“◊≈“ œŒ JT?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 IF OpenFile(PBase+'\kms', 'kms', 'shar')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pCommon+'\Jt', "Jt", "share", "Jt")>0
  IF USED('jt')
   USE IN jt
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  RETURN 
 ENDIF 

 m.t_dat1 = m.gdCurDat1 
 m.t_dat2 = m.gdCurdat2

 DO FORM TuneDat

 SELECT kms
 WAIT "œÓ‰ÓÊ‰ËÚÂ..." WINDOW NOWAIT 

 DIMENSION dim_jt(1,2)
 sta_d = 0

 SCAN FOR BETWEEN(dp,m.t_dat1,m.t_dat2)
  m.jt = jt
  ggg = ASCAN(dim_jt, m.jt)
  IF ggg = 0
   sta_d = sta_d + 1
   DIMENSION dim_jt(sta_d, 2)
   dim_jt(sta_d, 1) = m.jt
   dim_jt(sta_d, 2) = 1
  ELSE 
   dim_jt(ggg+1) = dim_jt(ggg+1) + 1
  ENDIF 
 ENDSCAN 
 =ASORT(dim_jt)

 IF sta_d>=1
  CREATE CURSOR StJt (jt c(1), cnt n(10)) 
  FOR iii=1 TO sta_d
   m.jt = dim_jt(iii,1)
   m.cnt = dim_jt(iii,2)
   INSERT INTO StJt (jt, cnt) VALUES (m.jt, m.cnt)
  ENDFOR 
 ELSE 
  IF USED('jt')
   USE IN jt
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  WAIT CLEAR 
  MESSAGEBOX(CHR(13)+CHR(10)+'«¿ ¬€¡–¿ÕÕ€… œ≈–»Œƒ ƒ¿ÕÕ€’ Õ≈“!'+CHR(13)+CHR(10),0+64,'')
  RETURN 
 ENDIF 

 RELEASE dim_jt 
 SELECT StJt

 WAIT CLEAR 
 REPORT FORM RepStJt PREVIEW  

 IF USED('jt')
  USE IN jt
 ENDIF 
 IF USED('kms')
  USE IN kms
 ENDIF 

RETURN 



