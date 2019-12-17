--
-- GET_RAST_INT  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Rast_Int
 (nom_zd# VARCHAR2)
RETURN VARCHAR2
AS
  rast# NUMBER;
  val# VARCHAR2(50);
BEGIN
  BEGIN
    SELECT KLS_STAN.rast INTO rast# FROM MONTH,KLS_STAN 
      WHERE MONTH.STAN_ID=KLS_STAN.ID AND MONTH.nom_zd=nom_zd#;
	rast#:=NVL(rast#,0);  
  EXCEPTION
	WHEN OTHERS THEN
	  rast#:=0;
  END;	  

  val#:='';	
  IF rast#<501 THEN
    val#:='(המ 500 ךל)';
  ELSE		
    IF rast#<1001 THEN
      val#:='(מע 501 המ 1000 ךל)';
	ELSE  
      IF rast#<1501 THEN
        val#:='(מע 1001 המ 1500 ךל)';
	  ELSE  
        IF rast#<2001 THEN
          val#:='(מע 1501 המ 2000 ךל)';
        ELSE  
          IF rast#<2501 THEN
            val#:='(מע 2001 המ 2500 ךל)';
          ELSE  
            IF rast#<3001 THEN
              val#:='(מע 2501 המ 3000 ךל)';
			ELSE  
              IF rast#<3501 THEN
                val#:='(מע 3001 המ 3500 ךל)';
			  ELSE	
                IF rast#<4001 THEN
                  val#:='(מע 3501 המ 4000 ךל)';
				ELSE  
                  IF rast#<4501 THEN
                    val#:='(מע 4001 המ 4500 ךל)';
                  ELSE  
                    IF rast#<5001 THEN
                      val#:='(מע 4501 המ 5000 ךל)';
                    ELSE  
                      IF rast#<5501 THEN
                        val#:='(מע 5001 המ 5500 ךל)';
                      ELSE  
                        IF rast#<6001 THEN
                          val#:='(מע 5501 המ 6000 ךל)';
						ELSE  
                          IF rast#<6501 THEN
                            val#:='(מע 6001 המ 6500 ךל)';
						  ELSE	
                            IF rast#<7001 THEN
                              val#:='(מע 6501 המ 7000 ךל)';
							ELSE  
                              IF rast#<7501 THEN
                                val#:='(מע 7001 המ 7500 ךל)';
	  				  	  	  ELSE  
                                IF rast#<8001 THEN
                                  val#:='(מע 7501 המ 8000 ךל)';
							    ELSE  
                                  IF rast#<8501 THEN
                                    val#:='(מע 8001 המ 8500 ךל)';
							      ELSE  
                                    IF rast#<9001 THEN
                                      val#:='(מע 8501 המ 9000 ךל)';
							        ELSE  
                                      val#:='(במכוו 9000 ךל)';
									END IF;
								  END IF;
								END IF;
							  END IF;
							END IF;
						  END IF;	  	  	  
  				        END IF;
					  END IF;
					END IF;
				  END IF;	  	
				END IF;  	
			  END IF;	  
			END IF;  
          END IF;  
		END IF;  
 	  END IF;  
	END IF;  
  END IF;  

  RETURN val#;
END Get_Rast_Int;

/

