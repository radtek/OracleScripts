delete from ARM_LOGS_STEPS_PSV where log_id in (select id from arm_logs_psv where computer_name='AZS-SERVER')

delete from ARM_ORACLE_DATAFILES_PSV where log_id in (select id from arm_logs_psv where computer_name='AZS-SERVER')

delete from arm_logs_psv where computer_name='AZS-SERVER'

delete from arm_values_psv where computer_name='AZS-SERVER'