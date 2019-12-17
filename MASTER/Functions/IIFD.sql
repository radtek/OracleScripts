--
-- IIFD  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.IIFD(Date1 IN DATE, Cond IN VARCHAR2, Date2 IN DATE,TruePart IN DATE,FalsePart IN DATE)
   RETURN DATE IS
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
	    RETURN(TruePart);
	  ELSE
	    RETURN(FalsePart);
	  END IF;
    END;

/

