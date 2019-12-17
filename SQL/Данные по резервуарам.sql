-- Для опередления мертвого остатка и максимальной вместимости на определенную дату :date_rep
select
  a.AZS_RN,
  a.AZS_NAME,
  a.REZ_RN,
  a.REZ_NAME,
  a.NOMEN_RN,
  a.NOMEN_CODE,
  a.DEAD_REST,
  NVL((
  SELECT b.MAX_VOLUME FROM azsbuffer.rez_meas b 
    WHERE b.PRN=a.rez_rn 
      AND b.DATE_MEAS<=:date_rep
      AND b.DATE_NEXT>=:date_rep
	  ),0) as MAX_VOLUME
from azsbuffer.v_rez_history a
where a.DATE_BEG<=:date_rep
  and a.DATE_END>=:date_rep

  
