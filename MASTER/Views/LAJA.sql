--
-- LAJA  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.LAJA
("ПРОДУКТ", "ПЛАТЕЛЬЩИКДОГ", "ПЛАТЕЛЬЩИК", "ВЕС", "СУММА", 
 DATE_KVIT)
AS 
SELECT 
  prod_group.name_npr AS Продукт,
  kls_predpr.PREDPR_NAME AS ПлательщикДог, 
  RTRIM(LTRIM(DECODE(STUPID_PLAT(kls_dog.predpr_id),'ничего',kls_groupdog.groupdog_name,STUPID_PLAT(kls_dog.predpr_id)))) AS Плательщик, 
  k.ves/1000 AS Вес,
  p.summa/1000 AS Сумма,
  bills.date_buxg AS date_kvit
 FROM 
   bills, kls_dog, kls_prod, 
   kls_prod prod_group,kls_predpr, 
   kls_groupdog, (SELECT kvit.bill_id,SUM(kvit.ves) AS ves FROM kvit GROUP BY bill_id) k,
   (SELECT bill_pos.NOM_DOK,SUM(bill_pos.SUMMA) AS summa FROM bill_pos WHERE bill_pos_id<10 GROUP BY nom_dok) p
 WHERE 
     (kls_prod.id_npr = bills.prod_id_npr)
 AND (bills.dog_id = kls_dog.id)
 AND (kls_prod.id_group_npr = prod_group.id_npr)
 AND (kls_groupdog.id = kls_dog.groupdog_id)
 AND (kls_predpr.ID=kls_dog.PREDPR_ID)
 AND bills.date_kvit>=TO_DATE('01.01.01','dd.mm.rr')
 AND (k.bill_id = bills.nom_dok)
 AND (p.nom_dok = bills.nom_dok);


