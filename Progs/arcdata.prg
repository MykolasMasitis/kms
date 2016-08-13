PROCEDURE ArcData

 IF MESSAGEBOX('¬€ ’Œ“»“≈ —Œ«ƒ¿“‹ ¿–’»¬ “≈ ”Ÿ≈… ¡¿«€?'+CHR(13)+CHR(10),7+32,'')=7
  RETURN 
 ENDIF 
 
 IF INLIST(SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1),'KMS.EXE','KMSPV.EXE')
  m.lppath = pBase
  m.kol_pv = 1
 ELSE 
  m.lppath = pBase+'\'+pvid(1,1)
 ENDIF 

 FOR num_pv = 1 TO m.kol_pv

  ZipFile = pvid(num_pv,1)+"_"+DTOS(DATE())+'.zip'
  IF fso.FileExists(pArc+'\'+ZipFile)
   fso.DeleteFile(pArc+'\'+ZipFile)
  ENDIF 

  WAIT "—Œ«ƒ¿Õ»≈ ¿–’»¬¿ œ”Õ “¿ "+pvid(num_pv,1)+"..." WINDOW NOWAIT  
  ZipOpen(pArc+'\'+ZipFile)
  IF fso.FileExists(lppath+'\adr50.dbf')
   ZipFile(lppath+'\adr50.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\adr50.cdx')
   ZipFile(lppath+'\adr50.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\adr77.dbf')
   ZipFile(lppath+'\adr77.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\adr77.cdx')
   ZipFile(lppath+'\adr77.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\answers.dbf')
   ZipFile(lppath+'\answers.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\answers.cdx')
   ZipFile(lppath+'\answers.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\arckms.dbf')
   ZipFile(lppath+'\arckms.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\arckms.cdx')
   ZipFile(lppath+'\arckms.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\e_ffoms.dbf')
   ZipFile(lppath+'\e_ffoms.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\e_ffoms.cdx')
   ZipFile(lppath+'\e_ffoms.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\enp2.dbf')
   ZipFile(lppath+'\enp2.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\enp2.cdx')
   ZipFile(lppath+'\enp2.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\error.dbf')
   ZipFile(lppath+'\error.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\error.cdx')
   ZipFile(lppath+'\error.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\kms.dbf')
   ZipFile(lppath+'\kms.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\kms.fpt')
   ZipFile(lppath+'\kms.fpt',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\kms.cdx')
   ZipFile(lppath+'\kms.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\moves.dbf')
   ZipFile(lppath+'\moves.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\moves.cdx')
   ZipFile(lppath+'\moves.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\odoc.dbf')
   ZipFile(lppath+'\odoc.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\odoc.cdx')
   ZipFile(lppath+'\odoc.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\ofio.dbf')
   ZipFile(lppath+'\ofio.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\ofio.cdx')
   ZipFile(lppath+'\ofio.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\osmo.dbf')
   ZipFile(lppath+'\osmo.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\osmo.cdx')
   ZipFile(lppath+'\osmo.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\pexp.dbf')
   ZipFile(lppath+'\pexp.dbf',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\predst.dbf')
   ZipFile(lppath+'\predst.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\predst.cdx')
   ZipFile(lppath+'\predst.cdx',.T.)
  ENDIF 

  IF fso.FileExists(lppath+'\user.dbf')
   ZipFile(lppath+'\user.dbf',.T.)
  ENDIF 
  IF fso.FileExists(lppath+'\user.cdx')
   ZipFile(lppath+'\user.cdx',.T.)
  ENDIF 

  ZipClose()
  WAIT CLEAR 

 ENDFOR 
 
 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!'+CHR(13)+CHR(10),0+64,'')

