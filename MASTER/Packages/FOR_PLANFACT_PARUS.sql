--
-- FOR_PLANFACT_PARUS  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Planfact_Parus AS

  -- Очистить таблицу PLAN_FACT
  PROCEDURE EmptyPlanFact;
  
  -- Заполнить план
  PROCEDURE FillPlan (DateBeg VARCHAR2, DateEnd VARCHAR2);
  
  -- Заполнить "Заявлено"
  PROCEDURE FillZayv (DateBeg VARCHAR2, DateEnd VARCHAR2);

  -- Заполнить факт
  PROCEDURE FillFact (DateBeg VARCHAR2, DateEnd VARCHAR2);
  
  -- Заполнение плана/факта по плану перевозок и поставки  
  PROCEDURE FillAll (DateBeg VARCHAR2, DateEnd VARCHAR2);
	 
END;

/

