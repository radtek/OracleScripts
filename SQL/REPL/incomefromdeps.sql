CREATE OR REPLACE TRIGGER T_INCOMEFROMDEPS_BDELETE
before delete on INCOMEFROMDEPS for each row
begin
if :old.DOC_STATE != 0 AND USER<>'SNP_REPL' then
P_EXCEPTION(0,'�������� ��ࠡ�⠭���� ���㬥�� �������⨬�.');
null;
end if;
/* ॣ������ ᮡ��� */
P_INCOMEFROMDEPS_IUD_EVENT( :old.RN, 'D', :old.COMPANY, :old.DOC_TYPE, :old.DOC_PREF, :old.DOC_NUMB );
end;
/



CREATE OR REPLACE TRIGGER PARUS.T_INCOMEFROMDEPSSPEC_BDELETE
before delete on INCOMEFROMDEPSSPEC for each row
declare
nDOC_STATE      number( 1 );
TABLE_MUTATING    exception;
NO_STATEMENT_PARSED	exception;
pragma exception_init( TABLE_MUTATING,-04091 );
pragma exception_init( NO_STATEMENT_PARSED,-01003 );
begin
P_LINKSALL_CHECK (:old.RN, :old.COMPANY, 'IncomFromDepsSpecs');
begin
select  DOC_STATE
into nDOC_STATE
from INCOMEFROMDEPS
where RN = :old.PRN;
if nDOC_STATE = 2 AND USER<>'SNP_REPL' then
P_EXCEPTION(0,'����饭� 㤠���� ��ப� ᯥ�䨪�樨 ���㬥��, ��ࠡ�⠭���� ��� 䠪�.');
end if;
if nDOC_STATE = 1 and (:old.QUANT_PLAN != 0 or :old.QUANT_PLAN_ALT != 0) AND USER<>'SNP_REPL' then
P_EXCEPTION(0,'����饭� 㤠���� ��ப� ᯥ�䨪�樨 � ������� ������⢮� ⮢��, �� ࠢ�� ���, ���㬥��, ��ࠡ�⠭���� ��� ����.');
end if;
/* ॣ������ ᮡ��� */
P_INCOMEFROMDEPSSPEC_IUD_EVENT(:old.RN,'D',:old.COMPANY,:old.PRN,:old.NOMMODIF,:old.PACK,:old.SUPPLY,
:old.SERNUMB, :old.COUNTRY, :old.GTD);
exception
when TABLE_MUTATING or NO_STATEMENT_PARSED then null;
end;
end;
/


CREATE OR REPLACE TRIGGER T_INCOMEFROMDEPSSPEC_BINSERT
before insert on INCOMEFROMDEPSSPEC for each row
declare
nDOC_STATE  INCOMEFROMDEPS.DOC_STATE%TYPE;
nSTORE      PKG_STD.tREF;
nRESULT     PKG_STD.tNUMBER;
begin
/* ���뢠��� ��ࠬ��஢ master-����� */
select CRN, DOC_STATE, STORE
into :new.CRN, nDOC_STATE, nSTORE
from INCOMEFROMDEPS
where RN = :new.PRN;
/* ���뢠��� ��ࠬ��஢ master-����� */
if (nDOC_STATE = 2) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'���������� ᯥ�䨪�権 � ���㬥�� ��ࠡ�⠭�� ��� 䠪� �������⨬�.');
end if;
/* �஢�ઠ ���४⭮�� ����� */
P_INCOMFROMDEPSP_CHECK_RECORD( 0, :new.NOMMODIF, :new.PACK, :new.ARTICLE, nSTORE, :new.CELL, :new.QUANT_FACT,
:new.QUANT_FACT_ALT, :new.QUANT_PLAN, :new.QUANT_PLAN_ALT, nRESULT );
/* ॣ������ ᮡ��� */
P_INCOMEFROMDEPSSPEC_IUD_EVENT( :new.RN,'I',:new.COMPANY,:new.PRN,:new.NOMMODIF,:new.PACK,:new.SUPPLY,
:new.SERNUMB, :new.COUNTRY, :new.GTD );
end;
/