LOAD DATA
CHARACTERSET RU8PC866
INTO TABLE ARM_BUFFER_PSV
APPEND
WHEN (4:4)='-'
(
ID SEQUENCE(1,1),
TEXT position(1:250) CHAR 
)  
