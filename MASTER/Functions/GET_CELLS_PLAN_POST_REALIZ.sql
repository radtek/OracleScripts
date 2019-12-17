--
-- GET_CELLS_PLAN_POST_REALIZ  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.get_cells_plan_post_realiz (
   date_plan#     DATE,
   supplier_id#   NUMBER,
   prod_id_npr#   VARCHAR2,
   tip_real_id#   NUMBER,
   vid_real_id#   NUMBER,
   org_kind_id#   NUMBER,
   org_stru_id#   NUMBER
)
   RETURN NUMBER
AS
   kol#   NUMBER;
BEGIN
   SELECT ves
     INTO kol#
     FROM plan_realiz
    WHERE date_plan = date_plan#
      AND supplier_id = supplier_id#
      AND prod_id_npr = prod_id_npr#
      AND tip_real_id = tip_real_id#
      AND vid_real_id = vid_real_id#
      AND org_kind_id = org_kind_id#
      AND org_stru_id = org_stru_id#
	  AND PARUS_RN IS NULL;

   RETURN kol#;
END get_cells_plan_post_realiz;

/

