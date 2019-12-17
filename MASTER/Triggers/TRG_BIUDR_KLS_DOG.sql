--
-- TRG_BIUDR_KLS_DOG  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KLS_DOG
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KLS_DOG FOR EACH ROW
DECLARE
  res NUMBER;
BEGIN

  IF INSERTING() OR UPDATING() THEN
    -- Уникальный ID
    IF :new.ID=0 OR :new.ID IS NULL THEN
      SELECT SEQ_KLS_DOG.NEXTVAL INTO :new.ID FROM DUAL;
    END IF;

    -- MAINDOG_ID	
    -- Для Базовых договоров - ссылки на самих себя
    BEGIN
      SELECT DOG_ID INTO res FROM KLS_DOG_MAIN WHERE DOG_ID=:NEW.ID;
    EXCEPTION
      WHEN OTHERS THEN
        res:=NULL;
    END;	
	
    IF NVL(res,0)=0 THEN  	
      BEGIN
        -- Для договоров, на которые что-либо ссылается - это ID
        SELECT DISTINCT :NEW.ID INTO res FROM MASTER_SHADOW.KLS_DOG_SHADOW B WHERE (B.lukdog_id=:NEW.ID AND NVL(B.lukdog_id,0)<>0);
      EXCEPTION 
        WHEN NO_DATA_FOUND THEN
          -- Для договоров, которые ссылаются на другой договор - это LUKDOG_ID
          res:=:new.LUKDOG_ID;
      END;
	END IF;  
	
    IF NVL(res,0)=0 THEN  	
	  -- ссылка на соответствующий Базовый договор
	  BEGIN
        SELECT DOG_ID INTO res FROM KLS_DOG_MAIN WHERE IS_AGENT=:NEW.IS_AGENT 
		   AND TO_DATE('31.12.'||TO_CHAR(:NEW.DOG_YEAR),'dd.mm.yyyy') BETWEEN FROM_DATE AND TO_DATE;
      EXCEPTION
        WHEN OTHERS THEN
		  res:=NULL;
	  END;	  	 		
	END IF;

    IF res=0 THEN
	  res:=NULL;
	END IF;	
	:NEW.MAINDOG_ID:=res;
	
  END IF;
END;
/


