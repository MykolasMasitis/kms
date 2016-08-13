FUNCTION Sverka5(tipd)

IF 3=2
PARAMETERS GrZ

GrZ= .f.
PUBLIC oldRec
oldRec = RECNO()

ddd = ADIR(rrr,pAisOms+'\'+User,'D')
IF ddd=0
 WAIT 'Отсутствует директория &pAisOms\&User!' WINDOW NOWAIT
 RETURN 0
ENDIF 

m.date_in  = DATE()
m.date_out = DATE()


tcOldAlias = ALIAS()

COPY FILE &PCommon\Zapros.dbf TO &PLocal\Zapros.dbf

USE &PLocal\Zapros IN 0 ALIAS Zapros SHARED 

SELECT (tcOldAlias)

IF this.IsFilt=.t. && Если установлен фильтр

 Flag = MESSAGEBOX("Вы хотите отправить групповой запрос (Да)"+CHR(13)+"или одиночный (Нет)?",4+48,"Внимание!")
 IF Flag == 6 && Запрос групповой

  GrZ = .t.

  Flag = MESSAGEBOX("Запрос по полису (Да)"+CHR(13)+"или по реквизитам (Нет)?",4+48,"Внимание!")
  IF Flag == 6

   SCAN 
    SCATTER MEMVAR 
    m.recid = PADL(m.recid,6,'0')
    m.fam   = CPCONVERT(1251,866, m.fam)
    m.im    = CPCONVERT(1251,866, m.im)
    m.ot    = CPCONVERT(1251,866, m.ot)
    m.s_pol = SUBSTR(m.sn_card, 1, AT(' ',m.sn_card)-1)
    m.s_pol = CPCONVERT(1251,866, m.s_pol)
    m.n_pol = INT(VAL(SUBSTR(m.sn_card, AT(' ',m.sn_card)+1)))
    m.dr    = DToS(m.dr)
    m.dom   = m.d
    INSERT INTO Zapros FROM MEMVAR 
   ENDSCAN 

  ELSE 

   SCAN 
    SCATTER MEMVAR 
    m.recid = PADL(m.recid,6,'0')
    m.fam   = CPCONVERT(1251,866, m.fam)
    m.im    = CPCONVERT(1251,866, m.im)
    m.ot    = CPCONVERT(1251,866, m.ot)
    m.s_pol = ''
    m.n_pol = 0
    m.dr    = DToS(m.dr)
    m.dom   = m.d
    INSERT INTO Zapros FROM MEMVAR 
   ENDSCAN 

  ENDIF 


 ELSE && Запрос одиночный

  Flag = MESSAGEBOX("Запрос по полису (Да)"+CHR(13)+"или по реквизитам (Нет)?",4+48,"Внимание!")
  IF Flag == 6

   SCATTER MEMVAR 
   m.recid = PADL(m.recid,6,'0')
   m.fam   = CPCONVERT(1251,866, m.fam)
   m.im    = CPCONVERT(1251,866, m.im)
   m.ot    = CPCONVERT(1251,866, m.ot)
   m.s_pol = SUBSTR(m.sn_card, 1, AT(' ',m.sn_card)-1)
   m.s_pol = CPCONVERT(1251,866, m.s_pol)
   m.n_pol = INT(VAL(SUBSTR(m.sn_card, AT(' ',m.sn_card)+1)))
   m.dr    = DToS(m.dr)
   m.dom   = m.d

  ELSE 

   SCATTER MEMVAR 
   m.recid = PADL(m.recid,6,'0')
   m.fam   = CPCONVERT(1251,866, m.fam)
   m.im    = CPCONVERT(1251,866, m.im)
   m.ot    = CPCONVERT(1251,866, m.ot)
   m.s_pol = ''
   m.n_pol = 0
   m.dr    = DToS(m.dr)
   m.dom   = m.d

  ENDIF 

  INSERT INTO Zapros FROM MEMVAR 

 ENDIF 

ELSE && Если фильтр не установлен 

 Flag = MESSAGEBOX("Запрос по полису (Да)"+CHR(13)+"или по реквизитам (Нет)?",4+48,"Внимание!")
 IF Flag == 6

  SCATTER MEMVAR 
  m.recid = PADL(m.recid,6,'0')
  m.fam   = CPCONVERT(1251,866, m.fam)
  m.im    = CPCONVERT(1251,866, m.im)
  m.ot    = CPCONVERT(1251,866, m.ot)
  m.s_pol = SUBSTR(m.sn_card, 1, AT(' ',m.sn_card)-1)
  m.s_pol = CPCONVERT(1251,866, m.s_pol)
  m.n_pol = INT(VAL(SUBSTR(m.sn_card, AT(' ',m.sn_card)+1)))
  m.dr    = DToS(m.dr)
  m.dom   = m.d

 ELSE 

  SCATTER MEMVAR 
   m.recid = PADL(m.recid,6,'0')
   m.fam   = CPCONVERT(1251,866, m.fam)
   m.im    = CPCONVERT(1251,866, m.im)
   m.ot    = CPCONVERT(1251,866, m.ot)
   m.s_pol = ''
   m.n_pol = 0
   m.dr    = DToS(m.dr)
   m.dom   = m.d

 ENDIF 

 INSERT INTO Zapros FROM MEMVAR 

ENDIF && Условие наличия/отсутствия фильтра

&& Формирование запроса окончено!
 
USE IN Zapros

ChVal  = Sys(3)
ID     = Allt(ChVal+'.'+Lower(User)+'@RUBY.MSK.OMS')
TFile  = Stuff(ChVal,1,1,'T')+'.'
BFile  = Stuff(ChVal,1,1,'B')+'.'
DFile  = Stuff(ChVal,1,1,'D')
EFile  = stuff(ChVal,1,1,'E')

Copy File &PLocal\Zapros.Dbf To &PBase\&pvid(1,1)\&User\OutPut\&DFile
Copy File &PLocal\Zapros.Dbf To &PAisOms\&User\OutPut\&DFile

poi = fcrea('&PAisOms\&User\OutPut\&TFile')
if poi != -1
 =fputs(poi,'To: erz@mgf.msk.oms')
 =fputs(poi,'Message-Id: &ID')
 =fputs(poi,'Subject: ERZ_sverka3')
 fzz = 'q_' + PADL(MONTH(DATE()),2,'0')+RIGHT(ALLTRIM(STR(YEAR(DATE()))),1)+'.dbf'
 =fputs(poi,'Attachment: &DFile &Fzz')
EndI
=fclos(poi)
 
COPY FILE &PAisOms\&User\OutPut\&TFile To ;
     &PBase\&pvid(1,1)\&User\OutPut\&BFile && Инициализируем посылку.
Rena &PAisOms\&User\OutPut\&TFile To ;
     &PAisOms\&User\OutPut\&BFile && Инициализируем посылку.

If SndWait(BFile, EFile, DFile, 0)
 Inse Into LoggFile ;
  (RecId, Drc, From, To, Dir, File, MesId, Subject, Date, Time, Confirm, Rslt) Valu ;
  (recc('LoggFile')+1, 'Send', User+'@RUBY.MSK.OMS', 'erz@mgf.msk.oms', User, BFile, Id, 'ERZ_sverka3', dtoc(date()), time(), '', .f.)
 Wait "Запрос успешно отправлен!" Wind Nowa
Else
 Retu
EndI

Push Key Clea
Set Escape On
On Escape Do StopScan2
Priv Fb

 StopIt = .t.
 Do While StopIt
  Wait "Ожидание ответа..." Wind Nowa
  Fb = ScanDir('&PAisOms\&User\InPut','b*.*','ERZ','&ID')
  If !Empty(Fb)
   poi = fopen('&PAisOms\&User\InPut\&Fb')
   if poi != -1
    y = ''
    =fseek(poi,0)
    do while !feof(poi)
     y=fgets(poi)
     if y = 'Attachment'
      Arg1 = allt(subs(y, at(':',y)+1,at(' ',y,2)-at(' ',y,1)))
      Arg2 = allt(subs(y, at(' ',y,2)+1))
     endi
    endd
    =fclos(poi)
    If !File('&PAisOms\&User\InPut\&Arg1') 
     Wait "Отсутствует или недоступен присоединенный файл!" Wind Nowa
     Exit
    else
     Wait "Обработка ответа..." Wind Nowa
     Copy File &PAisOms\&User\InPut\&Fb   To &PBase\&pvid(1,1)\&User\InPut\&Fb
     Copy File &PAisOms\&User\InPut\&Arg1 To &PBase\&pvid(1,1)\&User\InPut\&Arg1
     Copy File &PAisOms\&User\InPut\&Arg1 To &PLocal\Otvet.Dbf
     Dele File &PAisOms\&User\InPut\&Fb
     Dele File &PAisOms\&User\InPut\&Arg1
     OAL = ALia()
     Use &PLocal\Otvet In 0 Alia Otvet Excl
*     Sele (OAl)

     If GrZ=.t.
*      oldRec = RECNO("people")
*      MESSAGEBOX(STR(oldrec,10),0)
      Sele Otvet


      Inde On RecID To &PLocal\Otvet.Idx Comp
      Set Inde To &PLocal\Otvet
      Sele (OAl)
      SET RELATION TO PADL(recid,6,'0') INTO Otvet ADDITIVE 

	  THISFORM.LockScreen=.t.
	  
	  
      SCAN 
       IF !EMPTY(Otvet.RecId)
	    m.recid  = Otvet.RecId
	    m.data   = DATE()
	    m.sn_pol = TransPol(ALLTRIM(Otvet.s_pol) + ' ' + ALLTRIM(STR(Otvet.n_pol)))
	    m.s_pol  = Otvet.s_pol
	    m.n_pol  = Otvet.n_pol
	    m.q      = Otvet.q
	    m.fam    = IIF(VARTYPE(Otvet.Fam) == 'C', CPCONVERT(866,1251,Otvet.fam), '')
	    m.im     = IIF(VARTYPE(Otvet.Im) == 'C', CPCONVERT(866,1251,Otvet.im), '')
	    m.ot     = IIF(VARTYPE(Otvet.Ot) == 'C', CPCONVERT(866,1251,Otvet.ot), '')
	    m.dr     = IIF(VARTYPE(Otvet.Dr) == 'D', Otvet.dr, '')
	    m.w      = IIF(VARTYPE(Otvet.W) == 'N', Otvet.w, 0)
	    m.ul     = IIF(VARTYPE(Otvet.Ul) == 'N', Otvet.ul, 0)
	    m.dom    = IIF(VARTYPE(Otvet.Dom) == 'C', CPCONVERT(866,1251,Otvet.dom), '')
	    m.kor    = IIF(VARTYPE(Otvet.Kor) == 'C', CPCONVERT(866,1251,Otvet.kor), '')
	    m.str    = IIF(VARTYPE(Otvet.Str) == 'C', CPCONVERT(866,1251,Otvet.str), '')
	    m.kv     = IIF(VARTYPE(Otvet.Kv) == 'C', CPCONVERT(866,1251,Otvet.kv), '')
	    m.ans_r  = Otvet.ans_r
        IF RLOCK()
         INSERT INTO Answers FROM MEMVAR 
         UNLOCK 
        EndI
       EndI
      ENDSCAN 
       
	  This.Refresh
	  GO (oldRec)
	  thisform.Refresh
	  thisform.LockScreen=.f.

      SET RELATION OFF INTO Otvet
      SELECT Otvet
      SET INDEX TO 
      DELETE FILE &PLocal\Otvet.Idx
      USE 
      SELECT (OAL)
*      GO (oldRec)
      Wait Clea
      Wait "Ответ на Запрос обработан!" Wind Nowa
     Else


      m.recid  = Otvet.RecId
	  m.data   = DATE()
	  m.sn_pol = TransPol(ALLTRIM(Otvet.s_pol) + ' ' + ALLTRIM(STR(Otvet.n_pol)))
	  m.s_pol  = Otvet.s_pol
	  m.n_pol  = Otvet.n_pol
	  m.q      = Otvet.q
	  m.fam    = IIF(VARTYPE(Otvet.Fam) == 'C', CPCONVERT(866,1251,Otvet.fam), '')
	  m.im     = IIF(VARTYPE(Otvet.Im) == 'C', CPCONVERT(866,1251,Otvet.im), '')
	  m.ot     = IIF(VARTYPE(Otvet.Ot) == 'C', CPCONVERT(866,1251,Otvet.ot), '')
	  m.dr     = IIF(VARTYPE(Otvet.Dr) == 'D', Otvet.dr, '')
	  m.w      = IIF(VARTYPE(Otvet.W) == 'N', Otvet.w, 0)
	  m.ul     = IIF(VARTYPE(Otvet.Ul) == 'N', Otvet.ul, 0)
	  m.dom    = IIF(VARTYPE(Otvet.Dom) == 'C', CPCONVERT(866,1251,Otvet.dom), '')
	  m.kor    = IIF(VARTYPE(Otvet.Kor) == 'C', CPCONVERT(866,1251,Otvet.kor), '')
	  m.str    = IIF(VARTYPE(Otvet.Str) == 'C', CPCONVERT(866,1251,Otvet.str), '')
	  m.kv     = IIF(VARTYPE(Otvet.Kv) == 'C', CPCONVERT(866,1251,Otvet.kv), '')
	  m.ans_r  = Otvet.ans_r
      
      INSERT INTO Answers FROM MEMVAR 

      USE IN Otvet 
      WAIT CLEAR 
*      WAIT "Ответ на Запрос к ЕРЗ получен!"+CHR(13)+;
       "Полис: "+sn_erz WINDOW NOWAIT 
       WAIT CLEAR 
      ThisForm.Refresh 
     EndI
     Exit
*     repl confirm with Fb
    endi
   else
    wait "Невозможно открыть файл-паспорт!" wind
   endi
  Else
  EndI

  Fr = ScanDir('&PAisOms\&User\InPut','r*.*','ERZ','&Id')
  If !empty(Fr)
   wait "Получено сообщение КС о невозможности доставки ИП!" wind nowa
   poi = fopen('&PAisOms\&User\InPut\&Fr')
   if poi != -1
    y = ''
    =fseek(poi,0)
    do while !feof(poi)
     y=fgets(poi)
     if y = 'BodyPart'
      Arg1 = allt(subs(y, at(':',y)+1))
      Arg2 = Arg1
     endi
    endd
    =fclos(poi)
    If !File('&PAisOms\&User\InPut\&Arg1') 
     Wait "Отсутствует или недоступен файл "+&Arg1+" !" Wind Nowa
    else
     copy file &PAisOms\&User\InPut\&Fr to &PBase\lp(1,1)\&User\InPut\&Fr
     copy file &PAisOms\&User\InPut\&Arg1 to &PBase\lp(1,1)\&User\InPut\&Arg1
     dele file &PAisOms\&User\InPut\&Fr
     dele file &PAisOms\&User\InPut\&Arg1
     Exit
*     repl confirm with Fr
    endi
   else
    wait "Невозможно открыть файл-паспорт!" wind
   endi
  Else
  EndI

 EndD
 
 On Escape
 Set Escape Off
 Pop Key
ENDIF 
RETURN 