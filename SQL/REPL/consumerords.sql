
CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORD_BDELETE
before delete on CONSUMERORD for each row
begin
/* проверяем наличие временной блокировки документа */
if :old.BLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
/* проверим состояние заказа */
if ( :old.ORD_STATE <> 0 )  AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Удаление заказа потребителя в состоянии отличном от "Не утвержден" недопустимо.' );
end if;
/* регистрация события */
P_UPDATELIST_EVENT( 'CONSUMERORD',:old.RN,'D',:old.COMPANY,null,null,null,
F_SYSTEM_DOC2MSG( :old.COMPANY,:old.ORD_DOCTYPE,null,:old.ORD_PREF,:old.ORD_NUMB,:old.ORD_DATE ));
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORD_BINSERT
before insert on CONSUMERORD for each row
begin
/* проверяем наличие временной блокировки документа */
if :new.BLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
/* корректировка номера */
:new.ORD_NUMB := strright( strtrim( :new.ORD_NUMB ),10 );
:new.ORD_PREF := strright( strtrim( :new.ORD_PREF ),10 );
-- генерация следующего номера
if GET_OPTIONS_NUM('Realiz_Auto_Generate_Next_Number', :new.COMPANY) = 1 then
P_DOC_GETNEXTNUMB(:new.COMPANY, 'CONSUMERORD', 'ORD_DOCTYPE', 'ORD_PREF', 'ORD_NUMB',
'CONSUMERORDBUF', 'ORD_DOCTYPE', 'ORD_PREF', 'ORD_NUMB', :new.ORD_DOCTYPE, :new.ORD_PREF, :new.ORD_NUMB);
end if;
/* регистрация события */
P_UPDATELIST_EVENT( 'CONSUMERORD',:new.RN,'I',:new.COMPANY,null,null,null,
F_SYSTEM_DOC2MSG( :new.COMPANY,:new.ORD_DOCTYPE,null,:new.ORD_PREF,:new.ORD_NUMB,:new.ORD_DATE ) );
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORD_BUPDATE
before update on CONSUMERORD for each row
begin
/* проверка неизменности значений полей */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы CONSUMERORD недопустимо.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы CONSUMERORD недопустимо.' );
end if;
/* корректировка номера */
:new.ORD_NUMB := strright( strtrim( :new.ORD_NUMB ),10 );
:new.ORD_PREF := strright( strtrim( :new.ORD_PREF ),10 );
/* установка параметров detail-записей */
if not( :new.CRN = :old.CRN ) then -- смена каталога
update CONSUMERORDS
set CRN = :new.CRN
where PRN = :new.RN;
update CONSUMERORDP
set CRN = :new.CRN
where PRN = :new.RN;
else -- изменения в данных
/* проверяем наличие временной блокировки документа */
if (:old.BLOCKED = :new.BLOCKED) and (:old.BLOCKED = 1) and USER<>'SNP_REPL'           -- признак временной блокировки не меняется и установлен в 1
then
if (:old.RESERVDATE is not null and :new.RESERVDATE is null)  -- попытка снять зарезервирование
or (:old.NOTE is null and :new.NOTE is not null)            -- попытка исправить комментарий
or (:old.NOTE is not null and :new.NOTE is null)            -- попытка исправить комментарий
or (:old.NOTE <> :new.NOTE)                                 -- попытка исправить комментарий
--
-- добавлять условия, при которых разрешены UPDATE при установленном признаке "временная блокировка" ЗДЕСЬ
--
then
null;
else
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
end if;
if ( :new.ORD_STATE <> :old.ORD_STATE ) then -- если это не смена состояния, проверяем соотв. ограничения.
if (:new.ORD_STATE = 1) and (:new.FACEACC is null) then
P_EXCEPTION( 0,'Установка состояния "Утвержден" без задания лицевого счета недопустима.');
end if;
end if;/**/
end if;
/* регистрация события */
P_UPDATELIST_EVENT( 'CONSUMERORD',:new.RN,'U',:new.COMPANY,null,null,null,
F_SYSTEM_DOC2MSG( :new.COMPANY,:new.ORD_DOCTYPE,null,:new.ORD_PREF,:new.ORD_NUMB,:new.ORD_DATE ) );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDP_BINSERT
before insert on CONSUMERORDP for each row
declare
nBLOCKED                      number(1);      -- признак временной блокировки
begin
/* считывание параметров master-записи */
select COMPANY, CRN, BLOCKED
into :new.COMPANY, :new.CRN, nBLOCKED
from CONSUMERORD
where RN = :new.PRN;
/* проверяем наличие временной блокировки документа */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
/* регистрация события */
P_CONSUMERORDP_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.PERF_NUMB );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDP_BUPDATE
before update on CONSUMERORDP for each row
begin
/* проверка неизменности значений полей */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы CONSUMERORDP недопустимо.' );
end if;
if ( not( :new.PRN = :old.PRN ) ) then
P_EXCEPTION( 0,'Изменение значения поля PRN таблицы CONSUMERORDP недопустимо.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы CONSUMERORDP недопустимо.' );
end if;
if :old.CRN = :new.CRN then          -- каталог неизменен, => изменяются другие поля
if not F_CNSMRRDP_UPDBLCK_ENABLE
(
:old.RN, :new.RN
,:old.PRN, :new.PRN
,:old.COMPANY, :new.COMPANY
,:old.CRN, :new.CRN
,:old.PERF_NUMB, :new.PERF_NUMB
,:old.PERF_DATE, :new.PERF_DATE
,:old.PSUMWTAX, :new.PSUMWTAX
,:old.PSUMWOTAX, :new.PSUMWOTAX
,:old.SUPP_PLAN_SUM, :new.SUPP_PLAN_SUM
,:old.SUPP_FACT_SUM, :new.SUPP_FACT_SUM
,:old.PAY_PLAN_SUM, :new.PAY_PLAN_SUM
,:old.PAY_FACT_SUM, :new.PAY_FACT_SUM
,:old.ACC_QUANT, :new.ACC_QUANT
,:old.ACC_SUM, :new.ACC_SUM
) AND USER<>'SNP_REPL'
then -- изменяются поля, которые нельзя менять при установленном признаке "врем.блокировка"
/* проверяем наличие временной блокировки документа (Поле BLOCKED) */
P_TRADECALENDAR_CHECK_BLOCKED('CONSUMERORD', :new.PRN);
end if;
end if;
/* регистрация события */
P_CONSUMERORDP_IUD( :new.RN,'U',:new.COMPANY,:new.PRN,:new.PERF_NUMB );
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BDELETE
before delete on CONSUMERORDPS for each row
declare
nBLOCKED                     number(1);       -- признак временной блокировки заказа
TABLE_MUTATING               exception;
pragma exception_init(
TABLE_MUTATING, -04091);
begin
begin
/* выбираем признак временной блокировки из заголовка заказа */
select M.BLOCKED into nBLOCKED
from
CONSUMERORD  M,
CONSUMERORDS S
where S.RN = :old.PRN
and M.RN = S.PRN;
/* проверяем наличие временной блокировки документа */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
exception
when TABLE_MUTATING then
null; -- игнорируем события, вызываемые действиями над master-таблицей. пусть master сам контролирует их допустимость
end;
/* регистрация события */
P_CONSUMERORDPS_IUD( :old.RN,'D',:old.COMPANY,:old.PRN,:old.PERF );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BINSERT
before insert on CONSUMERORDPS for each row
declare
nORD_STATE     CONSUMERORD.ORD_STATE%TYPE;    -- состояние заказа (0-неподтвержден, 1-подтвержден, 2-согласование, 3-закрыт, 4-аннулирован)
nORD_PERIOD    CONSUMERORD.ORD_PERIOD%TYPE;   -- периодический заказ (0-разовый, 1-периодический)
nPERIOD_CORR   CONSUMERORD.PERIOD_CORR%TYPE;  -- коррекция по периодам (0-нет, 1-да)
nPERIOD_QUANT  CONSUMERORD.PERIOD_QUANT%TYPE; -- число периодов
nPRODUCT       PKG_STD.tREF;                  -- изделие
nPRAQUANT      RLARTICLES.QUANT%TYPE;         -- кол-во изделия в ДЕИ
nBLOCKED       CONSUMERORD.BLOCKED%TYPE;      -- признак временной блокировки заказа
nCONSOLIDATED  CONSUMERORD.CONSOLIDATED%TYPE; -- признак консолидации
begin
/* считывание параметров master-записи */
select COMPANY, CRN
into :new.COMPANY, :new.CRN
from CONSUMERORDS
where RN = :new.PRN;
/* считаем состояние заказа */
select /*+ ORDERED*/
M.ORD_STATE, M.ORD_PERIOD, M.PERIOD_CORR, M.PERIOD_QUANT, S.PRODUCT,
M.BLOCKED, M.CONSOLIDATED
into nORD_STATE, nORD_PERIOD, nPERIOD_CORR, nPERIOD_QUANT, nPRODUCT,
nBLOCKED, nCONSOLIDATED
from CONSUMERORD  M,
CONSUMERORDS S
where S.RN  = :new.PRN
and S.PRN = M.RN;
/* проверяем наличие временной блокировки документа */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
if (nCONSOLIDATED < 2) then -- для неконсолидированных заказов
/* проверим допустимость устанавливаемого состояния */
/* ограничение: запись добавляется только с состоянием 'не согласовано' */
if ( :new.PERFS_STATE <> 0 ) and USER<>'SNP_REPL' then -- состояние м. быть только 'не согласовано'
P_EXCEPTION( 0,'Установка состояния отличного от "Не согласовано" при добавлении записи исполнения позиции спецификации заказа недопустима.' );
else -- если состояние нормальное, то проверим заголовок
if (nORD_STATE <> 0) and USER<>'SNP_REPL' then -- заголовок д. быть в состоянии 'неподтвержден'
P_EXCEPTION( 0,'Добавление записи исполнения позиции спецификации заказа при состояния заголовка отличном от "Не утвержден" недопустимо.' );
end if;
end if;
end if;
/* если предыдущую проверку прошли, то осталось проверить только на ограничения параметров записи */
/* совпадения кол-в с кол-вами в изделии */
if (nPRODUCT is not null) AND USER<>'SNP_REPL' then
select QUANT into nPRAQUANT from RLARTICLES where RN = nPRODUCT;
if not( :new.ACTM_QUANT = 1 and :new.EXECM_QUANT = 1 and :new.CUSTM_QUANT = 1 ) then
P_EXCEPTION( 0,'При заданном изделии, количество в основной ЕИ отличное от 1 недопустимо.' );
end if;
if not( :new.ACTA_QUANT = nPRAQUANT and :new.EXECA_QUANT = nPRAQUANT and :new.CUSTA_QUANT = nPRAQUANT) then
P_EXCEPTION( 0,'При заданном изделии, количество в дополнительной ЕИ отличное от указанного в изделии недопустимо.' );
end if;
end if;
/* пересчет сумм у исполнения заказа */
update CONSUMERORDP
set PSUMWOTAX = PSUMWOTAX + :new.ACTSWOTAX,
PSUMWTAX  = PSUMWTAX + :new.ACTSWTAX
where RN = :new.PERF;  /* регистрация события */
P_CONSUMERORDPS_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.PERF );
end;
/

CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BUPDATE
before update on CONSUMERORDPS for each row
declare
nORD_STATE      CONSUMERORD.ORD_STATE%TYPE;    -- состояние заказа (0-неподтвержден, 1-подтвержден, 2-согласование, 3-закрыт, 4-аннулирован)
nORD_PERIOD     CONSUMERORD.ORD_PERIOD%TYPE;   -- периодический заказ (0-разовый, 1-периодический)
nPERIOD_CORR    CONSUMERORD.PERIOD_CORR%TYPE;  -- коррекция по периодам (0-нет, 1-да)
nPERIOD_QUANT   CONSUMERORD.PERIOD_QUANT%TYPE; -- число периодов
nATSAMETIME     CONSUMERORD.ATSAMETIME%TYPE;   -- одновременное исполнение (0-нет, 1-да)
nBLOCKED        CONSUMERORD.BLOCKED%TYPE;      -- признак временной блокировки заказа (0, 1)
nSUMWTAX        PKG_STD.tSUMM;                 -- исходная сумма с налогом
nSUMWOTAX       PKG_STD.tSUMM;                 -- исходная сумма без налога
nMAIN_QUANT     PKG_STD.tQUANT;                -- исходное кол-во в осн. ЕИ
nALT_QUANT      PKG_STD.tQUANT;                -- исходное кол-во в доп. ЕИ
nPRODUCT        PKG_STD.tREF;                  -- изделие
nPRAQUANT       PKG_STD.tQUANT;                -- кол-во изделия в ДЕИ
nTMP            PKG_STD.tREF;                  -- временная.
nSAVE_EXEC_CUST number(1);                     -- настройка "Сохранять предложения исполнителя и заказчика"
begin
/* проверка неизменности значений полей */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы CONSUMERORDPS недопустимо.' );
end if;
if ( not( :new.PRN = :old.PRN ) ) then
P_EXCEPTION( 0,'Изменение значения поля PRN таблицы CONSUMERORDPS недопустимо.' );
end if;
if ( not( :new.PERF = :old.PERF ) ) then
P_EXCEPTION( 0,'Изменение значения поля PERF таблицы CONSUMERORDPS недопустимо.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы CONSUMERORDPS недопустимо.' );
end if;
/* все проверки только если это не смена каталога */
if ( :new.CRN = :old.CRN ) then
/* считаем состояние заказа */
select M.ORD_STATE, M.ORD_PERIOD, M.PERIOD_CORR,M.PERIOD_QUANT,M.ATSAMETIME,M.BLOCKED,
S.SUMWTAX,S.SUMWOTAX,S.MAIN_QUANT,S.ALT_QUANT,S.PRODUCT
into nORD_STATE, nORD_PERIOD, nPERIOD_CORR,nPERIOD_QUANT,nATSAMETIME,nBLOCKED,
nSUMWTAX,nSUMWOTAX,nMAIN_QUANT,nALT_QUANT,nPRODUCT
from CONSUMERORD  M,
CONSUMERORDS S
where S.RN  = :new.PRN
and S.PRN = M.RN;
/* проверяем наличие временной блокировки документа */
if ( nBLOCKED = 1 and not F_CNSMRRDPS_UPDBLCK_ENABLE( :old.RN, :new.RN, :old.PRN, :new.PRN, :old.COMPANY, :new.COMPANY,
:old.CRN, :new.CRN, :old.PERF, :new.PERF, :old.PERFS_STATE, :new.PERFS_STATE,
:old.CS_DATE, :new.CS_DATE,:old.PERF_DATE, :new.PERF_DATE,
:old.ACTPF_DATE, :new.ACTPF_DATE,:old.CUST_DATE, :new.CUST_DATE,
:old.EXEC_DATE, :new.EXEC_DATE, :old.ACTM_QUANT, :new.ACTM_QUANT,
:old.ACTA_QUANT, :new.ACTA_QUANT, :old.EXECM_QUANT, :new.EXECM_QUANT,
:old.EXECA_QUANT, :new.EXECA_QUANT, :old.CUSTM_QUANT, :new.CUSTM_QUANT,
:old.CUSTA_QUANT, :new.CUSTA_QUANT,:old.ACTSWTAX, :new.ACTSWTAX,
:old.ACTSWOTAX, :new.ACTSWOTAX, :old.EXECSWTAX, :new.EXECSWTAX,
:old.EXECSWOTAX, :new.EXECSWOTAX, :old.CUSTSWTAX, :new.CUSTSWTAX,
:old.CUSTSWOTAX, :new.CUSTSWOTAX, :old.ACCM_QUANT, :new.ACCM_QUANT,
:old.ACCA_QUANT, :new.ACCA_QUANT, :old.ACC_SUM, :new.ACC_SUM,
:old.P_PLANM_QUANT, :new.P_PLANM_QUANT,
:old.P_PLANA_QUANT, :new.P_PLANA_QUANT,
:old.P_FACTM_QUANT, :new.P_FACTM_QUANT,
:old.P_FACTA_QUANT, :new.P_FACTA_QUANT,
:old.P_PLAN_SUM, :new.P_PLAN_SUM,:old.P_FACT_SUM, :new.P_FACT_SUM,
:old.RESERVM_QUANT, :new.RESERVM_QUANT,:old.RESERVA_QUANT, :new.RESERVA_QUANT )) AND USER<>'SNP_REPL'
then
P_EXCEPTION( 0,'Операция запрещена. Документ временно блокирован.' );
end if;
/* обработка смены состояния */
if ( :new.PERFS_STATE <> :old.PERFS_STATE ) then
/* проверим допустимость устанавливаемого состояния (вторая часть проверки - в процедуре P_CONSUMERORD_SET_STATE) */
if (nORD_STATE = 1 and nORD_PERIOD = 1 and :new.PERFS_STATE in (1,2)) then
/* если это периодический заказ и в состоянии 'Утвержден', проверим допустимость смены состояния спецификацией */
if ( PKG_DOCLINKS_SMART.CHECK_IN( 'ConsumersOrdersPerform' ) = 0 ) then -- проверка выходящих документов
P_DOCINPT_FIND_EXACT( 0,:old.COMPANY,'ConsumersOrdersPerform',:old.PERF,nTMP );
end if;
end if;
/* проверим допустимость устанавливаемого состояния */
if ( :new.PERFS_STATE = 0 and not (nORD_STATE = 0) ) AND USER<>'SNP_REPL' then -- не согласовано
P_EXCEPTION( 0,'Установка состояния исполнения позиции спецификации "Не согласовано"'||
' при состоянии заказа отличном от "Не утвержден" недопустима.' );
end if;
/* предложение заказчика */
if ( :new.PERFS_STATE = 1 and not (nORD_STATE = 2 or (nORD_STATE = 1 and nORD_PERIOD = 1 and nPERIOD_CORR = 1)) )  AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Установка состояния исполнения позиции спецификации "Предложение заказчика"'||
' при состоянии заказа отличном от "Согласование" или "Утвержден" недопустима.' );
end if;
/* предложение исполнителя */
if ( :new.PERFS_STATE = 2 and not (nORD_STATE = 2 or (nORD_STATE = 1 and nORD_PERIOD = 1 and nPERIOD_CORR = 1)) )  AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Установка состояния исполнения позиции спецификации "Предложение исполнителя"'||
' при состоянии заказа отличном от "Согласование" или "Утвержден" недопустима.' );
end if;
/* согласовано */
if ( :new.PERFS_STATE = 3 and not (nORD_STATE in (1,2)) ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Установка состояния исполнения позиции спецификации "Согласовано"'||
' при состоянии заказа отличном от "Согласование" или "Утвержден" недопустима.' );
end if;
/* считаем настройку "Сохранять предложения исполнителя и заказчика" */
nSAVE_EXEC_CUST := GET_OPTIONS_NUM('Realiz_ConsumerOrd_Save_Exec_Cust_Vals', :new.COMPANY);
/*!!!проверяем совпадение данных!!!*/
if ( :new.PERFS_STATE = 3 and not (:new.EXECM_QUANT = :new.CUSTM_QUANT and
:new.EXECA_QUANT = :new.CUSTA_QUANT and
:new.EXECSWTAX   = :new.CUSTSWTAX   and
:new.EXECSWOTAX  = :new.CUSTSWOTAX  and
:new.EXEC_DATE   = :new.CUST_DATE) ) then
if (:old.PERFS_STATE = 1) then
:new.ACTM_QUANT  := :new.CUSTM_QUANT;
:new.ACTA_QUANT  := :new.CUSTA_QUANT;
:new.ACTSWTAX    := :new.CUSTSWTAX;
:new.ACTSWOTAX   := :new.CUSTSWOTAX;
:new.ACTPF_DATE  := :new.CUST_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.EXECM_QUANT := :new.CUSTM_QUANT;
:new.EXECA_QUANT := :new.CUSTA_QUANT;
:new.EXECSWTAX   := :new.CUSTSWTAX;
:new.EXECSWOTAX  := :new.CUSTSWOTAX;
:new.EXEC_DATE   := :new.CUST_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 402 );
elsif (:old.PERFS_STATE = 2) then
:new.ACTM_QUANT  := :new.EXECM_QUANT;
:new.ACTA_QUANT  := :new.EXECA_QUANT;
:new.ACTSWTAX    := :new.EXECSWTAX;
:new.ACTSWOTAX   := :new.EXECSWOTAX;
:new.ACTPF_DATE  := :new.EXEC_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.CUSTM_QUANT := :new.EXECM_QUANT;
:new.CUSTA_QUANT := :new.EXECA_QUANT;
:new.CUSTSWTAX   := :new.EXECSWTAX;
:new.CUSTSWOTAX  := :new.EXECSWOTAX;
:new.CUST_DATE   := :new.EXEC_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 403 );
end if;
/* исправим дату и у заголовка исполнения по периоду */
if (nATSAMETIME = 1) then -- если исполнение одновременное
update CONSUMERORDP
set PERF_DATE = :new.ACTPF_DATE
where RN = :new.PERF
and PERF_DATE <> :new.ACTPF_DATE;
end if;
end if;
/* закрыто */
if ( :new.PERFS_STATE = 4 and not (nORD_STATE in (3,4)) ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Установка состояния исполнения позиции спецификации "Закрыто"'||
' при состоянии заказа отличном от "Закрыт" или "Аннулирован" недопустима.' );
end if;
/*!!!проверяем совпадение данных!!!*/
if ( :new.PERFS_STATE = 4 and not (:new.EXECM_QUANT = :new.CUSTM_QUANT and
:new.EXECA_QUANT = :new.CUSTA_QUANT and
:new.EXECSWTAX   = :new.CUSTSWTAX   and
:new.EXECSWOTAX  = :new.CUSTSWOTAX  and
:new.EXEC_DATE   = :new.CUST_DATE) ) then
/* если, параметры несогласованы - согласуем как при утверждении */
if (:old.PERFS_STATE = 1) then
:new.ACTM_QUANT  := :new.CUSTM_QUANT;
:new.ACTA_QUANT  := :new.CUSTA_QUANT;
:new.ACTSWTAX    := :new.CUSTSWTAX;
:new.ACTSWOTAX   := :new.CUSTSWOTAX;
:new.ACTPF_DATE  := :new.CUST_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.EXECM_QUANT := :new.CUSTM_QUANT;
:new.EXECA_QUANT := :new.CUSTA_QUANT;
:new.EXECSWTAX   := :new.CUSTSWTAX;
:new.EXECSWOTAX  := :new.CUSTSWOTAX;
:new.EXEC_DATE   := :new.CUST_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 402 );
elsif (:old.PERFS_STATE = 2) then
:new.ACTM_QUANT  := :new.EXECM_QUANT;
:new.ACTA_QUANT  := :new.EXECA_QUANT;
:new.ACTSWTAX    := :new.EXECSWTAX;
:new.ACTSWOTAX   := :new.EXECSWOTAX;
:new.ACTPF_DATE  := :new.EXEC_DATE;
if ( nSAVE_EXEC_CUST = 0 ) then
:new.CUSTM_QUANT := :new.EXECM_QUANT;
:new.CUSTA_QUANT := :new.EXECA_QUANT;
:new.CUSTSWTAX   := :new.EXECSWTAX;
:new.CUSTSWOTAX  := :new.EXECSWOTAX;
:new.CUST_DATE   := :new.EXEC_DATE;
end if;
PKG_GOODS_CHECK.P_ADD_ERROR( 403 );
end if;
/* исправим дату и у заголовка исполнения по периоду */
if (nATSAMETIME = 1) then -- если исполнение одновременное
update CONSUMERORDP
set PERF_DATE = :new.ACTPF_DATE
where RN = :new.PERF
and PERF_DATE <> :new.ACTPF_DATE;
end if;
end if;
/* переделать */
else -- состояние не изменилось
if ((:new.P_PLANM_QUANT = :old.P_PLANM_QUANT) and
(:new.P_PLANA_QUANT = :old.P_PLANA_QUANT) and
(:new.P_FACTM_QUANT = :old.P_FACTM_QUANT) and
(:new.P_FACTA_QUANT = :old.P_FACTA_QUANT) and
(:new.P_PLAN_SUM    = :old.P_PLAN_SUM)    and
(:new.P_FACT_SUM    = :old.P_FACT_SUM))   then -- если это не исполнение
if ( PKG_DOCLINKS_SMART.CHECK_IN( 'ConsumersOrdersPerform' ) = 0 ) AND USER<>'SNP_REPL' then -- проверка выходящих документов
P_DOCINPT_FIND_EXACT( 0,:old.COMPANY,'ConsumersOrdersPerform',:old.PERF,nTMP );
end if;
/* проверим допустимость изменения данных в установленом состоянии, только если нет спец. флага!!! */
if ( :old.PERFS_STATE = 3 or :old.PERFS_STATE = 4) and (PKG_FLAG.RESET_FLAG = 0) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Изменение записи исполнения позиции спецификации в состоянии "Закрыто" или "Согласовано" недопустимо.' );
end if;
else -- исправляем суммы исполнения у заголовка периода
update CONSUMERORDP
set SUPP_PLAN_SUM = SUPP_PLAN_SUM - :old.P_PLAN_SUM + :new.P_PLAN_SUM,
SUPP_FACT_SUM = SUPP_FACT_SUM - :old.P_FACT_SUM + :new.P_FACT_SUM
where RN = :new.PERF;
end if;
end if;
/* приравняем суммы, кол-ва и даты в зависмости от состояния */
if ( :new.PERFS_STATE = 0) and (PKG_FLAG.RESET_FLAG = 0) then -- в сост. не согласовано (берем исх. данные), только если нет спец. флага!!!
/* количества */
:new.ACTM_QUANT  := nMAIN_QUANT;
:new.ACTA_QUANT  := nALT_QUANT;
:new.CUSTM_QUANT := nMAIN_QUANT;
:new.CUSTA_QUANT := nALT_QUANT;
:new.EXECM_QUANT := nMAIN_QUANT;
:new.EXECA_QUANT := nALT_QUANT;
/* суммы */
:new.ACTSWTAX    := nSUMWTAX;
:new.ACTSWOTAX   := nSUMWOTAX;
:new.CUSTSWTAX   := nSUMWTAX;
:new.CUSTSWOTAX  := nSUMWOTAX;
:new.EXECSWTAX   := nSUMWTAX;
:new.EXECSWOTAX  := nSUMWOTAX;
/* даты */
if ( :new.PERFS_STATE <> :old.PERFS_STATE ) then -- исходная.
:new.ACTPF_DATE  := :new.PERF_DATE;
:new.CUST_DATE   := :new.PERF_DATE;
:new.EXEC_DATE   := :new.PERF_DATE;
else -- согласованная.
:new.PERF_DATE  := :new.ACTPF_DATE;
:new.CUST_DATE  := :new.ACTPF_DATE;
:new.EXEC_DATE  := :new.ACTPF_DATE;
end if;
elsif ( :new.PERFS_STATE = 1) then -- в сост. предложение заказчика
/* количества (данные меняются у исполнителя) */
:new.ACTM_QUANT  := :new.EXECM_QUANT;
:new.ACTA_QUANT  := :new.EXECA_QUANT;
/* суммы */
:new.ACTSWTAX    := :new.EXECSWTAX;
:new.ACTSWOTAX   := :new.EXECSWOTAX;
/* даты */
:new.ACTPF_DATE  := :new.EXEC_DATE;
elsif ( :new.PERFS_STATE = 2) then -- в сост. предложение исполнителя.
/* количества (данные меняются у заказчика) */
:new.ACTM_QUANT  := :new.CUSTM_QUANT;
:new.ACTA_QUANT  := :new.CUSTA_QUANT;
/* суммы */
:new.ACTSWTAX    := :new.CUSTSWTAX;
:new.ACTSWOTAX   := :new.CUSTSWOTAX;
/* даты */
:new.ACTPF_DATE  := :new.CUST_DATE;
end if;
/* пересчет сумм у периода исполнения заказа */
update CONSUMERORDP
set PSUMWOTAX = PSUMWOTAX - :old.ACTSWOTAX + :new.ACTSWOTAX,
PSUMWTAX  = PSUMWTAX - :old.ACTSWTAX + :new.ACTSWTAX
where RN = :new.PERF;
/* проверим ограничения */
/* совпадения кол-в с кол-ми в изделии */
if (nPRODUCT is not null) then
select QUANT into nPRAQUANT from RLARTICLES where RN = nPRODUCT;
if not( :new.ACTM_QUANT = 1 and :new.EXECM_QUANT = 1 and :new.CUSTM_QUANT = 1 ) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'При заданном изделии, количество в основной ЕИ отличное от 1 недопустимо.' );
end if;
if not( :new.ACTA_QUANT = nPRAQUANT and :new.EXECA_QUANT = nPRAQUANT and :new.CUSTA_QUANT = nPRAQUANT) AND USER<>'SNP_REPL' then
P_EXCEPTION( 0,'При заданном изделии, количество в дополнительной ЕИ отличное от указанного в изделии недопустимо.' );
end if;
end if;
end if;
/* регистрация события */
P_CONSUMERORDPS_IUD( :new.RN,'U',:new.COMPANY,:new.PRN,:new.PERF );
end;
/



CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDS_BDELETE
before delete on CONSUMERORDS for each row
begin
/* проверяем наличие временной блокировки документа (Поле BLOCKED) */
IF USER<>'SNP_REPL' THEN
  P_TRADECALENDAR_CHECK_BLOCKED('CONSUMERORD', :old.PRN);
END IF;  
/* регистрация события */
P_CONSUMERORDS_IUD( :old.RN,'D',:old.COMPANY,:old.PRN,:old.NOMEN,:old.NOM_PACK,:old.NOM_MODIF,:old.NOMMOD_PACK,:old.PRODUCT,:old.NAME );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDS_BINSERT
before insert on CONSUMERORDS for each row
declare
nORD_PERIOD           CONSUMERORD.ORD_PERIOD%TYPE;   -- периодический заказ (0-разовый, 1-периодический)
nORD_STATE            CONSUMERORD.ORD_STATE%TYPE;    -- состояние заказа (0-не утвержден, 1-утвержден, 2-согласование, 3-закрыт, 4-аннулирован)
nSIGN_SERIAL          DICNOMNS.SIGN_SERIAL%TYPE;     -- признак ведения учета по серийным номерам (0 - нет, 1 - да)
nPRNMOD               PKG_STD.tREF;                  -- модификация номенклатуры изделия.
nNOMEN_TYPE           DICNOMNS.NOMEN_TYPE%TYPE;      -- тип номерклатуры (1 - товар, 2 - услуга, 3 - тара)
IsUseNomenSerial      boolean;                       -- настройка "Производить с учетом серийных номеров"
nBLOCKED              CONSUMERORD.BLOCKED%TYPE;      -- признак временной блокировки
nCONSOLIDATED         CONSUMERORD.CONSOLIDATED%TYPE; -- признак консолидации
begin
/* считывание параметров master-записи */
select COMPANY, CRN, ORD_PERIOD, ORD_STATE, BLOCKED, CONSOLIDATED
into :new.COMPANY, :new.CRN, nORD_PERIOD, nORD_STATE, nBLOCKED, nCONSOLIDATED
from CONSUMERORD
where RN = :new.PRN;
/* проверка допустимости добавления */
/* проверяем наличие временной блокировки документа */
if nBLOCKED = 1 AND USER<>'SNP_REPL' then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
/* проверка текущего состояния master-записи */
if (nORD_STATE <> 0) and (nCONSOLIDATED < 2) and USER<>'SNP_REPL' then
P_EXCEPTION( 0,'Добавление записи позиции спецификации заказа в состоянии отличном от "Не утвержден" недопустимо.' );
end if;
/* проверка корректности добавляемых данных */
if (:new.PRODUCT is not null and nORD_PERIOD <> 0) then -- изделие доступно только для разового заказа
P_EXCEPTION( 0,'Для периодического заказа поле "Изделие" недоступно.' );
end if;
/* совпадения номенклатуры, модификации с изделием */
if ( :new.NOMEN is not null ) then
/* считаем параметры номенклатуры */
select SIGN_SERIAL,NOMEN_TYPE
into nSIGN_SERIAL,nNOMEN_TYPE
from DICNOMNS where RN = :new.NOMEN;
/* проверим на тип услуга */
if (nNOMEN_TYPE <> 2) and ((:new.BEGIN_DATE is not null) or (:new.END_DATE is not null)) then
P_EXCEPTION( 0,'Задание дат периода предоставления услуг, для спецификации с номенклатурой не являющейся услугой недопустимо.' );
end if;
if (nNOMEN_TYPE = 2) and (:new.BEGIN_DATE is null) then
P_EXCEPTION( 0,'Необходимо задать дату начала периода предоставления услуг.' );
end if;
IsUseNomenSerial := GET_OPTIONS_NUM('Realiz_Nomen_With_Ser_Num', :new.COMPANY) = 1;
if IsUseNomenSerial then
if (:new.PRODUCT is not null) then
if (nSIGN_SERIAL = 0) then
P_EXCEPTION( 0,'Для номенклатуры без признака ведения учета по серийным номерам указание изделия недопустимо.' );
end if;
select NOMMODIF into nPRNMOD from RLARTICLES where RN = :new.PRODUCT;
if (:new.NOM_MODIF <> nPRNMOD) then
P_EXCEPTION( 0,'Модификация номенклатуры изделия и спецификации заказа не совпадают.' );
end if;
else
if nSIGN_SERIAL = 1 then
P_EXCEPTION ( 0, 'Для номенклатуры, имеющей признак "Учет по серийным номерам", обязательно указание изделия.' );
end if;
end if;
end if;
end if;
/* регистрация события */
P_CONSUMERORDS_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.NOMEN,:new.NOM_PACK,:new.NOM_MODIF,:new.NOMMOD_PACK,:new.PRODUCT,:new.NAME );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDS_BUPDATE
before update on CONSUMERORDS for each row
begin
/* проверка неизменности значений полей */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'Изменение значения поля RN таблицы CONSUMERORDS недопустимо.' );
end if;
if ( not( :new.PRN = :old.PRN ) ) then
P_EXCEPTION( 0,'Изменение значения поля PRN таблицы CONSUMERORDS недопустимо.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'Изменение значения поля COMPANY таблицы CONSUMERORDS недопустимо.' );
end if;
/* установка параметров detail-записей */
if not( :new.CRN = :old.CRN ) then     -- смена каталога => остальные поля не меняются
update CONSUMERORDPS
set CRN = :new.CRN
where PRN = :new.RN;
else
/* проверяем наличие временной блокировки документа (Поле BLOCKED) */
IF USER<>'SNP_REPL' THEN
  P_TRADECALENDAR_CHECK_BLOCKED('CONSUMERORD', :new.PRN);
END IF;  
end if;
/* регистрация события */
P_CONSUMERORDS_IUD( :new.RN,'U',:new.COMPANY,:new.PRN,:new.NOMEN,:new.NOM_PACK,:new.NOM_MODIF,:new.NOMMOD_PACK,:new.PRODUCT,:new.NAME );
end;
/


CREATE OR REPLACE TRIGGER "PARUS".T_CONSUMERORDPS_BINSERT
before insert on CONSUMERORDPS for each row
declare
nORD_STATE     CONSUMERORD.ORD_STATE%TYPE;    -- состояние заказа (0-неподтвержден, 1-подтвержден, 2-согласование, 3-закрыт, 4-аннулирован)
nORD_PERIOD    CONSUMERORD.ORD_PERIOD%TYPE;   -- периодический заказ (0-разовый, 1-периодический)
nPERIOD_CORR   CONSUMERORD.PERIOD_CORR%TYPE;  -- коррекция по периодам (0-нет, 1-да)
nPERIOD_QUANT  CONSUMERORD.PERIOD_QUANT%TYPE; -- число периодов
nPRODUCT       PKG_STD.tREF;                  -- изделие
nPRAQUANT      RLARTICLES.QUANT%TYPE;         -- кол-во изделия в ДЕИ
nBLOCKED       CONSUMERORD.BLOCKED%TYPE;      -- признак временной блокировки заказа
nCONSOLIDATED  CONSUMERORD.CONSOLIDATED%TYPE; -- признак консолидации
begin
/* считывание параметров master-записи */
select COMPANY, CRN
into :new.COMPANY, :new.CRN
from CONSUMERORDS
where RN = :new.PRN;
/* считаем состояние заказа */
select /*+ ORDERED*/
M.ORD_STATE, M.ORD_PERIOD, M.PERIOD_CORR, M.PERIOD_QUANT, S.PRODUCT,
M.BLOCKED, M.CONSOLIDATED
into nORD_STATE, nORD_PERIOD, nPERIOD_CORR, nPERIOD_QUANT, nPRODUCT,
nBLOCKED, nCONSOLIDATED
from CONSUMERORD  M,
CONSUMERORDS S
where S.RN  = :new.PRN
and S.PRN = M.RN;
/* проверяем наличие временной блокировки документа */
if nBLOCKED = 1 then
P_EXCEPTION(0, 'Операция запрещена. Документ временно блокирован.');
end if;
if (nCONSOLIDATED < 2) then -- для неконсолидированных заказов
/* проверим допустимость устанавливаемого состояния */
/* ограничение: запись добавляется только с состоянием 'не согласовано' */
if ( :new.PERFS_STATE <> 0 ) and USER<>'SNP_REPL' then -- состояние м. быть только 'не согласовано'
P_EXCEPTION( 0,'Установка состояния отличного от "Не согласовано" при добавлении записи исполнения позиции спецификации заказа недопустима.' );
else -- если состояние нормальное, то проверим заголовок
if (nORD_STATE <> 0) and USER<>'SNP_REPL' then -- заголовок д. быть в состоянии 'неподтвержден'
P_EXCEPTION( 0,'Добавление записи исполнения позиции спецификации заказа при состояния заголовка отличном от "Не утвержден" недопустимо.' );
end if;
end if;
end if;
/* если предыдущую проверку прошли, то осталось проверить только на ограничения параметров записи */
/* совпадения кол-в с кол-вами в изделии */
if (nPRODUCT is not null) then
select QUANT into nPRAQUANT from RLARTICLES where RN = nPRODUCT;
if not( :new.ACTM_QUANT = 1 and :new.EXECM_QUANT = 1 and :new.CUSTM_QUANT = 1 ) then
P_EXCEPTION( 0,'При заданном изделии, количество в основной ЕИ отличное от 1 недопустимо.' );
end if;
if not( :new.ACTA_QUANT = nPRAQUANT and :new.EXECA_QUANT = nPRAQUANT and :new.CUSTA_QUANT = nPRAQUANT) then
P_EXCEPTION( 0,'При заданном изделии, количество в дополнительной ЕИ отличное от указанного в изделии недопустимо.' );
end if;
end if;
/* пересчет сумм у исполнения заказа */
update CONSUMERORDP
set PSUMWOTAX = PSUMWOTAX + :new.ACTSWOTAX,
PSUMWTAX  = PSUMWTAX + :new.ACTSWTAX
where RN = :new.PERF;  /* регистрация события */
P_CONSUMERORDPS_IUD( :new.RN,'I',:new.COMPANY,:new.PRN,:new.PERF );
end;
/
