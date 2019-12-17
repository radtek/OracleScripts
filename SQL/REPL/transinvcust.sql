CREATE OR REPLACE TRIGGER "PARUS".T_TRANSINVCUST_BDELETE before delete on TRANSINVCUST
for each row
begin
if :old.STATUS != 0 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, '�������� ���㬥�� � ���ﭨ� "��ࠡ�⠭" �������⨬�.');
end if;
/* 㤠����� �痢� */
P_LINKSALL_DELETE_FULL_OUT ( :old.COMPANY, 'GoodsTransInvoicesToConsumers', :old.RN );
/* ॣ������ ᮡ��� */
P_TRANSINVCUST_IUD_EVENT(:old.RN,'D',:old.COMPANY,:old.DOCTYPE,:old.PREF,:old.NUMB);
end;
/
