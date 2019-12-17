CREATE OR REPLACE PROCEDURE       snp_p_ob_nl (
   ncompany   IN   NUMBER,
   ddate       IN   DATE,
   scstore    IN   VARCHAR2
)
AS
   ngroup_ident       NUMBER;
   nident             NUMBER;
   scgroup_code       VARCHAR2 (20);
   scnomen_code       VARCHAR2 (20);
   scmodif_code       VARCHAR2 (20);
   scpack             VARCHAR2 (20);
   scparty            VARCHAR2 (20);
   scnom_cat          VARCHAR2 (160);
   scstore_cat        VARCHAR2 (160);
   
BEGIN
   DELETE
     FROM stroperjrn_d
    WHERE authid = USER;

--   ddate := dat1 - 1;
 p_stroperjrn_d (ncompany,ddate,ngroup_ident,nident,scgroup_code,scnomen_code,scmodif_code,scpack,scparty,scnom_cat,scstore_cat,scstore);

   UPDATE stroperjrn_d
      SET gtd = '1',
          quant_in_pack = ROUND (quant / quant_in_pack, 0)
    WHERE authid = USER;

   COMMIT;
END;
/

