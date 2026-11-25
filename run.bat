@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-22
set PATH=%JAVA_HOME%\bin;%PATH%
set CATALINA_HOME=C:\tools\apache-tomcat-9.0.123
set CATALINA_BASE=%CATALINA_HOME%
set PORT=8081

cd /d "%~dp0"

echo Stopping Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat" >nul 2>&1

REM Wait until the port is released, max ~30s
set /a tries=0
:waitloop
netstat -ano | findstr ":%PORT% " | findstr "LISTENING" >nul
if errorlevel 1 goto stopped
set /a tries+=1
if %tries% GEQ 30 (
  echo Tomcat did not stop gracefully, forcing...
  for /f "tokens=5" %%p in ('netstat -ano ^| findstr ":%PORT% " ^| findstr "LISTENING"') do taskkill /f /pid %%p >nul 2>&1
  goto stopped
)
timeout /t 1 /nobreak >nul
goto waitloop
:stopped
timeout /t 2 /nobreak >nul

echo Cleaning target...
if exist target (
  rmdir /s /q target 2>nul
  if exist target (
    echo Retrying clean...
    timeout /t 3 /nobreak >nul
    rmdir /s /q target
  )
)

echo Building...
call mvn package -q
if errorlevel 1 (
  echo BUILD FAILED
  pause
  exit /b 1
)

echo Deploying...
rmdir /s /q "%CATALINA_HOME%\webapps\BloodDonation" 2>nul
del /q "%CATALINA_HOME%\webapps\BloodDonation.war" 2>nul
rmdir /s /q "%CATALINA_HOME%\work\Catalina\localhost\BloodDonation" 2>nul
copy /y target\BloodDonation.war "%CATALINA_HOME%\webapps\BloodDonation.war"

echo Starting Tomcat...
call "%CATALINA_HOME%\bin\startup.bat"
echo.
echo Open: http://localhost:%PORT%/BloodDonation/  (then Ctrl+Shift+R)
pause