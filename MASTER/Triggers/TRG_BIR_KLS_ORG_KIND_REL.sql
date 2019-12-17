--
-- TRG_BIR_KLS_ORG_KIND_REL  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIR_KLS_ORG_KIND_REL
BEFORE INSERT
ON MASTER.KLS_ORG_KIND_RELATIONS
FOR EACH ROW
DECLARE
tmpVar NUMBER;
BEGIN
   tmpVar := 0;
if :new.id is null or :new.id=0 then
   Select seq_kls_org_kind_relations.NextVal into tmpVar from dual;
   :NEW.id := tmpVar;
end if;
END trg_bir_kls_org_kind_rel;
/


