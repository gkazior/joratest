DEFINE USER = joratest
DEFINE PASS = joratest

CREATE USER &USER IDENTIFIED BY &PASS
/
GRANT CONNECT, RESOURCE TO &USER
/

CONN &USER/&PASS
/

@src\main\config\create_schema_objects

EXIT;
