PROCEDURE AllExpert
 FOR num_pv=1 TO kol_pv
  WAIT "Анализ состояния регистра ПВ "+pvid(num_pv,1)+"..." WINDOW NOWAIT 

  WinFoot = Allt(pvid(num_pv,2))
  DEFINE WINDOW ExpReg AT 0,0 SIZE 47,113 TITLE ' Анализ состояния регистра ПВ &WinFoot ' ;
   FOOTER ' Ctrl+P-Печать Esc-выход ' IN SCREEN DOUBLE CLOSE FLOAT GROW MINIMIZE ZOOM ;
   COLOR SCHEME 4 FONT "Courier",12

  SET TEXTMERGE TO &PLocal\ExpReg SHOW 
  SET TALK ON 
  ACTIVATE WINDOW ExpReg

  USE &pBase\&pvid(num_pv,1)\kms IN 0 ALIAS kms SHARED ORDER sn_card
  USE &PCommon\Im1 IN 0 ALIAS mIm ORDER im SHARED 
  USE &PCommon\Im2 IN 0 ALIAS wIm ORDER im SHARED 
  SELECT kms
  GO TOP 

  \1. Проверка корректности заполнения полей Фамилия, Имя, Отчество, Пол, Дата рождения.
  \

  kkk = .f.
  SCAN

  IF  LEN(ALLTRIM(Im)) <= 1 ;
   OR (SEEK(Im, 'mIm') AND INLIST(RIGHT(PADL(ALLTRIM(ot),20),2),'на','зы')) ;
   OR (SEEK(Im, 'wIm') AND INLIST(RIGHT(PADL(ALLTRIM(ot),20),2),'ич','лы'))
   IF kkk = .f.
    \
    \ Полис Фамилия Имя Отчество Пол
    kkk = .t.
   ENDIF 
   \<<sn_card>> <<padr(allt(fam)+' '+allt(im)+' '+allt(ot),47)>> <<iif(w=1,'Муж','Жен')>> <<DTOC(dr)>> E5
  ENDIF 

  If (!InList(Righ(PadL(Allt(ot),20),2),'ан','ич','на','лы','зы','  ') Or ;
     (InList(Righ(PadL(Allt(fam),25),2),'ва','на','ая') And InList(Righ(PadL(Allt(ot),20),2),'ич','лы')) Or ;
     (InList(Righ(PadL(Allt(fam),25),2),'ов','ев','ин') And InList(Righ(PadL(Allt(ot),20),2),'на','зы')))
   IF kkk = .f.
    \
    \ Полис Фамилия Имя Отчество Пол
    kkk = .t.
   ENDIF 
   \<<sn_card>> <<padr(allt(fam)+' '+allt(im)+' '+allt(ot),47)>> <<iif(w=1,'Муж','Жен')>> <<DTOC(dr)>> E6
  EndI

  If (InList(Righ(PadL(Allt(fam),25),2),'ва','на','ая') And InList(Righ(PadL(Allt(ot),20),2),'на','зы') And w!=2) Or ;
     (InList(Righ(PadL(Allt(fam),25),2),'ов','ев','ин') And InList(Righ(PadL(Allt(ot),20),2),'ич','лы') And w!=1)
   IF kkk = .f.
    \
    \ Полис Фамилия Имя Отчество Пол
    kkk = .t.
   ENDIF 
   \<<sn_card>> <<padr(allt(fam)+' '+allt(im)+' '+allt(ot),47)>> <<iif(w=1,'Муж','Жен')>> <<DTOC(dr)>> E7
  EndI

  If Empty(Dr) Or (gdCurDat2-Dr)/365.25>130 Or Dr > gdCurDat2
   IF kkk = .f.
    \
    \ Полис Фамилия Имя Отчество Пол
    kkk = .t.
   ENDIF 
   \<<sn_card>> <<padr(allt(fam)+' '+allt(im)+' '+allt(ot),47)>> <<iif(w=1,'Муж','Жен')>> <<DTOC(dr)>> E8
  EndI

  ENDSCAN 

  IF kkk==.f.
   \   Ошибок не обнаружено!
  ENDIF 

  

  DEACTIVATE WINDOW ExpReg
  SET TEXTMERGE TO 
  SET TEXTMERGE NOSHOW 

  TxFile = PLocal+'\ExpReg.txt'

  IF kol_pv == 1
   COPY FILE &TxFile TO &PLocal\temp.txt
   ON KEY LABEL Ctrl+P COPY FILE &PLocal\temp.txt TO PRN
   KEYBOARD [{Ctrl+End}]
   MODIFY COMMAND &TxFile WINDOW ExpReg NOEDIT 
   ON KEY LABEL Ctrl+P
   DELETE FILE &PLocal\temp.txt
  ENDIF 

  oApp.CloseAllTable()
  WAIT CLEAR 
 ENDFOR 

RETURN 