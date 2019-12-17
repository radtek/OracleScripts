--
-- SUM_PR  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.SUM_PR(summa NUMBER)
  RETURN VARCHAR2 IS
  cc VARCHAR2(255);
  kops VARCHAR2(255);
  rbl VARCHAR2(255);
  ths VARCHAR2(255);
  mln VARCHAR2(255);
  bln VARCHAR2(255);
  sm NUMBER;
BEGIN
  IF summa=0 THEN
    RETURN '0 руб. 0 коп.';
  END IF;
  sm := ABS(summa);
  cc:=LTRIM(RTRIM(TO_CHAR(sm,'00000000000000.00')));
  kops := SUBSTR(cc,16,2) || ' коп';
  bln := propis_s(SUBSTR(cc,3,3),4);
  if bln || ' ' <> ' ' then
    bln:=bln || ' ';
  END IF;
  mln := propis_s(SUBSTR(cc,6,3),3);
  if mln || ' ' <> ' ' then
    mln:=mln || ' ';
  END IF;
  ths := propis_s(SUBSTR(cc,9,3),2);
  if ths || ' ' <> ' ' then
    ths:=ths || ' ';
  END IF;
  rbl := propis_s(SUBSTR(cc,12,3),1);
  IF TO_NUMBER(SUBSTR(cc,3,12)) <> 0 Then
    RETURN (bln || mln || ths || rbl || ' ' || kops);
  ELSE
    RETURN ('ноль руб ' || kops);
  End IF;
End;

/

