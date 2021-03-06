PROCEDURE AppMfc
 IF MESSAGEBOX('��������� ���-�����?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\pvp2.dbf')
  MESSAGEBOX('���������� ���� PVP2.DBF'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF !fso.FileExists(pbin+'\mfc_pv.dbf')
  MESSAGEBOX('���������� ���� MFC_PV.DBF'+CHR(13)+CHR(10),0+16,'')
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
  MESSAGEBOX(CHR(13)+CHR(10)+'���-������ �� ����������!',0+64,'')
  RETURN 
 ENDIF 
 
 oMailDir        = fso.GetFolder(pMFC)
 MailDirName     = oMailDir.Path
 oFilesInMailDir = oMailDir.Files
 nFilesInMailDir = oFilesInMailDir.Count
 
 IF nFilesInMailDir=0
  MESSAGEBOX(CHR(13)+CHR(10)+'���-������ �� ����������!',0+64,'')
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

  IF lcHead != 'PK' && ��� �� zip-����!
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

MESSAGEBOX('��������� ���������!',0+64,'')

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
  MESSAGEBOX('� ������ '+UPPER(m.bname)+'���������� '+ALLTRIM(STR(nKolFiles))+' ������, '+CHR(13)+CHR(10)+;
   '�� ������� 3!',0+16,'')
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
  ELSE 
  ENDIF 
 ENDSCAN 
 USE IN curuni

 UnZipClose()

RETURN 

FUNCTION UnZipOneFile(par1)
 PRIVATE m.zipname, m.npunkt
 m.zipname = par1
 m.npunkt = LEFT(m.zipname,3)

 SELECT * FROM pvp2 WHERE codpv=m.npunkt INTO CURSOR vbnm
 IF RECCOUNT('vbnm')=0
  m.mfcname = IIF(SEEK(m.npunkt, 'mfcpv'), m.npunkt+'(���,'+ALLTRIM(mfcpv.name_mfc)+')', '����� '+m.npunkt+'(���)')
  INSERT INTO pvp2 (v,q,codpv,name_pv,tip_pv,main_pv) VALUES ;
   (.f.,m.qcod,m.npunkt,m.mfcname,1,m.main_pv)
 ENDIF 
 IF USED('vbnm')
  USE IN vbnm
 ENDIF 

 IF !fso.FolderExists(pbase+'\'+m.npunkt)
  fso.CreateFolder(pbase+'\'+m.npunkt)
 ENDIF 
 IF !fso.FolderExists(pbase+'\'+m.npunkt+'\IMP')
  fso.CreateFolder(pbase+'\'+m.npunkt+'\IMP')
 ENDIF 
 IF !fso.FolderExists(pbase+'\'+m.npunkt+'\USR010')
  fso.CreateFolder(pbase+'\'+m.npunkt+'\USR010')
 ENDIF 
 
 =CreateFiles(m.npunkt)
 
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
* UnZipClose()

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

 IF OpenFile(pbase+'\'+m.npunkt+'\kms.dbf', 'kms', 'shar', 'vs')>0
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
 ENDIF 
 IF OpenFile(pbase+'\'+m.npunkt+'\adr77.dbf', 'adr77', 'shar', 'unik')>0
  IF USED('fiofile')
   USE IN fiofile
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
 ENDIF 
 IF OpenFile(pbase+'\'+m.npunkt+'\adr50.dbf', 'adr50', 'shar', 'unik')>0
  IF USED('fiofile')
   USE IN fiofile
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

FUNCTION CreateFiles(para1)
 PRIVATE m.npunkt
 m.npunkt = para1
 m.lpath = pbase+'\'+m.npunkt

 IF !fso.FileExists(m.lpath+'\kms.dbf')
   CREATE TABLE &lpath\kms ;
    (RecId i AUTOINC NEXTVALUE 1 STEP 1 , recid_chld i, pv c(3),;
     nz c(5), status n(1), p_doc n(1), sn_card c(17), vs c(9), vs_data d, ;
     enp c(16), q c(2), dp d, dt d, ;
     fam c(40), d_type1 c(1), im c(40), d_type2 c(1), ot c(40), d_type3 c(1), ;
     dr d, true_dr n(1), w n(1,0), c_okato c(5), ul n(5), d c(7), kor c(5), str c(5), kv c(5), ;
     jt c(1), pricin c(3), tranz c(3), mcod c(7), kl n(2,0), err c(2), pos c(2), cont c(40), ;
     c_doc n(2), s_doc c(9), n_doc c(8), d_doc d, podr_doc m, ss c(14), gr c(3), ;
     mr m, dat_reg d, ;
     form n(1), predst c(1), spos n(1), ffile c(12), d_type4 n(1), ;
     comment m, IsReReg n(1), ogrn_old c(13), okato_old c(5), dp_old d, gz_data d, ;
     fiofile c(15), n_kor n(6), ucod c(3), c_perm n(2), s_perm c(9), n_perm c(8), d_perm d,;
     oc_doc n(2), os_doc c(9), on_doc c(8), od_doc d, ofam c(40), oim c(40), oot c(40),;
     odr d, ow n(1), is2fio c(1), is2doc c(1), oper i, adr_id i, adr50_id i, enp2id i)
            
   SELECT  kms
   INDEX ON RecId TAG recid CANDIDATE 
   INDEX ON pv+STR(recid_chld,10) TAG recid_chld 
   INDEX ON nz TAG nz
   INDEX ON sn_card FOR !EMPTY(sn_card) TAG un_ks
   INDEX ON vs TAG vs 
   INDEX ON enp TAG enp
   INDEX ON sn_card TAG sn_card
   INDEX ON INT(VAL(SUBSTR(sn_card, AT(' ',sn_card)+1))) TAG n_card
   INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30))+DTOC(dr) TAG  fio COLLATE "Russian"
   INDEX ON MCOD+' '+UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30)) TAG fio_mcod COLLATE "Russian"
   INDEX ON mcod TAG mcod
   INDEX ON dp TAG dp
   INDEX ON dt TAG dt
   USE 
  ENDIF 


 IF !fso.FileExists(m.lpath+'\ArcKms.dbf')
  CREATE TABLE &lpath\arckms ;
    (RecId i , pv c(3),;
     nz c(5), status n(1), sn_card c(17), vs c(9), enp c(16),;
     q c(2), dp d, dt d, d_card d, ;
     fam c(25), d_type1 c(1), im c(20), d_type2 c(1), ot c(20), d_type3 c(1), ;
     dr d, w n(1,0), c_okato c(5), ul n(5), d c(7), kor c(5), str c(5), kv c(5), ;
     jt0 c(1), o_jt c(1), jt c(1), mcod c(7), kl n(2,0), err c(2), pos c(2), tel n(11), cont c(40), ;
     pricin c(3), c_doc n(2), s_doc c(9), n_doc c(8), d_doc d, podr_doc c(150), ss c(14), gr c(3), ;
     mr c(150), dat_reg d, obl_name c(60), ra_name c(60), np_c c(2), ;
     np_name c(60), ul_c c(2), ul_name c(60), dom2 c(7), kor2 c(5), str2 c(5), kv2 c(5), ;
     stat_z n(1), form n(1), predst c(1), spos n(1), ffile c(10), d_type4 n(1) )
            
   SELECT  arckms
   INDEX ON RecId TAG recid CANDIDATE 
   INDEX ON nz TAG nz
   INDEX ON sn_card FOR !EMPTY(sn_card) TAG un_ks
   INDEX ON vs TAG vs 
   INDEX ON enp TAG enp
   INDEX ON sn_card TAG sn_card
   INDEX ON INT(VAL(SUBSTR(sn_card, AT(' ',sn_card)+1))) TAG n_card
   INDEX ON UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30))+DTOC(dr) TAG  fio COLLATE "Russian"
   INDEX ON MCOD+' '+UPPER(PADR(ALLTRIM(Fam)+" "+LEFT(im,1)+" "+LEFT(ot,1),30)) TAG fio_mcod COLLATE "Russian"
   INDEX ON mcod TAG mcod
   INDEX ON dp TAG dp
   INDEX ON dt TAG dt
   USE 

 ENDIF 

 IF !fso.FileExists(m.lpath+'\predst.dbf')
  CREATE TABLE &lpath\predst ;
   (RecId i AUTOINC NEXTVALUE 1 STEP 1, Fam c(40), Im c(40), Ot c(40), ;
    c_doc n(2), s_doc c(9), n_doc c(8), d_doc d, podr_doc c(100), tel1 c(10), tel2 c(10), ;
    inf c(100) )
            
  SELECT  predst
  INDEX ON RecId TAG RecId CANDIDATE 
  INDEX ON LEFT(Fam,25)+LEFT(Im,3)+LEFT(Ot,3) TAG fio
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\Answers.dbf')
  CREATE TABLE &lpath\Answers ;
   (recid c(6), data d, tiperz c(15), sn_pol c(17), enp c(16), s_card c(6), n_card n(10), ;
    date_b d, date_e d, q c(2), q_ogrn c(13), fam c(25), im c(25), ot c(25), dr c(8),;
    w n(1,0), ans_r c(3), snils c(14), doc_type c(2), doc_ser c(12), doc_num c(16), ;
    doc_date d, gr c(3), erz c(1), tip_d c(1), okato c(5), npp n(2),err c(150))

  SELECT Answers
  INDEX on INT(VAL(recid)) TAG recid
  INDEX on sn_pol TAG sn_pol
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\user.dbf')
  CREATE TABLE &lpath\user ;
   (pv c(3), ucod i AUTOINC, id c(8), fam c(25), im c(20), ot c(20), kadr n(1))
  INSERT INTO user (pv, id, fam, im, ot, kadr) VALUES ;
   (m.npunkt, 'admin', '�������������', '', '', 1)
  SELECT user
  INDEX ON ucod TAG ucod CANDIDATE 
  USE 
 ENDIF 
         
 IF !fso.FileExists(m.lpath+'\error.dbf')
  CREATE TABLE &lpath\error ;
   (rec_id c(6), s_card c(6), n_card n(10), n_date d, q c(2), err c(2), err_text c(40), app_d d)
  SELECT error
  INDEX ON rec_id TAG rec_id
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\e_ffoms.dbf')
  CREATE TABLE &lpath\e_ffoms (v l, dcor d, recid i, data d, err c(5), "comment" c(250), c_t c(5), ;
   pid c(16), ans_fl c(2), step c(4))
  INDEX ON recid TAG recid
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\pexp.dbf')
  CREATE TABLE &lpath\pExp ;
  (pExp1 l, pExp2 l, pExp3 l, pExp4 l, pExp5 l, pExp6 l, pExp7 l, pExp8 l, pExp9 l, pExp10 l, ;
  minFam n(1), maxFam n(1), minIm n(1), maxIm n(1), minOt n(1), maxOt n(1))
  INSERT  INTO  pExp (pExp1, pExp2, pExp3, pExp4, pExp5, pExp6, pExp7, pExp8, pExp9, pExp10, minFam, maxFam, minIm, maxIm, minOt, maxOt) ;
  VALUES (.t., .t., .t., .t., .t., .t., .t., .t., .t., .t., 0, 1, 0, 1, 0, 1)
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\adr77.dbf')
  CREATE TABLE &lpath\adr77 (recid i AUTOINC, ul n(5), d c(7), kor c(5), str c(5), kv c(5))
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON PADL(ul,5,'0')+d+kor+str+kv TAG unik 
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\adr50.dbf')
  CREATE TABLE &lpath\adr50 (recid i AUTOINC, c_okato c(5), ra_name c(60), np_c c(2), ;
   np_name c(60), ul_c c(2), ul_name c(60), dom c(7), kor c(5), str c(5), kv c(5))
  INDEX ON recid TAG recid CANDIDATE 
  INDEX ON c_okato+LEFT(ra_name,10)+LEFT(np_name,10)+LEFT(ul_name,10)+dom+kor+str+kv TAG unik 
  USE 
 ENDIF 

 IF !fso.FileExists(m.lpath+'\enp2.dbf')
  CREATE TABLE &lpath\enp2 (recid i AUTOINC, enp c(16), ogrn c(13), okato c(5), dp d)
  INDEX ON recid TAG recid CANDIDATE 
  USE 
 ENDIF 

RETURN 
