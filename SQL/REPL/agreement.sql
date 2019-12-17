Drop index PARUS.I_AGREEMENT_COMPANY_FK;

CREATE INDEX PARUS.I_AGREEMENT_COMPANY_FK ON PARUS.AGREEMENT
(COMPANY, AGR_DATE)
LOGGING
TABLESPACE PARIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

