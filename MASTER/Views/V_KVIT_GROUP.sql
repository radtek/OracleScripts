--
-- V_KVIT_GROUP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KVIT_GROUP
(PROD_ID_NPR, BILL_ID)
AS 
select kvit.prod_id_npr,kvit.BILL_ID from kvit
where kvit.date_kvit>= to_date('01.04.2002','dd.mm.yyyy')
group by kvit.prod_id_npr,kvit.BILL_ID;


