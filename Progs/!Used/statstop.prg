PROCEDURE StatStop
 IF MESSAGEBOX('ÑÔÎÌÈÐÎÂÀÒÜ ÑÒÀÒÈÑÒÈÊÓ ÏÎ ÑÒÎÏ-ËÈÑÒÓ?'+CHR(13)+CHR(10),4+32,'')=7
  RETURN 
 ENDIF 
 IF !fso.FileExists(pcommon+'\StopList.dbf')
  MESSAGEBOX('ÎÒÑÓÒÑÒÂÓÅÒ ÔÀÉË STOPLIST.DBF!'+CHR(13)+CHR(10),0+16,'')
  RETURN 
 ENDIF 
 IF OpenFile(pcommon+'\StopList', 'StopL', 'shar')>0
  IF USED('StopL')
   USE IN StopL
  ENDIF 
  RETURN 
 ENDIF 
 IF OpenFile(pcommon+'\jt', 'jt', 'shar', 'jt')>0
  IF USED('StopL')
   USE IN StopL
  ENDIF 
  IF USED('Jt')
   USE IN Jt
  ENDIF 
  RETURN 
 ENDIF 
 
 m.t_dat1 = DATE()
 m.t_dat2 = m.t_dat1
 
 DO FORM TuneDat
 
 SELECT * FROM StopL WHERE q=m.qcod AND BETWEEN(date_end,m.t_dat1,m.t_dat2) ;
  INTO CURSOR curstop
 USE IN StopL
  
 IF _tally=0
  MESSAGEBOX('ÇÀ ÂÛÁÐÀÍÍÛÉ ÈÍÒÅÐÂÀË ÇÀÏÈÑÅÉ ÍÅÒ!'+CHR(13)+CHR(10),0+64,'')
  USE IN curstop
  RETURN 
 ELSE 
*  MESSAGEBOX('ÎÒÎÁÐÀÍÎ '+ALLTRIM(STR(_tally))+' ÇÀÏÈÑÅÉ'+CHR(13)+CHR(10),0+64,'')
 ENDIF 

 SELECT jt AS jt, COUNT(*) AS cnt FROM curstop GROUP BY jt ORDER BY jt INTO CURSOR curjt
 
 SELECT ist as ist, jt as jt, COUNT(*) as cnt FROM curstop GROUP BY ist, jt ORDER BY ist, jt ;
  INTO CURSOR curist
  
 SELECT qz as qz, jt as jt, COUNT(*) as cnt FROM curstop GROUP BY qz, jt ORDER BY qz, jt ;
  INTO CURSOR curqz
 
 SELECT curjt
 m.totcnt = RECCOUNT('curjt')
 SET RELATION TO jt INTO jt 
 IF RECCOUNT()>0
  REPORT FORM curjt PREVIEW 
 ENDIF 
 SET RELATION OFF INTO jt
 USE 
 
 SELECT curist
 SET RELATION TO jt INTO jt 
 IF RECCOUNT()>0
  REPORT FORM curist PREVIEW 
 ENDIF 
 SET RELATION OFF INTO jt
 USE
 
 SELECT curqz
 SET RELATION TO jt INTO jt 
 IF RECCOUNT()>0
  REPORT FORM curqz PREVIEW 
 ENDIF 
 SET RELATION OFF INTO jt
 USE 

 USE IN curstop
 USE IN Jt
 
RETURN 