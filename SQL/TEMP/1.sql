




CREATE OR REPLACE TRIGGER lider.trg_accept_motor_i_denc
 BEFORE
  INSERT OR UPDATE
 ON lider.accept_motor_i
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
Begin
    IF NOT F_REPL_PROCEED THEN
        PRC_CHECK_GDS_DENCITY(:NEW.gds_id, :NEW.DENCITY);
        PRC_CHECK_GDS_DENCITY(:NEW.gds_id, :NEW.WBILL_DENCITY);
    END IF;
End;
/


CREATE OR REPLACE TRIGGER lider.trg_invent_pour_denc
 AFTER
  INSERT OR UPDATE
 ON lider.invent_pour
REFERENCING NEW AS NEW OLD AS OLD
 FOR EACH ROW
Begin
    IF NOT F_REPL_PROCEED THEN
        PRC_CHECK_GDS_DENCITY(:NEW.gds_id, :NEW.DENCITY);
    END IF;
End;
/




CREATE OR REPLACE PUBLIC SYNONYM shift_report_sale FOR V_SHIFT_REPORT_SALE_KASU
/


CREATE OR REPLACE PUBLIC SYNONYM check_return_i FOR v_check_return_i_kasu
/


CREATE OR REPLACE PUBLIC SYNONYM check_return FOR v_check_return_kasu
/




update sys_unit t
set name='Сменный отчет КАСУ', MODULE = 'w_kazs', PB_LIBRARY =  'd_azs7'
where t.id = 2259;



select * from sys_unit t
where t.id = 2259;



SET DEFINE OFF;
Insert into LIDER.SYS_UNIT
   (ID, NAME, UNIT_RUN_ID, UNIT_TYPE_ID, MODULE, UNIT_ORDER, UNIT_ARHIVE, TYPE_ID, PB_LIBRARY, UNIT_READ_ONLY, MULTI_ED, UNIT_ID_ANALOG, TRANS)
 Values
   (2259, 'Сменный отчет', 102, 1, 'w_shift_report_view', 0, 0, 595, 'd_azs2', 0, 1, 0, 0);
COMMIT;



select * from zrepl_tbl@nt


select * from  zrepl_server_group@nt where id=892000000000103   


Insert into LIDER.ZREPL_SERVER_GROUP
   (ID, NAME, NOTE, TAG)
 Values
   (892000000000103, 'Сервер АЗС КАСУ', 'Сервер АЗС КАСУ идут только таблицы связанные с АЗС', 'AZS_KASU');




SELECT * FROM zrepl_srv_group_tbl@nt      
WHERE  zrepl_srv_group_tbl.group_id=892000000000103 



