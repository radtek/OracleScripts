CREATE OR REPLACE TRIGGER "PARUS".T_DICACCFO_BUPDATE_REPL_SNP
before update on DICACCFO for each row
declare
vTMP NUMBER;
begin
/* проверка на изменение CRN */
if not (:new.CRN = :old.CRN) then
  BEGIN
    SELECT CRN INTO vTMP
	  FROM SNP_REPL.V_CATALOG_LIST
	 WHERE DOC_TYPE='AccountFactOutput' AND CRN=:NEW.CRN;
    -- Зафиксирован перенос в каталог для Архангельска
 	-- Имитируем обновление спецификаций и связей
	PR_REPLICATE_DOCUMENT_SNP(pUNITCODE=>'AccountFactOutput',pTABLENAME=>'DICACCFO',pTABLERN=>:new.RN,pSELF=>0,pCOMMIT=>0);
  EXCEPTION
    WHEN OTHERS THEN
	  NULL;
  END;
end if;

end;
/
