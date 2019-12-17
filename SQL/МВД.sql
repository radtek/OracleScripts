/*******************************ТАБЛИЦА №1**********************************/
select
rownum "№",
sel.*
from
(
select
s.doc_number "Документ",
s.doc_date "От",
s.user_name "Пользователь",
s.fact_volume "Налито (счетчик), л",
s.fact_weight "Масса фактически, кг",
s.volume "Объем в накладной, л",
s.pure_weight "Масса в накладной, кг",
s.gds_name "Продукт",
s.car_name "Машина",
s.secno "Секция",
s.driver "Водитель"
from
lider.v_mvd_psv s
order by s.doc_id,"От","Машина","Секция"
) sel


/*******************************ТАБЛИЦА №2**********************************/
select * from
(
select distinct
s.doc_number "Номер документа",
s.doc_date "Дата документа",
s.car_name "Машина",
s.secno "Секция",
A_OWI.Z_USER_id "Код пользователя",
decode(a_owi.z_oper,'I','Добавление','U','Изменение','D','Удаление') "Операция",
A_OWI.Z_DATE_OPER "Дата операции",
A_OWI.Z_USER "Учетная запись",
DECODE(A_OWI.Z_USER,'MASTER','АСУТП-система',(select PCK_ADM.FNC_GET_EMPLOYEE(sud.emp_id) from sys_user_desc sud where sud.sysname=A_OWI.Z_USER)) "Пользователь",
A_OWI.Z_MACHINE "Компьютер",
A_OWI.CAR_VOLUME "Объем задания",
A_OWI.VOLUME "Объем фактически",
A_OWI.PURE_WEIGHT*1000 "Масса фактически",
s.doc_id
from 
lider.v_mvd_psv s,
audit_user.za_out_wbill_mo_os_i a_owi
where a_owi.line_id = s.line_id
)
order by doc_id,"Дата документа","Машина", "Секция", "Дата операции", "Операция"

/*******************************ТАБЛИЦА №3**********************************/
select
  s.doc_number "Номер документа",
  a.event_time "Дата",
  s.car_name "Машина",
  s.secno "Секция",
  s.line_id "Код документа",
  a.logfile_name "LOG файл",
  a.fact_volume "Налито (АСУТП), л",
  a.fact_weight "Масса фактически (АСУТП), кг",
  b.name as "Информация по наливу",
  'Стояк № '||to_char(c.seqno) as "Примечание"
from AZSBUFFER.V_ASUTPLOG_PSV@MASTER.CORP.LUKOIL.COM a,
v_mvd_psv s,
  (select * from alarm_type where id not in (1,99)
   union all
   select 0,'Налив стартовал','','' from dual
   union all
   select 1,'Налив завершился','','' from dual
   union all
   select 99,'Незавершенный налив','','' from dual
  ) b,
  flowmeter_desc c
where s.line_id=a.line_id
  and nvl(a.alarm_id,0)=b.id(+)
  and a.flow_desc_id=c.id
order by s.doc_id,a.event_time 
