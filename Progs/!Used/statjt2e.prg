PROCEDURE StatJT2E
 
 IF MESSAGEBOX('ÑÔÎÐÌÈÐÎÂÀÒÜ ÑÒÀÒÈÑÒÈÊÓ ÏÎ JT?'+CHR(13)+CHR(10),4+32,'')=7
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

 SELECT kms
 WAIT "Ïîäîæäèòå..." WINDOW NOWAIT 

 DIMENSION dim_jt(1,2)
 sta_d = 0

 SCAN 
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




