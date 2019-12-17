--
-- V_PAYMENTS_UNUSED  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PAYMENTS_UNUSED
(DOG_ID, ID, DATE_PLAT, SUMMA, DATE_POST, 
 DOG_NUMBER, DEST_ID)
AS 
SELECT
  b.dog_id,
  a.id,
  b.DATE_PLAT,
  sum(a.summa) as summa,
  b.DATE_POST,
  kls_dog.DOG_NUMBER,
  b.dest_id
  FROM
(
SELECT
  payments.ID,
  payments.SUMMA
  FROM payments
UNION ALL
SELECT
  payments_on_bills.PAYMENTS_ID,
  -payments_on_bills.SUMMA
  FROM payments_on_bills) a,payments b,kls_dog
  WHERE a.id=b.id AND b.dog_id=kls_dog.id
  GROUP BY b.dog_id,a.id,b.DATE_PLAT,
    b.DATE_POST,
    kls_dog.DOG_NUMBER,
    b.dest_id;


