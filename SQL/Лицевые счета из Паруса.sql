SELECT 
  tAGENT.AGNABBR AS AGENT_CODE,
  tAGENT.ORGCODE AS OKPO,
  tAGENT.AGNIDNUMB AS INN, 
  tAGENT.AGNNAME AS AGENT_NAME, 
  a.NUMB AS FACEACC_NUMB,
  dt.DOCNAME AS doctype,
  a.VALID_DOCNUMB AS DOCNUMB
FROM FACEACC a, AGNLIST tAGENT, DOCTYPES dt
WHERE
  a.agent=tagent.rn(+) AND  
  a.VALID_DOCTYPE=dt.rn(+)
  AND (EXISTS (SELECT /*+ RULE */ NULL FROM INORDERS C WHERE C.FACEACC=A.RN)
     OR EXISTS (SELECT /*+ RULE */ NULL FROM CONSUMERORD C WHERE C.FACEACC=A.RN) 
     OR EXISTS (SELECT /*+ RULE */ NULL FROM TRANSINVCUST C WHERE C.FACEACC=A.RN) 
     OR EXISTS (SELECT /*+ RULE */ NULL FROM TRANSINVDEPT C WHERE C.FACEACC=A.RN))
ORDER BY a.NUMB   
 