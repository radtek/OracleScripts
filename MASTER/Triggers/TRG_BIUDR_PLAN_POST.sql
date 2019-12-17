--
-- TRG_BIUDR_PLAN_POST  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_PLAN_POST
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.PLAN_POST
FOR EACH ROW
DECLARE
  v_old PLAN_POST%ROWTYPE;
  v_new PLAN_POST%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.PLAN_CENA := :OLD.PLAN_CENA;
    v_old.PLAN_VES := :OLD.PLAN_VES;
    v_old.PLAN_SUM := :OLD.PLAN_SUM;
    v_old.DATE_CENA := :OLD.DATE_CENA;
    v_old.PLAN_ID := :OLD.PLAN_ID;
    v_old.PLAN_PER_ID := :OLD.PLAN_PER_ID;
    v_old.PLANSTRU_ID := :OLD.PLANSTRU_ID;
    v_old.DOG_ID := :OLD.DOG_ID;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.PAYFORM_ID := :OLD.PAYFORM_ID;
    v_old.CAT_CEN_ID := :OLD.CAT_CEN_ID;
    v_old.APPL_TAG := :OLD.APPL_TAG;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.PLAN_CENA := :NEW.PLAN_CENA;
    v_new.PLAN_VES := :NEW.PLAN_VES;
    v_new.PLAN_SUM := :NEW.PLAN_SUM;
    v_new.DATE_CENA := :NEW.DATE_CENA;
    v_new.PLAN_ID := :NEW.PLAN_ID;
    v_new.PLAN_PER_ID := :NEW.PLAN_PER_ID;
    v_new.PLANSTRU_ID := :NEW.PLANSTRU_ID;
    v_new.DOG_ID := :NEW.DOG_ID;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.PAYFORM_ID := :NEW.PAYFORM_ID;
    v_new.CAT_CEN_ID := :NEW.CAT_CEN_ID;
    v_new.APPL_TAG := :NEW.APPL_TAG;

    -- Уникальный ID
    IF v_new.ID=0 OR v_new.ID IS NULL THEN
      SELECT SEQ_PLAN_POST.NEXTVAL INTO v_new.ID FROM DUAL;
    END IF;

    IF v_old.APPL_TAG='MASTER' THEN
      -- Проверка новых значений
      v_new.PLAN_CENA := NVL(v_new.PLAN_CENA,0);
      v_new.PLAN_VES := NVL(v_new.PLAN_VES,0);
      v_new.PLAN_SUM := v_new.PLAN_VES*v_new.PLAN_CENA;
	  v_new.DATE_CENA := TRUNC(v_new.DATE_CENA);
	END IF;  

    -- До обновления
    IF UPDATING() THEN
      NULL;
      IF v_old.ID<>v_new.ID THEN
        RAISE_APPLICATION_ERROR(For_Scripts.SG$PK_CHANGE, 'Нельзя менять PRIMARY KEY');
      END IF;
      IF v_old.PLAN_ID<>v_new.PLAN_ID THEN
        RAISE_APPLICATION_ERROR(For_Scripts.SG$FK_CHANGE, 'Нельзя менять план. Удалите запись и введите заново!');
      END IF;
      IF v_old.PLAN_PER_ID<>v_new.PLAN_PER_ID THEN
        RAISE_APPLICATION_ERROR(For_Scripts.SG$FK_CHANGE, 'Нельзя менять плановый период. Удалите запись и введите заново!');
      END IF;
--      IF v_old.DOG_ID<>v_new.DOG_ID THEN
--        RAISE_APPLICATION_ERROR(For_Scripts.SG$FK_CHANGE, 'Нельзя менять договор. Удалите запись и введите заново!');
--      END IF;
--      IF v_old.PROD_ID_NPR<>v_new.PROD_ID_NPR THEN
--        RAISE_APPLICATION_ERROR(For_Scripts.SG$FK_CHANGE, 'Нельзя менять продукт. Удалите запись и введите заново!');
--      END IF;
--      IF v_old.PLANSTRU_ID<>v_new.PLANSTRU_ID THEN
--        RAISE_APPLICATION_ERROR(For_Scripts.SG$FK_CHANGE, 'Нельзя менять позицию плана. Удалите запись и введите заново!');
--        NULL;
--      END IF;
    END IF;

    -- До добавления
    IF INSERTING() THEN
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.PLAN_CENA := v_new.PLAN_CENA;
    :NEW.PLAN_VES := v_new.PLAN_VES;
    :NEW.PLAN_SUM := v_new.PLAN_SUM;
    :NEW.DATE_CENA := v_new.DATE_CENA;
    :NEW.PLAN_ID := v_new.PLAN_ID;
    :NEW.PLAN_PER_ID := v_new.PLAN_PER_ID;
    :NEW.PLANSTRU_ID := v_new.PLANSTRU_ID;
    :NEW.DOG_ID := v_new.DOG_ID;
    :NEW.PROD_ID_NPR := v_new.PROD_ID_NPR;
    :NEW.PAYFORM_ID := v_new.PAYFORM_ID;
    :NEW.CAT_CEN_ID := v_new.CAT_CEN_ID;
    :NEW.APPL_TAG := v_new.APPL_TAG;
  END IF;
END;
/


