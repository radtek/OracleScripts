--
-- TRG_BIUDR_REPL_LIST  (Trigger) 
--
CREATE OR REPLACE TRIGGER MASTER.TRG_BIUDR_REPL_LIST
BEFORE INSERT OR DELETE OR UPDATE
ON MASTER.REPL_LIST
FOR EACH ROW
DECLARE
  v_old REPL_LIST%ROWTYPE;
  v_new REPL_LIST%ROWTYPE;
  v_tmp NUMBER;
BEGIN

  IF DELETING() OR UPDATING() THEN
    -- Старые значения
    v_old.ID := :OLD.ID;
    v_old.NAME := :OLD.NAME;
    v_old.TAG := :OLD.TAG;
    v_old.REPL_KIND := :OLD.REPL_KIND;
    v_old.SRC_SITE := :OLD.SRC_SITE;
    v_old.SRC_INFO_T := :OLD.SRC_INFO_T;
    v_old.SRC_SCHEM := :OLD.SRC_SCHEM;
    v_old.SRC_TABLE := :OLD.SRC_TABLE;
    v_old.SRC_FIELDS := :OLD.SRC_FIELDS;
    v_old.SRC_WHERE := :OLD.SRC_WHERE;
    v_old.SRC_QUERY := :OLD.SRC_QUERY;
    v_old.DST_SITE := :OLD.DST_SITE;
    v_old.DST_SCHEM := :OLD.DST_SCHEM;
    v_old.DST_TABLE := :OLD.DST_TABLE;
    v_old.DST_FIELDS := :OLD.DST_FIELDS;
    v_old.DST_UNIQ := :OLD.DST_UNIQ;
    v_old.SP_TYPE_BF := :OLD.SP_TYPE_BF;
    v_old.SP_SITE_BF := :OLD.SP_SITE_BF;
    v_old.SP_NAME_BF := :OLD.SP_NAME_BF;
    v_old.SP_TYPE_AF := :OLD.SP_TYPE_AF;
    v_old.SP_SITE_AF := :OLD.SP_SITE_AF;
    v_old.SP_NAME_AF := :OLD.SP_NAME_AF;
    v_old.COMPUTE_ST := :OLD.COMPUTE_ST;
    v_old.DATE_FIELD := :OLD.DATE_FIELD;
    v_old.DATE_BEG := :OLD.DATE_BEG;
    v_old.DATE_END := :OLD.DATE_END;
    v_old.LASTDATE := :OLD.LASTDATE;
    v_old.LASTTIME := :OLD.LASTTIME;
    v_old.LASTSIZE := :OLD.LASTSIZE;
    v_old.PARAM1 := :OLD.PARAM1;
    v_old.PARAM2 := :OLD.PARAM2;
    v_old.PARAM3 := :OLD.PARAM3;
    v_old.CHECK_MODE := :OLD.CHECK_MODE;
    v_old.FLAG_IS := :OLD.FLAG_IS;
    v_old.STAT_SCHEM := :OLD.STAT_SCHEM;
    v_old.STAT_TABLE := :OLD.STAT_TABLE;
    v_old.STAT_QUERY := :OLD.STAT_QUERY;
    v_old.REPL_SCHEM := :OLD.REPL_SCHEM;
    v_old.REPL_TABLE := :OLD.REPL_TABLE;
    v_old.F_APPL_TAG := :OLD.F_APPL_TAG;
    v_old.F_CONFIRM := :OLD.F_CONFIRM;
    v_old.FILE_TYPE_O := :OLD.FILE_TYPE_O;
    v_old.FILE_TYPE_I := :OLD.FILE_TYPE_I;
    v_old.IS_ACTIVE := :OLD.IS_ACTIVE;
    v_old.IS_TRACKING := :OLD.IS_TRACKING;
    v_old.TRACKING_ORDER := :OLD.TRACKING_ORDER;
  END IF;

  -- До удаления
  IF DELETING() THEN
    NULL;
  END IF;

  IF INSERTING() OR UPDATING() THEN
    -- Новые значения
    v_new.ID := :NEW.ID;
    v_new.NAME := :NEW.NAME;
    v_new.TAG := :NEW.TAG;
    v_new.REPL_KIND := :NEW.REPL_KIND;
    v_new.SRC_SITE := :NEW.SRC_SITE;
    v_new.SRC_INFO_T := :NEW.SRC_INFO_T;
    v_new.SRC_SCHEM := :NEW.SRC_SCHEM;
    v_new.SRC_TABLE := :NEW.SRC_TABLE;
    v_new.SRC_FIELDS := :NEW.SRC_FIELDS;
    v_new.SRC_WHERE := :NEW.SRC_WHERE;
    v_new.SRC_QUERY := :NEW.SRC_QUERY;
    v_new.DST_SITE := :NEW.DST_SITE;
    v_new.DST_SCHEM := :NEW.DST_SCHEM;
    v_new.DST_TABLE := :NEW.DST_TABLE;
    v_new.DST_FIELDS := :NEW.DST_FIELDS;
    v_new.DST_UNIQ := :NEW.DST_UNIQ;
    v_new.SP_TYPE_BF := :NEW.SP_TYPE_BF;
    v_new.SP_SITE_BF := :NEW.SP_SITE_BF;
    v_new.SP_NAME_BF := :NEW.SP_NAME_BF;
    v_new.SP_TYPE_AF := :NEW.SP_TYPE_AF;
    v_new.SP_SITE_AF := :NEW.SP_SITE_AF;
    v_new.SP_NAME_AF := :NEW.SP_NAME_AF;
    v_new.COMPUTE_ST := :NEW.COMPUTE_ST;
    v_new.DATE_FIELD := :NEW.DATE_FIELD;
    v_new.DATE_BEG := :NEW.DATE_BEG;
    v_new.DATE_END := :NEW.DATE_END;
    v_new.LASTDATE := :NEW.LASTDATE;
    v_new.LASTTIME := :NEW.LASTTIME;
    v_new.LASTSIZE := :NEW.LASTSIZE;
    v_new.PARAM1 := :NEW.PARAM1;
    v_new.PARAM2 := :NEW.PARAM2;
    v_new.PARAM3 := :NEW.PARAM3;
    v_new.CHECK_MODE := :NEW.CHECK_MODE;
    v_new.FLAG_IS := :NEW.FLAG_IS;
    v_new.STAT_SCHEM := :NEW.STAT_SCHEM;
    v_new.STAT_TABLE := :NEW.STAT_TABLE;
    v_new.STAT_QUERY := :NEW.STAT_QUERY;
    v_new.REPL_SCHEM := :NEW.REPL_SCHEM;
    v_new.REPL_TABLE := :NEW.REPL_TABLE;
    v_new.F_APPL_TAG := :NEW.F_APPL_TAG;
    v_new.F_CONFIRM := :NEW.F_CONFIRM;
    v_new.FILE_TYPE_O := :NEW.FILE_TYPE_O;
    v_new.FILE_TYPE_I := :NEW.FILE_TYPE_I;
    v_new.IS_ACTIVE := :NEW.IS_ACTIVE;
    v_new.IS_TRACKING := :NEW.IS_TRACKING;
    v_new.TRACKING_ORDER := :NEW.TRACKING_ORDER;

    IF 1=1 THEN
      -- Уникальный ID
      IF v_new.ID=0 OR v_new.ID IS NULL THEN
        SELECT SEQ_REPL_LIST.nextval INTO v_new.ID FROM DUAL;
      END IF;
      -- Проверка новых значений
      NULL;
    END IF;

    IF UPDATING() THEN
      NULL;
    END IF;

    -- До обновления
    IF UPDATING() THEN
      NULL;
    END IF;

    -- До добавления
    IF INSERTING() THEN
      NULL;
    END IF;

    -- Сохранение новых значений
    :NEW.ID := v_new.ID;
    :NEW.NAME := v_new.NAME;
    :NEW.TAG := v_new.TAG;
    :NEW.REPL_KIND := v_new.REPL_KIND;
    :NEW.SRC_SITE := v_new.SRC_SITE;
    :NEW.SRC_INFO_T := v_new.SRC_INFO_T;
    :NEW.SRC_SCHEM := v_new.SRC_SCHEM;
    :NEW.SRC_TABLE := v_new.SRC_TABLE;
    :NEW.SRC_FIELDS := v_new.SRC_FIELDS;
    :NEW.SRC_WHERE := v_new.SRC_WHERE;
    :NEW.SRC_QUERY := v_new.SRC_QUERY;
    :NEW.DST_SITE := v_new.DST_SITE;
    :NEW.DST_SCHEM := v_new.DST_SCHEM;
    :NEW.DST_TABLE := v_new.DST_TABLE;
    :NEW.DST_FIELDS := v_new.DST_FIELDS;
    :NEW.DST_UNIQ := v_new.DST_UNIQ;
    :NEW.SP_TYPE_BF := v_new.SP_TYPE_BF;
    :NEW.SP_SITE_BF := v_new.SP_SITE_BF;
    :NEW.SP_NAME_BF := v_new.SP_NAME_BF;
    :NEW.SP_TYPE_AF := v_new.SP_TYPE_AF;
    :NEW.SP_SITE_AF := v_new.SP_SITE_AF;
    :NEW.SP_NAME_AF := v_new.SP_NAME_AF;
    :NEW.COMPUTE_ST := v_new.COMPUTE_ST;
    :NEW.DATE_FIELD := v_new.DATE_FIELD;
    :NEW.DATE_BEG := v_new.DATE_BEG;
    :NEW.DATE_END := v_new.DATE_END;
    :NEW.LASTDATE := v_new.LASTDATE;
    :NEW.LASTTIME := v_new.LASTTIME;
    :NEW.LASTSIZE := v_new.LASTSIZE;
    :NEW.PARAM1 := v_new.PARAM1;
    :NEW.PARAM2 := v_new.PARAM2;
    :NEW.PARAM3 := v_new.PARAM3;
    :NEW.CHECK_MODE := v_new.CHECK_MODE;
    :NEW.FLAG_IS := v_new.FLAG_IS;
    :NEW.STAT_SCHEM := v_new.STAT_SCHEM;
    :NEW.STAT_TABLE := v_new.STAT_TABLE;
    :NEW.STAT_QUERY := v_new.STAT_QUERY;
    :NEW.REPL_SCHEM := v_new.REPL_SCHEM;
    :NEW.REPL_TABLE := v_new.REPL_TABLE;
    :NEW.F_APPL_TAG := v_new.F_APPL_TAG;
    :NEW.F_CONFIRM := v_new.F_CONFIRM;
    :NEW.FILE_TYPE_O := v_new.FILE_TYPE_O;
    :NEW.FILE_TYPE_I := v_new.FILE_TYPE_I;
    :NEW.IS_ACTIVE := v_new.IS_ACTIVE;
    :NEW.IS_TRACKING := v_new.IS_TRACKING;
    :NEW.TRACKING_ORDER := v_new.TRACKING_ORDER;
  END IF;
END;
/


