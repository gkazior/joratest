CREATE OR REPLACE PACKAGE
-- $Id:: ut_Example_p.sql 24 2009-12-30 23:40:28Z kazior                                                                                                                                $
-- $URL:: https://pckazior:8443/svn/sandbox/trunk/joratest/src/test/plsql/ut_Example_p.sql                                                                                              $
ut_Example
AS
  PROCEDURE rSetup;
  PROCEDURE rCleanup;

  PROCEDURE rTestExample;
END ut_Example;
/

