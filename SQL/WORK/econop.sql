/* Formatted on 2005/03/10 14:23 (Formatter Plus v4.8.5) */
SELECT   *
    FROM v_econoprs m
   WHERE company = :1
     AND crn = :2
     AND m.operation_date >= TO_DATE ('01/02/2005', 'dd/mm/yyyy')
     AND m.operation_date <= TO_DATE ('28/02/2005', 'dd/mm/yyyy')
     AND m.njur_pers IN (SELECT rn
                           FROM jurpersons
                          WHERE code = '‘…‚……”’…Ž„“Š’')
     AND (   (m.agent_from_rn IN (SELECT rn
                                    FROM agnlist
                                   WHERE agnabbr = '€‡‘-37'))
          OR (m.agent_to_rn IN (SELECT rn
                                  FROM agnlist
                                 WHERE agnabbr = '€‡‘-37'))
         )
     AND m.rn IN (
            SELECT m.prn
              FROM v_oprspecs_shadow m
             WHERE company = :3
               AND crn = :4
               AND m.operation_date >= TO_DATE ('01/02/2005', 'dd/mm/yyyy')
               AND m.operation_date <= TO_DATE ('28/02/2005', 'dd/mm/yyyy')
               AND m.nomenclature IN (SELECT rn
                                        FROM dicnomns
                                       WHERE nomen_code = '„‡—')
               AND m.nomen_partno = '13_010105­'
               AND (    m.account_debit IN (SELECT rn
                                              FROM dicaccs
                                             WHERE acc_number = '41.1/0720')
                    AND m.balunit_debit IN (SELECT rn
                                              FROM dicbunts
                                             WHERE bunit_mnemo = '–€_‘')
                   )
            UNION
            SELECT m.prn
              FROM v_oprspecs_shadow m
             WHERE company = :5
               AND crn = :6
               AND m.operation_date >= TO_DATE ('01/02/2005', 'dd/mm/yyyy')
               AND m.operation_date <= TO_DATE ('28/02/2005', 'dd/mm/yyyy')
               AND m.nomenclature IN (SELECT rn
                                        FROM dicnomns
                                       WHERE nomen_code = '„‡—')
               AND m.nomen_partno = '13_010105­'
               AND (    m.account_credit IN (SELECT rn
                                               FROM dicaccs
                                              WHERE acc_number = '41.1/0720')
                    AND m.balunit_credit IN (SELECT rn
                                               FROM dicbunts
                                              WHERE bunit_mnemo = '–€_‘')
                   ))
ORDER BY m.operation_date, m.operation_pref, m.operation_numb

