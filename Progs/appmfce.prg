PROCEDURE AppMfcE
 IF MESSAGEBOX('ÇÀÃÐÓÇÈÒÜ ÌÔÖ-ÔÀÉËÛ?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÅÒ ÔÀÉË PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÅÒ ÔÀÉË MFC_PV.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
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
 
 SELECT codpv FROM pvp2 WHERE tip_pv=2 INTO CURSOR mainpv
 IF RECCOUNT('mainpv')=1
  m.main_pv = codpv
 ELSE 
  m.main_pv = ''
 ENDIF 
 IF USED('mainpv')
  USE IN mainpv
 ENDIF 

 pMFC = fso.GetParentFolderName(pbin) + '\MFC'
 
 IF !fso.FolderExists(pMFC)
  fso.CreateFolder(pMFC)
  MESSAGEBOX(CHR(13)+CHR(10)+'ÌÔÖ-ÔÀÉËÎÂ ÍÅ ÎÁÍÀÐÓÆÅÍÎ!',0+64,'')
  RETURN 
 ENDIF 
 
 oMailDir        = fso.GetFolder(pMFC)
 MailDirName     = oMailDir.Path
 oFilesInMailDir = oMailDir.Files
 nFilesInMailDir = oFilesInMailDir.Count
 
 IF nFilesInMailDir=0
  MESSAGEBOX(CHR(13)+CHR(10)+'ÌÔÖ-ÔÀÉËÎÂ ÍÅ ÎÁÍÀÐÓÆÅÍÎ!',0+64,'')
  RETURN 
 ENDIF 
 
 CREATE CURSOR appstat (pv c(3), kolv n(5))
 
 FOR EACH oFileInMailDir IN oFilesInMailDir

  m.BFullName = oFileInMailDir.Path
  m.bname     = oFileInMailDir.Name
  m.recieved  = oFileInMailDir.DateLastModified
  
  IF LEFT(LOWER(ALLTRIM(m.bname)),1) != 'c'
   LOOP 
  ENDIF 
  IF SUBSTR(UPPER(ALLTRIM(m.bname)),2,2) != UPPER(m.qcod)
   LOOP 
  ENDIF 
  IF LEN(ALLTRIM(m.bname))!=12
   LOOP
  ENDIF 
  IF LOWER(RIGHT(ALLTRIM(m.bname),3)) != 'zip'
   LOOP 
  ENDIF 
  
  frfile = fso.GetFile(MailDirName+'\'+m.bname)
  IF frfile.size >= 2
   fhandl = frfile.OpenAsTextStream
   lcHead = fhandl.Read(2)
   fhandl.Close
  ELSE 
   lcHead = ''
  ENDIF 

  IF lcHead != 'PK' && Ýòî íå zip-ôàéë!
   LOOP 
  ENDIF 
  
  m.datafl = SUBSTR(bname,4,5)

  =AppOneCFile(ALLTRIM(m.bname))

 ENDFOR 

 IF USED('pvp2')
  USE IN pvp2
 ENDIF 
 IF USED('mfcpv')
  USE IN mfcpv
 ENDIF 

 SELECT appstat 
 BROWSE 

 MESSAGEBOX('ÎÁÐÀÁÎÒÊÀ ÇÀÊÎÍ×ÅÍÀ!',0+64,'')

RETURN 

FUNCTION AppOneCFile(par1)
 PRIVATE m.bname
 DIMENSION dimZip(13)
 dimZip = ''
 m.bname = par1

 IF !UnZipOpen(MailDirName+'\'+m.bname)
  RETURN 
 ENDIF 
 IF !UnzipGotoTopFile()
  UnZipClose()
  RETURN 
 ENDIF 

 nKolFiles = UnzipFileCount()
 
 IF FLOOR(nKolFiles/3)!=CEILING(INT(nKolFiles/3))
  MESSAGEBOX('Â ÀÐÕÈÂÅ '+UPPER(m.bname)+'ÑÎÄÅÐÆÈÒÑß '+ALLTRIM(STR(nKolFiles))+' ÔÀÉËÎÂ, '+CHR(13)+CHR(10)+;
   'ÍÅ ÊÐÀÒÍÎÅ 3!',0+16,'')
  UnZipClose()
  RETURN 
 ENDIF 

 CREATE CURSOR curuni (name c(8))
 INDEX ON name TAG name 
 SET ORDER TO name 
 
 DO WHILE UnzipGotoNextFile()
  UnzipAFileInfo('dimZip')
  IF LEN(UPPER(ALLTRIM(dimZip(1))))!=17
   LOOP 
  ENDIF 
  IF RIGHT(UPPER(ALLTRIM(dimZip(1))),3)!='DBF'
   LOOP 
  ENDIF 

  m.cfile = SUBSTR(ALLTRIM(dimZip(1,1)),6,8)
  IF !SEEK(m.cfile, 'curuni')
   INSERT INTO curuni (name) VALUES (m.cfile)
  ENDIF 

 ENDDO 
 
 SELECT curuni
 SCAN 
  m.zipname = name
  IF UnZipOneFile(m.zipname)
*   MESSAGEBOX(m.bname,0+64,m.zipname)
  ELSE 
*   MESSAGEBOX(m.bname,0+64,m.zipname)
  ENDIF 
 ENDSCAN 
* BROWSE 
 USE IN curuni

 UnZipClose()

RETURN 

FUNCTION UnZipOneFile(par1)
 PRIVATE m.zipname, m.npunkt
 m.zipname = par1
 m.npunkt = LEFT(m.zipname,3)

 SELECT * FROM pvp2 WHERE codpv=m.npunkt INTO CURSOR vbnm
 IF RECCOUNT('vbnm')=0
  m.mfcname = IIF(SEEK(m.npunkt, 'mfcpv'), m.npunkt+'(ÌÔÖ,'+ALLTRIM(mfcpv.name_mfc)+')', 'ÏÓÍÊÒ '+m.npunkt+'(ÌÔÖ)')
  INSERT INTO pvp2 (v,q,codpv,name_pv,tip_pv,main_pv) VALUES ;
   (.f.,m.qcod,m.npunkt,m.mfcname,1,m.main_pv)
 ENDIF 
 IF USED('vbnm')
  USE IN vbnm
 ENDIF 

 m.rstfile = m.qcod+m.zipname+'.dbf'
 
 fiofile = 'FIO'+m.rstfile
 adrfile = 'ADR'+m.rstfile
 docfile = 'DUL'+m.rstfile

 IF !UnzipGotoFileByName(fiofile)
  RETURN .f.
 ENDIF 
 IF !UnzipGotoFileByName(adrfile)
  RETURN .f.
 ENDIF 
 IF !UnzipGotoFileByName(docfile)
  RETURN .f. 
 ENDIF 
 
 IF fso.FileExists(pMFC+'\'+fiofile)
  fso.DeleteFile(pMFC+'\'+fiofile)
 ENDIF 
 IF fso.FileExists(pMFC+'\'+adrfile)
  fso.DeleteFile(pMFC+'\'+adrfile)
 ENDIF 
 IF fso.FileExists(pMFC+'\'+docfile)
  fso.DeleteFile(pMFC+'\'+docfile)
 ENDIF 
 
 UnzipGotoFileByName(fiofile)
 UnzipFile(pMFC)
 UnzipGotoFileByName(adrfile)
 UnzipFile(pMFC)
 UnzipGotoFileByName(docfile)
 UnzipFile(pMFC)

 oApp.CodePage(pMFC+'\'+fiofile, 866, .t.)
 oApp.CodePage(pMFC+'\'+adrfile, 866, .t.)
 oApp.CodePage(pMFC+'\'+docfile, 866, .t.)
 
 IF OpenFile(pMFC+'\'+fiofile, 'fiofile', 'shar')>0
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
 ENDIF 
 IF OpenFile(pMFC+'\'+docfile, 'docfile', 'excl')>0
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('docfile')
   USE IN docfile
  ENDIF 
 ENDIF 
 IF OpenFile(pMFC+'\'+adrfile, 'adrfile', 'excl')>0
  IF USED('adrfile')
   USE IN adrfile
  ENDIF 
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('docfile')
   USE IN docfile
  ENDIF 
 ENDIF 

 SELECT docfile
 INDEX ON recid TAG recid 
 SET ORDER TO recid
 SELECT adrfile
 INDEX ON recid TAG recid 
 SET ORDER TO recid

 SELECT fiofile
 SET RELATION TO recid INTO docfile
 SET RELATION TO recid INTO adrfile

 IF OpenFile(pbase+'\kms.dbf', 'kms', 'shar', 'vs')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('adrfile')
   USE IN adrfile
  ENDIF 
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('docfile')
   USE IN docfile
  ENDIF 
 ENDIF 
 IF OpenFile(pbase+'\adr77.dbf', 'adr77', 'shar', 'unik')>0
  IF USED('adrfile')
   USE IN adrfile
  ENDIF 
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('docfile')
   USE IN docfile
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
 ENDIF 
 IF OpenFile(pbase+'\adr50.dbf', 'adr50', 'shar', 'unik')>0
  IF USED('adrfile')
   USE IN adrfile
  ENDIF 
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('docfile')
   USE IN docfile
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  IF USED('adr50')
   USE IN adr50
  ENDIF 
 ENDIF 
 
 SELECT fiofile
 m.kol = 0
 SCAN 
  SCATTER FIELDS EXCEPT recid,pv,q,mfc_id,s_card,n_card,kl,dr,spos,predst,doc MEMVAR 

  m.pv      = pv
  m.sn_card = ALLTRIM(s_card+' '+IIF(n_card>0, PADL(n_card,10,'0'), ''))
  m.sn_card = IIF(EMPTY(m.sn_card), UPPER(qcod)+m.npunkt+' '+vs, m.sn_card)
  m.kl      = INT(VAL(kl))
  m.dr      = CTOD(SUBSTR(dr,7,2)+'.'+SUBSTR(dr,5,2)+'.'+SUBSTR(dr,1,4))
  m.prdest  = STR(predst,1)
  m.d       = dom
  
  m.d   = LOWER(PADR(ALLTRIM(m.d),7))
  m.kor = LOWER(PADR(ALLTRIM(m.kor),5))
  m.str = LOWER(PADR(ALLTRIM(m.str),5))
  m.kv  = LOWER(PADR(ALLTRIM(m.kv),5))
      
  m.unik = PADL(m.ul,5,'0') + m.d + m.kor + m.str + m.kv
  IF !SEEK(m.unik, 'adr77')
   INSERT INTO adr77 (ul,d,kor,str,kv) VALUES (m.ul,m.d,m.kor,m.str,m.kv)
   m.adr_id = GETAUTOINCVALUE()
  ELSE 
   m.adr_id = adr77.recid 
  ENDIF 

  m.c_doc = docfile.c_doc
  m.s_doc = docfile.s_doc
  m.n_doc = docfile.n_doc
  m.d_doc = docfile.d_doc
  
  m.c_okato  = adrfile.adr_ter+adrfile.adr_reg
  m.ra_name  = adrfile.adr_rjn
  m.np_name  = adrfile.adr_gor
  m.ul_name  = adrfile.adr_ul
  m.dom2     = adrfile.adr_dom 
  m.kor2     = adrfile.adr_kor
  m.str2     = adrfile.adr_str
  m.kv2      = adrfile.adr_kvr
  m.dat_reg  = adrfile.dat_reg
  
  m.adr50_id = 0
  IF !EMPTY(m.c_okato) AND m.c_okato!='45000'
   m.ra_name = UPPER(ALLTRIM(m.ra_name))
   m.np_name = UPPER(ALLTRIM(m.np_name))
   m.ul_name = UPPER(ALLTRIM(m.ul_name))
   m.dom2    = LOWER(PADR(ALLTRIM(m.dom2),7))
   m.kor2    = LOWER(PADR(ALLTRIM(m.kor2),5))
   m.str2    = LOWER(PADR(ALLTRIM(m.str2),5))
   m.kv2     = LOWER(PADR(ALLTRIM(m.kv2),5))
     
   m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom+m.kor+m.str+m.kv
   IF !SEEK(m.unik, 'adr50')
    INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
     (m.c_okato, m.ra_name, m.np_c, m.np_name, m.ul_c, m.ul_name, m.dom2, m.kor2, m.str2, m.kv2)
    m.adr50_id = GETAUTOINCVALUE()
   ELSE 
    m.adr50_id = adr50.recid 
   ENDIF 
  ENDIF 
  MESSAGEBOX(m.vs,0+64,'')
  IF !SEEK(m.vs, 'kms')  
   INSERT INTO kms FROM MEMVAR 
   m.kol = m.kol + 1
  ENDIF 

 ENDSCAN 
 SET RELATION OFF INTO docfile
 SET RELATION OFF INTO adrfile
 USE
 SELECT docfile
 SET ORDER TO 
 DELETE TAG ALL 
 USE 
 SELECT adrfile
 SET ORDER TO 
 DELETE TAG ALL 
 USE 
 
 USE IN kms
 USE IN adr50
 USE IN adr77
 
 INSERT INTO appstat (pv, kolv) VALUES (m.npunkt, m.kol)

RETURN .t. 

