FUNCTION Bmp2Jpg(para1,para2,para3)

 LOCAL m.Bmp, m.Jpg, m.Q

 IF PARAMETERS()<=0
  RETURN .f.
 ENDIF 
 IF PARAMETERS()>=1
  m.Bmp = LOWER(para1) && путь к bmp-файлу
 ENDIF 
 IF PARAMETERS()>=2
  m.Jpg = LOWER(para2) && путь к jpg-файлу
 ENDIF 
 IF PARAMETERS()>=3
  m.Q   = para3 && качетство 
 ENDIF 
 
 IF EMPTY(m.Bmp)
  RETURN .f.
 ENDIF 
 IF !fso.FileExists(m.Bmp)
  RETURN .f.
 ENDIF 
 IF EMPTY(m.Jpg)
  m.Jpg = STRTRAN(m.Bmp,'bmp','jpg')
 ENDIF 
 IF EMPTY(m.q)
  m.Q = 50
 ENDIF 
 IF m.q>100
  RETURN .f.
 ENDIF 
 IF fso.FileExists(m.Jpg)
  fso.DeleteFile(m.Jpg)
 ENDIF 
 
 Img = CreateObject("WIA.ImageFile")
 IP  = CreateObject("WIA.ImageProcess")

 Img.LoadFile(m.Bmp)

 IP.Filters.Add(IP.FilterInfos("Crop").FilterID)
 IP.Filters(1).Properties("Left").Value = (Img.Width-320)/4
 IP.Filters(1).Properties("Top").Value = (Img.Height-400)/4
 IP.Filters(1).Properties("Right").Value = (Img.Width-320)/4
 IP.Filters(1).Properties("Bottom").Value = (Img.Height-400)/4

 Img = IP.Apply(Img)

 IP.Filters.Add(IP.FilterInfos("Convert").FilterID)
 IP.Filters(2).Properties("FormatID").Value = "{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}" && JPG format
 IP.Filters(2).Properties("Quality").Value = m.Q
 Img = IP.Apply(Img)

 Img.SaveFile(m.Jpg)

RETURN .t. 