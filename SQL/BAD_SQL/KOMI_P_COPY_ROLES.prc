CREATE OR REPLACE PROCEDURE       KOMI_P_COPY_ROLES (
   nCOMPANY    IN   NUMBER,
   sROLE_OLD   IN   VARCHAR2,
   sROLE_NEW   IN   VARCHAR2,
   nAppend     IN   NUMBER DEFAULT 0)
                   -- 0- ������� �����, 1- �������� �����, -1- ������� �����, 2- �������� � ��������� ��������
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
         P_EXCEPTION (0, '������� ������ ���� "' || sROLE_OLD || '" �� ����������.');
   END;

   IF nAppend = 0
   THEN
      SELECT COUNT (*)
        INTO nCnt
        FROM ROLES
       WHERE ROLENAME = sROLE_NEW;

      IF nCnt > 0
      THEN
         P_EXCEPTION (0, '���� "' || sROLE_NEW || '" ����������.');
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
            P_EXCEPTION (0, '������� ������ ���� "' || sROLE_NEW || '" �� ����������.');
      END;
   END IF;

-- ��������� ����

   IF nAppend = 0
   THEN
      P_ROLES_INSERT (SROLENAME => sROLE_NEW, NRN => NRN_NEW);
   END IF;

   IF nAppend IN (0, 1)
   THEN
-- ���������� ���������� ����
      FOR rec IN (SELECT APPCODE, APPNAME
                    FROM V_ROLEAPPS
                   WHERE ROLEID = nRN_OLD
                     AND APPCODE NOT IN (SELECT APPCODE
                                           FROM V_ROLEAPPS
                                          WHERE ROLEID = nRN_NEW))
      LOOP
         P_ADMAP2RL_LINK (SAPPCODE => rec.APPCODE, NROLEID => nRN_NEW);
      END LOOP;

-- ���������� ����������� ����
      FOR rec IN (SELECT FULLNAME, COMPANY
                    FROM V_ROLECOMPS
                   WHERE ROLEID = nRN_OLD
                     AND COMPANY NOT IN (SELECT COMPANY
                                           FROM V_ROLECOMPS
                                          WHERE ROLEID = nRN_NEW))
      LOOP
         P_ADMCO2RL_LINK (NCOMPANY => rec.company, NROLEID => nRN_NEW);
      END LOOP;

-- ����� ������� ����
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
-- ��������� ������
         P_ADMUN2RL_BASE_LINK (NCOMPANY => rec.company, SUNITCODE => rec.unitcode, NROLEID => nRN_NEW);
      END LOOP;

-- ����� �� ��������
      FOR rec_cat IN (SELECT/*+ RULE*/
                          RN, CRN, NAME, UNITCODE, VERSION, COMPANY, CATACCESS, ROLEID, SIGNS
                        FROM VR_ACATALOG
                       WHERE cataccess = nRN_OLD
                         AND RN NOT IN (SELECT RN
                                          FROM VR_ACATALOG
                                         WHERE cataccess = nRN_NEW))
      LOOP
-- ��������� �������
         P_ADMRL2CTLG_LINK (NROLEID => nRN_NEW, NRN => rec_cat.rn);
      END LOOP;

-- �������� ��� ���������
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

-- �������� ��� ��������
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
-- ���������� �������� 
         P_UNITPRIV2RL_INSERT (NCOMPANY=> rec.COMPANY,
            NCATALOG    => rec.CATALOG,
            SUNITCODE   => rec.UNITCODE,
            NROLEID     => nRN_NEW,
            SFUNC       => rec.FUNC);
      END LOOP;
   END IF;

-- ��������� ����� � ������������ ��������   
   IF nAppend = 2
   THEN
-- �������� ��� ��������� (��������� � ������������)
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

-- �������� ��� ��������
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
-- ���������� �������� 
         P_UNITPRIV2RL_INSERT (NCOMPANY=> rec.COMPANY,
            NCATALOG    => rec.CATALOG,
            SUNITCODE   => rec.UNITCODE,
            NROLEID     => nRN_NEW,
            SFUNC       => rec.FUNC);
      END LOOP;
   END IF;

-- ���� ������� �����
   IF nAppend = -1
   THEN
-- ������� �������� ��� ��������� ��� ����
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

-- ������� �������� ��� �������� ��� ����
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
-- �������� �������� 
         P_UNITPRIV2RL_DELETE (NCOMPANY=> rec.COMPANY,
            NCATALOG    => rec.CATALOG,
            SUNITCODE   => rec.UNITCODE,
            NROLEID     => nRN_NEW,
            SFUNC       => rec.FUNC);
      END LOOP;

-- �������� ���� �� �������� ��� ����
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
-- ������� ����� �� �������
         P_ADMRL2CTLG_UNLINK (NROLEID => nRN_NEW, NRN => rec_cat.rn);
      END LOOP;
/*-- �������� �������� ���� (�� �����������)
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
-- ������� ������
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

