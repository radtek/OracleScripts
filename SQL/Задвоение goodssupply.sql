-- Задвоение товарных запасов
select /*+ rule */ rn,prn,store from goodssupply a where exists
( 
select * from
(select prn,store,count(*) from goodssupply group by prn,store having count(*)>1) 
where prn=a.prn and store=a.store
) 
order by prn,store

--Задвоение цен
select a.rowid,b.prn,b.store,a.* from regprice a, goodssupply b 
where a.prn=b.rn
and b.rn in
(
select /*+ rule */ rn from goodssupply a where exists
( 
select * from
(select prn,store,count(*) from goodssupply group by prn,store having count(*)>1) 
where prn=a.prn and store=a.store
)
)
order by b.prn,b.store,a.prn,a.adate 

-- Исправление
BEGIN
    PR_ChangeSupply_PSV(900000143288, 312770583);
END;  

-- Пересчет
create or replace procedure test2 as 
BEGIN
  FOR lcur IN (
               select a.rn from goodssupply a, snp_repl.v_store_list c
			   where a.store=c.store_rn
			   and c.crn=311965248
			  )  loop
    snp_repl.recalc_supply(lcur.rn);
  end loop;	
END;  




CREATE UNIQUE INDEX PARUS.C_GOODSSUPPLY_UK ON PARUS.GOODSSUPPLY
(PRN, STORE)
LOGGING
TABLESPACE PARIDX
PCTFREE    10
INITRANS   6
MAXTRANS   255
STORAGE    (
            INITIAL          2640K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


  