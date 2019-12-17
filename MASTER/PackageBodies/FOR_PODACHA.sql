--
-- FOR_PODACHA  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_PODACHA AS

  /* ��������� ������ */

  -- ������
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;


  -- ������������ ����� ������� ���������
  FUNCTION GetMaxNumPos(pVED_ID NUMBER) RETURN NUMBER AS
    MaxNum NUMBER;
    CurNum NUMBER;
  BEGIN
    CurNum:=0;
    FOR lcur IN (SELECT MAX(VED_POD_ROW.POD_POS) as MAX_NUM
                 FROM VED_POD_ROW
				WHERE VED_POD_ID=pVED_ID)
    LOOP
      CurNum:=NVL(lcur.MAX_NUM,0);
	  EXIT;
    END LOOP;
	MaxNum:=CurNum+1;
    RETURN MaxNum;
  END;

  /* ������� ������� ��������� */
  PROCEDURE DelRow(pCOMMIT NUMBER, pID NUMBER) AS
    vCNT NUMBER;
  BEGIN
    -- ��������� ������� ������� �������� 
	SELECT COUNT(*) INTO vCNT FROM REESTR WHERE VED_POD_ROW_ID=pID;
	IF vCNT>0 THEN
      RaiseError('������� ��������� ������ ������ ������� - ���� ������� ��������!');
	END IF;

    DELETE FROM VED_POD_ROW WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* ������� ��������� ��������� */
  PROCEDURE DelTitle(pCOMMIT NUMBER, pID NUMBER) AS
    vCNT NUMBER;
  BEGIN
    -- ��������� ������� �������
	SELECT COUNT(*) INTO vCNT FROM VED_POD_ROW WHERE VED_POD_ID=pID;
	IF vCNT>0 THEN
      RaiseError('��������� ������ ������ ������� - ���� �������!');
	END IF;

    DELETE FROM VED_POD WHERE ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
  END;

  /* ��������/�������� ��������� ��������� */
  FUNCTION AddTitle(pCOMMIT NUMBER, pID NUMBER, pMESTO_ID NUMBER, pLOAD_TYPE_ID NUMBER,
  	 pPOD_NUM NUMBER, pPOD_DATE DATE, pTECH_TIME VARCHAR2, pGOTOV_TIME VARCHAR2, pBEG_NALIV_TIME VARCHAR2, pEND_NALIV_TIME VARCHAR2,
     pVETKA_OTP_ID NUMBER) RETURN NUMBER AS

	vID NUMBER;
	vADD NUMBER;
	vTmp NUMBER;
	vTECH_TIME DATE;
	vGOTOV_TIME DATE;
	vBEG_NALIV_TIME DATE;
	vEND_NALIV_TIME DATE;
  BEGIN
    IF pTECH_TIME='' THEN
	  vTECH_TIME:=NULL;
	ELSE
	  vTECH_TIME:=TO_DATE(pTECH_TIME,'dd.mm.yyyy hh24:mi');
	END IF;  
    IF pGOTOV_TIME='' THEN
	  vGOTOV_TIME:=NULL;
	ELSE
	  vGOTOV_TIME:=TO_DATE(pGOTOV_TIME,'dd.mm.yyyy hh24:mi');
	END IF; 
    IF pBEG_NALIV_TIME='' THEN
	  vBEG_NALIV_TIME:=NULL;
	ELSE
	  vBEG_NALIV_TIME:=TO_DATE(pBEG_NALIV_TIME,'dd.mm.yyyy hh24:mi');
	END IF; 
    IF pEND_NALIV_TIME='' THEN
	  vEND_NALIV_TIME:=NULL;
	ELSE
	  vEND_NALIV_TIME:=TO_DATE(pEND_NALIV_TIME,'dd.mm.yyyy hh24:mi');
	END IF; 

    -- ID
	IF NVL(pID,0)<=0 THEN
	  vADD:=1;
      SELECT SEQ_ID.NEXTVAL INTO vID FROM DUAL;
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- �������� �������������
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM VED_POD
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('��������� ������ ������ ��������������� - ��� �������!');
		END IF;
	END;

	-- ��������� ���������
	UPDATE VED_POD SET (MESTO_ID, LOAD_TYPE_ID, VETKA_OTP_ID, POD_NUM, POD_DATE, TECH_TIME, GOTOV_TIME, BEG_NALIV_TIME, END_NALIV_TIME)=
	  (SELECT pMESTO_ID, pLOAD_TYPE_ID, pVETKA_OTP_ID, pPOD_NUM, pPOD_DATE, pTECH_TIME, pGOTOV_TIME, pBEG_NALIV_TIME, pEND_NALIV_TIME FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- ��������� ���������
      INSERT INTO VED_POD (ID,MESTO_ID, LOAD_TYPE_ID, VETKA_OTP_ID, POD_NUM, POD_DATE, TECH_TIME, GOTOV_TIME, BEG_NALIV_TIME, END_NALIV_TIME)
	  VALUES (vID, pMESTO_ID, pLOAD_TYPE_ID, pVETKA_OTP_ID, pPOD_NUM, pPOD_DATE, pTECH_TIME, pGOTOV_TIME, pBEG_NALIV_TIME, pEND_NALIV_TIME);
	END IF;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;

  /* ����������� ������� �� ��������� � ��������
     ������������ �������� - ID ������� ��������� ��� NULL - ���� ������ �� ������� */
  FUNCTION MoveRow (pCOMMIT NUMBER, pROW_ID NUMBER, pNEW_TITLE_ID NUMBER) RETURN NUMBER AS
	vTitle VED_POD%ROWTYPE;
	vRow VED_POD_ROW%ROWTYPE;
	vTmp NUMBER;
  BEGIN
    vRow.ID:=NULL;

	-- ��������� ������ �� ���������
	BEGIN
	  SELECT * INTO vRow
	    FROM VED_POD_ROW
	   WHERE ID=pROW_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vRow.ID:=NULL;
	END;

	IF vRow.ID IS NULL THEN
	  -- ��������� ������, ����� ������ � ��������� ���
	  RETURN NULL;
	END IF;

	-- �������� ������������� ���������-����������
	BEGIN
	  SELECT * INTO vTitle
	    FROM VED_POD
	   WHERE ID=pNEW_TITLE_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('��������� ������ � ������� ����������� ����� - �������!');
	END;

    -- ��������� ����� �� ��������� � ���������
	UPDATE VED_POD_ROW SET VED_POD_ID=pNEW_TITLE_ID WHERE ID=vRow.ID;
	-- ��������� ���� �������� � "���������" ������� ��������
	UPDATE REESTR SET VETKA_OTP_ID=vTitle.VETKA_OTP_ID WHERE VED_POD_ROW_ID=vRow.ID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vRow.ID;
  END;

  /* �������� ������ �� ������������
     ������������ �������� - ����� ���������, � ������� ������ ����� ��� ���� */
  FUNCTION CHECK_UNIQ (pLOAD_TYPE_ID NUMBER, pNUM_CIST VARCHAR2, pID NUMBER, pDATE DATE) RETURN NUMBER AS
  PRAGMA AUTONOMOUS_TRANSACTION;
    vRes NUMBER;
	vWorklen NUMBER;
  BEGIN
    IF pLOAD_TYPE_ID=1 THEN
	  vWorklen:=FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','WORKLEN#1',FOR_INIT.GetCurrUser);
	ELSE
	  vWorklen:=FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','WORKLEN#2',FOR_INIT.GetCurrUser);
	END IF;
    SELECT a.POD_NUM INTO vRes
	  FROM VED_POD_ROW b,VED_POD a
	 WHERE b.VED_POD_ID=a.ID
	   AND a.POD_DATE>=pDATE-2
	   AND b.NUM_CIST=pNUM_CIST
	   AND b.VAG_STATUS_ID IN (0,14)
	   AND b.ID<>pID
	   AND (TRUNC(a.POD_DATE)=TRUNC(pDATE) OR
	        ABS(hours_between(a.POD_DATE,pDATE))<vWorklen);
    ROLLBACK;
    RETURN vRes;
  EXCEPTION
    WHEN OTHERS THEN
	  ROLLBACK;
	  RETURN NULL;
  END;


  /* ��������/�������� ������� ���������
     ������������ �������� - ID ������� ��������� */
  FUNCTION AddRow(pCOMMIT NUMBER, pID NUMBER, pVED_POD_ID NUMBER, pPOD_POS NUMBER,
    pNUM_CIST VARCHAR2, pNCISTDOP NUMBER, pAXES NUMBER, pCAPACITY VARCHAR2, pVES_CIST NUMBER,
	pVAGONTYPE_ID NUMBER, pKALIBR_ID VARCHAR2, pVAGOWNER_ID NUMBER,
	pVETKA_POD_ID NUMBER, pVETKA_NAPR_ID NUMBER, pVAG_STATUS_ID NUMBER,
	pPROD_ID_NPR VARCHAR2, pVZLIV NUMBER, pVOLUME NUMBER, pTEMPER NUMBER, 
	pZPU_TYPE1 NUMBER, pZPU_TYPE2 NUMBER, pPLOMBA1 VARCHAR2, pPLOMBA2 VARCHAR2, pROSINSPL1 VARCHAR2,
	pROSINSPL2 VARCHAR2, pBAD_NUM NUMBER, pRAZMET_FACT VARCHAR2) RETURN VARCHAR2 AS

	vID VED_POD_ROW.ID%TYPE;
	vADD NUMBER(1);
	vTmp NUMBER;
	vLoadType VED_POD.LOAD_TYPE_ID%TYPE;
  BEGIN

    -- ID
	IF NVL(pID,0)=0 THEN
	  vADD:=1;
      SELECT SEQ_ID.nextval INTO vTmp FROM DUAL;
	  vID:=vTmp;
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- �������� ������������� ���������
	BEGIN
	  SELECT /*+ RULE */ LOAD_TYPE_ID
        INTO vLoadType
	 	FROM VED_POD
	   WHERE ID=pVED_POD_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('��������� ������ �������!');
	END;

	-- �������� ������������� �������
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM VED_POD_ROW
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('������� ������ ��������������� - ��� �������!');
		END IF;
	END;

	-- ��������� �������
	UPDATE VED_POD_ROW SET (POD_POS,NUM_CIST,NCISTDOP,AXES,CAPACITY,VES_CIST,
	  VAGONTYPE_ID,KALIBR_ID,VAGOWNER_ID,VETKA_POD_ID,VETKA_NAPR_ID,VAG_STATUS_ID,PROD_ID_NPR,
	  VZLIV,VOLUME,TEMPER,ZPU_TYPE1,ZPU_TYPE2,PLOMBA1,PLOMBA2,ROSINSPL1,
	  ROSINSPL2,BAD_NUM,RAZMET_FACT)=
    (SELECT pPOD_POS,pNUM_CIST,pNCISTDOP,pAXES,pCAPACITY,pVES_CIST,
	  pVAGONTYPE_ID,pKALIBR_ID,pVAGOWNER_ID,pVETKA_POD_ID,pVETKA_NAPR_ID,pVAG_STATUS_ID,pPROD_ID_NPR,
	  pVZLIV,pVOLUME,pTEMPER,pZPU_TYPE1,pZPU_TYPE2,pPLOMBA1,pPLOMBA2,pROSINSPL1,
	  pROSINSPL2,pBAD_NUM,pRAZMET_FACT FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- ��������� �������
      INSERT INTO VED_POD_ROW (ID,VED_POD_ID,POD_POS,NUM_CIST,NCISTDOP,AXES,CAPACITY,VES_CIST,
	  VAGONTYPE_ID,KALIBR_ID,VAGOWNER_ID,VETKA_POD_ID,VETKA_NAPR_ID,VAG_STATUS_ID,PROD_ID_NPR,
	  VZLIV,VOLUME,TEMPER,ZPU_TYPE1,ZPU_TYPE2,PLOMBA1,PLOMBA2,ROSINSPL1,
	  ROSINSPL2,BAD_NUM,RAZMET_FACT)
	  VALUES (vID,pVED_POD_ID,pPOD_POS,pNUM_CIST,pNCISTDOP,pAXES,pCAPACITY,pVES_CIST,
	  pVAGONTYPE_ID,pKALIBR_ID,pVAGOWNER_ID,pVETKA_POD_ID,pVETKA_NAPR_ID,pVAG_STATUS_ID,pPROD_ID_NPR,
	  pVZLIV,pVOLUME,pTEMPER,pZPU_TYPE1,pZPU_TYPE2,pPLOMBA1,pPLOMBA2,pROSINSPL1,
	  pROSINSPL2,pBAD_NUM,pRAZMET_FACT);
	END IF;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;
  
  /* ����������� ������� ��������� ������� � ��������� ������
     ������������ �������� - ID ������� ��������� */
  FUNCTION CopyVedOsmotrRow (pCOMMIT NUMBER, pVED_OSMOTR_ROW_ID NUMBER, pVED_POD_ID NUMBER) RETURN NUMBER AS
    vID VED_POD_ROW.ID%TYPE;
	vTitle VED_OSMOTR%ROWTYPE;
	vRow VED_OSMOTR_ROW%ROWTYPE;
	vTmp NUMBER;
  BEGIN
    vID:=NULL;

    -- ��������� ������� ������ � ��������� ������
	BEGIN
	  SELECT ID INTO vID
	    FROM VED_POD_ROW
	   WHERE VED_OSMOTR_ROW_ID=pVED_OSMOTR_ROW_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vID:=NULL;
	END;

	IF vID IS NOT NULL THEN
	  -- ����� � ��������� ������ ��� ����, ������ ��������� �� ����
	  RETURN vID;
	END IF;

	-- ��������� ������ �� ��������� �������
	BEGIN
	  SELECT * INTO vRow
	    FROM VED_OSMOTR_ROW
	   WHERE ID=pVED_OSMOTR_ROW_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    vRow.ID:=NULL;
	END;
	BEGIN
	  SELECT * INTO vTitle
	    FROM VED_OSMOTR
	   WHERE ID=vRow.VED_ID;
	EXCEPTION
	  WHEN OTHERS THEN
	    NULL;
	END;

	IF vRow.ID IS NULL OR vTitle.ID IS NULL THEN
	  -- ��������� ������, ����� ������ � �������� ������� ���
	  RETURN NULL;
	END IF;

	-- �������� ������������� ���������
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM VED_POD
	   WHERE ID=pVED_POD_ID;
	EXCEPTION
	  WHEN OTHERS THEN
        RaiseError('��������� ������ �������!');
	END;

    -- ��������� �����

	IF vRow.VAGONTYPE_ID IS NULL THEN
	  vRow.VAGONTYPE_ID:=FOR_CIST.GET_VAGONTYPE(vRow.NUM_CIST,vTitle.LOAD_TYPE_ID);
    END IF;
	IF vRow.KALIBR_ID IS NULL THEN
	  vRow.KALIBR_ID:=FOR_CIST.GET_KALIBR(vRow.NUM_CIST,vTitle.LOAD_TYPE_ID,vRow.VAGONTYPE_ID);
    END IF;
	IF vRow.NCISTDOP IS NULL THEN
	  vRow.NCISTDOP:=FOR_CIST.GET_NCISTDOP(vRow.NUM_CIST,vTitle.LOAD_TYPE_ID,vRow.VAGONTYPE_ID);
    END IF;
	IF vRow.VES_CIST IS NULL THEN
	  vRow.VES_CIST:=FOR_CIST.GET_VES_CIST(vRow.NUM_CIST,vTitle.LOAD_TYPE_ID,vRow.VAGONTYPE_ID);
    END IF;
	IF vRow.VAGOWNER_ID IS NULL THEN
	  vRow.VAGOWNER_ID:=FOR_CIST.GET_VAGOWNER(vRow.NUM_CIST,vTitle.LOAD_TYPE_ID,vRow.VAGONTYPE_ID);
    END IF;
	IF vRow.CAPACITY IS NULL THEN
	  vRow.CAPACITY:=FOR_CIST.GET_CAPACITY(vRow.NUM_CIST,vRow.KALIBR_ID,vTitle.LOAD_TYPE_ID,vRow.VAGONTYPE_ID);
    END IF;
	IF vRow.AXES IS NULL THEN
	  vRow.AXES:=FOR_CIST.GET_AXES(vRow.NUM_CIST,vRow.KALIBR_ID,0,vTitle.LOAD_TYPE_ID,vRow.VAGONTYPE_ID);
    END IF;

	vID:=AddRow(0,vID,pVED_POD_ID,FOR_PODACHA.GetMaxNumPos(pVED_POD_ID),
	    vRow.NUM_CIST,vRow.NCISTDOP,vRow.AXES,vRow.CAPACITY,vRow.VES_CIST,vRow.VAGONTYPE_ID,vRow.KALIBR_ID,
		vRow.VAGOWNER_ID,100,100,0,
		vRow.PROD_ID_NPR,NULL,0,NULL,
		FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','ZPU_TYPE1',FOR_INIT.GetCurrUser),
		FOR_ENVIRONMENT.GET_ENV('MASTER','VARI','ZPU_TYPE2',FOR_INIT.GetCurrUser),
		NULL,NULL,NULL,NULL,0,vRow.RAZMET_PER);

    -- ����������� ������ �� ������� ��������� ������
	UPDATE VED_POD_ROW SET VED_OSMOTR_ROW_ID=pVED_OSMOTR_ROW_ID WHERE ID=vID;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
  END;
  
END;

/

