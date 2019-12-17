--
-- IIFDATE  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.IIFDate(Date1 IN DATE, Cond IN VARCHAR2, Date2 IN DATE)
--- Возвращает   1-True   0-False
   RETURN number IS
   Cond1 BOOLEAN;
   BEGIN
      IF Cond='<' THEN
	    Cond1:=(Date1<Date2);
	  ELSE
	    IF Cond='=' THEN
          Cond1:=(Date1=Date2);
		ELSE
		  IF Cond='<=' THEN
		    Cond1:=(Date1<=Date2);
		  ELSE
		    IF Cond='>=' THEN
			  Cond1:=(Date1>=Date2);
			ELSE
              Cond1:=(Date1>Date2);
			END IF;
		  END IF;
		END IF;
	  END IF;
	  IF (Cond1) THEN
	    RETURN(1);
	  ELSE
	    RETURN(0);
	  END IF;
    END;

/

