--  ********************************************************************** 
--  Note: This rebuild script is not meant to be used when a possibility * 
--        exists that someone might try to access the table while it is  * 
--        being rebuilt!                                                 * 
--                                                                       * 
--        Locks are released when the first DDL, COMMIT or ROLLBACK is   * 
--        performed, so adding a "Lock table" command at the top of this * 
--        script will not prevent others from accessing the table for    * 
--        the duration of the script.                                    * 
--                                                                       * 
--   One more important note:                                            * 
--        This script will cause the catalog in replicated environments  * 
--        to become out of sync.                                         * 
--  ********************************************************************** 

--  Table Rebuild script generated by TOAD  
--  
--  Original table: UPDATELIST 
--  Backup of table: UPDATELIST_X 
--  Date: 06.08.2008 11:33:53 
--  
SET LINESIZE 200
--  
--  Make backup copy of original table 
ALTER TABLE PARUS.UPDATELIST RENAME TO UPDATELIST_X ; 
  
 

-- Drop all user named constraints
ALTER TABLE PARUS.UPDATELIST_X DROP CONSTRAINT C_UPDATELIST_NOTE_NB ;
ALTER TABLE PARUS.UPDATELIST_X DROP CONSTRAINT C_UPDATELIST_OPER_VAL ;
ALTER TABLE PARUS.UPDATELIST_X DROP CONSTRAINT SYS_C0011684 ;
ALTER TABLE PARUS.UPDATELIST_X DROP CONSTRAINT SYS_C0011685 ;
ALTER TABLE PARUS.UPDATELIST_X DROP CONSTRAINT SYS_C0011686 ;
ALTER TABLE PARUS.UPDATELIST_X DROP CONSTRAINT C_UPDATELIST_RN_PK ;

--  Recreate original table 
CREATE TABLE PARUS.UPDATELIST
(
  RN              NUMBER(17)                    NOT NULL,
  TABLENAME       VARCHAR2(32 BYTE)             NOT NULL,
  COMPANY         NUMBER(17)                    DEFAULT null,
  VERSION         NUMBER(17)                    DEFAULT null,
  TABLERN         NUMBER(17)                    NOT NULL,
  AUTHID          VARCHAR2(30 BYTE)             NOT NULL,
  MODIFDATE       DATE                          NOT NULL,
  OPERATION       VARCHAR2(1 BYTE)              NOT NULL,
  NOTE            VARCHAR2(2000 BYTE)           NOT NULL,
  BUSPROCHIST     NUMBER(17)                    DEFAULT null,
  BUSPROCACTHIST  NUMBER(17)                    DEFAULT null,
  OSUSER          VARCHAR2(30 BYTE)             DEFAULT null,
  MACHINE         VARCHAR2(64 BYTE)             DEFAULT null,
  TERMINAL        VARCHAR2(16 BYTE)             DEFAULT null,
  PROGRAM         VARCHAR2(64 BYTE)             DEFAULT null
)
TABLESPACE PARUSTEMP
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          400K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
NOMONITORING;
 
--  Copy the data from the renamed table  
INSERT /*+ APPEND */
INTO PARUS.UPDATELIST INS_TBL
(RN, TABLENAME, COMPANY, VERSION, 
TABLERN, AUTHID, MODIFDATE, OPERATION, 
NOTE, BUSPROCHIST, BUSPROCACTHIST, OSUSER, 
MACHINE, TERMINAL, PROGRAM)
SELECT 
RN, TABLENAME, COMPANY, VERSION, 
TABLERN, AUTHID, MODIFDATE, OPERATION, 
NOTE, BUSPROCHIST, BUSPROCACTHIST, OSUSER, 
MACHINE, TERMINAL, PROGRAM
FROM PARUS.UPDATELIST_X SEL_TBL 
where modifdate>=trunc(sysdate)-10; 
  
Commit ; 
  

-- Drop all other user named indexes 
DROP INDEX PARUS.I_UPDATELIST_TABLE_RN_DATE ;
DROP INDEX PARUS.UPDATELIST_DATE_I ;
DROP INDEX PARUS.I_UPDATELIST_TABLE_RN ;



--  Recreate Indexes, Constraints, and Grants 

CREATE UNIQUE INDEX PARUS.C_UPDATELIST_RN_PK ON PARUS.UPDATELIST
(RN)
LOGGING
TABLESPACE PARUSTEMPIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PARUS.I_UPDATELIST_TABLE_RN_DATE ON PARUS.UPDATELIST
(TABLENAME, TABLERN, MODIFDATE)
LOGGING
TABLESPACE PARUSTEMPIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PARUS.UPDATELIST_DATE_I ON PARUS.UPDATELIST
(MODIFDATE)
LOGGING
TABLESPACE PARUSTEMPIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


CREATE INDEX PARUS.I_UPDATELIST_TABLE_RN ON PARUS.UPDATELIST
(TABLENAME, RN)
LOGGING
TABLESPACE PARUSTEMPIDX
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          128K
            MINEXTENTS       1
            MAXEXTENTS       2147483645
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;


ALTER TABLE PARUS.UPDATELIST ADD (
  CONSTRAINT C_UPDATELIST_NOTE_NB
 CHECK ( rtrim( NOTE ) is not null ));

ALTER TABLE PARUS.UPDATELIST ADD (
  CONSTRAINT C_UPDATELIST_OPER_VAL
 CHECK ( OPERATION in( 'U','I','D' ) ));

ALTER TABLE PARUS.UPDATELIST ADD (
  CONSTRAINT SYS_C0011684
 CHECK (TABLERN IS NOT NULL));

ALTER TABLE PARUS.UPDATELIST ADD (
  CONSTRAINT SYS_C0011685
 CHECK (MODIFDATE IS NOT NULL));

ALTER TABLE PARUS.UPDATELIST ADD (
  CONSTRAINT SYS_C0011686
 CHECK (NOTE IS NOT NULL));

ALTER TABLE PARUS.UPDATELIST ADD (
  CONSTRAINT C_UPDATELIST_RN_PK
 PRIMARY KEY
 (RN)
    USING INDEX 
    TABLESPACE PARUSTEMPIDX
    PCTFREE    10
    INITRANS   2
    MAXTRANS   255
    STORAGE    (
                INITIAL          128K
                MINEXTENTS       1
                MAXEXTENTS       2147483645
                PCTINCREASE      0
                FREELISTS        1
                FREELIST GROUPS  1
               ));


GRANT DELETE, INSERT, SELECT, UPDATE ON  PARUS.UPDATELIST TO SNP_REPL_ROLE;
 
--  There are no FKeys that reference the new table to recreate. 
 

--  Analyze New Table 
Analyze Table PARUS.UPDATELIST Compute Statistics;

 
--  Recompile any dependent objects 
 
ALTER PACKAGE  "PARUS"."PKG_UPDATELIST" COMPILE PACKAGE ; 
  
ALTER PACKAGE  "SNP_REPL"."FOR_REPL" COMPILE PACKAGE ; 
  
ALTER PROCEDURE "PARUS"."KOMI_MOVE_UPDATELIST_TO_ARC" COMPILE ; 
  
ALTER PROCEDURE "PARUS"."PR_REPLICATE_DOCUMENT_SNP" COMPILE ; 
  
ALTER PROCEDURE "PARUS"."PR_UPDATELIST" COMPILE ; 
  
ALTER PROCEDURE "PARUS"."P_KOMIOIL_ARC_REMOVE" COMPILE ; 
  
ALTER PROCEDURE "PARUS"."P_UPDATELIST_BASE_DELETE" COMPILE ; 
  
ALTER PROCEDURE "PARUS"."P_UPDATELIST_BASE_MOVE_2ARC" COMPILE ; 
  
ALTER PROCEDURE "PARUS"."P_UPDATELIST_EXISTS" COMPILE ; 
  
ALTER VIEW "PARUS"."KOMI_V_UPDATELIST" COMPILE ; 
  
ALTER VIEW "PARUS"."V_UPDATELIST" COMPILE ; 
  
ALTER VIEW "PARUS"."V_UPDATELIST_COMMON" COMPILE ; 
  
ALTER VIEW "PARUS"."V_UPDATELIST_EXP" COMPILE ; 
  
ALTER VIEW "SNP_REPL"."V_REPL" COMPILE ; 
  
ALTER VIEW "SNP_REPL"."V_REPL_DOCLINKS" COMPILE ; 
  
ALTER VIEW "SNP_REPL"."V_REPL_DOCLINKS_DEL" COMPILE ; 
  
ALTER VIEW "SNP_REPL"."V_REPL_DOCLINKS_UPD" COMPILE ; 
  
ALTER VIEW "SNP_REPL"."V_REPL_PSV" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_INTANAKLDEPT_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_INTANAKLPOTR_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_INTASF_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_INTAZAYVL_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_SYKTNAKLDEPT_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_SYKTNAKLPOTR_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_SYKTSF_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_SYKTZAYVL_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_SYKTZAYVL_COUNTER_DETAIL" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_USINSKNAKLDEPT_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_USINSKNAKLPOTR_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_USINSKSF_COUNTER" COMPILE ; 
  
ALTER VIEW "VANEEV"."V_USINSKZAYVL_COUNTER" COMPILE ; 
  
--  Rebuild triggers for the new table. 
DROP TRIGGER PARUS.T_UPDATELIST_BINSERT;
DROP TRIGGER PARUS.T_UPDATELIST_BUPDATE;


CREATE OR REPLACE TRIGGER PARUS.T_UPDATELIST_BINSERT
before insert ON PARUS.UPDATELIST for each row
begin
if ( :new.RN is null ) then
:new.RN := GEN_UPDATELIST_ID;
end if;
:new.OSUSER := GET_SESSION_OSUSER;
:new.MACHINE := GET_SESSION_MACHINE;
:new.TERMINAL := GET_SESSION_TERMINAL;
:new.PROGRAM := GET_SESSION_PROGRAM;
if :new.NOTE||' '=' ' or :new.NOTE IS NULL THEN
  :new.NOTE:='?';
end if;
end;
/
SHOW ERRORS;



CREATE OR REPLACE TRIGGER PARUS.T_UPDATELIST_BUPDATE
before update ON PARUS.UPDATELIST for each row
begin
/* �������� ������������ �������� ����� */
if ( not( :new.RN = :old.RN ) ) then
P_EXCEPTION( 0,'��������� �������� ���� RN ������� UPDATELIST �����������.' );
end if;
if ( not( :new.TABLENAME = :old.TABLENAME ) ) then
P_EXCEPTION( 0,'��������� �������� ���� TABLENAME ������� UPDATELIST �����������.' );
end if;
if ( not( :new.VERSION = :old.VERSION ) and :new.COMPANY is null ) then
P_EXCEPTION( 0,'��������� �������� ���� VERSION ������� UPDATELIST �����������.' );
end if;
if ( not( :new.COMPANY = :old.COMPANY ) and :new.VERSION is not null ) then
P_EXCEPTION( 0,'��������� �������� ���� COMPANY ������� UPDATELIST �����������.' );
end if;
if ( not( :new.TABLERN = :old.TABLERN ) ) then
P_EXCEPTION( 0,'��������� �������� ���� TABLERN ������� UPDATELIST �����������.' );
end if;
if ( not( :new.AUTHID = :old.AUTHID ) ) then
P_EXCEPTION( 0,'��������� �������� ���� AUTHID ������� UPDATELIST �����������.' );
end if;
if ( not( :new.MODIFDATE = :old.MODIFDATE ) ) then
P_EXCEPTION( 0,'��������� �������� ���� MODIFDATE ������� UPDATELIST �����������.' );
end if;
if ( not( :new.OPERATION = :old.OPERATION ) ) then
P_EXCEPTION( 0,'��������� �������� ���� OPERATION ������� UPDATELIST �����������.' );
end if;
if ( not( :new.NOTE = :old.NOTE ) ) then
P_EXCEPTION( 0,'��������� �������� ���� NOTE ������� UPDATELIST �����������.' );
end if;
end;
/
SHOW ERRORS;