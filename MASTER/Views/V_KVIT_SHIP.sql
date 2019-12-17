--
-- V_KVIT_SHIP  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KVIT_SHIP
(PROD_ID_NPR, DATE_OTGR, QUAN)
AS 
SELECT  
      PROD_ID_NPR
      ,DATE_OTGR
      ,sum(VES) as quan 
      
  FROM KVIT
where date_otgr>'01-jun-2018'
and VAGONTYPE_ID = 0
 AND NUM_CIST = 'ро'
  group by PROD_ID_NPR,DATE_OTGR;


