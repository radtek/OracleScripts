set echo off
set feedback off
set pages 0
set lines 200
set verify off
set termout off


Spool uhta2.sql


SELECT 'set echo off' as "--" FROM dual;
SELECT 'set feedback off' as "--" FROM dual;
SELECT 'set pages 0' as "--" FROM dual;
SELECT 'set lines 200' as "--" FROM dual;
SELECT 'set verify off' as "--" FROM dual;
SELECT 'set termout off' as "--" FROM dual;
SELECT 'Spool uhta3.sql' as "--" FROM dual;

SELECT 'SELECT ''set echo off'' as "--" FROM dual;' as "--" FROM dual;
SELECT 'SELECT ''set feedback off'' as "--" FROM dual;' as "--" FROM dual;
SELECT 'SELECT ''set pages 0'' as "--" FROM dual;' as "--" FROM dual;
SELECT 'SELECT ''set lines 200'' as "--" FROM dual;' as "--" FROM dual;
SELECT 'SELECT ''set verify off'' as "--" FROM dual;' as "--" FROM dual;
SELECT 'SELECT ''set termout off'' as "--" FROM dual;' as "--" FROM dual;
SELECT 'SELECT ''Spool uhta3.log'' as "--" FROM dual;' as "--" FROM dual;


SELECT 'SELECT ''BEGIN'' FROM dual UNION ALL' as "--" FROM dual;
SELECT 'SELECT ''NULL;'' FROM dual UNION ALL' as "--" FROM dual;

SELECT * FROM
(			
SELECT DISTINCT 'SELECT '' PARUS.PR_REPLICATE_CHANGE_RN(''''DOCINPT'''','||TO_CHAR(DOCINPT.RN)||',''||TO_CHAR(RN)||'',1); '' FROM DOCINPT WHERE DOCUMENT='||TO_CHAR(DOCINPT.DOCUMENT)||' AND '||TO_CHAR(DOCINPT.RN)||'<>DOCINPT.RN UNION ALL' as SQL 
FROM DOCINPT 
WHERE RN IN (SELECT /*+ RULE */  a.TABLERN 
                FROM snp_repl.REPL_CALL_OUT a, snp_repl.REPL_SCHEMA_ROW b , snp_repl.REPL_TABLE c 
                WHERE a.schemarow_rn=b.rn AND b.table_dest_rn=c.rn AND a.counter>=3
				AND c.TABLENAME='DOCINPT' AND a.operation IN ('I','U'))
UNION ALL
SELECT DISTINCT 'SELECT '' PARUS.PR_REPLICATE_CHANGE_RN(''''DOCOUTPT'''','||TO_CHAR(DOCOUTPT.RN)||',''||TO_CHAR(RN)||'',1); '' FROM DOCOUTPT WHERE DOCUMENT='||TO_CHAR(DOCOUTPT.DOCUMENT)||' AND '||TO_CHAR(DOCOUTPT.RN)||'<>DOCOUTPT.RN UNION ALL' as SQL 
FROM DOCLINKS,DOCOUTPT
WHERE DOCLINKS.OUT_DOC=DOCOUTPT.RN AND DOCLINKS.RN IN (SELECT /*+ RULE */  a.TABLERN 
                FROM snp_repl.REPL_CALL_OUT a, snp_repl.REPL_SCHEMA_ROW b , snp_repl.REPL_TABLE c 
                WHERE a.schemarow_rn=b.rn AND b.table_dest_rn=c.rn AND a.counter>=3
				AND c.TABLENAME='DOCLINKS' AND a.operation IN ('I','U'))
ORDER BY SQL DESC	
);
SELECT 'SELECT ''END;'' FROM dual UNION ALL' FROM dual;
SELECT 'SELECT ''/'' FROM dual;' FROM dual;
SELECT 'SELECT ''spool off'' FROM dual;' FROM dual;
SELECT 'SELECT ''exit'' FROM dual;' FROM dual;

SELECT 'spool off' FROM dual;
SELECT 'exit' FROM dual;

spool off


exit