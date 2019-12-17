CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCSACC_BUPDATE_REPL_SNP
before update on BANKDOCSACC for each row
begin
/* ॣ������ ᮡ��� */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('BANKDOCSACC',:NEW.PRN,USER,SYSDATE,'U','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCSACC_BINSERT_REPL_SNP
before insert on BANKDOCSACC for each row
begin
/* ॣ������ ᮡ��� */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('BANKDOCSACC',:NEW.PRN,USER,SYSDATE,'I','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCSACC_BDELETE_REPL_SNP
before delete on BANKDOCSACC for each row
begin
/* ॣ������ ᮡ��� */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('BANKDOCSACC',:OLD.PRN,USER,SYSDATE,'D','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_S_BDELETE_REPL_SNP
before delete on BANKDOCS_SUMM for each row
begin
/* ॣ������ ᮡ��� */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('BANKDOCS_SUMM',:OLD.PRN,USER,SYSDATE,'D','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_S_BINSERT_REPL_SNP
before insert on BANKDOCS_SUMM for each row
begin
/* ॣ������ ᮡ��� */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('BANKDOCS_SUMM',:NEW.PRN,USER,SYSDATE,'I','?'); 
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_S_BUPDATE_REPL_SNP
before update on BANKDOCS_SUMM for each row
begin
/* ॣ������ ᮡ��� */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('BANKDOCS_SUMM',:NEW.PRN,USER,SYSDATE,'U','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_BUPDATE_REPL_SNP
before update on BANKDOCS for each row
declare
vTMP NUMBER;
begin
/* �஢�ઠ �� ��������� CRN */
if not (:new.CRN = :old.CRN) then
  BEGIN
    SELECT CRN INTO vTMP
	  FROM SNP_REPL.V_CATALOG_LIST
	 WHERE DOC_TYPE='BankDocuments' AND CRN=:NEW.CRN;
    -- ��䨪�஢�� ��७�� � ��⠫�� ��� ��堭����᪠
 	-- �����㥬 ���������� ᯥ�䨪�権 � �痢�
	PR_REPLICATE_DOCUMENT_SNP(pUNITCODE=>'BankDocuments',pTABLENAME=>'BANKDOCS',pTABLERN=>:new.RN,pSELF=>0,pCOMMIT=>0);
  EXCEPTION
    WHEN OTHERS THEN
	  NULL;
  END;
end if;

end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_BUPDATE
before update on BANKDOCS for each row
declare
nRESULT  PKG_STD.tNUMBER;
begin
/* �஢�ઠ ����������� ���祭�� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� BANKDOCS �������⨬�.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� BANKDOCS �������⨬�.' );
end if;
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :old.COMPANY,:old.BANK_DOCDATE );
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :new.COMPANY,:new.BANK_DOCDATE );
END IF;
/* ���४�஢�� ����� ���㬥�� */
P_BANKDOCS_CORRNUMB( :new.BANK_DOCPREF,:new.BANK_DOCNUMB,
:new.BANK_DOCPREF,:new.BANK_DOCNUMB );

if USER<>'SNP_REPL' then

if ( cmp_num ( :new.BANK_DOCTYPE    , :old.BANK_DOCTYPE ) = 0 ) or
( cmp_vc2 ( :new.BANK_DOCPREF    , :old.BANK_DOCPREF ) = 0 ) or
( cmp_vc2 ( :new.BANK_DOCNUMB    , :old.BANK_DOCNUMB ) = 0 ) or
( cmp_dat ( :new.BANK_DOCDATE    , :old.BANK_DOCDATE ) = 0 ) or
( cmp_num ( :new.VALID_DOCTYPE   , :old.VALID_DOCTYPE ) = 0 ) or
( cmp_vc2 ( :new.VALID_DOCNUMB   , :old.VALID_DOCNUMB ) = 0 ) or
( cmp_dat ( :new.VALID_DOCDATE   , :old.VALID_DOCDATE ) = 0 ) or
( cmp_num ( :new.AGENT_FROM      , :old.AGENT_FROM ) = 0 ) or
( cmp_num ( :new.AGENT_TO        , :old.AGENT_TO ) = 0 ) or
( cmp_num ( :new.AGENT_FROM_ACC  , :old.AGENT_FROM_ACC ) = 0 ) or
( cmp_num ( :new.AGENT_TO_ACC    , :old.AGENT_TO_ACC ) = 0 ) or
( cmp_num ( :new.BALUNIT         , :old.BALUNIT ) = 0 ) or
( cmp_num ( :new.TYPE_OPER       , :old.TYPE_OPER ) = 0 ) or
( cmp_num ( :new.PAY_SUM         , :old.PAY_SUM ) = 0 ) or
( cmp_num ( :new.TAX_SUM         , :old.TAX_SUM ) = 0 ) or
( cmp_num ( :new.PERCENT_TAX_SUM , :old.PERCENT_TAX_SUM ) = 0 ) or
( cmp_num ( :new.CURRENCY        , :old.CURRENCY ) = 0 ) or
( cmp_vc2 ( :new.PAY_TYPE        , :old.PAY_TYPE ) = 0 ) or
( cmp_vc2 ( :new.PAY_KIND        , :old.PAY_KIND ) = 0 ) or
( cmp_vc2 ( :new.FROM_NUMB       , :old.FROM_NUMB ) = 0 ) or
( cmp_dat ( :new.FROM_DATE       , :old.FROM_DATE ) = 0 ) or
( cmp_num ( :new.UNALLOTTED_SUM  , :old.UNALLOTTED_SUM ) = 0 ) or
( cmp_num ( :new.INCOMECLASS     , :old.INCOMECLASS ) = 0 ) or
( cmp_num ( :new.TRANSREASON     , :old.TRANSREASON ) = 0 ) or
( cmp_vc2 ( :new.TRANSPERIOD     , :old.TRANSPERIOD ) = 0 ) or
( cmp_vc2 ( :new.TRANSNUMBER     , :old.TRANSNUMBER ) = 0 ) or
( cmp_dat ( :new.TRANSDATE       , :old.TRANSDATE ) = 0 ) or
( cmp_num ( :new.TRANSTYPE       , :old.TRANSTYPE ) = 0 )  then
if OBJECT_EXISTS('BANKDOCSPEC', 'TABLE') <> 0 and
( cmp_num ( :new.BANK_DOCTYPE    , :old.BANK_DOCTYPE ) = 1 ) and
( cmp_vc2 ( :new.BANK_DOCPREF    , :old.BANK_DOCPREF ) = 1 ) and
( cmp_vc2 ( :new.BANK_DOCNUMB    , :old.BANK_DOCNUMB ) = 1 ) and
( cmp_dat ( :new.BANK_DOCDATE    , :old.BANK_DOCDATE ) = 1 ) and
( cmp_num ( :new.VALID_DOCTYPE   , :old.VALID_DOCTYPE ) = 1 ) and
( cmp_vc2 ( :new.VALID_DOCNUMB   , :old.VALID_DOCNUMB ) = 1 ) and
( cmp_dat ( :new.VALID_DOCDATE   , :old.VALID_DOCDATE ) = 1 ) and
( cmp_num ( :new.AGENT_FROM      , :old.AGENT_FROM ) = 1 ) and
( cmp_num ( :new.AGENT_TO        , :old.AGENT_TO ) = 1 ) and
( cmp_num ( :new.AGENT_FROM_ACC  , :old.AGENT_FROM_ACC ) = 1 ) and
( cmp_num ( :new.AGENT_TO_ACC    , :old.AGENT_TO_ACC ) = 1 ) and
( cmp_num ( :new.BALUNIT         , :old.BALUNIT ) = 1 ) and
( cmp_num ( :new.TYPE_OPER       , :old.TYPE_OPER ) = 1 ) and
( cmp_num ( :new.CURRENCY        , :old.CURRENCY ) = 1 ) and
( cmp_vc2 ( :new.PAY_TYPE        , :old.PAY_TYPE ) = 1 ) and
( cmp_vc2 ( :new.PAY_KIND        , :old.PAY_KIND ) = 1 ) and
( cmp_vc2 ( :new.FROM_NUMB       , :old.FROM_NUMB ) = 1 ) and
( cmp_dat ( :new.FROM_DATE       , :old.FROM_DATE ) = 1 ) and
( cmp_num ( :new.INCOMECLASS     , :old.INCOMECLASS ) = 1 ) and
( cmp_num ( :new.TRANSREASON     , :old.TRANSREASON ) = 1 ) and
( cmp_vc2 ( :new.TRANSPERIOD     , :old.TRANSPERIOD ) = 1 ) and
( cmp_vc2 ( :new.TRANSNUMBER     , :old.TRANSNUMBER ) = 1 ) and
( cmp_dat ( :new.TRANSDATE       , :old.TRANSDATE ) = 1 ) and
( cmp_num ( :new.TRANSTYPE       , :old.TRANSTYPE ) = 1 ) then
begin
P_LINKSALL_FIND_UNITCODE_LINK(0, :new.COMPANY, 'BankDocuments', :new.RN, 'EconomicOperations', nRESULT);
/* �᫠������ �痢� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET_IN('BankDocuments');
/* �஢�ઠ �裡 � ���㬥�⠬� */
P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BankDocuments' );
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
exception
when OTHERS then
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
raise;
end;
else
/* �஢�ઠ �裡 � ���㬥�⠬� */
P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'BankDocuments' );
end if;
end if;

end if;

/* ��ࠢ����� ��� ��ப ᯥ�䨪�樨 */
if :new.BALUNIT is not null then
begin
/* �᫠������ �痢� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET('BankDocumentsSpecs');
UPDATE_NFIELD_BY_NFIELD('BANKDOCSPEC','BALUNIT',:new.BALUNIT,'PRN',:old.RN);
/* ����⠭������� �痢� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
exception
when OTHERS then
/* ����⠭������� �痢� */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
raise;
end;
end if;
/* ��������� ���� ��ࠢ�� � ����, �� ᬥ�� ����� ��ࠢ�� */
if :new.CBS_STATE <> :old.CBS_STATE then
if :new.CBS_STATE =0 then
:new.CBS_DATE :=null; -- ������ � ���ﭨ� "�����"
else
:new.CBS_DATE := trunc(sysdate);
end if;
end if;
/* ॣ������ ᮡ��� */
P_BANKDOCS_IUD_EVENT( :new.RN,'U',:new.COMPANY,
:new.BANK_DOCTYPE,:new.BANK_DOCPREF,:new.BANK_DOCNUMB );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_BINSERT
before insert on BANKDOCS for each row
begin
IF USER<>'SNP_REPL' THEN
  -- �஢�ઠ �������� ��ਮ��
  P_APERIODS_CLOSED( :new.COMPANY,:new.BANK_DOCDATE );
END IF;  
-- ���४�஢�� ����� ���㬥��
P_BANKDOCS_CORRNUMB( :new.BANK_DOCPREF,:new.BANK_DOCNUMB,
:new.BANK_DOCPREF,:new.BANK_DOCNUMB );
-- ॣ������ ᮡ���
P_BANKDOCS_IUD_EVENT(:new.RN, 'I', :new.COMPANY, :new.BANK_DOCTYPE, :new.BANK_DOCPREF, :new.BANK_DOCNUMB);
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_BANKDOCS_BDELETE
before delete on BANKDOCS for each row
begin
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :old.COMPANY,:old.BANK_DOCDATE );
  /* �஢�ઠ �裡 � ���㬥�⠬� */
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'BankDocuments' );
END IF;  
/* ॣ������ ᮡ��� */
P_BANKDOCS_IUD_EVENT( :old.RN,'D',:old.COMPANY,
:old.BANK_DOCTYPE,:old.BANK_DOCPREF,:old.BANK_DOCNUMB );
end;
/
