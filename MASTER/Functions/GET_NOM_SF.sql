--
-- GET_NOM_SF  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_nom_Sf(pMode NUMBER, pNom_Dok NUMBER, pNom_Sf NUMBER, pOld_dok NUMBER, pOld_sf NUMBER, pSumma_Dok NUMBER, pDateVypSf DATE, pDateKvit DATE) RETURN VARCHAR2 IS
  vRes VARCHAR2(200);
BEGIN
  -- Функция возвращает: 
  -- pMode=0 			 номер СФ + номер корректируемого счета (через дробь) + дата СФ
  -- pMode=1			 номер СФ + номер корректируемого счета (через дробь)
  -- pMode=2			 номер СФ
  -- pMode=3			 номер СФ + дата СФ + г.
  vRes:=TO_CHAR(pNom_sf);
  IF NVL(pOld_Sf,0)<>0 AND NVL(pSumma_Dok,0)>0 AND pMode IN (0,1) THEN
    vRes:=vRes || '/' || LTRIM(TO_CHAR(pOld_sf));
  END IF;	
  IF pMode=0 THEN
/*    IF pDateVypSf<pDateKvit THEN
  	  vRes:=vRes || '  от  ' || TO_CHAR(pDateKvit, 'DD.MM.YYYY');
	ELSE*/   
  	  vRes:=vRes || '  от  ' || TO_CHAR(pDateVypSf, 'DD.MM.YYYY');
/*    END IF;*/
  END IF;
  IF pMode=3 THEN
/*    IF pDateVypSf<pDateKvit THEN
  	  vRes:=vRes || '  от  ' || TO_CHAR(pDateKvit, 'DD.MM.YYYY')  || 'г.' ;
	ELSE*/   
  	  vRes:=vRes || '  от  ' || TO_CHAR(pDateVypSf, 'DD.MM.YYYY') || 'г.';
/*    END IF;*/
  END IF;
  RETURN vRes; 	
END Get_Nom_Sf;
/

