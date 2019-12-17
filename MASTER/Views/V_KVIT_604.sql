--
-- V_KVIT_604  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_KVIT_604
(ID, FLG_OPERDATA, MESTO_ID, NOM_ZD, PROD_ID_NPR, 
 TEX_PD_ID, NUM_CIST, DATE_OTGR, VES, VES_BRUTTO, 
 VES_ED, KOL_ED, TARIF, TARIF19, TARIF_ORIG, 
 NUM_KVIT, DATE_KVIT, NUM_MILITARY, FLG_DOP_CIST, FLG_VAG_KLIENT, 
 VAGOWNER_ID, VAGONTYPE_ID, KALIBR_ID, VES_CIST, DATE_VOZ, 
 KVIT_VOZ, SUM_VOZ, DATE_OTV, PLOMBA1, PLOMBA2, 
 ROSINSPL1, ROSINSPL2, VZLIV, TEMPER, FAKT_PL, 
 FORMNAKL_ID, SHABEXP_ID, GTD, EXPED_ID, VETKA_OTP_ID, 
 NUM_EXP_MAR, BILL_ID, SVED_ID, DATE_OFORML, SVED_NUM, 
 PASP_ID, NUM_NAR, NUM_DOVER, PERER_ID, DATE_EDIT, 
 JKCOMMIT, GROTP_ID, PERECH_TEXPD_DATE, PERECH_TEXPD_NUM, SUM_PROD, 
 SUM_AKCIZ, SUM_PROD_NDS, TARIF_NDS, SUM_VOZN11, SUM_VOZN11_NDS, 
 SUM_VOZN12, SUM_VOZN12_NDS, SUM_STRAH, CENA, CENA_OTP, 
 DATE_CENA, CENA_VOZN, CAPACITY, TARIF_GUARD, TARIF_GUARD_NDS, 
 TARIF_ALT, NACENKA, PODDONS, SHIELDS, UPAK_ID, 
 UPAK_VES, KOL_NET, UPAK_VES_ED, SHIELD_VES, PODDON_VES, 
 PL, NUM_AKT, BILL_POS_ID, PROTO_NUM, PROTO_DATE, 
 NO_AKCIZ, PERECH_GUARD_DATE, PERECH_GUARD_NUM, TTN_ID, DATE_DOVER, 
 FIO_DRIVER, IS_LOADED, AXES, CTLV, DEFI_MASS_ID, 
 VOLUME, VOLUME15, ZPU_TYPE1, ZPU_TYPE2, PL15, 
 DATE_IN, CONTRACT, TTN)
AS 
select kvit."ID",kvit."FLG_OPERDATA",kvit."MESTO_ID",kvit."NOM_ZD",kvit."PROD_ID_NPR",kvit."TEX_PD_ID",kvit."NUM_CIST",kvit."DATE_OTGR",kvit."VES",kvit."VES_BRUTTO",kvit."VES_ED",kvit."KOL_ED",kvit."TARIF",kvit."TARIF19",kvit."TARIF_ORIG",kvit."NUM_KVIT",kvit."DATE_KVIT",kvit."NUM_MILITARY",kvit."FLG_DOP_CIST",kvit."FLG_VAG_KLIENT",kvit."VAGOWNER_ID",kvit."VAGONTYPE_ID",kvit."KALIBR_ID",kvit."VES_CIST",kvit."DATE_VOZ",kvit."KVIT_VOZ",kvit."SUM_VOZ",kvit."DATE_OTV",kvit."PLOMBA1",kvit."PLOMBA2",kvit."ROSINSPL1",kvit."ROSINSPL2",kvit."VZLIV",kvit."TEMPER",kvit."FAKT_PL",kvit."FORMNAKL_ID",kvit."SHABEXP_ID",kvit."GTD",kvit."EXPED_ID",kvit."VETKA_OTP_ID",kvit."NUM_EXP_MAR",kvit."BILL_ID",kvit."SVED_ID",kvit."DATE_OFORML",kvit."SVED_NUM",kvit."PASP_ID",kvit."NUM_NAR",kvit."NUM_DOVER",kvit."PERER_ID",kvit."DATE_EDIT",kvit."JKCOMMIT",kvit."GROTP_ID",kvit."PERECH_TEXPD_DATE",kvit."PERECH_TEXPD_NUM",kvit."SUM_PROD",kvit."SUM_AKCIZ",kvit."SUM_PROD_NDS",kvit."TARIF_NDS",kvit."SUM_VOZN11",kvit."SUM_VOZN11_NDS",kvit."SUM_VOZN12",kvit."SUM_VOZN12_NDS",kvit."SUM_STRAH",kvit."CENA",kvit."CENA_OTP",kvit."DATE_CENA",kvit."CENA_VOZN",kvit."CAPACITY",kvit."TARIF_GUARD",kvit."TARIF_GUARD_NDS",kvit."TARIF_ALT",kvit."NACENKA",kvit."PODDONS",kvit."SHIELDS",kvit."UPAK_ID",kvit."UPAK_VES",kvit."KOL_NET",kvit."UPAK_VES_ED",kvit."SHIELD_VES",kvit."PODDON_VES",kvit."PL",kvit."NUM_AKT",kvit."BILL_POS_ID",kvit."PROTO_NUM",kvit."PROTO_DATE",kvit."NO_AKCIZ",kvit."PERECH_GUARD_DATE",kvit."PERECH_GUARD_NUM",kvit."TTN_ID",kvit."DATE_DOVER",kvit."FIO_DRIVER",kvit."IS_LOADED",kvit."AXES",kvit."CTLV",kvit."DEFI_MASS_ID",kvit."VOLUME",kvit."VOLUME15",kvit."ZPU_TYPE1",kvit."ZPU_TYPE2",kvit."PL15",kvit."DATE_IN", 
trim(GET_CONTRACT_PARUS_VZ(kvit.num_kvit,'GD_CONT',kvit.date_kvit)) as contract,
--'11' as CONTRACT,
trim(GET_CONTRACT_PARUS_VZ(kvit.num_kvit,'GD_ACC',kvit.date_kvit)) as ttn
--'11' as TTN
 

from  kvit;

