select * from
(
select 
SUBSTR(owi.line_id, -10, 10) as line_id,
doc.doc_num "�����_���������", 
fact.num_otgr "�����_����",
fact.num_sec "������", 
doc.date_doc "����", 
gds.name "�������", 
owi.volume "�����", 
owi.pure_weight "�����", 
round(fact.ves,3) "�����_����", 
fact.vzliv "�����_����", 
PCK_ADM.FNC_GET_EMPLOYEE(access_.from_emp_id, 1) "���_��������_���������", 
PCK_ADM.FNC_GET_EMPLOYEE(access_.emp_id, 1) "����_���������_���������", 
access_.begin_date "������_�����������", 
access_.end_date "���������_�����������", 
access_.note "�������" 
from 
out_wbill_mo_os_i owi, 
lider.document doc, 
(select
"id" as id, 
"card_id" as card_id, 
"ves" as ves, 
"vzliv" as vzliv,
"num_sec" as num_sec,
"num_otgr" as num_otgr
from sh30@naliv) fact, 
(select  
da.doc_id,
max(da.BEGIN_DATE) begin_date,
max(da.END_DATE) end_date, 
from_emp.id from_emp_id,
emp.id emp_id,
da.note 
from  
document_access da, 
employee_moving from_emp_mov, 
employee_moving emp_mov, 
employee from_emp, 
employee emp 
where da.EMP_MOV_ID=emp_mov.id 
and from_emp_mov.id=da.FROM_EMP_MOVING_ID 
and from_emp_mov.EMPLOYEE_ID=from_emp.id 
and emp_mov.employee_id=emp.id
group by da.doc_id,from_emp.id,emp.id,da.note 
) access_, 
goods gds 
where owi.doc_id=doc.id 
and owi.doc_id=access_.doc_id (+) 
and fact.card_id (+)=SUBSTR(owi.line_id, -10, 10) 
and doc.date_doc>=to_date(:FROM_DATE,'dd.mm.yyyy') 
and doc.date_doc<to_date(:TO_DATE,'dd.mm.yyyy') 
and owi.gds_id=gds.id 
and doc.home_ent_id=892000000011089
and doc.unit_id<>1
union all
select 
"card_id" as line_id,
'' as "�����_���������", 
"num_otgr" as  "�����_����",
"num_sec" as "������", 
"np_data_o" as "����", 
"prod_abbr2" as "�������", 
0 as "�����", 
0 as "�����", 
round("ves",3) "�����_����", 
"vzliv" as "�����_����", 
'' as "���_��������_���������", 
'' as "����_���������_���������", 
NULL as "������_�����������", 
NULl as "���������_�����������", 
'' as "�������" 
from sh30@naliv fact
where "np_data_o">=to_date(:FROM_DATE,'dd.mm.yyyy') 
and "np_data_o"<to_date(:TO_DATE,'dd.mm.yyyy')
and "card_id" not in 
(
select 
SUBSTR(owi.line_id, -10, 10)
from 
out_wbill_mo_os_i owi, 
lider.document doc, 
goods gds 
where owi.doc_id=doc.id 
and doc.date_doc>=to_date(:FROM_DATE,'dd.mm.yyyy') 
and doc.date_doc<to_date(:TO_DATE,'dd.mm.yyyy') 
and owi.gds_id=gds.id 
and doc.home_ent_id=892000000011089
and doc.unit_id<>1
)
)
order by "����", "�����_���������","������" 
