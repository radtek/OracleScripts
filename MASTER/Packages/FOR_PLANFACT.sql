--
-- FOR_PLANFACT  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.For_Planfact AS

  -- Очистить таблицу PLAN_FACT
  PROCEDURE EmptyPlanFact;
  
  -- Заполнить план поставок
  PROCEDURE FillPlanPost (PlanId NUMBER, DateBeg VARCHAR2, DateEnd VARCHAR2, IsSNP NUMBER DEFAULT 0);
  
  -- Заполнить "Заявлено"
  PROCEDURE FillZayv (DateBeg VARCHAR2, DateEnd VARCHAR2, IsSNP NUMBER DEFAULT 0);

  -- Заполнить "Свободная емкость"
  PROCEDURE FillEmptyVol (TimeEnd VARCHAR2, DateEnd VARCHAR2);
    
  -- Заполнить факт по плану поставок
  PROCEDURE FillFactPost (DateBegPlan VARCHAR2, DateEndPlan VARCHAR2, TimeBeg VARCHAR2, DateBeg VARCHAR2, TimeEnd VARCHAR2, DateEnd VARCHAR2, IsSNP NUMBER DEFAULT 0);
  
  -- Заполнить план перевозок
  PROCEDURE FillPlanGD (DateBeg VARCHAR2, DateEnd VARCHAR2);
  
  -- Заполнить факт по плану перевозок
  PROCEDURE FillFactGD (TimeBeg VARCHAR2, DateBeg VARCHAR2, TimeEnd VARCHAR2, DateEnd VARCHAR2);

  -- Заполнение плана/факта по плану перевозок и поставки  
  PROCEDURE FillAll (PlanId NUMBER, DateBegPlanPost VARCHAR2, DateEndPlanPost VARCHAR2,  
     TimeBegFactPost VARCHAR2, DateBegFactPost VARCHAR2, TimeEndFactPost VARCHAR2, DateEndFactPost VARCHAR2,
	 DateBegPlanGD VARCHAR2, DateEndPlanGD VARCHAR2,   
     TimeBegFactGD VARCHAR2, DateBegFactGD VARCHAR2, TimeEndFactGD VARCHAR2, DateEndFactGD VARCHAR2);
	 
  -- Заполнение плана/факта по плану поставок для СНП  
  PROCEDURE FillSNP (PlanId NUMBER, DateBegPlanPost VARCHAR2, DateEndPlanPost VARCHAR2,  
     TimeBegFactPost VARCHAR2, DateBegFactPost VARCHAR2, TimeEndFactPost VARCHAR2, DateEndFactPost VARCHAR2,
	 DateBegPlanGD VARCHAR2, DateEndPlanGD VARCHAR2,   
     TimeBegFactGD VARCHAR2, DateBegFactGD VARCHAR2, TimeEndFactGD VARCHAR2, DateEndFactGD VARCHAR2);
	 
  -- Заполнение оперативной сводки  
  PROCEDURE FillOper (PlanId NUMBER, DateBegPlanPost VARCHAR2, DateEndPlanPost VARCHAR2,  
     TimeBegFactPost VARCHAR2, DateBegFactPost VARCHAR2, TimeEndFactPost VARCHAR2, DateEndFactPost VARCHAR2,
	 DateBegPlanGD VARCHAR2, DateEndPlanGD VARCHAR2,   
     TimeBegFactGD VARCHAR2, DateBegFactGD VARCHAR2, TimeEndFactGD VARCHAR2, DateEndFactGD VARCHAR2);

  -- Заполнение справки для видеоконференции  
  PROCEDURE FillConf (PlanId NUMBER, DateBegPlanPost VARCHAR2, DateEndPlanPost VARCHAR2,  
     TimeBegFactPost VARCHAR2, DateBegFactPost VARCHAR2, TimeEndFactPost VARCHAR2, DateEndFactPost VARCHAR2,
	 DateBegPlanGD VARCHAR2, DateEndPlanGD VARCHAR2,   
     TimeBegFactGD VARCHAR2, DateBegFactGD VARCHAR2, TimeEndFactGD VARCHAR2, DateEndFactGD VARCHAR2);
	 
END;

/

