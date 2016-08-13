PROCEDURE AppP3
 IF kol_pv!=1
  MESSAGEBOX('ÄÎËÆÅÍ ÁÛÒÜ ÂÛÁÐÀÍ 1 ÏÓÍÊÒ!',0+64,'')
  RETURN 
 ENDIF 
 
 IF MESSAGEBOX('ÇÀÃÐÓÇÈÒÜ ÔÐÀÃÌÅÍÒ ÐÅÃÈÑÒÐÀ "ÏÀÍÀÖÅÈ"?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 

 pUpdDir = fso.GetParentFolderName(pbin)+'\P3'
 IF !fso.FolderExists(pUpdDir)
  fso.CreateFolder(pUpdDir)
 ENDIF 
 
 SET DEFAULT TO (pUpdDir)
 DbfFile = ''
 DbfFile = GETFILE('dbf')
 IF EMPTY(DbfFile)
  MESSAGEBOX(CHR(13)+CHR(10)+'ÂÛ ÍÈ×ÅÃÎ ÍÅ ÂÛÁÐÀËÈ!'+CHR(13)+CHR(10),0+16,'')
  SET DEFAULT TO &pbin
  RETURN 
 ENDIF 
 
 SET DEFAULT TO &pbin
 
 IF OpenFile(DbfFile, 'kmsp3', 'shar')>0
  IF USED('kmsp3')
   USE IN kmsp3
  ENDIF 
  RETURN 
 ENDIF 
 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\kms', 'kms', 'shar', 'enp')>0
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('kmsp3')
   USE IN kmsp3
  ENDIF 
  RETURN 
 ENDIF 
 
 IF OpenFile(pbase+'\'+pvid(1,1)+'\adr77', 'adr77', 'shar', 'unik')>0
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('kmsp3')
   USE IN kmsp3
  ENDIF 
  RETURN 
 ENDIF 

 IF OpenFile(pbase+'\'+pvid(1,1)+'\adr50', 'adr50', 'shar')>0
  IF USED('adr50')
   USE IN adr50
  ENDIF 
  IF USED('adr77')
   USE IN adr77
  ENDIF 
  IF USED('kms')
   USE IN kms
  ENDIF 
  IF USED('kmsp3')
   USE IN kmsp3
  ENDIF 
  RETURN 
 ENDIF 

 SELECT kmsp3 
 SCAN 
  m.pv = pvid(1,1)
  m.q = 'P3'
  
  m.enp = enp
  m.kl  = INT(VAL(kl))
  m.fam = ALLTRIM(fam)
  m.im = ALLTRIM(im)
  m.ot = ALLTRIM(ot)
  m.dr = CTOD(SUBSTR(dr,7,2)+'.'+SUBSTR(dr,5,2)+'.'+SUBSTR(dr,1,4))
  m.w = w
  m.lpi_id = lpu_id
  m.ss = snils
  m.gr = gr
  m.mr = mr
  m.cont = cont
  
  m.c_doc = c_doc
  m.s_doc = s_doc
  m.n_doc = n_doc
  m.d_doc = d_doc
  
  m.ul  = adr_msk
  m.d   = adr_dom
  m.kor = adr_kor
  m.str = adr_str
  m.kv  = adr_kvr

  m.unik = PADL(m.ul,5,'0') + m.d + m.kor + m.str + m.kv

  IF !SEEK(m.unik, 'adr77', 'unik')
   INSERT INTO adr77 (ul,d,kor,str,kv) VALUES ;
   (m.ul,m.d,m.kor,m.str,m.kv)
   m.adr_id = GETAUTOINCVALUE()
  ELSE 
   m.adr_id = adr77.recid
  ENDIF 

IF 3=2
 m.c_okato = .c_okato
 m.ra_name = UPPER(ALLTRIM(.ra_name))
 m.np_c    = .np_c
 m.np_name = UPPER(ALLTRIM(.np_name))
 m.ul_c    = .ul_c
 m.ul_name = UPPER(ALLTRIM(.ul_name))
 m.dom2    = LOWER(PADR(ALLTRIM(.dom2),7))
 m.kor2    = LOWER(PADR(ALLTRIM(.kor2),5))
 m.str2    = LOWER(PADR(ALLTRIM(.str2),5))
 m.kv2     = LOWER(PADR(ALLTRIM(.kv2),5))
m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom2+m.kor2+m.str2+m.kv2

IF !SEEK(m.unik, 'adr50', 'unik')
 INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
  (thisform.c_okato, thisform.ra_name, thisform.np_c, thisform.np_name, thisform.ul_c, thisform.ul_name, ;
   thisform.dom2, thisform.kor2, thisform.str2, thisform.kv2)
 m.adr50_id = GETAUTOINCVALUE()
ELSE 
 m.adr50_id = adr50.recid
ENDIF 
THISFORM.adr50_id = m.adr50_id
ENDIF 

  IF !SEEK(m.enp, 'kms')
   INSERT INTO kms FROM MEMVAR 
  ENDIF 

 ENDSCAN 
 USE IN kmsp3
 USE IN kms
 USE IN adr50
 USE IN adr77

RETURN 