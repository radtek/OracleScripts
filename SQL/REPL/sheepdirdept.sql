CREATE OR REPLACE TRIGGER "PARUS".T_SHEEPDIRSDEPT_BDELETE before delete on SHEEPDIRSDEPT
for each row
declare
nCNT number (17);
begin
if :old.STATUS = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION ( 0, 'Удаление распоряжения на отгрузку в состоянии "отработан" недопустимо.' );
end if;
if :old.STATUS = 2 AND USER<>'SNP_REPL' then
P_EXCEPTION ( 0, 'Удаление распоряжения на отгрузку в состоянии "закрыт" недопустимо.' );
end if;
/* Проверка связей по DocLinks c ТТН */
select count (*)
into nCNT
from
DOCINPT    I,
DOCLINKS   D,
DOCOUTPT   O,
TRANSINVCUST INV
where I.DOCUMENT = :old.RN
and I.UNITCODE = 'SheepDirectToConsumers'
--
and O.UNITCODE = 'GoodsTransInvoicesToConsumers'
--
and I.RN       = D.IN_DOC
and D.OUT_DOC  = O.RN
and O.DOCUMENT = INV.RN;
if nCNT > 0 then
P_EXCEPTION ( 0, 'Удаление распоряжения, на основании которого выписаны накладные, недопустимо.' );
end if;
/* Полное удаление документа из выходной таблицы. */
P_LINKSALL_DELETE_FULL_OUT (:old.COMPANY, 'SheepDirectToDepts', :old.RN);
/* регистрация события */
P_SHEEPDIRSDEPT_IUD_EVENT(:old.RN,'D',:old.COMPANY,:old.DOCTYPE,:old.PREF,:old.NUMB);
end;
/
