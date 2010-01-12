package com.gk.joratest;

import java.sql.Connection;
import java.sql.PreparedStatement;

import junit.framework.TestCase;
import junit.framework.TestResult;

/**
 * Test case represents a PLSQL procedure in a PLSQL packages.
 * 
 * @author kazior
 * 
 */
public class OracleTestCase extends TestCase {
	private OracleTestSuite suite;
	private String procedureName;
	private CharSequence packageName;
	private static String templatePlsqlCode = "-- joratest " + "\n"
			+ "BEGIN                             " + "\n"
			+ "  IF NOT ut_Run.fbSkip('#PACKAGE#', '#PROCEDURE#') THEN " + "\n"
			+ "    #PACKAGE#.rCleanup;           " + "\n"
			+ "	   #PACKAGE#.rSetup;             " + "\n"
			+ "	   #PACKAGE#.#PROCEDURE#;        " + "\n"
			+ "	   #PACKAGE#.rCleanup;           " + "\n"
			+ "  END IF;                         " + "\n"
			+ "EXCEPTION                         " + "\n"
			+ "	 WHEN OTHERS THEN                " + "\n"
			+ "	   #PACKAGE#.rCleanup;           " + "\n"
			+ "	   RAISE;                        " + "\n"
			+ "END;                              " + "\n";

	public OracleTestCase(OracleTestSuite suite, String packageName,
			String procedureName) {
		super(packageName + "." + procedureName);
		this.suite = suite;
		this.packageName = packageName;
		this.procedureName = procedureName;
	}

	@Override
	public void run(TestResult result) {

		super.run(result);
	}

	@Override
	protected void runTest() throws Throwable {
		final String blockToCall = templatePlsqlCode.replace("#PACKAGE#",
				packageName).replace("#PROCEDURE#", procedureName);

		try {
			// index expressions
			final Connection connection = suite.getConnection();
			PreparedStatement pstmtProcCall = connection
					.prepareStatement(blockToCall);
			pstmtProcCall.execute();
			pstmtProcCall.close();
		} catch (java.sql.SQLException e) {
			throw new TestException(e, blockToCall);
		}

	}

}
