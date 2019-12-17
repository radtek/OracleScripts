--
-- VES_PR  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.VES_PR(summa NUMBER)
  RETURN VARCHAR2 IS
  cc VARCHAR2(255);
  kops VARCHAR2(255);
  rbl VARCHAR2(255);
  ths VARCHAR2(255);
  mln VARCHAR2(255);
  bln VARCHAR2(255);
  res VARCHAR2(255);
  sm NUMBER;
  cc1 VARCHAR2(255);
BEGIN
  IF summa=0 THEN
    RETURN '0 Í„.';
  END IF;
  sm := ABS(summa);
  cc:=LTRIM(RTRIM(TO_CHAR(sm,'0000000000000.000')));
  cc1:=LTRIM(RTRIM(TO_CHAR(TRUNC(sm,0))));
  kops := LTRIM(RTRIM(SUBSTR(cc,15,3) || ' Í„.'));
  bln := propis_v(SUBSTR(cc,2,3),4,cc1);
  if bln || ' ' <> ' ' then
    bln:=bln || ' ';
  END IF;
  mln := propis_v(SUBSTR(cc,5,3),3,cc1);
  if mln || ' ' <> ' ' then
    mln:=mln || ' ';
  END IF;
  ths := propis_v(SUBSTR(cc,8,3),2,cc1);
  if ths || ' ' <> ' ' then
    ths:=ths || ' ';
  END IF;
  rbl := propis_v(SUBSTR(cc,11,3),1,cc1);
  IF TO_NUMBER(SUBSTR(cc,2,12)) <> 0 Then
    Res:=LTRIM(RTRIM(bln || mln || ths || rbl || ' ' || kops));
  ELSE
    Res:=kops;
  End IF;
  RETURN UPPER(SUBSTR(Res,1,1)) || LOWER(SUBSTR(Res,2,LENGTH(Res)-1));
END;

/

