@echo off
setlocal enabledelayedexpansion

cls

echo.
echo ==========================================
echo.
echo           NostagiaCore Installer
echo.
echo ==========================================
echo.

for /f %%i in ('powershell -command "(Invoke-WebRequest -Uri 'https://api.github.com/repos/kotyaralih/NostalgiaCore/releases/latest' | ConvertFrom-Json).tag_name"') do set latest_release=%%i

if "%latest_release%"=="" (
    echo Error: Could not retrieve the latest release. Please retry manually.
    pause
    exit /b
)

echo Latest release: %latest_release%
echo.

:menu
echo Select installation option:
echo 1) Install PHP and Core
echo 2) Install PHP only
echo 3) Install Core only
echo.
set /p choice="Your choice: "

if "%choice%"=="1" goto install_both
if "%choice%"=="2" goto install_php
if "%choice%"=="3" goto install_core
echo Invalid choice, try again.
goto menu

:install_php
echo [PHP] Downloading PHP_Windows_x64.zip...
powershell -command "Invoke-WebRequest -Uri 'https://github.com/kotyaralih/NostalgiaCore/releases/download/%latest_release%/PHP_Windows_x64.zip' -OutFile 'PHP_Windows_x64.zip'"
echo [PHP] Extracting...
powershell -command "Expand-Archive -Path 'PHP_Windows_x64.zip' -DestinationPath '.' -Force"
if exist "vc_redist.x64.exe" del "vc_redist.x64.exe"
echo [PHP] Deleting archive...
del "PHP_Windows_x64.zip"
echo [PHP] PHP installed!
goto :eof

:install_core
echo [CORE] Downloading NostalgiaCore-%latest_release%.zip...
powershell -command "Invoke-WebRequest -Uri 'https://github.com/kotyaralih/NostalgiaCore/archive/refs/tags/%latest_release%.zip' -OutFile 'NostalgiaCore-%latest_release%.zip'"
echo [CORE] Extracting...
powershell -command "Expand-Archive -Path 'NostalgiaCore-%latest_release%.zip' -DestinationPath '.' -Force"
if exist "NostalgiaCore-%latest_release%" (
    xcopy "NostalgiaCore-%latest_release%\*.*" "*.*" /e /i /h /y
    rd /s /q "NostalgiaCore-%latest_release%"
)
echo [CORE] Deleting archive...
del "NostalgiaCore-%latest_release%.zip"
echo [CORE] Core installed!
goto :eof

:install_both
call :install_php
call :install_core
echo Installation complete! To start the server, run the start.bat file.
pause