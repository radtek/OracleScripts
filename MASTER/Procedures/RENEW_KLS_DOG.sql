--
-- RENEW_KLS_DOG  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.Renew_Kls_Dog (DATE_BEG DATE:=TRUNC(SYSDATE,'MONTH') ,DATE_END DATE:=SYSDATE, param1 VARCHAR2:='', param2 VARCHAR2:='', param3 VARCHAR2:='') IS
BEGIN

  UPDATE KLS_DOG
        SET (dog_number, short_number, predpr_id, dog_year, dog_date, dog_begin_date, dog_end_date, rep_kod,
		     groupdog_id, viddog_id, insure_id, gosprog_id, lukdog_id, usl_opl_id, agent_id,is_agent,unp_id)
        = (SELECT A.long_num, A.NUM_DOG, A.kod_plat, A.god_d, A.date_dog,A.date_begin, A.date_end, A.rep_kod,
		     A.group_, A.vid_dog, A.dog_strah, A.program, NVL(lukdog.id,0), NVL(A.kod_opl,0), A.kod_agent,A.is_agent,A.unp_id 
			 FROM load_buffer.v_dog_2009 A, load_buffer.v_dog_2009 lukdog WHERE A.id=KLS_DOG.id AND A.NUM_DOG2=lukdog.NUM_DOG(+))
    WHERE EXISTS (SELECT A.id FROM load_buffer.v_dog_2009 A WHERE A.id=KLS_DOG.id);
  COMMIT;

  INSERT INTO KLS_DOG (id, dog_number, short_number, predpr_id, dog_year, dog_date, dog_begin_date, dog_end_date, rep_kod,
		     groupdog_id, viddog_id, insure_id,gosprog_id, lukdog_id, usl_opl_id, agent_id,is_agent,unp_id)
	           (SELECT C.id, C.long_num, C.NUM_DOG, C.kod_plat, C.god_d, C.date_dog, C.date_begin, C.date_end, C.rep_kod,
			   C.group_, C.vid_dog, C.dog_strah,c.program,NVL(lukdog.id,0),NVL(C.kod_opl,0), C.kod_agent,C.is_agent,c.unp_id 
			   FROM load_buffer.v_dog_2009 C, load_buffer.v_dog_2009 lukdog
      WHERE C.NUM_DOG2=lukdog.NUM_DOG(+) AND NOT EXISTS (SELECT D.id FROM KLS_DOG D WHERE D.id=C.id));
  COMMIT;

END Renew_Kls_Dog; 
/

