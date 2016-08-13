PROCEDURE PackKmsE
  WAIT "ÓÏÀÊÎÂÊÀ ÁÄ ÏÂ..." WINDOW NOWAIT 

  IF OpenFile('&PBase\adr50', 'adr50', 'excl')>0
   IF USED('adr50')
    USE IN adr50
   ENDIF 
  ELSE 
   SELECT adr50
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\adr77', 'adr77', 'excl')>0
   IF USED('adr77')
    USE IN adr77
   ENDIF 
  ELSE 
   SELECT adr77
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\answers', 'answers', 'excl')>0
   IF USED('answers')
    USE IN aswers
   ENDIF 
  ELSE 
   SELECT answers
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\e_ffoms', 'efoms', 'excl')>0
   IF USED('efoms')
    USE IN efoms
   ENDIF 
  ELSE 
   SELECT efoms
   PACK 
   USE 
  ENDIF 
  
  IF OpenFile('&PBase\enp2', 'enp2', 'excl')>0
   IF USED('enp2')
    USE IN enp2
   ENDIF 
  ELSE 
   SELECT enp2
   PACK 
   USE 
  ENDIF 
  
  IF OpenFile('&PBase\error', 'error', 'excl')>0
   IF USED('error')
    USE IN error
   ENDIF 
  ELSE 
   SELECT error
   PACK 
   USE 
  ENDIF 
  
  IF OpenFile('&PBase\kms', 'kms', 'excl')>0
   IF USED('kms')
    USE IN kms
   ENDIF 
  ELSE 
   SELECT kms
   PACK 
   USE 
  ENDIF 
  
  IF OpenFile('&PBase\moves', 'moves', 'excl')>0
   IF USED('moves')
    USE IN moves
   ENDIF 
  ELSE 
   SELECT moves
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\odoc', 'odoc', 'excl')>0
   IF USED('odoc')
    USE IN odoc
   ENDIF 
  ELSE 
   SELECT odoc
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\ofio', 'ofio', 'excl')>0
   IF USED('ofio')
    USE IN ofio
   ENDIF 
  ELSE 
   SELECT ofio
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\osmo', 'osmo', 'excl')>0
   IF USED('osmo')
    USE IN osmo
   ENDIF 
  ELSE 
   SELECT osmo
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\permiss', 'permiss', 'excl')>0
   IF USED('permiss')
    USE IN permiss
   ENDIF 
  ELSE 
   SELECT permiss
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\predst', 'predst', 'excl')>0
   IF USED('predst')
    USE IN predst
   ENDIF 
  ELSE 
   SELECT predst
   PACK 
   USE 
  ENDIF 

  IF OpenFile('&PBase\user', 'users', 'excl')>0
   IF USED('users')
    USE IN users
   ENDIF 
  ELSE 
   SELECT users
   PACK 
   USE 
  ENDIF 
  
  WAIT CLEAR 
RETURN
