CREATE OR REPLACE TRIGGER T_INORDERS_BDELETE
before delete on INORDERS for each row
begin
if :old.DOCSTATUS <> 0 AND USER<>'SNP_REPL' then
P_EXCEPTION ( 0, '�������� ��室���� �थ� � ��ࠡ�⠭��� ���ﭨ� �������⨬�.' );
end if;
/* ॣ������ ᮡ��� */
P_INORDERS_IUD_EVENT(:old.RN,'D',:old.COMPANY,:old.INDOCTYPE,:old.INDOCPREF,:old.INDOCNUMB);
end;
/

