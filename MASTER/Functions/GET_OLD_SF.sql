--
-- GET_OLD_SF  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Old_Sf(pNom_Dok NUMBER, pNom_Sf NUMBER, pOld_dok NUMBER, pOld_sf NUMBER) RETURN NUMBER IS
  vOld_Old_sf NUMBER;
  vOld_Old_dok NUMBER;
BEGIN
  -- Функция возвращает номер корректируемого счета для визуализации в СФ и реестрах (через дробь) с 
  -- учетом ситуации когда корректирующие СФ в свою очередб тоже корректируются
  IF NVL(pOld_Sf,0)=0 THEN -- Если нет ссылки на корректируемый счет
    RETURN NULL;
  ELSE
    IF NVL(pOld_Sf,0)=NVL(pNom_Sf,0) THEN -- Если корректируемый и корректирующий счета равны, то Корректирующий счет - минусовой
	  -- Проверяем не является ли корректируемый счет корректирующим для другого (цепочка корректировок)
	  BEGIN
  	    SELECT Old_nom_sf,Old_nom_dok INTO vOld_old_sf,vOld_old_dok FROM BILLS WHERE nom_dok=pOld_Dok;
      EXCEPTION
        WHEN OTHERS THEN
  	      vOld_old_sf:=0;
		  vOld_old_dok:=0;
      END;
 	  IF NVL(vOld_Old_Sf,0)=0 THEN -- Если корректируемый счет не ссылается на другой
	    RETURN NULL;
	  ELSE -- Если корректируемый счет является корректирующим для другого
	    RETURN vOld_Old_sf;
	  END IF;
	ELSE
	  RETURN pOld_sf;
	END IF;
  END IF;	      		   
END Get_Old_sf;
/

