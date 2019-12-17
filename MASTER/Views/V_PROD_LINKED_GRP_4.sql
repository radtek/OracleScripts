--
-- V_PROD_LINKED_GRP_4  (View) 
--
CREATE OR REPLACE FORCE VIEW MASTER.V_PROD_LINKED_GRP_4
(FACT_ID_NPR, GROUP_NAME_NPR, LINK_ID_NPR)
AS 
SELECT
  Prod_1.Id_npr AS Fact_Id_Npr,
  KLS_PROD_GROUPS.Group_name AS Group_Name_npr,
  Gr_2.Prod_id_npr AS Link_Id_npr
FROM KLS_PROD Prod_1,
     KLS_PROD_GROUPS_DESC Gr_1,
     KLS_PROD_GROUPS_DESC Gr_2,
     KLS_PROD_GROUPS
WHERE Prod_1.Id_npr = Gr_1.Prod_id_npr
  AND Gr_1.Prod_groups_id = KLS_PROD_GROUPS.ID
  AND KLS_PROD_GROUPS.Prod_type_grp_id = 4
  AND Gr_1.Prod_groups_id = Gr_2.Prod_groups_id
ORDER BY Prod_1.Id_npr,Gr_2.Prod_id_npr;


