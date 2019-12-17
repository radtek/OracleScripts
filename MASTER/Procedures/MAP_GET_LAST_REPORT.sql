--
-- MAP_GET_LAST_REPORT  (Procedure) 
--
CREATE OR REPLACE PROCEDURE MASTER.MAP_GET_LAST_REPORT(AGN_RN in NUMBER, RN out number ) IS
test number;
BEGIN
   
   select parus.azsazslistmt.azs_number into RN 
   		  from parus.azsazslistmt@oracle.world 
   		  where parus.azsazslistmt.azs_agent = agn_RN;

END;

/

