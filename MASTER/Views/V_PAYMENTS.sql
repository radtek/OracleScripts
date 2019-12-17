--
-- V_PAYMENTS  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PAYMENTS
(ID, DOG_ID, BANK_ID, RS, SUMMA, 
 NAZN_PLAT, OURBANK_ID, NUM_PLAT, DATE_PLAT, DATE_POST, 
 PAYFORM_ID, DOG_NUMBER, DOG_DATE, BANK_NAME, BANK_ADRESS, 
 OURBANK_NAME, OURBANK_ADRESS, PLAT_NAME, SUMMA_PLACED, PAYFORM_NAME, 
 DEST_ID, DEST_NAME, RS_ID, RS_UNP, PLAT_ID)
AS 
SELECT /*+ ORDERED INDEX (kls_predpr KLS_PREDPR_I_ID_SHORT_NAME_EMA) */
       PAYMENTS.ID, PAYMENTS.dog_id, PAYMENTS.bank_id, PAYMENTS.rs,
       PAYMENTS.summa, PAYMENTS.nazn_plat, PAYMENTS.ourbank_id,
       PAYMENTS.num_plat, PAYMENTS.date_plat, PAYMENTS.date_post,
       PAYMENTS.payform_id, KLS_DOG.dog_number, KLS_DOG.dog_date,
       KLS_BANKS.bank_name, KLS_BANKS.address AS bank_adress,
       kls_banks2.bank_name AS ourbank_name,
       kls_banks2.address AS ourbank_adress,
       KLS_PREDPR.predpr_name AS plat_name,
       (SELECT SUM (PAYMENTS_ON_BILLS.summa)
          FROM PAYMENTS_ON_BILLS
         WHERE PAYMENTS_ON_BILLS.payments_id = PAYMENTS.ID) AS summa_placed,
       KLS_PAYFORM.payform_name, PAYMENTS.dest_id,
       dest.dest_name AS dest_name, PAYMENTS.rs_id, rs.rs AS rs_unp,
       KLS_PREDPR.ID AS plat_id
  FROM PAYMENTS,
       KLS_DOG,
       KLS_PREDPR,
       KLS_PAYFORM,
       KLS_BANKS kls_banks2,
       KLS_BANKS,
       KLS_BILL_POS_TYPE dest,
       KLS_RS rs
 WHERE PAYMENTS.dog_id = KLS_DOG.ID(+)
   AND PAYMENTS.bank_id = KLS_BANKS.ID(+)
   AND PAYMENTS.ourbank_id = kls_banks2.ID(+)
   AND KLS_DOG.predpr_id = KLS_PREDPR.ID
   AND PAYMENTS.payform_id = KLS_PAYFORM.ID
   AND PAYMENTS.dest_id = dest.ID(+)
   AND PAYMENTS.rs_id = rs.ID;


