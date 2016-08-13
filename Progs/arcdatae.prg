PROCEDURE ArcDataE

 IF MESSAGEBOX('¬€ ’Œ“»“≈ —Œ«ƒ¿“‹ ¿–’»¬ “≈ ”Ÿ≈… ¡¿«€?'+CHR(13)+CHR(10),7+32,'')=7
  RETURN 
 ENDIF 
 
 ZipFile = DTOS(DATE())+'.zip'
 IF fso.FileExists(pArc+'\'+ZipFile)
  fso.DeleteFile(pArc+'\'+ZipFile)
 ENDIF 

 WAIT "—Œ«ƒ¿Õ»≈ ¿–’»¬¿ ¡ƒ œ”Õ “¿..." WINDOW NOWAIT  
 ZipOpen(pArc+'\'+ZipFile)
 IF fso.FileExists(pbase+'\adr50.dbf')
  ZipFile(pbase+'\adr50.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\adr50.cdx')
  ZipFile(pbase+'\adr50.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\adr77.dbf')
  ZipFile(pbase+'\adr77.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\adr77.cdx')
  ZipFile(pbase+'\adr77.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\answers.dbf')
  ZipFile(pbase+'\answers.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\answers.cdx')
  ZipFile(pbase+'\answers.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\arckms.dbf')
  ZipFile(pbase+'\arckms.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\arckms.cdx')
  ZipFile(pbase+'\arckms.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\e_ffoms.dbf')
  ZipFile(pbase+'\e_ffoms.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\e_ffoms.cdx')
  ZipFile(pbase+'\e_ffoms.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\enp2.dbf')
  ZipFile(pbase+'\enp2.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\enp2.cdx')
  ZipFile(pbase+'\enp2.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\error.dbf')
  ZipFile(pbase+'\error.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\error.cdx')
  ZipFile(pbase+'\error.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\kms.dbf')
  ZipFile(pbase+'\kms.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\kms.fpt')
  ZipFile(pbase+'\kms.fpt',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\kms.cdx')
  ZipFile(pbase+'\kms.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\moves.dbf')
  ZipFile(pbase+'\moves.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\moves.cdx')
  ZipFile(pbase+'\moves.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\odoc.dbf')
  ZipFile(pbase+'\odoc.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\odoc.cdx')
  ZipFile(pbase+'\odoc.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\ofio.dbf')
  ZipFile(pbase+'\ofio.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\ofio.cdx')
  ZipFile(pbase+'\ofio.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\permiss.dbf')
  ZipFile(pbase+'\permiss.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\permiss.cdx')
  ZipFile(pbase+'\permiss.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\predst.dbf')
  ZipFile(pbase+'\predst.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\predst.cdx')
  ZipFile(pbase+'\predst.cdx',.T.)
 ENDIF 

 IF fso.FileExists(pbase+'\user.dbf')
  ZipFile(pbase+'\user.dbf',.T.)
 ENDIF 
 IF fso.FileExists(pbase+'\user.cdx')
  ZipFile(pbase+'\user.cdx',.T.)
 ENDIF 

 ZipClose()
 WAIT CLEAR 

 MESSAGEBOX('Œ¡–¿¡Œ“ ¿ «¿ ŒÕ◊≈Õ¿!'+CHR(13)+CHR(10),0+64,'')

