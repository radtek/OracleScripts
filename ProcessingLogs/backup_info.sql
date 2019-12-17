Connect azsbuffer/azsbuffer@buh

-- set echo off
-- set termout off
set trimout off
set trimspool on
set linesize 1000
set pagesize 5000
alter session set nls_date_format='dd.mm.yyyy hh24:mi:ss';

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--��� � ��������� � ������������ ������ ������� HotCopy (����� 7 ����)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_hotcopyold_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--��� � ��������� � ������������ ������� ����� DAMP_RUN.BAT (����� 2 ����)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_dumpold_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--��� � ��������� � ������������ ���������� ������� MoveArchiveLog (����� 1 ���)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_archivelogsold_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--�� ������������� ������ ���������� �����������' as "_" from dual;
SET HEADING ON

select * from v_arm_info_backuperrors_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--������ �� ��� �� ��������� 4 �����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_lasterrorsazs_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--� �.�. ORACLE-������ �� ��� �� ��������� 4 �����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_oraerrorsazs_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--������ �� ���������� �� ��������� 4 �����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_lasterrorsnb_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--� �.�. ORACLE-������ �� ���������� �� ��������� 4 �����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_oraerrorsnb_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--������ �� ������ �� �� ��������� 4 �����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_lasterrorsother_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--�������� ����������' as "_" from dual;
SET HEADING ON

select * from v_arm_info_parameters1_psv;

select * from v_arm_info_parameters2_psv;


SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--���������� �� �����������' as "_" from dual;
SET HEADING ON

select * from v_arm_info_antivirus_psv;


SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '-- ��� - ������� ����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_time_zone_azs_psv;

SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '-- ��������� - ������� ����' as "_" from dual;
SET HEADING ON

select * from v_arm_info_time_zone_nb_psv;



SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '--������ ���� ���, �� ������� ���� ���������� � �������' as "_" from dual;
SET HEADING ON

select * from v_arm_info_allazs_psv;

SET HEADING OFF
select '---------------------------------------------------------------------------' as "_" from dual;
select '--������ ���� ��������, �� ������� ���� ���������� � �������' as "_" from dual;
SET HEADING ON

select * from v_arm_info_allnb_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--��� � ��������� ��� ���������� ����������� (HotCopy)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_nohotcopy_psv;

SET HEADING OFF
select '-------------------- ��������!!! ------------------------------------------' as "_" from dual;
select '--��� � ��������� ��� ������ ����� (DAMP_RUN.BAT)' as "_" from dual;
SET HEADING ON

select * from v_arm_info_nodump_psv;

exit
