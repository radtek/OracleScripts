--
-- GET_CENA_BN  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.GET_CENA_BN
 (pDOG_ID NUMBER,pEND_DATE DATE,pPROD_ID_NPR VARCHAR2)
RETURN NUMBER
AS
  vPRICE NUMBER;
BEGIN

  vPRICE:=0;
    
  -- Определяем цену без НДС из последнего счета по договору за этот период (по н/пр)
  FOR lcur IN (SELECT /*+ RULE */ bp.CENA_BN FROM BILL_POS bp, BILLS b
               WHERE b.NOM_DOK=bp.NOM_DOK
			     AND b.DOG_ID=pDOG_ID
			     AND b.DATE_KVIT<=pEND_DATE
				 AND bp.PROD_ID_NPR=pPROD_ID_NPR
			  ORDER BY b.DATE_KVIT DESC) LOOP
    vPRICE:=NVL(lcur.CENA_BN,0);
	EXIT;
  END LOOP;
  
  IF vPRICE=0 THEN
    -- Определяем цену без НДС из заявки по договору на этот месяц
    FOR lcur IN (SELECT CENA FROM MONTH a
                  WHERE a.DOG_ID=pDOG_ID
			        AND a.DATE_PLAN<=pEND_DATE
				    AND a.PROD_ID_NPR=pPROD_ID_NPR
				 ORDER BY a.INPUT_DATE DESC) LOOP
      vPRICE:=NVL(lcur.CENA,0);
  	  EXIT;
    END LOOP;
  END IF;	
  
  RETURN vPRICE;
END Get_CENA_BN;

/

