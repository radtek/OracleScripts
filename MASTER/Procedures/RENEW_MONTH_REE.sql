--
-- RENEW_MONTH_REE  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.RENEW_MONTH_REE (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE master.month_ree A
    set (ves)
	 = (SELECT m.val_zd
          FROM load_buffer.UHTA_REE M
		 WHERE A.nom_zd=m.nom_zd AND A.date_ree=M.date_ree AND A.dop_ree=M.dop_ree)
    WHERE exists (SELECT m.val_zd
                    FROM load_buffer.UHTA_REE M
                   WHERE A.nom_zd=m.nom_zd AND A.date_ree=M.date_ree AND A.dop_ree=M.dop_ree);
  COMMIT;

  INSERT INTO master.month_ree
        (date_ree,dop_ree,nom_zd,ves)
	    (SELECT m.date_ree,m.dop_ree,m.nom_zd,m.val_zd
          FROM load_buffer.UHTA_REE M
		 WHERE not exists (SELECT A.nom_zd FROM master.month_ree A WHERE A.date_ree=M.date_ree AND A.dop_ree=M.dop_ree AND A.nom_zd=m.nom_zd));
  COMMIT;

  DELETE FROM master.month_ree A 
   WHERE NOT EXISTS (SELECT M.NOM_ZD from load_buffer.UHTA_REE M WHERE M.DATE_REE=A.DATE_REE AND M.DOP_REE=A.DOP_REE AND M.NOM_ZD = A.NOM_ZD) AND
     A.date_ree BETWEEN date_beg AND date_end;

  COMMIT;

END RENEW_MONTH_REE;

/

