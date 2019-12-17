--
-- GET_KOL_DN  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.GET_KOL_DN
 (pDOG_ID NUMBER,pBEGIN_DATE DATE,pEND_DATE DATE,pPROD_ID_NPR VARCHAR2 DEFAULT NULL)
RETURN NUMBER
AS
  vKOL_DN NUMBER;
  vPROD_ID_NPR VARCHAR2(30);
BEGIN

  IF pPROD_ID_NPR||' '=' ' THEN
    vPROD_ID_NPR:='*';
  ELSE
    vPROD_ID_NPR:=pPROD_ID_NPR;	
  END IF;

  vKOL_DN:=0;
    
  -- Определяем отсрочку из последнего счета по договору за этот период (по н/пр)
  FOR lcur IN (SELECT /*+ RULE */ b.KOL_DN FROM BILL_POS bp, BILLS b
               WHERE b.NOM_DOK=bp.NOM_DOK
			     AND b.DOG_ID=pDOG_ID
			     AND b.DATE_KVIT<=pEND_DATE
				 AND bp.PROD_ID_NPR=DECODE(vPROD_ID_NPR,'*',bp.PROD_ID_NPR,vPROD_ID_NPR)
				 AND bP.PROD_ID_NPR>='10100' 
			  ORDER BY b.DATE_KVIT DESC) LOOP
    vKOL_DN:=lcur.KOL_DN;
	EXIT;
  END LOOP;
  
  IF vKOL_DN=0 THEN
    -- Определяем отсрочку из последнего счета по договору за этот период (по услугам)
    FOR lcur IN (SELECT /*+ RULE */ b.KOL_DN FROM BILL_POS bp, BILLS b
               WHERE b.NOM_DOK=bp.NOM_DOK
			     AND b.DOG_ID=pDOG_ID
			     AND b.DATE_KVIT<=pEND_DATE
				 AND bp.PROD_ID_NPR=DECODE(vPROD_ID_NPR,'*',bp.PROD_ID_NPR,vPROD_ID_NPR)
				 AND bP.PROD_ID_NPR<'10100'
			  ORDER BY b.DATE_KVIT DESC) LOOP
      vKOL_DN:=lcur.KOL_DN;
  	  EXIT;
    END LOOP;
  END IF;	

  IF vKOL_DN=0 THEN
    -- Определяем отсрочку из заявки
    FOR lcur IN (SELECT /*+ RULE */ b.KOL_DN FROM MONTH a,USL_DOG b
               WHERE a.DOG_ID=pDOG_ID
			     AND a.DOG_ID=b.DOG_ID
			     AND a.USL_NUMBER=b.USL_NUMBER
			     AND a.DATE_PLAN<=LAST_DAY(pEND_DATE)
			  ORDER BY a.INPUT_DATE DESC) LOOP
      vKOL_DN:=lcur.KOL_DN;
  	  EXIT;
    END LOOP;
  END IF;	
  
  RETURN vKOL_DN;
END Get_KOL_DN;

/

