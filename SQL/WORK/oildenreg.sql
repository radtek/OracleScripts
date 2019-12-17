
--
-- OILDENREG  (Table) 
--
CREATE TABLE OILDENREG ( RN NUMBER(17) NOT NULL, COMPANY NUMBER(17) NOT NULL, CRN NUMBER(17) NOT NULL, AZS_NUMBER NUMBER(17) NOT NULL, RES_NUMBER NUMBER(17) DEFAULT null, NOM_NUMBER NUMBER(17) NOT NULL, DATE_TIME DATE NOT NULL, DENSITY NUMBER(17,5) DEFAULT 0 NOT NULL, CELL NUMBER(17) DEFAULT null ) LOGGING NOCOMPRESS NOCACHE NOPARALLEL NOMONITORING
/


--
-- C_OILDENREG_RES_DATE_UK  (Index) 
--
CREATE UNIQUE INDEX C_OILDENREG_RES_DATE_UK ON OILDENREG (RES_NUMBER, CELL, DATE_TIME, COMPANY) LOGGING NOPARALLEL
/


--
-- C_OILDENREG_PK  (Index) 
--
CREATE UNIQUE INDEX C_OILDENREG_PK ON OILDENREG (RN) LOGGING NOPARALLEL
/


--
-- I_OILDENREG_AZS_FK  (Index) 
--
CREATE INDEX I_OILDENREG_AZS_FK ON OILDENREG (AZS_NUMBER) LOGGING NOPARALLEL
/


--
-- I_OILDENREG_CELL_FK  (Index) 
--
CREATE INDEX I_OILDENREG_CELL_FK ON OILDENREG (CELL) LOGGING NOPARALLEL
/


--
-- I_OILDENREG_COMPANY_FK  (Index) 
--
CREATE INDEX I_OILDENREG_COMPANY_FK ON OILDENREG (COMPANY) LOGGING NOPARALLEL
/


--
-- I_OILDENREG_CRN_FK  (Index) 
--
CREATE INDEX I_OILDENREG_CRN_FK ON OILDENREG (CRN) LOGGING NOPARALLEL
/


--
-- I_OILDENREG_NOMEN_FK  (Index) 
--
CREATE INDEX I_OILDENREG_NOMEN_FK ON OILDENREG (NOM_NUMBER) LOGGING NOPARALLEL
/


--
-- T_OILDENREG_BDELETE  (Trigger) 
--
CREATE OR REPLACE TRIGGER T_OILDENREG_BDELETE before delete on OILDENREG for each row
begin
/* ����������� ������� */
P_OILDENREG_IUD_EVENT( :old.RN, 'D', :old.COMPANY, :old.AZS_NUMBER, :old.CELL, :old.DATE_TIME );
end;
/
SHOW ERRORS;



--
-- T_OILDENREG_BINSERT  (Trigger) 
--
CREATE OR REPLACE TRIGGER T_OILDENREG_BINSERT
before insert on OILDENREG for each row
declare
nTMP  PKG_STD.tNUMBER;
begin
/* �������� ������ */
P_OILDENREG_CHECK_RECORD( 0,:new.COMPANY,:new.AZS_NUMBER,:new.CELL,:new.NOM_NUMBER,nTMP );
/* ����������� ������� */
P_OILDENREG_IUD_EVENT( :new.RN, 'I', :new.COMPANY, :new.AZS_NUMBER, :new.CELL, :new.DATE_TIME );
end;
/
SHOW ERRORS;



--
-- T_OILDENREG_BUPDATE  (Trigger) 
--
CREATE OR REPLACE TRIGGER T_OILDENREG_BUPDATE
before update on OILDENREG for each row
declare
nTMP  PKG_STD.tNUMBER;
begin
/* �������� ������������ �������� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� �������� ���� RN ������� OILDENREG �����������.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) ) then
P_EXCEPTION( 0,'��������� �������� ���� COMPANY ������� OILDENREG �����������.' );
end if;
/* �������� ������, ���� �� ����� �������� */
if ( :new.CRN = :old.CRN ) then
P_OILDENREG_CHECK_RECORD( 0,:new.COMPANY,:new.AZS_NUMBER,:new.CELL,:new.NOM_NUMBER,nTMP );
end if;
/* ����������� ������� */
P_OILDENREG_IUD_EVENT( :new.RN, 'U', :new.COMPANY, :new.AZS_NUMBER, :new.CELL, :new.DATE_TIME );
end;
/
SHOW ERRORS;



--
-- OILDENREG  (Synonym) 
--
CREATE PUBLIC SYNONYM OILDENREG FOR OILDENREG
/


-- 
-- Non Foreign Key Constraints for Table OILDENREG 
-- 
ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_CELL_RES_VAL CHECK ( CELL is not null or RES_NUMBER is not null ))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_DENSITY_VAL CHECK ( DENSITY >= 0 ))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_PK PRIMARY KEY (RN))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_RES_DATE_UK UNIQUE (RES_NUMBER, CELL, DATE_TIME, COMPANY))
/


-- 
-- Foreign Key Constraints for Table OILDENREG 
-- 
ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_AZS_FK FOREIGN KEY (AZS_NUMBER) REFERENCES AZSAZSLISTMT (RN))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_CELL_FK FOREIGN KEY (CELL) REFERENCES STPLCELLS (RN))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_COMPANY_FK FOREIGN KEY (COMPANY) REFERENCES COMPANIES (RN))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_CRN_FK FOREIGN KEY (CRN) REFERENCES ACATALOG (RN))
/

ALTER TABLE OILDENREG ADD ( CONSTRAINT C_OILDENREG_NOMEN_FK FOREIGN KEY (NOM_NUMBER) REFERENCES DICNOMNS (RN))
/

