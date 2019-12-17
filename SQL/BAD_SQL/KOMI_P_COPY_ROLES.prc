CREATE OR REPLACE PROCEDURE       KOMI_P_COPY_ROLES (
   nCOMPANY    IN   NUMBER,
   sROLE_OLD   IN   VARCHAR2,
   sROLE_NEW   IN   VARCHAR2,
   nAppend     IN   NUMBER DEFAULT 0)
                   -- 0- создать новую, 1- добавить права, -1- удалить права, 2- добавить в доступные каталоги
AS
   nRN_NEW   NUMBER (17);
   nRN_OLD   NUMBER (17);
   nCnt      NUMBER;
BEGIN
   BEGIN
      SELECT RN
        INTO nRN_OLD
        FROM ROLES
       WHERE ROLENAME = sROLE_OLD;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         P_EXCEPTION (0, 'Учетная запись роли "' || sROLE_OLD || '" не определена.');
   END;

   IF nAppend = 0
   THEN
      SELECT COUNT (*)
        INTO nCnt
        FROM ROLES
       WHERE ROLENAME = sROLE_NEW;

      IF nCnt > 0
      THEN
         P_EXCEPTION (0, 'Роль "' || sROLE_NEW || '" существует.');
      END IF;
   ELSE
      BEGIN
         SELECT RN
           INTO nRN_NEW
           FROM ROLES
          WHERE ROLENAME = sROLE_NEW;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            P_EXCEPTION (0, 'Учетная запись роли "' || sROLE_NEW || '" не определена.');
      END;
   END IF;

-- Добавляем роль

   IF nAppend = 0
   THEN
      P_ROLES_INSERT (SROLENAME => sROLE_NEW, NRN => NRN_NEW);
   END IF;

   IF nAppend IN (0, 1)
   THEN
-- Назначение приложений роли
      FOR rec IN (SELECT APPCODE, APPNAME
                    FROM V_ROLEAPPS
                   WHERE ROLEID = nRN_OLD
                     AND APPCODE NOT IN (SELECT APPCODE
                                           FROM V_ROLEAPPS
                                          WHERE ROLEID = nRN_NEW))
      LOOP
         P_ADMAP2RL_LINK (SAPPCODE => rec.APPCODE, NROLEID => nRN_NEW);
      END LOOP;

-- Назначение организаций роли
      FOR rec IN (SELECT FULLNAME, COMPANY
                    FROM V_ROLECOMPS
                   WHERE ROLEID = nRN_OLD
                     AND COMPANY NOT IN (SELECT COMPANY
                                           FROM V_ROLECOMPS
                                          WHERE ROLEID = nRN_NEW))
      LOOP
         P_ADMCO2RL_LINK (NCOMPANY => rec.company, NROLEID => nRN_NEW);
      END LOOP;

-- Какие разделы есть
      FOR rec IN (SELECT DISTINCT a.UNITCODE, a.UNITNAME, a.UNITNUMB, a.SIGN_ACCREG, a.SIGN_HIER, a.CTRLSIGN,
                                  a.COMPANY, a.VERSION
                    FROM V_ROLEUNITS a
                   WHERE a.ROLEID = nRN_OLD
                     AND NOT EXISTS (SELECT b.*
                                       FROM V_ROLEUNITS b
                                      WHERE b.ROLEID = nRN_NEW
                                        AND a.COMPANY = b.COMPANY
                                        AND a.UNITCODE = b.UNITCODE
                                        AND a.VERSION = b.VERSION))
      LOOP
-- Добавляем раздел
         P_ADMUN2RL_BASE_LINK (NCOMPANY => rec.company, SUNITCODE => rec.unitcode, NROLEID => nRN_NEW);
      END LOOP;

-- Права на каталоги
      FOR rec_cat IN (SELECT/*+ RULE*/
                          RN, CRN, NAME, UNITCODE, VERSION, COMPANY, CATACCESS, ROLEID, SIGNS
                        FROM VR_ACATALOG
                       WHERE cataccess = nRN_OLD
                         AND RN NOT IN (SELECT RN
                                          FROM VR_ACATALOG
                                         WHERE cataccess = nRN_NEW))
      LOOP
-- Добавляем каталог
         P_ADMRL2CTLG_LINK (NROLEID => nRN_NEW, NRN => rec_cat.rn);
      END LOOP;

-- Действия над каталогом
      FOR rec_cat IN (SELECT a.FUNC, a.NAME, a.NUMB, a.SIGN, a.CATALOG, a.COMPANY, a.UNITCODE
                        FROM V_ROLECTLGFUNC a
                       WHERE a.ROLEID = nRN_OLD
                         AND NOT EXISTS (SELECT b.*
                                           FROM V_ROLECTLGFUNC b
                                          WHERE b.ROLEID = nRN_NEW
                                            AND a.CATALOG = b.CATALOG
                                            AND a.FUNC = b.FUNC
                                            AND a.UNITCODE = b.UNITCODE
                                            AND a.COMPANY = b.COMPANY))
      LOOP
         P_CTLGPRIV2RL_INSERT (NCATALOG => rec_cat.CATALOG, NROLEID => nRN_NEW, SFUNC => rec_cat.FUNC);
      END LOOP;

-- Действия над разделом
      FOR rec IN (SELECT a.UNITCODE, a.FUNC, a.NAME, a.NUMB, a.SIGN, a.COMPANY, a.CATALOG
                    FROM V_ROLEUNITFUNC a
                   WHERE a.ROLEID = nRN_OLD
                     AND NOT EXISTS (SELECT b.*
                                       FROM V_ROLEUNITFUNC b
                                      WHERE b.ROLEID = nRN_NEW
                                        AND a.CATALOG = b.CATALOG
                                        AND a.FUNC = b.FUNC
                                        AND a.UNITCODE = b.UNITCODE
                                        AND a.COMPANY = b.COMPANY))
      LOOP
-- Добавление действия 
         P_UNITPRIV2RL_INSERT (NCOMPANY=> rec.COMPANY,
            NCATALOG    => rec.CATALOG,
            SUNITCODE   => rec.UNITCODE,
            NROLEID     => nRN_NEW,
            SFUNC       => rec.FUNC);
      END LOOP;
   END IF;

-- Добавляем права в существующие каталоги   
   IF nAppend = 2
   THEN
-- Действия над каталогом (Добавляем к существующим)
      FOR rec_cat IN (SELECT a.FUNC, a.NAME, a.NUMB, a.SIGN, a.CATALOG, a.COMPANY, a.UNITCODE
                        FROM V_ROLECTLGFUNC a
                       WHERE a.ROLEID = nRN_OLD
                         AND EXISTS (SELECT b.*
                                       FROM V_ROLECTLGFUNC b
                                      WHERE b.ROLEID = nRN_NEW
                                        AND a.CATALOG = b.CATALOG
                                        AND a.UNITCODE = b.UNITCODE
                                        AND a.COMPANY = b.COMPANY)
                         AND NOT EXISTS (SELECT b.*
                                           FROM V_ROLECTLGFUNC b
                                          WHERE b.ROLEID = nRN_NEW
                                            AND a.FUNC = b.FUNC
                                            AND a.CATALOG = b.CATALOG
                                            AND a.UNITCODE = b.UNITCODE
                                            AND a.COMPANY = b.COMPANY))
      LOOP
         P_CTLGPRIV2RL_INSERT (NCATALOG => rec_cat.CATALOG, NROLEID => nRN_NEW, SFUNC => rec_cat.FUNC);
      END LOOP;

-- Действия над разделом
      FOR rec IN (SELECT a.UNITCODE, a.FUNC, a.NAME, a.NUMB, a.SIGN, a.COMPANY, a.CATALOG
                    FROM V_ROLEUNITFUNC a
                   WHERE a.ROLEID = nRN_OLD
                     AND EXISTS (SELECT b.*
                                   FROM V_ROLEUNITFUNC b
                                  WHERE b.ROLEID = nRN_NEW
                                    AND a.CATALOG = b.CATALOG
                                    AND a.UNITCODE = b.UNITCODE
                                    AND a.COMPANY = b.COMPANY)
                     AND NOT EXISTS (SELECT b.*
                                       FROM V_ROLEUNITFUNC b
                                      WHERE b.ROLEID = nRN_NEW
                                        AND a.CATALOG = b.CATALOG
                                        AND a.FUNC = b.FUNC
                                        AND a.UNITCODE = b.UNITCODE
                                        AND a.COMPANY = b.COMPANY))
      LOOP
-- Добавление действия 
         P_UNITPRIV2RL_INSERT (NCOMPANY=> rec.COMPANY,
            NCATALOG    => rec.CATALOG,
            SUNITCODE   => rec.UNITCODE,
            NROLEID     => nRN_NEW,
            SFUNC       => rec.FUNC);
      END LOOP;
   END IF;

-- Если удаляем права
   IF nAppend = -1
   THEN
-- Удаляем действия над каталогом для роли
      FOR rec_cat IN (SELECT a.FUNC, a.NAME, a.NUMB, a.SIGN, a.CATALOG, a.COMPANY, a.UNITCODE
                        FROM V_ROLECTLGFUNC a
                       WHERE a.ROLEID = nRN_NEW
                         AND EXISTS (SELECT b.*
                                       FROM V_ROLECTLGFUNC b
                                      WHERE b.ROLEID = nRN_OLD
                                        AND a.CATALOG = b.CATALOG
                                        AND a.FUNC = b.FUNC
                                        AND a.UNITCODE = b.UNITCODE
                                        AND a.COMPANY = b.COMPANY))
      LOOP
         P_CTLGPRIV2RL_DELETE (NCATALOG => rec_cat.CATALOG, NROLEID => nRN_NEW, SFUNC => rec_cat.FUNC);
      END LOOP;

-- Удаляем действия над разделом для роли
      FOR rec IN (SELECT a.UNITCODE, a.FUNC, a.NAME, a.NUMB, a.SIGN, a.COMPANY, a.CATALOG
                    FROM V_ROLEUNITFUNC a
                   WHERE a.ROLEID = nRN_NEW
                     AND EXISTS (SELECT b.*
                                   FROM V_ROLEUNITFUNC b
                                  WHERE b.ROLEID = nRN_OLD
                                    AND a.CATALOG = b.CATALOG
                                    AND a.FUNC = b.FUNC
                                    AND a.UNITCODE = b.UNITCODE
                                    AND a.COMPANY = b.COMPANY))
      LOOP
-- Удаление действия 
         P_UNITPRIV2RL_DELETE (NCOMPANY=> rec.COMPANY,
            NCATALOG    => rec.CATALOG,
            SUNITCODE   => rec.UNITCODE,
            NROLEID     => nRN_NEW,
            SFUNC       => rec.FUNC);
      END LOOP;

-- Удаление прав на каталоги для роли
      FOR rec_cat IN (SELECT/*+ RULE*/
                          b.RN, b.CRN, b.NAME, b.UNITCODE, b.VERSION, b.COMPANY, b.CATACCESS, b.ROLEID,
                          b.SIGNS
                        FROM VR_ACATALOG b
                       WHERE b.cataccess = nRN_NEW
                         AND EXISTS (SELECT c.*
                                       FROM VR_ACATALOG c
                                      WHERE c.cataccess = nRN_OLD
                                        AND c.rn = b.rn
                                        AND c.unitcode = b.UNITCODE
                                        AND b.COMPANY = c.COMPANY
                                        AND b.VERSION = c.VERSION)
                         AND NOT EXISTS (SELECT *
                                           FROM V_ROLEUNITFUNC a
                                          WHERE a.ROLEID = nRN_NEW
                                            AND b.RN = a.CATALOG
                                            AND b.UNITCODE = a.UNITCODE
                                            AND b.COMPANY = a.COMPANY)
                         AND NOT EXISTS (SELECT *
                                           FROM V_ROLECTLGFUNC a
                                          WHERE a.ROLEID = nRN_NEW
                                            AND b.RN = a.CATALOG
                                            AND b.UNITCODE = a.UNITCODE
                                            AND b.COMPANY = a.COMPANY))
      LOOP
-- Удаляем права на каталог
         P_ADMRL2CTLG_UNLINK (NROLEID => nRN_NEW, NRN => rec_cat.rn);
      END LOOP;
/*-- Удаление разделов роли (Не доработанно)
      FOR rec IN (SELECT DISTINCT a.UNITCODE, a.UNITNAME, a.UNITNUMB, a.SIGN_ACCREG, a.SIGN_HIER, a.CTRLSIGN,
                                  a.COMPANY, a.VERSION
                    FROM V_ROLEUNITS a
                   WHERE a.ROLEID = nRN_NEW
                     AND EXISTS (SELECT b.*
                                   FROM V_ROLEUNITS b
                                  WHERE b.ROLEID = nRN_OLD
                                    AND a.COMPANY = b.COMPANY
                                    AND a.UNITCODE = b.UNITCODE
                                    AND a.VERSION = b.VERSION
                                    AND NOT EXISTS (SELECT *
                                                      FROM VR_ACATALOG c
                                                     WHERE c.cataccess = nRN_OLD
                                                       AND c.UNITCODE = b.UNITCODE
                                                       AND c.VERSION = b.VERSION))
                     AND NOT EXISTS (SELECT *
                                       FROM VR_ACATALOG b
                                      WHERE b.cataccess = nRN_NEW
                                        AND b.UNITCODE = a.UNITCODE
                                        AND b.VERSION = a.VERSION))
      LOOP
-- Удаляем раздел
         P_ADMUN2RL_BASE_UNLINK (NCOMPANY => rec.company, SUNITCODE => rec.unitcode, NROLEID => nRN_NEW);
      END LOOP;*/
   END IF;

   COMMIT;
END;
-- Drop the existing synonym 
-- drop public synonym KOMI_P_COPY_ROLES;
-- Create the new synonym 
-- create public synonym KOMI_P_COPY_ROLES
--  for PARUS.KOMI_P_COPY_ROLES;


-- grant execute on parus.KOMI_P_COPY_ROLES to dba;
/

