select distinct a.azs_number, a.AZS_NAME from azsazslistmt a, azssreportmain b
where a.rn = b.azs_number
and b.DATE_SMENA > TO_DATE('01.08.2003','dd.mm.yyyy')

