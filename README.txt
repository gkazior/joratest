JORATEST library 2009
-------------------------------------------------
webside: https://code.google.com/p/joratest/
-------------------------------------------------

Copyright (c) 2009 Grzegorz Kazior. All Rights Reserved.

DESCRIPTION

This package contains a JUnit suite definition which generates PLSQL
unit tests.

For more information about the library go to the webside.

REQUIREMENTS

This software requires Java 5 (JDK 1.6.0+) and maven.

INSTALLATION

No special installation is required.
To write PLSQL test cases it is convenient to use attached ut_Assert PLSQL
package (and others). To install the database object run the install.bat
script. It connects to the database and creates the joratest schema and
installs database objects on it.
The password for SYS is hard coded in install.bat.
Schemaname and password for joratest schema is hardcoded in src\main\config\install.sql


LICENSE

See the LICENCE.txt

CHANGES

This section summarizes changes between released versions of the classifier.

Version 0.0.2  2009-12-30
    Initial release
