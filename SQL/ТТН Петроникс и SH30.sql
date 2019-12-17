select * from
(
select 
SUBSTR(owi.line_id, -10, 10) as line_id,
doc.doc_num "Номер_накладной", 
fact.num_otgr "Номер_авто",
fact.num_sec "Секция", 
doc.date_doc "Дата", 
gds.name "Продукт", 
owi.volume "Объем", 
owi.pure_weight "Масса", 
round(fact.ves,3) "Масса_факт", 
fact.vzliv "Объем_факт", 
PCK_ADM.FNC_GET_EMPLOYEE(access_.from_emp_id, 1) "Кто_разрешил_исправить", 
PCK_ADM.FNC_GET_EMPLOYEE(access_.emp_id, 1) "Кому_разрешено_исправить", 
access_.begin_date "Начало_исправления", 
access_.end_date "Окончание_исправления", 
access_.note "Причина" 
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
'' as "Номер_накладной", 
"num_otgr" as  "Номер_авто",
"num_sec" as "Секция", 
"np_data_o" as "Дата", 
"prod_abbr2" as "Продукт", 
0 as "Объем", 
0 as "Масса", 
round("ves",3) "Масса_факт", 
"vzliv" as "Объем_факт", 
'' as "Кто_разрешил_исправить", 
'' as "Кому_разрешено_исправить", 
NULL as "Начало_исправления", 
NULl as "Окончание_исправления", 
'' as "Причина" 
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
order by "Дата", "Номер_накладной","Секция" 
