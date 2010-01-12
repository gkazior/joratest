CREATE OR REPLACE PACKAGE
-- $Id:: ut_Run_p.sql 24 2009-12-30 23:40:28Z kazior                                                                                                                                    $
-- $URL:: https://pckazior:8443/svn/sandbox/trunk/joratest/src/main/plsql/ut_Run_p.sql                                                                                                  $
ut_Run
AS
  PROCEDURE rRunAllTests(pv_PackagesLike IN VARCHAR2 DEFAULT NULL);
  -- for PLSQL tests. When function returns FALSE then the test is skipped
  FUNCTION  fbSkip(pv_PackageName IN VARCHAR2, pv_ProcedureName IN VARCHAR2) RETURN BOOLEAN;

  FUNCTION fvGetCursorCode RETURN VARCHAR2;

END ut_Run;
/

