--
-- V_LP_77203  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_LP_77203
(P1, P2, P3, P4, P5, 
 P6, P7, P51, DATA_FACT, GL_NAME)
AS 
select 1 as p1, -- физический показатель
       122 as p2, -- единица измерения
       1 as p3, -- периодичность
       10 as p4, -- статус показателя
       157143 as p5, -- Отчитывающиеся предприятие
       s.kccc as p6, -- материал(основная деятельность)
       2 as p7, -- Тип данных (2-за сутки)
       art.pkt_sv_new.tovar2(trunc(sysdate)-1, decode(s.id_sprav_oil_product,55,substr(s.k_sort,1,9),s.k_sort), 1) as p51,
       trunc(sysdate)-1 as data_fact,
       s.gl_name
   from art.sv_str_prvo s, art.plan_m m
   where s.id_plan=m.id_plan
     and s.num=5 and s.id_sprav_oil_product>0 --and s.plan_m>0
     and s.id_sprav_oil_product<>6 and s.id_sprav_oil_product<>41 and s.id_sprav_oil_product<>557 and s.id_sprav_oil_product<>630
     and m.data_n=trunc(sysdate-1,'mm')
     and m.id_vid_plan = 1

union all

select 1 as p1, -- физический показатель
       122 as p2, -- единица измерения
       1 as p3, -- периодичность
       10 as p4, -- статус показателя
       157143 as p5, -- Отчитывающиеся предприятие
       s.kccc as p6, -- материал(основная деятельность)
       3 as p7, -- Тип данных (3-с нач.мес.)
       art.pkt_sv_new.tovar2(trunc(sysdate)-1, decode(s.id_sprav_oil_product,55,substr(s.k_sort,1,9),s.k_sort), 2) as p51,
       trunc(sysdate)-1 as data_fact,
       s.gl_name
   from art.sv_str_prvo s, art.plan_m m
   where s.id_plan=m.id_plan
     and s.num=5 and s.id_sprav_oil_product>0 --and s.plan_m>0
     and s.id_sprav_oil_product<>6 and  s.id_sprav_oil_product<>41 and s.id_sprav_oil_product<>557 and s.id_sprav_oil_product<>630
     and m.data_n=trunc(sysdate-1,'mm')
     and m.id_vid_plan = 1;


