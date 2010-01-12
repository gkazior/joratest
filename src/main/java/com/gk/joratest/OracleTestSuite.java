package com.gk.joratest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import junit.framework.TestResult;
import junit.framework.TestSuite;
import oracle.jdbc.pool.OracleDataSource;

/**
 * Test suite for unit tests. Finds PLSQL packages to test and builds test
 * cases.
 * 
 * @author kazior
 * 
 */
public class OracleTestSuite extends TestSuite {
	@Override
	public void run(TestResult result) {
		runStatement(beforeTestsStatement);
		super.run(result);
		runStatement(afterTestsStatement);
	}

	private void runStatement(String statement) {
		if ((statement != null) && !statement.isEmpty()) {

			try {
				final PreparedStatement pstmt = getConnection()
						.prepareStatement(statement);
				pstmt.execute();
				pstmt.close();
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
	}

	private final static String sqlPackagesToTest = ""
			+ "SELECT /*+ RULE */                          " + "\n"
			+ "      PACKAGE_NAME   pckName                " + "\n"
			+ "     ,OBJECT_NAME   procName                " + "\n"
			+ " FROM USER_ARGUMENTS                        " + "\n"
			+ "WHERE OBJECT_NAME LIKE 'RTEST%'             " + "\n"
			+ "  AND PACKAGE_NAME LIKE 'UT\\_%' ESCAPE '\\'" + "\n"
			+ "  AND PACKAGE_NAME LIKE :1                  " + "\n"
			+ "  AND POSITION = 1                          ";

	private String username;
	private String password;
	private String url;
	private String beforeTestsStatement;
	private String afterTestsStatement;

	public String getBeforeTestsStatement() {
		return beforeTestsStatement;
	}

	public void setBeforeTestsStatement(String beforeTestsStatement) {
		this.beforeTestsStatement = beforeTestsStatement;
	}

	public String getAfterTestsStatement() {
		return afterTestsStatement;
	}

	public void setAfterTestsStatement(String afterTestsStatement) {
		this.afterTestsStatement = afterTestsStatement;
	}

	private boolean errorWhenNoCase = true;

	public boolean isErrorWhenNoCase() {
		return errorWhenNoCase;
	}

	public void setErrorWhenNoCase(boolean errorWhenNoCase) {
		this.errorWhenNoCase = errorWhenNoCase;
	}

	private String packagesLike = "%";

	private Connection connection;

	public Connection getConnection() {
		if (connection == null) {
			try {
				final OracleDataSource ods = new OracleDataSource();
				ods.setDataSourceName("url");
				ods.setUser(username);
				ods.setPassword(password);
				ods.setURL(url);

				final Connection connection = ods.getConnection();
				connection.setAutoCommit(false);
				this.connection = connection;
			} catch (SQLException e) {
				throw new RuntimeException(e);
			}
		}
		return connection;
	}

	public String getUrl() {
		return url;
	}

	public String getPackagesLike() {
		return packagesLike;
	}

	public String getPassword() {
		return password;
	}

	public String getUsername() {
		return username;
	}

	public void setConnection(Connection connection) {
		this.connection = connection;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public void setPackagesLike(String packagesLike) {
		if (packagesLike == null) {
			this.packagesLike = "%";
		} else {
			this.packagesLike = packagesLike + "%";
		}
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public void setUpOracleTests() {
		getConnection();

		addTest(new JoraNoTestCases(this));

		try {
			final PreparedStatement pstmt = connection
					.prepareStatement(sqlPackagesToTest);
			pstmt.setString(1, packagesLike);
			final ResultSet rset = pstmt.executeQuery();

			while (rset.next()) {
				final String packageName = rset.getString("pckName");
				final String procedureName = rset.getString("ProcName");

				addTest(new OracleTestCase(this, packageName, procedureName));
			}

			rset.close();
			pstmt.close();
		} catch (SQLException e) {
			throw new RuntimeException(e);
		}
	}

	public void setUsername(String username) {
		this.username = username;
	}

	@Override
	public String getName() {
		return this.getClass().getName() + ": PLSQL packages like "
				+ packagesLike;
	}
}
