CREATE OR REPLACE PACKAGE  BODY
-- $Id:: ut_Assert_b.sql 24 2009-12-30 23:40:28Z kazior                                                                                                                                 $
-- $URL:: https://pckazior:8443/svn/sandbox/trunk/joratest/src/main/plsql/ut_Assert_b.sql                                                                                               $
ut_Assert
AS

SUBTYPE String IS VARCHAR2(32000);

---------------------------------------------------------------------------
FUNCTION fdGetSysdate RETURN DATE IS
BEGIN
  RETURN SYSDATE;
END fdGetSysdate;
---------------------------------------------------------------------------
PROCEDURE rLogInfo(pv_Comment IN VARCHAR2)
IS
BEGIN
  dbms_output.put_line(pv_Comment);
END rLogInfo;
---------------------------------------------------------------------------
FUNCTION fvBooleanToString(pb_Value IN BOOLEAN )
RETURN VARCHAR2 IS
BEGIN
  IF pb_Value IS NULL THEN
    RETURN '(NULL)';
  ELSIF pb_Value THEN
    RETURN 'TRUE';
  END IF;

  RETURN 'FALSE';
END fvBooleanToString;
---------------------------------------------------------------------------
PROCEDURE rLogProblem(pv_Comment IN VARCHAR2)
IS
BEGIN
  RAISE_APPLICATION_ERROR(-20001, pv_Comment);
END rLogProblem;
---------------------------------------------------------------------------
PROCEDURE rExpectException(pv_Code VARCHAR2, pv_Exception VARCHAR2, pv_Comment IN VARCHAR2 DEFAULT NULL) IS
  vv_Sqlerrm String;
BEGIN
  rLogInfo(pv_Code || ' Exc: ' || pv_Exception);
  EXECUTE IMMEDIATE 'BEGIN ' || pv_Code || '; END;';
  rFail('Unexpectadly no expected exception [' || pv_Comment || '] ' || pv_Exception);
EXCEPTION
  WHEN OTHERS THEN
    vv_Sqlerrm := sqlerrm;
    IF NOT vv_Sqlerrm LIKE pv_Exception THEN
      rFail('Expected exception [' || pv_Comment || '] '  || pv_Exception || ' but actual is ' || vv_Sqlerrm);
    END IF;
END rExpectException;
---------------------------------------------------------------------------
PROCEDURE rFail(pv_Comment IN VARCHAR2 DEFAULT NULL) IS
BEGIN
  rLogProblem(pv_Comment);
END rFail;
---------------------------------------------------------------------------
PROCEDURE rAssertEquals(pb_Expected IN BOOLEAN , pb_Actual IN BOOLEAN , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pb_Expected IS NULL AND pb_Actual IS NULL THEN
    RETURN;
  END IF;
  IF NVL(pb_Expected != pb_Actual, TRUE) THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected [' || fvBooleanToString(pb_Expected) || '] Actual[' || fvBooleanToString(pb_Actual) || ']');
  END IF;
END rAssertEquals;
---------------------------------------------------------------------------
PROCEDURE rAssertEquals(pv_Expected IN VARCHAR2, pv_Actual IN VARCHAR2, pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pv_Expected IS NULL AND pv_Actual IS NULL THEN
    RETURN;
  END IF;
  IF NVL(pv_Expected != pv_Actual, TRUE) THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected [' || pv_Expected || '] Actual[' || pv_Actual || ']');
  END IF;
END rAssertEquals;
---------------------------------------------------------------------------
PROCEDURE rAssertEquals(pn_Expected IN NUMBER  , pn_Actual IN NUMBER  , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pn_Expected IS NULL AND pn_Actual IS NULL THEN
    RETURN;
  END IF;
  IF NVL(pn_Expected != pn_Actual, TRUE) THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected [' || pn_Expected || '] Actual[' || pn_Actual || ']');
  END IF;
END rAssertEquals;
---------------------------------------------------------------------------
PROCEDURE rAssertEquals(pd_Expected IN DATE    , pd_Actual IN DATE    , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pd_Expected IS NULL AND pd_Actual IS NULL THEN
    RETURN;
  END IF;
  IF NVL(pd_Expected != pd_Actual, TRUE) THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected ['         || TO_CHAR(pd_Expected         , 'YYYY.MM.DD HH24:MM:SS')
                           || '] Actual['           || TO_CHAR(pd_Actual           , 'YYYY.MM.DD HH24:MM:SS')
                           || '] when sysdate is [' || TO_CHAR(fdGetSysdate        , 'YYYY.MM.DD HH24:MM:SS')
                           || ']');
  END IF;
END rAssertEquals;
---------------------------------------------------------------------------
PROCEDURE rAssertEquals(pl_Expected IN BLOB , pl_Actual IN BLOB , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pl_Expected IS NULL AND pl_Actual IS NULL THEN
    RETURN;
  END IF;

  IF pl_Expected IS NULL OR pl_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' BLOBS are different!');
  END IF;

  IF 0 != dbms_lob.compare(pl_Expected,pl_Actual) THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' BLOBS are different (not null)!');
  END IF;
END rAssertEquals;
---------------------------------------------------------------------------
PROCEDURE rAssertEquals(pl_Expected IN CLOB , pl_Actual IN CLOB , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pl_Expected IS NULL AND pl_Actual IS NULL THEN
    RETURN;
  END IF;

  IF pl_Expected IS NULL OR pl_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' CLOBS are different!');
  END IF;

  IF 0 != dbms_lob.compare(pl_Expected,pl_Actual) THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' CLOBS are different (not null)!');
  END IF;
END rAssertEquals;
---------------------------------------------------------------------------
PROCEDURE rAssertTrue  (pb_Actual IN BOOLEAN , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF NOT pb_Actual THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual false)');
  END IF;
END rAssertTrue;
---------------------------------------------------------------------------
PROCEDURE rAssertFalse (pb_Actual IN BOOLEAN , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pb_Actual THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual true)');
  END IF;
END rAssertFalse;
---------------------------------------------------------------------------
PROCEDURE rAssertNull (pb_Actual IN BOOLEAN, pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pb_Actual IS NOT NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected NULL but '
                           || ' actual is ['           || fvBooleanToString(pb_Actual)
                           || ']');
  END IF;
END rAssertNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNull (pv_Actual IN VARCHAR2 , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pv_Actual IS NOT NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected NULL but '
                           || ' actual is ['           || pv_Actual
                           || ']');

  END IF;
END rAssertNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNull (pd_Actual IN DATE     , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pd_Actual IS NOT NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected NULL but '
                           || ' actual is ['           || TO_CHAR(pd_Actual           , 'YYYY.MM.DD HH24:MM:SS')
                           || '] when sysdate is ['    || TO_CHAR(fdGetSysdate        , 'YYYY.MM.DD HH24:MM:SS')
                           || ']');

  END IF;
END rAssertNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNull (pn_Actual IN NUMBER   , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pn_Actual IS NOT NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected NULL but '
                           || ' actual is ['   || TO_CHAR(pn_Actual)
                           || ']'
                           );
  END IF;
END rAssertNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNull (pl_Actual IN BLOB   , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pl_Actual IS NOT NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected NULL but '
                           || ' actual length is ['   || dbms_lob.getlength(pl_Actual)
                           || ']'
                           );
  END IF;
END rAssertNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNull (pl_Actual IN CLOB   , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pl_Actual IS NOT NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Expected NULL but '
                           || ' actual length is ['   || dbms_lob.getlength(pl_Actual)
                           || ']'
                           );
  END IF;
END rAssertNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNotNull (pb_Actual IN BOOLEAN  , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pb_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' Actual NOT NULL');
  END IF;
END rAssertNotNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNotNull (pv_Actual IN VARCHAR2 , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pv_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual NOT NULL)');
  END IF;
END rAssertNotNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNotNull (pd_Actual IN DATE     , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pd_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual NOT NULL)');
  END IF;
END rAssertNotNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNotNull (pn_Actual IN NUMBER   , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pn_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual NOT NULL)');
  END IF;
END rAssertNotNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNotNull (pl_Actual IN BLOB   , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pl_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual NOT NULL)');
  END IF;
END rAssertNotNull;
---------------------------------------------------------------------------
PROCEDURE rAssertNotNull (pl_Actual IN CLOB   , pv_Comment IN VARCHAR2 DEFAULT NULL)
IS
BEGIN
  IF pl_Actual IS NULL THEN
    rLogProblem('Comment[' || pv_Comment || ']' || ' (Actual NOT NULL)');
  END IF;
END rAssertNotNull;
---------------------------------------------------------------------------
END ut_Assert;
/
