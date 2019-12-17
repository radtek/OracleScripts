--
-- FOR_VISIR  (Package Body) 
--
CREATE OR REPLACE PACKAGE BODY MASTER.FOR_VISIR AS

PROCEDURE GLOBAL_TO_LOCAL(AUSER_ID NUMBER,FROM_DATE DATE,TO_DATE DATE) IS
BEGIN

  UPDATE month_visir_loc A
     SET (prichin)
	 = (SELECT B.prichin
          FROM master.v_month_ree B
		 WHERE B.date_ree=A.date_ree AND B.dop_ree=A.dop_ree AND B.NOM_ZD=A.NOM_ZD AND B.date_ree BETWEEN FROM_DATE AND TO_DATE)
   WHERE A.app_users_id=AUSER_ID  
     AND exists
       (SELECT B.prichin
          FROM master.v_month_ree B
		 WHERE B.date_ree=A.date_ree AND B.dop_ree=A.dop_ree AND B.NOM_ZD=A.NOM_ZD AND B.date_ree BETWEEN FROM_DATE AND TO_DATE);
  COMMIT;

  INSERT INTO month_visir_loc
     (date_ree,dop_ree,nom_zd,prichin,app_users_id)
	 (SELECT B.date_ree,B.dop_ree,B.nom_zd,B.prichin,AUSER_ID
        FROM master.v_month_ree B
		 WHERE B.date_ree BETWEEN FROM_DATE AND TO_DATE
		   AND not exists (SELECT A.nom_zd FROM month_visir_loc A WHERE A.date_ree=B.date_ree AND A.dop_ree=B.dop_ree AND A.nom_zd=B.nom_zd AND A.app_users_id=AUSER_ID AND A.date_ree BETWEEN FROM_DATE AND TO_DATE));
  COMMIT;

  DELETE FROM month_visir_loc A
   WHERE NOT EXISTS (SELECT B.NOM_ZD FROM master.v_month_ree B
                      WHERE A.date_ree=B.date_ree AND A.dop_ree=B.dop_ree AND A.nom_zd=B.nom_zd AND B.date_ree BETWEEN FROM_DATE AND TO_DATE)
	 AND A.app_users_id=AUSER_ID;

  COMMIT;

END;

PROCEDURE LOCAL_TO_GLOBAL(AUSER_ID NUMBER,FROM_DATE DATE,TO_DATE DATE) IS
BEGIN

  DELETE FROM master.month_visir A
   WHERE A.date_ree BETWEEN FROM_DATE AND TO_DATE 
     AND NOT EXISTS (SELECT B.NOM_ZD FROM month_visir_loc B
                      WHERE A.date_ree=B.date_ree AND A.dop_ree=B.dop_ree AND A.nom_zd=B.nom_zd AND B.app_users_id=AUSER_ID AND LTrim(RTrim(B.prichin)) || ' '<>' ' AND B.date_ree BETWEEN FROM_DATE AND TO_DATE);
  COMMIT;

  UPDATE master.month_visir A
     SET (prichin,app_users_id)
	 = (SELECT B.prichin,B.app_users_id
          FROM month_visir_loc B
		 WHERE B.date_ree=A.date_ree AND B.dop_ree=A.dop_ree AND B.NOM_ZD=A.NOM_ZD AND B.APP_USERS_ID=AUSER_ID AND LTrim(RTrim(B.prichin))||' '<>LTrim(RTrim(A.prichin))||' ' AND B.date_ree BETWEEN FROM_DATE AND TO_DATE)
   WHERE A.date_ree BETWEEN FROM_DATE AND TO_DATE 
     AND exists
       (SELECT B.app_users_id
          FROM month_visir_loc B
		 WHERE B.date_ree=A.date_ree AND B.dop_ree=A.dop_ree AND B.NOM_ZD=A.NOM_ZD AND B.APP_USERS_ID=AUSER_ID AND LTrim(RTrim(B.prichin))||' '<>LTrim(RTrim(A.prichin))||' ' AND B.date_ree BETWEEN FROM_DATE AND TO_DATE);
  COMMIT;

  INSERT INTO master.month_visir
     (date_ree,dop_ree,nom_zd,prichin,app_users_id)
	 (SELECT B.date_ree,B.dop_ree,B.nom_zd,B.prichin,B.APP_USERS_ID
        FROM month_visir_loc B
		 WHERE not exists (SELECT A.nom_zd FROM master.month_visir A WHERE A.date_ree=B.date_ree AND A.dop_ree=B.dop_ree AND A.nom_zd=B.nom_zd AND A.date_ree BETWEEN FROM_DATE AND TO_DATE)
		   AND B.app_users_id=AUSER_ID AND LTrim(RTrim(B.prichin)) || ' '<>' '
		   AND B.date_ree BETWEEN FROM_DATE AND TO_DATE);
  COMMIT;


END;


PROCEDURE LOCAL_TO_GLOBAL_ROW(AACTION VARCHAR2, AUSER_ID NUMBER, ADATE_REE DATE, ADOP_REE NUMBER, ANOM_ZD VARCHAR2, APRICHIN VARCHAR2) IS
cnt1 NUMBER;
BEGIN

  IF AACTION = 'D' OR (AACTION='U' AND LTrim(RTrim(APRICHIN)) || ' '=' ') THEN
    DELETE FROM master.month_visir A
     WHERE A.date_ree=ADATE_REE AND A.dop_ree=ADOP_REE AND A.nom_zd=ANOM_ZD AND LTrim(RTrim(APRICHIN)) || ' '=' ';
  END IF;

  IF AACTION = 'U' AND LTrim(RTrim(APRICHIN)) || ' '<>' ' THEN
    UPDATE master.month_visir A
       SET prichin=APRICHIN,app_users_id=AUSER_ID
     WHERE A.date_ree=ADATE_REE AND A.dop_ree=ADOP_REE AND A.NOM_ZD=ANOM_ZD AND LTrim(RTrim(A.prichin))||' '<>LTrim(RTrim(APRICHIN))||' ';
  END IF;

  IF AACTION = 'I' AND LTrim(RTrim(APRICHIN)) || ' '<>' ' THEN

    SELECT COUNT(*) INTO cnt1
	  FROM master.month_visir A
	 WHERE A.date_ree=ADATE_REE AND A.dop_ree=ADOP_REE AND A.nom_zd=ANOM_ZD;

	IF cnt1=0 THEN
      INSERT INTO master.month_visir (date_ree,dop_ree,nom_zd,prichin,app_users_id)
	    VALUES (ADATE_REE,ADOP_REE,ANOM_ZD,APRICHIN,AUSER_ID);
	END IF;
  END IF;

END;

END;

/

