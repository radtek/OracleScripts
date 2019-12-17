--
-- GET_SF_DOPOLN2  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Sf_Dopoln2  (pBill_IdNpr VARCHAR2, pBill_NameNpr VARCHAR2, pBillPos_IdNpr VARCHAR2, pBillPos_NameNpr VARCHAR2,
 pDogNumber VARCHAR2, pDogDate DATE, pNomDok NUMBER, pDateKvit DATE, pDateMos DATE, pNumAkt VARCHAR2, pNaznOtg NUMBER) RETURN VARCHAR2 AS
BEGIN
  -- Возвращает Дополнение для СФ
  -- pBill_IdNpr - н/пр в СФ
  -- pBillPos_IdNpr - н/пр в позиции СФ
  -- pDogNumber - договор 
  -- pDogDate - дата договора 
  -- pNomDok - BILLS.NOM_DOK
  -- pNumAkt - N акта
  -- pDateKvit - дата квитанции  
  IF pBill_IdNpr IN ('10090','10091','10092','10062','10063','10055','10095','10097','10098','10058') THEN 
    RETURN 'Согласно договору '|| pDogNumber || ' от ' || TO_CHAR(pDogDate,'dd.mm.yyyy') ||'г. ';
  ELSE
    IF pBill_IdNpr IN ('10093','10094','10096') THEN 
	  RETURN pBillPos_NameNpr || ' за '||NLS_LOWER(Rusmonth(pDateKvit)) || ' согласно договору '|| pDogNumber || ' от ' || TO_CHAR(pDogDate,'dd.mm.yyyy') ||'г. ';
	ELSE   
      IF pNaznOtg=9  THEN 
--        RETURN 'Акт приема-передачи № ' || Get_List_Nakl_Num(pNomDok) || ' от ' || TO_CHAR(pDateKvit,'dd.mm.yyyy') ||' г. ';
	    RETURN 'Акт приема-передачи № ' || pNumAkt || ' от ' || TO_CHAR(pDateKvit,'dd.mm.yyyy') ||'г. ';
	  ELSE
        IF pBill_IdNpr='10080'  THEN 
	      RETURN 'Акт приема-передачи № ' || pNumAkt || ' от ' || TO_CHAR(pDateKvit,'dd.mm.yyyy') ||'г. ';
	    ELSE
          IF pBill_IdNpr<'10100' AND pBill_IdNpr<>'10080' THEN 
		    RETURN 'Согласно отчета агента от ' || TO_CHAR(pDateMos,'dd.mm.yyyy') ||'г. ' ;
    	  ELSE 
	  	    RETURN 'Квит. № ' || Get_List_Nakl_Num(pNomDok) || ' от ' || TO_CHAR(pDateKvit,'dd.mm.yyyy') ||' г. ';
		  END IF;
	    END IF;
	  END IF;	
	END IF;
  END IF;	  	   
END Get_Sf_Dopoln2;

/

