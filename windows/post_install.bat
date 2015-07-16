@echo off

set "INSTALL_DIR=%1"
if "%INSTALL_DIR%" == "" set "INSTALL_DIR=%cd%"

echo "Setting up Environmental Variables..."

setx /M CATALINA_HOME "%INSTALL_DIR%\tomcat"

setx /M path "%INSTALL_DIR%\tools\im;%INSTALL_DIR%\tools\gs\bin;%INSTALL_DIR%\tools\lo\program;%PATH%"

reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Artifex\GPL Ghostscript\9.16" /f /v "" /t REG_SZ /d "%INSTALL_DIR%\tools\gs"

echo "Installing Tomcat8 Service..."

call "%INSTALL_DIR%\tomcat\bin\service.bat" install

echo "Starting Tomcat8..."

start %INSTALL_DIR%\tomcat\bin\tomcat8w.exe start

echo "Installation Complete..."

pause
