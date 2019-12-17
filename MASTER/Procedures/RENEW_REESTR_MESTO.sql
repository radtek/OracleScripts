--
-- RENEW_REESTR_MESTO  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Reestr_Mesto (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
  vMesto NUMBER;
  vType NUMBER;
BEGIN

UPDATE load_buffer.REESTR SET np_timep='00:00' WHERE SUBSTR(np_timep,1,1)=' ' OR np_timep IS NULL;
UPDATE load_buffer.REESTR SET time_e='00:00' WHERE SUBSTR(time_e,1,1)=' ' OR time_e IS NULL;
UPDATE load_buffer.REESTR SET np_data_o=date_otgr WHERE np_data_o IS NULL;
UPDATE load_buffer.REESTR SET date_e=date_otgr WHERE date_e IS NULL;
UPDATE load_buffer.REESTR SET kod_perer=0 WHERE kod_perer IS NULL;


IF param1 || ' ' =' ' THEN --- место не указано
  RETURN;
ELSE
  vMesto:=TO_NUMBER(param1);
END IF;

IF param2 || ' ' =' ' THEN --- тип оперативки
  vType:=0;
ELSE
  vType:=TO_NUMBER(param2);
END IF;

--- Обновляем REESTR
UPDATE MASTER.KVIT SET
    (MESTO_ID,NOM_ZD,PROD_ID_NPR,TEX_PD_ID,NUM_CIST,DATE_OTGR,
     VES,VES_BRUTTO,VES_ED,KOL_ED,TARIF,TARIF19,TARIF_ORIG,NUM_KVIT,DATE_KVIT,
     NUM_MILITARY,FLG_DOP_CIST,FLG_VAG_KLIENT,VAGOWNER_ID,VAGONTYPE_ID,KALIBR_ID,
     VES_CIST,DATE_VOZ,KVIT_VOZ,SUM_VOZ,DATE_OTV,PLOMBA1,PLOMBA2,ROSINSPL1,ROSINSPL2,
     VZLIV,TEMPER,FAKT_PL,FORMNAKL_ID,SHABEXP_ID,GTD,EXPED_ID,VETKA_OTP_ID,
     BILL_ID,NUM_EXP_MAR,DATE_OFORML,SVED_NUM,SVED_ID,PASP_ID,PERER_ID,
	 DATE_EDIT,JKCOMMIT,GROTP_ID,DATE_CENA,CENA,CENA_OTP,CAPACITY,SHIELDS,PODDONS,
	 UPAK_ID,UPAK_VES,UPAK_VES_ED,SHIELD_VES,PODDON_VES,KOL_NET,PL,
     AXES,CTLV,DEFI_MASS_ID,VOLUME,VOLUME15,PL15,ZPU_TYPE1,ZPU_TYPE2,NUM_NAR,NUM_DOVER,DATE_DOVER,FIO_DRIVER)
   = (SELECT NVL(k.mesto,0),k.nom_zd,k.kod_npr,k.kod_tex_pd,k.num_cist,k.date_otgr,
     k.ves,DECODE(MONTH.NAZN_OTG_ID,4,k.ves_brutto,k.ves),k.wes_ed,k.kol_ed,k.TARIF,k.TARIF19,k.TARIF_ORIG,k.num_kvit,k.date_kvit,
     LTRIM(RTRIM(k.transp)),Iif(k.DOP_CIST,1,0),Iif(k.VAG_KLIENT,1,0),NVL(k.tipv,0),NVL(k.rodv,0),NVL(k.tip,'0'),
     k.tara_all,k.date_voz,k.KVIT_VOZ,k.SUM_VOZ,k.date_otv,k.PLOMBA1,k.PLOMBA2,k.ROSINSPL1,k.ROSINSPL2,
     k.VZLIV,k.TEMPER,k.XPL,NVL(k.forma,0),k.rexp,NVL(k.GTD,''),E.KOD_PREDPR,k.gd_track,
     k.n_plat,k.n_mar,TO_DATE(TO_CHAR(np_data_o,'dd.mm.yyyy ') || SUBSTR(np_timep,1,5),'dd.mm.yyyy hh24:mi'),k.NP,k.sved_id,k.KODPASP,p_r.PREDPR_ID,
     TO_DATE(TO_CHAR(date_e,'dd.mm.yyyy ') || SUBSTR(time_e,1,5),'dd.mm.yyyy hh24:mi'),Iif(k.JKCOMMIT,1,0),k.KOD_GROTP,
	 k.date_cen,k.cena,k.cena_otp,k.wes,k.shields,k.poddons,
	 u.ID,k.bag_ves,k.bag1_ves,k.shld_ves,k.podd_ves,k.kol_net,k.pl,
     k.osc,k.ctlv,k.defi_mass,k.volume,k.volume15,k.pl15,k.ZPU_TYPE1,k.ZPU_TYPE2,k.NARIAD,k.DOVEREN,k.DATE_DOVER,k.FIO_DRIVER
          FROM load_buffer.reestr k, load_buffer.exped e, MASTER.PREDPR_ROLE p_r, MASTER.MONTH, MASTER.KLS_UPAK u
		  WHERE k.KVIT_id=MASTER.KVIT.ID AND E.kod=K.EXPED AND k.mesto=vMesto AND p_r.KLS_ROLE_ID=2 
		    AND p_r.FOX_KOD=k.KOD_PERER AND k.NOM_ZD=MONTH.nom_zd(+) AND k.BAG_ID=u.BAG_ID(+))
 WHERE MASTER.KVIT.FLG_OPERDATA=1 AND MASTER.KVIT.MESTO_ID=vMesto AND
    EXISTS (SELECT C.ID FROM load_buffer.reestr C WHERE C.kvit_id=MASTER.KVIT.ID AND C.Mesto=vMesto);

--- Добавляем в REESTR
INSERT  INTO MASTER.KVIT
     (ID,FLG_OPERDATA,MESTO_ID,NOM_ZD,PROD_ID_NPR,TEX_PD_ID,NUM_CIST,DATE_OTGR,
      VES,VES_BRUTTO,VES_ED,KOL_ED,TARIF,TARIF19,TARIF_ORIG,NUM_KVIT,DATE_KVIT,
      NUM_MILITARY,FLG_DOP_CIST,FLG_VAG_KLIENT,VAGOWNER_ID,VAGONTYPE_ID,KALIBR_ID,
      VES_CIST,DATE_VOZ,KVIT_VOZ,SUM_VOZ,DATE_OTV,PLOMBA1,PLOMBA2,ROSINSPL1,ROSINSPL2,
      VZLIV,TEMPER,FAKT_PL,FORMNAKL_ID,SHABEXP_ID,GTD,EXPED_ID,VETKA_OTP_ID,
	  BILL_ID,NUM_EXP_MAR,DATE_OFORML,SVED_NUM,SVED_ID,PASP_ID,PERER_ID,
	  DATE_EDIT,JKCOMMIT,GROTP_ID,DATE_CENA,CENA,CENA_OTP,CAPACITY,SHIELDS,PODDONS,
	  UPAK_ID,UPAK_VES,UPAK_VES_ED,SHIELD_VES,PODDON_VES,KOL_NET,PL,
       AXES,CTLV,DEFI_MASS_ID,VOLUME,VOLUME15,PL15,ZPU_TYPE1,ZPU_TYPE2,NUM_NAR,NUM_DOVER,DATE_DOVER,FIO_DRIVER)
      (SELECT k.kvit_id,1,NVL(k.mesto,0),k.nom_zd,k.kod_npr,k.kod_tex_pd,k.num_cist,k.date_otgr,
          k.ves,DECODE(MONTH.NAZN_OTG_ID,4,k.ves_brutto,k.ves),k.wes_ed,k.kol_ed,k.TARIF,k.TARIF19,k.TARIF_ORIG,k.num_kvit,k.date_kvit,
          LTRIM(RTRIM(k.transp)),Iif(k.DOP_CIST,1,0),Iif(k.VAG_KLIENT,1,0),NVL(k.tipv,0),NVL(k.rodv,0),NVL(k.tip,'0'),
          k.tara_all,k.date_voz,k.KVIT_VOZ,k.SUM_VOZ,k.date_otv,k.PLOMBA1,k.PLOMBA2,k.ROSINSPL1,k.ROSINSPL2,
          k.VZLIV,k.TEMPER,k.XPL,NVL(k.forma,0),k.rexp,NVL(k.GTD,''),E.KOD_PREDPR,k.gd_track,
  		  k.n_plat,k.n_mar,TO_DATE(TO_CHAR(np_data_o,'dd.mm.yyyy ') || SUBSTR(np_timep,1,5),'dd.mm.yyyy hh24:mi'),k.NP,k.sved_id,k.KODPASP,p_r.PREDPR_ID,
          TO_DATE(TO_CHAR(date_e,'dd.mm.yyyy ') || SUBSTR(time_e,1,5),'dd.mm.yyyy hh24:mi'),Iif(k.JKCOMMIT,1,0),k.KOD_GROTP,
		  k.date_cen,k.cena,k.cena_otp,k.wes,k.shields,k.poddons,
		  u.ID,k.bag_ves,k.bag1_ves,k.shld_ves,k.podd_ves,k.kol_net,k.pl,
          k.osc,k.ctlv,k.defi_mass,k.volume,k.volume15,k.pl15,k.ZPU_TYPE1,k.ZPU_TYPE2,k.NARIAD,k.DOVEREN,k.DATE_DOVER,k.FIO_DRIVER
        FROM load_buffer.reestr k, load_buffer.exped e, MASTER.PREDPR_ROLE p_r, MASTER.MONTH, MASTER.KLS_UPAK u
        WHERE E.kod=K.EXPED AND k.Mesto=vMesto AND p_r.KLS_ROLE_ID=2 
		  AND p_r.FOX_KOD=k.KOD_PERER AND k.nom_zd=MONTH.nom_zd(+) AND k.BAG_ID=u.BAG_ID(+)
  	      AND NOT EXISTS (SELECT A.ID FROM MASTER.KVIT A WHERE A.ID=k.kvit_id AND A.MESTO_ID=vMesto));
--COMMIT;

--- Удаляем записи из REESTR
IF vType=0 THEN  --- Если полная оперативка
  DELETE FROM MASTER.KVIT A WHERE A.FLG_OPERDATA=1 AND A.MESTO_ID=vMesto AND
    (NOT EXISTS (SELECT r.ID FROM load_buffer.reestr r WHERE r.kvit_id = A.ID) OR
     EXISTS (SELECT k.ID FROM MASTER.KVIT k WHERE k.FLG_OPERDATA=0 AND k.MESTO_ID=A.MESTO_ID AND k.ID=A.ID) OR
     EXISTS (SELECT k.ID FROM MASTER.KVIT k WHERE k.FLG_OPERDATA=0 AND k.MESTO_ID=A.MESTO_ID AND k.num_cist=A.num_cist AND k.date_otgr=A.date_otgr AND k.SVED_NUM=A.SVED_NUM AND k.NOM_ZD=A.NOM_ZD));
ELSE  --- Если краткая оперативка
  DELETE FROM MASTER.KVIT A WHERE A.FLG_OPERDATA=1 AND A.MESTO_ID=vMesto AND
    (EXISTS (SELECT r.ID FROM load_buffer.reestr r WHERE r.date_remov IS NOT NULL AND r.kvit_id=A.ID) OR
     EXISTS (SELECT k.ID FROM MASTER.KVIT k WHERE k.FLG_OPERDATA=0 AND k.MESTO_ID=A.MESTO_ID AND k.ID=A.ID) OR
     EXISTS (SELECT k.ID FROM MASTER.KVIT k WHERE k.FLG_OPERDATA=0 AND k.MESTO_ID=A.MESTO_ID AND k.num_cist=A.num_cist AND k.date_otgr=A.date_otgr AND k.SVED_NUM=A.SVED_NUM AND k.NOM_ZD=A.NOM_ZD));
END IF;
COMMIT;

--UPDATE KVIT SET ves_brutto=ves 
--WHERE EXISTS (SELECT NULL FROM MONTH WHERE MONTH.nom_zd=KVIT.nom_zd AND MONTH.NAZN_OTG_ID<>4);
--COMMIT;

END Renew_Reestr_Mesto;
/

