--
-- IIFN  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.IIFN(Cond IN BOOLEAN,TruePart IN NUMBER,FalsePart IN NUMBER)
   RETURN NUMBER
   IS
   BEGIN
      IF (Cond) THEN
	    RETURN(TruePart);
	  ELSE
	    RETURN(FalsePart);
	  END IF;
    END;

/

