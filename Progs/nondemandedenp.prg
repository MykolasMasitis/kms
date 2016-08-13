PROCEDURE NonDemandedEnp
 IF MESSAGEBOX('’Œ“»“≈ —‘Œ–Ã»–Œ¬¿“‹ ∆”–Õ¿À'+CHR(13)+CHR(10)+;
  'Õ≈¬Œ—“–≈¡Œ¬¿ÕÕ€’ œŒÀ»—Œ¬?',4+32,'')=7
  RETURN 
 ENDIF 
 
 m.lcTmpName = ptempl+'\NonDemandedEnp.xls'
 IF !fso.FileExists(m.lcTmpName)
  MESSAGEBOX('Œ“—”“—“¬”≈“ ÿ¿¡ÀŒÕ Œ“◊≈“¿ NONDEMANDEDENP.XLS',0+16,'')
 ENDIF 
 
 IF INLIST(SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1),'KMS.EXE','KMSPV.EXE')
  m.kol_pv = 1
 ENDIF 
 
 CREATE CURSOR curkms (nrec n(6), "pv" c(3), nz c(5), vs c(9), vs_data d, enp c(16), gz_data d, ;
  fio c(50), dr d, "cont" c(40), wrkpl c(100))
 INDEX on pv TAG pv 
 SET ORDER TO pv
 
 WAIT "Œ“¡Œ– ƒ¿ÕÕ€’..." WINDOW NOWAIT 
 
 FOR m.num_pv=1 TO m.kol_pv
  IF SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1)='KMS.EXE'
   m.lppath = pBase
  ELSE 
   m.lppath = pBase+'\'+pvid(m.num_pv,1)
  ENDIF 
  IF !fso.FolderExists(m.lppath)
   LOOP 
  ENDIF 
  IF !fso.FileExists(m.lppath+'\kms.dbf')
   LOOP 
  ENDIF 
  IF !fso.FileExists(m.lppath+'\wrkpl.dbf')
   LOOP 
  ENDIF 
  IF OpenFile(m.lppath+'\kms', 'kms', 'shar')>0
   IF USED('kms')
    USE IN kms 
   ENDIF 
   LOOP 
  ENDIF 
  IF OpenFile(m.lppath+'\wrkpl', 'wrkpl', 'shar', 'recid')>0
   USE IN kms 
   IF USED('wrkpl')
    USE IN wrkpl
   ENDIF 
   LOOP 
  ENDIF 

  SELECT kms 
  SET RELATION TO wrkid INTO wrkpl
  SCAN 
   SCATTER MEMVAR 
   IF m.qcod!='S6'
    IF !(!EMPTY(m.enp) AND TYPE(m.enp)='N' AND m.scn!='POK' AND m.status=5)
     LOOP 
    ENDIF 
   ELSE 
    IF !(!EMPTY(m.enp) AND TYPE(m.enp)='N' AND m.status=5)
     LOOP 
    ENDIF 
   ENDIF 

   m.fio   = ALLTRIM(m.fam)+' '+LEFT(m.im,1)+'.'+LEFT(m.ot,1)+'.'
   m.wrkpl = ALLTRIM(wrkpl.name)
   
   INSERT INTO curkms FROM MEMVAR 
   
  ENDSCAN 
  SET RELATION OFF INTO wrkpl
  USE IN wrkpl
  USE IN kms 

 ENDFOR 
 
 
 SELECT curkms
 REPLACE ALL nrec WITH RECNO()
 
 WAIT CLEAR 
 WAIT "‘Œ–Ã»–Œ¬¿Õ»≈ Œ“◊≈“¿..." WINDOW NOWAIT 

 m.lcRepName = pOut+'\NonDemandedEnp.xls'
 m.IsVisible = .F.
 
 m.llResult = X_Report(m.lcTmpName, m.lcRepName, m.IsVisible)
 USE IN curkms
 
 WAIT CLEAR 
 
 PUBLIC oExcel AS Excel.Application

 WAIT "«‡ÔÛÒÍ MS Excel..." WINDOW NOWAIT 
 TRY 
  oExcel=GETOBJECT(,"Excel.Application")
 CATCH 
  oExcel=CREATEOBJECT("Excel.Application")
 ENDTRY 
 WAIT CLEAR 
 
 oExcel.Workbooks.Open(m.lcRepName)
 
 oExcel.Visible= .T. 


RETURN 