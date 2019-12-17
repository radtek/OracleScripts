--
-- XX101_ZKERP_TO_KVIT  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.XX101_ZKERP_TO_KVIT
(FILENAME, PARSEDATETIME, PROPAGATESTATUS, FILEROWNUM, ACTIONCODE, 
 WAYBILLID, WAYBILLROWID, ID, PROD_ID_NPR, NUM_CIST, 
 DATE_OTGR, VES, KOL_NET, TARIF, NUM_KVIT, 
 DATE_KVIT, VAGONTYPE_ID, KALIBR_ID, VZLIV, MESTO_ID, 
 VETKA_OTP_ID, VAGOWNER_ID, NOM_ZD, AXES, VES_BRUTTO, 
 SVED_NUM, DATE_OFORML, PLOMBA1, PLOMBA2, TEMPER, 
 FAKT_PL, SHABEXP_ID, SVED_ID, KOL_ED, VES_ED, 
 VES_CIST, PASP_ID, PASP_NUM, NUM_DOVER, CAPACITY, 
 PODDONS, TTN_ID, FIO_DRIVER, DATE_DOVER, VOLUME, 
 FLG_DOP_CIST)
AS 
SELECT filename,
          parsedatetime,
          propagatestatus,
          filerownum,
          z.actioncode,
          --------------------------------------------------------------------------------
          -- —Â„ÂÈ ¿ÌÚÓÌÓ‚ 06.10.2008
          waybillid,
          waybillrowid,
          --------------------------------------------------------------------------------

          TO_NUMBER (waybillid || waybillrowid) AS id,
          prod.id_npr AS prod_id_npr,
          SUBSTR (transportnum, 1, 10) AS num_cist,
          ADD_MONTHS (shipmentdate, 0) AS date_otgr,
          DECODE (prod.id_npr, '90000', totalweight, pureweight) AS ves,
          pureweight AS kol_net,
          ora_val (tariff) AS tarif,
          ora_val (kvitnum) AS num_kvit,
          ADD_MONTHS (kvitdate, 0) AS date_kvit,
          NVL ( (SELECT vt.id
                 FROM kls_vagontype vt
                 WHERE z.transporttypecode LIKE vt.isu_kod2), 0
          )
             AS vagontype_id,
          NVL ( (SELECT k.id
                 FROM kls_kalibr k
                 WHERE REPLACE (z.transportunittype, 'A', '¿') LIKE k.kod_isu),
               '0'
          )
             AS kalibr_id,
          (CASE WHEN transportkind = '01' THEN ora_val (productvolume) ELSE fillingheight END) AS vzliv,
          (CASE WHEN transportkind = '01' THEN 2 ELSE 1 END) AS mesto_id,
          (CASE WHEN transportkind = '01' THEN 7 ELSE 14 END) AS vetka_otp_id,
          (CASE
              WHEN ownershiptype = 1
              THEN
                 3
              ELSE
                 NVL ( (SELECT id
                        FROM kls_vagowner
                        WHERE isu_postav_name =
                                 DECODE (z.owner,
                                    'Ã¿√»—“–¿À‹ Õ≈‘“≈Œ–√—»Õ≈«', 'ÃÕŒ—',
                                    'Ã¿√»—“–¿À‹ Õ≈‘“≈Œ–√—»Õ“≈«', 'ÃÕŒ—',
                                    '«¿Œ "À” Œ…À-“–¿Õ—"', 'À” Œ…À-“–¿Õ—',
                                    'ŒŒŒ "À” Œ…À-“–¿Õ—"', 'À” Œ…À-“–¿Õ—',
                                    z.owner)),
                      99
                 )
           END)
             AS vagowner_id,
          z.ordercode AS nom_zd,
          z.axescount AS axes,
          DECODE (prod.id_npr, '90000', totalweight, pureweight) AS ves_brutto,
          DECODE (reestrnum, '1300000118', NULL, reestrnum) AS sved_num,
          (CASE
              WHEN shipmentdate IS NULL
              THEN
                 TO_DATE (NULL)
              ELSE
                 TO_DATE (TO_CHAR (ADD_MONTHS (shipmentdate, 0), 'dd.mm.yyyy')
                          || ' '
                          || SUBSTR (z.shipmenttime, 1, 2)
                          || ':'
                          || SUBSTR (z.shipmenttime, 3, 2)
                          || ':'
                          || SUBSTR (z.shipmenttime, 5, 2),
                          'dd.mm.yyyy hh24:mi:ss'
                 )
           END)
             AS date_oforml,
          seal1 AS plomba1,
          seal2 AS plomba2,
          tempoffilling AS temper,
          densityfact AS fakt_pl,
          TO_NUMBER (ttnsamplecode) AS shabexp_id,
          (CASE
              WHEN reestrnum || ' ' = ' ' OR reestrnum = '1300000118' THEN ''
              ELSE 'R' || SUBSTR (reestrnum, -8, 8)
           END)
             AS sved_id,
          packingitemcount AS kol_ed,
          z.packingitemweight AS ves_ed,
          ora_val (z.tarevagonweight) AS ves_cist,
          (CASE
              WHEN z.passportnum || ' ' = ' '
              THEN
                 ''
              WHEN TO_NUMBER (z.passportnum) > 3000000000
              THEN
                 'R' || TO_CHAR (TO_NUMBER (z.passportnum) - 3000000000)
              ELSE
                 'R' || z.passportnum
           END)
             AS pasp_id,
          z.passportnum AS pasp_num,
          warrantnum AS num_dover,
          ora_val (vagontonnage) AS capacity,
          pancount AS poddons,
          TO_NUMBER (waybillid) AS ttn_id,
          driverfio AS fio_driver,
          warrantdate AS date_dover,
          ora_val (productvolume) AS volume,
          1 AS flg_dop_cist
   FROM --------------------------------------------------------------------------------
                                                  -- —Â„ÂÈ ¿ÌÚÓÌÓ‚ 06.10.2008
                                                        -- xx101_zkerp_data z,
  xx101_zkerp_pending_action z, --------------------------------------------------------------------------------
                                (SELECT *
                                 FROM kls_prod
                                 WHERE id_npr <= '90000') prod
   WHERE z.productcode = prod.ksss_prod_id(+);


