PROCEDURE AppMfcR3
 IF MESSAGEBOX('«¿√–”«»“‹ ‘¿…À€ ¬€ƒ¿◊» Ã‘÷?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('Œ“—”“—“¬≈“ ‘¿…À PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('Œ“—”“—“¬≈“ ‘¿…À MFC_PV.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 
 pMFC = fso.GetParentFolderName(pbin) + '\MFC'
 
 IF !fso.FolderExists(pMFC)
  fso.CreateFolder(pMFC)
  MESSAGEBOX(CHR(13)+CHR(10)+'Ã‘÷-‘¿…ÀŒ¬ Õ≈ Œ¡Õ¿–”∆≈ÕŒ!',0+64,'')
  RETURN 
 ENDIF 
 
 oal = SYS(5)+SYS(2003)
 SET DEFAULT TO (pMFC)
 EFile = GETFILE('dbf','','',0,'“ÍÌËÚÂ Ì‡ Ù‡ÈÎ!')
 SET DEFAULT TO (oal)
 
 IF EMPTY(EFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'¬€ Õ»◊≈√Œ Õ≈ ¬€¡–¿À»!'+CHR(13)+CHR(10),0+48,'')
  RETURN 
 ELSE 
  MESSAGEBOX('¬€ ¬€¡–¿À» '+m.efile+CHR(13)+CHR(10),0+48,'')
 ENDIF 
 
 IF OpenFile(m.EFile, 'efile', 'excl')>0
  IF USED('efile')
   USE IN efile
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT efile
 IF FIELD('enp')!='ENP'
  MESSAGEBOX('¬ ¬€¡–¿ÕÕŒÃ ‘¿…À≈ Õ≈“ œŒÀﬂ ENP!'+CHR(13)+CHR(10),0+48,'')
  USE 
  RETURN 
 ENDIF 
 IF FIELD('vsn')!='VSN'
  MESSAGEBOX('¬ ¬€¡–¿ÕÕŒÃ ‘¿…À≈ Õ≈“ œŒÀﬂ VSN!'+CHR(13)+CHR(10),0+48,'')
  USE 
  RETURN 
 ENDIF 
 IF FIELD('date_v')!='DATE_V'
  MESSAGEBOX('¬ ¬€¡–¿ÕÕŒÃ ‘¿…À≈ Õ≈“ œŒÀﬂ DATE_V!'+CHR(13)+CHR(10),0+48,'')
  USE 
  RETURN 
 ENDIF 

 IF FIELD('pv')='PV'
  IF MESSAGEBOX('‘¿…À Œ¡–¿¡¿“€¬¿À—ﬂ –¿Õ≈≈.'+CHR(13)+CHR(10)+'œŒ¬“Œ–»“‹ Œ¡–¿¡Œ“ ”?'+CHR(13)+CHR(10),4+32,'')=6 && Yes!
   REPLACE ALL pv WITH ''
  ELSE 
   USE 
   RETURN 
  ENDIF 
 ELSE 
  ALTER TABLE efile ADD COLUMN pv c(3)
 ENDIF 

 IF OpenFile(pbin+'\pvp2', 'pvp2', 'shar')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pbin+'\mfc_pv', 'mfcpv', 'shar', 'pv')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  IF USED('mfcpv')
   USE IN mfcpv
  ENDIF 
  RETURN 
 ENDIF 
 
 SELECT pvp2
 SET RELATION TO codpv INTO mfcpv
 
 SELECT efile
 SCAN 
  m.vs  = vsn
  m.enp = enp
  m.dp  = date_v
  
  m.pv  = ''
  
  WAIT m.vs WINDOW NOWAIT 
  
  SELECT pvp2
  SCAN 
   IF EMPTY(mfcpv.pv)
    LOOP 
   ENDIF 
   m.pvv = codpv
   IF !fso.FolderExists(pbase+'\'+m.pvv)
    LOOP 
   ENDIF 
   IF !fso.FileExists(pbase+'\'+m.pvv+'\kms.dbf')
    LOOP 
   ENDIF 
   IF OpenFile(pbase+'\'+m.pvv+'\kms', 'kms', 'shar', 'vs')>0
    IF USED('kms')
     USE IN kms
    ENDIF 
    SELECT pvp2
    LOOP
   ENDIF 
   
   IF SEEK(m.vs, 'kms')
    m.pv = m.pvv
    EXIT
   ENDIF 
   USE IN kms

  ENDSCAN 
  WAIT CLEAR 
  
  USE IN kms
  SELECT efile 
  REPLACE pv WITH m.pv
  
 ENDSCAN 

 USE IN efile
 IF USED('pvp2')
  USE IN pvp2
 ENDIF 
 IF USED('mfcpv')
  USE IN mfcpv
 ENDIF 

 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!',0+64,'')

RETURN 

