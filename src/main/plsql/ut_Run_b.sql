CREATE OR REPLACE PACKAGE BODY
-- $Id:: ut_Run_b.sql 24 2009-12-30 23:40:28Z kazior                                                                                                                                    $
-- $URL:: https://pckazior:8443/svn/sandbox/trunk/joratest/src/main/plsql/ut_Run_b.sql                                                                                                  $
ut_Run
AS

TYPE TRec_TestCaseData
  IS RECORD (PackageName   VARCHAR2(100)
            ,ProcedureName VARCHAR2(100)
            ,Code          VARCHAR2(32000)
            );

---------------------------------------------------------------------------
FUNCTION fvGetCaseCodeTemplate RETURN VARCHAR2 IS
BEGIN
  RETURN 'BEGIN '                           || chr(10) ||
         '  #DYN01.rCleanup;'               || chr(10) ||
         '  #DYN01.rSetup;'                 || chr(10) ||
         '  #DYN01.#DYN02;'                 || chr(10) ||
         '  #DYN01.rCleanup;'               || chr(10) ||
         'EXCEPTION'                        || chr(10) ||
         '  WHEN OTHERS THEN'               || chr(10) ||
         '    #DYN01.rCleanup;'             || chr(10) ||
         '    RAISE; '                      || chr(10) ||
         'END;' ;
END fvGetCaseCodeTemplate;
---------------------------------------------------------------------------
FUNCTION fvGetCaseCode(pv_PackageName IN VARCHAR2, pv_ProcedureName IN VARCHAR2)
  RETURN VARCHAR2
IS
BEGIN
  RETURN REPLACE(REPLACE(fvGetCaseCodeTemplate
                        ,'#DYN01'
                        ,pv_PackageName)
                ,'#DYN02'
                ,pv_ProcedureName
                );
END fvGetCaseCode;
---------------------------------------------------------------------------
FUNCTION fvGetCursorCode RETURN VARCHAR2 IS
BEGIN
  RETURN 'SELECT /*+  RULE */'                                || chr(10) ||
         '      PACKAGE_NAME pckName '                        || chr(10) ||
         '     ,OBJECT_NAME  procName'                        || chr(10) ||
         ' FROM USER_ARGUMENTS '                              || chr(10) ||
         'WHERE OBJECT_NAME LIKE ''RTEST%'''                  || chr(10) ||
         '  AND PACKAGE_NAME LIKE ''UT\_%'' ESCAPE ''\'''     || chr(10) ||
         '  AND PACKAGE_NAME LIKE :1'                         || chr(10) ||
         '  AND POSITION = 1';
END fvGetCursorCode;
---------------------------------------------------------------------------
PROCEDURE rRunTestCase(pr_TestCaseData IN OUT TRec_TestCaseData
                      ,pv_ErrorMessage IN OUT VARCHAR2
                      ,pb_Success      IN OUT BOOLEAN
                      ) IS
BEGIN
  pb_Success := FALSE;

  pr_TestCaseData.Code := fvGetCaseCode(pv_PackageName   => pr_TestCaseData.PackageName
                                       ,pv_ProcedureName => pr_TestCaseData.ProcedureName
                                       );
  EXECUTE IMMEDIATE pr_TestCaseData.Code;
  pb_Success := TRUE;
EXCEPTION
  WHEN OTHERS THEN
    pb_Success := FALSE;
    pv_ErrorMessage := sqlerrm;
END rRunTestCase;
---------------------------------------------------------------------------
PROCEDURE rRunAllTests(pv_PackagesLike IN VARCHAR2) IS
  TYPE TCur_RefCursor IS REF CURSOR;
  vc_Cursor           TCur_RefCursor;
  vb_Success          BOOLEAN := TRUE;
  vv_PackagesLike     VARCHAR2(100) := '%';
  vv_LastErrorMessage VARCHAR2(32000);
  vr_TestCaseData     TRec_TestCaseData;
BEGIN
  dbms_output.put_line('---------------------------------------------------');
  dbms_output.put_line('---  joratest (c) 2009 G.K.                        ');
  dbms_output.put_line('---  Simple PLSQL unit test framework              ');
  dbms_output.put_line('---  Have your own Everest                         ');
  dbms_output.put_line('---------------------------------------------------');

  IF pv_PackagesLike IS NOT NULL THEN
    vv_PackagesLike := pv_PackagesLike || '%';
  END IF;

  OPEN vc_Cursor FOR fvGetCursorCode USING vv_PackagesLike;
  LOOP
    FETCH vc_Cursor INTO vr_TestCaseData.PackageName, vr_TestCaseData.ProcedureName;

    EXIT WHEN vc_Cursor%NOTFOUND;

    dbms_output.put_line('---  Testing:  ' || vr_TestCaseData.PackageName || '.' || vr_TestCaseData.ProcedureName || '                       ');

    vb_Success := FALSE;

    rRunTestCase(pr_TestCaseData => vr_TestCaseData
                ,pv_ErrorMessage => vv_LastErrorMessage
                ,pb_Success      => vb_Success
                );

    dbms_output.put_line('---------------------------------------------------');
    dbms_output.put_line('Test code: ' || chr(13) || chr(10) || vr_TestCaseData.Code         || chr(13) || chr(10));
    dbms_output.put_line('Exception: ' || chr(13) || chr(10) || vv_LastErrorMessage          || chr(13) || chr(10));
    dbms_output.put_line('---------------------------------------------------');


  END LOOP;

  IF vb_Success THEN
    dbms_output.put_line('---              S U C C E S S                  ');
  ELSE
    dbms_output.put_line('---              F A I L U R E                  ');
  END IF;
  dbms_output.put_line('---------------------------------------------------');
END rRunAllTests;
---------------------------------------------------------------------------
-- for PLSQL tests. When function returns FALSE then the test is skipped
FUNCTION  fbSkip(pv_PackageName IN VARCHAR2, pv_ProcedureName IN VARCHAR2) RETURN BOOLEAN IS
  vi_Ret NUMBER;
  ce_StatementIgnored   EXCEPTION;
  PRAGMA exception_init(ce_StatementIgnored, -6550);
BEGIN
  EXECUTE IMMEDIATE REPLACE(
   '
   DECLARE
    -- joratest code
    :vi_Ret  NUMBER;
     vi_Skip NUMBER;
   BEGIN
     IF #PACKAGENAME#.fbSkip(:pv_ProcedureName) THEN
       vi_Skip := 1;
     ELSE
       vi_Skip := 0;
     END IF;
     :vi_Ret := vi_Skip;
   END;'
   , '#PACKAGENAME#', pv_PackageName)
   USING OUT vi_Ret, pv_ProcedureName;
  RETURN vi_Ret=1;
EXCEPTION
  WHEN ce_StatementIgnored THEN
    RETURN FALSE;
END fbSkip;
---------------------------------------------------------------------------
END ut_Run;
/
