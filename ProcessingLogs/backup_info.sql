Connect azsbuffer/azsbuffer@buh

-- set echo off
-- set termout off
set trimout off
set trimspool on
set linesize 1000
set pagesize 5000
alter session set nls_date_format='dd.mm.yyyy hh24:mi:ss';

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--АЗС и нефтебазы с просроченным ПОЛНЫМ бакапом HotCopy (более 7 дней)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_hotcopyold_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--АЗС и нефтебазы с просроченным снятием дампа DAMP_RUN.BAT (более 2 дней)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_dumpold_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--АЗС и нефтебазы с просроченным ежедневным бакапом MoveArchiveLog (более 1 дня)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_archivelogsold_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--Не разрешившиеся ошибки резервного копирования' as "_" from dual;
SET HEADING ON

select * from v_arm_info_backuperrors_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--Ошибки на АЗС за последние 4 суток' as "_" from dual;
SET HEADING ON

select * from v_arm_info_lasterrorsazs_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--в т.ч. ORACLE-ошибки на АЗС за последние 4 суток' as "_" from dual;
SET HEADING ON

select * from v_arm_info_oraerrorsazs_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--Ошибки на Нефтебазах за последние 4 суток' as "_" from dual;
SET HEADING ON

select * from v_arm_info_lasterrorsnb_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--в т.ч. ORACLE-ошибки на Нефтебазах за последние 4 суток' as "_" from dual;
SET HEADING ON

select * from v_arm_info_oraerrorsnb_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--Ошибки на прочих ПК за последние 4 суток' as "_" from dual;
SET HEADING ON

select * from v_arm_info_lasterrorsother_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--Контроль параметров' as "_" from dual;
SET HEADING ON

select * from v_arm_info_parameters1_psv;

select * from v_arm_info_parameters2_psv;


SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--Информация об антивирусах' as "_" from dual;
SET HEADING ON

select * from v_arm_info_antivirus_psv;


SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '-- АЗС - часовой пояс' as "_" from dual;
SET HEADING ON

select * from v_arm_info_time_zone_azs_psv;

SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '-- Нефтебазы - часовой пояс' as "_" from dual;
SET HEADING ON

select * from v_arm_info_time_zone_nb_psv;



SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '--Реестр всех АЗС, по которым есть информация о бакапах' as "_" from dual;
SET HEADING ON

select * from v_arm_info_allazs_psv;

SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '--Реестр всех Нефтебаз, по которым есть информация о бакапах' as "_" from dual;
SET HEADING ON

select * from v_arm_info_allnb_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--АЗС и нефтебазы без резервного копирования (HotCopy)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_nohotcopy_psv;

SET HEADING OFF
select '-------------------- ВНИМАНИЕ!!! ------------------------------------------' as "_" from dual;
select '--АЗС и нефтебазы без снятия дампа (DAMP_RUN.BAT)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_nodump_psv;

exit
