PROCEDURE RepPv
 IF MESSAGEBOX('ÑÔÎÐÌÈÐÎÂÀÒÜ ÎÒ×ÅÒ ÏÎ ÏÂ?',4+32,'')=7
  RETURN 
 ENDIF 
 
 IF !fso.FileExists(pCommon+'\reppv.dbf')
  CREATE TABLE &pCommon\reppv (recid i autoinc, vs c(9), sn_card c(17), enp c(16), jt c(1), tip c(1), pv c(3), ;
   vs_data d, ucod c(3), imptime t, impfile c(25))
  INDEX on recid TAG recid CANDIDATE 
  INDEX on vs TAG vs
  INDEX on sn_card TAG sn_card
  INDEX on enp TAG enp
  USE IN reppv
 ENDIF 

 xDir=GETDIR(pExpImp)
 
 IF EMPTY(xDir)
  MESSAGEBOX('ÂÛ ÍÈ×ÅÃÎ ÍÅ ÂÛÁÐÀËÈ!',0+64,'')
  RETURN 
 ENDIF 

 tcOldDefDir = SYS(5)+SYS(2003)
 SET DEFAULT TO (xDir)
 
 nExpFiles = ADIR(aExpFiles, 'e???_??????_??????.zip')
 
 IF nExpFiles==0
  SET DEFAULT TO (tcOldDefDir)
  RELEASE nExpFiles, aExpFiles
  MESSAGEBOX('ÍÅ ÎÁÍÀÐÓÆÅÍÎ ÍÈ ÎÄÍÎÃÎ ÎÁÌÅÍÍÎÃÎ ÔÀÉËÀ!', 0+64, '')
  RETURN 
 ENDIF 
 
 MESSAGEBOX('ÎÁÍÀÐÓÆÅÍÎ ' + ALLTRIM(STR(nExpFiles)) + ' ÎÁÌÅÍÍÛÕ ÔÀÉËÀ!', 0+64, '')

 IF OpenFile(pCommon+'\reppv', 'reppv', 'shar', 'vs')>0
  IF USED('reppv')
   USE IN reppv
  ENDIF 
  RETURN 
 ENDIF 

 FOR nNPExpFile = 1 TO nExpFiles
  cExpFileName = aExpFiles(nNPExpFile,1)
  cExpFileName = IIF(OCCURS('\', cexpfilename)>0, SUBSTR(cExpFileName, RAT('\', cExpFileName)+1), cExpFileName)

*  MESSAGEBOX(cExpFileName,0+64,'')

  IF UnzipOpen(xDir+'\'+cExpFileName)==.T.
   FilesInZip = UnZipFileCount()
   DIMENSION ZipArray(13)
   ZipArray = ''
   UnzipSetFolder(xDir)
   UnZipGotoTopFile()
   FOR FileInZip=0 TO FilesInZip-1
    UnzipAFileInfo("ZipArray")
    m.FileInZipName = ALLTRIM(ZipArray(1))
   
    IF fso.FileExists(xDir+'\'+m.FileInZipName)
     fso.DeleteFile(xDir+'\'+m.FileInZipName)
    ENDIF 

    IF UPPER(m.FileInZipName)=STRTRAN(UPPER(cExpFileName),'ZIP','DBF')
*     MESSAGEBOX(m.FileInZipName,0+64,'')
     UnzipByIndex(FileInZip)
    ENDIF 
    IF UPPER(m.FileInZipName)=STRTRAN(UPPER(cExpFileName),'ZIP','FPT')
     UnzipByIndex(FileInZip)
    ENDIF 

    UnzipGotoNextFile()
   ENDFOR  
   UnzipClose()
  ELSE 
   LOOP   
  ENDIF 

  m.cExpFileName = STRTRAN(cExpFileName,'ZIP','DBF')
  =ProcOneEFile(m.cExpFileName)
  
 ENDFOR 
 
 m.datt1 = CTOD('01.'+PADL(MONTH(DATE()),2,'0')+'.'+STR(YEAR(DATE()),4))
 m.datt2 = GOMONTH(m.datt1,1)-1
 
 SET DEFAULT TO (tcOldDefDir)
 
 DO FORM TuneDat
 
* MESSAGEBOX(DTOC(m.datt1)+' '+DTOC(m.datt2),0+64,'')
 
 SELECT 000000 as recid, pv, ucod, tip, coun(*) as cnt FROM reppv WHERE BETWEEN(vs_data, m.datt1, m.datt2) ;
  GROUP BY pv, ucod, tip INTO CURSOR currep READWRITE 
 REPLACE ALL recid WITH RECNO()
 USE IN reppv

 IF OpenFile(pBin+'\pvp2', 'pvp2', 'shar', 'codpv')>0
  IF USED('pvp2')
   USE IN pvp2
  ENDIF 
  USE IN currep
  RETURN 
 ENDIF 
 IF OpenFile(pCommon+'\Users', 'Users', 'shar', 'vir')>0
  IF USED('users')
   USE IN users
  ENDIF 
  USE IN pvp2
  USE IN currep
  RETURN 
 ENDIF 

 SELECT currep
 SET RELATION TO pv INTO pvp2
 SET RELATION TO pv+ucod INTO Users ADDITIVE 

 m.lcTmpName = pTempl+'\reppv.xls'
 m.lcRepName = pOut+'\reppv_'+STRTRAN(DTOC(m.datt1),'.','')+'_'+STRTRAN(DTOC(m.datt2),'.','')+'.xls'
 m.IsVisible = .T.
 
 m.llResult = X_Report(m.lcTmpName, m.lcRepName, m.IsVisible)
 
* REPORT FORM RepPv PREVIEW 
 
 SELECT currep 
 SET RELATION OFF INTO Users
 SET RELATION OFF INTO pvp2
 USE IN pvp2
 USE IN currep
 USE IN users


RETURN 

FUNCTION ProcOneEFile
 LPARAMETERS ExFile
 PRIVATE ExpDbf
 m.ExpDbf = m.ExFile
 
 IF !fso.FileExists(xDir+ExpDbf)
  RETURN 
 ENDIF 
 
 IF OpenFile(xDir+ExpDbf, 'expfile', 'shar')>0
  IF USED('expfile')
   USE IN expfile
  ENDIF 
  RETURN 
 ENDIF 
 
* MESSAGEBOX(expdbf,0+64,'')
 SELECT expfile
 SCAN 
  m.vs       = vs
  m.sn_card = sn_card
  m.enp     = enp
  m.jt      = jt
  m.pv      = pv
  m.vs_data = vs_data
  m.ucod    = ucod
  m.imptime = DATETIME()
  m.impfile = m.ExpDbf
  
  IF m.jt='r'
   LOOP 
  ENDIF 
 
  IF !INLIST(m.jt,'2','z')
   m.tip = '1'
   IF !SEEK(m.vs, 'reppv')
    INSERT INTO reppv FROM MEMVAR 
   ENDIF 
  ELSE 
   m.tip = '2'
   IF !EMPTY(m.enp)
    IF !SEEK(m.enp, 'reppv', 'enp')
     INSERT INTO reppv FROM MEMVAR 
    ENDIF 
   ELSE 
    IF !EMPTY(m.sn_card)
     IF !SEEK(m.sn_card, 'reppv', 'sn_card')
      INSERT INTO reppv FROM MEMVAR 
     ENDIF 
    ELSE 
     IF !EMPTY(m.vs)
      IF !SEEK(m.vs, 'reppv')
       INSERT INTO reppv FROM MEMVAR 
      ENDIF 
     ENDIF 
    ENDIF 
   ENDIF 

  ENDIF 

 ENDSCAN 
 USE IN expfile


RETURN 