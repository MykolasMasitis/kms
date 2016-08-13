PROCEDURE App26
 IF MESSAGEBOX('«¿√–”«»“‹ ƒ¿ÕÕ€≈ »« ¬Õ≈ÿÕ≈√Œ ‘¿…À¿?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 pUpdDir = fso.GetParentFolderName(pbin)+'\UPDATE'
 IF !fso.FolderExists(pUpdDir)
  fso.CreateFolder(pUpdDir)
 ENDIF 
 
 SET DEFAULT TO (pUpdDir)
 DbfFile = ''
 DbfFile = GETFILE('dbf')
 IF EMPTY(DbfFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'¬€ Õ»◊≈√Œ Õ≈ ¬€¡–¿À»!'+CHR(13)+CHR(10),0+16,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 
 
 IF !fso.FolderExists(pbase+'\106')
  MESSAGEBOX('Œ“—”“—“¬”≈“ ƒ»–≈ “Œ–»ﬂ 106!'+CHR(13)+CHR(10),0+16,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 

 SET DEFAULT TO &pbin
 
 IF OpenFile(DbfFile, 'file26', 'shar')>0
  IF USED('file26')
   USE IN file26
  ENDIF 
  RETURN 
 ENDIF 
 
 IF OpenFile(pbase+'\106\kms', 'kms', 'shar', 'enp')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('file26')
   USE IN file26
  ENDIF 
  RETURN 
 ENDIF 
 
 WAIT "Œ¡–¿¡Œ“ ¿..." WINDOW NOWAIT  
 SELECT file26
 SCAN 
  m.enp     = enp
  m.sn_card = s_card + ' ' + PADL(n_card,10,'0')
  
  IF EMPTY(m.enp)
   LOOP 
  ENDIF 

  m.dp    = date_b
  m.dt    = date_e
  m.q     = q
  m.fam   = fam
  m.im    = im
  m.ot    = ot
  m.dr    = dr
  m.w     = IIF(pol='Ã', 1, 2)
  m.ss    = snils
  m.c_doc = INT(VAL(doc_type))
  m.s_doc = doc_ser
  m.n_doc = doc_num
  m.d_doc = doc_date
  
  m.act = .t.
  
  IF !SEEK(m.enp, 'kms')
   INSERT INTO kms FROM MEMVAR 
  ENDIF 
  
 ENDSCAN 

 USE IN file26
 USE IN kms
 
 WAIT CLEAR 
 
 MESSAGEBOX('OK'+CHR(13)+CHR(10),0+64,'') 
 
RETURN 