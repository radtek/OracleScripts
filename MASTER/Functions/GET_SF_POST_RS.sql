--
-- GET_SF_POST_RS  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Sf_Post_Rs  (pPostId NUMBER, pPostRS VARCHAR2, pDogNumber VARCHAR2) RETURN VARCHAR2 AS
BEGIN
  -- Возвращает р/с поставщика для СФ
  IF pDogNumber IN ('0411498/721/13/2004','0411565/737/13/2004') THEN 
    RETURN '40702810700000000335'; 
  ELSE 
    RETURN pPostRS; 
  END IF;
END Get_Sf_Post_Rs;

/

