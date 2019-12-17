/* Выводит список файлов данных (datafiles), для которых требуется восстановление (recovery) */

SELECT r.file# AS df#, d.name AS df_name, t.name AS tbsp_name,
d.status, r.error, r.change#, r.time
FROM v$recover_file r, v$datafile d, v$tablespace t
WHERE t.ts# = d.ts#
AND d.file# = r.file#