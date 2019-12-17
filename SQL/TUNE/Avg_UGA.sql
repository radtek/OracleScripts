SELECT sn.name, avg(ss.value)
   FROM v$sesstat ss, v$statname sn
    WHERE ss.statistic# = sn.statistic#
      AND sn.name = 'session uga memory max' 
       GROUP BY sn.name;