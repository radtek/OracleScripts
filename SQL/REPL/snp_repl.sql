CREATE OR REPLACE PACKAGE For_Repl AS


gREPL_NAME CONSTANT VARCHAR2(20):='SNP_REPL';

gRepl_init REPL_INIT%ROWTYPE; -- ����ன�� ९����樨 ⥪�饣� 㧫�
gErrApplCode NUMBER;
gErrApplMsg VARCHAR2(500);
gErrOraCode NUMBER;
gErrOraMsg VARCHAR2(500);

/* ������ � ����ᮬ >-100 - �� ����᪨� */

fr_REPL_OK CONSTANT NUMBER:=1; -- �訡�� ���
fr_REPL_INFO CONSTANT NUMBER:=2; -- �訡�� ���, �� �㦭� ������� � ���
fr_REPL_ERROR CONSTANT NUMBER:=-100; -- ����᪠� �訡��
fr_REPL_ERROR_NON_CRITICAL CONSTANT NUMBER:=-2; -- �� ����᪠� �訡��
fr_REPL_ACTIVE CONSTANT NUMBER:=-101; -- �訡�� �� ������ ���짮��⥫�� SNP_REPL - ⠪�� ���짮��⥫� 㦥 �ਫ��������
fr_REPL_INIT CONSTANT NUMBER:=-102;		 -- �訡�� �� �⥭�� ����஥� ९����樨
fr_REPL_ROW_NOTFOUND CONSTANT NUMBER:=-3; -- �訡�� �� ����஥��� ������: � ⠡��� ९����樨 ���� ��ப�, ��� ���ன ��� ����� � ९����㥬�� ⠡���
fr_REPL_DBLINK_NOTSEND CONSTANT NUMBER:=-104; -- �訡�� ��।�� �����஢ �१ DBLINK
fr_REPL_SQL_EMPTY CONSTANT NUMBER:=-105; -- ��ନ஢���� ������ - ���⮩
fr_REPL_NO_REPL CONSTANT NUMBER:=-106; -- ����⪠ ����᪠ ��楤��� ९����樨 �� �� ����� ९������

fr_CALL_ERR CONSTANT NUMBER:=-110; -- ����� �ᯮ������ ������: �訡��
fr_CALL_NOTSEND CONSTANT NUMBER:=0; -- ����� ������: �����⮢���
fr_CALL_RESEND CONSTANT NUMBER:=1; -- ����� ������: �����
fr_CALL_SEND CONSTANT NUMBER:=2; -- ����� ������: ��᫠�
fr_CALL_WAIT CONSTANT NUMBER:=3; -- ����� ������: ���� १���� �।��饣� ������
fr_CALL_SKIP CONSTANT NUMBER:=100; -- ����� ������: �ய�饭 �� �⠯� ������� (�㡫�஢����)
fr_CALL_OK CONSTANT NUMBER:=101; -- ����� ������: �ᯥ譮 �믮����
fr_CALL_SKIP_MODE_NODELETE CONSTANT NUMBER:=102; -- ����� ������: �ய�饭 - ०�� ��� 㤠����� (REPL_MODE=0)
fr_CALL_SKIP_MODE_CHECKDATE CONSTANT NUMBER:=103; -- ����� ������: �ய�饭 - ���५ (REPL_MODE=2)
fr_CALL_NO_DATA_FOUND CONSTANT NUMBER:=104; -- �� �믮������ ������ UPDATE ��� DELETE - ������ �� �������
fr_CALL_USER_DELETED CONSTANT NUMBER:=-111; -- ������ 㤠��� ���짮��⥫�� �� ⥪�饬 㧫�
fr_CALL_DEST_USER_DELETED CONSTANT NUMBER:=-112; -- ������ 㤠��� ���짮��⥫�� �� 㧫�-�����祭��
fr_CALL_USER_RESTORED CONSTANT NUMBER:=-11; -- ������ ����⠭����� ���짮��⥫�� �� ⥪�饬 㧫�
fr_CALL_DEST_USER_RESTORED CONSTANT NUMBER:=-113; -- ������ ����⠭����� ���짮��⥫�� �� 㧫�-�����祭��

fr_REPL_MODE_NODELETE CONSTANT NUMBER:=0; -- ����� ९����樨 - ��� 㤠�����
fr_REPL_MODE_FULL CONSTANT NUMBER:=1; -- ����� ९����樨 - �����
fr_REPL_MODE_CHECKDATE CONSTANT NUMBER:=2; -- ����� ९����樨 - �஢�ઠ ���� ����䨪�樨

/* �஢���� ����稥 ��㣮� ��ᨨ SNP_REPL */
FUNCTION Check_Login(pSessionID NUMBER) RETURN NUMBER ;

/* �������� ����� �� REPL_CALL_OUT */
PROCEDURE DeleteCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pSTATUS NUMBER, pDATE_EXEC DATE DEFAULT NULL);

/* ����⠭������� �� ��娢� ����� � REPL_CALL_OUT */
PROCEDURE RestoreCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER);

/* ���������� ����� � REPL_ANSW */
FUNCTION AddAnswOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER ,
					pSTATUS NUMBER, pNOTE VARCHAR2) RETURN NUMBER;

/* �������� ����� �� REPL_CALL */
PROCEDURE DeleteCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pStatus NUMBER, pDATE_EXEC DATE DEFAULT NULL);

/* ����⠭������� ����� � REPL_CALL */
PROCEDURE RestoreCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER);

/* ��ࠡ�⪠ �室��� �⢥⮢ ����㯨��� �� 㧫� pSITE_DEST_RN �� 㧥� pSITE_SOURCE_RN */
FUNCTION Answ_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* �ᯮ������ �室��� ����ᮢ ����㯨��� �� 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN */
FUNCTION Call_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER;

/* ��ନ஢���� ��室��� ����ᮢ � 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN �� �奬� pSCHEMA_RN */
FUNCTION Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER;

/* ������ ��室��� ����ᮢ � 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN �� �।��� �㡫�஢����
   (� ��᫥���騬 ��७�ᮬ �� REPL_CALL_OUT � REPL_CALL) */
FUNCTION Analyze_Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* ��।�� �१ DBLink � 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN ��室��� �⢥⮢ � ����ᮢ */
FUNCTION SendDBLink(pSessionID NUMBER,pTYPE VARCHAR2,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pREPL_SCHEMANAME VARCHAR2,pDBLINK VARCHAR2) RETURN NUMBER;

/* ����� ९����樨: ��ࠡ�⪠ �室��� �⢥⮢ */
FUNCTION ExecAnswIn(pSessionID NUMBER) RETURN NUMBER;

/* ����� ९����樨: ��ࠡ�⪠ �室��� ����ᮢ */
FUNCTION ExecCallIn(pSessionID NUMBER) RETURN NUMBER;

/* ����� ९����樨: ��ନ஢���� ��室��� ����ᮢ */
FUNCTION ExecCallOut(pSessionID NUMBER)  RETURN NUMBER;

/* ����� ��।�� �१ DBLink */
FUNCTION ExecDBLINK(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* �������� ID */
FUNCTION GetFileSeq RETURN NUMBER;

/* ��砫� ����㧪� ����஥� ९����樨 */
FUNCTION START_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* �����襭�� ����㧪� ����஥� ९����樨 */
FUNCTION FINISH_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* ��砫� ���㧪� ����஥� ९����樨 */
FUNCTION START_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* �����襭�� ���㧪� ����஥� ९����樨 */
FUNCTION FINISH_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* ��砫� ���㧪� ������ ९����樨 */
FUNCTION START_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* ��砫� ���㧪� ������ ९����樨 */
FUNCTION START_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* �����襭�� ���㧪� ������ ९����樨 */
FUNCTION FINISH_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* �����襭�� ���㧪� ������ ९����樨 */
FUNCTION FINISH_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER;

/* ����稥 ������ ��� ���㧪� */
FUNCTION EXPORT_READY_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* ����稥 ������ ��� ���㧪� */
FUNCTION EXPORT_READY_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER;

/* ����稥 ������ ��� �ᯮ������ */
FUNCTION EXECUTE_READY_CALL(pSessionID NUMBER) RETURN NUMBER;


END;
/

CREATE OR REPLACE PACKAGE BODY For_Repl AS

/* �㭪�� ������ �������� ����祪 �� ������ */
FUNCTION ReplaceKav (p_str VARCHAR2) RETURN VARCHAR2 AS
BEGIN
  RETURN REPLACE(p_str,'''','"');
END;

/* �஢���� ����稥 ��㣮� ��ᨨ SNP_REPL */
FUNCTION Check_Login(pSessionID NUMBER) RETURN NUMBER AS
vCnt NUMBER;
BEGIN
  vCnt:=0;
  IF USER<>gREPL_NAME THEN
    RETURN fr_REPL_NO_REPL;
  END IF;
  select COUNT(*) INTO vCnt
    from v_$session
   where AUDSID<>userenv('sessionid')
     and status IN ('ACTIVE','INACTIVE')
     and username=USER;
  IF vCnt=0 THEN
    RETURN fr_REPL_OK;
  ElSE
    RETURN fr_REPL_ACTIVE;
  END IF;
END;

/* ������ � ��� */
PROCEDURE AddLog(pSessionID NUMBER,pSiteRN NUMBER,pCallRN NUMBER,pDateLog DATE,pApplCode NUMBER, pApplMsg VARCHAR2) IS
PRAGMA AUTONOMOUS_TRANSACTION;
i NUMBER;
BEGIN
  gErrApplCode:=pApplCode;
  gErrApplMsg:=ReplaceKav(SUBSTR(pApplMsg,1,500));
  gErrOraCode:=SQLCODE;
  gErrOraMsg:=ReplaceKav(SUBSTR(SQLERRM,1,500));
  i:=FOR_SESSION.WriteToLog(pSessionId,pApplCode,pApplMsg,pSiteRN,'FOR_REPL',pDateLog,pCallRN);
  COMMIT;
EXCEPTION
  WHEN OTHERS THEN ROLLBACK;
END;

/* �������� ����� �� REPL_CALL_OUT */
PROCEDURE DeleteCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pSTATUS NUMBER, pDATE_EXEC DATE DEFAULT NULL) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  IF pSTATUS=fr_CALL_USER_DELETED THEN
    -- �᫨ ������ 㤠����� �� ����䥩�, � �㦭� 㤠����
	-- ���� ������ ⠪��
	BEGIN
	  -- ����塞 ���஡���� �� 㤠�塞�� ������
	  SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL_OUT
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- ������� ��祣�
		RETURN;
	END;
    -- �饬 ���� ������
	IF vOPERATION='D' THEN
	  -- � DELETE ��� ����� �����஢
      vALTER_RN:=0;
	ELSIF vOPERATION='I' THEN
	  -- � INSERT'� ���� ���� ������ UPDATE
	  vALTER_RN:=vUPDATE_RN;
	ELSIF vOPERATION='U' THEN
	  -- � UPDATE'� ���� ���� ������ INSERT
	  vALTER_RN:=0;
      BEGIN
	    -- �饬 INSERT
 	    SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL_OUT
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN;
	  EXCEPTION
	    WHEN OTHERS THEN
		  -- ��୮�� ���
		  vALTER_RN:=0;
	  END;
	END IF;
	vALTER_RN:=NVL(vALTER_RN,0);
  END IF;

  IF pSTATUS<>fr_CALL_SKIP THEN
    -- ������塞 �����
    UPDATE /*+ RULE */ REPL_CALL_OUT SET STATUS=pSTATUS
     WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
       AND SITE_DEST_RN=pSITE_DEST_RN
       AND (RN=pCallOutRN OR RN=vALTER_RN);
    -- ��७�ᨬ � ��娢
    INSERT INTO REPL_CALL_OUT_HIST (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, DATE_EXEC, DATE_HIST)
    SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, pDATE_EXEC, SYSDATE FROM REPL_CALL_OUT
      WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
        AND SITE_DEST_RN=pSITE_DEST_RN
        AND (RN=pCallOutRN OR RN=vALTER_RN);
  END IF;		

  -- ����塞
  DELETE /*+ RULE */ FROM REPL_CALL_OUT
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND (RN=pCallOutRN OR RN=vALTER_RN);
END;

/* ����⠭������� ����� � REPL_CALL_OUT */
PROCEDURE RestoreCallOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  -- �᫨ ������ ����⠭���������� �� ����䥩�, � �㦭� ����⠭�����
  -- ���� ������ ⠪��
  BEGIN
	-- ����塞 ���஡���� � ����⠭���������� ������
	SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL_OUT_HIST
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN;
  EXCEPTION
	WHEN OTHERS THEN
	  -- ����⠭�������� ��祣�
	  RETURN;
  END;
  -- �饬 ���� ������
  IF vOPERATION='D' THEN
    -- � DELETE ��� ����� �����஢
    vALTER_RN:=0;
  ELSIF vOPERATION='I' THEN
    -- � INSERT'� ���� ���� ������ UPDATE
    vALTER_RN:=vUPDATE_RN;
  ELSIF vOPERATION='U' THEN
    -- � UPDATE'� ���� ���� ������ INSERT
    vALTER_RN:=0;
    BEGIN
	  -- �饬 INSERT
 	  SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL_OUT_HIST
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- ��୮�� ���
	    vALTER_RN:=0;
	END;
  END IF;
  vALTER_RN:=NVL(vALTER_RN,0);
  -- ������塞 �����
  UPDATE /*+ RULE */ REPL_CALL_OUT_HIST SET STATUS=fr_CALL_USER_RESTORED
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND (RN=pCallOutRN OR RN=vALTER_RN);
  -- ����⠭�������� �� ��娢�
  INSERT INTO REPL_CALL_OUT (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT)
   SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT FROM REPL_CALL_OUT_HIST
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
      AND SITE_DEST_RN=pSITE_DEST_RN
      AND (RN=pCallOutRN OR RN=vALTER_RN);
  -- ����塞 �� ��娢�
  DELETE /*+ RULE */ FROM REPL_CALL_OUT_HIST
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND (RN=pCallOutRN OR RN=vALTER_RN);
END;

/* ��ࠡ�⪠ �室��� �⢥⮢ ����㯨��� �� 㧫� pSITE_DEST_RN �� 㧥� pSITE_SOURCE_RN */
FUNCTION Answ_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER AS
vResult NUMBER;
BEGIN
  vResult:=fr_REPL_OK;

  -- ��ॡ�ࠥ� ����� �� �室�饣� ����
  FOR lcur IN (
               SELECT /*+ RULE */ A.*
			   FROM REPL_ANSW A
			   WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- ���� ��������
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- ���� ����������
			   ORDER BY A.RN
			  )
  LOOP
    IF lcur.STATUS>=fr_CALL_OK THEN
	  -- ������ �믮���� �ᯥ譮
	  -- �������� ����� �� REPL_CALL_OUT
	  DeleteCallOut(pSessionId,lcur.CALL_OUT_RN,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.STATUS,lcur.DATE_LOG);
    ELSE
	  CASE
	    WHEN lcur.STATUS=fr_CALL_USER_DELETED THEN
		  -- ������ 㤠��� �� ⥪�饬 㧫�
		  NULL;
	    WHEN lcur.STATUS=fr_CALL_DEST_USER_DELETED THEN
		  -- ������ 㤠��� �� 㧫�-�����祭��
 	      UPDATE REPL_CALL_OUT SET STATUS=lcur.STATUS
	       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	         AND SITE_DEST_RN=pSITE_DEST_RN
		     AND RN=lcur.CALL_OUT_RN;
	    WHEN lcur.STATUS=fr_CALL_USER_RESTORED THEN
		  -- ������ ����⠭����� �� ⥪�饬 㧫�
		  NULL;
	    WHEN lcur.STATUS=fr_CALL_DEST_USER_RESTORED THEN
		  -- ������ ����⠭����� �� 㧫�-�����祭��
		  NULL;
		ELSE
 	      -- ������塞 ���稪 ����஢
	      -- ����뢠�� 䫠� ��ࠢ����
 	      UPDATE REPL_CALL_OUT SET COUNTER=COUNTER+1, STATUS=fr_CALL_RESEND
	       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	         AND SITE_DEST_RN=pSITE_DEST_RN
		     AND RN=lcur.CALL_OUT_RN;
	  END CASE;
      -- � ��ୠ�
      AddLog(pSessionId,pSITE_DEST_RN,lcur.CALL_OUT_RN,lcur.DATE_LOG,lcur.STATUS,lcur.NOTE);
      vResult:=fr_REPL_ERROR;
	END IF;

    DELETE FROM REPL_ANSW A
     WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- ���� ��������
       AND A.SITE_DEST_RN=pSITE_DEST_RN -- ���� ����������
	   AND A.RN=lcur.RN;

  END LOOP;
  RETURN vResult;
END;

/* �஢�ઠ ���������� �ᯮ������ ������ */
FUNCTION CheckReplMode (pSessionID NUMBER,pREPL_USERNAME VARCHAR2, pREPL_TABLENAME VARCHAR2,
     pREPL_TABLERN NUMBER, pREPL_MODE NUMBER, pREPL_TABLE VARCHAR2,
	 pOPERATION VARCHAR2, pMODIFDATE DATE, pCALL_RN NUMBER) RETURN NUMBER AS
  vSQLText VARCHAR2(4000);
  vCnt NUMBER;
BEGIN
  IF pREPL_MODE=fr_REPL_MODE_NODELETE AND pOPERATION='D' THEN
    -- �஢��塞 �� ����������� 㤠�����
    RETURN fr_CALL_SKIP_MODE_NODELETE;
  END IF;
  IF pREPL_MODE=fr_REPL_MODE_CHECKDATE THEN
    -- �஢��塞 �� ����稥 ����� ᢥ��� ���������
    BEGIN
	  vSQLText:='SELECT COUNT(*) FROM '||pREPL_TABLE||' WHERE REPL_USERNAME='''||pREPL_USERNAME||''''||
	  ' AND REPL_TABLENAME='''||pREPL_TABLENAME||''''||
	  ' AND REPL_TABLERN='||pREPL_TABLERN||
	  ' AND REPL_MODIFDATE>:MODIFDATE '||
      ' AND REPL_AUTHID<>'''||gRepl_Init.REPL_SCHEMANAME||''''|| -- �᪫���� ����䨪�樨, ᤥ����� ९�����஬
	  ' AND ROWNUM=1 ';
	  EXECUTE IMMEDIATE vSQLText INTO vCnt USING pMODIFDATE;
	  IF vCnt>0 THEN
        RETURN fr_CALL_SKIP_MODE_CHECKDATE;
	  END IF;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- �᫨ �訡�� - ᪮॥ �ᥣ� ��������� ⠡��� ९����樨
		-- ��� � ��� �����४⭠� �������
		AddLog(pSessionId,gRepl_init.SITE_RN,pCALL_RN,SYSDATE,fr_CALL_ERR,'�訡�� �� ���饭�� � ⠡��� '||pREPL_TABLE||': '||SQLERRM);
	END;
  END IF;
  RETURN fr_CALL_OK;
END;

/* �ᯮ������ ������ */
FUNCTION ExecuteSQL(pEXEC_MODE VARCHAR2,pSessionID NUMBER,pOPERATION VARCHAR2,pUSERNAME VARCHAR2,pTABLENAME VARCHAR2,pSQLText VARCHAR2,pCallRN NUMBER) RETURN NUMBER AS
  vSQLText VARCHAR2(8000);
  cur INTEGER; -- �����
  vCnt NUMBER;
BEGIN
  IF pOPERATION='I' THEN
    vSQLText:='INSERT INTO '||pUSERNAME||'.'||pTABLENAME;
  ELSE
    IF pOPERATION='U' THEN
      vSQLText:='UPDATE '||pUSERNAME||'.'||pTABLENAME;
	ELSE
      vSQLText:='DELETE FROM '||pUSERNAME||'.'||pTABLENAME;
	END IF;
  END IF;

  SAVEPOINT repl_exec;

  -- ���뢠�� �����
  cur := DBMS_SQL.OPEN_CURSOR;
  -- ���ᨭ� �����
  DBMS_SQL.PARSE(cur,vSQLText||' '||pSQLText,DBMS_SQL.NATIVE);
  -- �ᯮ������ �����
  vCnt := DBMS_SQL.EXECUTE (cur);
  -- ����뢠�� �����
  DBMS_SQL.CLOSE_CURSOR (cur);
  IF vCnt=0 THEN
    RETURN fr_CALL_NO_DATA_FOUND;
  ELSE
    RETURN fr_CALL_OK;
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO repl_exec;
	IF pEXEC_MODE<>'NO_ERROR' THEN
  	  AddLog(pSessionId,gRepl_init.SITE_RN,pCallRN,SYSDATE,fr_CALL_ERR,SQLERRM);
	END IF;
    RETURN fr_CALL_ERR;
END;

/* ���������� ����� � REPL_ANSW */
FUNCTION AddAnswOut(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER ,
					pSTATUS NUMBER, pNOTE VARCHAR2) RETURN NUMBER as
  vRN NUMBER;
BEGIN
  vRN:=GET_SEQ_LOCAL();
  INSERT INTO REPL_ANSW (RN,SITE_SOURCE_RN,SITE_DEST_RN,CALL_OUT_RN,STATUS,NOTE,DATE_LOG)
	   VALUES(vRN,pSITE_SOURCE_RN,pSITE_DEST_RN,pCallOutRN,pSTATUS,SUBSTR(pNOTE,1,500),SYSDATE);
  RETURN vRN;
END;


/* �������� ����� �� REPL_CALL */
PROCEDURE DeleteCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER, pStatus NUMBER, pDATE_EXEC DATE DEFAULT NULL) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  IF pSTATUS=fr_CALL_USER_DELETED THEN
    -- �᫨ ������ 㤠����� �� ����䥩�, � �㦭� 㤠����
	-- ���� ������ ⠪��
	BEGIN
	  -- ����塞 ���஡���� �� 㤠�塞�� ������
	  SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN
		 AND ROWNUM=1;
	EXCEPTION
	  WHEN OTHERS THEN
	    -- ������� ��祣�
		RETURN;
	END;
    -- �饬 ���� ������
	IF vOPERATION='D' THEN
	  -- � DELETE ��� ����� �����஢
      vALTER_RN:=0;
	ELSIF vOPERATION='I' THEN
	  -- � INSERT'� ���� ���� ������ UPDATE
	  vALTER_RN:=vUPDATE_RN;
	ELSIF vOPERATION='U' THEN
	  -- � UPDATE'� ���� ���� ������ INSERT
	  vALTER_RN:=0;
      BEGIN
	    -- �饬 INSERT
 	    SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN
		   AND ROWNUM=1;
	  EXCEPTION
	    WHEN OTHERS THEN
		  -- ��୮�� ���
		  vALTER_RN:=0;
	  END;
	END IF;
	vALTER_RN:=NVL(vALTER_RN,0);
  END IF;

  IF pStatus<fr_CALL_OK THEN
    -- ������塞 �����
	UPDATE /*+ RULE*/ REPL_CALL SET STATUS=pStatus
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	  AND ROWNUM=1;
	UPDATE /*+ RULE*/ REPL_CALL SET STATUS=pStatus
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	  AND ROWNUM=1;
    -- ��७�ᨬ �訡��� ������
    INSERT INTO REPL_CALL_ERR (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, DATE_EXEC, DATE_HIST)
  	  SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, pDATE_EXEC, SYSDATE FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	  AND ROWNUM=1;
    INSERT INTO REPL_CALL_ERR (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, DATE_EXEC, DATE_HIST)
  	  SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT, pDATE_EXEC, SYSDATE FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	  AND ROWNUM=1;
  END IF;
  -- ����塞 ������
  DELETE /*+ RULE */ FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	  AND ROWNUM=1;
  DELETE /*+ RULE */ FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	  AND ROWNUM=1;
END;

/* ����⠭������� ����� � REPL_CALL */
PROCEDURE RestoreCall(pSessionID NUMBER,pCallOutRN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER) as
  vUPDATE_RN NUMBER;
  vALTER_RN NUMBER;
  vOPERATION VARCHAR2(10);
BEGIN
  vALTER_RN:=0;
  -- �᫨ ������ ����⠭���������� �� ����䥩�, � �㦭� 㤠����
  -- ���� ������ ⠪��
  BEGIN
	  -- ����塞 ���஡���� �� ������
	  SELECT /*+ RULE */ OPERATION,UPDATE_RN INTO vOPERATION,vUPDATE_RN
	    FROM REPL_CALL_ERR
       WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
         AND SITE_DEST_RN=pSITE_DEST_RN
		 AND RN=pCallOutRN
		 AND ROWNUM=1;
  EXCEPTION
	  WHEN OTHERS THEN
	    -- ����⠭�������� ��祣�
		RETURN;
  END;
  -- �饬 ���� ������
  IF vOPERATION='D' THEN
	  -- � DELETE ��� ����� �����஢
      vALTER_RN:=0;
  ELSIF vOPERATION='I' THEN
	  -- � INSERT'� ���� ���� ������ UPDATE
	  vALTER_RN:=vUPDATE_RN;
  ELSIF vOPERATION='U' THEN
	  -- � UPDATE'� ���� ���� ������ INSERT
    vALTER_RN:=0;
    BEGIN
	    -- �饬 INSERT
 	    SELECT /*+ RULE */ RN INTO vALTER_RN
	      FROM REPL_CALL_ERR
         WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
           AND SITE_DEST_RN=pSITE_DEST_RN
		   AND UPDATE_RN=pCallOutRN
		   AND ROWNUM=1;
	EXCEPTION
	    WHEN OTHERS THEN
		  -- ��୮�� ���
		  vALTER_RN:=0;
    END;
  END IF;
  vALTER_RN:=NVL(vALTER_RN,0);

  -- ������塞 �����
  UPDATE /*+ RULE */ REPL_CALL_ERR SET STATUS=fr_CALL_USER_RESTORED
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND RN=pCallOutRN
	 AND ROWNUM=1;
  UPDATE /*+ RULE */ REPL_CALL_ERR SET STATUS=fr_CALL_USER_RESTORED
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
     AND RN=vALTER_RN
	 AND ROWNUM=1;
  -- ��७�ᨬ �訡��� ������
  INSERT INTO REPL_CALL (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT)
    SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	 AND ROWNUM=1;
  INSERT INTO REPL_CALL (RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT)
    SELECT /*+ RULE */ RN, UPDATE_RN, SITE_SOURCE_RN, SITE_DEST_RN, SCHEMA_RN, SCHEMAROW_RN, TABLERN, REPL_RN, OPERATION, MODIFDATE, COUNTER, STATUS, SENDDATE, FILENAME, SQL1_TEXT, SQL2_TEXT FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	 AND ROWNUM=1;
  -- ����塞 ������
  DELETE /*+ RULE */ FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=pCallOutRN
	 AND ROWNUM=1;
  DELETE /*+ RULE */ FROM REPL_CALL_ERR
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
	  AND SITE_DEST_RN=pSITE_DEST_RN
      AND RN=vALTER_RN
	 AND ROWNUM=1;
END;

/* �ᯮ������ �����筮�� ����� */
FUNCTION OneCallIn (pEXEC_MODE VARCHAR2,pSessionId NUMBER,pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER,
                    pSQL_TEXT VARCHAR2, pRN NUMBER, pREPL_USERNAME VARCHAR2, pREPL_TABLENAME VARCHAR2,
					pUSERNAME VARCHAR2,pTABLENAME VARCHAR2,
                    pTABLERN NUMBER, pREPL_MODE NUMBER, pREPL_TABLE VARCHAR2,
                    pOPERATION VARCHAR2, pMODIFDATE DATE) RETURN NUMBER AS
  vSQLText VARCHAR2(8000);
  vInsertSQLText VARCHAR2(8000);
  vStatusANSW NUMBER;
  vInsertRN NUMBER;
  vInsertSQL1 NUMBER;
  vInsertSQL2 NUMBER;
  vRN NUMBER;
  vNote VARCHAR2(500);
  vInsertNote VARCHAR2(500);
  vResult NUMBER;
BEGIN
  vResult:=fr_REPL_OK;
  vStatusANSW:=fr_CALL_OK;
  vInsertRN:=0;
  vNote:='';
  vInsertNote:='';
  IF pOPERATION='U' THEN
    -- �᫨ �� UPDATE - �饬 ���� INSERT
	BEGIN
	  SELECT /*+ RULE */ A.RN,A.SQL1_TEXT||A.SQL2_TEXT as SQL_TEXT
		INTO vInsertRN,vInsertSQLText
		FROM REPL_CALL A
        WHERE A.UPDATE_RN=pRN -- �� RN UPDATE'�
		  AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- ���� ��������
          AND A.SITE_DEST_RN=pSITE_DEST_RN -- ���� ����������
		  AND A.OPERATION='I';
    EXCEPTION
      WHEN OTHERS THEN
	    vInsertRN:=0;
	END;
  END IF;

  -- ��ନ�㥬 ������
  vSQLText:=pSQL_TEXT;
  -- �஢��塞 ����������� �ᯮ������
  gErrApplMsg:='';
  vStatusANSW:=CheckReplMode (pSessionId,
                    pREPL_USERNAME, pREPL_TABLENAME,
                    pTABLERN, pREPL_MODE, pREPL_TABLE,
                    pOPERATION, pMODIFDATE, pRN);
  vNote:=gErrApplMsg;
  IF vStatusANSW=fr_CALL_OK THEN
	-- �ᯮ������
  	gErrApplMsg:='';
	vStatusANSW:=ExecuteSQL(pEXEC_MODE,pSessionId,pOPERATION,pUSERNAME,pTABLENAME,vSQLText,pRN);
    vNote:=gErrApplMsg;
	IF pOPERATION='U' AND vStatusANSW=fr_CALL_NO_DATA_FOUND AND vInsertRN<>0 THEN
	  -- �᫨ UPDDATE �� 㤠��� ��-�� ������⢨� ����� � ���� INSERT
      -- �믮��塞 ������ INSERT
 	  gErrApplMsg:='';
      vStatusANSW:=ExecuteSQL(pEXEC_MODE,pSessionId,'I',pUSERNAME,pTABLENAME,vInsertSQLText,pRN);
	  vInsertNote:=gErrApplMsg;
	END IF;
  END IF;

  -- ��ନ�㥬 �⢥� �� UPDATE ��� DELETE
  IF vStatusANSW>=fr_CALL_OK THEN
	vNote:='';
	vInsertNote:='';
    IF pEXEC_MODE='NO_ERROR' AND vStatusANSW=fr_CALL_NO_DATA_FOUND THEN
	  vResult:=fr_CALL_NO_DATA_FOUND;
	END IF;
  ELSE
	vResult:=fr_REPL_ERROR;
  END IF;
  -- �᫨ ०�� "��� �訡��", � ���⢥ত��� � 㤠�塞 ⮫쪮 �ᯥ��
  IF pEXEC_MODE<>'NO_ERROR' OR vResult=fr_REPL_OK THEN
    vRN:=AddAnswOut(pSessionId,pRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,vNote);
    IF vInsertRN<>0 THEN
	  -- ��ନ�㥬 �⢥� �� INSERT
  	  vRN:=AddAnswOut(pSessionId,vInsertRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,vInsertNote);
    END IF;
    -- ����塞 ������ �� ���� REPL_CALL
    DeleteCall(pSessionId,pRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,SYSDATE);
    IF vInsertRN<>0 THEN
  	  DeleteCall(pSessionId,vInsertRN,pSITE_SOURCE_RN,pSITE_DEST_RN,vStatusANSW,SYSDATE);
    END IF;
  END IF;
--  IF pEXEC_MODE<>'NO_ERROR' THEN
    COMMIT;
--  END IF;
  RETURN vResult;
END;

/* �ᯮ������ �室��� ����ᮢ ����㯨��� �� 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN */
FUNCTION Call_In(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER AS
  vStatus NUMBER;
  vResult NUMBER;
BEGIN
  vResult:=fr_REPL_OK;
  -- 1-� ��室: ��� ॣ����樨 �訡��, ��� 㤠����� �訡���� �����஢,
  -- ��� �஬������� COMMIT'�� � � ⮬ ���浪�, � ���஬ �������
  -- �।������⥫쭮 �ᯮ��﫨��
  -- ����, ���� ���-�� 1 �ᯥ�� ������
  LOOP
    vResult:=fr_REPL_ERROR; -- �⮡� �� ��横����� �� ������⢨� �����஢
    FOR lcur IN (
               SELECT /*+ RULE */ A.*, A.SQL1_TEXT ||A.SQL2_TEXT as SQL_TEXT,
			          C.REPL_MODE, C.REPL_TABLE,
					  D.REPL_USERNAME, D.REPL_TABLENAME,
					  D.USERNAME, D.TABLENAME
			   FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- ���� ��������
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- ���� ����������
			     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
                 AND A.SITE_DEST_RN=B.SITE_DEST_RN
				 AND A.SCHEMA_RN=B.RN
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_DEST_RN=D.RN -- ������ �� 㧫�-�����祭��
				 AND A.OPERATION IN ('U','D') -- ⮫쪮 DELETE � UPDATE
				 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
				 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
				 AND A.STATUS>fr_REPL_ERROR -- ����஫� �����
			   ORDER BY A.MODIFDATE,A.REPL_RN
			  )
    LOOP
      vStatus:=OneCallIn ('NO_ERROR',pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,
                    lcur.SQL_TEXT,lcur.RN,lcur.REPL_USERNAME,lcur.REPL_TABLENAME,
                    lcur.USERNAME,lcur.TABLENAME,
                    lcur.TABLERN,lcur.REPL_MODE,lcur.REPL_TABLE,
                    lcur.OPERATION,lcur.MODIFDATE);
	  IF vStatus>fr_REPL_ERROR AND vStatus<>fr_CALL_NO_DATA_FOUND THEN
	    vResult:=fr_REPL_OK;
	  END IF;
    END LOOP;
    EXIT WHEN vResult=fr_REPL_ERROR;
  END LOOP;
  COMMIT;

  vResult:=fr_REPL_OK;
  -- 2-�� ��室: � ॣ����樥� �訡��
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, A.SQL1_TEXT ||A.SQL2_TEXT as SQL_TEXT,
			          C.REPL_MODE, C.REPL_TABLE,
					  D.REPL_USERNAME, D.REPL_TABLENAME,
					  D.USERNAME, D.TABLENAME
			   FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- ���� ��������
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- ���� ����������
			     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
                 AND A.SITE_DEST_RN=B.SITE_DEST_RN
				 AND A.SCHEMA_RN=B.RN
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_DEST_RN=D.RN -- ������ �� 㧫�-�����祭��
				 AND A.OPERATION IN ('D','U') -- ⮫쪮 DELETE � UPDATE
				 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
				 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
				 AND A.STATUS>fr_REPL_ERROR -- ����஫� �����
			   ORDER BY B.SORTBY,C.SORTBY,A.TABLERN
			  )
  LOOP
    vStatus:=OneCallIn ('FULL',pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,
                    lcur.SQL_TEXT,lcur.RN,lcur.REPL_USERNAME,lcur.REPL_TABLENAME,
                    lcur.USERNAME,lcur.TABLENAME,
                    lcur.TABLERN,lcur.REPL_MODE,lcur.REPL_TABLE,
                    lcur.OPERATION,lcur.MODIFDATE);
	IF vStatus<=fr_REPL_ERROR THEN
	  vResult:=fr_REPL_ERROR;
	END IF;
	COMMIT;
  END LOOP;

  RETURN vResult;
END;

/* ���������� ����� � REPL_CALL_OUT */
FUNCTION AddCallOut(pSessionID NUMBER,pSQLText VARCHAR2,pUpdate_RN NUMBER,
                    pSITE_SOURCE_RN NUMBER ,pSITE_DEST_RN NUMBER ,pSCHEMA_RN NUMBER, pSCHEMAROW_RN NUMBER,
					pTABLERN NUMBER,
			        pReplRN NUMBER,pOperation VARCHAR2,pModifdate DATE) RETURN NUMBER as
  vRN NUMBER;
  vSQL1 VARCHAR2(4000);
  vSQL2 VARCHAR2(4000);
BEGIN
  vSQL1:=SUBSTR(pSQLText,1,4000);
  vSQL2:=SUBSTR(pSQLText,4001,8000);
  IF vSQL1||' '<>' ' THEN
	-- REPL_CALL_OUT
	vRN:=GET_SEQ_LOCAL();
    INSERT INTO REPL_CALL_OUT
	   (RN,UPDATE_RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,TABLERN,
	    REPL_RN,OPERATION,MODIFDATE,COUNTER,STATUS,SQL1_TEXT,SQL2_TEXT)
	  VALUES(
		vRN,pUpdate_RN,pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,pSCHEMAROW_RN,pTABLERN,
			pReplRN,pOperation,pModifdate,1,fr_CALL_NOTSEND,vSQL1,vSQL2);
  ELSE
    vRN:=fr_REPL_SQL_EMPTY;
  END IF;
  RETURN vRN;
END;


/* ��ନ஢���� ��室��� ����ᮢ � 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN �� �奬� pSCHEMA_RN */
FUNCTION Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pSCHEMA_RN NUMBER) RETURN NUMBER AS
TYPE ReplCursor_type IS REF CURSOR;
ReplCursor ReplCursor_type;

vReplRN NUMBER; -- RN ⠡���� ९����樨
vTableRN NUMBER; -- RN ९����㥬�� ⠡���� �� ⠡���� ९����樨
vOrigRN NUMBER; -- RN ९����㥬�� ⠡���� �� ᠬ�� ⠡����
vOperation VARCHAR2(1); -- ������
vModifdate DATE;  -- ��� ����䨪�樨

cur INTEGER; -- �����

f_number NUMBER; -- ���� ⨯� NUMBER
f_varchar2 VARCHAR2(2000); -- ���� ⨯� VARCHAR2
f_date DATE; -- ���� ⨯� DATE

fdbk INTEGER; -- �������  EXECUTE

vSQLFields VARCHAR2(2000); -- ���᮪ ९����㥬�� �����
vSQLFieldsD VARCHAR2(2000); -- ���᮪ ९����㥬�� ����� (� ���⠢��� D.)
vSQLText VARCHAR2(4000); -- ����� �� 㤠����� ��� ����������
vSQLTextINS VARCHAR2(4000); -- ����� �� ����������
vStatus NUMBER; -- ����� ��� ⠡���� REPL_STATUS
vResult NUMBER; -- ������� �㭪樨

TYPE Column_rec IS RECORD (
      COLUMN_ID NUMBER,
	  COLUMN_NAME VARCHAR2(30),
      DATA_TYPE VARCHAR2(120),
	  DATA_LENGTH NUMBER
   ); -- ���: ���ᠭ�� ����
TYPE Columns_type IS TABLE OF Column_rec INDEX BY BINARY_INTEGER; -- ���: ᯨ᮪ �����
ColList Columns_type; -- ���᮪ �����
ColListCount NUMBER; -- ���-�� �����
zpt VARCHAR2(1);
i NUMBER;
s VARCHAR2(4000);
vUpdate_RN NUMBER;
vRN NUMBER;
BEGIN

  vResult:=fr_REPL_OK;

  -- ���뢠�� �����
  cur := DBMS_SQL.OPEN_CURSOR;

  -- ��ॡ�ࠥ� ⠡����, ���ᠭ�� � �奬� ९����樨
  FOR lcur IN (
               SELECT
			     A.RN as SCHEMAROW_RN,
			     B.REPL_USERNAME, B.REPL_TABLENAME, -- ������ �� ⠡���� ९����樨
			     B.USERNAME, B.TABLENAME, -- ������/�।�⠢�����, ��� ���ன ���� �믮������� �������
				 B.RNNAME, -- ��� 㭨���쭮�� ID
				 Trim(A.SQL_FIELDS) as SQL_FIELDS, -- ���᮪ �����
				 Trim(A.SQL_WHERE) as SQL_WHERE, -- ���. �᫮���
				 Trim(A.REPL_TABLE) as REPL_TABLE, -- �����쭠� ⠡���/�।�⠢����� ९����樨
				 A.REPL_MODE, -- ����� ९����樨
				 A.SORTBY -- ���冷�
			   FROM REPL_SCHEMA_ROW A, REPL_TABLE B
			   WHERE A.TABLE_SOURCE_RN=B.RN -- ������ �� 㧫�-���筨��
			     AND A.IS_ACTIVE=1  -- ��⨢��� ��ப� �奬�
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN -- ���� ��������
                 AND A.SITE_DEST_RN=pSITE_DEST_RN -- ���� ����������
                 AND A.SCHEMA_RN=pSCHEMA_RN -- �奬� ९����樨
			   ORDER BY A.SORTBY,B.USERNAME,B.TABLENAME
			  )
  LOOP
    EXIT WHEN vResult<=fr_REPL_ERROR;
    ColListCount:=0;
	vSQLFields:=lcur.SQL_FIELDS;
	-- �᫨ ᯨ᮪ ����� ���⮩
	if vSQLFields||' ' = ' ' then
	  vSQLFields:='*';
	end if;
	vSQLFields:=','||vSQLFields||',';
	vSQLFields:=NLS_UPPER(Replace(vSQLFields,' ',''));
	-- �஢��� ����稥 ���� RN (�᫨ ��� - ������塞 � ᯨ᮪ �����)
    IF INSTR(vSQLFields,','||lcur.RNNAME||',')<=0 AND vSQLFields<>',*,' THEN
	  vSQLFields:=vSQLFields||lcur.RNNAME||',';
    END IF;

    -- ��।��塞 ᯨ᮪ ����� � ���� ���ᨢ�
	FOR cs IN (SELECT C.COLUMN_ID,C.COLUMN_NAME,C.DATA_TYPE, C.DATA_LENGTH
                      FROM SYS.ALL_TAB_COLUMNS C
					 WHERE C.OWNER=lcur.USERNAME
					   AND C.TABLE_NAME=lcur.TABLENAME
                     ORDER BY C.COLUMN_ID)
    LOOP
	  IF INSTR(vSQLFields,','||cs.COLUMN_NAME||',')>0 OR vSQLFields=',*,' THEN
	    ColListCount:=ColListCount+1;
		ColList(ColListCount):=cs;
	  END IF;
	END LOOP;

    -- ��।��塞 ᯨ᮪ ����� � ���� ��ப�
	vSQLFields:='';
	vSQLFieldsD:='';
	zpt:='';
	FOR i IN 1..ColListCount LOOP
	  vSQLFields:=vSQLFields||zpt||ColList(i).COLUMN_NAME;
	  vSQLFieldsD:=vSQLFieldsD||zpt||'D.'||ColList(i).COLUMN_NAME;
	  zpt:=',';
	END LOOP;

    -- ��ந� ����� �� �롮�� ������
    vSQLText:=
        'SELECT /*+ RULE */ A.REPL_RN,A.REPL_TABLERN,A.REPL_OPERATION,A.REPL_MODIFDATE, D.' || lcur.RNNAME ||' as REPL_RN_ORIG, '||vSQLFieldsD;
    vSQLText:=vSQLText || ' FROM ' || lcur.REPL_TABLE || ' A, ';
	vSQLText:=vSQLText || lcur.USERNAME || '.' || lcur.TABLENAME || ' D ' ||
        ' WHERE A.REPL_TABLERN=D.' || lcur.RNNAME || '(+)'||
		'   AND NOT EXISTS (SELECT NULL FROM REPL_STATUS B ' ||
        '                    WHERE B.SITE_SOURCE_RN=' || TO_CHAR(pSITE_SOURCE_RN) ||
        '                      AND B.SITE_DEST_RN=' || TO_CHAR(pSITE_DEST_RN) ||
        '                      AND B.SCHEMA_RN=' || TO_CHAR(pSCHEMA_RN) ||
        '                      AND B.SCHEMAROW_RN=' || TO_CHAR(lcur.SCHEMAROW_RN) ||
        '                      AND B.REPL_RN=A.REPL_RN) ' ||
		'   AND A.REPL_USERNAME='''||lcur.REPL_USERNAME||'''' ||
		'   AND A.REPL_TABLENAME='''||lcur.REPL_TABLENAME||'''' ||
	    '   AND A.REPL_AUTHID<>'''||gRepl_Init.REPL_SCHEMANAME||''''; -- �᪫���� ����䨪�樨, ᤥ����� ९�����஬
	-- ��⥬ ०�� ९����樨
	CASE
	  WHEN lcur.REPL_MODE=0 THEN
	    vSQLText:=vSQLText||'   AND A.REPL_OPERATION IN (''I'',''U'')';  -- ���쪮 IU
	  WHEN lcur.REPL_MODE=3 THEN
	    vSQLText:=vSQLText||'   AND A.REPL_OPERATION = ''D'''; -- ���쪮 D
  	  ELSE
	    vSQLText:=vSQLText||'   AND A.REPL_OPERATION IN (''I'',''U'',''D'')'; -- ���쪮 IUD
	END CASE;
	IF lcur.SQL_WHERE||' '<>' ' THEN
	  vSQLText:=vSQLText||' AND '|| lcur.SQL_Where;
	END IF;
	vSQLText:=vSQLText||' ORDER BY A.REPL_RN ';

    -- �஬����筠� �窠 �⪠�
    SAVEPOINT repl_pars;

	BEGIN
  	  -- ���ᨭ� �����
      DBMS_SQL.PARSE(cur,vSQLText,DBMS_SQL.NATIVE);

	  -- ��।��塞 ����
	  -- ��㦥���
      DBMS_SQL.DEFINE_COLUMN (cur, 1, vReplRN);
      DBMS_SQL.DEFINE_COLUMN (cur, 2, vTableRN);
      DBMS_SQL.DEFINE_COLUMN (cur, 3, vOperation, 1);
      DBMS_SQL.DEFINE_COLUMN (cur, 4, vModifdate);
      DBMS_SQL.DEFINE_COLUMN (cur, 5, vOrigRN);

	  -- �����
	  FOR i IN 1..ColListCount LOOP
	    IF ColList(i).DATA_TYPE='NUMBER' THEN
          DBMS_SQL.DEFINE_COLUMN (cur, i+5, f_number);
	    END IF;
	    IF ColList(i).DATA_TYPE='VARCHAR2' THEN
          DBMS_SQL.DEFINE_COLUMN (cur, i+5, f_varchar2,ColList(i).DATA_LENGTH);
	    END IF;
	    IF ColList(i).DATA_TYPE='DATE' THEN
          DBMS_SQL.DEFINE_COLUMN (cur, i+5, f_date);
	    END IF;
	  END LOOP;

	  -- �����⢫塞 ��ॡ�� ९����㥬�� ����ᥩ ⠡����
      fdbk := DBMS_SQL.EXECUTE (cur);
      LOOP
        EXIT WHEN DBMS_SQL.FETCH_ROWS (cur) = 0;
        EXIT WHEN vResult<=fr_REPL_ERROR;
	    -- ��⠥� ᫥����� ����
        DBMS_SQL.COLUMN_VALUE (cur, 1, vReplRN);
        DBMS_SQL.COLUMN_VALUE (cur, 2, vTableRN);
        DBMS_SQL.COLUMN_VALUE (cur, 3, vOperation);
        DBMS_SQL.COLUMN_VALUE (cur, 4, vModifdate);
        DBMS_SQL.COLUMN_VALUE (cur, 5, vOrigRN);

	    vSQLText:='';
	    vStatus:=fr_REPL_OK;
	    -- ��⠥� ���� � ����묨 � �ନ�㥬 ������
	    IF vOperation='D' THEN
	      -- ��������
		  vSQLText:='WHERE '||lcur.RNNAME||'='||TO_CHAR(vTableRN);
 	      IF lcur.SQL_WHERE||' '<>' ' THEN
	        vSQLText:=vSQLText||' AND '|| lcur.SQL_Where;
	      END IF;
		  vSQLTextINS:='';
	    ELSE
	      IF vOrigRN IS NOT NULL THEN
		    vOperation:='U';
  	        -- ���������� ��� ����������
	  	    -- 1. ����� �� ����������
		    vSqlText:='SET ';
		    -- 2. ����� �� ����������
		    vSqlTextINS:='('||vSQLFields||') VALUES (';
		    zpt:=' ';
		    -- ��ॡ�ࠥ� ����
  	        FOR i IN 1..ColListCount LOOP
	          IF ColList(i).DATA_TYPE='NUMBER' THEN
		        DBMS_SQL.COLUMN_VALUE (cur, i+5, f_number);
		  	    if f_number IS NULL then
			      s:='NULL';
			    else
			      s:=TO_CHAR(f_number);
			    end if;
                vSQLText:=vSQLText||zpt||ColList(i).COLUMN_NAME||'='||s;
                vSQLTextINS:=vSQLTextINS||zpt||s;
			    zpt:=',';
		      END IF;
  	          IF ColList(i).DATA_TYPE='VARCHAR2' THEN
		        DBMS_SQL.COLUMN_VALUE (cur, i+5, f_varchar2);
			    if f_varchar2 IS NULL then
			      s:='NULL';
			    else
			      s:=Replace(f_varchar2,'''','''''');
			      s:=''''||s||'''';
			    end if;
                vSQLText:=vSQLText||zpt||ColList(i).COLUMN_NAME||'='||s;
                vSQLTextINS:=vSQLTextINS||zpt||s;
			    zpt:=',';
  	          END IF;
 	          IF ColList(i).DATA_TYPE='DATE' THEN
		        DBMS_SQL.COLUMN_VALUE (cur, i+5, f_date);
			    if f_date IS NULL then
			      s:='NULL';
			    else
			      s:='TO_DATE('''||TO_CHAR(f_date,'DD.MM.YYYY HH24:MI:SS')||''',''DD.MM.YYYY HH24:MI:SS'')';
			    end if;
                vSQLText:=vSQLText||zpt||ColList(i).COLUMN_NAME||'='||s;
                vSQLTextINS:=vSQLTextINS||zpt||s;
			    zpt:=',';
	          END IF;
	        END LOOP;
		    -- �����蠥� �ନ஢���� ����ᮢ
            vSQLText:=vSQLText||' WHERE '||lcur.RNNAME||'='||TO_CHAR(vTableRN);
		    -- ������塞 � UPDATE ���.�᫮���
 	        IF lcur.SQL_WHERE||' '<>' ' THEN
	          vSQLText:=vSQLText||' AND '|| lcur.SQL_Where;
	        END IF;
            vSQLTextINS:=vSQLTextINS||')';
		  ELSE
		    -- U ��� I, � ����� ���
		    vStatus:=fr_REPL_ROW_NOTFOUND;
		  END IF;
  	    END IF;

	    -- �஬����筠� �窠 �⪠�
        SAVEPOINT repl_row;

	    -- ������塞 ���� ��室��� ����ᮢ
	    IF vStatus=fr_REPL_OK then
	      -- �᭮���� �����
		  vUpdate_RN:=NULL;
		  vUpdate_RN:=AddCallOut(pSessionId,vSQLText,vUpdate_RN,
		                       pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,lcur.SCHEMAROW_RN,
							   vTableRN,
			                   vReplRN,vOperation,vModifdate);
	      IF vUpdate_RN<0 THEN
		    vStatus:=vUpdate_RN;
		    vUpdate_RN:=NULL;
		  END IF;
	    END IF;

	    IF vStatus=fr_REPL_OK AND vSQLTextINS||' '<>' ' Then
	      -- ����� �� ����������
		  vRN:=AddCallOut(pSessionId,vSQLTextINS,vUpdate_RN,
		                       pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,lcur.SCHEMAROW_RN,
							   vTableRN,
			                   vReplRN,'I',vModifdate);
	    END IF;

	    IF vStatus > fr_REPL_ERROR then
	      -- ������ �뫠 ��९���஢��� 㤠筮
	      -- ������塞 ������ � ⠡���� ����ᮢ
		  UPDATE REPL_STATUS SET
		    STATUS=vStatus,TABLERN=vTableRN
		  WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
		    AND SITE_DEST_RN=pSITE_DEST_RN
			AND SCHEMA_RN=pSCHEMA_RN
			AND SCHEMAROW_RN=lcur.SCHEMAROW_RN
			AND REPL_RN=vReplRN;
		  IF SQL%NOTFOUND THEN
  	        vRN:=GET_SEQ_LOCAL();
  		    INSERT INTO REPL_STATUS (RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,REPL_RN,STATUS,TABLERN)
		      VALUES(vRN,pSITE_SOURCE_RN,pSITE_DEST_RN,pSCHEMA_RN,lcur.SCHEMAROW_RN,vReplRN,vStatus,vTableRN);
		  END IF;
	    ELSE
	      -- ������ �뫠 ��९���஢��� ��㤠筮 - �㦭� ᫥��� �⪠�����
          ROLLBACK TO repl_row;
		  vResult:=fr_REPL_ERROR;
	    END IF;
      END LOOP;
    EXCEPTION
	  WHEN OTHERS THEN
		ROLLBACK TO repl_pars;
	    vResult:=fr_REPL_ERROR;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'�訡�� �� �ନ஢���� ��室��� ����ᮢ (REPL_SCHEMA_ROW.RN='||TO_CHAR(lcur.SCHEMAROW_RN)||'): '||SQLERRM);
	END;
  END LOOP;
  DBMS_SQL.CLOSE_CURSOR (cur);

  RETURN vResult;
END;


/* ��⠭����� ����� ����� � REPL_CALL_OUT */
PROCEDURE SetCallOutStatus(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pRN NUMBER,pSTATUS NUMBER) AS
BEGIN
  UPDATE /*+ RULE */ REPL_CALL_OUT SET STATUS=pSTATUS
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
     AND SITE_DEST_RN=pSITE_DEST_RN
	 AND RN=pRN;
END;


/* ������ ��室��� ����ᮢ � 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN �� �।��� �㡫�஢����
   (� ��᫥���騬 ����஢����� �� REPL_CALL_OUT � REPL_CALL) */
FUNCTION Analyze_Call_Out(pSessionID NUMBER,pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER) RETURN NUMBER AS
  vLastUserName VARCHAR2(30);
  vLastTableName VARCHAR2(50);
  vLastTableRn NUMBER;
  vLastOperation VARCHAR2(1);
BEGIN

  -- ��� ��� ⠡���
  -- ��ॡ�ࠥ� �� ��ࠢ����� ������� UPDATE ��� DELETE � REPL_CALL_OUT 
  -- � ���⭮� ���浪� (�⮡� ��⠢����� ⮫쪮 ��᫥���� ���������)
  vLastUserName:='';
  vLastTableName:='';
  vLastTableRn:=0;
  vLastOperation:='';
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, D.USERNAME, D.TABLENAME
			    FROM REPL_CALL_OUT A, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- �� ��ࠢ�����
				 AND A.OPERATION IN ('U','D') -- ���쪮 UPDATE ��� DELETE
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_SOURCE_RN=D.RN
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
				 AND A.SITE_DEST_RN=pSITE_DEST_RN
			   ORDER BY D.USERNAME, D.TABLENAME, A.TABLERN, A.MODIFDATE DESC, A.REPL_RN DESC
			  )
  LOOP
    IF lcur.USERNAME=vLastUserName AND
	   lcur.TABLENAME=vLastTableName AND
	   lcur.TABLERN=vLastTableRn Then
	   -- �� �� ������
	   IF vLastOperation='D' and lcur.OPERATION='D'  THEN
		 -- �᫨ �।���� ������ �뫠 㤠�����,
         -- � ⥪��� - ⮦� 㤠�����
	     SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
	   ELSE
	     IF vLastOperation = 'U' and lcur.OPERATION='U' THEN
		   -- �᫨ �।���� ������ �뫠 ����������,
           -- � ⥪��� - ⮦� ����������
	       SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
		 ELSE
		   -- �।���� � ⥪��� ������ - ࠧ��
	       vLastOperation:=lcur.OPERATION;
		 END IF;
	   END IF;
	ELSE
	   -- ������ ����������
       vLastUserName:=lcur.USERNAME;
       vLastTableName:=lcur.TABLENAME;
       vLastTableRn:=lcur.TABLERN;
       vLastOperation:=lcur.OPERATION;
    END IF;
  END LOOP;

  -- ���쪮 ��� DOCLINKS
  -- ��ॡ�ࠥ� �� ��ࠢ����� ������� UPDATE ��� DELETE � REPL_CALL_OUT 
  -- � DELETE � ��砫� ᯨ᪠ (�⮡� �᪫���� INSERT/UPDATE ��᫥ DELETE)
  vLastUserName:='';
  vLastTableName:='';
  vLastTableRn:=0;
  vLastOperation:='';
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, D.USERNAME, D.TABLENAME
			    FROM REPL_CALL_OUT A, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- �� ��ࠢ�����
				 AND A.OPERATION IN ('U','D') -- ���쪮 UPDATE ��� DELETE
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_SOURCE_RN=D.RN
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
				 AND A.SITE_DEST_RN=pSITE_DEST_RN
				 AND D.REPL_USERNAME='PARUS'
				 AND D.REPL_TABLENAME='DOCLINKS'
			   ORDER BY D.USERNAME, D.TABLENAME, A.TABLERN, DECODE(A.OPERATION,'D',0,1)
			  )
  LOOP
    IF lcur.USERNAME=vLastUserName AND
	   lcur.TABLENAME=vLastTableName AND
	   lcur.TABLERN=vLastTableRn Then
	   -- �� �� ������
	   IF vLastOperation='D' THEN
		 -- �᫨ �।���� ������ �뫠 㤠�����,
         -- � �� ��⠫�� - 㤠�塞
	     SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
	   ELSE
	     IF vLastOperation = 'U' and lcur.OPERATION='U' THEN
		   -- �᫨ �।���� ������ �뫠 ����������,
           -- � ⥪��� - ⮦� ����������
	       SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_SKIP);
		 ELSE
		   -- �।���� � ⥪��� ������ - ࠧ��
	       vLastOperation:=lcur.OPERATION;
		 END IF;
	   END IF;
	ELSE
	   -- ������ ����������
       vLastUserName:=lcur.USERNAME;
       vLastTableName:=lcur.TABLENAME;
       vLastTableRn:=lcur.TABLERN;
       vLastOperation:=lcur.OPERATION;
    END IF;
  END LOOP;

  -- ��।��塞 ��� ��� ��⠢���� �����஢ ���ﭨ� �������� 
  -- (��אַ� ���冷� ��ॡ�� - �⮡� ���� �� ��ࠢ���, � ��⠫�� ����� ��� १����)
  vLastUserName:='';
  vLastTableName:='';
  vLastTableRn:=0;
  vLastOperation:='';
  FOR lcur IN (
               SELECT /*+ RULE */ A.*, D.USERNAME, D.TABLENAME
			    FROM REPL_CALL_OUT A, REPL_SCHEMA_ROW C, REPL_TABLE D
			   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- �� ��ࠢ�����
				 AND A.OPERATION IN ('U','D') -- ���쪮 UPDATE ��� DELETE
				 AND A.SCHEMAROW_RN=C.RN
				 AND C.TABLE_SOURCE_RN=D.RN
				 AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
				 AND A.SITE_DEST_RN=pSITE_DEST_RN
			   ORDER BY D.USERNAME, D.TABLENAME, A.TABLERN, A.MODIFDATE, A.REPL_RN
			  )
  LOOP
    IF lcur.USERNAME=vLastUserName AND
	   lcur.TABLENAME=vLastTableName AND
	   lcur.TABLERN=vLastTableRn Then
       -- �� ��⠫�� ������� � ⠪�� �� TABLERN
       -- ��ॢ���� � ���ﭨ� ��������
       SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_WAIT);
	ELSE
	   -- ������ ����������
       vLastUserName:=lcur.USERNAME;
       vLastTableName:=lcur.TABLENAME;
       vLastTableRn:=lcur.TABLERN;
       vLastOperation:=lcur.OPERATION;
	   IF lcur.STATUS=fr_CALL_WAIT THEN
         -- �᫨ ������ � ���ﭨ� ��������
         -- � ��ॢ���� ��� � ���ﭨ� - � ��ࠢ��
         SetCallOutStatus(pSessionId,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN,fr_CALL_NOTSEND);
	   END IF;
    END IF;
  END LOOP;
  
  -- �ਢ���� � ᮮ⢥��⢨� ������
  UPDATE /*+ RULE */ REPL_CALL_OUT A SET STATUS=
    (SELECT MAX(B.STATUS)
	   FROM REPL_CALL_OUT B
	  WHERE B.RN=A.UPDATE_RN
        AND B.SITE_SOURCE_RN=pSITE_SOURCE_RN
        AND B.SITE_DEST_RN=pSITE_DEST_RN)
   WHERE EXISTS (SELECT NULL
	               FROM REPL_CALL_OUT B
				  WHERE B.RN=A.UPDATE_RN
                    AND B.SITE_SOURCE_RN=pSITE_SOURCE_RN
	                AND B.SITE_DEST_RN=pSITE_DEST_RN)
     AND A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND,fr_CALL_WAIT) -- �� ��ࠢ�����
     AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
	 AND A.SITE_DEST_RN=pSITE_DEST_RN;

  -- �����㥬 ����ࠢ����� ����� �� REPL_CALL_OUT � REPL_CALL,
  INSERT INTO REPL_CALL
  SELECT /*+ RULE */ * FROM REPL_CALL_OUT A
   WHERE A.STATUS IN (fr_CALL_NOTSEND,fr_CALL_RESEND) --
     AND A.COUNTER<=2 -- ����஢ ������ 2
     AND A.SITE_SOURCE_RN=pSITE_SOURCE_RN
	 AND A.SITE_DEST_RN=pSITE_DEST_RN
	 AND NOT EXISTS (  -- ������ ⠬ �� ���
	    SELECT NULL FROM REPL_CALL B
		 WHERE B.SITE_SOURCE_RN=pSITE_SOURCE_RN
	       AND B.SITE_DEST_RN=pSITE_DEST_RN
		   AND B.RN=A.RN);

  -- ����塞 �ய�饭�� �����
  FOR lcur IN (SELECT /*+ RULE */ * FROM REPL_CALL_OUT
               WHERE STATUS IN (fr_CALL_SKIP) -- �ய�饭�
                 AND SITE_SOURCE_RN=pSITE_SOURCE_RN
            	 AND SITE_DEST_RN=pSITE_DEST_RN)
  LOOP
--    AddLog(pSessionId,gRepl_init.SITE_RN,lcur.RN,SYSDATE,fr_CALL_SKIP,'������ �ய�饭 �� ������� � �㤥� 㤠���');
    DeleteCallOut(pSessionId,lcur.RN,pSITE_SOURCE_RN,pSITE_DEST_RN,fr_CALL_SKIP,NULL);
  END LOOP;

  RETURN fr_REPL_OK;
END;

/* ��।�� �१ DBLink � 㧫� pSITE_SOURCE_RN �� 㧥� pSITE_DEST_RN ��室��� �⢥⮢ � ����ᮢ */
FUNCTION SendDBLink(pSessionID NUMBER,pTYPE VARCHAR2, pSITE_SOURCE_RN NUMBER,pSITE_DEST_RN NUMBER,pREPL_SCHEMANAME VARCHAR2,pDBLINK VARCHAR2) RETURN NUMBER AS
  SQLText VARCHAR2(4000);
  vStatus NUMBER;
BEGIN
  -- ��ࠢ�� REPL_ANSW - �⢥�� �� �室�騥 ������
  IF pTYPE='REPL_ANSW' THEN
    BEGIN
	  -- �����⮢�� � ��।��
	  vStatus:=START_EXPORT_ANSW(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN);
      -- ��।��
	  IF vStatus>fr_REPL_ERROR THEN
        SQLText:='INSERT INTO '||pREPL_SCHEMANAME||'.REPL_ANSW';
        IF pDBLINK||' '<>' ' THEN
          SQLText:=SQLText||'@'||pDBLINK;
        END IF;
  	    SQLText:=SQLText||' (RN,SITE_SOURCE_RN,SITE_DEST_RN,CALL_OUT_RN,SENDDATE,STATUS,NOTE,DATE_LOG) ';
        SQLText:=SQLText||' SELECT RN,SITE_SOURCE_RN,SITE_DEST_RN,CALL_OUT_RN,SYSDATE,STATUS,NOTE,DATE_LOG '||
	    ' FROM REPL_ANSW WHERE SITE_SOURCE_RN='||TO_CHAR(pSITE_SOURCE_RN)||' AND SITE_DEST_RN='||TO_CHAR(pSITE_DEST_RN);
	    EXECUTE IMMEDIATE SQLText;
	    -- �����襭�� ��।��
	    vStatus:=FINISH_EXPORT_ANSW(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN);
	  END IF;
	  IF vStatus<=fr_REPL_ERROR THEN
	    ROLLBACK;
	  END IF;
    EXCEPTION
      WHEN OTHERS THEN
	  BEGIN
        ROLLBACK;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_DBLINK_NOTSEND,'����⪠ ��।�� �� 㧥� '||TO_CHAR(pSITE_SOURCE_RN)||' (�奬� '||pREPL_SCHEMANAME||') �१ DBLINK='||pDBLINK||': '||SQLERRM);
        RETURN fr_REPL_DBLINK_NOTSEND;
	  END;
    END;
  END IF;

  IF pTYPE='REPL_CALL' THEN
    -- ��ࠢ�� REPL_CALL - ��室�騥 ������
    BEGIN
	  -- ��ॡ�ࠥ� ������� � REPL_CALL (���묨 - INSERT)
      FOR lcur IN (SELECT * FROM REPL_CALL
                    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN
					  AND SITE_DEST_RN=pSITE_DEST_RN
 	 			    ORDER BY UPDATE_RN NULLS FIRST, RN)
	  LOOP
	    -- �����⮢�� � ��।��
  	    vStatus:=START_EXPORT_CALL(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN);
        -- ��।��
		IF vStatus>fr_REPL_ERROR THEN
  	      SQLText:='INSERT INTO '||pREPL_SCHEMANAME||'.REPL_CALL';
          IF pDBLINK||' '<>' ' THEN
            SQLText:=SQLText||'@'||pDBLINK;
          END IF;
	      SQLText:=SQLText||' (RN,UPDATE_RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,TABLERN,REPL_RN,OPERATION,MODIFDATE,COUNTER,STATUS,SENDDATE,SQL1_TEXT,SQL2_TEXT) ';
          SQLText:=SQLText||' SELECT /*+ RULE */ RN,UPDATE_RN,SITE_SOURCE_RN,SITE_DEST_RN,SCHEMA_RN,SCHEMAROW_RN,TABLERN,REPL_RN,OPERATION,MODIFDATE,COUNTER,STATUS,SYSDATE,SQL1_TEXT,SQL2_TEXT '||
             ' FROM REPL_CALL WHERE RN='||TO_CHAR(lcur.RN)||' AND SITE_SOURCE_RN='||TO_CHAR(pSITE_SOURCE_RN)||' AND SITE_DEST_RN='||TO_CHAR(pSITE_DEST_RN);
	      EXECUTE IMMEDIATE SQLText;
		  -- �����襭�� ��।��
	      vStatus:=FINISH_EXPORT_CALL(pSessionID,pSITE_SOURCE_RN,pSITE_DEST_RN,lcur.RN);
		END IF;
	    IF vStatus<=fr_REPL_ERROR THEN
	      ROLLBACK;
	    END IF;
	  END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
	  BEGIN
        ROLLBACK;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_DBLINK_NOTSEND,'����⪠ ��।�� �� 㧥� '||TO_CHAR(pSITE_DEST_RN)||' (�奬� '||pREPL_SCHEMANAME||') �१ DBLINK='||pDBLINK||': '||SQLERRM);
        RETURN fr_REPL_DBLINK_NOTSEND;
	  END;
    END;
  END IF;
  RETURN fr_REPL_OK;
END;

/* ����� ९����樨: ��ࠡ�⪠ �室��� �⢥⮢ */
FUNCTION ExecAnswIn(pSessionID NUMBER) RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- �।���������� �� �࠭ᯮ��� 䠩�� 㦥 ����㦥�� � ���� REPL_ANSW
  -- ���� �� ���� �������� �१ DBLink

  -- ��।��塞 ⥪�騩 㧥� (1 ������)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'�訡�� �� �⥭�� ���ଠ樨 � ⥪�饬 㧫�:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- �஢��塞 ����������� ������ (��� �᪫�祭�� ���� �����६����� ९����権)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' 㦥 ����饭�');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ����� �ࠢ� ����᪠�� ९������');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ᬮ��� ����᪠�� ९������: �訡�� �� ������');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;

  vResult:=fr_REPL_OK;

  -- �������� ������
  -- ��ॡ�ࠥ� 㧫�, � ����묨 � ⥪�饣� 㧫�
  -- ���� ��⨢�� �裡 �� ������ (��᪮��� �⢥�� �� ��室�騥 ������)
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN -- ���� ����������
                 FROM REPL_SCHEMA A,REPL_SITE B
                WHERE A.SITE_DEST_RN=B.RN
				  AND B.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_SOURCE_RN=gRepl_init.SITE_RN -- ����騩 㧥�: ��������
  			    ORDER BY B.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
	BEGIN
  	  vErr:=Answ_In(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'�訡�� �� ��ࠡ�⪥ �室��� �⢥⮢:'||SQLERRM);
	END;
  END LOOP;

  COMMIT;
  RETURN vResult;
END;

/* ����� ९����樨: �����⮢�� � ९����樨 */
PROCEDURE START_REPL(pSessionID NUMBER) AS
BEGIN
  -- �⪫�砥� ॣ������ ᮡ�⨩ ��� ⥪�饩 ��ᨨ
  parus.pkg_updatelist.drop_register(null,null);

  -- �����⮢�� ᯨ᪠ ⮢���� ����ᮢ (��� ������)
  DELETE FROM SOJ_TMP;

  -- ����� �� ��ୠ�� ᪫��᪨� ����権 (�� �������� �����ࠬ)
  INSERT INTO SOJ_TMP (SOJ_RN, OPERATION, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ DISTINCT A.TABLERN,A.OPERATION,E.GOODSSUPPLY
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.STOREOPERJOURN E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='STOREOPERJOURN'
	 AND A.TABLERN=E.RN(+);

  -- ����� �� ⮢���� ����ᮢ (�� �������� �����ࠬ)
  INSERT INTO SOJ_TMP (SOJ_RN, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ 0, A.TABLERN
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='GOODSSUPPLY';

  -- �����⮢�� ᯨ᪠ ⮢���� ����ᮢ (��� ������ ���⪮� �� ���⠬ �࠭����)
  DELETE FROM SPOJ_TMP;

  -- ����� �� ��ୠ�� १�ࢨ஢���� �� ���⠬ �࠭���� (�� �������� �����ࠬ)
  INSERT INTO SPOJ_TMP (SPOJ_RN, OPERATION, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ DISTINCT A.TABLERN,A.OPERATION,E.GOODSSUPPLY
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.STRPLOPRJRNL E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='STRPLOPRJRNL'
	 AND A.TABLERN=E.RN(+);

  -- ����� �� ⮢���� ����ᮢ (�� �������� �����ࠬ)
  INSERT INTO SPOJ_TMP (SPOJ_RN, SUPPLY_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ 0, A.TABLERN
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='GOODSSUPPLY';

  -- �����⮢�� ᯨ᪠ ��楢�� ��⮢ (��� ������)
  DELETE FROM LN_TMP;

  -- ����� �� ��ୠ�� ���㧮� (�� �������� �����ࠬ)
  INSERT INTO LN_TMP (LN_RN, OPERATION, FACEACC_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ A.TABLERN,A.OPERATION,E.FACEACC
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.LIABILITYNOTES E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='LIABILITYNOTES'
	 AND A.TABLERN=E.RN(+);

  -- ����� �� ��ୠ�� ���⥦�� (�� �������� �����ࠬ)
  INSERT INTO LN_TMP (LN_RN, OPERATION, FACEACC_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ A.TABLERN,A.OPERATION,E.FACEACC
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D, PARUS.PAYNOTES E
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='PAYNOTES'
	 AND A.TABLERN=E.RN(+);

  -- ����� �� ��楢�� ��⮢ (�� �������� �����ࠬ)
  INSERT INTO LN_TMP (LN_RN, FACEACC_BEFORE)
  SELECT /*+ ORDERED INDEX(A REPL_CALL_PK) */ 0,A.TABLERN
    FROM REPL_CALL A, REPL_SCHEMA B, REPL_SCHEMA_ROW C, REPL_TABLE D
   WHERE A.SITE_DEST_RN=gRepl_init.SITE_RN -- �室�騥 ������
     AND A.SITE_SOURCE_RN=B.SITE_SOURCE_RN
     AND A.SITE_DEST_RN=B.SITE_DEST_RN
	 AND A.SCHEMA_RN=B.RN
	 AND A.SCHEMAROW_RN=C.RN
     AND C.TABLE_DEST_RN=D.RN
	 AND B.IS_ACTIVE=1 -- ��⨢��� �奬�
	 AND C.IS_ACTIVE=1 -- ��⨢��� ��ப� �奬�
	 AND D.REPL_USERNAME='PARUS'
	 AND D.REPL_TABLENAME='FACEACC';

  COMMIT;
END;

/* ����� ९����樨: �����襭�� ९����樨 */
PROCEDURE FINISH_REPL(pSessionID NUMBER) AS
BEGIN
  -- �����⮢�� ᯨ᪠ ⮢���� ����ᮢ (��� ������)
  -- ���⠢�� ⥪�騥 ���祭�� STOREOPERJOURN.GOODSSUPPLY
  UPDATE SOJ_TMP SET (SUPPLY_AFTER)=
  (
    SELECT DISTINCT E.GOODSSUPPLY
      FROM PARUS.STOREOPERJOURN E
     WHERE E.RN=SOJ_TMP.SOJ_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.STOREOPERJOURN E
     WHERE E.RN=SOJ_TMP.SOJ_RN
  );

  COMMIT;

  -- �믮���� ������ ⮢���� ����ᮢ
  FOR lcur IN (
               SELECT SUPPLY_BEFORE as GOODSSUPPLY_RN
                 FROM SOJ_TMP
				UNION
               SELECT SUPPLY_AFTER
                 FROM SOJ_TMP
				)
  LOOP
    IF lcur.GOODSSUPPLY_RN IS NOT NULL THEN
      snp_repl.recalc_supply(lcur.GOODSSUPPLY_RN);
	END IF;
  END LOOP;

  -- �����⮢�� ᯨ᪠ ⮢���� ����ᮢ (��� ������ ���⪮� �� ���⠬ �࠭����)
  -- ���⠢�� ⥪�騥 ���祭�� STRPLOPRJRNL.GOODSSUPPLY
  UPDATE SPOJ_TMP SET (SUPPLY_AFTER)=
  (
    SELECT DISTINCT E.GOODSSUPPLY
      FROM PARUS.STRPLOPRJRNL E
     WHERE E.RN=SPOJ_TMP.SPOJ_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.STRPLOPRJRNL E
     WHERE E.RN=SPOJ_TMP.SPOJ_RN
  );

  COMMIT;

  -- �믮���� ������ ⮢���� ����ᮢ �� ���⠬ �࠭����
  FOR lcur IN (
               SELECT SUPPLY_BEFORE as GOODSSUPPLY_RN
                 FROM SPOJ_TMP
				UNION
               SELECT SUPPLY_AFTER
                 FROM SPOJ_TMP
				)
  LOOP
    IF lcur.GOODSSUPPLY_RN IS NOT NULL THEN
      snp_repl.recalc_supcellvz(lcur.GOODSSUPPLY_RN);
	END IF;
  END LOOP;

  COMMIT;

  -- �����⮢�� ᯨ᪠ ��楢�� ��⮢ (��� ������)
  -- ���⠢�� ⥪�騥 ���祭�� LIABILITYNOTES.FACEACC
  UPDATE LN_TMP SET (FACEACC_AFTER)=
  (
    SELECT DISTINCT E.FACEACC
      FROM PARUS.LIABILITYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.LIABILITYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  );

  -- ���⠢�� ⥪�騥 ���祭�� PAYNOTES.FACEACC
  UPDATE LN_TMP SET (FACEACC_AFTER)=
  (
    SELECT DISTINCT E.FACEACC
      FROM PARUS.PAYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  )
  WHERE EXISTS
  (
    SELECT NULL
      FROM PARUS.PAYNOTES E
     WHERE E.RN=LN_TMP.LN_RN
  );

  COMMIT;

  -- �믮���� ������ ��楢�� ��⮢
  FOR lcur IN (
               SELECT FACEACC_BEFORE as FACEACC_RN
                 FROM LN_TMP
				UNION
               SELECT FACEACC_AFTER
                 FROM LN_TMP
				)
  LOOP
    IF lcur.FACEACC_RN IS NOT NULL THEN
      PARUS.PR_CORR_FACEACC(lcur.FACEACC_RN);
	END IF;
  END LOOP;

  COMMIT;

  -- ����砥� ॣ������ ᮡ�⨩ ��� ⥪�饩 ��ᨨ
  parus.pkg_updatelist.set_register(null,null);

END;

/* ����� ९����樨: ��ࠡ�⪠ �室��� ����ᮢ */
FUNCTION ExecCallIn(pSessionID NUMBER) RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- �।���������� �� �࠭ᯮ��� 䠩�� 㦥 ����㦥�� � ���� REPL_CALL
  -- ���� ��� ���� �������� �१ DBLink

  -- ��।��塞 ⥪�騩 㧥� (1 ������)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'�訡�� �� �⥭�� ���ଠ樨 � ⥪�饬 㧫�:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- �஢��塞 ����������� ������ (��� �᪫�祭�� ���� �����६����� ९����権)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' 㦥 ����饭�');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ����� �ࠢ� ����᪠�� ९������');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ᬮ��� ����᪠�� ९������: �訡�� �� ������');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;


  -- �����⮢�� � ९����樨
  START_REPL(pSessionId);

  vResult:=fr_REPL_OK;

  -- �������� ������� / ��������� ������
  -- ��ॡ�ࠥ� 㧫�, � ����묨 � ⥪�饣� 㧫�
  -- ���� ��⨢�� �裡 �� �����
  FOR lcur IN (
               SELECT A.RN as SCHEMA_RN, A.SITE_SOURCE_RN, A.SITE_DEST_RN -- ���� ���������
                 FROM REPL_SCHEMA A,REPL_SITE B
                WHERE A.SITE_SOURCE_RN=B.RN
				  AND B.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_DEST_RN=gRepl_init.SITE_RN -- ����騩 㧥�: ����������
				  AND A.IS_ACTIVE=1 -- ���� ��⨢��
  			    ORDER BY B.SORTBY,A.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
    -- ��ࠡ�⪠ �室��� ����ᮢ
    BEGIN
  	  vErr:=Call_In(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN,lcur.SCHEMA_RN);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
  	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
 	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'�訡�� �� ��ࠡ�⪥ �室��� ����ᮢ (REPL_SCHEMA.RN='||TO_CHAR(lcur.SCHEMA_RN)||'):'||SQLERRM);
	END;
  END LOOP;

  -- �����襭�� ९����樨
  FINISH_REPL(pSessionId);

  COMMIT;
  RETURN vResult;
END;

/* ����� ९����樨: ��ନ஢���� ��室��� ����ᮢ */
FUNCTION ExecCallOut(pSessionID NUMBER) RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- ��।��塞 ⥪�騩 㧥� (1 ������)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'�訡�� �� �⥭�� ���ଠ樨 � ⥪�饬 㧫�:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- �஢��塞 ����������� ������ (��� �᪫�祭�� ���� �����६����� ९����権)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' 㦥 ����饭�');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ����� �ࠢ� ����᪠�� ९������');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ᬮ��� ����᪠�� ९������: �訡�� �� ������');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;

  vResult:=fr_REPL_OK;

  -- ��������� �������
  -- ��ॡ�ࠥ� 㧫�, � ����묨 � ⥪�饣� 㧫�
  -- ���� ��⨢�� �裡 �� ������
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN -- ���� ����������
                 FROM REPL_SCHEMA A,REPL_SITE B
                WHERE A.SITE_DEST_RN=B.RN
				  AND B.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_SOURCE_RN=gRepl_init.SITE_RN -- ����騩 㧥�: ��������
				  AND A.IS_ACTIVE=1 -- ���� ��⨢��
  			    ORDER BY B.SORTBY
				)
  LOOP
    -- ��ନ஢���� ��室��� ����ᮢ �� ������ 㧫� - � ����� �࠭���樨
    SET TRANSACTION READ WRITE;
    -- ��ॡ�ࠥ� ��⨢�� �奬� ९����樨
    FOR lcur2 IN (
               SELECT DISTINCT A.SORTBY, A.RN as SCHEMA_RN -- �奬� ९����樨
                 FROM REPL_SCHEMA A
                WHERE A.SITE_DEST_RN=lcur.SITE_DEST_RN -- ���� ����������
				  AND A.SITE_SOURCE_RN=lcur.SITE_SOURCE_RN -- ����騩 㧥�: ��������
				  AND A.IS_ACTIVE=1 -- ���� ��⨢��
  			    ORDER BY A.SORTBY
				)
	LOOP
      SAVEPOINT repl_out; -- �஬����筠� �窠 �⪠�
      BEGIN
  	    vErr:=Call_Out(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN, lcur2.SCHEMA_RN);
	    IF vErr<=fr_REPL_ERROR THEN
	      vResult:=vErr;
	    END IF;
      EXCEPTION
	    WHEN OTHERS THEN
		  ROLLBACK TO repl_out; -- �⪠⨬�� �� �஬������� ���
 	      vResult:=fr_REPL_ERROR;
 		  AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'�訡�� �� �ନ஢���� ��室��� ����ᮢ (REPL_SCHEMA.RN='||TO_CHAR(lcur2.SCHEMA_RN)||'):'||SQLERRM);
      END;
	END LOOP;
	-- �����蠥� �࠭�����
    COMMIT;

	-- ������ ��室��� �⢥⮢
    SET TRANSACTION READ WRITE;
    BEGIN
	  vErr:=Analyze_Call_Out(pSessionId,lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'�訡�� �� ������� ��室��� ����ᮢ:'||SQLERRM);
    END;
    COMMIT;
  END LOOP;

  COMMIT;
  RETURN vResult;
END;

/* ����� ��।�� �१ DBLink */
FUNCTION ExecDBLINK(pSessionID NUMBER, pSITE_DEST_RN NUMBER)  RETURN NUMBER AS
vErr NUMBER;
vResult NUMBER;
BEGIN

  -- �।���������� �� �࠭ᯮ��� 䠩�� 㦥 ����㦥�� � ���� REPL_ANSW � REPL_CALL
  -- ���� �� ���� ��������� �१ DBLink

  -- ��।��塞 ⥪�騩 㧥� (1 ������)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'�訡�� �� �⥭�� ���ଠ樨 � ⥪�饬 㧫�:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;

  -- �஢��塞 ����������� ������ (��� �᪫�祭�� ���� �����६����� ९����権)
  vResult:=Check_Login(pSessionId);
  IF vResult<>fr_REPL_OK THEN
    IF vResult=fr_REPL_ACTIVE THEN
      AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' 㦥 ����饭�');
	ELSE
      IF vResult=fr_REPL_NO_REPL THEN
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ����� �ࠢ� ����᪠�� ९������');
      ELSE
        AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'����� '||USER||' �� ᬮ��� ����᪠�� ९������: �訡�� �� ������');
	  END IF;
	END IF;
	ROLLBACK;
    RETURN vResult;
  END IF;

  vResult:=fr_REPL_OK;

  -- ��।��� �१ DBLINK
  -- ��������� ������
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN, C.REPL_SCHEMANAME,C.DBLINK -- ���� ���������
                 FROM REPL_SCHEMA A,REPL_SITE B, REPL_INIT C
                WHERE A.SITE_SOURCE_RN=B.RN
				  AND B.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_SOURCE_RN=pSITE_DEST_RN -- ���� ���筨�
				  AND A.SITE_DEST_RN=gRepl_init.SITE_RN -- ����騩 㧥�: ����������
				  AND A.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_SOURCE_RN=C.SITE_RN
				  AND C.USE_DBLINK=1
  			    ORDER BY B.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
    BEGIN
      vErr:=SendDBLink(pSessionId,'REPL_ANSW',lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN,lcur.REPL_SCHEMANAME,lcur.DBLINK);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
	EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
  	    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,vResult,'�訡�� �� ��ࠢ�� �१ DBLINK ��室��� �⢥⮢:'||SQLERRM);
    END;
  END LOOP;

  -- ��������� �������
  FOR lcur IN (
               SELECT DISTINCT B.SORTBY, A.SITE_SOURCE_RN, A.SITE_DEST_RN, C.REPL_SCHEMANAME,C.DBLINK -- ���� ����������
                 FROM REPL_SCHEMA A,REPL_SITE B, REPL_INIT C
                WHERE A.SITE_DEST_RN=B.RN
				  AND B.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_SOURCE_RN=gRepl_init.SITE_RN -- ����騩 㧥�: ��������
				  AND A.SITE_DEST_RN=pSITE_DEST_RN -- ����-�����祭��
				  AND A.IS_ACTIVE=1 -- ���� ��⨢��
				  AND A.SITE_DEST_RN=C.SITE_RN
				  AND C.USE_DBLINK=1
  			    ORDER BY B.SORTBY
				)
  LOOP
    SET TRANSACTION READ WRITE;
    BEGIN
      vErr:=SendDBLink(pSessionId,'REPL_CALL',lcur.SITE_SOURCE_RN, lcur.SITE_DEST_RN,lcur.REPL_SCHEMANAME,lcur.DBLINK);
	  IF vErr<=fr_REPL_ERROR THEN
	    vResult:=vErr;
	  END IF;
	  COMMIT;
    EXCEPTION
	  WHEN OTHERS THEN
	    ROLLBACK;
 	    vResult:=fr_REPL_ERROR;
		AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,VResult,'�訡�� �� ��ࠢ�� �१ DBLINK ��室��� ����ᮢ:'||SQLERRM);
	END;
  END LOOP;

  -- �����蠥� �࠭�����
  COMMIT;
  RETURN vResult;
END;

/* �������� ID */
FUNCTION GetFileSeq RETURN NUMBER AS
Res NUMBER;
BEGIN
  SELECT SEQ_FILE_LOCAL.nextval INTO Res FROM DUAL;
  RETURN Res;
END;

/* ��砫� ����㧪� ����஥� ९����樨 */
FUNCTION START_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
BEGIN
  -- �⪫�祭�� �����३��� � �ਣ��஢
  -- REPL_SCHEMA_ROW
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW DISABLE CONSTRAINT REPL_SCHEMAROW_TABLE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW DISABLE CONSTRAINT REPL_SCHEMAROW_TABLE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW DISABLE CONSTRAINT SCHEMA_ROW_REPL_SCHEMA_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA_ROW DISABLE';

  -- REPL_SCHEMA
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA DISABLE CONSTRAINT SCHEMA_REPL_SITE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA DISABLE CONSTRAINT SCHEMA_REPL_SITE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA DISABLE';

  -- REPL_SITE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SITE DISABLE';

  -- REPL_TABLE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_TABLE DISABLE';

  -- ���⪠ ⠡���
  DELETE FROM KLS_REPL_MODE;
  DELETE FROM KLS_EVENTS;
  DELETE FROM KLS_STATUS;
  DELETE FROM REPL_SCHEMA_ROW;
  DELETE FROM REPL_SCHEMA;
  DELETE FROM REPL_SITE;
  DELETE FROM REPL_TABLE;
  DELETE FROM CATALOG_LIST;
  DELETE FROM FCACGR_LIST;
  DELETE FROM STORE_LIST;

  COMMIT;
  RETURN fr_REPL_OK;
EXCEPTION
  WHEN OTHERS THEN
    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_ERROR,'�訡�� �� �����⮢�� � ����㧪� ����஥� ९����樨: '||SQLERRM);
    ROLLBACK;
    RETURN fr_REPL_ERROR;
END;

/* �����襭�� ����㧪� ����஥� ९����樨 */
FUNCTION FINISH_IMPORT_META(pSessionID NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
BEGIN
  -- ����祭�� �����३��� � �ਣ��஢
  -- REPL_SCHEMA_ROW
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW ENABLE CONSTRAINT REPL_SCHEMAROW_TABLE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW ENABLE CONSTRAINT REPL_SCHEMAROW_TABLE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA_ROW ENABLE CONSTRAINT SCHEMA_ROW_REPL_SCHEMA_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA_ROW ENABLE';

  -- REPL_SCHEMA
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA ENABLE CONSTRAINT SCHEMA_REPL_SITE_DEST_FK';
  EXECUTE IMMEDIATE 'ALTER TABLE REPL_SCHEMA ENABLE CONSTRAINT SCHEMA_REPL_SITE_SOURCE_FK';
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SCHEMA ENABLE';

  -- REPL_SITE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_SITE ENABLE';

  -- REPL_TABLE
  EXECUTE IMMEDIATE 'ALTER TRIGGER TRG_BIUDR_REPL_TABLE ENABLE';

  COMMIT;
  RETURN fr_REPL_OK;
EXCEPTION
  WHEN OTHERS THEN
    AddLog(pSessionId,gRepl_init.SITE_RN,NULL,SYSDATE,fr_REPL_ERROR,'�訡�� �� �����襭�� ����㧪� ����஥� ९����樨: '||SQLERRM);
    ROLLBACK;
    RETURN fr_REPL_ERROR;
END;

/* ��砫� ���㧪� ����஥� ९����樨 */
FUNCTION START_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* �����襭�� ���㧪� ����஥� ९����樨 */
FUNCTION FINISH_EXPORT_META(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* ��砫� ���㧪� ������ ९����樨 */
FUNCTION START_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  UPDATE /*+ RULE */ REPl_ANSW SET SENDDATE=SYSDATE, FILENAME=pFILENAME
	 WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* ��砫� ���㧪� ������ ९����樨 */
FUNCTION START_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  UPDATE /*+ RULE */ REPl_CALL_OUT SET STATUS=fr_CALL_SEND, SENDDATE=SYSDATE, FILENAME=pFILENAME
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0)
	 AND EXISTS (
           SELECT NULL FROM REPl_CALL
	        WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0)
			  AND RN=REPL_CALL_OUT.RN
			  );

  UPDATE /*+ RULE */ REPl_CALL SET STATUS=fr_CALL_SEND, SENDDATE=SYSDATE, FILENAME=pFILENAME
	 WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);

  COMMIT;
  RETURN fr_REPL_OK;
END;

/* �����襭�� ���㧪� ������ ९����樨 */
FUNCTION FINISH_EXPORT_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  DELETE FROM /*+ RULE*/ REPL_ANSW
   WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* �����襭�� ���㧪� ������ ९����樨 */
FUNCTION FINISH_EXPORT_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER, pRN NUMBER DEFAULT 0, pFILENAME VARCHAR2 DEFAULT NULL) RETURN NUMBER AS
BEGIN
  DELETE FROM /*+ RULE*/ REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN AND (RN=pRN OR pRN=0);
  COMMIT;
  RETURN fr_REPL_OK;
END;

/* ����稥 ������ ��� ���㧪� */
FUNCTION EXPORT_READY_ANSW(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
  vCnt NUMBER;
BEGIN
  vCnt:=0;
  BEGIN
    SELECT /*+ RULE */ COUNT(*) INTO vCnt
	FROM REPl_ANSW
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN;
  EXCEPTION
    WHEN OTHERS THEN
      vCnt:=0;
  END;
  IF vCnt=0 THEN
    RETURN fr_REPL_ROW_NOTFOUND;
  ELSE
    RETURN fr_REPL_OK;
  END IF;
END;

/* ����稥 ������ ��� ���㧪� */
FUNCTION EXPORT_READY_CALL(pSessionID NUMBER, pSITE_SOURCE_RN NUMBER, pSITE_DEST_RN NUMBER) RETURN NUMBER AS
  vCnt NUMBER;
BEGIN
  vCnt:=0;
  BEGIN
    SELECT /*+ RULE */ COUNT(*) INTO vCnt
    FROM REPL_CALL
    WHERE SITE_SOURCE_RN=pSITE_SOURCE_RN AND SITE_DEST_RN=pSITE_DEST_RN
	  AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
	  vCnt:=0;
  END;
  IF vCnt=0 THEN
    RETURN fr_REPL_ROW_NOTFOUND;
  ELSE
    RETURN fr_REPL_OK;
  END IF;
END;

/* ����稥 ������ ��� �ᯮ������ */
FUNCTION EXECUTE_READY_CALL(pSessionID NUMBER) RETURN NUMBER AS
vCnt NUMBER;
BEGIN
  vCnt:=0;
  -- ��।��塞 ⥪�騩 㧥� (1 ������)
  BEGIN
    SELECT * INTO gRepl_init FROM REPL_INIT WHERE IS_CURRENT=1 AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
 	  AddLog(pSessionId,0,NULL,SYSDATE,fr_REPL_INIT,'�訡�� �� �⥭�� ���ଠ樨 � ⥪�饬 㧫�:'||SQLERRM);
	  ROLLBACK;
	  RETURN fr_REPL_INIT;
  END;
  BEGIN
    SELECT /*+ RULE */ COUNT(*) INTO vCnt
    FROM REPL_CALL
    WHERE SITE_DEST_RN=gRepl_init.SITE_RN
	  AND ROWNUM=1;
  EXCEPTION
    WHEN OTHERS THEN
	  vCnt:=0;
  END;
  IF vCnt=0 THEN
    RETURN fr_REPL_ROW_NOTFOUND;
  ELSE
    RETURN fr_REPL_OK;
  END IF;
END;

END;
/
