CREATE OR REPLACE PROCEDURE       KOMI_P_MODI_ROLES (
   nCOMPANY   IN   NUMBER,
   sROLE      IN   VARCHAR2,-- Роль
   sUNIT      IN   VARCHAR2,-- Раздел
   sCATALOG   IN   VARCHAR2,-- Каталог
   sFUNC      IN   VARCHAR2,-- Действие
   nAppend    IN   NUMBER DEFAULT 0)
-- 0- добавить в доступные каталоги, -1- удалить права, 1- добавить во все каталоги
AS
   nRN_ROLE      NUMBER (17);
   nRN_UNIT      NUMBER (17);
   nRN_CATALOG   NUMBER (17);
   nVERSION      NUMBER (17);
   sFUNCCODE     VARCHAR2 (40);
   sUNITCODE     VARCHAR2 (40);
   nCnt          NUMBER;
BEGIN
   DBMS_OUTPUT.enable (100000);

   BEGIN
      SELECT RN
        INTO nRN_ROLE
        FROM ROLES
       WHERE ROLENAME = sROLE;
      DBMS_OUTPUT.put_line ('nRN_ROLE - ' || TO_CHAR (nRN_ROLE));
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Учетная запись роли "' || sROLE || '" не определена.');
   END;

   BEGIN
      SELECT RN, UNITCODE
        INTO nRN_UNIT, sUNITCODE
        FROM UNITLIST
       WHERE unitname = sUNIT;
      DBMS_OUTPUT.put_line ('nRN_UNIT, sUNITCODE - ' || TO_CHAR (nRN_UNIT) || ', ' || sUNITCODE);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Раздел - "' || sUNIT || '" не определен.');
   END;

   BEGIN
      SELECT RN
        INTO nRN_CATALOG
        FROM ACATALOG
       WHERE DOCNAME IN (SELECT a.UNITCODE
                           FROM UNITLIST a
                          WHERE a.parentcode IS NULL
                          START WITH a.unitcode = sUNITCODE
                         CONNECT BY PRIOR a.parentcode = a.unitcode)
         AND name = sCATALOG
         AND (
                   COMPANY = nCOMPANY
                OR EXISTS (SELECT *
                             FROM compverlist
                            WHERE company = nCompany
                              AND unitcode IN (SELECT a.UNITCODE
                                                 FROM UNITLIST a
                                                WHERE a.parentcode IS NULL
                                                START WITH a.unitcode = sUNITCODE
                                               CONNECT BY PRIOR a.parentcode = a.unitcode)));
      DBMS_OUTPUT.put_line ('nRN_CATALOG - ' || TO_CHAR (nRN_CATALOG));
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Каталог - "' || sCATALOG || '" в разделе "' || sUNIT || '" не определен.');
   END;

   BEGIN
      SELECT CODE
        INTO sFUNCCODE
        FROM UNITFUNC
       WHERE UNITCODE = sUNITCODE
         AND name = sFUNC;
      DBMS_OUTPUT.put_line ('sFUNCCODE - ' || sFUNCCODE);
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Действие - "' || sFUNC || '" в разделе' || sUNIT || '" не определено.');
   END;

-- Добавляем роль

   IF nAppend IN (0, 1)
   THEN
-- Пройдемся по каталогам   
      FOR rec_cat IN (SELECT a.rn
                        FROM ACATALOG a
                       START WITH     a.rn = nRN_CATALOG
                                  AND a.docname IN (SELECT b.UNITCODE
                                                      FROM UNITLIST b
                                                     WHERE b.parentcode IS NULL
                                                     START WITH b.unitcode = sUNITCODE
                                                    CONNECT BY PRIOR b.parentcode = b.unitcode)
                                  AND (
                                            COMPANY = nCOMPANY
                                         OR EXISTS (SELECT *
                                                      FROM compverlist
                                                     WHERE company = nCompany
                                                       AND unitcode IN (SELECT b.UNITCODE
                                                                          FROM UNITLIST b
                                                                         WHERE b.parentcode IS NULL
                                                                         START WITH b.unitcode = sUNITCODE
                                                                        CONNECT BY PRIOR b.parentcode =
                                                                                                   b.unitcode)))
                      CONNECT BY PRIOR a.rn = a.crn)
      LOOP
-- Права на каталоги
         FOR rec IN (SELECT/*+ RULE*/
                         RN, cataccess
                       FROM VR_ACATALOG
                      WHERE roleid = nRN_ROLE
                        AND RN = rec_cat.rn
                        AND (
                                  COMPANY = nCOMPANY
                               OR EXISTS (SELECT *
                                            FROM compverlist
                                           WHERE company = nCompany
                                             AND unitcode IN (SELECT b.UNITCODE
                                                                FROM UNITLIST b
                                                               WHERE b.parentcode IS NULL
                                                               START WITH b.unitcode = sUNITCODE
                                                              CONNECT BY PRIOR b.parentcode = b.unitcode))))
         LOOP
            SELECT COUNT (*)
              INTO nCnt
              FROM V_ROLEUNITFUNC b
             WHERE b.ROLEID = nRN_ROLE
               AND b.CATALOG = rec_cat.rn
               AND b.FUNC = sFUNCCODE
               AND b.UNITCODE = sUNITCODE
               AND b.COMPANY = nCOMPANY;
            DBMS_OUTPUT.put_line ('nCnt - ' || TO_CHAR (nCnt));

            IF nCnt = 0
            THEN
               IF     nAppend = 1
                  AND rec.cataccess IS NULL
               THEN
-- Добавляем каталог
                  DBMS_OUTPUT.put_line ('******');
                  P_ADMRL2CTLG_LINK (NROLEID => nRN_ROLE, NRN => rec_cat.rn);
-- Добавление действия 
                  P_UNITPRIV2RL_INSERT (NCOMPANY=> nCOMPANY,
                     NCATALOG    => rec_cat.rn,
                     SUNITCODE   => sUNITCODE,
                     NROLEID     => nRN_ROLE,
                     SFUNC       => sFUNCCODE);
               ELSE
-- Добавление действия 
                  IF rec.cataccess IS NOT NULL
                  THEN
                     DBMS_OUTPUT.put_line ('+++++++');
                     P_UNITPRIV2RL_INSERT (NCOMPANY=> nCOMPANY,
                        NCATALOG    => rec_cat.rn,
                        SUNITCODE   => sUNITCODE,
                        NROLEID     => nRN_ROLE,
                        SFUNC       => sFUNCCODE);
                  END IF;
               END IF;
            END IF;
         END LOOP;
      END LOOP;
   END IF;

   IF nAppend = -1
   THEN
-- Пройдемся по каталогам   
      FOR rec_cat IN (SELECT a.rn
                        FROM ACATALOG a
                       START WITH     a.rn = nRN_CATALOG
                                  AND a.docname IN (SELECT b.UNITCODE
                                                      FROM UNITLIST b
                                                     WHERE b.parentcode IS NULL
                                                     START WITH b.unitcode = sUNITCODE
                                                    CONNECT BY PRIOR b.parentcode = b.unitcode)
                                  AND (
                                            COMPANY = nCOMPANY
                                         OR EXISTS (SELECT *
                                                      FROM compverlist
                                                     WHERE company = nCompany
                                                       AND unitcode IN (SELECT b.UNITCODE
                                                                          FROM UNITLIST b
                                                                         WHERE b.parentcode IS NULL
                                                                         START WITH b.unitcode = sUNITCODE
                                                                        CONNECT BY PRIOR b.parentcode =
                                                                                                   b.unitcode)))
                      CONNECT BY PRIOR a.rn = a.crn)
      LOOP
         SELECT COUNT (*)
           INTO nCnt
           FROM V_ROLEUNITFUNC b
          WHERE b.ROLEID = nRN_ROLE
            AND b.CATALOG = rec_cat.rn
            AND b.FUNC = sFUNCCODE
            AND b.UNITCODE = sUNITCODE
            AND b.COMPANY = nCOMPANY;
         DBMS_OUTPUT.put_line ('nCnt - ' || TO_CHAR (nCnt));

         IF nCnt <> 0
         THEN
-- Удаление действия 
            P_UNITPRIV2RL_DELETE (NCOMPANY=> nCOMPANY,
               NCATALOG    => rec_cat.rn,
               SUNITCODE   => sUNITCODE,
               NROLEID     => nRN_ROLE,
               SFUNC       => sFUNCCODE);
         END IF;
      END LOOP;
   END IF;

--   DBMS_OUTPUT.disable;
   COMMIT;
END;
-- Drop the existing synonym 
-- drop public synonym KOMI_P_MODI_ROLES;
-- Create the new synonym 
-- create public synonym KOMI_P_MODI_ROLES for PARUS.KOMI_P_MODI_ROLES;


-- grant execute on parus.KOMI_P_MODI_ROLES to dba;
/

