*
*	Library of routines to manipulate OpenOffice.org.
*
*
* Список известных параметров шрифта:
* charColor - цвет
* charHeight - размер
* charFontName - имя шрифта
* сharWeight - толщина (Bold) 100 обычный, 200 жирный
* charUnderline - подчеркнутый
* charPosture - курсив
* charStrikeout - перечеркнутый
* charFontCharSet - кодировка

* Группа констант com.sun.star.awt.FontWeight
* http://api.openoffice.org/docs/common/ref/com/sun/star/awt/FontWeight.html
#define DONTKNOW    0  && The font weight is not specified/known.   
#define THIN       50  && specifies a 50% font weight.   
#define ULTRALIGHT 60  && specifies a 60% font weight.   
#define LIGHT      75  && specifies a 75% font weight.   
#define SEMILIGHT  90  && specifies a 90% font weight.   
#define NORMAL    100  && specifies a normal font weight.   
#define SEMIBOLD  110  && specifies a 110% font weight.   
#define BOLD      150  && specifies a 150% font weight.   
#define ULTRABOLD 175  && specifies a 175% font weight.   
#define BLACK     200  && specifies a 200% font weight.   

*############################################################
*	Public API
*	High level routines.
*############################################################


* Return .T. if OpenOffice.org is installed.
* Return .F. if not installed.
FUNCTION OOoIsInstalled()
	LOCAL oServiceManager
	oServiceManager = .NULL.

	LOCAL cOldErrHandler
	cOldErrHandler = ON( "ERROR" )
	ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
		oServiceManager = OOoGetServiceManager()
	ON ERROR &cOldErrHandler
	
	* If we could create a Service Manager,
	*  then OpenOffice.org must be installed.
	RETURN NOT ISNULL( oServiceManager )
ENDFUNC




* Easy way to create a new Draw document.
FUNCTION OOoCreateNewDrawDocument()
	LOCAL oDrawDoc
	oDrawDoc = OOoOpenURL( "private:factory/sdraw" )
	RETURN oDrawDoc
ENDFUNC


* Easy way to create a new Writer document.
FUNCTION OOoCreateNewWriterDocument()
	LOCAL oWriterDoc
	oWriterDoc = OOoOpenURL( "private:factory/swriter" )
	RETURN oWriterDoc
ENDFUNC


* Easy way to create a new Calc document.
FUNCTION OOoCreateNewCalcDocument()
	LOCAL oCalcDoc
	oCalcDoc = OOoOpenURL( "private:factory/scalc" )
	RETURN oCalcDoc
ENDFUNC


* Easy way to create a new Impress document.
FUNCTION OOoCreateNewImpressDocument()
	LOCAL oImpressDoc
	oImpressDoc = OOoOpenURL( "private:factory/simpress" )
	RETURN oImpressDoc
ENDFUNC



FUNCTION OOoOpenFile( cFilename )
	* change backslashes to forward slashes.
	LOCAL cURL
	cURL = "file:///" + CHRTRAN( cFilename, "\", "/" )
	
	LOCAL oDoc
	oDoc = OOoOpenURL( cURL )
	RETURN oDoc
ENDFUNC


PROCEDURE OOoTerminateProgram()
	LOCAL oDesktop
	oDesktop = OOoGetDesktop()
	oDesktop.Terminate()
	
	=__OOoReleaseCachedVars()
ENDPROC




*############################################################
*	Draw specific tools
*############################################################


* Page zero is the first page.
* Once you have a drawing document, obtain one of its pages.
FUNCTION OOoGetDrawPage( oDrawDoc, nPageNum )
	LOCAL oPages
	oPages = oDrawDoc.GetDrawPages()
	LOCAL oPage
	oPage = oPages.GetByIndex( nPageNum )
	RETURN oPage
ENDFUNC


* Given a draw document, create a shape.
* The shape must be added to the draw page, by calling
*  the draw page's Add() method.
* The oPosition and oSize arguments are optional, but you may
*  pass a Point and Size struct for these arguments.

FUNCTION OOoMakeRectangleShape( oDrawDoc, oPosition, oSize )
	LOCAL oShape
	oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.RectangleShape", oPosition, oSize )
	RETURN oShape
ENDFUNC

FUNCTION OOoMakeEllipseShape( oDrawDoc, oPosition, oSize )
	LOCAL oShape
	oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.EllipseShape", oPosition, oSize )
	RETURN oShape
ENDFUNC

FUNCTION OOoMakeLineShape( oDrawDoc, oPosition, oSize )
	LOCAL oShape
	oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.LineShape", oPosition, oSize )
	RETURN oShape
ENDFUNC

FUNCTION OOoMakeTextShape( oDrawDoc, oPosition, oSize )
	LOCAL oShape
	oShape = OOoMakeShape( oDrawDoc, "com.sun.star.drawing.TextShape", oPosition, oSize )
	RETURN oShape
ENDFUNC


* Create and return a Point struct.
FUNCTION OOoPosition( nX, nY )
	LOCAL oPoint
	oPoint = OOoCreateStruct( "com.sun.star.awt.Point" )
	oPoint.X = nX
	oPoint.Y = nY
	RETURN oPoint
ENDFUNC

* Create and return a Size struct.
FUNCTION OOoSize( nWidth, nHeight )
	LOCAL oSize
	oSize = OOoCreateStruct( "com.sun.star.awt.Size" )
	oSize.Width = nWidth
	oSize.Height = nHeight
	RETURN oSize
ENDFUNC


* Given a shape, alter its position.
PROCEDURE OOoSetPosition( oShape, nX, nY )
	LOCAL oPosition
	oPosition = oShape.Position
	oPosition.X = nX
	oPosition.Y = nY
	oShape.Position = oPosition
ENDPROC

* Given a shape, alter its size.
PROCEDURE OOoSetSize( oShape, nWidth, nHeight )
	LOCAL oSize
	oSize = oShape.Size
	oSize.Width = nWidth
	oSize.Height = nHeight
	oShape.Size = oSize
ENDPROC


* Given a draw document, create a shape.
* Optional:  oPosition, oSize can receive a Point or Size struct.
FUNCTION OOoMakeShape( oDrawDoc, cShapeClassName, oPosition, oSize )
	LOCAL oShape
	oShape = oDrawDoc.CreateInstance( cShapeClassName )
	
	IF (TYPE([oPosition])="O")  AND  (NOT ISNULL( oPosition ))
		oShape.Position = oPosition
	ENDIF
	IF (TYPE([oSize])="O")  AND  (NOT ISNULL( oSize ))
		oShape.Size = oSize
	ENDIF
	
	RETURN oShape
ENDFUNC



*############################################################
*	Color conversion utilities
*	--------------------------
*	Visual FoxPro and OpenOffice.org do not represent
*	 color values the same way.
*	Conversion routines in both directions are provided
*	 to keep things easy.
*	In addition, extremely convenient HSV routines are provided.
*	See LibGraphics for discussion of HSV color model.
*############################################################


* Similar to VFP's built in RGB() function.
* Pass in R,G,B values and out comes an OpenOffice.org color value.
* Note that this is DIFFERENT from how VFP constructs color values.
FUNCTION OOoRGB( nRed, nGreen, nBlue )
	RETURN BITOR( BITOR( BITLSHIFT( nRed, 16 ), BITLSHIFT( nGreen, 8 ) ), nBlue )
ENDFUNC

* Translate between a Visual FoxPro color and an OpenOffice.org color
*  by using a simple formula.
* Pass in a VFP color, out comes an OOo color.  And vice versa.
FUNCTION OOoColor( nColor )
	LOCAL nTranslatedColor
	nTranslatedColor = (INT( nColor / 65536 )) + (INT( INT( nColor / 256 ) % 256 ) * 256) + (INT( nColor % 256 ) * 65536)
	RETURN nTranslatedColor
ENDFUNC

* Extract the Red component from an OpenOffice.org color.
* SImilar to the RGBRed() function in LibGraphics.
FUNCTION OOoRed( nOOoColor )
*	RETURN INT( nOOoColor / 65536 )
	RETURN BITRSHIFT( BITAND( nOOoColor, 0x00FF0000 ), 16 )
ENDFUNC

* Extract the Green component from an OpenOffice.org color.
* SImilar to the RGBGreen() function in LibGraphics.
FUNCTION OOoGreen( nOOoColor )
*	RETURN INT( INT( nOOoColor / 256 ) % 256 )
	RETURN BITRSHIFT( BITAND( nOOoColor, 0x0000FF00 ), 8 )
ENDFUNC

* Extract the Blue component from an OpenOffice.org color.
* SImilar to the RGBBlue() function in LibGraphics.
FUNCTION OOoBlue( nOOoColor )
*	RETURN INT( nOOoColor % 256 )
	RETURN BITAND( nOOoColor, 0x000000FF )
ENDFUNC

* Convenient way to construct an OOo color from HSV components.
* See LibGraphics for information about HSV.
* Note nHue is a number from 0.0 to 1.0.
FUNCTION OOoHSV( nHue, nSaturation, nBrightness )
	LOCAL nColor
*	nColor = MakeHSVColor( nHue * 6.0, nSaturation, nBrightness )
	nColor = OOoColor( nColor )
	RETURN nColor
ENDFUNC

* Convenient way to extract the Hue component from an OOo color.
* See LibGraphics for information about HSV.
* Note nHue is a number from 0.0 to 1.0.
FUNCTION OOoHue( nOOoColor )
*	RETURN HSVHue( OOoColor( nOOoColor ) ) / 6.0
ENDFUNC

* Convenient way to extract the Saturation component from an OOo color.
* See LibGraphics for information about HSV.
FUNCTION OOoSaturation( nOOoColor )
*	RETURN HSVSaturation( OOoColor( nOOoColor ) )
ENDFUNC

* Convenient way to extract the Brightness component from an OOo color.
* See LibGraphics for information about HSV.
FUNCTION OOoBrightness( nOOoColor )
*	RETURN HSVValue( OOoColor( nOOoColor ) )
ENDFUNC



*############################################################



PROCEDURE DoNothing__ErrorHandler( pnError, pcErrMessage, pnLineNo, pcProgramFileSys16, pcProgram, pcErrorParamSys2018 )
ENDPROC


* Return the OpenOffice.org service manager object.
* Cache it in a global variable.
* Create it if not already cached.
FUNCTION OOoGetServiceManager()
	IF (TYPE([goOOoServiceManager])!="O")  OR  ISNULL( goOOoServiceManager )
		PUBLIC goOOoServiceManager
		goOOoServiceManager = .NULL.
		goOOoServiceManager = CREATEOBJECT( "Com.Sun.Star.ServiceManager.1" )
	ENDIF
	RETURN goOOoServiceManager
ENDFUNC


* Sugar coated routine to ask the service manager to
*  create you an instance of some other OpenOffice.org UNO object.
FUNCTION OOoServiceManager_CreateInstance( cServiceName )
	LOCAL oServiceManager
	oServiceManager = OOoGetServiceManager()
	
	LOCAL oInstance
	oInstance = .NULL.

	LOCAL cOldErrHandler
	cOldErrHandler = ON( "ERROR" )
	ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
		oInstance = oServiceManager.createInstance( cServiceName )
	ON ERROR &cOldErrHandler
	
	IF ISNULL( oInstance )
		=__OOoReleaseCachedVars()
		oServiceManager = OOoGetServiceManager()
		oInstance = oServiceManager.createInstance( cServiceName )
	ENDIF

	RETURN oInstance
ENDFUNC

FUNCTION OOoServiceManager_CreateInstanceWithArguments( cServiceName, aArgs )
	LOCAL oServiceManager
	oServiceManager = OOoGetServiceManager()  && GetProcessServiceManager() <=> CREATEOBJECT( "Com.Sun.Star.ServiceManager.1" )
	
	LOCAL oInstance
	oInstance = .NULL.

	LOCAL cOldErrHandler
	cOldErrHandler = ON( "ERROR" )
	ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
		oInstance = oServiceManager.createInstanceWithArguments( cServiceName, @ aArgs )
	ON ERROR &cOldErrHandler
	
	IF ISNULL( oInstance )
		=__OOoReleaseCachedVars()
		oServiceManager = OOoGetServiceManager()
		oInstance = oServiceManager.createInstanceWithArguments( cServiceName, @ aArgs )
	ENDIF

	RETURN oInstance
ENDFUNC

* Return the OpenOffice.org desktop object.
* Cache it in a global variable.
* Create it if not already cached.
FUNCTION OOoGetDesktop()
	IF (TYPE([goOOoDesktop])!="O")  OR  ISNULL( goOOoDesktop )
		PUBLIC goOOoDesktop
		goOOoDesktop = OOoServiceManager_CreateInstance( "com.sun.star.frame.Desktop" )
		COMARRAY( goOOoDesktop, 10 )
	ENDIF
	RETURN goOOoDesktop
ENDFUNC

* Return an instance of com.sun.star.reflection.CoreReflection.
* Cache it in a global variable.
* Create it if not already cached.
FUNCTION OOoGetCoreReflection()
	IF (TYPE([goOOoCoreReflection])!="O")  OR  ISNULL( goOOoCoreReflection )
		PUBLIC goOOoCoreReflection
		goOOoCoreReflection = OOoServiceManager_CreateInstance( "com.sun.star.reflection.CoreReflection" )
		COMARRAY( goOOoCoreReflection, 10 )
	ENDIF
	RETURN goOOoCoreReflection
ENDFUNC

* Return the OpenOffice.org version string.
FUNCTION OOoVersion()
LOCAL aArgs[1] As com.sun.star.beans.PropertyValue, oSettings As Object
	IF (TYPE([goOOoConfigProvider])!="O")  OR  ISNULL( goOOoConfigProvider )
		PUBLIC goOOoConfigProvider
		goOOoConfigProvider = OOoServiceManager_CreateInstance( "com.sun.star.configuration.ConfigurationProvider" )
		COMARRAY( goOOoConfigProvider, 10 )
	ENDIF
	aArgs[1] = OOoPropertyValue( "nodepath", "/org.openoffice.Setup/Product")
	oSettings = goOOoConfigProvider.createInstanceWithArguments("com.sun.star.configuration.ConfigurationAccess", @ aArgs)
	RETURN oSettings.getByName("ooSetupVersion")
ENDFUNC

* Перевод функции GetConfigAccess: http://www.oooforum.org/forum/viewtopic.phtml?t=10519&highlight=spellchecking
PROCEDURE OOoSpellChecking( lCheck )
LOCAL aArg[1], aArgs[2] As com.sun.star.beans.PropertyValue, oConfigAccess As Object
	IF (TYPE([goOOoConfigProvider])!="O")  OR  ISNULL( goOOoConfigProvider )
		PUBLIC goOOoConfigProvider
		aArg[1] = OOoPropertyValue( "enableasync", .T.)
		goOOoConfigProvider = OOoServiceManager_CreateInstanceWithArguments( "com.sun.star.configuration.ConfigurationProvider", @ aArg)
*		goOOoConfigProvider = OOoServiceManager_CreateInstance( "com.sun.star.configuration.ConfigurationProvider" )
		COMARRAY( goOOoConfigProvider, 10 )
	ENDIF

	aArgs[1] = OOoPropertyValue( "nodepath", "/org.openoffice.Office.Linguistic/SpellChecking" )
	aArgs[2] = OOoPropertyValue( "lazywrite", .T. )
	oConfigAccess = goOOoConfigProvider.createInstanceWithArguments("com.sun.star.configuration.ConfigurationUpdateAccess", @ aArgs)
	oConfigAccess.IsSpellAuto = lCheck
	oConfigAccess.commitChanges()

**	 IF (TYPE([goOOoLinguProperties])!="O")  OR  ISNULL( goOOoLinguProperties )
**	 	PUBLIC goOOoLinguProperties
**	 	goOOoLinguProperties = OOoServiceManager_CreateInstance( "com.sun.star.linguistic2.LinguProperties" )
**	 	COMARRAY( goOOoLinguProperties, 10 )
**	 ENDIF
**	 goOOoLinguProperties.IsUseDictionaryList = lCheck  && .T.
*    goOOoLinguProperties.IsSpellAuto = lCheck  && .T.
*    goOOoLinguProperties.IsSpellHide = lCheck  && .T.
**   goOOoLinguProperties.IsSpellInAllLanguages = lCheck  && .T.
**	 * MessageBox (goOOoLinguProperties.DefaultLocale.Country)
**   goOOoLinguProperties.DefaultLocale = oLocale
**   * MessageBox (goOOoLinguProperties.DefaultLocale.Country)
**   goOOoLinguProperties.DefaultLocale_CJK = oLocale 
**   goOOoLinguProperties.DefaultLocale_CTL = oLocale
ENDPROC

* Create a UNO struct object and return it.
FUNCTION OOoCreateStruct( cTypeName )
	* Ask service manager for a CoreReflection object.
	LOCAL oCoreReflection
	oCoreReflection = OOoGetCoreReflection()
	
	* Get the IDL Class for the type name.
	LOCAL oXIdlClass
	oXIdlClass = .NULL.

	LOCAL cOldErrHandler
	cOldErrHandler = ON( "ERROR" )
	ON ERROR = DoNothing__ErrorHandler( ERROR(), MESSAGE(), LINENO(), SYS(16), PROGRAM(), SYS(2018) )
		oXIdlClass = oCoreReflection.forName( cTypeName )
	ON ERROR &cOldErrHandler
	
	IF ISNULL( oXIdlClass )
		=__OOoReleaseCachedVars()
		oCoreReflection = OOoGetCoreReflection()
		oXIdlClass = oCoreReflection.forName( cTypeName )
	ENDIF
	
	* Create a variable to hold the created Struct.
	* Assign it some initial value.
	LOCAL oStruct
	oStruct = CREATEOBJECT( "relation" ) && assign some kind of object initially

	* Ask the class definition to create an instance.
	oXIdlClass.CreateObject( @oStruct )
	
	RETURN oStruct
ENDFUNC


* Create a com.sun.star.beans.PropertyValue struct and return it.
FUNCTION OOoPropertyValue( cName, uValue, nHandle, nState )
	LOCAL oPropertyValue
	oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" )
	
	oPropertyValue.Name = cName
	oPropertyValue.Value = uValue
	
	IF TYPE([nHandle])="N"
		oPropertyValue.Handle = nHandle
	ENDIF
	IF TYPE([nState])="N"
		oPropertyValue.State = nState
	ENDIF
	
	RETURN oPropertyValue
ENDFUNC

PROCEDURE OOoSetDesignMode( oDoc, lMode )
LOCAL laArgs[1]
  loFrame   = oDoc.getCurrentController().getFrame()
  dispatcher = OOoServiceManager_CreateInstance("com.sun.star.frame.DispatchHelper")
  laArgs[1] = OOoPropertyValue("SwitchControlDesignMode", lMode)
  dispatcher.executeDispatch(loFrame, ".uno:SwitchControlDesignMode", "", 0, @laArgs)
ENDPROC

* Open or Create a document from it's URL.
* New documents are created by URL's such as:
*	private:factory/sdraw
*	private:factory/swriter
*	private:factory/scalc
*	private:factory/simpress
FUNCTION OOoOpenURL( cURL )
*	LOCAL oPropertyValue
*	oPropertyValue = OOoCreateStruct( "com.sun.star.beans.PropertyValue" )

*	LOCAL ARRAY aNoArgs[1]
*	aNoArgs[1] = oPropertyValue
*	aNoArgs[1].Name = "ReadOnly"
*	aNoArgs[1].Value = .F.

	LOCAL ARRAY aNoArgs[1]
	aNoArgs[1] = OOoPropertyValue( "ReadOnly", .F. )
	
	LOCAL oDesktop
	oDesktop = OOoGetDesktop()

	LOCAL oDoc
	oDoc = oDesktop.LoadComponentFromUrl( cURL, "_blank", 0, @ aNoargs )
	
	* Make sure that arrays passed to this document are passed zero based.
	COMARRAY( oDoc, 10 )
	
	RETURN oDoc
ENDFUNC


PROCEDURE __OOoReleaseCachedVars()
	RELEASE goOOoServiceManager, goOOoDesktop, goOOoCoreReflection
ENDPROC



*############################################################


* Experimental stuff



*SET PROCEDURE TO LibOOo ADDITIVE
*oDoc = OOoOpenFile( GetDesktopFolderPathname() + "test.sxw" )


* This is an attempt to print a document.
PROCEDURE PrintExperiment( oDoc )
	LOCAL ARRAY aArgs[1]
	aArgs[1] = OOoPropertyValue( "CopyCount", 1, -1, 0 )
*	aArgs[1] = OOoPropertyValue( "Collate", .F. )
	
	oDoc.Print( @ aArgs )
ENDPROC


*############################################################


PROCEDURE TestOOo()
	* Create a drawing.
	LOCAL oDoc
	oDoc = OOoCreateNewDrawDocument()
	
	* Get the first page of the drawing.
	LOCAL oPage
	oPage = OOoGetDrawPage( oDoc, 0 )
	
	LOCAL nHue, nSaturation, nBrightness
	LOCAL nRow, nCol
	LOCAL oShape

	* Now let's draw some rectangles.

	* Let's vary the hue and saturation, while keeping the brightness constant.
	* But you could vary any two parameters, while keeping the third constant.
	
	nBrightness = 1.0 && full brightness
	FOR nRow = 0 TO 9
		FOR nCol = 0 TO 9
			* Create a shape
			oShape = OOoMakeRectangleShape( oDoc )
			* Calculate color
			nHue = nCol / 9 && hue varies *across* by column
			nSaturation = nRow / 9 && saturation varies *down* by row
			* set color of shape
			* oShape.FillColor = OOoRGB( 255, 255, 255 )
			oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
			* Position and size the shape
			OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
			OOoSetPosition( oShape, 1000 + nCol * 600, 1000 + nRow * 600 )
			* Add shape to page
			oPage.Add( oShape )
		ENDFOR
	ENDFOR


	* Let's vary the hue and saturation, while keeping the brightness constant.
	* This time, we'll use less-brightness
	* But you could vary any two parameters, while keeping the third constant.
	
	nBrightness = 0.7 && less brightness
	FOR nRow = 0 TO 9
		FOR nCol = 0 TO 9
			* Create a shape
			oShape = OOoMakeRectangleShape( oDoc )
			* Calculate color
			nHue = nCol / 9 && hue varies *across* by column
			nSaturation = nRow / 9 && saturation varies *down* by row
			* set color of shape
			oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
			* Position and size the shape
			OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
			OOoSetPosition( oShape, 9000 + nCol * 600, 1000 + nRow * 600 )
			* Add shape to page
			oPage.Add( oShape )
		ENDFOR
	ENDFOR


	* Let's vary the hue and brightness, while keeping the saturation constant.
	* But you could vary any two parameters, while keeping the third constant.
	
	nSaturation = 1.0 && full saturation
	FOR nRow = 0 TO 9
		FOR nCol = 0 TO 9
			* Create a shape
			oShape = OOoMakeRectangleShape( oDoc )
			* Calculate color
			nHue = nRow / 9 && hue varies *down* by row
			nBrightness = nCol / 9 && brightness varies *across* by column
			* set color of shape
			oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
			* Position and size the shape
			OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
			OOoSetPosition( oShape, 1000 + nCol * 600, 9000 + nRow * 600 )
			* Add shape to page
			oPage.Add( oShape )
		ENDFOR
	ENDFOR


	* Let's vary the saturation and brightness, while keeping the hue constant.
	* The hue will be yellow.
	* But you could vary any two parameters, while keeping the third constant.

	* Imagine hue is a "rainbow" of colors, from 0.0 to 1.0.
	* 0.0 is red, then you progress to orange, yellow, green, blue, purple, and
	*  then back to red again.  (Not like a real rainbow.)  1.0 is red also.
	* HSV colors are easy for HUMANS, while RGB colors are easy for COMPUTERS.
	* Quick, what is the RGB for Pink?  Brown?
	* In HSV, you would think Pink is a low-saturation red at full brightness,
	*  thus you could say H=0.0, S=0.5, B=1.0; and that's off the top of my head.
	* Brown is a low brightness Orange, so H=0.0888, S=1.0, B=0.6; right out of thin air.
	* Need a highly contrasting color?  Easy in HSV coordinates.
	* Just pick the opposite hue, maybe maximize saturation (opposite of other color),
	*  and maybe also a min or max brightness.  Can't easily come up with highly
	*  contrasting colors in RGB coordinates in RGB space.
	* Need to "soften" colors?  Take each HSV coordinate, and lower the saturation
	*  by 10 %.
	* Need to "darken" colors?  Lower the brightness of each pixel by 10 %.
	
	nHue = 0.1666 && yellow
	FOR nRow = 0 TO 9
		FOR nCol = 0 TO 9
			* Create a shape
			oShape = OOoMakeRectangleShape( oDoc )
			* Calculate color
			nSaturation = nRow / 9 && saturation varies *down* by row
			nBrightness = nCol / 9 && brightness varies *across* by column
			* set color of shape
			oShape.FillColor = OOoHSV( nHue, nSaturation, nBrightness )
			* Position and size the shape
			OOoSetSize( oShape, 500, 500 ) && 1/2 cm by 1/2 cm
			OOoSetPosition( oShape, 9000 + nCol * 600, 9000 + nRow * 600 )
			* Add shape to page
			oPage.Add( oShape )
		ENDFOR
	ENDFOR
	
	
	* Gee, you don't suppose someone out there could take the knowledge represented
	*  by this code and figure out how to make OpenOffice.org draw bar charts?
	
ENDPROC

************************

* *-- Calc Dokument
* If oDoc.supportsService("com.sun.star.sheet.SpreadsheetDocument")  && Calc Document
*     CellPos(1,2).SetString('Проба функции ActiveSheet') 
*     CellPos(1,3).SetString('Проба функции CellPos') 
*     * Получим массив с наименованиями листов книги Calc
*     oSheetsNames = oDoc.getSheets().getElementNames()
* Else
*     * oDoc.supportsService("com.sun.star.text.TextDocument")  && Writer Document
*     =MessageBox("Функция вызвана не из документа OpenOffice Calc!",48,"Сообщение")
* EndIf

* (c) 09.05.2007 by deqwan22
* http://www.oooforum.org/forum/viewtopic.phtml?t=56947
FUNCTION ActiveSheet
*	ActiveSheet=StarDesktop.CurrentComponent.CurrentController.ActiveSheet
	RETURN goOOoDesktop.CurrentComponent.CurrentController.ActiveSheet
ENDFUNC

* (c) 09.05.2007 by deqwan22
* http://www.oooforum.org/forum/viewtopic.phtml?t=56947
FUNCTION CellPos
LPARAM lColumn, lRow
	RETURN ActiveSheet.getCellByPosition (lColumn,lRow) 
ENDFUNC

* OpenOffice (найти последнюю ячейку)
* http://forum.foxclub.ru/read.php?29,274735
FUNCTION OOoGetLastUsedCel(oSheet AS OBJECT) AS Variant  
*/* последняя используемая строка/колонка  
*/* aAddress - возвращаемый обьект,содержит  
*/* aAddress.EndRow - последняя строка  
*/* aAddress.EndColumn - последняя колонка  
LOCAL oCell As Object, oCursor As Object, aAddress AS Variant
    
	oCell = oSheet.getCellByPosition(0, 0)  
	oCursor = oSheet.createCursorByRange(oCell)  
	oCursor.GotoEndOfUsedArea(.T.)  
	aAddress = oCursor.RangeAddress  
	RETURN  aAddress  
ENDFUNC

FUNCTION CalcColumnNameToNumber
LPARAM oSheet As com.sun.star.sheet.Spreadsheet, cColumnName As String
LOCAL oColumns, oColumn, oRangeAddress, nColumn
   oColumns = oSheet.getColumns() 
   oColumn = oColumns.getByName( cColumnName ) 
   oRangeAddress = oColumn.getRangeAddress() 
   nColumn = oRangeAddress.StartColumn 
   RETURN nColumn 
ENDFUNC

*-------------------------------------------------
* См. "howto_insert_date_de.pdf"
* Sets the passed number format as property of an object.
*
* parameter oController
* The controller that contains a number formatter.
*
* parameter oDestObj
* The destination object. Format is set at its NumberFormat property.
*
* parameter aFormat
* The string representation of the number format,
* or empty string to use the passed default format.
*
* parameter nStdFormat
* Index of a default number format (com.sun.star.util.NumberFormat
* constants), if no string is specified.
*-------------------------------------------------
PROCEDURE Set_Number_Format
LPARAM oController As Object, oDestObj As Object, aFormat As String, nStdFormat As Integer, nKey As Long
LOCAL aLocale
	oLocale = OOoCreateStruct( "com.sun.star.lang.Locale" )
	With oLocale
		.Language = "ru"
		.Country = "RU"
	EndWith
	oFormats = oDoc.getNumberFormats()  && oController.Model.NumberFormats

	If Empty(aFormat)
		oDestObj.NumberFormat = oFormats.getStandardFormat( nStdFormat, oLocale )
	Else
		nKey = oFormats.queryKey( aFormat, aLocale, .T. )
		If nKey < 0
			nKey = oFormats.addNew( aFormat, aLocale )
		EndIf
		oDestObj.NumberFormat = nKey
	EndIf
ENDPROC

PROCEDURE CellContentClear
LPARAM oSheet As Object, oCell as Object
LOCAL nContentTypes as Long
	*-- Складываем типы содержимого ячейки, которые должны быть очищены 
	nContentTypes = ooCellFlagsSTRING + ooCellFlagsVALUE + ooCellFlagsFORMULA
	*-- Очищаем при помощи интерфейса com.sun.star.sheet.XSheetOperation
	oCell.clearContents( nContentTypes )
ENDPROC

