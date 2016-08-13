#DEFINE MB_ICONSTOP 16
#DEFINE MB_ICONEXCLAMATION 16
#DEFINE MSG_ERROR "������!"
#DEFINE MSG_WARNING "��������������!"
#DEFINE ERR_VAR "ERR_VAR"
#DEFINE ERR_ALIAS "ERR_ALIAS"
#DEFINE ERR_EOF "ERR_EOF"
#DEFINE ERR_SETVAL "ERR_SETVAL"
#DEFINE CR CHR(13)

FUNCTION UnikAlias
		LOCAL lc
		lc = SUBSTR(SYS(2015),3)
		IF !ISALPHA(SUBSTR(m.lc,1,1))
			lc = "A" + SUBSTR(m.lc,2)
		ENDIF
		RETURN m.lc
ENDFUNC

*************************************************************************
* FUNCTION SaveAlias													*
* ��������� ���������� ��������� � ����������������� �������			*
* � ������ ������ �������� ��������� �� ������							*
* tcAlias - ��� ������� �������											*
* tlAll	  - .t. - ���������� ���� ���������, ����� -  ��� ���. ������	*
* tlOver  - ��������� ���������� ������ ��������� ������ ������������� 	*
*			(�� ��������� - .t. )										*
*************************************************************************
FUNCTION SaveAlias
LPARAMETERS tcAlias, tlAll, tlOver
	IF PCOUNT()<3
		m.tlOver = .t.
	ENDIF
	IF !TABLEUPDATE( m.tlAll, m.tlOver, m.tcAlias )
		local laerr(1,5), k
		k = aerror(laerr)
		MessageBox([������ ��� ���������� "] + m.tcAlias + ["] +CR+;
					"CODE: " + str(laerr(1,1))+CR+;
					laerr(1,2), MB_ICONSTOP, MSG_ERROR )
		RETURN .F.
	ENDIF
	RETURN .t.
ENDFUNC

*************************************************************************
* FUNCTION MyUse														*
* �������� ������� � ��������� ������ � ����� ������� �������			*
* tcTable	- ��� ����� �������											*
* tcAlias	- �����, ����������� ����������� ��������, ���� ������		*
*			  �������� ������, ����������� �������� ����� �����			*
* tcOpt		- ����� ������� USE (SHARED, EXCL, NOUPDATE...)
* ����������: .T. - ������� �������, .F. - ������						*
* ���� ��������� ����� ����������, �� ���������� ������������ � ���.���.*
*************************************************************************
FUNCTION MyUse
LPARAMETERS tcTable, tcAlias, tcOpt, tnBuffering, tcOpenList
	LOCAL ok, oErr, llSave
	llSave = PCOUNT()>4
	IF TYPE('m.tcTable')!="C"
		RETURN .F.
	ENDIF
	IF TYPE('m.tcAlias')!="C"
		tcAlias = juststem(m.tcTable)
	ENDIF
	IF TYPE('m.tcOpt')!="C"
		m.tcOpt = ""
	ENDIF
	tcAlias = UPPER( m.tcAlias)
	tcOpenList = ""
	ok = .T.
	IF USED( m.tcAlias )
		SELE (tcAlias)
	ELSE
		LOCAL la1(1,1), la2(1,1), n1, n2
		IF m.llSave
			n1 = AUSED( la1 )
		ENDIF
		SELE 0
		oErr = ON("ERROR")
		ON ERROR ok = .F.
		USE (tcTable) ALIAS (tcAlias) &tcOpt
		ON ERROR &oErr
		IF !m.ok &&AND ( TYPE("m.glDebug")!="L" OR m.glDebug )
			ShowError( [���������� ������� ������� "] + m.tcTable + [".]  )
		ENDIF
		IF m.llSave
			n2 = AUSED( la2 )
			LOCAL i
			FOR i=1 TO m.n2
				IF ASCAN( la1, la2( m.i,1 ) ) =0 AND la2( m.i,1 )!=m.tcAlias
					tcOpenList = m.tcOpenList + IIF( EMPTY(m.tcOpenList), '', ',' )+;
								 la2( m.i, 1 )
				ENDIF
			ENDFOR
		ENDIF
	ENDIF
	IF TYPE( "m.tnBuffering" ) = "N" AND m.ok
		IF m.tnBuffering>=0
			CURSORSETPROP( "BUFFERING", m.tnBuffering )
		ENDIF
	ENDIF
	RETURN m.ok
ENDFUNC
FUNCTION CloseAlias
LPARAMETERS m.tc
	IF !USED( m.tc )
		return
	ENDIF
	IF CURSORGETPROP( "BUFFERING", m.tc )>1
*		IF GetNextModified( 0, m.tc )!=0
			TABLEREVERT(.t., m.tc)
*		ENDIF
	ENDIF
	USE IN m.tc
ENDFUNC

*************************************************************************
* FUNCTION GetRecState													*
* �������� ������� ��������� � ������� ������          					*
* ���������� �������� ��������                                         	*
*	1 - ������ �� ����������											*
*	2 - ���� ��� ����-�� ����� ����������, ��� �������� ������ �������� *
*	3 - ���� � ������ �������� �� ���������� ��� ����� ������			*
*	4 - ���� ��������� � ����� ������									*
* tAlias - ����� ���. ���. ��� ��� ������								*
* ��������: � ������� �� ����������� �-�� GETFLDSTATE ������ �-��       *
* ���������� ������ (OLDVAL()) � ����� �������� �����, ���� �-��		*
* GetFldState ���������� 2 ��� 4, �� ��� �������� ��������� ����������	*
* �������������� �������������� ������� ���� � ��������� 1 ��� 3 �����. *
*************************************************************************
FUNCTION GetRecState
LPARAMETERS tAlias
	if !INLIST( TYPE("m.tAlias"), 'N', 'C' )
		m.tAlias = alias()
	endif
	LOCAL lnRecState, i, lnOldArea, lnFldState, lnFldName
	lnOldArea  = SELECT(0)
	SELECT (m.tAlias)
	lnRecState = GETFLDSTATE( 0 )
	FOR I=1 TO FCOUNT()
		lnFldName = FIELD( m.i )
		lnFldState = GETFLDSTATE( m.I )
		IF m.lnFldState!=1 AND m.lnFldState!=3
			IF EVAL( m.lnFldName ) = OLDVAL( m.lnFldName )
				SETFLDSTATE( m.i, m.lnFldState - 1 )
			ELSE
				m.lnRecState = m.lnFldState
			ENDIF
		ENDIF
	ENDFOR
	SELECT (m.lnOldArea)
	RETURN m.lnRecState

*============= ������� �������������� �����, ������� � ����� ============

*************************************************************************
* FUNCTION FirstWord													*
* ���������� ������ ����� �� ������ ����, ����������� ��������� ��������*
* @tcString	- �����������												*
* tcShare	- �����������												*
* ��������: ����� ��������� ����� �������� ������ ���������, 			*
* ���� ������ �������� ���������� �� ������								*
*************************************************************************
FUNCTION FirstWord(tcString,tcShare)
		LOCAL lnPos,lcFWord
		IF TYPE('tcShare')!="C"
			tcShare = ','
		ENDIF
		lnPos = AT(tcShare,tcString)
		IF lnpos = 0
			lcFWord = tcString
			tcString = ""
		ELSE
			lcFWord  = LEFT(tcString,lnPos-1)
			tcString = SUBSTR(tcString,lnPos+LEN(m.tcShare))
		ENDIF
		RETURN lcFWord
	ENDFUNC
*************************************************************************
* FUNCTION utos															*
* ������� �������� ������ ���� � ������									*
*************************************************************************
FUNCTION utos( tvPar )
	LOCAL lcType
	lcType = TYPE("m.tvPar")
	DO CASE
	CASE m.lcType = 'C' OR m.lcType = 'M'
		RETURN ALLTR( m.tvPar )
	CASE m.lcType = 'D'
		RETURN DTOC( m.tvPar )
	CASE m.lcType = 'T'
		RETURN TTOC( m.tvPar )
	CASE m.lcType = 'N' OR m.lcType = 'Y'
		IF m.tvPar - INT( m.tvPar )!=0
			LOCAL lc, ln
			lc = ALLTR(STR(m.tvPar,20,8))
			FOR ln = LEN(m.lc) TO 1 STEP -1
				IF SUBSTR(m.lc,m.ln,1)!='0'
					EXIT
				ENDIF
			ENDFOR
			IF INLIST( SUBSTR(m.lc, m.ln, 1), ',','.')
				m.ln = m.ln-1
			ENDIF
			IF m.ln>0
				lc = SUBSTR(m.lc, 1, m.ln )
			ENDIF
			RETURN m.lc
		ELSE
			RETURN ALLTR(STR(m.tvPar))
		ENDIF
	CASE m.lcType = 'L'
		RETURN IIF( m.tvPar, '.T.', '.F.' )
	ENDCASE
	RETURN ""
ENDFUNC

*************************************************************************
* FUNCTION stou															*
* ������� ������, �������������� �-�� utos � ��������, ��������� ���� 	*
* tcVal - �������� � ���� ������										*
* tcType- ��� 															*
* ����������: Numeric,Character,Logical,Date,Time						*
*************************************************************************
FUNCTION stou( tcVal, tcType )
	DO CASE
	CASE m.tcType = 'C' OR m.tcType = 'M'
		RETURN ALLTR( m.tcVal )
	CASE m.tcType = 'D'
		RETURN CTOD( m.tcVal )
	CASE m.tcType = 'T'
		RETURN CTOT( m.tcVal )
	CASE m.tcType = 'N' OR m.tcType = 'Y'
		RETURN VAL(  m.tcVal )
	CASE m.tcType = 'L'
		tcVal = upper(m.tcVal)
		RETURN IIF( m.tcVal = '.T.',.t., .f.)
	ENDCASE
	RETURN .f.
ENDFUNC

* ����� ���� ������ Save

*************************************************************************
* ������� ��������� � ���� � ���������� ������ � ������� STOP			*
*************************************************************************
FUNCTION WarningBox
LPARAMETERS tcMsg
	if type("m.tcMsg")!="C"
		m.tcMsg = "����������� ������"
	endif
	MESSAGEBOX( m.tcMsg + '.',  MB_ICONEXCLAMATION, MSG_WARNING)
ENDFUNC

FUNCTION ErrorBox
LPARAMETERS tcMsg
	if type("m.tcMsg")!="C"
		m.tcMsg = "����������� ������"
	endif
	MESSAGEBOX( m.tcMsg, MB_ICONSTOP, "������!")
ENDFUNC

Function ShowError
LPARAMETER tcText
   	local aMsg
   	dimension aMsg(1,6)
   	aerror(aMsg)
   	if type( "m.tcText" )!="C"
   		m.tcText = ""
   	endif
   	ErrorBox( iif(empty(m.tcText),"", m.tcText + CR ) + aMsg(1,2) )
ENDFUNC
*****************************************************************
* PROCEDURE BEEP												*
* ������ ��������� �������										*
*****************************************************************
PROCEDURE BEEP
LPARAMETERS tcName
	IF TYPE("m.tcName")!="C"
		set bell to
	ELSE
		tcName = "SOUNDS\" + allt(m.tcName)+".WAV"
		IF FILE( m.tcName)
			set bell to m.tcName
		ELSE
			set bell to
		ENDIF
	ENDIF
	?? chr(7)
	set bell to
ENDPROC
****************************************************************
* FUNCTION GetBorderWidth										*
* ���������� ������ ����� ����									*
* tnBorderWidth - ����� �����:									*
*	0 - ���, 1 - ������, 2 - ����������, 3 - ����������			*
*****************************************************************
FUNCTION GetBorderWidth
LPARAMETERS tnBorderStyle
	DO CASE
		CASE m.tnBorderStyle=1	&& Fixed Single
			return SYSMETRIC(10)
		CASE m.tnBorderStyle=2	&& Fixed Dialog
			return SYSMETRIC(12)
		CASE m.tnBorderStyle=3	&& Sizable
			return SYSMETRIC(3)
	ENDCASE
	RETURN 0

*****************************************************************
* FUNCTION GetBorderHeight										*
* ���������� ������ ����� ����									*
* tnBorderWidth - ����� �����:									*
*	0 - ���, 1 - ������, 2 - ����������, 3 - ����������			*
*****************************************************************
FUNCTION GetBorderHeight
LPARAMETERS tnBorderStyle
	DO CASE
		CASE m.tnBorderStyle=1	&& Fixed Single
			return SYSMETRIC(11)
		CASE m.tnBorderStyle=2	&& Fixed Dialog
			return SYSMETRIC(13)
		CASE m.tnBorderStyle=3	&& Sizable
			return SYSMETRIC(4)
	ENDCASE
	RETURN 0

*************************************************************************
* FUNCTION BlankVal														*
* ��������� ������ ���������� ��������� ����							*
*************************************************************************
FUNCTION BlankVal
LPARAMETERS tcType
	tcType = UPPER(m.tcType)
	DO CASE
	CASE m.tcType = "C"
		RETURN ""
	CASE m.tcType = "N"
		RETURN 0
	CASE m.tcType = "L"
		RETURN .f.
	CASE m.tcType = "D"
		RETURN {}
	ENDCASE
	RETURN .f.
ENDFUNC

*************************************************************************
* FUNCTION HasTag														*
* �������� ������� � ������� ������� � ��������� ������					*
* tcTag	 - ��� �������													*
* tAlias - ����� ���. ���. ��� ��� ������								*
* ����������: .T. - ������ ����, .F. - ��� ��� ����� �� ������			*
*************************************************************************
Function HasTag
LPARAMETERS tcTag, tAlias
	local n, i, lnOldArea, llResult
*	lnOldArea = SELECT(0)
	IF INLIST( TYPE( "m.tAlias" ), "N", "C" )
		IF EMPTY( ALIAS( m.tAlias) )
			RETURN .F.
		ENDIF
*		SELECT (m.tAlias)
	ELSE
		if empty(alias())
			return .f.
		endif
	ENDIF
	llResult = .f.
*	tcTag = allt(upper(m.tcTag))
	n = TAGCOUNT(CDX(1, m.tAlias), m.tAlias)
	for i=1 to m.n
		if TAG(CDX(1, m.tAlias), m.i, m.tAlias) == allt(upper(m.tcTag))
			llResult = .t.
			EXIT
		endif
	endfor
	return m.llResult

*************************************************************************
* FUNCTION TXTTRANSFORM													*
* ��������� �������������� ������ �� �������, ����������� �������		*
* ���� �� ������ ���������:												*
* U - � ������� �������													*
* Z - ��������� ������ ������ 											*
* ...																	*
*************************************************************************
FUNCTION TXTTRANSFORM
LPARAMETERS tc, tcFormat, lnMaxLength
	IF EMPTY( m.tcFormat )
		RETURN m.tc
	ENDIF
	IF AT('T', tcFormat )>0
		tc = ALLTRIM( m.tc )
	ENDIF
	DO CASE
	CASE AT('A', m.tcFormat )>0
		tc = PROPER(LTRIM( m.tc ))
	CASE AT('U', m.tcFormat )>0
		tc = UPPER( m.tc )
	CASE AT('L', m.tcFormat )>0
		tc = LOWER( m.tc )
	CASE AT('Z', m.tcFormat)>0 AND m.lnMAxLength>0
		tc = PADL( ALLT( m.tc ), m.lnMaxLength, '0')
	ENDCASE
	RETURN m.tc
ENDFUNC

*==== ����� === ===========================================================