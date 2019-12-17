--
-- V_GU_DEC_MON  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_GU_DEC_MON
(COLUMN_A, COLUMN_B, COLUMN_C, COLUMN_D, COLUMN_E, 
 COLUMN_F, COLUMN_G, COLUMN_H, COLUMN_I, COLUMN_J)
AS 
select 
COLUMN_A, 
COLUMN_B, 
COLUMN_C, 
COLUMN_D, 
sum(COLUMN_E) as COLUMN_E, 
sum(COLUMN_F) as COLUMN_F, 
sum(COLUMN_G) as COLUMN_G, 
sum(COLUMN_H) as COLUMN_H, 
sum(COLUMN_I) as COLUMN_I, 
sum(COLUMN_J) as COLUMN_J
from 
(

select 
-- Заказ на месяц (3, E) 
       Null                               as COLUMN_A,  -- Дата 
       0                                  as COLUMN_B,  -- Возможность отгрузки по эстакадам 
       T2.NAME_NPR                        as COLUMN_C,  -- Продукт 
       (case T1.LOAD_ABBR when 'САМ' 
		  then T3.PREDPR_NAME || ' (а/н)' 
	      else T3.PREDPR_NAME || ' (ж/д)' 
        end)                              as COLUMN_D, 
       T1.VES                                  as COLUMN_E,  -- Заказ на месяц, тн 
       0                        as COLUMN_F,  -- Отгрузка по графику, тн 
       0                                  as COLUMN_G,  -- Задание на сутки, тн 
       0                                  as COLUMN_H,  -- Отклонение от графика, тн 
       0                                  as COLUMN_I,  -- Факт за сутки, тн 
       0                                  as COLUMN_J,   -- Отклонение от задания на сутки, тн
       T1.input_number 
from V_MASTER_REPORTS V1, ZAKAZ T1 
join KLS_PROD T2 on (T1.PROD_ID_NPR = T2.ID_NPR) 
join KLS_PREDPR T3 on (T1.PLAT_ID = T3.ID) 
where (T1.DATE_PLAN between V1.BEGIN_DATE and Last_Day(V1.BEGIN_DATE)) and 
      (Nls_Upper(V1.REPORT_FILE) = 'GU_DEC.XLS') and 
      t1.is_agent=1 and
      t1.is_accept=1
union all
select 
-- Заказ на месяц (3, E) 
       Null                               as COLUMN_A,  -- Дата 
       0                                  as COLUMN_B,  -- Возможность отгрузки по эстакадам 
       T2.NAME_NPR                        as COLUMN_C,  -- Продукт 
       (case T1.LOAD_ABBR when 'САМ' 
		  then T3.PREDPR_NAME || ' (а/н)' 
	      else T3.PREDPR_NAME || ' (ж/д)' 
        end)                              as COLUMN_D, 
       T1.TONN_DECLARED                                  as COLUMN_E,  -- Заказ на месяц, тн 
       0                        as COLUMN_F,  -- Отгрузка по графику, тн 
       0                                  as COLUMN_G,  -- Задание на сутки, тн 
       0                                  as COLUMN_H,  -- Отклонение от графика, тн 
       0                                  as COLUMN_I,  -- Факт за сутки, тн 
       0                                  as COLUMN_J,   -- Отклонение от задания на сутки, тн
       T1.nom_zd 
from V_MASTER_REPORTS V1, MONTH T1 
join KLS_PROD T2 on (T1.PROD_ID_NPR = T2.ID_NPR) 
join KLS_DOG D on (T1.DOG_ID = D.ID) 
join KLS_PREDPR T3 on (D.PREDPR_ID = T3.ID) 
where (T1.DATE_PLAN between V1.BEGIN_DATE and Last_Day(V1.BEGIN_DATE)) and 
      (Nls_Upper(V1.REPORT_FILE) = 'GU_DEC.XLS') and 
      T1.is_exp=1
)      
group by 
COLUMN_A, COLUMN_B, COLUMN_C, COLUMN_D;


