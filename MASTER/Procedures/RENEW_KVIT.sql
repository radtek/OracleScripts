--
-- RENEW_KVIT  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kvit (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
  v_dat DATE;
  cnt1 NUMBER;
BEGIN

UPDATE load_buffer.KVIT SET np_timep='00:00' WHERE SUBSTR(np_timep,1,1)=' ' OR np_timep IS NULL;
UPDATE load_buffer.KVIT SET time_e='00:00' WHERE SUBSTR(time_e,1,1)=' ' OR time_e IS NULL;
UPDATE load_buffer.KVIT SET np_data_o=date_otgr WHERE np_data_o IS NULL;
UPDATE load_buffer.KVIT SET date_e=date_otgr WHERE date_e IS NULL;
UPDATE load_buffer.KVIT SET kod_perer=0 WHERE kod_perer IS NULL;

  -- Определение архивной даты  
  BEGIN
    SELECT ARH_DATE.LAST_DATE INTO v_dat
	  FROM ARH_DATE WHERE ARH_DATE.TABLENAME='KVIT';
  EXCEPTION 
    WHEN OTHERS THEN
	  v_dat:=TO_DATE('31.12.1899','dd.mm.yyyy');
  END;	  	    

UPDATE MASTER.KVIT SET
  (FLG_OPERDATA,MESTO_ID,NOM_ZD,PROD_ID_NPR,TEX_PD_ID,NUM_CIST,DATE_OTGR,
   VES,VES_BRUTTO,VES_ED,KOL_ED,TARIF,TARIF19,TARIF_ORIG,NUM_KVIT,DATE_KVIT,
   NUM_MILITARY,FLG_DOP_CIST,FLG_VAG_KLIENT,VAGOWNER_ID,VAGONTYPE_ID,KALIBR_ID,
   VES_CIST,DATE_VOZ,KVIT_VOZ,SUM_VOZ,DATE_OTV,PLOMBA1,PLOMBA2,ROSINSPL1,ROSINSPL2,
   VZLIV,TEMPER,FAKT_PL,FORMNAKL_ID,SHABEXP_ID,GTD,EXPED_ID,VETKA_OTP_ID,
   /*BILL_ID,*/NUM_EXP_MAR,DATE_OFORML,SVED_NUM,SVED_ID,PASP_ID,PERER_ID,
   DATE_EDIT,JKCOMMIT,GROTP_ID,PERECH_TEXPD_NUM, PERECH_TEXPD_DATE,
   /*SUM_PROD, SUM_AKCIZ, SUM_PROD_NDS, TARIF_NDS, SUM_VOZN11, SUM_VOZN11_NDS, SUM_VOZN12, SUM_VOZN12_NDS, SUM_STRAH,
   DATE_CENA,CENA,CENA_OTP,*/CENA_VOZN,TARIF_GUARD,/*TARIF_GUARD_NDS,*/TARIF_ALT,CAPACITY,NACENKA,SHIELDS,PODDONS,
   UPAK_ID,UPAK_VES,UPAK_VES_ED,SHIELD_VES,PODDON_VES,KOL_NET,PL,/*NUM_AKT,PROTO_NUM,PROTO_DATE,NO_AKCIZ,*/PERECH_GUARD_NUM,PERECH_GUARD_DATE,
   AXES,CTLV,DEFI_MASS_ID,VOLUME,VOLUME15,PL15,/*ZPU_TYPE1,ZPU_TYPE2,*/NUM_NAR,NUM_DOVER,DATE_DOVER,FIO_DRIVER)
 = (SELECT 0,k.mesto,k.nom_zd,k.kod_npr,k.plat_tarif,k.num_cist,k.date_otgr,
   k.ves,DECODE(MONTH.NAZN_OTG_ID,4,k.ves_brutto,k.ves),k.wes_ed,k.kol_ed,k.TARIF,k.TARIF19,k.TARIF_ORIG,k.num_kvit,k.date_kvit,
   LTRIM(RTRIM(k.transp)),Iif(k.DOP_CIST,1,0),Iif(k.VAG_KLIENT,1,0),NVL(k.tipv,0),NVL(k.rodv,0),NVL(k.tip,'0'),
   k.tara_all,k.date_voz,k.KVIT_VOZ,k.SUM_VOZ,k.date_otv,k.PLOMBA1,k.PLOMBA2,k.ROSINSPL1,k.ROSINSPL2,
   k.VZLIV,k.TEMPER,k.XPL,0,k.rexp,NVL(k.GTD,''),E.KOD_PREDPR,k.gd_track,
   /*k.n_plat,*/k.n_mar,TO_DATE(TO_CHAR(np_data_o,'dd.mm.yyyy ') || SUBSTR(np_timep,1,5),'dd.mm.yyyy hh24:mi'),k.NP,k.sved_id,k.KODPASP,p_r.PREDPR_ID,
   TO_DATE(TO_CHAR(date_e,'dd.mm.yyyy ') || SUBSTR(time_e,1,5),'dd.mm.yyyy hh24:mi'),1,k.KOD_GROTP,k.NUM_PERECH,k.DAT_PERECH,
   /*k.D_41, k.SUM_AKCIZ, k.D_191, k.D_194, k.SUM_NALIV, k.NDC_NAL20, k.D_442, k.NDC_TR20, k.SUM_NACEN,*/
   /*k.date_cen,k.cena,k.cena_otp,*/NVL(k.cena_vozn,0),NVL(k.dop_tarif,0),/*NVL(k.ndc_doptar,0),*/NVL(k.tarif_alt,0),
   k.WES,k.NACENKA,k.shields,k.poddons,
   u.ID,k.bag_ves,k.bag1_ves,k.shld_ves,k.podd_ves,k.kol_net,k.pl,/*k.reestr,k.PROTO_NUM,k.PROTO_DATE,IIF(k.NO_AKCIZ,1,0),*/
   k.n_per_ohr,k.d_per_ohr,
   k.osc,k.ctlv,k.defi_mass,k.volume,k.volume15,k.pl15,/*k.ZPU_TYPE1,k.ZPU_TYPE2,*/k.NARIAD,k.DOVEREN,k.DATE_DOVER,k.FIO_DRIVER
          FROM load_buffer.KVIT k, load_buffer.exped e, MASTER.PREDPR_ROLE p_r, MASTER.MONTH, MASTER.KLS_UPAK u
		  WHERE k.ID=MASTER.KVIT.ID AND E.kod=K.EXPED AND p_r.KLS_ROLE_ID=2 
		    AND p_r.FOX_KOD=k.KOD_PERER AND k.NOM_ZD=MONTH.nom_zd(+) AND k.BAG_ID=u.BAG_ID(+))
  WHERE EXISTS (SELECT load_buffer.KVIT.ID FROM load_buffer.KVIT WHERE load_buffer.KVIT.ID=MASTER.KVIT.ID)
    AND master.kvit.date_otgr BETWEEN date_beg AND date_end
	and master.kvit.date_kvit>v_dat;

UPDATE MASTER.KVIT SET
  (BILL_ID,SUM_PROD, SUM_AKCIZ, SUM_PROD_NDS, TARIF_NDS, SUM_VOZN11, SUM_VOZN11_NDS, SUM_VOZN12, SUM_VOZN12_NDS, SUM_STRAH,
   DATE_CENA,CENA,CENA_OTP,TARIF_GUARD_NDS,NUM_AKT,PROTO_NUM,PROTO_DATE,NO_AKCIZ)
 = (SELECT k.n_plat,k.D_41, k.SUM_AKCIZ, k.D_191, k.D_194, k.SUM_NALIV, k.NDC_NAL20, k.D_442, k.NDC_TR20, k.SUM_NACEN,
    k.date_cen,k.cena,k.cena_otp,NVL(k.ndc_doptar,0),k.reestr,k.PROTO_NUM,k.PROTO_DATE,IIF(k.NO_AKCIZ,1,0)
          FROM load_buffer.KVIT k, load_buffer.exped e, MASTER.PREDPR_ROLE p_r, MASTER.MONTH, MASTER.KLS_UPAK u
		  WHERE k.ID=MASTER.KVIT.ID AND E.kod=K.EXPED AND p_r.KLS_ROLE_ID=2 
		    AND p_r.FOX_KOD=k.KOD_PERER AND k.NOM_ZD=MONTH.nom_zd(+) AND k.BAG_ID=u.BAG_ID(+))
  WHERE EXISTS (SELECT load_buffer.KVIT.ID FROM load_buffer.KVIT WHERE load_buffer.KVIT.ID=MASTER.KVIT.ID)
    AND master.kvit.date_otgr BETWEEN date_beg AND date_end
	AND master.kvit.date_kvit<TO_DATE('14.07.2006','dd.mm.yyyy')
	and master.kvit.date_kvit>v_dat;

INSERT INTO MASTER.KVIT
     (ID,FLG_OPERDATA,MESTO_ID,NOM_ZD,PROD_ID_NPR,TEX_PD_ID,NUM_CIST,DATE_OTGR,
      VES,VES_BRUTTO,VES_ED,KOL_ED,TARIF,TARIF19,TARIF_ORIG,NUM_KVIT,DATE_KVIT,
      NUM_MILITARY,FLG_DOP_CIST,FLG_VAG_KLIENT,VAGOWNER_ID,VAGONTYPE_ID,KALIBR_ID,
      VES_CIST,DATE_VOZ,KVIT_VOZ,SUM_VOZ,DATE_OTV,PLOMBA1,PLOMBA2,ROSINSPL1,ROSINSPL2,
      VZLIV,TEMPER,FAKT_PL,FORMNAKL_ID,SHABEXP_ID,GTD,EXPED_ID,VETKA_OTP_ID,
	  BILL_ID,NUM_EXP_MAR,DATE_OFORML,SVED_NUM,SVED_ID,PASP_ID,PERER_ID,
      DATE_EDIT,JKCOMMIT,GROTP_ID,PERECH_TEXPD_NUM, PERECH_TEXPD_DATE,
	  SUM_PROD, SUM_AKCIZ, SUM_PROD_NDS, TARIF_NDS, SUM_VOZN11, SUM_VOZN11_NDS, SUM_VOZN12, SUM_VOZN12_NDS, SUM_STRAH,
	  DATE_CENA,CENA,CENA_OTP,CENA_VOZN,TARIF_GUARD,TARIF_GUARD_NDS,TARIF_ALT,CAPACITY,NACENKA,SHIELDS,PODDONS,
	  UPAK_ID,UPAK_VES,UPAK_VES_ED,SHIELD_VES,PODDON_VES,KOL_NET,PL,NUM_AKT,PROTO_NUM,PROTO_DATE,NO_AKCIZ,PERECH_GUARD_NUM,PERECH_GUARD_DATE,
      AXES,CTLV,DEFI_MASS_ID,VOLUME,VOLUME15,PL15,/*ZPU_TYPE1,ZPU_TYPE2,*/NUM_NAR,NUM_DOVER,DATE_DOVER,FIO_DRIVER)
      (SELECT k.ID,0,k.mesto,k.nom_zd,k.kod_npr,k.plat_tarif,k.num_cist,k.date_otgr,
          k.ves,DECODE(MONTH.NAZN_OTG_ID,4,k.ves_brutto,k.ves),k.wes_ed,k.kol_ed,k.TARIF,k.TARIF19,k.TARIF_ORIG,k.num_kvit,k.date_kvit,
          LTRIM(RTRIM(k.transp)),Iif(k.DOP_CIST,1,0),Iif(k.VAG_KLIENT,1,0),NVL(k.tipv,0),NVL(k.rodv,0),NVL(k.tip,'0'),
          k.tara_all,k.date_voz,k.KVIT_VOZ,k.SUM_VOZ,k.date_otv,k.PLOMBA1,k.PLOMBA2,k.ROSINSPL1,k.ROSINSPL2,
          k.VZLIV,k.TEMPER,k.XPL,0,k.rexp,NVL(k.GTD,''),E.KOD_PREDPR,k.gd_track,
		  k.n_plat,k.n_mar,TO_DATE(TO_CHAR(np_data_o,'dd.mm.yyyy ') || SUBSTR(np_timep,1,5),'dd.mm.yyyy hh24:mi'),k.NP,k.sved_id,k.kodpasp,p_r.PREDPR_ID,
          TO_DATE(TO_CHAR(date_e,'dd.mm.yyyy ') || SUBSTR(time_e,1,5),'dd.mm.yyyy hh24:mi'),1,k.KOD_GROTP,k.NUM_PERECH,k.DAT_PERECH,
		  k.D_41, k.SUM_AKCIZ, k.D_191, k.D_194, k.SUM_NALIV, k.NDC_NAL20, k.D_442, k.NDC_TR20, k.SUM_NACEN,
  	      k.date_cen,k.cena,k.cena_otp,NVL(k.cena_vozn,0),NVL(k.dop_tarif,0),NVL(k.ndc_doptar,0),NVL(k.tarif_alt,0),
		  k.wes,k.NACENKA,k.shields,k.poddons,
		  u.ID,k.bag_ves,k.bag1_ves,k.shld_ves,k.podd_ves,k.kol_net,k.pl,k.reestr,k.PROTO_NUM,k.PROTO_DATE,IIF(k.NO_AKCIZ,1,0),
		  k.n_per_ohr,k.d_per_ohr,
          k.osc,k.ctlv,k.defi_mass,k.volume,k.volume15,k.pl15,/*k.ZPU_TYPE1,k.ZPU_TYPE2,*/k.NARIAD,k.DOVEREN,k.DATE_DOVER,k.FIO_DRIVER
        FROM load_buffer.KVIT k, load_buffer.exped e, MASTER.PREDPR_ROLE p_r, MASTER.MONTH, MASTER.KLS_UPAK u
        WHERE E.kod=K.EXPED AND p_r.KLS_ROLE_ID=2 AND p_r.FOX_KOD=k.KOD_PERER AND k.BAG_ID=u.BAG_ID(+)
		  AND k.nom_zd=MONTH.nom_zd(+) 
  	      AND NOT EXISTS (SELECT MASTER.KVIT.ID FROM MASTER.KVIT WHERE MASTER.KVIT.ID=k.ID));

UPDATE KVIT SET BILL_POS_ID=1 WHERE  BILL_POS_ID IS NULL AND date_otgr BETWEEN date_beg AND date_end;

--- Удаляем записи из KVIT (только в том случае, если в буфере есть записи)
begin
  select count(*) into cnt1 from load_buffer.kvit k;
exception
  when others then
    cnt1:=0;
end;  
if cnt1>0 then
  DELETE FROM MASTER.KVIT A WHERE A.FLG_OPERDATA=0 AND NVL(A.BILL_ID,0)=0 AND
    NOT EXISTS (SELECT k.ID FROM load_buffer.KVIT k WHERE k.ID = A.ID) AND
    A.date_otgr BETWEEN date_beg AND date_end
	and A.date_kvit>v_dat;
end if;

Renew_Reestr_kvit(DATE_BEG,DATE_END,param1,param2,param3);

-- проставляем признак внеплановых вагонов (с 01.01.2008)
update kvit A set FLG_DOP_CIST=0 
where A.date_otgr BETWEEN date_beg AND date_end
and A.date_otgr>=to_date('01.01.2008','dd.mm.yyyy')
and A.date_kvit>v_dat
and A.FLG_DOP_CIST=1;

update kvit A set FLG_DOP_CIST=0
where exists
(
select null from kvit, kvit_vneplan, month, gu12_a
where kvit.num_kvit=kvit_vneplan.NUM_KVIT
  and kvit.ID=A.id
  and kvit.nom_zd=month.nom_zd
  and month.gu12_a_id=gu12_a.id
  and kvit_vneplan.NOM_Z=gu12_a.NOM_Z
  and kvit_vneplan.IS_VNEPLAN=0
) 
and A.date_otgr BETWEEN date_beg AND date_end
and A.date_otgr>=to_date('01.01.2008','dd.mm.yyyy')
and A.date_kvit>v_dat;

update kvit A set FLG_DOP_CIST=1
where exists
(
select null from kvit, kvit_vneplan, month, gu12_a
where kvit.num_kvit=kvit_vneplan.NUM_KVIT
  and kvit.ID=A.id
  and kvit.nom_zd=month.nom_zd
  and month.gu12_a_id=gu12_a.id
  and kvit_vneplan.NOM_Z=gu12_a.NOM_Z
  and kvit_vneplan.IS_VNEPLAN=1
) 
and A.date_otgr BETWEEN date_beg AND date_end
and A.date_otgr>=to_date('01.01.2008','dd.mm.yyyy')
and A.date_kvit>v_dat;

COMMIT;

END Renew_Kvit; 
/

