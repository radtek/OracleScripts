CREATE OR REPLACE TRIGGER "PARUS".T_NOMPRICE_BUPDATE
before update on NOMPRICE for each row
begin
if ( :new.RN != :old.RN ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� RN ⠡���� NOMPRICE �������⨬�.' );
end if;
if ( :new.COMPANY != :old.COMPANY ) then
P_EXCEPTION( 0,'��������� ���祭�� ���� COMPANY ⠡���� NOMPRICE �������⨬�.' );
end if;
if ( :new.NOMENCLATURE != :old.NOMENCLATURE ) then
P_EXCEPTION( 0,'��������� ���祭�� ������������ �������⨬�.' );
end if;
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :old.COMPANY,:old.PRICE_DATE );
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :new.COMPANY,:new.PRICE_DATE );
END IF;  
/* �८�ࠧ������ �㬬 */
P_NOMPRICE_MAKESUMS( :new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE,
:new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE );
/* ॣ������ ᮡ��� */
P_NOMPRICE_IUD_EVENT( :new.RN,'U',:new.COMPANY,:new.NOMENCLATURE,:new.PRICE_DATE,:new.BALUNIT,:new.CURRENCY,:new.PF_TYPE );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_NOMPRICE_BINSERT
before insert on NOMPRICE for each row
begin
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :new.COMPANY,:new.PRICE_DATE );
END IF;  
/* �८�ࠧ������ �㬬 */
P_NOMPRICE_MAKESUMS( :new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE,
:new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE);
/* ॣ������ ᮡ��� */
P_NOMPRICE_IUD_EVENT( :new.RN,'I',:new.COMPANY,:new.NOMENCLATURE,:new.PRICE_DATE,:new.BALUNIT,:new.CURRENCY,:new.PF_TYPE );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_NOMPRICE_BDELETE
before delete on NOMPRICE for each row
begin
IF USER<>'SNP_REPL' THEN
  /* �஢�ઠ �������� ��ਮ�� */
  P_APERIODS_CLOSED( :old.COMPANY,:old.PRICE_DATE );
END IF;  
/* ॣ������ ᮡ��� */
P_NOMPRICE_IUD_EVENT( :old.RN,'D',:old.COMPANY,:old.NOMENCLATURE,:old.PRICE_DATE,:old.BALUNIT,:old.CURRENCY,:old.PF_TYPE );
end;
/
