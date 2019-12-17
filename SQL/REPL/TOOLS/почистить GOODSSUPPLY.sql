-- Убрать уникальность
DROP INDEX PARUS.C_GOODSSUPPLY_UK;
/
CREATE  INDEX PARUS.C_GOODSSUPPLY_UK ON PARUS.GOODSSUPPLY
(PRN, STORE)
LOGGING
TABLESPACE PARUSIDX2
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
/

-- Вернуть уникальность
DROP INDEX PARUS.C_GOODSSUPPLY_UK;
/
CREATE UNIQUE INDEX PARUS.C_GOODSSUPPLY_UK ON PARUS.GOODSSUPPLY
(PRN, STORE)
LOGGING
TABLESPACE PARUSIDX2
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

-- Удалить дубли
select /*+ RULE */ a.*,a.rowid from PARUS.GOODSSUPPLY a
where exists (
select null from
(
select PRN, STORE from PARUS.GOODSSUPPLY
group by PRN, STORE having count(*)>1
) where prn=a.prn and store=a.store
) and nvl(restplan,0)=0 and nvl(restplanalt,0)=0 and nvl(restfact,0)=0 and nvl(restfactalt,0)=0 and nvl(reserv,0)=0 and nvl(reservalt,0)=0

