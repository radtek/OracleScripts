--
-- IIF  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.IIF(Cond IN CHAR,TruePart IN NUMBER,FalsePart IN NUMBER)
   RETURN NUMBER
   IS
   BEGIN
      IF (Cond='T') THEN
	    RETURN(TruePart);
	  ELSE
	    RETURN(FalsePart);
	  END IF;
    END;

/

