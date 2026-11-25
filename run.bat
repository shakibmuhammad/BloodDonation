@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-22
set PATH=%JAVA_HOME%\bin;%PATH%
@REM  set CATALINA_HOME=C:\tools\apache-tomcat-9.0.123
set CATALINA_HOME=C:\apache-tomcat-9.0.120


@REM  cd /d D:\Study\IDP\idp1\BloodDonation
cd /c C:\Users\Abujar\OneDrive\Documents\Desktop\idp


echo Stopping Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat"
timeout /t 6 /nobreak >nul
taskkill /f /im java.exe >nul 2>&1
timeout /t 2 /nobreak >nul

echo Building...
call mvn clean package -q
if errorlevel 1 (
  echo BUILD FAILED
  pause
  exit /b 1
)

echo Deploying...
rmdir /s /q "%CATALINA_HOME%\webapps\BloodDonation"
del /q "%CATALINA_HOME%\webapps\BloodDonation.war" 2>nul
rmdir /s /q "%CATALINA_HOME%\work\Catalina\localhost\BloodDonation" 2>nul
copy /y target\BloodDonation.war "%CATALINA_HOME%\webapps\BloodDonation.war"

echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"
echo.
echo Open: http://localhost:8080/BloodDonation/  (then Ctrl+Shift+R)
pause