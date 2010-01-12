CREATE OR REPLACE PACKAGE BODY
-- $Id:: ut_Example_b.sql 24 2009-12-30 23:40:28Z kazior                                                                                                                                $
-- $URL:: https://pckazior:8443/svn/sandbox/trunk/joratest/src/test/plsql/ut_Example_b.sql                                                                                              $
ut_Example
AS

---------------------------------------------------------------------------
PROCEDURE rSetup IS
BEGIN
  NULL;
END rSetup;
---------------------------------------------------------------------------
PROCEDURE rCleanup IS
BEGIN
  NULL;
END rCleanup;
---------------------------------------------------------------------------
PROCEDURE rTestExample IS
BEGIN
  ut_Assert.rAssertTrue(TRUE);
END;
---------------------------------------------------------------------------
END ut_Example;
/

