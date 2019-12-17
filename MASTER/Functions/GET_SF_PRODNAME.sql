--
-- GET_SF_PRODNAME  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Sf_Prodname  (pBill_IdNpr VARCHAR2, pBill_NameNpr VARCHAR2, pBillPos_IdNpr VARCHAR2, pBillPos_NameNpr VARCHAR2,
 pDateKvit DATE) RETURN VARCHAR2 AS
BEGIN
  -- Возвращает Наименование н/пр для СФ
  -- pBill_IdNpr - н/пр в СФ
  -- pBillPos_IdNpr - н/пр в позиции СФ
  -- pDateKvit - дата квитанции 
  IF pBill_IdNpr IN ('10090','10091','10092') THEN 
    RETURN pBillPos_NameNpr || ' за '||NLS_LOWER(Rusmonth(pDateKvit)) || ' (ДЗ)';
  ELSE
    IF pBill_IdNpr IN ('10093','10094','10055','10095','10096','10097','10098','10058') THEN 
      RETURN pBillPos_NameNpr || ' за '||NLS_LOWER(Rusmonth(pDateKvit));
	ELSE   
      IF pBill_IdNpr IN ('10062','10063') THEN 
        RETURN pBillPos_NameNpr || ' за '||NLS_LOWER(Rusmonth(pDateKvit))|| ')';
	  ELSE   
	    RETURN pBillPos_NameNpr;
	  END IF;	
	END IF;
  END IF;	  	   
END Get_Sf_Prodname;

/

