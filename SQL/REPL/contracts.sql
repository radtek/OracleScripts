CREATE OR REPLACE TRIGGER "PARUS".T_CONTRACTS_BDELETE
before delete on CONTRACTS for each row
begin
/* регистрация события */
P_CONTRACTS_IUD( :old.RN,'D',:old.COMPANY, :old.DOC_TYPE, :old.DOC_PREF, :old.DOC_NUMB, :old.DOC_DATE,
:old.AGENT, :old.STATUS, :old.CONFIRM_DATE, :old.CLOSE_DATE);
end;
/
