--
-- TEST1  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.TEST1 IS
  v_tmp1 NUMBER;
BEGIN
  v_tmp1:=for_filial.GET_OST_BEGIN('2001','10314',TO_DATE('05.02.2004','dd.mm.yyyy')); 
END TEST1;

/

