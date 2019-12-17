--
-- FOR_REESTR  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.For_Reestr
AS

-- Заполнить параметры реестра
   PROCEDURE fill_reestr_param (
      date_plan#   VARCHAR2,
      date_ree#    VARCHAR2
   ) AS
   BEGIN
      DELETE FROM TEMP_REESTR_PARAMS
            WHERE terminal_name = For_Init.getcurrterm
              AND osuser_name = For_Init.getcurruser;

      INSERT INTO TEMP_REESTR_PARAMS
                  (date_plan,
                   datetime_report
                  )
           VALUES (TO_DATE (date_plan#, 'dd.mm.yyyy'),
                   TO_DATE (SUBSTR(date_ree#,1,16),'dd.mm.yyyy hh24:mi')
                  );

      COMMIT;
   END;


/* ДОБАВИТЬ/ИЗМЕНИТЬ РЕЕСТР */
FUNCTION AddReestr(pID NUMBER, pNUM_REE NUMBER, pDATE_REE DATE,
   pDATE_TO DATE, pDATE_PLAN DATE, pUSE_GRAFIK NUMBER,
   pGRAFIK_DATE_FROM DATE, pGRAFIK_DATE_TO DATE, pSTATUS NUMBER,
   pDOP_REE NUMBER) RETURN NUMBER AS

	vID NUMBER;
	vADD NUMBER;
  BEGIN
    -- ID
	IF NVL(pID,0)<=0 THEN
	  vADD:=1;
      SELECT SEQ_ID.NEXTVAL INTO vID FROM DUAL;
	ELSE
	  vADD:=0;
	  vID:=pID;
	END IF;

	-- Обновляем
	UPDATE MONTH_REESTR SET (NUM_REE, DATE_REE, DATE_TO, DATE_PLAN,
	  USE_GRAFIK, GRAFIK_DATE_FROM, GRAFIK_DATE_TO, STATUS, DOP_REE)=
	  (SELECT pNUM_REE, pDATE_REE, pDATE_TO, pDATE_PLAN,
	  pUSE_GRAFIK, pGRAFIK_DATE_FROM, pGRAFIK_DATE_TO, pSTATUS, pDOP_REE FROM dual)
	 WHERE ID=vID;

	IF SQL%NOTFOUND THEN
	  -- Добавляем заказ
      INSERT INTO MONTH_REESTR (ID, NUM_REE, DATE_REE, DATE_TO, DATE_PLAN,
	  USE_GRAFIK, GRAFIK_DATE_FROM, GRAFIK_DATE_TO, STATUS, DOP_REE)
	  VALUES (vID, pNUM_REE, pDATE_REE, pDATE_TO, pDATE_PLAN,
	  pUSE_GRAFIK, pGRAFIK_DATE_FROM, pGRAFIK_DATE_TO, pSTATUS, pDOP_REE);
	END IF;
	RETURN vID;
  END;

/* График в виде строки */
FUNCTION GrafikToStr(pNOM_ZD VARCHAR2, pGRAFIK_TO DATE) RETURN VARCHAR2 AS
    vGRAFIK VARCHAR2(2000);
	vPART VARCHAR2(2000);
	vPREV_DAY NUMBER(2);
	vPREV_MON NUMBER(2);
	vCUR_DAY NUMBER(2);
	vCUR_MON NUMBER(2);
	vLAST_DAY NUMBER(2);
	vLAST_MON NUMBER(2);
	vCUR_VAG NUMBER(5);
	vPREV_VAG NUMBER(5);
	vREPEAT NUMBER(1);
BEGIN
  vLAST_DAY:=0;
  vPREV_DAY:=0;
  vPREV_MON:=0;
  vPREV_VAG:=0;
  vGRAFIK:='';
  FOR lcur IN (SELECT gu12_br.DATE_R as DATE_LOAD, SUM(gu12_br.KOL_VAG) as KOL_VAG 
                   FROM gu12_a,gu12_b,gu12_br,month
                  WHERE month.nom_zd=pNOM_ZD
                    AND month.GU12_A_ID=gu12_a.id
                    AND gu12_a.id=gu12_b.id_a
                    AND gu12_b.STAN_ID=month.STAN_ID
                    AND gu12_b.id=gu12_br.id_b
                    AND gu12_br.date_r<=pGRAFIK_TO
			  	    AND gu12_b.ISCOR<>2
                  GROUP BY gu12_br.DATE_R
				  HAVING SUM(gu12_br.KOL_VAG)>0
                  ORDER BY gu12_br.DATE_R)
  LOOP
	vCUR_DAY:=TO_NUMBER(TO_CHAR(lcur.DATE_LOAD,'DD'));
	vCUR_MON:=TO_NUMBER(TO_CHAR(lcur.DATE_LOAD,'MM'));
	vCUR_VAG:=lcur.KOL_VAG;
	  
	IF vPREV_DAY>0 THEN
      -- Уже были
      IF vCUR_MON<>vPREV_MON OR vCUR_VAG<>vPREV_VAG THEN
         -- Изменился месяц или кол-во вагонов
		IF vREPEAT=1 THEN
		  vPART:='по '||vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
		ELSE   
		  vPART:=vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
		END IF;
		IF vGRAFIK||' '<>' ' THEN  
 		  vGRAFIK:=vGRAFIK||'; '||vPART;
		ELSE  
 		  vGRAFIK:=vPART;
		END IF;  
		vREPEAT:=0;
		vPART:=TRIM(TO_CHAR(vCUR_VAG))||'ц - '||TRIM(TO_CHAR(vCUR_DAY,'00'));
 	  ELSE
		vPART:=vPART||','||TRIM(TO_CHAR(vCUR_DAY,'00'));
		vREPEAT:=1;
	  END IF;
	ELSE
	  -- В первый раз
	  vPART:=TRIM(TO_CHAR(vCUR_VAG))||'ц - '||TRIM(TO_CHAR(vCUR_DAY,'00'));
	  vREPEAT:=0;
	END IF;
	vPREV_DAY:=vCUR_DAY;
	vPREV_MON:=vCUR_MON;
	vPREV_VAG:=vCUR_VAG;
  END LOOP;
  IF vPREV_DAY>0 THEN
    IF vREPEAT=1 THEN
	  vPART:='по '||vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
    ELSE   
	  vPART:=vPART||'/'||TRIM(TO_CHAR(vPREV_MON,'00'));
	END IF;
	IF vGRAFIK||' '<>' ' THEN  
 	  vGRAFIK:=vGRAFIK||'; '||vPART;
	ELSE  
 	  vGRAFIK:=vPART;
	END IF;  
  END IF;

  RETURN vGRAFIK;	
END;


/* График в виде строки */
FUNCTION GetLoadAbbr(pNOM_ZD VARCHAR2) RETURN VARCHAR2 AS
    vRES VARCHAR2(30);
	vZPT VARCHAR2(10);
BEGIN
  vRES:='';
  vZPT:='';
  FOR lcur IN (SELECT DISTINCT
			        CASE 
                      WHEN gu12_b.PRINVAG_ID=207 THEN 'МПС'
				      WHEN NVL(C.ID,0)<>0 AND c.LOAD_ABBR||' ' <> ' ' THEN c.LOAD_ABBR
				      ELSE 'СОБ'
	  			    END as LOAD_ABBR   
                   FROM month,gu12_a,gu12_b,kls_gd_sobstvvag c
                  WHERE month.nom_zd=pNOM_ZD
                    AND month.GU12_A_ID=gu12_a.id
                    AND gu12_a.id=gu12_b.id_a
                    AND month.STAN_ID=gu12_b.STAN_ID
					AND month.LOAD_ABBR not in ('САМ','КНТ')
			  	    AND gu12_b.ISCOR<>2
					AND gu12_b.SOBSTVVAG_ID=C.ID(+)
				  UNION
                  SELECT DISTINCT LOAD_ABBR
                   FROM month
                  WHERE month.nom_zd=pNOM_ZD
                    AND month.LOAD_ABBR in ('САМ','КНТ'))
  LOOP
	vRES:=vRES||vZPT||lcur.LOAD_ABBR;
	vZPT:=', ';
  END LOOP;
  RETURN vRES;	
END;
  
END;

/

