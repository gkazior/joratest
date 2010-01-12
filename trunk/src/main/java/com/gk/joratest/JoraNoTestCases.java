package com.gk.joratest;

import junit.framework.TestCase;

public class JoraNoTestCases extends TestCase {
	private OracleTestSuite oracleTestSuite;

	public JoraNoTestCases(OracleTestSuite oracleTestSuite) {
		super("No test case");
		this.oracleTestSuite = oracleTestSuite;
	}

	@Override
	protected void runTest() throws Throwable {
			if (oracleTestSuite.isErrorWhenNoCase() && (oracleTestSuite.countTestCases() <= 1)) {
				fail("Test suite has no testcases. Suite tells this is a problem. Check OracleTestSuite.isErrorWhenNoCase().");
			} 
	}
}
