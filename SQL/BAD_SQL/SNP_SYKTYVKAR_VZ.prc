CREATE OR REPLACE PROCEDURE       snp_syktyvkar_vz (
crn_ IN NUMBER , -- каталог проводки
pref_ IN VARCHAR2, -- префикс проводки
sacc_from         IN   VARCHAR2, --с какого счет
sacc_to         IN   VARCHAR2, --на  какого счет
ddate        IN   DATE,--  дата проводки
smol_from          IN   VARCHAR2,-- c какого МОЛа
smol_to           IN   VARCHAR2,-- на какой МОЛ
scurrency    IN   VARCHAR2-- валюта
)
   AS
   num_prov  NUMBER; -- номер проводки
   BEGIN

P_ECONOPRS_GETNEXTNUMB (2, pref_,   num_prov);
MODIFY_ECONOPRS (NULL, 2, crn_, 'СЕВЕРНЕФТЕПРОДУКТ', pref_, num_prov, 'Перевод остатков ЖУков', ddate, NULL, NULL, NULL, NULL, NULL, NULL, NULL, smol_from, smol_to,  num_prov );


FOR rec IN (
		   SELECT c.nomen_code,c.nomen_name,c.umeas_main,c.umeas_alt, a.PARTNO,
		   SUM(a.acnt_remn_sum) acnt_res_sum,SUM(a.acnt_remn_quant) acnt_res_quant, SUM(a.acnt_alt_quant) acnt_res_aquant
             FROM
             curnames b, dicnomns c,v_VALREMNS a
            WHERE
			   a.currency_rn = b.rn
              AND a.nomenclature_rn = c.rn (+)
              AND a.remn_date=TO_DATE('01.01.2004', 'dd.mm.yyyy') AND a.accname='41/01' AND a.agname='Есева Е.В.'
         GROUP BY a.PARTNO,a.currency_rn,a.nomenclature_rn,b.curcode,c.nomen_code,c.nomen_name,c.umeas_main,c.umeas_alt
		 ORDER BY c.nomen_name)
LOOP
END LOOP;

MODIFY_OPRSPECS ()

 END;

SELECT SNOMEN_PARTNO, SUM(NPRS_CUR) , SNOMEN_CODE
  FROM V_SALESREPORTDETAIL
WHERE
NPRN =214712875
OR
NPRN =214648409
OR
NPRN =214712921
GROUP BY SNOMEN_PARTNO,  SNOMEN_CODE
ORDER BY SNOMEN_CODE


SELECT SUM(NPRS_CUR)
  FROM V_SALESREPORTDETAIL
WHERE
NPRN =214712875
OR
NPRN =214665832
OR
NPRN =214666188

GROUP BY NPRN



SELECT SUM(NPRS_CUR)
  FROM V_SALESREPORTDETAIL
WHERE
NPRN =214662046
GROUP BY NCOMPANY



SELECT  B.sgroup_code
FROM V_SALESREPORTDETAIL A, v_dicnomns B
WHERE
A.NPRN =214662046
AND A.snomen_code = B.NOMEN_CODE
GROUP BY sgroup_code

select from v_incomefromdept
/

