/* Formatted on 2005/05/16 08:33 (Formatter Plus v4.8.5) */
SELECT   *
    FROM v_econoprs m
   WHERE company = :1
     AND m.operation_date >= TO_DATE ('01/04/2005', 'dd/mm/yyyy')
     AND m.operation_date <= TO_DATE ('30/04/2005', 'dd/mm/yyyy')
     AND m.agent_from_rn IN (SELECT rn
                               FROM agnlist
                              WHERE agnabbr = '€‡‘ 20')
     AND m.rn IN (
            SELECT m.prn
              FROM v_oprspecs_shadow m
             WHERE company = :2
               AND m.operation_date >= TO_DATE ('01/04/2005', 'dd/mm/yyyy')
               AND m.operation_date <= TO_DATE ('30/04/2005', 'dd/mm/yyyy')
               AND m.account_debit IN (SELECT rn
                                         FROM dicaccs
                                        WHERE acc_number LIKE '62%')
               AND m.account_credit IN (SELECT rn
                                          FROM dicaccs
                                         WHERE acc_number = '90.1/')
               AND m.analytic_credit1 IN (SELECT rn
                                            FROM dicanls
                                           WHERE anl_number = '01')
               AND m.analytic_credit3 IN (SELECT rn
                                            FROM dicanls
                                           WHERE anl_number = '‘Ž“’’Ž‚')
               AND m.analytic_credit5 IN (SELECT rn
                                            FROM dicanls
                                           WHERE anl_number = '01'))
ORDER BY m.operation_date, m.operation_pref, m.operation_numb

