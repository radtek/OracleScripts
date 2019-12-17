--
-- TIPERROR  (Function) 
--
CREATE OR REPLACE FUNCTION MASTER.TIPERROR(ktu_prod VARCHAR2, unp_prod VARCHAR2, ktu_nom_zd VARCHAR2, unp_nom_zd VARCHAR2, ktu_nariad VARCHAR2, unp_nariad VARCHAR2, ktu_doveren VARCHAR2, unp_doveren VARCHAR2, ktu_ves NUMBER, unp_ves NUMBER, date_end DATE, max_date_nar DATE)
  RETURN VARCHAR2 IS
  Res VARCHAR2(250);
  Ending VARCHAR2(250);
  OutS VARCHAR2(250);
BEGIN

  Res := '';
  Ending := '';

  If (ktu_ves <> 0 OR ktu_ves is not null) And (unp_ves = 0 OR unp_ves is null) Then
    Res := Res || Ending || 'НЕТ отгрузки';
    Ending := ' ; ';
  Else
    If (ktu_ves = 0 OR ktu_ves is null) And (unp_ves <> 0 OR unp_ves is not null) Then
      Res := Res || Ending || 'НЕТ наряда/разнарядки';
      Ending := ' ; ';
    Else
      If ktu_prod || ' ' <> unp_prod || ' ' Then
        Res := Res || Ending || 'В разнарядке н/п - ' || ktu_prod;
        Ending := ' ; ';
      End If;
      If unp_ves > ktu_ves Then
        Res := Res || Ending || 'Перегруз';
        Ending := ' ; ';
      End If;
      If max_date_nar > date_end Then
        Res := Res || Ending || 'Превышение срока наряда (по наряду - ' || date_end || ', а отгрузка - ' || TO_CHAR(max_date_nar,'dd.mm.yyyy') || ')';
        Ending := ' ; ';
      End If;
    End If;
  End If;

  RETURN Res;
End;

/

