--
-- V_ARC_REZ  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_ARC_REZ
(DATEUPLOAD, REZ_NUM, REZ_NUM_UNP, VOL, DEAD_VOL, 
 MAX_VOL, PRIM, DISP_NAME, AR_TOV_ID, PROD_ID_NPR, 
 ORG_STRU_ID, STATUS, MAX_VOL_M3, DEAD_VOL_M3, TRK_COUNT, 
 FOR_AND, KOL_LKREZERV)
AS 
select z.data_zamer_reservuar+1 as dateupload,
       z.id_reservuar as rez_num,
       r.nomer_reservuar as rez_num_unp,
       z.tonag as vol,
       r.mertv_ostatok as dead_vol,
       r.max_vzliv as max_vol,
       z.primechanie as prim,
       null as disp_name,
       decode(z.id_vid_oil_product,1,1,0) as ar_tov_id,
       p.id_npr as prod_id_npr,
       1 as org_stru_id,
       null as status,
       null as max_vol_m3,
       null as dead_vol_m3,
       null as trk_count,
       null as for_and,
       z.KOL_LKREZERV                
from art.zamer_reservuar z, art.reservuar r, art.sprav_oil_product o,
     master.kls_prod p
where z.id_reservuar=r.id_reservuar
      and z.id_sprav_oil_product=o.id_sprav_oil_product
      and to_char(o.okp, 'FM0999999999')=p.kod_10;


