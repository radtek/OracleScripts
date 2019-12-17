--
-- TRG_AIUDR_REESTR_IN  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_AIUDR_REESTR_IN
AFTER INSERT OR DELETE OR UPDATE
ON MASTER.REESTR_IN
FOR EACH ROW
BEGIN
  -- ��������� ���-�� � ���� � ��������� ���������
  IF INSERTING() THEN
    UPDATE SVED_IN 
	   SET SVED_CNT=NVL(SVED_CNT,0)+1,  
	       SVED_VES=NVL(SVED_VES,0)+NVL(:NEW.VES,0),
	       VES_NETTO=NVL(VES_NETTO,0)+NVL(:NEW.VES_NETTO,0),  
	       VES_KVIT=NVL(VES_KVIT,0)+NVL(:NEW.VES_KVIT,0),  
	       VES_NETTO_KVIT=NVL(VES_NETTO_KVIT,0)+NVL(:NEW.VES_NETTO_KVIT,0)  
 	 WHERE ID=:NEW.SVED_IN_ID;	     
  END IF;	
  IF DELETING() THEN
    UPDATE SVED_IN 
	   SET SVED_CNT=NVL(SVED_CNT,0)-1, 
	       SVED_VES=NVL(SVED_VES,0)-NVL(:OLD.VES,0),
	       VES_NETTO=NVL(VES_NETTO,0)-NVL(:OLD.VES_NETTO,0),  
	       VES_KVIT=NVL(VES_KVIT,0)-NVL(:OLD.VES_KVIT,0),  
	       VES_NETTO_KVIT=NVL(VES_NETTO_KVIT,0)-NVL(:OLD.VES_NETTO_KVIT,0)  
	 WHERE ID=:OLD.SVED_IN_ID;	   
  END IF;
  IF UPDATING('VES') OR UPDATING('VES_NETTO') OR UPDATING('VES_KVIT') OR UPDATING('VES_NETTO_KVIT') OR UPDATING('P_VOD_KVIT') OR UPDATING('P_SOL_KVIT') OR UPDATING('P_DIRT_KVIT') THEN
    UPDATE SVED_IN 
	   SET SVED_VES=NVL(SVED_VES,0)-NVL(:OLD.VES,0)+NVL(:NEW.VES,0),
	       VES_NETTO=NVL(VES_NETTO,0)-NVL(:OLD.VES_NETTO,0)+NVL(:NEW.VES_NETTO,0),  
	       VES_KVIT=NVL(VES_KVIT,0)-NVL(:OLD.VES_KVIT,0)+NVL(:NEW.VES_KVIT,0),  
	       VES_NETTO_KVIT=NVL(VES_NETTO_KVIT,0)-NVL(:OLD.VES_NETTO_KVIT,0)+NVL(:NEW.VES_NETTO_KVIT,0)  
	 WHERE ID=:NEW.SVED_IN_ID; 
  END IF;	 
END;
/


