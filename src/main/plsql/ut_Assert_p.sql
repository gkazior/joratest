CREATE OR REPLACE PACKAGE
-- $Id:: ut_Assert_p.sql 24 2009-12-30 23:40:28Z kazior                                                                                                                                 $
-- $URL:: https://pckazior:8443/svn/sandbox/trunk/joratest/src/main/plsql/ut_Assert_p.sql                                                                                               $
ut_Assert
AS
  PROCEDURE rFail          (pv_Comment  IN VARCHAR2 DEFAULT NULL);

  PROCEDURE rAssertTrue    (pb_Actual   IN BOOLEAN  , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertFalse   (pb_Actual   IN BOOLEAN  , pv_Comment IN VARCHAR2 DEFAULT NULL );

  PROCEDURE rAssertEquals  (pb_Expected IN BOOLEAN  , pb_Actual IN BOOLEAN  , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertEquals  (pn_Expected IN NUMBER   , pn_Actual IN NUMBER   , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertEquals  (pd_Expected IN DATE     , pd_Actual IN DATE     , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertEquals  (pv_Expected IN VARCHAR2 , pv_Actual IN VARCHAR2 , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertEquals  (pl_Expected IN CLOB     , pl_Actual IN CLOB     , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertEquals  (pl_Expected IN BLOB     , pl_Actual IN BLOB     , pv_Comment IN VARCHAR2 DEFAULT NULL );


  PROCEDURE rAssertNull    (pb_Actual   IN BOOLEAN  , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertNull    (pn_Actual   IN NUMBER   , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertNull    (pd_Actual   IN DATE     , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertNull    (pv_Actual   IN VARCHAR2 , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertNull    (pl_Actual   IN CLOB     , pv_Comment IN VARCHAR2 DEFAULT NULL );
  PROCEDURE rAssertNull    (pl_Actual   IN BLOB     , pv_Comment IN VARCHAR2 DEFAULT NULL );

  PROCEDURE rAssertNotNull (pb_Actual   IN BOOLEAN  , pv_Comment IN VARCHAR2 DEFAULT NULL);
  PROCEDURE rAssertNotNull (pn_Actual   IN NUMBER   , pv_Comment IN VARCHAR2 DEFAULT NULL);
  PROCEDURE rAssertNotNull (pd_Actual   IN DATE     , pv_Comment IN VARCHAR2 DEFAULT NULL);
  PROCEDURE rAssertNotNull (pv_Actual   IN VARCHAR2 , pv_Comment IN VARCHAR2 DEFAULT NULL);
  PROCEDURE rAssertNotNull (pl_Actual   IN CLOB     , pv_Comment IN VARCHAR2 DEFAULT NULL);
  PROCEDURE rAssertNotNull (pl_Actual   IN BLOB     , pv_Comment IN VARCHAR2 DEFAULT NULL);

  PROCEDURE rExpectException (pv_Code VARCHAR2, pv_Exception VARCHAR2, pv_Comment IN VARCHAR2 DEFAULT NULL);
END ut_Assert;
/

