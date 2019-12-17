CREATE OR REPLACE PROCEDURE PARUS.snp_vz_recalcsupply
(
nrn_ In number-- RN партии
)
as
prihod_plan NUMBER;
prihod_plan_alt NUMBER;
rashod_plan NUMBER;
rashod_plan_alt NUMBER;
prihod_fact NUMBER;
prihod_fact_alt NUMBER;
rashod_fact NUMBER;
rashod_fact_alt NUMBER;
begin

select
  nvl(sum (decode (SIGNPLAN,1,prihod,2,prihod,0)),0), --as prihod_plan,
  nvl(sum (decode (SIGNPLAN,1,prihod_alt,2,prihod_alt,0)),0), --as prihod_plan_alt,
  nvl(sum (decode (SIGNPLAN,1,rashod,2,rashod,0)),0), --as rashod_plan,
  nvl(sum (decode (SIGNPLAN,1,rashod_alt,2,rashod_alt,0)),0), --as rashod_plan_alt,
  nvl(sum (decode (SIGNPLAN,0,prihod,2,prihod,0)),0), --as prihod_fact,
  nvl(sum (decode (SIGNPLAN,0,prihod_alt,2,prihod_alt,0)),0),--as prihod_fact_alt,
  nvl(sum (decode (SIGNPLAN,0,rashod,2,rashod,0)),0),--as rashod_fact,
  nvl(sum (decode (SIGNPLAN,0,rashod_alt,2,rashod_alt,0)),0)--as rashod_fact_alt,
into
  prihod_plan,
  prihod_plan_alt,
  rashod_plan,
  rashod_plan_alt,
  prihod_fact,
  prihod_fact_alt,
  rashod_fact,
  rashod_fact_alt
from
(
  select 
    A.SIGNPLAN,
    SUM(decode (AG.GSMWAYS_TYPE,1,NVL(QUANT,0), 0)) as prihod ,
    SUM(decode (AG.GSMWAYS_TYPE,1,NVL(QUANTALT,0), 0)) as prihod_alt ,
    SUM(decode (AG.GSMWAYS_TYPE,0,NVL(QUANT,0),0))as rashod,
    SUM(decode (AG.GSMWAYS_TYPE,0,NVL(QUANTALT,0),0))as rashod_alt
  from STOREOPERJOURN A, AZSGSMWAYSTYPES AG
  where A.STOPER=AG.rn
    and A.GOODSSUPPLY=nrn_
  group by  A.SIGNPLAN
);

update goodssupply set
  restplan = prihod_plan- rashod_plan ,
  restplanalt =prihod_plan_alt - rashod_plan_alt,
  restfact =prihod_fact  - rashod_fact,
  restfactalt = prihod_fact_alt  - rashod_fact_alt
where
  rn = nrn_;

commit;

end;
/


GRANT EXECUTE ON  PARUS.SNP_VZ_RECALCSUPPLY TO PUBLIC;

