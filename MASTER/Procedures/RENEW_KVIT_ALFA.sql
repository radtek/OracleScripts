--
-- RENEW_KVIT_ALFA  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_KVIT_ALFA (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
  date_inc DATE;
BEGIN

UPDATE MASTER.KVIT_ALFA SET
  (VES, KOL_NET, DATE_OTGR)
 = (SELECT VES, KOL_NET, DATE_OTGR
      FROM load_buffer.KVITALFA k
		  WHERE k.kvit_ID=KVIT_ALFA.kvit_ID AND k.con_id=kvit_alfa.con_id)
  WHERE EXISTS (SELECT NULL FROM load_buffer.KVITALFA k WHERE k.kvit_ID=KVIT_ALFA.kvit_ID AND k.con_id=kvit_alfa.con_id);

INSERT INTO MASTER.KVIT_ALFA
     (CON_ID, KVIT_ID, VES, KOL_NET, DATE_OTGR)
      (SELECT CON_ID, KVIT_ID, VES, KOL_NET, DATE_OTGR
        FROM load_buffer.KVITALFA k
        WHERE NOT EXISTS (SELECT NULL FROM MASTER.KVIT_ALFA WHERE KVIT_ALFA.kvit_ID=k.kvit_ID AND k.con_id=kvit_alfa.con_id));

COMMIT;		

DELETE FROM MASTER.KVIT_ALFA A WHERE 
    NOT EXISTS (SELECT NULL FROM load_buffer.KVITALFA k WHERE k.kvit_ID=A.kvit_ID AND k.con_id=A.con_id) AND
    A.date_otgr BETWEEN date_beg AND date_end;

COMMIT;

END Renew_KVIT_ALFA;

/
