CREATE OR REPLACE TRIGGER "PARUS".T_NOMPRICE_BUPDATE
before update on NOMPRICE for each row
begin
if ( :new.RN != :old.RN ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы NOMPRICE недопустимо.' );
end if;
if ( :new.COMPANY != :old.COMPANY ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы NOMPRICE недопустимо.' );
end if;
if ( :new.NOMENCLATURE != :old.NOMENCLATURE ) then
P_EXCEPTION( 0,'Изменение значения номенклатуры недопустимо.' );
end if;
IF USER<>'SNP_REPL' THEN
  /* проверка закрытости периода */
  P_APERIODS_CLOSED( :old.COMPANY,:old.PRICE_DATE );
  /* проверка закрытости периода */
  P_APERIODS_CLOSED( :new.COMPANY,:new.PRICE_DATE );
END IF;  
/* преобразование сумм */
P_NOMPRICE_MAKESUMS( :new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE,
:new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE );
/* регистрация события */
P_NOMPRICE_IUD_EVENT( :new.RN,'U',:new.COMPANY,:new.NOMENCLATURE,:new.PRICE_DATE,:new.BALUNIT,:new.CURRENCY,:new.PF_TYPE );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_NOMPRICE_BINSERT
before insert on NOMPRICE for each row
begin
IF USER<>'SNP_REPL' THEN
  /* проверка закрытости периода */
  P_APERIODS_CLOSED( :new.COMPANY,:new.PRICE_DATE );
END IF;  
/* преобразование сумм */
P_NOMPRICE_MAKESUMS( :new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE,
:new.ACNT_PRICE,:new.ACNT_BASE_PRICE,:new.CTRL_PRICE,:new.CTRL_BASE_PRICE);
/* регистрация события */
P_NOMPRICE_IUD_EVENT( :new.RN,'I',:new.COMPANY,:new.NOMENCLATURE,:new.PRICE_DATE,:new.BALUNIT,:new.CURRENCY,:new.PF_TYPE );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_NOMPRICE_BDELETE
before delete on NOMPRICE for each row
begin
IF USER<>'SNP_REPL' THEN
  /* проверка закрытости периода */
  P_APERIODS_CLOSED( :old.COMPANY,:old.PRICE_DATE );
END IF;  
/* регистрация события */
P_NOMPRICE_IUD_EVENT( :old.RN,'D',:old.COMPANY,:old.NOMENCLATURE,:old.PRICE_DATE,:old.BALUNIT,:old.CURRENCY,:old.PF_TYPE );
end;
/
