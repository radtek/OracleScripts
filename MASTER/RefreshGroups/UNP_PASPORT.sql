--
-- UNP_PASPORT  (Refresh Group) 
--
DECLARE
  SnapArray SYS.DBMS_UTILITY.UNCL_ARRAY;
BEGIN
  Begin
    SnapArray(1) := 'MASTER.UNP_DISPETCHER';
    SnapArray(2) := 'MASTER.UNP_FACT_PASP';
    SnapArray(3) := 'MASTER.UNP_SPRAV_POKAZATEL';
    SnapArray(4) := 'MASTER.UNP_PASPORT';
    SnapArray(5) := 'MASTER.UNP_SPRAV_OIL_PRODUCT';
    SnapArray(6) := 'MASTER.UNP_NORM_PASP';
    SnapArray(7) := NULL;
    SYS.DBMS_REFRESH.MAKE (
      name => 'MASTER.UNP_PASPORT'
      ,tab  => SnapArray
      ,next_date => NULL
      ,interval  => NULL
      ,implicit_destroy => TRUE
      ,lax => TRUE
      ,job => 0
      ,rollback_seg => NULL
      ,push_deferred_rpc => TRUE
      ,refresh_after_errors => FALSE
      ,purge_option => 1
      ,parallelism => 0
      ,heap_size => 0
    );
    Commit;
  exception
    when others then
    begin
      raise;
    end;
  end;
END;
/

