PROCEDURE StatJT
 #INCLUDE INCLUDE\MSGB.H
 IF MESSAGEBOX("Вы хотите сформировать статистику по jt?",4+32,"") != mbYES
  RETURN 
 ENDIF 
 
 TRY 
  USE &PBase\&pvid(1,1)\kms IN 0 ALIAS kms SHARED ORDER nz
  USE &PCommon\jt IN 0 ALIAS sprjt SHARED ORDER jt
  IsOpenedFiles = .t.
 CATCH
  IsOpenedFiles = .f.
 ENDTRY 

 IF !IsOpenedFiles
  oApp.CloseAllTable()
  MESSAGEBOX('Невозможно открыть файлы!',0+16, '')
  RETURN 
 ENDIF 
 
 SELECT jt, coun(*) AS cnt FROM kms GROUP BY jt ORDER BY jt INTO CURSOR curjt
 SELECT curjt
 SET RELATION TO jt INTO sprjt
 
 TRY 
  oWord=GETOBJECT(,"Word.Application")
 CATCH 
  oWord=CREATEOBJECT("Word.Application")
 ENDTRY 

 oDoc = oWord.Documents.Add

 WITH oWord.Selection
  .Font.Name = 'Arial'
  .Font.Size = 12
  .ParagraphFormat.Alignment = 1  && wdAlignParagraphCenter 
  .TypeText("Состояние регистра в разрезе по признакам движения полиса"+CHR(10)+CHR(13))
  .TypeParagraph
  .ParagraphFormat.Alignment = 0  && wdAlignParagraphLeft
 ENDWITH 

 oRng = oWord.Selection.Range
 oRng.Collapse(0)
 oRng.InsertAfter('jt;Наименование jt;Кол-во записей')
 oRng.InsertParagraphAfter
 
 SCAN
  WITH oRng
   .InsertAfter(jt+';'+sprjt.name+';'+ALLTRIM(STR(cnt)))
   .InsertParagraphAfter
  ENDWITH 
 ENDSCAN  

 oRng.ConvertToTable(';')
 WITH oRng.Tables.Item(1).Columns
  .Item(1).Width = 25
  .Item(2).Width = 350
  .Item(3).Width = 60
 ENDWITH 

 SET RELATION OFF INTO sprJt
 USE IN sprJt
 USE
* CLOSE DATABASES 
 
 oWord.Visible = .t.
RETURN 