--
-- IIF_NUM  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.IIF_NUM(FirstIn NUMBER, Cond VARCHAR2, SecondIn NUMBER, FirstOut NUMBER, SecondOut NUMBER)
RETURN NUMBER
IS
BEGIN
  IF Cond='>' THEN
	IF FirstIn>SecondIn THEN
  	  RETURN(FirstOut);
 	ELSE
	  RETURN(SecondOut);
 	END IF;
  ELSE
    IF Cond='<' THEN	
	  IF FirstIn<SecondIn THEN
  	    RETURN(FirstOut);
 	  ELSE
	    RETURN(SecondOut);
 	  END IF;
	ELSE
	  IF Cond='=' THEN
	    IF FirstIn=SecondIn THEN
  	      RETURN(FirstOut);
 	    ELSE
	      RETURN(SecondOut);
 	    END IF;
	  ELSE
	    IF Cond = '>=' THEN
 	      IF FirstIn>=SecondIn THEN
  	        RETURN(FirstOut);
   	      ELSE
	        RETURN(SecondOut);
 	      END IF;
	    ELSE 
		  IF Cond='<=' THEN	
	        IF FirstIn<=SecondIn THEN
  	          RETURN(FirstOut);
 	        ELSE
	          RETURN(SecondOut);
 	        END IF;
	      ELSE	
	        RETURN(NULL);
	      END IF;
		END IF;
	  END IF;
	END IF;
  END IF;	  	  	
END;

/

