PROCEDURE CheckTFE
	LOCAL m.nFormatType, m.cZayavka
	m.nFormatType = 0
	m.cZayavka = ""

	CREATE TABLE &PBase\&pvid(1,1)\checktfe FREE ;
		(tname c(13), tnrec n(10), dbls_id n(10), dbls_pol n(10), fname c(13), fnrec n(10), tfrelated n(10), ename c(13), enrec n(10), terelated n(10))

	m.StartPath = STRTRAN(UPPER(m.PBin), '\BIN', '')
	tcDir = GETDIR('&StartPath', 'Выберите директорию','')
	SET DEFAULT TO (tcDir)
	SET TABLEVALIDATE TO 0
	
	TFile = SYS(2000, tcDir+'\'+'tp2??????.dbf')

	If !EMPTY(TFile)
		=AppTFile(TFile)
	ELSE 
		WAIT  "Нет ни одного t-файла, нечего обрабатывать!" Wind Nowa
		oApp.CloseAllTable()
		RETURN 
	ENDIF 
	
	WAIT "ОБРАБОТКА, ЖДИТЕ..." WINDOW NOWAIT 	

	TFile = SYS(2000, tcDir+'\'+'tp2??????.dbf',1)
	DO WHILE !EMPTY(TFile)
		=AppTFile(TFile)
		TFile = SYS(2000, tcDir+'\'+'tp2??????.dbf',1)
	ENDDO   

	oApp.CloseAllTable()
	WAIT CLEAR 

RETURN 
	
FUNCTION AppTFile	
	PARAMETERS TFile
	LOCAL IsEFileExists, ENRec, IsFFileExists, FNRec, TFRelated, TERelated, dbls
	IsEFileExists = .f.
	IsFFileExists = .f.
	ENRec = 0
	FNRec = 0
	TFRelated = 0
	TERelated = 0
	dbls = 0
	
	m.cZayavka = SUBSTR(TFile, RAT('\',TFile)+7, 3)

	FFile = 'f'+SUBSTR(TFile,2)
	IF FILE('&FFile')
		IsFFileExists = .t.
	ELSE 
		IsFFileExists = .f.
	ENDIF 

	EFile = 'etp2'+m.cZayavka+'.dbf'
	IF FILE('&EFile')
		IsEFileExists = .t.
	ELSE 
		IsEFileExists = .f.
	ENDIF 
	
*	DO cpzero.prg WITH "&TFile", 866
*	DO cpzero.prg WITH "&FFile", 866
*	DO cpzero.prg WITH "&EFile", 866

	USE (TFile) IN 0 ALIAS TFile EXCLUSIVE 
	SELECT TFile

	DO CASE 
		CASE VARTYPE(sn) == 'C' AND VARTYPE(recid) == 'U' && Старый формат!
			m.nFormatType = 1
		CASE VARTYPE(sn) == 'U' AND VARTYPE(recid) == 'C' && Новый формат!
			m.nFormatType = 2
		CASE VARTYPE(sn) == 'U' AND VARTYPE(recid) == 'U' && Неизвестный формат!
			USE 
			RETURN 
	ENDCASE 

	IF m.nFormatType == 1
	 SELECT * FROM TFile WHERE sn IN ;
	  (SELECT sn FROM tfile GROUP BY sn HAVING coun(*)>1) ORDER BY sn INTO CURSOR curdbl
	ELSE 
	 SELECT * FROM TFile WHERE recid IN ;
	  (SELECT recid FROM tfile GROUP BY recid HAVING coun(*)>1) ORDER BY recid INTO CURSOR curdbl
	ENDIF 
	SELECT * FROM TFile WHERE n_card IN ;
     (SELECT n_card FROM tfile GROUP BY n_card HAVING coun(*)>1) ORDER BY n_card INTO CURSOR curdbl_pol

	m.dbls_id = RECCOUNT('curdbl')
	m.dbls_pol = RECCOUNT('curdbl_pol')
*	USE IN curdbl
	USE IN curdbl_pol
	SELECT curdbl
	IF m.nFormatType == 1
	 INDEX ON sn TO &PLocal\sn UNIQUE 
*	 SET INDEX TO &PLocal\sn
 	 SELECT TFile
 	 SET RELATION TO sn INTO curdbl
	ELSE
	 INDEX ON recid TO &PLocal\recid UNIQUE 
*	 SET INDEX TO &PLocal\recid
	 SELECT TFile
	 SET RELATION TO recid INTO curdbl
	ENDIF 
	
*	COUNT FOR !INLIST(jt,'5','d','f','k','n','r','t','u','v') TO m.nPervInTFile
    
    m.tnrec = RECCOUNT()

	IF IsFFileExists==.t.
		USE (FFile) IN 0 ALIAS FFile EXCLUSIVE 
		SELECT FFile
		IF m.nFormatType = 1
			m.fnrec = RECCOUNT('ffile')
*			COUNT FOR LEFT(sn,3) == pvid(1,1) TO m.fnrec 
			INDEX ON sn TAG sn
			SET ORDER TO sn
			SELECT TFile
			SET RELATION TO sn INTO FFile ADDITIVE 
			COUNT FOR !EMPTY(FFile.sn) AND EMPTY(curdbl.sn) TO m.TFRelated
		ELSE
			m.fnrec = RECCOUNT('ffile')
			INDEX ON rec_id TAG rec_id
			SET ORDER TO rec_id
			SELECT TFile
			SET RELATION TO recid INTO FFile ADDITIVE 
			COUNT FOR !EMPTY(FFile.rec_id) AND EMPTY(curdbl.recid) TO m.TFRelated
		ENDIF  
	ENDIF 

	IF IsEFileExists==.t.
		USE (EFile) IN 0 ALIAS EFile EXCLUSIVE 
		SELECT EFile
		IF m.nFormatType = 1
			m.enrec = RECCOUNT('efile')
*			COUNT FOR LEFT(sn,3) == pvid(1,1) TO m.enrec 
			INDEX ON sn TAG sn
			SET ORDER TO sn
			SELECT TFile
			SET RELATION TO sn INTO EFile ADDITIVE 
			COUNT FOR !EMPTY(EFile.sn) AND EMPTY(curdbl.sn) TO m.TERelated
		ELSE
			m.enrec = RECCOUNT()
			INDEX ON rec_id TAG rec_id
			SET ORDER TO rec_id
			SELECT TFile
			SET RELATION TO recid INTO EFile ADDITIVE 
			COUNT FOR !EMPTY(EFile.rec_id) AND EMPTY(curdbl.recid) TO m.TERelated
		ENDIF  
	ENDIF 
	
	IF IsFFileExists == .t.
		SET RELATION OFF INTO FFile
		SELECT FFile
		SET ORDER TO 
		DELETE TAG ALL 
		USE 
		SELECT TFile
	ENDIF 

	IF IsEFileExists == .t.
		SET RELATION OFF INTO EFile
		SELECT EFile
		SET ORDER TO 
		DELETE TAG ALL 
		USE 
		SELECT TFile
	ENDIF 
	
	USE IN curdbl
	
	USE 

	INSERT INTO checktfe (tname, tnrec, dbls_id, dbls_pol, fname, fnrec, ename, enrec, tfrelated, terelated) VALUES;
		(UPPER(m.tfile), m.tnrec, m.dbls_id, m.dbls_pol, UPPER(m.ffile), m.fnrec, UPPER(m.efile), m.enrec, m.TFRelated, m.TERelated)

RETURN 