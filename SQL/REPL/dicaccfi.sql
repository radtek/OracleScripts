CREATE OR REPLACE TRIGGER "PARUS".T_DICACCFI_BUPDATE_REPL_SNP
before update on DICACCFI for each row
declare
vTMP NUMBER;
begin
/* �஢�ઠ �� ��������� CRN */
if not (:new.CRN = :old.CRN) then
  BEGIN
    SELECT CRN INTO vTMP
	  FROM SNP_REPL.V_CATALOG_LIST
	 WHERE DOC_TYPE='AccountFactInput' AND CRN=:NEW.CRN;
    -- ��䨪�஢�� ��७�� � ��⠫�� ��� ��堭����᪠
 	-- �����㥬 ���������� ᯥ�䨪�権 � �痢�
	PR_REPLICATE_DOCUMENT_SNP(pUNITCODE=>'AccountFactInput',pTABLENAME=>'DICACCFI',pTABLERN=>:new.RN,pSELF=>0,pCOMMIT=>0);
  EXCEPTION
    WHEN OTHERS THEN
	  NULL;
  END;
end if;

end;
/
