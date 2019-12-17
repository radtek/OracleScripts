/*******************************������� �1**********************************/
select
rownum "�",
sel.*
from
(
select
s.doc_number "��������",
s.doc_date "��",
s.user_name "������������",
s.fact_volume "������ (�������), �",
s.fact_weight "����� ����������, ��",
s.volume "����� � ���������, �",
s.pure_weight "����� � ���������, ��",
s.gds_name "�������",
s.car_name "������",
s.secno "������",
s.driver "��������"
from
lider.v_mvd_psv s
order by s.doc_id,"��","������","������"
) sel


/*******************************������� �2**********************************/
select * from
(
select distinct
s.doc_number "����� ���������",
s.doc_date "���� ���������",
s.car_name "������",
s.secno "������",
A_OWI.Z_USER_id "��� ������������",
decode(a_owi.z_oper,'I','����������','U','���������','D','��������') "��������",
A_OWI.Z_DATE_OPER "���� ��������",
A_OWI.Z_USER "������� ������",
DECODE(A_OWI.Z_USER,'MASTER','�����-�������',(select PCK_ADM.FNC_GET_EMPLOYEE(sud.emp_id) from sys_user_desc sud where sud.sysname=A_OWI.Z_USER)) "������������",
A_OWI.Z_MACHINE "���������",
A_OWI.CAR_VOLUME "����� �������",
A_OWI.VOLUME "����� ����������",
A_OWI.PURE_WEIGHT*1000 "����� ����������",
s.doc_id
from 
lider.v_mvd_psv s,
audit_user.za_out_wbill_mo_os_i a_owi
where a_owi.line_id = s.line_id
)
order by doc_id,"���� ���������","������", "������", "���� ��������", "��������"

/*******************************������� �3**********************************/
select
  s.doc_number "����� ���������",
  a.event_time "����",
  s.car_name "������",
  s.secno "������",
  s.line_id "��� ���������",
  a.logfile_name "LOG ����",
  a.fact_volume "������ (�����), �",
  a.fact_weight "����� ���������� (�����), ��",
  b.name as "���������� �� ������",
  '����� � '||to_char(c.seqno) as "����������"
from AZSBUFFER.V_ASUTPLOG_PSV@MASTER.CORP.LUKOIL.COM a,
v_mvd_psv s,
  (select * from alarm_type where id not in (1,99)
   union all
   select 0,'����� ���������','','' from dual
   union all
   select 1,'����� ����������','','' from dual
   union all
   select 99,'������������� �����','','' from dual
  ) b,
  flowmeter_desc c
where s.line_id=a.line_id
  and nvl(a.alarm_id,0)=b.id(+)
  and a.flow_desc_id=c.id
order by s.doc_id,a.event_time 
