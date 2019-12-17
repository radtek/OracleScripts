--
-- V_REZ_UNP_ESB  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_REZ_UNP_ESB
(DATE_ZAMER, FACTORY_KSSS, TANK_PARK, TANK_NUMBER, PRODUCT_CODE, 
 PRODUCT_NAME, PRODUCT_KSSS, STATUS, GDS_W, DEAD_W, 
 FREE_W, INFORM, TRANSIT_W, TECH_W, STORE_OBJ_ID, 
 KOD_OWN_KC, SUPPLY_KSSS, SRC_CATEGORY_ID, GDS_W2)
AS 
SELECT z.data_zamer_reservuar+1 AS date_zamer,
          157143 AS factory_ksss,
          decode (r.id_vid_rezervuar,14,'ВЦ','Товарный парк') AS tank_park,
          r.nomer_reservuar AS tank_number,
          z.id_sprav_oil_product AS product_code,
          p.name_npr AS product_name,
          o.kccc AS product_ksss,
          DECODE (z.id_vid_oil_product,
                  1, 'Паспортизовано',
                  'Не паспортизовано')
             AS status,
          art.pkt_sv_new.ras_ost (z.tonag, r.mertv_ostatok, 0) AS gds_w,
          art.pkt_sv_new.ras_mo (z.tonag, r.mertv_ostatok) AS dead_w,
          art.pkt_sv_new.ras_sve (z.tonag, r.max_vzliv) AS free_w,
          z.primechanie AS inform,
          0 as TRANSIT_W,
          0 as TECH_W,
          1149 as STORE_OBJ_ID,
          157143 as KOD_OWN_KC,
          157143 as SUPPLY_KSSS,
          6 as SRC_CATEGORY_ID,
          z.kol_lkrezerv as gds_w2
     FROM art.zamer_reservuar z,
          art.reservuar r,
          art.sprav_oil_product o,
          master.kls_prod p
    WHERE     z.id_reservuar = r.id_reservuar
          AND z.id_sprav_oil_product = o.id_sprav_oil_product
          AND TO_CHAR (o.okp, 'FM0999999999') = p.kod_10
          AND o.kccc IS NOT NULL
          AND (z.id_vid_oil_product = 1 OR z.id_vid_oil_product = 3)
          AND o.k_sort LIKE '1%'
          --AND r.id_vid_rezervuar <> 14
;


