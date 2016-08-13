PROCEDURE TFile2Kms
	LOCAL m.nFormatType, m.cZayavka
	m.nFormatType = 0
	m.cZayavka = ""

	CREATE TABLE &PBase\&pvid(1,1)\te2kms FREE ;
		(tfilename c(13), tfilenrec n(10), processed n(10), efilename c(13), efilenrec n(10), isrelated l, nrelated n(10))

	m.StartPath = STRTRAN(UPPER(m.PBin), '\BIN', '')
	tcDir = GETDIR('&StartPath', 'Выберите директорию','')
	SET DEFAULT TO (tcDir)
	SET TABLEVALIDATE TO 0
	
	USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms SHARED
	USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms2 SHARED ORDER sn_card AGAIN 

	PFile = SYS(2000, tcDir+'\'+'tp2??????.dbf')

	If !EMPTY(PFile)
		=AppTFile(PFile)
	ELSE 
		WAIT  "Нет ни одного t-файла, нечего обрабатывать!" Wind Nowa
		oApp.CloseAllTable()
		RETURN 
	ENDIF 
	
	WAIT "ОБРАБОТКА, ЖДИТЕ..." WINDOW NOWAIT 	

	PFile = SYS(2000, tcDir+'\'+'tp2??????.dbf',1)
	DO WHILE !EMPTY(PFile)
		=AppTFile(PFile)
		PFile = SYS(2000, tcDir+'\'+'tp2??????.dbf',1)
	ENDDO   

	oApp.CloseAllTable()
	WAIT CLEAR 

RETURN 
	
FUNCTION AppTFile	
	PARAMETERS TFile
	LOCAL IsEFileExists, EFileNRec, IsRelated, HowManyRelated, HowManyProcessed
	IsEFileExists = .f.
	EFileNRec = 0
	IsRelated = .f.
	HowManyRelated = 0
	HowManyProcessed = 0
	
	m.cZayavka = SUBSTR(TFile, RAT('\',TFile)+7, 3)

	EFile = 'etp2'+m.cZayavka+'.dbf'
	IF FILE('&EFile')
		IsEFileExists = .t.
	ELSE 
		IsEFileExists = .f.
	ENDIF 

	DO CASE 
		CASE UPPER(SUBSTR(TFile, RAT('\',TFile)+1, 3)) != 'T' + qcod
			MESSAGEBOX('Это не файл-заявка КМС!',0+48,'Внимание!')
			RETURN 
*		CASE SUBSTR(TFile, RAT('\',TFile)+4, 3) != pvid(1,1)
*			MESSAGEBOX('Другой пункт выдачи!',0+48,'Внимание!')
*			RETURN 
	ENDCASE 
	
	DO cpzero.prg WITH "&TFile", 866

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
	
	COUNT FOR INLIST(jt,'5','d','f','k','n','r','t','u','v') TO m.nOneFileRecCount
	IF m.nOneFileRecCount == 0
		USE 
		RETURN 
	ENDIF 

	IF IsEFileExists==.t.
		USE (EFile) IN 0 ALIAS EFile EXCLUSIVE 
		SELECT EFile
		IF m.nFormatType = 1
*			COUNT FOR LEFT(sn,3) == pvid(1,1) TO m.efilenrec 
			INDEX ON sn TAG sn
			SET ORDER TO sn
			SELECT TFile
			SET RELATION TO sn INTO EFile 
*			COUNT FOR !EMPTY(EFile.sn) TO m.HowManyRelated
			IF m.efilenrec != m.HowManyRelated && Неполная/отсутсвует связка, рвем связь!
				SET RELATION OFF INTO EFile
				SELECT EFile
				SET ORDER TO 
				DELETE TAG ALL 
				USE 
				SELECT TFile
				IsEFileExists = .f.	
				m.IsRelated = .f.	
			ELSE 
				m.IsRelated = .t.	
			ENDIF 
		ELSE
*			m.efilenrec = RECCOUNT()
			INDEX ON rec_id TAG rec_id
			SET ORDER TO rec_id
			SELECT TFile
			SET RELATION TO recid INTO EFile
*			COUNT FOR !EMPTY(EFile.rec_id) TO m.HowManyRelated
			IF m.efilenrec != m.HowManyRelated && Неполная/отсутствует связка, рвем связь!
				SET RELATION OFF INTO EFile
				SELECT EFile
				SET ORDER TO 
				DELETE TAG ALL 
				USE 
				SELECT TFile
				IsEFileExists = .f.		
				m.IsRelated = .f.	
			ELSE 
				m.IsRelated = .t.	
			ENDIF
		ENDIF  
	ELSE 
	ENDIF 
	
	SELECT TFile
	SCAN
		m.polis = TransPol(s_card+" "+ALLTRIM(STR(n_card)))
		IF SEEK(m.polis, 'kms2') AND IIF(USED(EFile), EMPTY(EFile.sn), 1==1)
			IF INLIST(jt,'5','d','f','k','n','r','t','u','v')
				m.jt = jt
				m.dp = dp
				IF VARTYPE(old_fam) == 'C'
					m.sn_pasp = old_fam
				ELSE
					m.sn_pasp = ""
				ENDIF 
				IF VARTYPE(dat_iskl)=='D'
					m.dat_iskl = dat_iskl
				ELSE 
					m.dat_iskl = {}
				ENDIF 
				IF VARTYPE(nomdiskl)== 'C'
					m.nomdiskl = nomdiskl
				ELSE
					m.nomdiskl = ""
				ENDIF 
				IF VARTYPE(datdiskl)=='D'
					m.datdiskl = datdiskl
				ELSE
					m.datdiskl = {}
				ENDIF 
				DO CASE 
					CASE m.jt == '0' AND IsPolis94(m.polis)
						m.jt = '1'
					CASE m.jt == '6'
						m.jt = 'b'
					OTHERWISE 
				ENDCASE 
				IF m.nFormatType = 1 && Старый формат
					m.dp = CTOD(SUBSTR(m.dp,7,2)+'.'+SUBSTR(m.dp,5,2)+'.'+SUBSTR(m.dp,1,4))
				ENDIF 
				SELECT kms2
				IF EMPTY(jt0) AND IIF(USED(EFile), EMPTY(EFile.sn), 1==1)
*					REPLACE jt0 WITH jt, dp0 WITH dp
*					REPLACE dp WITH m.dp, jt WITH m.jt, nz0 WITH m.cZayavka
					REPLACE dp WITH m.dp, jt WITH m.jt
					REPLACE dat_iskl WITH m.dat_iskl, nomdiskl WITH m.nomdiskl, datdiskl WITH m.datdiskl,;
					 sn_pasp WITH m.sn_pasp
					HowManyProcessed = HowManyProcessed+1
				ENDIF 
				SELECT TFile
			ENDIF 
		ENDIF 
	ENDSCAN 

	IF IsEFileExists == .t.
		SET RELATION OFF INTO EFile
		SELECT EFile
		SET ORDER TO 
		DELETE TAG ALL 
		USE 
		SELECT TFile
		IsEFileExists = .f.		
	ENDIF 
	
	USE 

	INSERT INTO te2kms (tfilename, tfilenrec, processed, efilename, efilenrec, isrelated, nrelated) VALUES;
		(UPPER(m.tfile),m.nOneFileRecCount,m.HowManyProcessed, UPPER(m.efile), m.efilenrec, m.IsRelated, m.HowManyRelated)

RETURN 