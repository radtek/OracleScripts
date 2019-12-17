--
-- TRG_BIUDR_KVIT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_KVIT
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.KVIT FOR EACH ROW
DECLARE
  v_tmp NUMBER;
BEGIN

  -- До удаления
  IF DELETING() AND NVL(:OLD.BILL_ID,0)<>0 THEN
     --raise_application_error( FOR_SCRIPTS.SG$ERROR, 'Невозможно удалить вагон, входящий в счет-фактуру!');
     null;
  END IF;

  -- определить ID накладной
  IF INSERTING() OR 
     (UPDATING('DATE_KVIT') AND :NEW.DATE_KVIT<>:OLD.DATE_KVIT) OR 
	 (UPDATING('NUM_KVIT') AND :NEW.NUM_KVIT<>:OLD.NUM_KVIT) THEN
    if :new.date_otgr<to_date('01.04.2008','dd.mm.yyyy') then 
      :NEW.ttn_id:=to_number(to_char(:NEW.date_kvit,'yyyymmdd')||lpad(to_char(:NEW.num_kvit),7,'0'));
    end if;  
  END IF;
  
  -- Попытка обновить запись, загруженную в ИСУ
  IF UPDATING() AND :OLD.IS_LOADED in (8,9) THEN

    IF :OLD.TTN_ID<>:NEW.TTN_ID OR
       :OLD.NUM_KVIT<>:NEW.NUM_KVIT OR
       :OLD.DATE_OTGR<>:NEW.DATE_OTGR OR
       :OLD.NUM_CIST<>:NEW.NUM_CIST OR
       NVL(:OLD.TARIF,0)<>NVL(:NEW.TARIF,0) OR
       NVL(:OLD.TARIF19,0)<>NVL(:NEW.TARIF19,0) OR
       NVL(:OLD.TARIF_GUARD,0)<>NVL(:NEW.TARIF_GUARD,0) OR
       NVL(:OLD.VES_BRUTTO,0)<>NVL(:NEW.VES_BRUTTO,0) OR
       NVL(:OLD.VES,0)<>NVL(:NEW.VES,0) OR
       NVL(:OLD.KOL_ED,0)<>NVL(:NEW.KOL_ED,0) OR
--       NVL(:OLD.TARIF_NDS,0)<>NVL(:NEW.TARIF_NDS,0) OR
--       NVL(:OLD.TARIF_GUARD_NDS,0)<>NVL(:NEW.TARIF_GUARD_NDS,0) OR
       :OLD.DATE_KVIT<>:NEW.DATE_KVIT OR
       :OLD.NUM_DOVER||' '<>:NEW.NUM_DOVER||' ' OR
       NVL(:OLD.DATE_DOVER,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(:NEW.DATE_DOVER,TO_DATE('01.01.1900','dd.mm.yyyy')) OR
       :OLD.FIO_DRIVER||' '<>:NEW.FIO_DRIVER||' ' OR
	   (:OLD.FLG_OPERDATA<>:NEW.FLG_OPERDATA AND :OLD.FLG_OPERDATA=1) OR -- раскредитовывание
       :OLD.NOM_ZD||' '<>:NEW.NOM_ZD||' ' OR
       NVL(:OLD.VAGOWNER_ID,0)<>NVL(:NEW.VAGOWNER_ID,0) OR
       :OLD.PROD_ID_NPR||' '<>:NEW.PROD_ID_NPR||' ' OR
       NVL(:OLD.VAGONTYPE_ID,0)<>NVL(:NEW.VAGONTYPE_ID,0) OR
       NVL(:OLD.VES_ED,0)<>NVL(:NEW.VES_ED,0) OR
--       NVL(:OLD.BILL_ID,0)<>NVL(:NEW.BILL_ID,0) OR
--       NVL(:OLD.NUM_AKT,0)<>NVL(:NEW.NUM_AKT,0) OR
--       NVL(:OLD.BILL_POS_ID,0)<>NVL(:NEW.BILL_POS_ID,0) OR
--       :OLD.PROTO_NUM||' '<>:NEW.PROTO_NUM||' ' OR
--       NVL(:OLD.PROTO_DATE,TO_DATE('01.01.1900','dd.mm.yyyy'))<>NVL(:NEW.PROTO_DATE,TO_DATE('01.01.1900','dd.mm.yyyy')) OR
       NVL(:OLD.AXES,0)<>NVL(:NEW.AXES,0) THEN

      :NEW.IS_LOADED:=1;
	END IF;
	  
  END IF;

  IF UPDATING() THEN
    IF :NEW.TARIF=0 THEN
	  :NEW.TARIF_NDS:=0;
	END IF;   
    IF :NEW.TARIF_GUARD=0 THEN
	  :NEW.TARIF_GUARD_NDS:=0;
	END IF;
	IF :NEW.SUM_VOZN11=0 THEN
	  :NEW.SUM_VOZN11_NDS:=0;
	END IF;
	IF :NEW.SUM_VOZN12=0 THEN
	  :NEW.SUM_VOZN12_NDS:=0;
	END IF;
	IF :NEW.SUM_PROD=0 THEN
	  :NEW.SUM_PROD_NDS:=0;
	END IF;
  END IF;
  	
  -- Попытка добавить новую запись
  IF INSERTING() THEN
    :NEW.IS_LOADED:=0;
  END IF;

  
END;
/


