--
-- V_CLIENTBANK  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_CLIENTBANK
(BO_SENDER, BO_INN_S, BO_ACC_S, BO_BIK_S, KREDIT, 
 DEBET, BO_RECEIVER, BO_INN_R, BO_ACC_R, BO_BIK_R, 
 BO_NUM, BO_NAZN, BO_DT, BO_KS_R, BO_KS_S, 
 BO_VID, BO_RN_PARUS, ID, ACCKEY, BO_SUMM, 
 ID_CODE, RID)
AS 
SELECT /*+ PARALLEL (PVZ_BNOPRS 2) */
       cb.Bo_sender, cb.Bo_inn_s, cb.Bo_acc_s,
       cb.Bo_bik_s,
       DECODE (cb.Bo_vid, 1, cb.Bo_summ, 0) AS Kredit,
       DECODE (cb.Bo_vid, 1, 0, cb.Bo_summ) AS Debet,
       cb.Bo_receiver, cb.Bo_inn_r, cb.Bo_acc_r,
       cb.Bo_bik_r, cb.Bo_num, cb.Bo_nazn,
       cb.Bo_dt, cb.Bo_ks_r, cb.Bo_ks_s,
       cb.Bo_vid, cb.Bo_rn_parus, cb.ID,
       cb.Acckey, cb.Bo_summ, cb.Id_code, ROWID as rid
  FROM Pvz.Pvz_bnoprs@Oracle.World cb;


