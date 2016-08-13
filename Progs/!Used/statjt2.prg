PROCEDURE StatJT2

m.oldalias = IIF(!EMPTY(ALIAS()), ALIAS(), "")

IF !USED('kms')
 pnResult = OpenFile("&pBase\&pvid(1,1)\kms", "kms", "share")
 IF pnResult > 0
  RETURN .f.
 ENDIF
 m.WasUsedKms = .F.
ELSE 
 m.WasUsedKms = .T.
 m.oldrec = RECNO('kms')
ENDIF 

IF !USED('Jt')
 pnResult = OpenFile("&pCommon\Jt", "Jt", "share", "Jt")
 IF pnResult > 0
  RETURN .f.
 ENDIF
 m.WasUsedJt = .F.
ELSE 
 m.WasUsedJt = .T.
ENDIF 

SELECT kms
WAIT "Подождите..." WINDOW NOWAIT 

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

IF m.WasUsedKms = .f.
 USE IN kms
ELSE 
 GO m.oldrec IN kms
ENDIF 

IF m.WasUsedJt = .f.
 USE IN Jt
ENDIF 

IF !EMPTY(m.oldalias)
 SELECT (m.oldalias)
ENDIF 

RETURN 




