--
-- GET_START_5  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Start_5
 (dat# DATE, num_5# NUMBER)
RETURN DATE
AS
  dd DATE;
BEGIN
  RETURN TRUNC(dat#,'MONTH')+(num_5#-1)*5;
END Get_Start_5;

/

