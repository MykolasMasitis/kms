PROCEDURE makeZsv
 IF MESSAGEBOX(CHR(13)+CHR(10)+'бш унрхре янапюрэ'+;
  CHR(13)+CHR(10)+'ябндмши Z-тюик?'+;
  CHR(13)+CHR(10),4+32,'')!= 6
  RETURN 
 ENDIF 
 
 tgDir = GETDIR(fso.GetParentFolderName(pbin),'','')
 
 IF EMPTY(tgDir)
  RETURN 
 ENDIF 
 
 IF fso.FileExists(tgDir+'z'+m.qcod+'sv.dbf')
  fso.DeleteFile(tgDir+'z'+m.qcod+'sv.dbf')
 ENDIF 

 oMailDir = fso.GetFolder(tgDir)
 MailDirName = oMailDir.Path
 oFilesInMailDir = oMailDir.Files
 nFilesInMailDir = oFilesInMailDir.Count

 MESSAGEBOX('намюпсфемн '+ALLTRIM(STR(nFilesInMailDir))+' тюикнб!', 0+64)

 IF nFilesInMailDir<=0
  RETURN 
 ENDIF 

 m.IsSvExists = .f.
 
 FOR EACH oFileInMailDir IN oFilesInMailDir
  m.fullname  = ALLTRIM(LOWER(oFileInMailDir.Path))
  m.shortname = ALLTRIM(LOWER(oFileInMailDir.Name))


  IF LEFT(m.shortname,3)=LOWER('z'+m.qcod) AND RIGHT(m.shortname,4)='.dbf'
  ELSE 
   LOOP 
  ENDIF 

  WAIT m.shortname WINDOW NOWAIT 
  
  m.dp = CTOD(SUBSTR(m.shortname,7,2)+'.'+SUBSTR(m.shortname,5,2)+'.201'+SUBSTR(m.shortname,4,1))

  =PutCodePage(m.fullname, 866, .t.)

  IF !m.IsSvExists
   IF OpenFile(m.fullname, 'ffile', 'share')>0
    LOOP 
   ELSE 
    SELECT ffile
    COPY STRUCTURE TO tgDir+'\z'+m.qcod+'sv'
    USE 
    =OpenFile(tgDir+'\z'+m.qcod+'sv', 'zsv', 'excl')
    SELECT zsv
    ALTER TABLE zsv ADD COLUMN dp d
    fso.DeleteFile(tgDir+'z'+m.qcod+'sv.bak')
   ENDIF 
  ENDIF 
  
  APPEND FROM (m.fullname)
  REPLACE FOR EMPTY(dp) dp WITH m.dp 
  
  WAIT CLEAR 
 ENDFOR 

 IF USED('zsv')
  USE IN zsv
 ENDIF 

 WAIT CLEAR 

RETURN
