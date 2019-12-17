--
-- TRIM_NUMNAR  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.TRIM_NUMNAR(InS VARCHAR2)
  RETURN VARCHAR2 IS
  i NUMBER;
  j NUMBER;
  OutS VARCHAR2(250);
BEGIN
  IF InS IS NULL THEN
    RETURN InS;
  ELSE
    OutS := LTRIM(RTRIM(InS));

    i := 1;
    FOR ii IN 1..Length(OutS) LOOP
      i := ii;
      IF SUBSTR(OutS, i, 1) <> '0' THEN
        EXIT;
      END IF;
    END LOOP;

    j := 1;
    FOR jj IN 1..LENGTH(OutS) LOOP
      j:=LENGTH(OutS)-jj+1;
      IF SUBSTR(OutS, j, 1) <> '.' THEN
        EXIT;
      END IF;
    END LOOP;

    OutS := SUBSTR(OutS, i, j - i + 1);
	RETURN OutS;
  END IF;

END;

/

