PROCEDURE efile2kms
 IF MESSAGEBOX("ХОТИТЕ ПРИНЯТЬ ОБМЕННЫЕ ФАЙЛЫ?", 4+32, 'НОВЫЙ ВАРИАНТ') != 6
  RETURN 
 ENDIF 

 tcOldDefDir = SYS(5)+SYS(2003)
 SET DEFAULT TO (pExpImp)
 
* nExpFiles = ADIR(aExpFiles, 'e???_??????_??????.dbf')
 nExpFiles = ADIR(aExpFiles, 'e???_??????_??????.zip')
 
 IF nExpFiles==0
  SET DEFAULT TO (tcOldDefDir)
  RELEASE nExpFiles, aExpFiles
  MESSAGEBOX('НЕ ОБНАРУЖЕНО НИ ОДНОГО ОБМЕННОГО ФАЙЛА!', 0+64, '')
  RETURN 
 ENDIF 
 
 nImpFiles = ADIR(aImpFiles, 'i???_??????_??????.dbf')
 
 nNPExpFiles = nExpFiles
 FOR nExpFile=1 TO nExpFiles
  IF !EMPTY(aExpFiles(nExpFile,1))
   cExpFileName = aExpFiles(nExpFile,1)
   cImpFileName = STRTRAN(aExpFiles(nExpFile,1),'E','I')
   nFndImpElement = IIF(nImpFiles>0, ASCAN(aImpFiles, cImpFileName), 0)
   IF nFndImpElement > 0 
    nFndExpElement = ASCAN(aExpFiles, cExpFileName)
    =ADEL(aExpFiles, nFndExpElement)
    nNPExpFiles = nNPExpFiles - 1
    nExpFile = nExpFile - 1
   ENDIF 
  ELSE 
   EXIT 
  ENDIF 
 ENDFOR 
 
 IF nNPExpFiles <= 0
  SET DEFAULT TO (tcOldDefDir)
  RELEASE nExpFiles, aExpFiles, nImpFiles, aImpFiles
  MESSAGEBOX('ВСЕ ОБНАРУЖЕННЫЕ ОБМЕННЫЕ ФАЙЛЫ ОБРАБОТАНЫ!', 0+64, '')
  RETURN 
 ENDIF 
 
 MESSAGEBOX('ОБНАРУЖЕНО ' + ALLTRIM(STR(nNPExpFiles)) + ' ОБМЕННЫХ ФАЙЛА!', 0+64, '')

 FOR nNPExpFile = 1 TO nNPExpFiles
  cExpFileName = aExpFiles(nNPExpFile,1)
  cExpFileName = IIF(OCCURS('\', cexpfilename)>0, SUBSTR(cExpFileName, RAT('\', cExpFileName)+1), cExpFileName)
  MESSAGEBOX(cExpFileName,0+64,'')

  IF UnzipOpen(pExpImp+'\'+cExpFileName)==.T.
   FilesInZip = UnZipFileCount()
*   CREATE CURSOR CursZip (EFile c(25))
   DIMENSION ZipArray(13)
   ZipArray = ''
   UnzipSetFolder(pExpImp)
   UnZipGotoTopFile()
   FOR FileInZip=0 TO FilesInZip-1
    UnzipAFileInfo("ZipArray")
    m.FileInZipName = ALLTRIM(ZipArray(1))
   
    IF fso.FileExists(pExpImp+'\'+m.FileInZipName)
     fso.DeleteFile(pExpImp+'\'+m.FileInZipName)
    ENDIF 

    UnzipByIndex(FileInZip)
*    INSERT INTO CursZip (EFile) VALUES (m.FileInZipName)

    UnzipGotoNextFile()
   ENDFOR  
   UnzipClose()
  ELSE 
   LOOP   
  ENDIF 
  m.cExpFileName = STRTRAN(cExpFileName,'ZIP','DBF')
  =ProcOneEFile(m.cExpFileName)
  
 ENDFOR 
 
* SELECT CursZip
* BROWSE 
* USE 
 
 SET DEFAULT TO (tcOldDefDir)
 oApp.CloseAllTable()

RETURN 

FUNCTION ProcOneEFile
 LPARAMETERS ExFile
 PRIVATE ExpDbf

 ExpDbf = ExFile
 ExpFpt = STRTRAN(ExpDbf, 'DBF', 'FPT')
 ImpDbf = STRTRAN(ExpDbf, 'E', 'I')
 ImpErr = STRTRAN(ExpDbf, 'E', 'ERR')
 ImpFpt = STRTRAN(ImpDbf, 'DBF', 'FPT')
 
 pnktvid = SUBSTR(ExpDbf,2,3)
 
 IF INLIST(SUBSTR(m.lcProgram, RAT('\',m.lcProgram)+1),'KMS.EXE','KMSPV.EXE')
  m.lppath = pBase
 ELSE 
  m.lppath = pBase+'\'+pnktvid
 ENDIF 

 m.IsOk=.t.
 IF !fso.FileExists(pcommon+'\users.dbf')
  m.IsOk=.f.
 ENDIF 
 IF m.IsOk
  IF OpenFile(pcommon+'\users', 'users', 'shar', 'vir')>0
   IF USED('users')
    USE IN users
   ENDIF 
   m.IsOk=.f.
  ENDIF 
 ENDIF 
 IF m.IsOk
  IF !fso.FileExists(pexpimp+'\user'+pnktvid+'.dbf')
   IF USED('users')
    USE IN users
   ENDIF 
   m.IsOk=.f.
  ENDIF 
 ENDIF 
 IF m.IsOk
  IF OpenFile(pexpimp+'\user'+pnktvid+'.dbf', 'duser', 'shar')>0
   IF USED('users')
    USE IN users
   ENDIF 
   IF USED('duser')
    USE IN duser
   ENDIF 
   m.IsOk=.f.
  ENDIF 
 ENDIF 

 IF m.IsOk
  SELECT dUser
  SCAN
   m.vir = pv+PADL(ucod,3,'0')
   IF !SEEK(m.vir, 'users')
    m.u_pv   = pv
    m.u_ucod = ucod
    m.u_id   = id
    m.u_fam  = fam
    m.u_im   = im
    m.u_ot   = ot
    m.u_kadr = kadr
    INSERT INTO users (pv,ucod,id,fam,im,ot,kadr) VALUES ;
     (m.u_pv,m.u_ucod,m.u_id, m.u_fam, m.u_im,m.u_ot,m.u_kadr)
   ENDIF 
  ENDSCAN 
  USE 
  USE IN Users
 ENDIF 
 
 USE (ExpDbf) IN 0 ALIAS eexp SHARED 
 SELECT eexp
 COPY TO (ImpDbf)
 USE 
 
 tnResult = 0
 tnResult = tnResult + OpenFile("&lppath\kms", "kms", "shared", "vs")
 tnResult = tnResult + OpenFile("&lppath\adr77", "adr77", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\adr50", "adr50", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\enp2", "enp2", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\osmo", "osmo", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\odoc", "odoc", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\ofio", "ofio", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\permiss", "permiss", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\permis2", "permis2", "shared", "recid")
 tnResult = tnResult + OpenFile("&lppath\wrkpl", "wrkpl", "shared", "name")
 tnResult = tnResult + OpenFile("&ImpDbf", "ImpFile", "excl")
 tnResult = tnResult + OpenFile("&PCommon\Jt", "jtt", "shared", "jt")
 
 IF tnResult > 0
  oApp.CloseAllTable()
  RETURN 
 ENDIF 
 
 CREATE CURSOR errcur (pv c(3), vs c(9), sn_card c(25), enp c(16), fam c(25), im c(20), ot c(20), dr d,;
  fam2 c(25), im2 c(20), ot2 c(20), dr2 d, cmnt c(100))
 
 SELECT ImpFile
 nRecords = RECCOUNT()
 nProceed = 0
 nProceedBefore = 0
 
 nProceedBefore = 0
 nAddedRecs = 0
 nUpdatedRecs = 0

 SCAN
  nProceed = nProceed + 1
  m.c_okato=''
  SCATTER MEMO MEMVAR 
  RELEASE permid,ofioid,odocid,osmoid,predstid,wrkid,ucod,oper
  m.operpv = oper

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
  
  m.adr50_id = 0
  IF !EMPTY(m.c_okato) AND m.c_okato!='45000'
  m.ra_name = UPPER(ALLTRIM(m.ra_name))
  m.np_name = UPPER(ALLTRIM(m.np_name))
  m.ul_name = UPPER(ALLTRIM(m.ul_name))
  m.dom     = LOWER(PADR(ALLTRIM(m.dom2),7))
  m.kor     = LOWER(PADR(ALLTRIM(m.kor2),5))
  m.str     = LOWER(PADR(ALLTRIM(m.str2),5))
  m.kv      = LOWER(PADR(ALLTRIM(m.kv2),5))
     
  m.unik = m.c_okato+LEFT(m.ra_name,10)+LEFT(m.np_name,10)+LEFT(m.ul_name,10)+m.dom+m.kor+m.str+m.kv
  IF !SEEK(m.unik, 'adr50')
   INSERT INTO adr50 (c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, str, kv) VALUES ;
    (m.c_okato, m.ra_name, m.np_c, m.np_name, m.ul_c, m.ul_name, m.dom, m.kor, m.str, m.kv)
   m.adr50_id = GETAUTOINCVALUE()
  ELSE 
   m.adr50_id = adr50.recid 
  ENDIF 
  ENDIF 

  m.c_perm = IIF(FIELD('c_perm')='C_PERM', c_perm, 0)
  m.s_perm = IIF(FIELD('s_perm')='S_PERM', s_perm, '')
  m.n_perm = IIF(FIELD('n_perm')='N_PERM', n_perm, '')
  m.d_perm = IIF(FIELD('d_perm')='D_PERM', d_perm, {})

  m.permid = 0
  IF !EMPTY(m.n_perm)
   m.unik = m.s_perm + n_perm
*   IF !SEEK(m.unik, 'permiss')
    INSERT INTO permiss (c_perm,s_perm,n_perm,d_perm) VALUES (m.c_perm,m.s_perm,m.n_perm,m.d_perm)
    m.permid = GETAUTOINCVALUE()
*   ELSE 
*    m.permid = permiss.recid 
*   ENDIF 
  ENDIF 

  m.c_perm = IIF(FIELD('c_perm2')='C_PERM2', c_perm2, 0)
  m.s_perm = IIF(FIELD('s_perm2')='S_PERM2', s_perm2, '')
  m.n_perm = IIF(FIELD('n_perm2')='N_PERM2', n_perm2, '')
  m.d_perm = IIF(FIELD('d_perm2')='D_PERM2', d_perm2, {})

  m.perm2id = 0
  IF !EMPTY(m.n_perm)
   m.unik = m.s_perm + n_perm
*   IF !SEEK(m.unik, 'permiss')
    INSERT INTO permis2 (c_perm,s_perm,n_perm,d_perm) VALUES (m.c_perm,m.s_perm,m.n_perm,m.d_perm)
    m.perm2id = GETAUTOINCVALUE()
*   ELSE 
*    m.permid = permiss.recid 
*   ENDIF 
  ENDIF 

  m.o_fam = IIF(FIELD('ofam')='OFAM', ofam, '')
  m.o_im  = IIF(FIELD('oim')='OIM', oim, '')
  m.o_ot  = IIF(FIELD('oot')='OOT', oot, '')
  m.o_dr  = IIF(FIELD('odr')='ODR', odr, {})
  m.o_w   = IIF(FIELD('ow')='OW', ow, 0)

  m.ofioid = 0
  IF !EMPTY(m.o_fam) OR !EMPTY(m.o_im) OR !EMPTY(m.o_ot) OR !EMPTY(m.o_dr) OR !EMPTY(m.o_w)
   INSERT INTO ofio (fam,im,ot,dr,w) VALUES (m.o_fam,m.o_im,m.o_ot,m.o_dr,m.o_w)
   m.ofioid = GETAUTOINCVALUE()
  ENDIF 

  m.c_doc = IIF(FIELD('oc_doc')='OC_DOC', oc_doc, 0)
  m.s_doc = IIF(FIELD('os_doc')='OS_DOC', os_doc, '')
  m.n_doc = IIF(FIELD('on_doc')='ON_DOC', on_doc, '')
  m.d_doc = IIF(FIELD('od_doc')='OD_DOC', od_doc, {})

  m.odocid = 0
  IF !EMPTY(m.c_doc)
   INSERT INTO odoc (c_doc,s_doc,n_doc,d_doc) VALUES (m.c_doc,m.s_doc,m.n_doc,m.d_doc)
   m.odocid = GETAUTOINCVALUE()
  ENDIF 

  m.c_doc = c_doc
  m.s_doc = s_doc
  m.n_doc = n_doc
  m.d_doc = d_doc

  m.okato_old = IIF(FIELD('okato_old')='OKATO_OLD', okato_old, '')
  m.ogrn_old  = IIF(FIELD('ogrn_old')='OGRN_OLD', ogrn_old, '')
  m.dp_old    = IIF(FIELD('dp_old')='DP_OLD', dp_old, {})

  m.osmoid = 0
  IF !EMPTY(m.okato_old)
   INSERT INTO osmo (okato,ogrn,dp) VALUES (m.okato_old,m.ogrn_old,m.dp_old)
   m.osmoid = GETAUTOINCVALUE()
  ENDIF 
  
  m.wrkid = 0
  IF SEEK(LEFT(m.wrkname,50), 'wrkpl')
   m.wrkid = wrkpl.recid
  ELSE 
   INSERT INTO wrkpl (code,name) VALUES (m.wrkcode,m.wrkname)
   m.wrkid = GETAUTOINCVALUE()
  ENDIF 

  m.dt = IIF(m.dt={31.12.9999}, {31.12.2099}, m.dt)

  IF EMPTY(m.recid_smo) && Запись ранее не обрабатывалась
   DO CASE 
    CASE m.jt=='2'
     IF !EMPTY(m.enp) OR m.qcod='S6'
      IF m.qcod!='R4'
       m.new_recid = UpdIns('enp', m.enp)
      ELSE 
       m.new_recid = UpdIns('', m.enp)
      ENDIF 
*      m.new_recid = UpdIns('vs', m.vs)

*      IF m.form=2
       =AppJpeg(m.recid_pv, m.new_recid)
*      ENDIF 

     ELSE 
      INSERT INTO errcur ;
       (pv, vs, enp, fam, im, ot, dr, cmnt);
        VALUES;
       (m.pnktvid, m.vs, m.enp, m.fam, m.im, m.ot, m.dr, 'Пустое ЕНП')
      m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
      MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
       'подан с признаком движения '+m.jt+', '+CHR(13)+CHR(10)+;
       'для которого обязательно заполнения поля ENP!'+CHR(13)+CHR(10)+;
       'В данной записи (recid_pv='+ALLTRIM(STR(m.recid_pv))+' поле ENP путое!'+CHR(13)+CHR(10),;
        0+48,'Некорректная запись!')
     ENDIF 

    CASE m.jt=='z'
      DO CASE 
      CASE !EMPTY(m.sn_card)
       IF m.qcod!='R4'
        m.new_recid = UpdIns('sn_card', m.sn_card)
       ELSE 
        m.new_recid = UpdIns('', m.sn_card)
       ENDIF 

*       IF m.form=2
        =AppJpeg(m.recid_pv, m.new_recid)
*       ENDIF 

      CASE !EMPTY(m.enp) OR m.qcod='S6'
       IF m.qcod!='R4'
        m.new_recid = UpdIns('enp', m.enp)
       ELSE 
        m.new_recid = UpdIns('', m.enp)
       ENDIF 

*       IF m.form=2
        =AppJpeg(m.recid_pv, m.new_recid)
*       ENDIF 

      OTHERWISE 

       INSERT INTO errcur ;
        (pv, vs, sn_card, enp, fam, im, ot, dr, cmnt);
         VALUES;
        (m.pnktvid, m.vs, m.sn_card, m.enp, m.fam, m.im, m.ot, m.dr, 'Пустое ЕНП и КМС')
       m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
       MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
        'подан с призаком движения '+m.jt+', '+CHR(13)+CHR(10)+;
        'для которого обязательно заполнения поля SN_CARD!'+CHR(13)+CHR(10)+;
        'В данной записи (recid_pv='+ALLTRIM(STR(m.recid_pv))+' поле SN_CARD пустое!'+CHR(13)+CHR(10),;
         0+48,'Некорректная запись!')

      ENDCASE 

    CASE m.jt=='k'
     IF m.qcod='P2'
      nAddedRecs = nAddedRecs + 1
      INSERT INTO kms FROM MEMVAR 
      m.new_recid = GETAUTOINCVALUE()
      REPLACE recid_smo WITH m.new_recid

*      IF m.form=2
       =AppJpeg(m.recid_pv, m.new_recid)
*      ENDIF 
     ELSE 
      DO CASE
      CASE !EMPTY(m.sn_card) 
       m.new_recid = UpdIns('sn_card', m.sn_card)

*       IF m.form=2
        =AppJpeg(m.recid_pv, m.new_recid)
*       ENDIF 

      CASE !EMPTY(m.enp) OR m.qcod='S6'
       m.new_recid = UpdIns('enp', m.enp)
 
*       IF m.form=2
        =AppJpeg(m.recid_pv, m.new_recid)
*       ENDIF 

      OTHERWISE 

       INSERT INTO errcur ;
        (pv, vs, sn_card, enp, fam, im, ot, dr, cmnt);
         VALUES;
        (m.pnktvid, m.vs, m.sn_card, m.enp, m.fam, m.im, m.ot, m.dr, 'Пустое ЕНП и КМС')
       m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
       MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
        'подан с призаком движения '+m.jt+', '+CHR(13)+CHR(10)+;
        'для которого обязательно заполнения поля SN_CARD!'+CHR(13)+CHR(10)+;
        'В данной записи (recid_pv='+ALLTRIM(STR(m.recid_pv))+' поле SN_CARD пустое!'+CHR(13)+CHR(10),;
         0+48,'Некорректная запись!')

      ENDCASE 
     ENDIF 

    CASE m.jt=='d'
     IF !EMPTY(m.enp) OR m.qcod='S6'
      m.new_recid = UpdIns('enp', m.enp)

*      IF m.form=2
       =AppJpeg(m.recid_pv, m.new_recid)
*      ENDIF 

     ELSE 
      INSERT INTO errcur ;
       (pv, vs, enp, fam, im, ot, dr, cmnt);
        VALUES;
       (m.pnktvid, m.vs, m.enp, m.fam, m.im, m.ot, m.dr, 'Пустое ЕНП')
      m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
      MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
       'подан с признаком движения '+m.jt+', '+CHR(13)+CHR(10)+;
       'для которого обязательно заполнения поля ENP!'+CHR(13)+CHR(10)+;
       'В данной записи (recid_pv='+ALLTRIM(STR(m.recid_pv))+' поле ENP путое!'+CHR(13)+CHR(10),;
        0+48,'Некорректная запись!')
     ENDIF 

    CASE m.jt=='r'
     IF !EMPTY(m.vs) OR m.qcod='S6'
      m.scn = 'POK'
      m.new_recid = UpdIns('vs', m.vs)
     ELSE 
      INSERT INTO errcur ;
       (pv, vs, enp, fam, im, ot, dr, cmnt);
        VALUES;
       (m.vs, m.enp, m.fam, m.im, m.ot, m.dr, 'Пустое ВС')
      m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
      MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
       'подан с призаком движения '+m.jt+', '+CHR(13)+CHR(10)+;
       'для которого обязательно заполнения поля ENP!'+CHR(13)+CHR(10)+;
       'В данной записи (recid_pv='+ALLTRIM(STR(m.recid_pv))+' поле VS путое!'+CHR(13)+CHR(10),;
        0+48,'Некорректная запись!')
     ENDIF 

    OTHERWISE 
     IF EMPTY(m.vs)
*      IF !INLIST(m.jt,'k','0')
       IF m.qcod!='S6'
       INSERT INTO errcur ;
        (pv, vs, enp, fam, im, ot, dr, cmnt);
         VALUES;
        (m.pnktvid, m.vs, m.enp, m.fam, m.im, m.ot, m.dr, 'Пустое ВС')
       m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
       MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
        'подан с призаком движения '+m.jt+', '+CHR(13)+CHR(10)+;
        'для которого обязательно заполнения поля VS!'+CHR(13)+CHR(10)+;
        'В данной записи (recid_pv='+ALLTRIM(STR(m.recid_pv))+' поле VS путое!'+CHR(13)+CHR(10),;
        0+48,'Некорректная запись!')
       ELSE && m.qcod='S6'

       nAddedRecs = nAddedRecs + 1
       INSERT INTO kms FROM MEMVAR 
       m.new_recid = GETAUTOINCVALUE()
       REPLACE recid_smo WITH m.new_recid

*        IF m.form=2
         =AppJpeg(m.recid_pv, m.new_recid)
*        ENDIF 

       ENDIF 
*      ENDIF 
     ELSE 

      IF !SEEK(m.vs, 'kms', 'vs')
       nAddedRecs = nAddedRecs + 1
       INSERT INTO kms FROM MEMVAR 
       m.new_recid = GETAUTOINCVALUE()
       REPLACE recid_smo WITH m.new_recid

*        IF m.form=2
         =AppJpeg(m.recid_pv, m.new_recid)
*        ENDIF 

      ELSE 

       IF m.jt='1'
        m.fam2 = ALLTRIM(kms.fam)
        m.im2  = ALLTRIM(kms.im)
        m.ot2  = ALLTRIM(kms.ot)
        m.dr2  = kms.dr
        INSERT INTO errcur ;
         (pv, vs, enp, fam, im, ot, dr, fam2, im2, ot2, dr2, cmnt);
          VALUES;
         (m.pnktvid, m.vs, m.enp, m.fam, m.im, m.ot, m.dr, m.fam2, m.im2, m.ot2, m.dr2, 'ВС выдан ранее')
        m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
        MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
         'подан с временным свидетельством '+m.vs+', '+CHR(13)+CHR(10)+;
         'выданным ранее'+CHR(13)+CHR(10)+;
         m.fam2+' '+m.im2+' '+m.ot2+CHR(13)+CHR(10),0+48,'Некорректная запись!')
       ELSE 
        nUpdatedRecs = nUpdatedRecs + 1
        REPLACE recid_smo WITH kms.recid
        REPLACE kms.dp WITH m.dp, kms.jt WITH m.jt, kms.status WITH 1, ;
         kms.operpv WITH m.operpv
        =IsDiffKms()

*        IF m.form=2
         m.new_recid = kms.recid
         =AppJpeg(m.recid_pv, m.new_recid)
*        ENDIF 

       ENDIF 

      ENDIF 

     ENDIF


   ENDCASE 
  
  ELSE                && Запись обработана ранее

   INSERT INTO errcur ;
    (pv, vs, enp, fam, im, ot, dr, cmnt);
     VALUES;
    (m.pnktvid, m.vs, m.enp, m.fam, m.im, m.ot, m.dr, 'Запись добавлена ранее')
   m.ffio = ALLTRIM(m.fam)+' '+ALLTRIM(m.im)+' '+ALLTRIM(m.ot)+', '+DTOC(m.dr)
   MESSAGEBOX(m.ffio+CHR(13)+CHR(10)+;
    'распознан как поданный ранее и не добавлен!'+CHR(13)+CHR(10)+;
    0+48,'Повторная подача!')
   nProceedBefore = nProceedBefore + 1

  ENDIF 
  
 ENDSCAN 

 USE 

 IF m.nProceedBefore == m.nProceed 
  MESSAGEBOX("Все "+ALLTRIM(STR(m.nProceed))+" представленные записи были обработаны ранее!",;
   0+48,"Внимание! Повторная обработка!")
 ELSE 
  MESSAGEBOX("Обработано "+STR(nProceed,5)+" записей."+CHR(13)+CHR(10)+;
   "Добавлено "+STR(nAddedRecs,5)+" записей."+CHR(13)+CHR(10)+;
   "Обновлено "+STR(nUpdatedRecs,5)+" записей."+CHR(13)+CHR(10),0+64, '')
 ENDIF 
 
 USE IN kms
 USE IN adr50
 USE IN adr77
 USE IN enp2
 USE IN permiss
 USE IN permis2
 USE IN osmo
 USE IN ofio
 USE IN odoc
 USE IN wrkpl
 USE IN jtt
* oApp.CloseAllTable()

 SELECT errcur
 COPY TO &pexpimp\&imperr
 IF RECCOUNT() > 0
  REPORT FORM &pbin\reports\repdbl PREVIEW  
 ENDIF 
 USE 

RETURN 

FUNCTION UpdIns
 PARAMETERS para1, para2 && 'enp', m.enp
 LOCAL tip, polis
 m.tip   = para1
 m.polis = m.para2 
 
 IF !EMPTY(m.tip)

  IF !SEEK(m.polis, 'kms', m.tip)
   nAddedRecs = nAddedRecs + 1
   RELEASE RecId, nz
   INSERT INTO kms FROM MEMVAR 
   m.new_recid = GETAUTOINCVALUE()
   REPLACE recid_smo WITH m.new_recid
  ELSE 
   m.new_recid = kms.recid
   nUpdatedRecs = nUpdatedRecs + 1
   REPLACE recid_smo WITH kms.recid
   REPLACE kms.dp WITH m.dp, kms.jt WITH m.jt,  kms.scn WITH m.scn, kms.status WITH 1, ;
    kms.operpv WITH m.operpv
  ENDIF 
 
 ELSE 
 
  nAddedRecs = nAddedRecs + 1
  RELEASE RecId, nz
  INSERT INTO kms FROM MEMVAR 
  m.new_recid = GETAUTOINCVALUE()
  REPLACE recid_smo WITH m.new_recid

 ENDIF 

RETURN m.new_recid

FUNCTION AppJpeg
 PARAMETERS para1, para2
 LOCAL m.recid_pv, m.new_recid
 m.recid_pv  = para1
 m.new_recid = para2

 m.f_file = 'f'+PADL(m.recid_pv,6,'0') && m.new_recid
 m.fn_file = 'f'+PADL(m.new_recid,6,'0') && m.new_recid
 IF fso.FileExists(pExpImp+'\'+m.f_file+'.jpg')
  IF fso.FileExists(m.lppath+'\jpeg\'+m.fn_file+'.jpg')
   fso.DeleteFile(m.lppath+'\jpeg\'+m.fn_file+'.jpg')
  ENDIF 
  fso.CopyFile(PExpImp+'\'+m.f_file+'.jpg', m.lppath+'\jpeg\'+m.fn_file+'.jpg')
 ENDIF 

 m.s_file = 's'+PADL(m.recid_pv,6,'0')
 m.sn_file = 's'+PADL(m.new_recid,6,'0') && m.new_recid
 IF fso.FileExists(pExpImp+'\'+m.s_file+'.jpg')
  IF fso.FileExists(m.lppath+'\jpeg\'+m.sn_file+'.jpg')
   fso.DeleteFile(m.lppath+'\jpeg\'+m.sn_file+'.jpg')
  ENDIF 
  fso.CopyFile(PExpImp+'\'+m.s_file+'.jpg', m.lppath+'\jpeg\'+m.sn_file+'.jpg')
 ENDIF 
RETURN 

FUNCTION IsDiffKms
 m.IsDifFound = .F.
 IF kms.p_doc != m.p_doc
  m.IsDifFound = .T.
  REPLACE kms.p_doc WITH m.p_doc
 ENDIF 
 IF kms.sn_card != m.sn_card
  m.IsDifFound = .T.
  REPLACE kms.sn_card WITH m.sn_card
 ENDIF 
 IF kms.vs != m.vs
  m.IsDifFound = .T.
  REPLACE kms.vs WITH m.vs
 ENDIF 
 IF kms.vs_data != m.vs_data
  m.IsDifFound = .T.
  REPLACE kms.vs_data WITH m.vs_data
 ENDIF 
 IF kms.enp != m.enp
  m.IsDifFound = .T.
  REPLACE kms.enp WITH m.enp
 ENDIF 
 IF kms.dp != m.dp
  m.IsDifFound = .T.
  REPLACE kms.dp WITH m.dp
 ENDIF 
 IF kms.dt != m.dt
  m.IsDifFound = .T.
  REPLACE kms.dt WITH m.dt
 ENDIF 
 IF kms.fam != m.fam
  m.IsDifFound = .T.
  REPLACE kms.fam WITH m.fam
 ENDIF 
 IF kms.d_type1 != m.d_type1
  m.IsDifFound = .T.
  REPLACE kms.d_type1 WITH m.d_type1
 ENDIF 
 IF kms.im != m.im
  m.IsDifFound = .T.
  REPLACE kms.im WITH m.im
 ENDIF 
 IF kms.d_type2 != m.d_type2
  m.IsDifFound = .T.
  REPLACE kms.d_type2 WITH m.d_type2
 ENDIF 
 IF kms.ot != m.ot
  m.IsDifFound = .T.
  REPLACE kms.ot WITH m.ot
 ENDIF 
 IF kms.d_type3 != m.d_type3
  m.IsDifFound = .T.
  REPLACE kms.d_type3 WITH m.d_type3
 ENDIF 
 IF kms.dr != m.dr
  m.IsDifFound = .T.
  REPLACE kms.dr WITH m.dr
 ENDIF 
 IF kms.true_dr != m.true_dr
  m.IsDifFound = .T.
  REPLACE kms.true_dr WITH m.true_dr
 ENDIF 
 IF kms.w != m.w
  m.IsDifFound = .T.
  REPLACE kms.w WITH m.w
 ENDIF 
 IF kms.jt != m.jt
  m.IsDifFound = .T.
  REPLACE kms.jt WITH m.jt
 ENDIF 
 IF kms.kl != m.kl
  m.IsDifFound = .T.
  REPLACE kms.kl WITH m.kl
 ENDIF 
 IF kms.cont != m.cont
  m.IsDifFound = .T.
  REPLACE kms.cont WITH m.cont
 ENDIF 
 IF kms.c_doc != m.c_doc
  m.IsDifFound = .T.
  REPLACE kms.c_doc WITH m.c_doc
 ENDIF 
 IF kms.s_doc != m.s_doc
  m.IsDifFound = .T.
  REPLACE kms.s_doc WITH m.s_doc
 ENDIF 
 IF kms.n_doc != m.n_doc
  m.IsDifFound = .T.
  REPLACE kms.n_doc WITH m.n_doc
 ENDIF 
 IF kms.d_doc != m.d_doc
  m.IsDifFound = .T.
  REPLACE kms.d_doc WITH m.d_doc
 ENDIF 
 IF kms.ss != m.ss
  m.IsDifFound = .T.
  REPLACE kms.ss WITH m.ss
 ENDIF 
 IF kms.dat_reg != m.dat_reg
  m.IsDifFound = .T.
  REPLACE kms.dat_reg WITH m.dat_reg
 ENDIF 
 IF kms.form != m.form
  m.IsDifFound = .T.
  REPLACE kms.form WITH m.form
 ENDIF 
 IF kms.predst != m.predst
  m.IsDifFound = .T.
  REPLACE kms.predst WITH m.predst
 ENDIF 
 IF kms.spos != m.spos
  m.IsDifFound = .T.
  REPLACE kms.spos WITH m.spos
 ENDIF 
 IF kms.d_type4 != m.d_type4
  m.IsDifFound = .T.
  REPLACE kms.d_type4 WITH m.d_type4
 ENDIF 
* IF kms.ogrn_old != m.ogrn_old
*  m.IsDifFound = .T.
*  REPLACE kms.ogrn_old WITH m.ogrn_old
* ENDIF 
* IF kms.okato_old != m.okato_old
*  m.IsDifFound = .T.
*  REPLACE kms.okato_old WITH m.okato_old
* ENDIF 
* IF kms.dp_old != m.dp_old
*  m.IsDifFound = .T.
*  REPLACE kms.dp_old WITH m.dp_old
* ENDIF 
 IF kms.podr_doc != m.podr_doc
  m.IsDifFound = .T.
  REPLACE kms.podr_doc WITH m.podr_doc
 ENDIF 
 IF kms.mr != m.mr
  m.IsDifFound = .T.
  REPLACE kms.mr WITH m.mr
 ENDIF 
 IF kms.comment != m.comment
  m.IsDifFound = .T.
  REPLACE kms.comment WITH m.comment
 ENDIF 
 IF kms.adr_id != m.adr_id
  m.IsDifFound = .T.
  REPLACE kms.adr_id WITH m.adr_id
 ENDIF 
 IF kms.adr50_id != m.adr50_id
  m.IsDifFound = .T.
  REPLACE kms.adr50_id WITH m.adr50_id
 ENDIF 
RETURN m.IsDifFound