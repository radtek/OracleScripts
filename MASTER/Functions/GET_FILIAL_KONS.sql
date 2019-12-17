--
-- GET_FILIAL_KONS  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.Get_Filial_Kons
 (kod_fil# NUMBER)
RETURN NUMBER
AS
  val# NUMBER;
BEGIN
  BEGIN
    SELECT MIN(ID) INTO val# FROM ORG_STRUCTURE
      WHERE filial=kod_fil#;
  EXCEPTION
    WHEN OTHERS THEN
	  val#:=31;
  END;			
  RETURN val#;
END Get_Filial_Kons;

/

