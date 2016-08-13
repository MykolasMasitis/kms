PROCEDURE prn_vs
 PRIVATE m.qnamen, m.qaddressn, m.dp, m.fio, m.doc, m.docissue, m.birthplace, m.ismale,;
  m.isfemale, m.expiredate, m.operfio

 dotname = pTempl + "\vs_template.dot"
 docname = pLocal + "\vs_template.doc"

 m.qnamen     = allt(m.qname)+" ("+m.qcod+pvid(1,1)+")"
 m.qaddressn  = allt(m.qaddress)
 m.dp         = padl(day(dp),2,"0")+space(5)+padl(month(dp),2,"0")+space(9)+subs(allt(str(year(dp))),3,2)
 m.fio        = allt(fam)+' '+allt(im)+' '+allt(ot)
 m.doc        = dtoc(dr)+', '+iif(seek(str(c_doc,2),"viddoc"),allt(viddoc.name), '')+' '+allt(s_doc)+' '+allt(n_doc)+', גûהאם '+dtoc(d_doc)
 m.docissue   = allt(podr_doc)
 m.birthplace = allt(mr)
 m.ismale     = 'V'
 m.isfemale   = 'V'
 m.expiredate = padl(day(dp+38),2,"0")+space(5)+padl(month(dp+38),2,"0")+space(8)+subs(allt(str(year(dp+38))),3,2)
* m.operfio    = allt(pvid(1,6))+' '+left(allt(pvid(1,7)),1)+'.'+left(allt(pvid(1,8)),1)+'.'
 m.operfio    = allt(m.userfam)+' '+left(allt(m.userim),1)+'.'+left(allt(m.userot),1)+'.'

 TRY 
  oWord=GETOBJECT(,"Word.Application")
 CATCH 
  oWord=CREATEOBJECT("Word.Application")
 ENDTRY 
 oDoc = oWord.Documents.Add(dotname)
    
 oDoc.Bookmarks('qname').Select  
 oWord.Selection.TypeText(m.qnamen)

 oDoc.Bookmarks('qaddress').Select  
 oWord.Selection.TypeText(ALLTRIM(m.qaddressn))

 oDoc.Bookmarks('dp').Select  
 oWord.Selection.TypeText(ALLTRIM(m.dp))

 oDoc.Bookmarks('fio').Select  
 oWord.Selection.TypeText(m.fio)

 oDoc.Bookmarks('doc').Select  
 oWord.Selection.TypeText(m.doc)

 oDoc.Bookmarks('docissue').Select  
 oWord.Selection.TypeText(m.docissue)

 oDoc.Bookmarks('birthplace').Select  
 oWord.Selection.TypeText(m.birthplace)

 IF w==1
 oDoc.Bookmarks('ismale').Select  
 oWord.Selection.TypeText(m.ismale)
 ELSE 
 oDoc.Bookmarks('isfemale').Select  
 oWord.Selection.TypeText(m.isfemale)
 ENDIF 
 oDoc.Bookmarks('expiredate').Select  
 oWord.Selection.TypeText(m.expiredate)

 oDoc.Bookmarks('operfio').Select  
 oWord.Selection.TypeText(m.operfio)

 oWord.Visible = .t.
 
RETURN 

