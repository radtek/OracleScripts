CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCSACC_BDELETE_REPL_SNP
before delete on CASHDOCSACC for each row
begin
/* регистрация события */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('CASHDOCSACC',:OLD.PRN,USER,SYSDATE,'D','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCSACC_BINSERT_REPL_SNP
before insert on CASHDOCSACC for each row
begin
/* регистрация события */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('CASHDOCSACC',:NEW.PRN,USER,SYSDATE,'I','?'); 
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCSACC_BUPDATE_REPL_SNP
before update on CASHDOCSACC for each row
begin
/* регистрация события */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('CASHDOCSACC',:NEW.PRN,USER,SYSDATE,'U','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCS_S_BDELETE_REPL_SNP
before delete on CASHDOCS_SUMM for each row
begin
/* регистрация события */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('CASHDOCS_SUMM',:OLD.PRN,USER,SYSDATE,'D','?'); 
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCS_S_BINSERT_REPL_SNP
before insert on CASHDOCS_SUMM for each row
begin
/* регистрация события */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('CASHDOCS_SUMM',:NEW.PRN,USER,SYSDATE,'I','?'); 
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCS_S_BUPDATE_REPL_SNP
before update on CASHDOCS_SUMM for each row
begin
/* регистрация события */
INSERT INTO UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
VALUES ('CASHDOCS_SUMM',:NEW.PRN,USER,SYSDATE,'U','?'); 
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCS_BDELETE
before delete on CASHDOCS for each row
begin
IF USER<>'SNP_REPL' THEN
  /* проверка закрытости периода */
  P_APERIODS_CLOSED( :old.COMPANY,:old.CASH_DOCDATE );
  /* проверка связи с документами */
  P_LINKSALL_CHECK( :old.RN,:old.COMPANY,'CashDocuments' );
END IF;  
/* регистрация события */
P_CASHDOCS_IUD_EVENT( :old.RN,'D',:old.COMPANY,:old.CASH_DOCTYPE,
:old.CASH_DOCPREF,:old.CASH_DOCNUMB );
end;
/




CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCS_BINSERT
before insert on CASHDOCS for each row
begin
IF USER<>'SNP_REPL' THEN
  -- проверка закрытости периода
  P_APERIODS_CLOSED(:new.COMPANY,:new.CASH_DOCDATE);
END IF;  
-- корректировка номера документа
P_CASHDOCS_CORRNUMB(:new.CASH_DOCPREF, :new.CASH_DOCNUMB,
:new.CASH_DOCPREF, :new.CASH_DOCNUMB );
-- регистрация события
P_CASHDOCS_IUD_EVENT( :new.RN,'I',:new.COMPANY,:new.CASH_DOCTYPE,
:new.CASH_DOCPREF,:new.CASH_DOCNUMB );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CASHDOCS_BUPDATE
before update on CASHDOCS for each row
declare
UNLT_SUM     PKG_STD.tSUMM;
begin
/* проверка неизменности значений полей */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы CASHDOCS недопустимо.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы CASHDOCS недопустимо.' );
end if;
IF USER<>'SNP_REPL' THEN
  /* проверка закрытости периода */
  P_APERIODS_CLOSED( :old.COMPANY,:old.CASH_DOCDATE );
  P_APERIODS_CLOSED( :new.COMPANY,:new.CASH_DOCDATE );
END IF;
/* корректировка номера документа */
P_CASHDOCS_CORRNUMB( :new.CASH_DOCPREF,:new.CASH_DOCNUMB,
:new.CASH_DOCPREF,:new.CASH_DOCNUMB );

if USER<>'SNP_REPL' then

if ( cmp_num ( :new.CASH_DOCTYPE    , :old.CASH_DOCTYPE ) = 0 ) or
( cmp_vc2 ( :new.CASH_DOCPREF    , :old.CASH_DOCPREF ) = 0 ) or
( cmp_vc2 ( :new.CASH_DOCNUMB    , :old.CASH_DOCNUMB ) = 0 ) or
( cmp_dat ( :new.CASH_DOCDATE    , :old.CASH_DOCDATE ) = 0 ) or
( cmp_num ( :new.VALID_DOCTYPE   , :old.VALID_DOCTYPE ) = 0 ) or
( cmp_vc2 ( :new.VALID_DOCNUMB   , :old.VALID_DOCNUMB ) = 0 ) or
( cmp_dat ( :new.VALID_DOCDATE   , :old.VALID_DOCDATE ) = 0 ) or
( cmp_num ( :new.AGENT_FROM      , :old.AGENT_FROM ) = 0 ) or
( cmp_num ( :new.AGENT_TO        , :old.AGENT_TO ) = 0 ) or
( cmp_num ( :new.BALUNIT         , :old.BALUNIT ) = 0 ) or
( cmp_num ( :new.TYPE_OPER       , :old.TYPE_OPER ) = 0 ) or
( cmp_num ( :new.PAY_SUM         , :old.PAY_SUM ) = 0 ) or
( cmp_num ( :new.TAX_SUM         , :old.TAX_SUM ) = 0 ) or
( cmp_num ( :new.PERCENT_TAX_SUM , :old.PERCENT_TAX_SUM ) = 0 ) or
( cmp_num ( :new.CURRENCY        , :old.CURRENCY ) = 0 ) or
( cmp_num ( :new.UNALLOTTED_SUM  , :old.UNALLOTTED_SUM ) = 0 ) then
/* проверка связи с документами */
P_LINKSALL_CHECK( :new.RN,:new.COMPANY,'CashDocuments' );
end if;

end if;

/* исправление ПБЕ строк спецификации */
if :new.BALUNIT is not null then
begin
/* ослабление связей */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_SET('CashDocumentsSpecs');
/* исправление ПБЕ строк спецификации */
UPDATE_NFIELD_BY_NFIELD('CASHDOCSPEC','BALUNIT',:new.BALUNIT,'PRN',:old.RN);
/* восстановление связей */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
exception
when OTHERS then
/* восстановление связей */
PKG_DOCLINKS_SMART.P_PKG_DOCLINKS_CLEAR;
raise;
end;
end if;
/* регистрация события */
P_CASHDOCS_IUD_EVENT( :new.RN,'U',:new.COMPANY,:new.CASH_DOCTYPE,
:new.CASH_DOCPREF,:new.CASH_DOCNUMB );
end;
/
