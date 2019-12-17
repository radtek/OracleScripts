CREATE OR REPLACE TRIGGER T_DOCINPT_BDELETE_REPL_KOMI
before delete on DOCINPT for each row
begin
/* регистрация события */
IF USER<>'SNP_REPL' AND :OLD.UNITCODE IN (
                     'IncomingOrders',
                     'IncomingOrdersSpecs',
                     'GoodsTransInvoicesToDepts',
                     'GoodsTransInvoicesToDeptsSpecs',
                     'IncomFromDeps',
                     'IncomFromDepsSpecs',
                     'StoragePlacesOperJournal',
                     'StoragePlacesResJournal',
                     'StoreOpersJournal',
                     'LiabilitiesNotes',
                     'ReservationJournal',
                     'DailyTurnsJournal',
                     'ConsumersOrders',
                     'ConsumersOrdersSpec',
                     'ConsumersOrdersPerform',
                     'ConsumersOrdersSpecPerform',
                     'PaymentAccounts',
                     'PaymentAccountsSpecs',
                     'SheepDirectToConsumers',
                     'SheepDirectToConsumersSpecs',
                     'SheepDirectToDepts',
                     'SheepDirectToDeptsSpecs',
                     'GoodsTransInvoicesToConsumers',
                     'GoodsTransInvoicesToConsumersSpecs',
                     'AccountFactOutput',
                     'AccountFactOutputSlave',
                     'AccountFactInput',
                     'AccountFactInputSlave',
                     'TradeReports',
                     'TradeReportsSp',
                     'PayNotes',
                     'BillAssignmentActs',
                     'BillAssignmentActsMovement',
                     'BillAssignmentActDocs',
                     'BillAssignmentActAssigns',
                     'BillReceptionActs',
                     'BillReceptionActsMovement',
                     'BillReceptionActDocs',
                     'BillReceptionActAssigns',
                     'BankDocuments',
                     'CashDocuments',
                     'InterDebts',
                     'InterDebtsSp',
                     'WriteOffActs',
                     'WriteOffActsSpecs',
                     'BillCardsMovement',
                     'BillCards',
                     'BillPayDestination',
                     'RealizationInventorySheet',
                     'RealizationInventorySheetSpec',
                     'RealizationPrices',
                     'RealizationPricesSpecs' 
) THEN
  INSERT INTO PARUS.UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
  VALUES ('DOCINPT',:OLD.RN,USER,SYSDATE,'D',TO_CHAR(:OLD.DOCUMENT));
END IF;  
end;
/

CREATE OR REPLACE TRIGGER T_DOCINPT_BINSERT_REPL_KOMI
before insert on DOCINPT for each row
begin
/* регистрация события */
IF USER<>'SNP_REPL' AND :NEW.UNITCODE IN (
                     'IncomingOrders',
                     'IncomingOrdersSpecs',
                     'GoodsTransInvoicesToDepts',
                     'GoodsTransInvoicesToDeptsSpecs',
                     'IncomFromDeps',
                     'IncomFromDepsSpecs',
                     'StoragePlacesOperJournal',
                     'StoragePlacesResJournal',
                     'StoreOpersJournal',
                     'LiabilitiesNotes',
                     'ReservationJournal',
                     'DailyTurnsJournal',
                     'ConsumersOrders',
                     'ConsumersOrdersSpec',
                     'ConsumersOrdersPerform',
                     'ConsumersOrdersSpecPerform',
                     'PaymentAccounts',
                     'PaymentAccountsSpecs',
                     'SheepDirectToConsumers',
                     'SheepDirectToConsumersSpecs',
                     'SheepDirectToDepts',
                     'SheepDirectToDeptsSpecs',
                     'GoodsTransInvoicesToConsumers',
                     'GoodsTransInvoicesToConsumersSpecs',
                     'AccountFactOutput',
                     'AccountFactOutputSlave',
                     'AccountFactInput',
                     'AccountFactInputSlave',
                     'TradeReports',
                     'TradeReportsSp',
                     'PayNotes',
                     'BillAssignmentActs',
                     'BillAssignmentActsMovement',
                     'BillAssignmentActDocs',
                     'BillAssignmentActAssigns',
                     'BillReceptionActs',
                     'BillReceptionActsMovement',
                     'BillReceptionActDocs',
                     'BillReceptionActAssigns',
                     'BankDocuments',
                     'CashDocuments',
                     'InterDebts',
                     'InterDebtsSp',
                     'WriteOffActs',
                     'WriteOffActsSpecs',
                     'BillCardsMovement', 
                     'BillCards',
                     'BillPayDestination',
                     'RealizationInventorySheet',
                     'RealizationInventorySheetSpec',
                     'RealizationPrices',
                     'RealizationPricesSpecs' 
) THEN
  INSERT INTO PARUS.UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
  VALUES ('DOCINPT',:NEW.RN,USER,SYSDATE,'I',TO_CHAR(:NEW.DOCUMENT));
END IF;  
end;
/


CREATE OR REPLACE TRIGGER T_DOCINPT_BUPDATE_REPL_KOMI
before update on DOCINPT for each row
begin
/* регистрация события */
IF USER<>'SNP_REPL' AND :NEW.UNITCODE IN (
                     'IncomingOrders',
                     'IncomingOrdersSpecs',
                     'GoodsTransInvoicesToDepts',
                     'GoodsTransInvoicesToDeptsSpecs',
                     'IncomFromDeps',
                     'IncomFromDepsSpecs',
                     'StoragePlacesOperJournal',
                     'StoragePlacesResJournal',
                     'StoreOpersJournal',
                     'LiabilitiesNotes',
                     'ReservationJournal',
                     'DailyTurnsJournal',
                     'ConsumersOrders',
                     'ConsumersOrdersSpec',
                     'ConsumersOrdersPerform',
                     'ConsumersOrdersSpecPerform',
                     'PaymentAccounts',
                     'PaymentAccountsSpecs',
                     'SheepDirectToConsumers',
                     'SheepDirectToConsumersSpecs',
                     'SheepDirectToDepts',
                     'SheepDirectToDeptsSpecs',
                     'GoodsTransInvoicesToConsumers',
                     'GoodsTransInvoicesToConsumersSpecs',
                     'AccountFactOutput',
                     'AccountFactOutputSlave',
                     'AccountFactInput',
                     'AccountFactInputSlave',
                     'TradeReports',
                     'TradeReportsSp',
                     'PayNotes',
                     'BillAssignmentActs',
                     'BillAssignmentActsMovement',
                     'BillAssignmentActDocs',
                     'BillAssignmentActAssigns',
                     'BillReceptionActs',
                     'BillReceptionActsMovement',
                     'BillReceptionActDocs',
                     'BillReceptionActAssigns',
                     'BankDocuments',
                     'CashDocuments',
                     'InterDebts',
                     'InterDebtsSp',
                     'WriteOffActs',
                     'WriteOffActsSpecs',
                     'BillCardsMovement', 
                     'BillCards',
                     'BillPayDestination',
                     'RealizationInventorySheet',
                     'RealizationInventorySheetSpec',
                     'RealizationPrices',
                     'RealizationPricesSpecs' 
) THEN
  INSERT INTO PARUS.UPDATELIST (TABLENAME,TABLERN,AUTHID,MODIFDATE,OPERATION,NOTE)
  VALUES ('DOCINPT',:NEW.RN,USER,SYSDATE,'U',TO_CHAR(:NEW.DOCUMENT));
end if;  
end;
/


CREATE OR REPLACE TRIGGER T_DOCINPT_BUPDATE
before update on DOCINPT for each row
begin
/* проверка неизменности */
if ( :old.STATUS = :new.STATUS ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Модификация записи таблицы DOCINPT недопустима.' );
end if;
end;
/
