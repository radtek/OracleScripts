--
-- MONTH_SPECIAL_DEKA_TRIAD  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Month_Special_deka_triad(AYear in number,AMonth in number) 
RETURN NUMBER IS
tmpVar NUMBER;
BEGIN

tmpVar:=123;

/*select name_npr from KLS_PROD
*/

return tmpVar;



  

      
   
   
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
       
END Month_Special_deka_triad; 
/

