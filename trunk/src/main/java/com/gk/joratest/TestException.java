package com.gk.joratest;

import java.sql.SQLException;

/**
 * TestException is a class for a better diagnosis of the test failure. It shows
 * the PLSQL block used for tests. The block may be copied and executed in a
 * external tool like sqlplus.
 * 
 * @author kazior
 * 
 */
@SuppressWarnings("serial")
public class TestException extends Exception {
	private String statement;

	public TestException(SQLException e, String statement) {
		super(e);
		this.statement = statement;
	}

	@Override
	public String toString() {
		return this.getClass().getName() + ": \n" + statement;
	}
}
