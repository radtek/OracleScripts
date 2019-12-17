--
-- T99_LOG_KVIT  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.T99_LOG_KVIT
/* ---------------------------------------------
  Генератор скриптов для MASTER
  PSV v1.04
--------------------------------------------- */
 AFTER DELETE OR INSERT OR UPDATE ON MASTER.KVIT  FOR EACH ROW
DECLARE
  v_old KVIT%ROWTYPE;
  v_new KVIT%ROWTYPE;
  v_tmp NUMBER;
  LogId NUMBER;
  cl_WhatWasDone CLOB;
  WriteStr VARCHAR2(250);
  WritePos NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.FLG_OPERDATA := :OLD.FLG_OPERDATA;
    v_old.MESTO_ID := :OLD.MESTO_ID;
    v_old.NOM_ZD := :OLD.NOM_ZD;
    v_old.PROD_ID_NPR := :OLD.PROD_ID_NPR;
    v_old.TEX_PD_ID := :OLD.TEX_PD_ID;
    v_old.NUM_CIST := :OLD.NUM_CIST;
    v_old.DATE_OTGR := :OLD.DATE_OTGR;
    v_old.VES := :OLD.VES;
    v_old.VES_BRUTTO := :OLD.VES_BRUTTO;
    v_old.VES_ED := :OLD.VES_ED;
    v_old.KOL_ED := :OLD.KOL_ED;
    v_old.TARIF := :OLD.TARIF;
    v_old.TARIF19 := :OLD.TARIF19;
    v_old.TARIF_ORIG := :OLD.TARIF_ORIG;
    v_old.NUM_KVIT := :OLD.NUM_KVIT;
    v_old.DATE_KVIT := :OLD.DATE_KVIT;
    v_old.NUM_MILITARY := :OLD.NUM_MILITARY;
    v_old.FLG_DOP_CIST := :OLD.FLG_DOP_CIST;
    v_old.FLG_VAG_KLIENT := :OLD.FLG_VAG_KLIENT;
    v_old.VAGOWNER_ID := :OLD.VAGOWNER_ID;
    v_old.VAGONTYPE_ID := :OLD.VAGONTYPE_ID;
    v_old.KALIBR_ID := :OLD.KALIBR_ID;
    v_old.VES_CIST := :OLD.VES_CIST;
    v_old.DATE_VOZ := :OLD.DATE_VOZ;
    v_old.KVIT_VOZ := :OLD.KVIT_VOZ;
    v_old.SUM_VOZ := :OLD.SUM_VOZ;
    v_old.DATE_OTV := :OLD.DATE_OTV;
    v_old.PLOMBA1 := :OLD.PLOMBA1;
    v_old.PLOMBA2 := :OLD.PLOMBA2;
    v_old.ROSINSPL1 := :OLD.ROSINSPL1;
    v_old.ROSINSPL2 := :OLD.ROSINSPL2;
    v_old.VZLIV := :OLD.VZLIV;
    v_old.TEMPER := :OLD.TEMPER;
    v_old.FAKT_PL := :OLD.FAKT_PL;
    v_old.FORMNAKL_ID := :OLD.FORMNAKL_ID;
    v_old.SHABEXP_ID := :OLD.SHABEXP_ID;
    v_old.GTD := :OLD.GTD;
    v_old.EXPED_ID := :OLD.EXPED_ID;
    v_old.VETKA_OTP_ID := :OLD.VETKA_OTP_ID;
    v_old.NUM_EXP_MAR := :OLD.NUM_EXP_MAR;
    v_old.BILL_ID := :OLD.BILL_ID;
    v_old.SVED_ID := :OLD.SVED_ID;
    v_old.DATE_OFORML := :OLD.DATE_OFORML;
    v_old.SVED_NUM := :OLD.SVED_NUM;
    v_old.PASP_ID := :OLD.PASP_ID;
    v_old.NUM_NAR := :OLD.NUM_NAR;
    v_old.NUM_DOVER := :OLD.NUM_DOVER;
    v_old.PERER_ID := :OLD.PERER_ID;
    v_old.DATE_EDIT := :OLD.DATE_EDIT;
    v_old.JKCOMMIT := :OLD.JKCOMMIT;
    v_old.GROTP_ID := :OLD.GROTP_ID;
    v_old.PERECH_TEXPD_DATE := :OLD.PERECH_TEXPD_DATE;
    v_old.PERECH_TEXPD_NUM := :OLD.PERECH_TEXPD_NUM;
    v_old.SUM_PROD := :OLD.SUM_PROD;
    v_old.SUM_AKCIZ := :OLD.SUM_AKCIZ;
    v_old.SUM_PROD_NDS := :OLD.SUM_PROD_NDS;
    v_old.TARIF_NDS := :OLD.TARIF_NDS;
    v_old.SUM_VOZN11 := :OLD.SUM_VOZN11;
    v_old.SUM_VOZN11_NDS := :OLD.SUM_VOZN11_NDS;
    v_old.SUM_VOZN12 := :OLD.SUM_VOZN12;
    v_old.SUM_VOZN12_NDS := :OLD.SUM_VOZN12_NDS;
    v_old.SUM_STRAH := :OLD.SUM_STRAH;
    v_old.CENA := :OLD.CENA;
    v_old.CENA_OTP := :OLD.CENA_OTP;
    v_old.DATE_CENA := :OLD.DATE_CENA;
    v_old.CENA_VOZN := :OLD.CENA_VOZN;
    v_old.CAPACITY := :OLD.CAPACITY;
    v_old.TARIF_GUARD := :OLD.TARIF_GUARD;
    v_old.TARIF_GUARD_NDS := :OLD.TARIF_GUARD_NDS;
    v_old.TARIF_ALT := :OLD.TARIF_ALT;
    v_old.NACENKA := :OLD.NACENKA;
    v_old.PODDONS := :OLD.PODDONS;
    v_old.SHIELDS := :OLD.SHIELDS;
    v_old.UPAK_ID := :OLD.UPAK_ID;
    v_old.UPAK_VES := :OLD.UPAK_VES;
    v_old.KOL_NET := :OLD.KOL_NET;
    v_old.UPAK_VES_ED := :OLD.UPAK_VES_ED;
    v_old.SHIELD_VES := :OLD.SHIELD_VES;
    v_old.PODDON_VES := :OLD.PODDON_VES;
    v_old.PL := :OLD.PL;
    v_old.NUM_AKT := :OLD.NUM_AKT;
    v_old.BILL_POS_ID := :OLD.BILL_POS_ID;
    v_old.PROTO_NUM := :OLD.PROTO_NUM;
    v_old.PROTO_DATE := :OLD.PROTO_DATE;
    v_old.NO_AKCIZ := :OLD.NO_AKCIZ;
    v_old.PERECH_GUARD_DATE := :OLD.PERECH_GUARD_DATE;
    v_old.PERECH_GUARD_NUM := :OLD.PERECH_GUARD_NUM;
    v_old.TTN_ID := :OLD.TTN_ID;
    v_old.DATE_DOVER := :OLD.DATE_DOVER;
    v_old.FIO_DRIVER := :OLD.FIO_DRIVER;
    v_old.IS_LOADED := :OLD.IS_LOADED;
    v_old.AXES := :OLD.AXES;
    v_old.CTLV := :OLD.CTLV;
    v_old.DEFI_MASS_ID := :OLD.DEFI_MASS_ID;
    v_old.VOLUME := :OLD.VOLUME;
    v_old.VOLUME15 := :OLD.VOLUME15;
    v_old.ZPU_TYPE1 := :OLD.ZPU_TYPE1;
    v_old.ZPU_TYPE2 := :OLD.ZPU_TYPE2;
    v_old.PL15 := :OLD.PL15;
    v_old.DATE_IN := :OLD.DATE_IN;
  END IF;

  -- После удаления
  IF DELETING() THEN
    NULL;
    -- Запись в лог
    IF 1=1 THEN
      SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
      INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
        SELECT LogId,'KVIT',TO_CHAR(V_OLD.ID) || TO_CHAR(V_OLD.FLG_OPERDATA),osuser,terminal,MODULE,'D',EMPTY_CLOB()
          FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

      SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

      WritePos:=1;

            WriteStr:=':OLD.ID=' || TO_CHAR(V_OLD.ID) || ' :NEW.ID=' || TO_CHAR(V_NEW.ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.FLG_OPERDATA=' || TO_CHAR(V_OLD.FLG_OPERDATA) || ' :NEW.FLG_OPERDATA=' || TO_CHAR(V_NEW.FLG_OPERDATA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.MESTO_ID=' || TO_CHAR(V_OLD.MESTO_ID) || ' :NEW.MESTO_ID=' || TO_CHAR(V_NEW.MESTO_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.NUM_CIST=' || (V_OLD.NUM_CIST) || ' :NEW.NUM_CIST=' || (V_NEW.NUM_CIST) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_OTGR=' || TO_CHAR(V_OLD.DATE_OTGR,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OTGR=' || TO_CHAR(V_NEW.DATE_OTGR,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.VES_BRUTTO=' || TO_CHAR(V_OLD.VES_BRUTTO) || ' :NEW.VES_BRUTTO=' || TO_CHAR(V_NEW.VES_BRUTTO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.NUM_KVIT=' || TO_CHAR(V_OLD.NUM_KVIT) || ' :NEW.NUM_KVIT=' || TO_CHAR(V_NEW.NUM_KVIT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_KVIT=' || TO_CHAR(V_OLD.DATE_KVIT,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_KVIT=' || TO_CHAR(V_NEW.DATE_KVIT,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.BILL_ID=' || TO_CHAR(V_OLD.BILL_ID) || ' :NEW.BILL_ID=' || TO_CHAR(V_NEW.BILL_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.SVED_ID=' || (V_OLD.SVED_ID) || ' :NEW.SVED_ID=' || (V_NEW.SVED_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_OFORML=' || TO_CHAR(V_OLD.DATE_OFORML,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OFORML=' || TO_CHAR(V_NEW.DATE_OFORML,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.SVED_NUM=' || TO_CHAR(V_OLD.SVED_NUM) || ' :NEW.SVED_NUM=' || TO_CHAR(V_NEW.SVED_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.PASP_ID=' || (V_OLD.PASP_ID) || ' :NEW.PASP_ID=' || (V_NEW.PASP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.SUM_PROD=' || TO_CHAR(V_OLD.SUM_PROD) || ' :NEW.SUM_PROD=' || TO_CHAR(V_NEW.SUM_PROD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.BILL_POS_ID=' || TO_CHAR(V_OLD.BILL_POS_ID) || ' :NEW.BILL_POS_ID=' || TO_CHAR(V_NEW.BILL_POS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.TTN_ID=' || TO_CHAR(V_OLD.TTN_ID) || ' :NEW.TTN_ID=' || TO_CHAR(V_NEW.TTN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.IS_LOADED=' || TO_CHAR(V_OLD.IS_LOADED) || ' :NEW.IS_LOADED=' || TO_CHAR(V_NEW.IS_LOADED) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_IN=' || TO_CHAR(V_OLD.DATE_IN,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_IN=' || TO_CHAR(V_NEW.DATE_IN,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          
    END IF;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.FLG_OPERDATA := :NEW.FLG_OPERDATA;
    v_new.MESTO_ID := :NEW.MESTO_ID;
    v_new.NOM_ZD := :NEW.NOM_ZD;
    v_new.PROD_ID_NPR := :NEW.PROD_ID_NPR;
    v_new.TEX_PD_ID := :NEW.TEX_PD_ID;
    v_new.NUM_CIST := :NEW.NUM_CIST;
    v_new.DATE_OTGR := :NEW.DATE_OTGR;
    v_new.VES := :NEW.VES;
    v_new.VES_BRUTTO := :NEW.VES_BRUTTO;
    v_new.VES_ED := :NEW.VES_ED;
    v_new.KOL_ED := :NEW.KOL_ED;
    v_new.TARIF := :NEW.TARIF;
    v_new.TARIF19 := :NEW.TARIF19;
    v_new.TARIF_ORIG := :NEW.TARIF_ORIG;
    v_new.NUM_KVIT := :NEW.NUM_KVIT;
    v_new.DATE_KVIT := :NEW.DATE_KVIT;
    v_new.NUM_MILITARY := :NEW.NUM_MILITARY;
    v_new.FLG_DOP_CIST := :NEW.FLG_DOP_CIST;
    v_new.FLG_VAG_KLIENT := :NEW.FLG_VAG_KLIENT;
    v_new.VAGOWNER_ID := :NEW.VAGOWNER_ID;
    v_new.VAGONTYPE_ID := :NEW.VAGONTYPE_ID;
    v_new.KALIBR_ID := :NEW.KALIBR_ID;
    v_new.VES_CIST := :NEW.VES_CIST;
    v_new.DATE_VOZ := :NEW.DATE_VOZ;
    v_new.KVIT_VOZ := :NEW.KVIT_VOZ;
    v_new.SUM_VOZ := :NEW.SUM_VOZ;
    v_new.DATE_OTV := :NEW.DATE_OTV;
    v_new.PLOMBA1 := :NEW.PLOMBA1;
    v_new.PLOMBA2 := :NEW.PLOMBA2;
    v_new.ROSINSPL1 := :NEW.ROSINSPL1;
    v_new.ROSINSPL2 := :NEW.ROSINSPL2;
    v_new.VZLIV := :NEW.VZLIV;
    v_new.TEMPER := :NEW.TEMPER;
    v_new.FAKT_PL := :NEW.FAKT_PL;
    v_new.FORMNAKL_ID := :NEW.FORMNAKL_ID;
    v_new.SHABEXP_ID := :NEW.SHABEXP_ID;
    v_new.GTD := :NEW.GTD;
    v_new.EXPED_ID := :NEW.EXPED_ID;
    v_new.VETKA_OTP_ID := :NEW.VETKA_OTP_ID;
    v_new.NUM_EXP_MAR := :NEW.NUM_EXP_MAR;
    v_new.BILL_ID := :NEW.BILL_ID;
    v_new.SVED_ID := :NEW.SVED_ID;
    v_new.DATE_OFORML := :NEW.DATE_OFORML;
    v_new.SVED_NUM := :NEW.SVED_NUM;
    v_new.PASP_ID := :NEW.PASP_ID;
    v_new.NUM_NAR := :NEW.NUM_NAR;
    v_new.NUM_DOVER := :NEW.NUM_DOVER;
    v_new.PERER_ID := :NEW.PERER_ID;
    v_new.DATE_EDIT := :NEW.DATE_EDIT;
    v_new.JKCOMMIT := :NEW.JKCOMMIT;
    v_new.GROTP_ID := :NEW.GROTP_ID;
    v_new.PERECH_TEXPD_DATE := :NEW.PERECH_TEXPD_DATE;
    v_new.PERECH_TEXPD_NUM := :NEW.PERECH_TEXPD_NUM;
    v_new.SUM_PROD := :NEW.SUM_PROD;
    v_new.SUM_AKCIZ := :NEW.SUM_AKCIZ;
    v_new.SUM_PROD_NDS := :NEW.SUM_PROD_NDS;
    v_new.TARIF_NDS := :NEW.TARIF_NDS;
    v_new.SUM_VOZN11 := :NEW.SUM_VOZN11;
    v_new.SUM_VOZN11_NDS := :NEW.SUM_VOZN11_NDS;
    v_new.SUM_VOZN12 := :NEW.SUM_VOZN12;
    v_new.SUM_VOZN12_NDS := :NEW.SUM_VOZN12_NDS;
    v_new.SUM_STRAH := :NEW.SUM_STRAH;
    v_new.CENA := :NEW.CENA;
    v_new.CENA_OTP := :NEW.CENA_OTP;
    v_new.DATE_CENA := :NEW.DATE_CENA;
    v_new.CENA_VOZN := :NEW.CENA_VOZN;
    v_new.CAPACITY := :NEW.CAPACITY;
    v_new.TARIF_GUARD := :NEW.TARIF_GUARD;
    v_new.TARIF_GUARD_NDS := :NEW.TARIF_GUARD_NDS;
    v_new.TARIF_ALT := :NEW.TARIF_ALT;
    v_new.NACENKA := :NEW.NACENKA;
    v_new.PODDONS := :NEW.PODDONS;
    v_new.SHIELDS := :NEW.SHIELDS;
    v_new.UPAK_ID := :NEW.UPAK_ID;
    v_new.UPAK_VES := :NEW.UPAK_VES;
    v_new.KOL_NET := :NEW.KOL_NET;
    v_new.UPAK_VES_ED := :NEW.UPAK_VES_ED;
    v_new.SHIELD_VES := :NEW.SHIELD_VES;
    v_new.PODDON_VES := :NEW.PODDON_VES;
    v_new.PL := :NEW.PL;
    v_new.NUM_AKT := :NEW.NUM_AKT;
    v_new.BILL_POS_ID := :NEW.BILL_POS_ID;
    v_new.PROTO_NUM := :NEW.PROTO_NUM;
    v_new.PROTO_DATE := :NEW.PROTO_DATE;
    v_new.NO_AKCIZ := :NEW.NO_AKCIZ;
    v_new.PERECH_GUARD_DATE := :NEW.PERECH_GUARD_DATE;
    v_new.PERECH_GUARD_NUM := :NEW.PERECH_GUARD_NUM;
    v_new.TTN_ID := :NEW.TTN_ID;
    v_new.DATE_DOVER := :NEW.DATE_DOVER;
    v_new.FIO_DRIVER := :NEW.FIO_DRIVER;
    v_new.IS_LOADED := :NEW.IS_LOADED;
    v_new.AXES := :NEW.AXES;
    v_new.CTLV := :NEW.CTLV;
    v_new.DEFI_MASS_ID := :NEW.DEFI_MASS_ID;
    v_new.VOLUME := :NEW.VOLUME;
    v_new.VOLUME15 := :NEW.VOLUME15;
    v_new.ZPU_TYPE1 := :NEW.ZPU_TYPE1;
    v_new.ZPU_TYPE2 := :NEW.ZPU_TYPE2;
    v_new.PL15 := :NEW.PL15;
    v_new.DATE_IN := :NEW.DATE_IN;

    -- После обновления
    IF UPDATING() THEN
      NULL;
      -- Запись в лог
      IF V_OLD.ID<>V_NEW.ID OR V_OLD.FLG_OPERDATA<>V_NEW.FLG_OPERDATA THEN
        -- Изменился PRIMARY KEY, добавляем в лог 2 записи
        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'KVIT',TO_CHAR(V_OLD.ID) || TO_CHAR(V_OLD.FLG_OPERDATA),osuser,terminal,MODULE,'D'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;

        -- Запись в лог
        IF 1=1 THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE)
            SELECT LogId,'KVIT',TO_CHAR(V_NEW.ID) || TO_CHAR(V_NEW.FLG_OPERDATA),osuser,terminal,MODULE,'I'
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');
        END IF;
      ELSE
        -- PRIMARY KEY не изменился, добавляем в лог 1 запись
        -- Запись в лог
        IF nvl(V_OLD.BILL_ID,0)<>nvl(V_NEW.BILL_ID,0) THEN
          SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
          INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
            SELECT LogId,'KVIT',TO_CHAR(V_NEW.ID) || TO_CHAR(V_NEW.FLG_OPERDATA),osuser,terminal,MODULE,'U',EMPTY_CLOB()
              FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

          SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

          WritePos:=1;

          IF V_OLD.ID<>V_NEW.ID THEN
            WriteStr:=':OLD.ID=' || TO_CHAR(V_OLD.ID) || ' :NEW.ID=' || TO_CHAR(V_NEW.ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FLG_OPERDATA<>V_NEW.FLG_OPERDATA THEN
            WriteStr:=':OLD.FLG_OPERDATA=' || TO_CHAR(V_OLD.FLG_OPERDATA) || ' :NEW.FLG_OPERDATA=' || TO_CHAR(V_NEW.FLG_OPERDATA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          /*IF V_OLD.MESTO_ID<>V_NEW.MESTO_ID THEN
            WriteStr:=':OLD.MESTO_ID=' || TO_CHAR(V_OLD.MESTO_ID) || ' :NEW.MESTO_ID=' || TO_CHAR(V_NEW.MESTO_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NOM_ZD||' '<>V_NEW.NOM_ZD||' ' THEN
            WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROD_ID_NPR||' '<>V_NEW.PROD_ID_NPR||' ' THEN
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TEX_PD_ID<>V_NEW.TEX_PD_ID THEN
            WriteStr:=':OLD.TEX_PD_ID=' || TO_CHAR(V_OLD.TEX_PD_ID) || ' :NEW.TEX_PD_ID=' || TO_CHAR(V_NEW.TEX_PD_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_CIST||' '<>V_NEW.NUM_CIST||' ' THEN
            WriteStr:=':OLD.NUM_CIST=' || (V_OLD.NUM_CIST) || ' :NEW.NUM_CIST=' || (V_NEW.NUM_CIST) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_OTGR<>V_NEW.DATE_OTGR THEN
            WriteStr:=':OLD.DATE_OTGR=' || TO_CHAR(V_OLD.DATE_OTGR,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OTGR=' || TO_CHAR(V_NEW.DATE_OTGR,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VES<>V_NEW.VES THEN
            WriteStr:=':OLD.VES=' || TO_CHAR(V_OLD.VES) || ' :NEW.VES=' || TO_CHAR(V_NEW.VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VES_BRUTTO<>V_NEW.VES_BRUTTO THEN
            WriteStr:=':OLD.VES_BRUTTO=' || TO_CHAR(V_OLD.VES_BRUTTO) || ' :NEW.VES_BRUTTO=' || TO_CHAR(V_NEW.VES_BRUTTO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VES_ED<>V_NEW.VES_ED THEN
            WriteStr:=':OLD.VES_ED=' || TO_CHAR(V_OLD.VES_ED) || ' :NEW.VES_ED=' || TO_CHAR(V_NEW.VES_ED) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.KOL_ED<>V_NEW.KOL_ED THEN
            WriteStr:=':OLD.KOL_ED=' || TO_CHAR(V_OLD.KOL_ED) || ' :NEW.KOL_ED=' || TO_CHAR(V_NEW.KOL_ED) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF<>V_NEW.TARIF THEN
            WriteStr:=':OLD.TARIF=' || TO_CHAR(V_OLD.TARIF) || ' :NEW.TARIF=' || TO_CHAR(V_NEW.TARIF) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF19<>V_NEW.TARIF19 THEN
            WriteStr:=':OLD.TARIF19=' || TO_CHAR(V_OLD.TARIF19) || ' :NEW.TARIF19=' || TO_CHAR(V_NEW.TARIF19) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF_ORIG<>V_NEW.TARIF_ORIG THEN
            WriteStr:=':OLD.TARIF_ORIG=' || TO_CHAR(V_OLD.TARIF_ORIG) || ' :NEW.TARIF_ORIG=' || TO_CHAR(V_NEW.TARIF_ORIG) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_KVIT<>V_NEW.NUM_KVIT THEN
            WriteStr:=':OLD.NUM_KVIT=' || TO_CHAR(V_OLD.NUM_KVIT) || ' :NEW.NUM_KVIT=' || TO_CHAR(V_NEW.NUM_KVIT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_KVIT<>V_NEW.DATE_KVIT THEN
            WriteStr:=':OLD.DATE_KVIT=' || TO_CHAR(V_OLD.DATE_KVIT,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_KVIT=' || TO_CHAR(V_NEW.DATE_KVIT,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_MILITARY||' '<>V_NEW.NUM_MILITARY||' ' THEN
            WriteStr:=':OLD.NUM_MILITARY=' || (V_OLD.NUM_MILITARY) || ' :NEW.NUM_MILITARY=' || (V_NEW.NUM_MILITARY) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FLG_DOP_CIST<>V_NEW.FLG_DOP_CIST THEN
            WriteStr:=':OLD.FLG_DOP_CIST=' || TO_CHAR(V_OLD.FLG_DOP_CIST) || ' :NEW.FLG_DOP_CIST=' || TO_CHAR(V_NEW.FLG_DOP_CIST) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FLG_VAG_KLIENT<>V_NEW.FLG_VAG_KLIENT THEN
            WriteStr:=':OLD.FLG_VAG_KLIENT=' || TO_CHAR(V_OLD.FLG_VAG_KLIENT) || ' :NEW.FLG_VAG_KLIENT=' || TO_CHAR(V_NEW.FLG_VAG_KLIENT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VAGOWNER_ID<>V_NEW.VAGOWNER_ID THEN
            WriteStr:=':OLD.VAGOWNER_ID=' || TO_CHAR(V_OLD.VAGOWNER_ID) || ' :NEW.VAGOWNER_ID=' || TO_CHAR(V_NEW.VAGOWNER_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VAGONTYPE_ID<>V_NEW.VAGONTYPE_ID THEN
            WriteStr:=':OLD.VAGONTYPE_ID=' || TO_CHAR(V_OLD.VAGONTYPE_ID) || ' :NEW.VAGONTYPE_ID=' || TO_CHAR(V_NEW.VAGONTYPE_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.KALIBR_ID||' '<>V_NEW.KALIBR_ID||' ' THEN
            WriteStr:=':OLD.KALIBR_ID=' || (V_OLD.KALIBR_ID) || ' :NEW.KALIBR_ID=' || (V_NEW.KALIBR_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VES_CIST<>V_NEW.VES_CIST THEN
            WriteStr:=':OLD.VES_CIST=' || TO_CHAR(V_OLD.VES_CIST) || ' :NEW.VES_CIST=' || TO_CHAR(V_NEW.VES_CIST) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_VOZ<>V_NEW.DATE_VOZ THEN
            WriteStr:=':OLD.DATE_VOZ=' || TO_CHAR(V_OLD.DATE_VOZ,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_VOZ=' || TO_CHAR(V_NEW.DATE_VOZ,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.KVIT_VOZ||' '<>V_NEW.KVIT_VOZ||' ' THEN
            WriteStr:=':OLD.KVIT_VOZ=' || (V_OLD.KVIT_VOZ) || ' :NEW.KVIT_VOZ=' || (V_NEW.KVIT_VOZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_VOZ<>V_NEW.SUM_VOZ THEN
            WriteStr:=':OLD.SUM_VOZ=' || TO_CHAR(V_OLD.SUM_VOZ) || ' :NEW.SUM_VOZ=' || TO_CHAR(V_NEW.SUM_VOZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_OTV<>V_NEW.DATE_OTV THEN
            WriteStr:=':OLD.DATE_OTV=' || TO_CHAR(V_OLD.DATE_OTV,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OTV=' || TO_CHAR(V_NEW.DATE_OTV,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLOMBA1||' '<>V_NEW.PLOMBA1||' ' THEN
            WriteStr:=':OLD.PLOMBA1=' || (V_OLD.PLOMBA1) || ' :NEW.PLOMBA1=' || (V_NEW.PLOMBA1) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PLOMBA2||' '<>V_NEW.PLOMBA2||' ' THEN
            WriteStr:=':OLD.PLOMBA2=' || (V_OLD.PLOMBA2) || ' :NEW.PLOMBA2=' || (V_NEW.PLOMBA2) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ROSINSPL1||' '<>V_NEW.ROSINSPL1||' ' THEN
            WriteStr:=':OLD.ROSINSPL1=' || (V_OLD.ROSINSPL1) || ' :NEW.ROSINSPL1=' || (V_NEW.ROSINSPL1) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ROSINSPL2||' '<>V_NEW.ROSINSPL2||' ' THEN
            WriteStr:=':OLD.ROSINSPL2=' || (V_OLD.ROSINSPL2) || ' :NEW.ROSINSPL2=' || (V_NEW.ROSINSPL2) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VZLIV<>V_NEW.VZLIV THEN
            WriteStr:=':OLD.VZLIV=' || TO_CHAR(V_OLD.VZLIV) || ' :NEW.VZLIV=' || TO_CHAR(V_NEW.VZLIV) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TEMPER<>V_NEW.TEMPER THEN
            WriteStr:=':OLD.TEMPER=' || TO_CHAR(V_OLD.TEMPER) || ' :NEW.TEMPER=' || TO_CHAR(V_NEW.TEMPER) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FAKT_PL<>V_NEW.FAKT_PL THEN
            WriteStr:=':OLD.FAKT_PL=' || TO_CHAR(V_OLD.FAKT_PL) || ' :NEW.FAKT_PL=' || TO_CHAR(V_NEW.FAKT_PL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FORMNAKL_ID<>V_NEW.FORMNAKL_ID THEN
            WriteStr:=':OLD.FORMNAKL_ID=' || TO_CHAR(V_OLD.FORMNAKL_ID) || ' :NEW.FORMNAKL_ID=' || TO_CHAR(V_NEW.FORMNAKL_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SHABEXP_ID<>V_NEW.SHABEXP_ID THEN
            WriteStr:=':OLD.SHABEXP_ID=' || TO_CHAR(V_OLD.SHABEXP_ID) || ' :NEW.SHABEXP_ID=' || TO_CHAR(V_NEW.SHABEXP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GTD||' '<>V_NEW.GTD||' ' THEN
            WriteStr:=':OLD.GTD=' || (V_OLD.GTD) || ' :NEW.GTD=' || (V_NEW.GTD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.EXPED_ID<>V_NEW.EXPED_ID THEN
            WriteStr:=':OLD.EXPED_ID=' || TO_CHAR(V_OLD.EXPED_ID) || ' :NEW.EXPED_ID=' || TO_CHAR(V_NEW.EXPED_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VETKA_OTP_ID<>V_NEW.VETKA_OTP_ID THEN
            WriteStr:=':OLD.VETKA_OTP_ID=' || TO_CHAR(V_OLD.VETKA_OTP_ID) || ' :NEW.VETKA_OTP_ID=' || TO_CHAR(V_NEW.VETKA_OTP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_EXP_MAR||' '<>V_NEW.NUM_EXP_MAR||' ' THEN
            WriteStr:=':OLD.NUM_EXP_MAR=' || (V_OLD.NUM_EXP_MAR) || ' :NEW.NUM_EXP_MAR=' || (V_NEW.NUM_EXP_MAR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;*/
          IF nvl(V_OLD.BILL_ID,0)<>nvl(V_NEW.BILL_ID,0) THEN
            WriteStr:=':OLD.BILL_ID=' || TO_CHAR(V_OLD.BILL_ID) || ' :NEW.BILL_ID=' || TO_CHAR(V_NEW.BILL_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          /*IF V_OLD.SVED_ID||' '<>V_NEW.SVED_ID||' ' THEN
            WriteStr:=':OLD.SVED_ID=' || (V_OLD.SVED_ID) || ' :NEW.SVED_ID=' || (V_NEW.SVED_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_OFORML<>V_NEW.DATE_OFORML THEN
            WriteStr:=':OLD.DATE_OFORML=' || TO_CHAR(V_OLD.DATE_OFORML,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OFORML=' || TO_CHAR(V_NEW.DATE_OFORML,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SVED_NUM<>V_NEW.SVED_NUM THEN
            WriteStr:=':OLD.SVED_NUM=' || TO_CHAR(V_OLD.SVED_NUM) || ' :NEW.SVED_NUM=' || TO_CHAR(V_NEW.SVED_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PASP_ID||' '<>V_NEW.PASP_ID||' ' THEN
            WriteStr:=':OLD.PASP_ID=' || (V_OLD.PASP_ID) || ' :NEW.PASP_ID=' || (V_NEW.PASP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_NAR||' '<>V_NEW.NUM_NAR||' ' THEN
            WriteStr:=':OLD.NUM_NAR=' || (V_OLD.NUM_NAR) || ' :NEW.NUM_NAR=' || (V_NEW.NUM_NAR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_DOVER||' '<>V_NEW.NUM_DOVER||' ' THEN
            WriteStr:=':OLD.NUM_DOVER=' || (V_OLD.NUM_DOVER) || ' :NEW.NUM_DOVER=' || (V_NEW.NUM_DOVER) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PERER_ID<>V_NEW.PERER_ID THEN
            WriteStr:=':OLD.PERER_ID=' || TO_CHAR(V_OLD.PERER_ID) || ' :NEW.PERER_ID=' || TO_CHAR(V_NEW.PERER_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_EDIT<>V_NEW.DATE_EDIT THEN
            WriteStr:=':OLD.DATE_EDIT=' || TO_CHAR(V_OLD.DATE_EDIT,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_EDIT=' || TO_CHAR(V_NEW.DATE_EDIT,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.JKCOMMIT<>V_NEW.JKCOMMIT THEN
            WriteStr:=':OLD.JKCOMMIT=' || TO_CHAR(V_OLD.JKCOMMIT) || ' :NEW.JKCOMMIT=' || TO_CHAR(V_NEW.JKCOMMIT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.GROTP_ID<>V_NEW.GROTP_ID THEN
            WriteStr:=':OLD.GROTP_ID=' || TO_CHAR(V_OLD.GROTP_ID) || ' :NEW.GROTP_ID=' || TO_CHAR(V_NEW.GROTP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PERECH_TEXPD_DATE||' '<>V_NEW.PERECH_TEXPD_DATE||' ' THEN
            WriteStr:=':OLD.PERECH_TEXPD_DATE=' || TO_CHAR(V_OLD.PERECH_TEXPD_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.PERECH_TEXPD_DATE=' || TO_CHAR(V_NEW.PERECH_TEXPD_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PERECH_TEXPD_NUM<>V_NEW.PERECH_TEXPD_NUM THEN
            WriteStr:=':OLD.PERECH_TEXPD_NUM=' || (V_OLD.PERECH_TEXPD_NUM) || ' :NEW.PERECH_TEXPD_NUM=' || (V_NEW.PERECH_TEXPD_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_PROD<>V_NEW.SUM_PROD THEN
            WriteStr:=':OLD.SUM_PROD=' || TO_CHAR(V_OLD.SUM_PROD) || ' :NEW.SUM_PROD=' || TO_CHAR(V_NEW.SUM_PROD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_AKCIZ<>V_NEW.SUM_AKCIZ THEN
            WriteStr:=':OLD.SUM_AKCIZ=' || TO_CHAR(V_OLD.SUM_AKCIZ) || ' :NEW.SUM_AKCIZ=' || TO_CHAR(V_NEW.SUM_AKCIZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_PROD_NDS<>V_NEW.SUM_PROD_NDS THEN
            WriteStr:=':OLD.SUM_PROD_NDS=' || TO_CHAR(V_OLD.SUM_PROD_NDS) || ' :NEW.SUM_PROD_NDS=' || TO_CHAR(V_NEW.SUM_PROD_NDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF_NDS<>V_NEW.TARIF_NDS THEN
            WriteStr:=':OLD.TARIF_NDS=' || TO_CHAR(V_OLD.TARIF_NDS) || ' :NEW.TARIF_NDS=' || TO_CHAR(V_NEW.TARIF_NDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_VOZN11<>V_NEW.SUM_VOZN11 THEN
            WriteStr:=':OLD.SUM_VOZN11=' || TO_CHAR(V_OLD.SUM_VOZN11) || ' :NEW.SUM_VOZN11=' || TO_CHAR(V_NEW.SUM_VOZN11) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_VOZN11_NDS<>V_NEW.SUM_VOZN11_NDS THEN
            WriteStr:=':OLD.SUM_VOZN11_NDS=' || TO_CHAR(V_OLD.SUM_VOZN11_NDS) || ' :NEW.SUM_VOZN11_NDS=' || TO_CHAR(V_NEW.SUM_VOZN11_NDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_VOZN12<>V_NEW.SUM_VOZN12 THEN
            WriteStr:=':OLD.SUM_VOZN12=' || TO_CHAR(V_OLD.SUM_VOZN12) || ' :NEW.SUM_VOZN12=' || TO_CHAR(V_NEW.SUM_VOZN12) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_VOZN12_NDS<>V_NEW.SUM_VOZN12_NDS THEN
            WriteStr:=':OLD.SUM_VOZN12_NDS=' || TO_CHAR(V_OLD.SUM_VOZN12_NDS) || ' :NEW.SUM_VOZN12_NDS=' || TO_CHAR(V_NEW.SUM_VOZN12_NDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SUM_STRAH<>V_NEW.SUM_STRAH THEN
            WriteStr:=':OLD.SUM_STRAH=' || TO_CHAR(V_OLD.SUM_STRAH) || ' :NEW.SUM_STRAH=' || TO_CHAR(V_NEW.SUM_STRAH) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA<>V_NEW.CENA THEN
            WriteStr:=':OLD.CENA=' || TO_CHAR(V_OLD.CENA) || ' :NEW.CENA=' || TO_CHAR(V_NEW.CENA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA_OTP<>V_NEW.CENA_OTP THEN
            WriteStr:=':OLD.CENA_OTP=' || TO_CHAR(V_OLD.CENA_OTP) || ' :NEW.CENA_OTP=' || TO_CHAR(V_NEW.CENA_OTP) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_CENA<>V_NEW.DATE_CENA THEN
            WriteStr:=':OLD.DATE_CENA=' || TO_CHAR(V_OLD.DATE_CENA,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_CENA=' || TO_CHAR(V_NEW.DATE_CENA,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CENA_VOZN<>V_NEW.CENA_VOZN THEN
            WriteStr:=':OLD.CENA_VOZN=' || TO_CHAR(V_OLD.CENA_VOZN) || ' :NEW.CENA_VOZN=' || TO_CHAR(V_NEW.CENA_VOZN) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CAPACITY||' '<>V_NEW.CAPACITY||' ' THEN
            WriteStr:=':OLD.CAPACITY=' || (V_OLD.CAPACITY) || ' :NEW.CAPACITY=' || (V_NEW.CAPACITY) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF_GUARD<>V_NEW.TARIF_GUARD THEN
            WriteStr:=':OLD.TARIF_GUARD=' || TO_CHAR(V_OLD.TARIF_GUARD) || ' :NEW.TARIF_GUARD=' || TO_CHAR(V_NEW.TARIF_GUARD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF_GUARD_NDS<>V_NEW.TARIF_GUARD_NDS THEN
            WriteStr:=':OLD.TARIF_GUARD_NDS=' || TO_CHAR(V_OLD.TARIF_GUARD_NDS) || ' :NEW.TARIF_GUARD_NDS=' || TO_CHAR(V_NEW.TARIF_GUARD_NDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TARIF_ALT<>V_NEW.TARIF_ALT THEN
            WriteStr:=':OLD.TARIF_ALT=' || TO_CHAR(V_OLD.TARIF_ALT) || ' :NEW.TARIF_ALT=' || TO_CHAR(V_NEW.TARIF_ALT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NACENKA<>V_NEW.NACENKA THEN
            WriteStr:=':OLD.NACENKA=' || TO_CHAR(V_OLD.NACENKA) || ' :NEW.NACENKA=' || TO_CHAR(V_NEW.NACENKA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PODDONS<>V_NEW.PODDONS THEN
            WriteStr:=':OLD.PODDONS=' || TO_CHAR(V_OLD.PODDONS) || ' :NEW.PODDONS=' || TO_CHAR(V_NEW.PODDONS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SHIELDS<>V_NEW.SHIELDS THEN
            WriteStr:=':OLD.SHIELDS=' || TO_CHAR(V_OLD.SHIELDS) || ' :NEW.SHIELDS=' || TO_CHAR(V_NEW.SHIELDS) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.UPAK_ID<>V_NEW.UPAK_ID THEN
            WriteStr:=':OLD.UPAK_ID=' || TO_CHAR(V_OLD.UPAK_ID) || ' :NEW.UPAK_ID=' || TO_CHAR(V_NEW.UPAK_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.UPAK_VES<>V_NEW.UPAK_VES THEN
            WriteStr:=':OLD.UPAK_VES=' || TO_CHAR(V_OLD.UPAK_VES) || ' :NEW.UPAK_VES=' || TO_CHAR(V_NEW.UPAK_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.KOL_NET<>V_NEW.KOL_NET THEN
            WriteStr:=':OLD.KOL_NET=' || TO_CHAR(V_OLD.KOL_NET) || ' :NEW.KOL_NET=' || TO_CHAR(V_NEW.KOL_NET) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.UPAK_VES_ED<>V_NEW.UPAK_VES_ED THEN
            WriteStr:=':OLD.UPAK_VES_ED=' || TO_CHAR(V_OLD.UPAK_VES_ED) || ' :NEW.UPAK_VES_ED=' || TO_CHAR(V_NEW.UPAK_VES_ED) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.SHIELD_VES<>V_NEW.SHIELD_VES THEN
            WriteStr:=':OLD.SHIELD_VES=' || TO_CHAR(V_OLD.SHIELD_VES) || ' :NEW.SHIELD_VES=' || TO_CHAR(V_NEW.SHIELD_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PODDON_VES<>V_NEW.PODDON_VES THEN
            WriteStr:=':OLD.PODDON_VES=' || TO_CHAR(V_OLD.PODDON_VES) || ' :NEW.PODDON_VES=' || TO_CHAR(V_NEW.PODDON_VES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PL<>V_NEW.PL THEN
            WriteStr:=':OLD.PL=' || TO_CHAR(V_OLD.PL) || ' :NEW.PL=' || TO_CHAR(V_NEW.PL) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NUM_AKT<>V_NEW.NUM_AKT THEN
            WriteStr:=':OLD.NUM_AKT=' || TO_CHAR(V_OLD.NUM_AKT) || ' :NEW.NUM_AKT=' || TO_CHAR(V_NEW.NUM_AKT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.BILL_POS_ID<>V_NEW.BILL_POS_ID THEN
            WriteStr:=':OLD.BILL_POS_ID=' || TO_CHAR(V_OLD.BILL_POS_ID) || ' :NEW.BILL_POS_ID=' || TO_CHAR(V_NEW.BILL_POS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROTO_NUM||' '<>V_NEW.PROTO_NUM||' ' THEN
            WriteStr:=':OLD.PROTO_NUM=' || (V_OLD.PROTO_NUM) || ' :NEW.PROTO_NUM=' || (V_NEW.PROTO_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PROTO_DATE<>V_NEW.PROTO_DATE THEN
            WriteStr:=':OLD.PROTO_DATE=' || TO_CHAR(V_OLD.PROTO_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.PROTO_DATE=' || TO_CHAR(V_NEW.PROTO_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.NO_AKCIZ<>V_NEW.NO_AKCIZ THEN
            WriteStr:=':OLD.NO_AKCIZ=' || TO_CHAR(V_OLD.NO_AKCIZ) || ' :NEW.NO_AKCIZ=' || TO_CHAR(V_NEW.NO_AKCIZ) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PERECH_GUARD_DATE<>V_NEW.PERECH_GUARD_DATE THEN
            WriteStr:=':OLD.PERECH_GUARD_DATE=' || TO_CHAR(V_OLD.PERECH_GUARD_DATE,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.PERECH_GUARD_DATE=' || TO_CHAR(V_NEW.PERECH_GUARD_DATE,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PERECH_GUARD_NUM||' '<>V_NEW.PERECH_GUARD_NUM||' ' THEN
            WriteStr:=':OLD.PERECH_GUARD_NUM=' || (V_OLD.PERECH_GUARD_NUM) || ' :NEW.PERECH_GUARD_NUM=' || (V_NEW.PERECH_GUARD_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.TTN_ID<>V_NEW.TTN_ID THEN
            WriteStr:=':OLD.TTN_ID=' || TO_CHAR(V_OLD.TTN_ID) || ' :NEW.TTN_ID=' || TO_CHAR(V_NEW.TTN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_DOVER<>V_NEW.DATE_DOVER THEN
            WriteStr:=':OLD.DATE_DOVER=' || TO_CHAR(V_OLD.DATE_DOVER,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_DOVER=' || TO_CHAR(V_NEW.DATE_DOVER,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.FIO_DRIVER||' '<>V_NEW.FIO_DRIVER||' ' THEN
            WriteStr:=':OLD.FIO_DRIVER=' || (V_OLD.FIO_DRIVER) || ' :NEW.FIO_DRIVER=' || (V_NEW.FIO_DRIVER) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.IS_LOADED<>V_NEW.IS_LOADED THEN
            WriteStr:=':OLD.IS_LOADED=' || TO_CHAR(V_OLD.IS_LOADED) || ' :NEW.IS_LOADED=' || TO_CHAR(V_NEW.IS_LOADED) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.AXES<>V_NEW.AXES THEN
            WriteStr:=':OLD.AXES=' || TO_CHAR(V_OLD.AXES) || ' :NEW.AXES=' || TO_CHAR(V_NEW.AXES) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.CTLV<>V_NEW.CTLV THEN
            WriteStr:=':OLD.CTLV=' || TO_CHAR(V_OLD.CTLV) || ' :NEW.CTLV=' || TO_CHAR(V_NEW.CTLV) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DEFI_MASS_ID<>V_NEW.DEFI_MASS_ID THEN
            WriteStr:=':OLD.DEFI_MASS_ID=' || TO_CHAR(V_OLD.DEFI_MASS_ID) || ' :NEW.DEFI_MASS_ID=' || TO_CHAR(V_NEW.DEFI_MASS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VOLUME<>V_NEW.VOLUME THEN
            WriteStr:=':OLD.VOLUME=' || TO_CHAR(V_OLD.VOLUME) || ' :NEW.VOLUME=' || TO_CHAR(V_NEW.VOLUME) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.VOLUME15<>V_NEW.VOLUME15 THEN
            WriteStr:=':OLD.VOLUME15=' || TO_CHAR(V_OLD.VOLUME15) || ' :NEW.VOLUME15=' || TO_CHAR(V_NEW.VOLUME15) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ZPU_TYPE1<>V_NEW.ZPU_TYPE1 THEN
            WriteStr:=':OLD.ZPU_TYPE1=' || TO_CHAR(V_OLD.ZPU_TYPE1) || ' :NEW.ZPU_TYPE1=' || TO_CHAR(V_NEW.ZPU_TYPE1) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.ZPU_TYPE2<>V_NEW.ZPU_TYPE2 THEN
            WriteStr:=':OLD.ZPU_TYPE2=' || TO_CHAR(V_OLD.ZPU_TYPE2) || ' :NEW.ZPU_TYPE2=' || TO_CHAR(V_NEW.ZPU_TYPE2) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.PL15<>V_NEW.PL15 THEN
            WriteStr:=':OLD.PL15=' || TO_CHAR(V_OLD.PL15) || ' :NEW.PL15=' || TO_CHAR(V_NEW.PL15) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;
          IF V_OLD.DATE_IN<>V_NEW.DATE_IN THEN
            WriteStr:=':OLD.DATE_IN=' || TO_CHAR(V_OLD.DATE_IN,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_IN=' || TO_CHAR(V_NEW.DATE_IN,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
          END IF;*/
          
          IF WritePos=1 THEN
            DELETE FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG WHERE ID = LogId;
          END IF;  
          
        END IF;
      END IF;
    END IF;

    -- После добавления
    IF INSERTING() THEN
      NULL;
      -- Запись в лог
      IF 1=1 THEN
        SELECT seq_table_activity_log.NEXTVAL INTO LogId FROM dual;
        INSERT INTO MASTER_SHADOW.TABLE_ACTIVITY_LOG (ID,TABLE_NAME,TABLE_ID,OSUSER,TERMINAL,MODULE,EVENT_TYPE,WhatWasDone)
          SELECT LogId,'KVIT',TO_CHAR(V_NEW.ID) || TO_CHAR(V_NEW.FLG_OPERDATA),osuser,terminal,MODULE,'I',EMPTY_CLOB()
            FROM sys.V_$SESSION WHERE audsid=USERENV('sessionid');

        SELECT WhatWasDone INTO cl_WhatWasDone
            FROM MASTER_SHADOW.TABLE_ACTIVITY_LOG
            WHERE ID = LogId
            FOR UPDATE;

        WritePos:=1;

            WriteStr:=':OLD.ID=' || TO_CHAR(V_OLD.ID) || ' :NEW.ID=' || TO_CHAR(V_NEW.ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.FLG_OPERDATA=' || TO_CHAR(V_OLD.FLG_OPERDATA) || ' :NEW.FLG_OPERDATA=' || TO_CHAR(V_NEW.FLG_OPERDATA) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.MESTO_ID=' || TO_CHAR(V_OLD.MESTO_ID) || ' :NEW.MESTO_ID=' || TO_CHAR(V_NEW.MESTO_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.NOM_ZD=' || (V_OLD.NOM_ZD) || ' :NEW.NOM_ZD=' || (V_NEW.NOM_ZD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.PROD_ID_NPR=' || (V_OLD.PROD_ID_NPR) || ' :NEW.PROD_ID_NPR=' || (V_NEW.PROD_ID_NPR) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.NUM_CIST=' || (V_OLD.NUM_CIST) || ' :NEW.NUM_CIST=' || (V_NEW.NUM_CIST) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_OTGR=' || TO_CHAR(V_OLD.DATE_OTGR,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OTGR=' || TO_CHAR(V_NEW.DATE_OTGR,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.VES_BRUTTO=' || TO_CHAR(V_OLD.VES_BRUTTO) || ' :NEW.VES_BRUTTO=' || TO_CHAR(V_NEW.VES_BRUTTO) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.NUM_KVIT=' || TO_CHAR(V_OLD.NUM_KVIT) || ' :NEW.NUM_KVIT=' || TO_CHAR(V_NEW.NUM_KVIT) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_KVIT=' || TO_CHAR(V_OLD.DATE_KVIT,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_KVIT=' || TO_CHAR(V_NEW.DATE_KVIT,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.BILL_ID=' || TO_CHAR(V_OLD.BILL_ID) || ' :NEW.BILL_ID=' || TO_CHAR(V_NEW.BILL_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.SVED_ID=' || (V_OLD.SVED_ID) || ' :NEW.SVED_ID=' || (V_NEW.SVED_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_OFORML=' || TO_CHAR(V_OLD.DATE_OFORML,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_OFORML=' || TO_CHAR(V_NEW.DATE_OFORML,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.SVED_NUM=' || TO_CHAR(V_OLD.SVED_NUM) || ' :NEW.SVED_NUM=' || TO_CHAR(V_NEW.SVED_NUM) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.PASP_ID=' || (V_OLD.PASP_ID) || ' :NEW.PASP_ID=' || (V_NEW.PASP_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.SUM_PROD=' || TO_CHAR(V_OLD.SUM_PROD) || ' :NEW.SUM_PROD=' || TO_CHAR(V_NEW.SUM_PROD) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.BILL_POS_ID=' || TO_CHAR(V_OLD.BILL_POS_ID) || ' :NEW.BILL_POS_ID=' || TO_CHAR(V_NEW.BILL_POS_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.TTN_ID=' || TO_CHAR(V_OLD.TTN_ID) || ' :NEW.TTN_ID=' || TO_CHAR(V_NEW.TTN_ID) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.IS_LOADED=' || TO_CHAR(V_OLD.IS_LOADED) || ' :NEW.IS_LOADED=' || TO_CHAR(V_NEW.IS_LOADED) || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
            WriteStr:=':OLD.DATE_IN=' || TO_CHAR(V_OLD.DATE_IN,'dd.mm.yyyy hh24:mi:ss') || ' :NEW.DATE_IN=' || TO_CHAR(V_NEW.DATE_IN,'dd.mm.yyyy hh24:mi:ss') || CHR(13);
            dbms_lob.WRITE(cl_WhatWasDone, LENGTH(WriteStr),WritePos,WriteStr);
            WritePos:=WritePos+LENGTH(WriteStr);
      END IF;
    END IF;

  END IF;
END;
/


ALTER TRIGGER MASTER.T99_LOG_KVIT DISABLE;


