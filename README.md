# BloodLink

BloodLink is a blood donor and request directory for Bangladesh. It uses JSP, `javax.servlet`, JDBC DAOs, Oracle Database 11g XE, and a Maven WAR deployment. It is built for Tomcat 9 and JDK 22.

## 1. Requirements

- JDK 22 (Maven and Tomcat must both use this JDK or a newer compatible JDK).
- Apache Maven 3.8 or newer.
- Apache Tomcat 9. Use Tomcat 9, which provides `javax.servlet`; Tomcat 10 uses `jakarta.servlet` and is not compatible with this project as-is.
- Oracle Database 11g Express Edition (XE), with the listener available on `localhost:1521` and the XE SID/service `XE`.
- Oracle SQL*Plus, SQL Developer, or the Oracle extension for Visual Studio Code for running the SQL scripts.

## 2. Create the Oracle application user

Connect to the XE database as an administrator, then create the application user. Replace the sample password with a strong local password:

```sql
CREATE USER bloodapp IDENTIFIED BY "Choose-A-Strong-Password"
  DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp;
GRANT CREATE SESSION, CREATE TABLE, CREATE SEQUENCE, CREATE TRIGGER TO bloodapp;
ALTER USER bloodapp QUOTA UNLIMITED ON users;
```

`CREATE INDEX` is not a valid system privilege and causes `ORA-00990`. The app user can create indexes in its own schema as part of the schema script; it needs the tablespace quota above.

If the password contains characters such as `@`, `/`, or spaces, do not put it in the `sqlplus user/password@...` command: those characters can be interpreted as part of the connect syntax, and command-line passwords may be exposed. Start SQL*Plus without logging in and let it prompt for the password:

```text
sqlplus /nolog
SQL> CONNECT system@localhost:1521/XE
Enter password: (type the administrator password)
```

SQL*Plus prompts when the password is omitted from `CONNECT`. [Oracle SQL*Plus guide](https://docs.oracle.com/en/database/oracle/oracle-database/26/sqpug/SQL-Plus-quick-start.html).

## 3. Create the schema and load sample data

Run `sql/schema.sql` first, then `sql/sample-data.sql`. The schema models the Bangladesh location hierarchy as `divisions` → `districts` → `upazilas`; the sample script inserts all 8 divisions, 64 districts, starter upazilas/thanas, sample donors and requests, and the starter administrator. Donors and admins can sign in using either username or email. New donor usernames are requested during registration; the sample donor usernames are their email address's local part. It is intended for a new schema; do not run the inserts repeatedly against existing data.

### SQL*Plus

Connect as `bloodapp` and enter the password at the prompt:

```text
sqlplus /nolog
SQL> CONNECT bloodapp@localhost:1521/XE
Enter password: (type the bloodapp password)
SQL> @sql/schema.sql
SQL> @sql/sample-data.sql
SQL> EXIT
```

Run these commands from the project directory, or use absolute paths for the two SQL files.

### SQL Developer

Create a Basic connection with username `bloodapp`, host `localhost`, port `1521`, and SID `XE` (or service name `XE`, depending on the connection form). Connect, open `sql/schema.sql`, use **Run Script**, then repeat for `sql/sample-data.sql`.

### VS Code Oracle extension

Create an Oracle connection for `bloodapp` with host `localhost`, port `1521`, and SID/service `XE`. Open each SQL file and execute the full script while connected as `bloodapp`. Run schema before sample data.

## 4. Configure the JDBC connection

Edit `src/main/resources/db.properties` before building:

```properties
jdbc.driver=oracle.jdbc.OracleDriver
jdbc.url=jdbc:oracle:thin:@localhost:1521:XE
jdbc.username=bloodapp
jdbc.password=your_database_password
```

The project uses the SID form `jdbc:oracle:thin:@localhost:1521:XE`. Keep this password consistent with the Oracle user's password. The file is packaged inside the WAR at `WEB-INF/classes/db.properties`; protect the deployed WAR and do not commit a real deployment password.

## 5. Build the WAR

From the project directory:

```text
mvn clean package
```

The output is `target/BloodDonation.war`. The Maven runtime dependency is Oracle `ojdbc6` version `11.2.0.4`. If Maven cannot obtain that artifact, install the matching JAR into the local Maven repository, then rebuild:

```text
mvn install:install-file -Dfile=path\to\ojdbc6.jar -DgroupId=com.oracle.database.jdbc -DartifactId=ojdbc6 -Dversion=11.2.0.4 -Dpackaging=jar
mvn clean package
```

Use the `ojdbc6` JAR matching the version declared in `pom.xml`. Do not add a second Oracle driver copy to the WAR and Tomcat at the same time.

## 6. Deploy on Tomcat 9

Tomcat must run with JDK 22 or a newer JDK that supports the class files produced by this project. `JAVA_HOME` must point to the JDK directory, not its `bin` subdirectory. If Tomcat runs as a Windows service, set the service's Java selection to the same JDK.

### Windows PowerShell

Set the paths for your machine, stop Tomcat, build, copy the WAR, and restart it:

```powershell
$env:JAVA_HOME = 'C:\Program Files\Java\jdk-22'
$env:Path = "$env:JAVA_HOME\bin;$env:Path"
$TomcatHome = 'C:\path\to\apache-tomcat-9.0.x'

& "$TomcatHome\bin\shutdown.bat"
Set-Location 'D:\Study\IDP\idp1\BloodDonation'
mvn clean package
Copy-Item '.\target\BloodDonation.war' "$TomcatHome\webapps\BloodDonation.war" -Force
& "$TomcatHome\bin\startup.bat"
```

If Tomcat is installed as a Windows service, stop and start that service instead of using the batch files. Tomcat deploys the app under `/BloodDonation/` from the WAR name.

### Linux/macOS shell

Set the actual JDK and Tomcat paths, then deploy:

```sh
export JAVA_HOME=/path/to/jdk-22
export PATH="$JAVA_HOME/bin:$PATH"
export CATALINA_HOME=/path/to/apache-tomcat-9.0.x

"$CATALINA_HOME/bin/shutdown.sh"
mvn clean package
cp target/BloodDonation.war "$CATALINA_HOME/webapps/BloodDonation.war"
"$CATALINA_HOME/bin/startup.sh"
```

Open `http://localhost:8080/BloodDonation/` unless the Tomcat HTTP connector uses another port.

### Oracle XE and Tomcat port conflict

Oracle XE 11g commonly uses port `1521` for its database listener and `8080` for the XE web interface. Tomcat also commonly uses HTTP port `8080`, so choose a free HTTP port for one of them. [Oracle XE 11g default ports](https://docs.oracle.com/cd/E17781_01/install.112/e18803/).

The simplest option is to change Tomcat's HTTP `<Connector port="8080" ...>` in `$CATALINA_HOME/conf/server.xml` to an unused port such as `8081`, then restart Tomcat and browse to `http://localhost:8081/BloodDonation/`. To change the Oracle XE HTTP port instead, connect as an Oracle administrator and run:

```sql
EXEC DBMS_XDB.SETHTTPPORT(8081);
```

That changes the XE web interface port, not the database listener port used by JDBC. Oracle's [XE 11g network guide](https://docs.oracle.com/cd/E17781_01/server.112/e18804/network.htm) documents this procedure and how to verify the listener endpoint afterward.

## 7. Starter accounts and admin password

After loading sample data:

- Admin username: `admin`
- Admin email: `admin@bloodlink.local`
- Admin password: `Admin@123`
- Sample donor password: `Donor@123`; use the username from a sample donor's email local part or an email listed in `sql/sample-data.sql`.

New donor registrations start in `PENDING` and cannot appear in donor search until an administrator approves them. Change the sample admin password before a real deployment. To generate a new salted hash locally, build the project and run `jshell --class-path target/classes`:

```java
import com.blood.util.PasswordUtil;
String salt = PasswordUtil.newSalt();
String hash = PasswordUtil.hash("your-new-password", salt);
System.out.println(salt);
System.out.println(hash);
```

Connect as `bloodapp`, replace the placeholders with the generated output, and commit the update:

```sql
UPDATE admins
   SET password_hash = '<generated hash>',
       password_salt = '<generated salt>'
 WHERE username = 'admin';
COMMIT;
```

Do not store the plaintext password in the database.

## 8. English and Bangla language switcher

The header's `English | বাংলা` control stores `lang=en` or `lang=bn` in the session. The selected locale is used by JSP messages and localized server validation responses.

To add a label, add the same key to both `src/main/resources/i18n/messages_en.properties` and `messages_bn.properties`. Keep the English value readable text. In the Bangla file, write non-ASCII Bangla characters as Java properties `\uXXXX` escapes; for example, `\u09ac\u09be\u0982\u09b2\u09be` renders `বাংলা`. Keep JSPs UTF-8 and use `<fmt:message key="your.key"/>` rather than hardcoding UI text.

## 9. Division, district, and upazila selects

The public forms use a shared searchable combobox with keyboard, pointer, and mobile support. District options carry their division from the database, and division filtering is client-side; the district IDs still submit as `districtId`. District changes fetch `/upazilas?districtId=<id>`, whose JSON items contain `id` and `name`, and preserve the form fields `bloodGroup`, `districtId`, and `upazilaId`.

The home search, donor search, registration, profile editing, blood request, and admin location forms use this component. The admin location workspace supports create, read, update, and delete for divisions, districts, and upazilas; referenced records cannot be deleted while donor/request records depend on them. Keep these records accurate because the division filter is client-side and search forms submit no division field.

The admin donor workspace supports creating accounts, editing profile and availability/status fields, reviewing, blocking, and deleting donors. New admin-created donor accounts start in `PENDING`; set a temporary password and communicate it through a secure channel. The request workspace supports creating, editing, deleting, and changing request status (`OPEN`, `FULFILLED`, or `CLOSED`); `CLOSED` requests are inactive and may be reopened. The admin dashboard summarizes donor/request/location counts and recent activity.

## 10. Troubleshooting

| Symptom | What to check |
|---|---|
| HTTP 500 | Read the newest `logs/localhost.*.log` and `logs/catalina.*.log` in the Tomcat `CATALINA_BASE`; inspect the last `Caused by` entry. Check `db.properties`, then confirm Tomcat can load the Oracle JDBC driver. |
| `ORA-12541` | Oracle listener is not reachable. Confirm XE and its listener are running and `jdbc.url` uses the correct host and port. |
| `ORA-12514` | The listener does not know the requested service. Confirm the XE service/SID and use `XE` in the JDBC URL. |
| `ORA-01017` | Username/password was rejected. Check the `bloodapp` credentials in `db.properties`; avoid an accidental mismatch in case-sensitive passwords. |
| `ORA-00942` | A table or view is missing or the connected user is wrong. Run `sql/schema.sql` as `bloodapp` and check the JDBC username. |
| `ORA-01950` | The schema lacks quota on its tablespace. As an Oracle administrator, grant quota on the actual tablespace, for example `ALTER USER bloodapp QUOTA UNLIMITED ON users;`. |
| `UnsupportedClassVersionError` | Tomcat is running an older Java runtime than the JDK used to compile the app. Point Maven and the Tomcat service to JDK 22 or newer. |
| 404 for `/BloodDonation/` | Confirm `BloodDonation.war` is in Tomcat's `webapps`, wait for deployment, and check the context path and connector port. |
| Bangla appears garbled | Keep JSPs and resource files UTF-8; the Bangla properties file uses `\uXXXX` escapes. Check the database with `SELECT value FROM NLS_DATABASE_PARAMETERS WHERE parameter = 'NLS_CHARACTERSET';`; `AL32UTF8` is the expected Unicode database character set. Do not attempt an in-place database character-set change as a quick fix. |
| Old CSS remains visible | Hard-refresh with `Ctrl+F5`, then check that Tomcat deployed the new WAR and loaded the expected CSS path. |

## 11. Manual test checklist

- [ ] Open `/BloodDonation/` at 360px, 768px, and 1280px; verify the hero, search card, three “How it works” steps, tips, and footer.
- [ ] Choose a division and confirm only its districts remain; choose a district and verify the upazila list loads, shows loading/empty/error states, and clears when the division changes.
- [ ] Choose a district first and confirm its division is selected automatically. Submit home/search filters and confirm parameter names remain `bloodGroup`, `districtId`, and `upazilaId`.
- [ ] Edit a donor profile and confirm its saved division, district, and upazila are restored.
- [ ] Test keyboard navigation (arrows, Enter, Escape), pointer selection, and phone-width interaction in each searchable form.
- [ ] Switch languages on public and admin pages; confirm all visible labels and validation messages update, and Bangla text is readable.
- [ ] Sign in as a donor and admin by both username and email; test a wrong password and verify the same generic failure message.
- [ ] As a guest, submit `POST /request`; confirm the server blocks it and login keeps the intended request URL. Try an unsafe `returnTo` such as `//example.com` and confirm fallback to the dashboard.
- [ ] Verify dashboard totals and recent activity, and donor create/edit/status/delete flows.
- [ ] Verify request create/edit/status/delete flows, including closing an OPEN request and reopening a CLOSED request.
- [ ] Verify division, district, and upazila create/edit/delete flows; confirm linked locations are protected from deletion.
- [ ] Confirm every admin mutation is CSRF-protected and new donor accounts remain PENDING until approved.
- [ ] Check Tomcat logs and browser console after the deployed smoke test.

## 12. Department presentation

For a department demonstration, use the home page to explain donor search and the three-step flow, then show a donor dashboard and an admin dashboard with community counts and management links. Load the sample data before presenting so the statistics and lists are populated. Use a test database and the starter accounts only for a local demonstration; change sample credentials before any shared or public deployment.

