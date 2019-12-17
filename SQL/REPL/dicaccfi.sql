CREATE OR REPLACE TRIGGER "PARUS".T_DICACCFI_BUPDATE_REPL_SNP
before update on DICACCFI for each row
declare
vTMP NUMBER;
begin
/* проверка на изменение CRN */
if not (:new.CRN = :old.CRN) then
  BEGIN
    SELECT CRN INTO vTMP
	  FROM SNP_REPL.V_CATALOG_LIST
	 WHERE DOC_TYPE='AccountFactInput' AND CRN=:NEW.CRN;
    -- Зафиксирован перенос в каталог для Архангельска
 	-- Имитируем обновление спецификаций и связей
	PR_REPLICATE_DOCUMENT_SNP(pUNITCODE=>'AccountFactInput',pTABLENAME=>'DICACCFI',pTABLERN=>:new.RN,pSELF=>0,pCOMMIT=>0);
  EXCEPTION
    WHEN OTHERS THEN
	  NULL;
  END;
end if;

end;
/
