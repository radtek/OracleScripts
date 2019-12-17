--
-- FOR_PLANPOST  (Package) 
--
CREATE OR REPLACE PACKAGE MASTER.FOR_PLANPOST AS
  PLAN_PERIODS_ID PLAN_PERIODS.ID%TYPE;

  -- Открыть плановый период
  -- возвращает PLAN_PERIODS.ID
  FUNCTION NewPeriod (PlanID NUMBER, DatePlan DATE, BeginDate DATE, EndDate DATE) RETURN NUMBER;

  -- Изменить плановый период
  PROCEDURE ChangePeriod (PlanPerID NUMBER, DatePlan DATE, BeginDate DATE, EndDate DATE);

  -- Удалить плановый период
  PROCEDURE DeletePeriod (PlanPerID NUMBER);

  -- Копирование плана
  -- возвращает PLAN_PERIODS.ID
  FUNCTION CopyPlan (PlanPerIdFrom NUMBER, PlanIdTo NUMBER) RETURN NUMBER;

  -- Изменение плана
  PROCEDURE NewIzm (TableID VARCHAR2 DEFAULT 'POST', PlanPerID NUMBER, NumIzm NUMBER, NumCheck NUMBER);

  -- Заполнение временной таблицы для ввода/редактирования позиции плана
  -- Возвращает уникальное имя временной таблицы
  FUNCTION FillTempPayForms(IsAdd NUMBER, PlanId NUMBER, PlanPerId NUMBER, ProdId VARCHAR2, PlanStruId NUMBER, DogId NUMBER, RefineryId NUMBER DEFAULT 8, OrgStruId NUMBER DEFAULT NULL) RETURN VARCHAR2;

  -- Заполнение цен во временной таблице
  PROCEDURE FillTempPrices(PlanPerId NUMBER, ProdId VARCHAR2, DogId NUMBER);

  -- Сохранение изменений из временной таблицы в PLAN_POST
  FUNCTION AddPlanPost(EditId NUMBER, PlanId NUMBER, PlanPerId NUMBER, ProdId VARCHAR2, PlanStruId NUMBER, DogId NUMBER, 
                           RefineryId NUMBER, OrgStruId NUMBER, PayFormId NUMBER, Price NUMBER, Ves NUMBER, CatCenId NUMBER, DateCena DATE) RETURN NUMBER;

  -- Очистка временной таблицы
  PROCEDURE ClearTempPayForms(TempTableName VARCHAR2);

  -- Удалить позицию плана
  PROCEDURE DeletePlanPost(EditId NUMBER);

END;
/

