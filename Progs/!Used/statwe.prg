PROCEDURE StatWE

 IF MESSAGEBOX('ÑÔÎÐÌÈÐÎÂÀÒÜ ÎÒ×ÅÒ ÏÎ ÏÎËÓ?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 IF OpenFile(PBase+'\kms', 'kms', 'shar')>0
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
  m.w = STR(w,1)
  ggg = ASCAN(dim_jt, m.w)
  IF ggg = 0
   sta_d = sta_d + 1
   DIMENSION dim_jt(sta_d, 2)
   dim_jt(sta_d, 1) = m.w
   dim_jt(sta_d, 2) = 1
  ELSE 
   dim_jt(ggg+1) = dim_jt(ggg+1) + 1
  ENDIF 
 ENDSCAN 
 =ASORT(dim_jt)

 IF sta_d>=1
  CREATE CURSOR StJt (w c(1), cnt n(10)) 
  FOR iii=1 TO sta_d
   m.w = dim_jt(iii,1)
   m.cnt = dim_jt(iii,2)
   INSERT INTO StJt (w, cnt) VALUES (m.w, m.cnt)
  ENDFOR 
 ENDIF 

 RELEASE dim_jt 
 SELECT StJt

 WAIT CLEAR 
 REPORT FORM RepStW PREVIEW  

 IF USED('kms')
  USE IN kms
 ENDIF 

RETURN 




