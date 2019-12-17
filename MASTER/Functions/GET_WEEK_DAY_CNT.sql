--
-- GET_WEEK_DAY_CNT  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Week_Day_Cnt(pDATE DATE, pWEEK_DAY NUMBER) RETURN NUMBER IS
  vFIRST DATE;
  vLAST DATE;
  vWEEK_DAY NUMBER;
  vCNT NUMBER;
BEGIN
  vFIRST:=TRUNC(pDATE,'MONTH'); -- ѕервый день мес€ца
  vLAST:=LAST_DAY(pDATE); -- ѕоследний день мес€ца
  vWEEK_DAY:=TO_NUMBER(TO_CHAR(vFIRST,'D')); -- ƒень недели первого дн€ мес€ца
  -- ѕерва€ дата искомого дн€ недели
  IF pWEEK_DAY>=vWEEK_DAY THEN
    vFIRST:=vFIRST+pWEEK_DAY-vWEEK_DAY;
  ELSE
    vFIRST:=vFIRST+7+pWEEK_DAY-vWEEK_DAY;
  END IF; 	
  vCNT:=0;
  LOOP
    IF TO_NUMBER(TO_CHAR(vFIRST,'D'))=pWEEK_DAY THEN
  	  vCNT:=vCNT+1;
	END IF;  
    vFIRST:=vFIRST+1;
    EXIT WHEN vFIRST>vLAST;
  END LOOP;  
  RETURN vCNT;
END Get_Week_Day_Cnt;

/

