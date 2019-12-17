CREATE OR REPLACE TRIGGER "PARUS".T_FACEACC_BUPDATE before update on FACEACC
for each row
declare
nPAY_NOTES_COUNT PKG_STD.tNUMBER;
begin
if (:new.RN != :old.RN ) then
P_EXCEPTION ( 0,'Модификация значения поля RN недопустима.');
end if;
if (:new.COMPANY != :old.COMPANY ) then
P_EXCEPTION ( 0,'Модификация значения поля COMPANY недопустима.');
end if;
:new.CREDIT_SUM  := round(:new.CREDIT_SUM, 2);
:new.BEGIN_SUM   := round(:new.BEGIN_SUM,  2);
:new.CURRENT_SUM := round(:new.CURRENT_SUM, 2);
:new.PLAN_SUM    := round(:new.PLAN_SUM, 2);
/* Установка флага прохождения операций */
if (:old.OPER_FLAG = 0) then
if (:new.CURRENT_SUM <> :old.CURRENT_SUM) then
:new.OPER_FLAG := 1;
end if;
end if;
if (:new.AGENT != :old.AGENT) then
P_EXCEPTION ( 0,'Модификация контрагента лицевого счета недопустима.');
end if;
if (:new.CURRENCY != :old.CURRENCY) then
P_EXCEPTION ( 0,'Модификация валюты лицевого счета недопустима.');
end if;
/* Установка флага дебетовый/кредитовый счет */
if (:new.CURRENT_SUM < 0) then
:new.ACC_TYPE := 0;
else
:new.ACC_TYPE := 1;
end if;
if (:new.PRN != :old.PRN ) then
P_EXCEPTION ( 0,'Недопустимо изменение родительского счета.');
end if;
if (:new.PRN is not null) then
if (:new.VALID_DOCTYPE != :old.VALID_DOCTYPE ) then
P_EXCEPTION ( 0,'Модификация типа документа для счета, созданного на основании соглашения о взаимозачетах, недопустима.');
end if;
if (:new.VALID_DOCNUMB != :old.VALID_DOCNUMB) then
P_EXCEPTION ( 0,'Модификация номера документа для счета, созданного на основании соглашения о взаимозачетах,недопустима.');
end if;
if (:new.VALID_DOCDATE != :old.VALID_DOCDATE) then
P_EXCEPTION ( 0,'Модификация даты документа для счета, созданного на основании соглашения о взаимозачетах, недопустима.');
end if;
end if;
if ( :new.PLAN_CLOSE_DATE is not null ) and ( trunc ( :new.PLAN_OPEN_DATE ) > trunc ( :new.PLAN_CLOSE_DATE ) ) then
P_EXCEPTION ( 0, 'Плановая дата закрытия лицевого счета не может быть меньше плановой даты открытия.' );
end if;
if ( :new.FACT_OPEN_DATE is not null and :new.FACT_CLOSE_DATE is not null ) and ( trunc ( :new.FACT_OPEN_DATE ) > trunc ( :new.FACT_CLOSE_DATE ) ) then
P_EXCEPTION ( 0, 'Фактическая дата закрытия лицевого счета не может быть меньше фактической даты открытия.' );
end if;
/* установка каталога detail-записей */
if ( not( :new.CRN = :old.CRN ) ) then
update_nfield_by_nfield( 'SERVCHARGES',    'CRN',:new.CRN,'FACEACC',:new.RN );
update_nfield_by_nfield( 'ENPACCOUNT',     'CRN',:new.CRN,'FACEACCRN',:new.RN );
update_nfield_by_nfield( 'FCACPAYPLANS',   'CRN',:new.CRN,'PRN',:new.RN );
update_nfield_by_nfield( 'FCACOPERPLANS',  'CRN',:new.CRN,'PRN',:new.RN );
update_nfield_by_nfield( 'FCACGRAPHPOINTS','CRN',:new.CRN,'PRN',:new.RN );
update_nfield_by_nfield( 'DEALPASSPORTS',  'CRN',:new.CRN,'PRN',:new.RN );
end if;
/*изменение сметы*/
if CMP_NUM(:new.BUDGEXPEND_SP,:old.BUDGEXPEND_SP) = 0 then
select count(RN)
into nPAY_NOTES_COUNT
from PAYNOTES
where FACEACC = :old.RN;
if nPAY_NOTES_COUNT > 0 then
P_EXCEPTION(0,'Невозможно изменить значение сметы/статьи сметы, так как по лицевому счету создан платеж.');
end if;
/* каскадное обновление сметы расходов для точек графика лицевого счета */
update FCACGRAPHPOINTS
set BUDGEXPEND_SP = :new.BUDGEXPEND_SP
where PRN = :new.RN;
end if;
/* регистрация события */
-- PSV для избежания регистрации пересчета суммовых полей
IF NOT ( 
     CMP_NUM(:OLD.RN,:NEW.RN)=1 AND
     CMP_NUM(:OLD.CRN,:NEW.CRN)=1 AND
	 CMP_NUM(:OLD.COMPANY,:NEW.COMPANY)=1 AND
	 CMP_NUM(:OLD.PRN,:NEW.PRN)=1 AND 
	 CMP_NUM(:OLD.AGENT,:NEW.AGENT)=1 AND
	 CMP_NUM(:OLD.FINERULE,:NEW.FINERULE)=1 AND
	 CMP_VC2(:OLD.NUMB,:NEW.NUMB)=1 AND
	 CMP_NUM(:OLD.ACC_TYPE,:NEW.ACC_TYPE)=1 AND
	 CMP_NUM(:OLD.ACC_KIND,:NEW.ACC_KIND)=1 AND 
	 CMP_NUM(:OLD.OPER_FLAG,:NEW.OPER_FLAG)=1 AND 
	 CMP_NUM(:OLD.VALID_DOCTYPE,:NEW.VALID_DOCTYPE)=1 AND
	 CMP_VC2(:OLD.VALID_DOCNUMB,:NEW.VALID_DOCNUMB)=1 AND 
	 CMP_DAT(:OLD.VALID_DOCDATE,:NEW.VALID_DOCDATE)=1 AND
	 CMP_DAT(:OLD.PLAN_CLOSE_DATE,:NEW.PLAN_CLOSE_DATE)=1 AND
	 CMP_DAT(:OLD.FACT_CLOSE_DATE,:NEW.FACT_CLOSE_DATE)=1 AND 
	 CMP_NUM(:OLD.EXECUTIVE,:NEW.EXECUTIVE)=1 AND
	 CMP_NUM(:OLD.CURRENCY,:NEW.CURRENCY)=1 AND
	 CMP_NUM(:OLD.CREDIT_SUM,:NEW.CREDIT_SUM)=1 AND
	 CMP_NUM(:OLD.BEGIN_SUM,:NEW.BEGIN_SUM)=1 AND
	 CMP_VC2(:OLD.SPEC_MARK1,:NEW.SPEC_MARK1)=1 AND
	 CMP_VC2(:OLD.SPEC_MARK2,:NEW.SPEC_MARK2)=1 AND 
	 CMP_VC2(:OLD.SPEC_MARK3,:NEW.SPEC_MARK3)=1 AND 
	 CMP_VC2(:OLD.SPEC_MARK4,:NEW.SPEC_MARK4)=1 AND 
	 CMP_VC2(:OLD.SPEC_MARK5,:NEW.SPEC_MARK5)=1 AND 
     CMP_VC2(:OLD.NOTE,:NEW.NOTE)=1 AND
	 CMP_NUM(:OLD.ACC_CLASS,:NEW.ACC_CLASS)=1 AND
	 CMP_NUM(:OLD.SERV_SUM,:NEW.SERV_SUM)=1 AND
	 CMP_NUM(:OLD.SERV_PERCENT,:NEW.SERV_PERCENT)=1 AND
	 CMP_NUM(:OLD.FCACGR,:NEW.FCACGR)=1 AND
	 CMP_NUM(:OLD.AGNACC,:NEW.AGNACC)=1 AND 
	 CMP_NUM(:OLD.AGNFI,:NEW.AGNFI)=1 AND
	 CMP_NUM(:OLD.AGNFO,:NEW.AGNFO)=1 AND
	 CMP_DAT(:OLD.PLAN_OPEN_DATE,:NEW.PLAN_OPEN_DATE)=1 AND
	 CMP_DAT(:OLD.FACT_OPEN_DATE,:NEW.FACT_OPEN_DATE)=1 AND
	 CMP_NUM(:OLD.SIGN_CONTRACT,:NEW.SIGN_CONTRACT)=1 AND
	 CMP_NUM(:OLD.PLAN_SUM,:NEW.PLAN_SUM)=1 AND
	 CMP_NUM(:OLD.ORDER_SIGN,:NEW.ORDER_SIGN)=1 AND
	 CMP_NUM(:OLD.SUBDIV,:NEW.SUBDIV)=1 AND
	 CMP_NUM(:OLD.TARIF,:NEW.TARIF)=1 AND
	 CMP_NUM(:OLD.DISCOUNT,:NEW.DISCOUNT)=1 AND
	 CMP_NUM(:OLD.PAY_TYPE,:NEW.PAY_TYPE)=1 AND
	 CMP_NUM(:OLD.SHIP_TYPE,:NEW.SHIP_TYPE)=1 AND
	 CMP_NUM(:OLD.PRICE_TYPE,:NEW.PRICE_TYPE)=1 AND
	 CMP_NUM(:OLD.DOC_SERV,:NEW.DOC_SERV)=1 AND
	 CMP_NUM(:OLD.PLAN_SERV,:NEW.PLAN_SERV)=1 AND
	 CMP_NUM(:OLD.DOC_SHIP,:NEW.DOC_SHIP)=1 AND
	 CMP_NUM(:OLD.PLAN_SHIP,:NEW.PLAN_SHIP)=1 AND
	 CMP_NUM(:OLD.DOC_INCOME,:NEW.DOC_INCOME)=1 AND
	 CMP_NUM(:OLD.PLAN_INCOME,:NEW.PLAN_INCOME)=1 AND
	 CMP_NUM(:OLD.DOC_POSTED,:NEW.DOC_POSTED)=1 AND
	 CMP_NUM(:OLD.PLAN_POSTED,:NEW.PLAN_POSTED)=1 AND
	 CMP_NUM(:OLD.DOC_PAYED,:NEW.DOC_PAYED)=1 AND
	 CMP_NUM(:OLD.PLAN_PAYED,:NEW.PLAN_PAYED)=1 AND
	 CMP_DAT(:OLD.PRICE_DATE,:NEW.PRICE_DATE)=1 AND
	 CMP_NUM(:OLD.AGN_TRANS,:NEW.AGN_TRANS)=1 AND
	 CMP_NUM(:OLD.BUDGEXPEND_SP,:NEW.BUDGEXPEND_SP)=1 AND
	 CMP_NUM(:OLD.SIGNTAX,:NEW.SIGNTAX)=1 AND
	 (CMP_NUM(:OLD.FACT_SERV,:NEW.FACT_SERV)=0 OR
	  CMP_NUM(:OLD.FACT_SHIP,:NEW.FACT_SHIP)=0 OR
	  CMP_NUM(:OLD.FACT_INCOME,:NEW.FACT_INCOME)=0 OR
	  CMP_NUM(:OLD.FACT_POSTED,:NEW.FACT_POSTED)=0 OR
	  CMP_NUM(:OLD.FACT_PAYED,:NEW.FACT_PAYED)=0)
  ) THEN
  P_UPDATELIST_EVENT( 'FACEACC',:new.RN,'U',:new.COMPANY,null,null,null,:new.NUMB );
end if;
  
end;
/

