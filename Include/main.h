*-- Общие константы приложения
*-- Данный файл должен быть включен в ЛЮБОЙ класс приложения

#INCLUDE 	STRINGS.H
#INCLUDE 	FOXPRO.H
#INCLUDE	KEYBOARD.H
#INCLUDE	VB_CONSTANT.H
#INCLUDE	FOXPRO_REPORTING.H
#INCLUDE	REPORTLISTENERS.H

*-- Для отладки DEBUGMODE должен быть .T.
*-- Для Рабочего режима необходимо установить DEBUGMODE в .F.
*-- И перекомпилировать ВЕСЬ !!! проект

#DEFINE	DEBUGMODE .F.
#DEFINE RG_PUNKT 1
#DEFINE RG_SMO 2

*-- Число попыток входа в систему
#DEFINE		COUNT_LOGIN		3
*-- Режим работы команд SQL
#DEFINE		MODE_SQL_ASYN	.T.

#DEFINE		SQLDRIVER			"SQL Server"
#DEFINE		SQL_APP_ROLE		"WORK_ROLE"
#DEFINE		ROLE_PASS			"b22222222"
#DEFINE 	NAME_MAIN_WINDOW	"ДЕМОНСТРАЦИОННЫЙ ПРОЕКТ"
#DEFINE		ERRFILE				"ERR.TXT"
#DEFINE		INIFILE				"USER.INI"
#DEFINE		SQLINIFILE			"CONFIG.INI"
#DEFINE		LOGFILE				"ERRSQL.TXT"
#DEFINE 	ERRORTITLE_LOC		"Ошибка !"
#DEFINE 	SQL_LOGIN			"LoginForAll"
#DEFINE 	LOGIN_PASSWORD		"123"
#DEFINE 	SQL_LOGIN_ADMIN		"AppAdmin"
#DEFINE 	ADMIN_PASSWORD		"111222333"

*-- Задержка вывода WAIT
#DEFINE		WAIT_TIMEOUT		1

#DEFINE CRLF  CHR(13) + CHR(10)
#DEFINE CR    CHR(13)
#DEFINE TAB    CHR(9)

*-- Эти константы используются в формах 
*-- для индикации статуса текущего алиаса
#DEFINE FILE_OK    0
#DEFINE FILE_BOF  1
#DEFINE FILE_EOF  2
#DEFINE FILE_CANCEL  3

#DEFINE			OPEN_FOLDER		0x31
#DEFINE			CLOSE_FOLDER	0x30
#DEFINE			NOT_CHILDREN	0x9F

