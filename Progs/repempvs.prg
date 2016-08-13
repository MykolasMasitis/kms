PROCEDURE RepEmpVS
 IF MESSAGEBOX('бш унрхре ятнплхпнбюрэ нрвер'+CHR(13)+CHR(10)+;
  'он "онрепъммшл" бпелеммшл яхдерекэярбюл?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pBase+'\'+pvid(1,1)+'\kms.dbf')
  RETURN 
 ENDIF 
 IF OpenFile(pBase+'\'+pvid(1,1)+'\kms', 'kms', 'shar', 'vs')>0
  IF USED('kms')
   USE IN kms
  ENDIF
  RETURN 
 ENDIF 
 
 CREATE CURSOR curvs (vs n(9))
 INDEX on vs TAG vs 
 SET ORDER TO vs 

 SELECT INT(VAL(vs)) as vs  FROM kms unique WHERE !EMPTY(vs) ORDER BY vs INTO CURSOR curvs
 INDEX on vs TAG vs 
 SET ORDER TO vs
 
 SELECT curvs 
 
 m.minvs = 0
 m.maxvs = 0
 CALCULATE MIN(vs) TO m.minvs 
 CALCULATE MAX(vs) TO m.maxvs 
 
 USE IN kms

 m.ischecked = .f.
 DO FORM selints
 IF m.ischecked = .f.
  USE IN curvs
  RETURN 
 ENDIF 

 IF m.minvs=0
  USE IN curvs
  MESSAGEBOX('ньхайю! лхмхлюкэмши мнлеп бя=0!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF m.maxvs=0
  USE IN curvs
  MESSAGEBOX('ньхайю! люйяхлюкэмши мнлеп бя=0!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF m.minvs>m.maxvs
  USE IN curvs
  MESSAGEBOX('ньхайю! люйяхлюкэмши мнлеп бя лемэье лхмхлюкэмнцн!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 MESSAGEBOX('лхмхлюкэмши бC '+PADL(INT(m.minvs),9,'0')+CHR(13)+CHR(10)+;
  'люйяхлюкэмши бC '+PADL(INT(m.maxvs),9,'0')+CHR(13)+CHR(10),0+64,'')
* USE IN curvs
* RETURN   
 
 CREATE CURSOR empvs (vs n(9))
 INDEX on vs TAG vs
 SET ORDER TO vs
 
 OldEscStatus = SET("Escape")
 SET ESCAPE OFF 
 CLEAR TYPEAHEAD 

 m.cvs = m.minvs
 DO WHILE m.cvs<=m.maxvs
  WAIT PADL(INT(m.cvs),9,'0')+'...' WINDOW NOWAIT 
  IF !SEEK(m.cvs, 'curvs')
   INSERT INTO empvs (vs) VALUES (m.cvs)
  ENDIF 
  m.cvs = m.cvs + 1
  IF CHRSAW(0) 
   IF INKEY() == 27
    IF MESSAGEBOX('бш унрхре опепбюрэ напюанрйс?',4+32,'') == 6
     EXIT 
    ENDIF 
   ENDIF 
  ENDIF 
 ENDDO 
 WAIT CLEAR 
 
 SET ESCAPE &OldEscStatus

 USE IN curvs
 
 SELECT empvs
 m.nfile = pvid(1,1)+'_'+PADL(INT(m.minvs),9,'0')+'_'+PADL(INT(m.maxvs),9,'0')
 COPY TO &pout\&nfile
 USE 
 
 MESSAGEBOX('напюанрйю гюйнмвемю!'+CHR(13)+CHR(10)+'пегскэрюрш напюанрйх яндепфюряъ б тюике'+CHR(13)+CHR(10)+;
  m.nfile+CHR(13)+CHR(10),0+64,'')
 
 
 
RETURN 