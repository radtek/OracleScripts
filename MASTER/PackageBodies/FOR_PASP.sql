--
-- FOR_PASP  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.For_pasp AS

/* ПАСПОРТА */

  -- Ошибка
  PROCEDURE RaiseError (pText VARCHAR2) AS
  BEGIN
    ROLLBACK;
    RAISE_APPLICATION_ERROR(For_Scripts.SG$NO_CORRECT, pText);
  END;


-- Добавить/изменить паспорт
FUNCTION AddPasp (pCOMMIT NUMBER, pID VARCHAR2, pMESTO_ID NUMBER ,pPASP_NUM VARCHAR2, pREZ_NUM VARCHAR2,
                  pPASP_DATE DATE,pINSPEKTOR VARCHAR2, pDATE_OFORML DATE, pPROD_ID_NPR VARCHAR2, pDATE_VIR DATE,
				  pPERER_ID NUMBER) RETURN VARCHAR2 AS
	vID KLS_PASP.ID%TYPE;
	vADD NUMBER(1);
	vTmp NUMBER;
BEGIN
	 vID:=pID;

    -- ID
	IF pID||' '=' ' OR pID IS NULL THEN
	  vADD:=1;
      SELECT SEQ_KLS_PASP.nextval INTO vTmp FROM DUAL;
	  vID:=SUBSTR(TO_CHAR(vTmp),1,9);
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- Проверка существования
	BEGIN
	  SELECT /*+ RULE */ 1
        INTO vTmp
	 	FROM KLS_PASP
	   WHERE ID=vID;
	EXCEPTION
	  WHEN OTHERS THEN
	    IF vAdd=0 THEN
          RaiseError('Паспорт нельзя отредактировать - он удален!');
		END IF;
	END;

	-- Обновляем документ
	UPDATE KLS_PASP SET (PASP_NUM, REZ_NUM, PASP_DATE, INSPEKTOR, DATE_OFORML, PROD_ID_NPR, MESTO_ID,
		   				DATE_VIR, PERER_ID)=
	  (SELECT pPASP_NUM, pREZ_NUM, pPASP_DATE, pINSPEKTOR, pDATE_OFORML, pPROD_ID_NPR, pMESTO_ID,
	  		  pDATE_VIR, pPERER_ID FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем документ
      INSERT INTO KLS_PASP (ID, PASP_NUM, REZ_NUM, PASP_DATE, INSPEKTOR, DATE_OFORML, PROD_ID_NPR, MESTO_ID,
		   				DATE_VIR, PERER_ID, DATEUPLOAD)
	  VALUES (vID, pPASP_NUM, pREZ_NUM, pPASP_DATE, pINSPEKTOR, pDATE_OFORML, pPROD_ID_NPR, pMESTO_ID,
	  		  pDATE_VIR, pPERER_ID,SYSDATE);
	END IF;

	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
	RETURN vID;
END;
 
 /* УДАЛИТЬ ПАСПОРТ С ПОКАЗАТЕЛЯМИ */
PROCEDURE DelTitle(pCOMMIT NUMBER, pID VARCHAR2) AS
BEGIN
    DELETE FROM KLS_PASP WHERE ID=pID;
    DELETE FROM KLS_VALPASP WHERE PASP_ID=pID;
	-- COMMIT
	IF pCOMMIT=1 THEN
	  COMMIT;
	END IF;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
	  NULL;
END;

-- Добавить/обновить основные показатели паспорта
PROCEDURE AddMainPaspValue (pCOMMIT NUMBER,pPASP_ID VARCHAR2, pPL15 NUMBER, pPL20 NUMBER, pP_SER NUMBER,
                            pT_VSP NUMBER, pP_VOD NUMBER, pP_DIRT NUMBER, pMG_SOL NUMBER, pP_SOL NUMBER) AS
BEGIN
  NULL;
END;

PROCEDURE SET_PASP_VALUE (pPASP_ID VARCHAR2, pKODIF_ID NUMBER, pKODIF_TAG VARCHAR2, pQUAL VARCHAR2) AS
BEGIN
	IF (NVL(pKODIF_ID,0)>0) AND NOT(pPASP_ID||' '=' ' OR pPASP_ID IS NULL)  THEN
	  -- Сохраняем значение по ID
	  UPDATE KLS_VALPASP SET QUAL=pQUAL
	  WHERE PASP_ID=pPASP_ID AND KODIF_ID=pKODIF_ID;

	  IF SQL%NOTFOUND THEN
	    INSERT INTO KLS_VALPASP (PASP_ID,KODIF_ID,QUAL)
		VALUES (pPASP_ID,pKODIF_ID,pQUAL);
	  END IF;
	END IF;

  EXCEPTION
    WHEN OTHERS THEN RETURN;
END;

-- Получить значение показателя паспорта
FUNCTION GET_PASP_VALUE_AS_CHAR (pPASP_ID VARCHAR2, pKODIF_ID NUMBER, pKODIF_TAG VARCHAR2) RETURN VARCHAR2 AS
  vRes VARCHAR2(30);
  vIS_PASP_UNP NUMBER(1);
BEGIN
vRes:='';
-- источник паспорта
BEGIN
  SELECT 1 INTO vIS_PASP_UNP 
    FROM UNP_PASPORT 
   WHERE ID_PASPORT=pPASP_ID;
EXCEPTION
  WHEN OTHERS THEN
    vIS_PASP_UNP:=0;
END;	   

IF vIS_PASP_UNP=0 THEN
  IF NVL(pKODIF_ID,0)>0 THEN
    SELECT QUAL INTO vRes
    FROM KLS_VALPASP
    WHERE PASP_ID=pPASP_ID AND KODIF_ID=pKODIF_ID AND ROWNUM=1;
  ELSIF pKODIF_TAG||' '<>' ' THEN
    SELECT QUAL INTO vRes
    FROM KLS_VALPASP p, KLS_KODIF k
    WHERE
  		p.KODIF_ID=k.ID
		AND p.PASP_ID=pPASP_ID
		AND NLS_UPPER(k.FIELD_SVED)=NLS_UPPER(pKODIF_TAG)
		AND ROWNUM=1;
  END IF;
ELSE
  IF NVL(pKODIF_ID,0)>0 THEN
    SELECT QUAL INTO vRes
    FROM V_VALPASP_UNP
    WHERE PASP_ID=pPASP_ID AND KODIF_ID=pKODIF_ID AND ROWNUM=1;
  ELSIF pKODIF_TAG||' '<>' ' THEN
    SELECT QUAL INTO vRes
    FROM V_VALPASP_UNP p
    WHERE p.PASP_ID=pPASP_ID
  	  AND NLS_UPPER(p.FIELD_SVED)=NLS_UPPER(pKODIF_TAG)
	  AND ROWNUM=1;
  END IF;
END IF;  
RETURN vRes;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;

FUNCTION GET_PASP_VALUE_AS_NUM (pPASP_ID VARCHAR2, pKODIF_ID NUMBER, pKODIF_TAG VARCHAR2) RETURN NUMBER AS
BEGIN
  RETURN ora_char_to_num(GET_PASP_VALUE_AS_CHAR(pPASP_ID,pKODIF_ID, pKODIF_TAG));
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;

/* Поиск паспорта */
-- Поиск паспорта
FUNCTION GET_PASP_ID RETURN NUMBER AS
BEGIN

/**************************************************************
* Поиск паспорта на н/п
*************************************************************
FUNCTION loca_pasp
PARAMETERS m.num_pasp,m.num_rez,m.dins,m.mesto,m.tip_otgr,m.pasp_tbl
PRIVATE m.kodpasp,stor_sele,refr_prod,new_npr,cnt1,old_filter
  stor_sele=SELECT()
  IF EMPTY(m.pasp_tbl)
    m.pasp_tbl='ZAGPASP'
  ENDIF
  IF UPPER(m.pasp_tbl)='ZAGPASP'
    m.pasp_tbl='ZAGPASP'
  ELSE
    m.pasp_tbl='REZPASP'
  ENDIF

  DECLARE ar_np(1)
  DO CASE
    CASE EMPTY(m.num_pasp) OR EMPTY(m.num_rez) OR EMPTY(m.dins)
      m.kodpasp='нет пасп.'
    OTHERWISE
      IF SEEK(m.kod_npr,'PROD')
        m.kod_gr=prod.kod_gr

        SELECT kod FROM prod WHERE kod_gr=m.kod_gr INTO ARRAY ar_np
        IF EMPTY(ar_np)
          =mes_dial(7,'Внимание',"У н/продукта не определена группа. \rСообщите программистам")
          m.kodpasp='нет пасп.'
          SELECT (stor_sele)
          RETURN m.kodpasp
        ENDIF
      ENDIF

      SELECT &pasp_tbl

      CALC CNT() FOR mesto=m._g_mesto ;
                 AND ALLT(num_pasp)=ALLT(m.num_pasp) ;
                 AND ALLT(num_rez)=ALLT(m.num_rez) ;
                 AND dins=m.dins ;
                 AND mesto=m.mesto ;
                 AND tip_otgr=m.tip_otgr TO m.cnt1
      DO CASE
        CASE m.cnt1>=1
          IF m.cnt1=1
            LOCATE FOR mesto=m._g_mesto ;
                   AND ALLT(num_pasp)=ALLT(m.num_pasp) ;
                   AND ALLT(num_rez)=ALLT(m.num_rez) ;
                   AND dins=m.dins ;
                   AND mesto=m.mesto ;
                   AND tip_otgr=m.tip_otgr
          ELSE
            old_filter=FILTER(m.pasp_tbl)
            SET FILTER TO mesto=m._g_mesto ;
                      AND ALLT(num_pasp)=ALLT(m.num_pasp) ;
                      AND ALLT(num_rez)=ALLT(m.num_rez) ;
                      AND dins=m.dins ;
                      AND mesto=m.mesto ;
                      AND tip_otgr=m.tip_otgr
            DO Get_Pasp.spr WITH m.pasp_tbl,''
            m.new_npr=&pasp_tbl..kod_npr
            SET FILTER TO &old_filter
            LOCATE FOR mesto=m._g_mesto ;
                   AND ALLT(num_pasp)=ALLT(m.num_pasp) ;
                   AND ALLT(num_rez)=ALLT(m.num_rez) ;
                   AND dins=m.dins ;
                   AND mesto=m.mesto ;
                   AND kod_npr=m.new_npr ;
                   AND tip_otgr=m.tip_otgr
          ENDIF
          m.new_npr=&pasp_tbl..kod_npr
          IF FOUND()
            m.kodpasp=&pasp_tbl..kodpasp
            IF ASCAN(ar_np,m.new_npr)>0 OR EMPTY(ar_np)
              IF NOT EMPTY(m.kod_npr)
                IF m.kod_npr<>m.new_npr
                  WAIT CLEAR
                  WAIT 'Марки нефтепродуктов в заявке и паспорте'+CHR(13)+;
                     'не совпадают !' WINDOW NOWAIT
                  refr_prod=.T.
                  m.kod_npr=m.new_npr
                ELSE
                  refr_prod=.F.
                ENDIF
              ELSE
                refr_prod=.T.
                m.kod_npr=m.new_npr
              ENDIF
              IF SEEK(m.kod_npr,'PROD')
                m.prod = prod.naim_pr
              ELSE
                m.prod = [Не определен !]
              ENDIF
              IF refr_prod
                SHOW GETS
              ENDIF
            ELSE
              m.kodpasp='нет пасп.'
              WAIT CLEAR
              WAIT 'Марки нефтепродуктов в заявке и паспорте'+CHR(13)+;
                 'принадлежат к разным группам !' WINDOW NOWAIT
            ENDIF
          ELSE
            m.kodpasp='нет пасп.'
            WAIT CLEAR
            WAIT 'Нет такого паспорта !' WINDOW NOWAIT
          ENDIF
        CASE m.cnt1<1
          m.kodpasp='нет пасп.'
          WAIT CLEAR
          WAIT 'Нет такого паспорта !' WINDOW NOWAIT
      ENDCASE
  ENDCASE
  SELECT (stor_sele)
RETURN m.kodpasp

*/
  RETURN NULL;
END;

-- Получить ID показателя паспорта по ТЕГУ
FUNCTION GET_KODIF_ID_BY_TAG (pPROD_ID_NPR VARCHAR2, pTAG VARCHAR2) RETURN NUMBER AS
BEGIN
/*  && ===========================================================
&& ID показателя типа m.tip_pok из паспорта для н/п m.kod_npr
&& ===========================================================
FUNCTION GetPokId
PARAMETERS m.kod_npr,m.tip_pok
PRIVATE m.res,stor_sele
  m.tip_pok=LOWER(ALLT(m.tip_pok))
  m.res=0
  IF m.tip_pok='u_ves'
    stor_sele=SELECT()
    SELECT prod
    LOCATE FOR kod=m.kod_npr
    IF FOUND()
      m.res=prod.u_ves_id
      IF EMPTY(m.res)
        m.res=1
      ENDIF
    ELSE
      m.res=1
    ENDIF
    SELECT (stor_sele)
  ELSE
    SELECT a.kodif_id, B.FIELD_SVED ;
      FROM (m._g_pathdbf+'ntablpok') a,(m._g_pathdbf+'nkodifik') b ;
      WHERE a.kodif_id=b.id ;
        AND a.kod_npr=m.kod_npr ;
        AND M.TIP_POK==LOWER(ALLT(b.field_sved)) ;
      ORDER BY a.sortby ;
      INTO CURSOR cur_tmp
    SELECT cur_tmp
    GO TOP
    m.res=cur_tmp.kodif_id
    IF EMPTY(m.res)
      m.res=0
    ENDIF
    USE IN cur_tmp
  ENDIF
RETURN m.res
*/
  RETURN NULL;
END;

-- Получить значение показателя паспорта по тэгу
FUNCTION GET_PASP_VALUE_BY_TAG (pPASP_ID VARCHAR2, pKODIF_TAG VARCHAR2) RETURN VARCHAR2 AS
  vRes VARCHAR2(50);
  vIS_PASP_UNP NUMBER(1);
BEGIN
  -- источник паспорта
  BEGIN
    SELECT 1 INTO vIS_PASP_UNP 
      FROM UNP_PASPORT 
     WHERE ID_PASPORT=pPASP_ID;
  EXCEPTION
    WHEN OTHERS THEN
      vIS_PASP_UNP:=0;
  END;	   

  IF vIS_PASP_UNP=0 THEN
    SELECT QUAL INTO vRes
    FROM KLS_VALPASP p, KLS_KODIF k
    WHERE
  		p.KODIF_ID=k.ID
		AND p.PASP_ID=pPASP_ID
		AND NLS_UPPER(k.FIELD_SVED)=NLS_UPPER(pKODIF_TAG)
		AND ROWNUM=1;
  ELSE
    SELECT QUAL INTO vRes
    FROM V_VALPASP_UNP p
    WHERE p.PASP_ID=pPASP_ID
		AND NLS_UPPER(p.FIELD_SVED)=NLS_UPPER(pKODIF_TAG)
		AND ROWNUM=1;
  END IF;		
  RETURN vRes;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;

-- Получить значение показателя паспорта по коду R3
FUNCTION GET_PASP_VALUE_BY_R3 (pPASP_ID VARCHAR2, pID_R3 VARCHAR2) RETURN VARCHAR2 AS
  vRes VARCHAR2(50);
  vIS_PASP_UNP NUMBER(1);
BEGIN
  -- источник паспорта
  BEGIN
    SELECT 1 INTO vIS_PASP_UNP 
      FROM UNP_PASPORT 
     WHERE ID_PASPORT=pPASP_ID;
  EXCEPTION
    WHEN OTHERS THEN
      vIS_PASP_UNP:=0;
  END;	   

--  IF vIS_PASP_UNP=0 THEN
    SELECT QUAL INTO vRes
    FROM KLS_VALPASP p, KLS_KODIF k
    WHERE
  		p.KODIF_ID=k.ID
		AND p.PASP_ID=pPASP_ID
		AND NLS_UPPER(k.ID_R3)=NLS_UPPER(pID_R3)
		AND ROWNUM=1;
/*  ELSE
    SELECT QUAL INTO vRes
    FROM V_VALPASP_UNP p
    WHERE p.PASP_ID=pPASP_ID
		AND NLS_UPPER(p.ID_R3)=NLS_UPPER(pID_R3)
		AND ROWNUM=1;
  END IF;*/		
  RETURN vRes;
EXCEPTION
  WHEN OTHERS THEN
    RETURN NULL;
END;


END;

/

