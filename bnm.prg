PUBLIC  loException as Object 
TRY 
 USE bnm IN 0 ALIAS bnm SHARED 
CATCH TO loException 
 MESSAGEBOX('Procedure: '+loException.Procedure+CHR(13)+CHR(10)+;
 'Message: '+loexception.Message+CHR(13)+CHR(10)+;
 'LineContents: '+loexception.LineContents+CHR(13)+CHR(10)+;
 'Details: '+loexception.Details+CHR(13)+CHR(10),0+64,'')
ENDTRY 

