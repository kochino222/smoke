@echo off
REM Script para descargar e instalar Visual Studio Community con componentes para Flutter

setlocal enabledelayedexpansion

echo.
echo ========================================
echo Visual Studio Community - Instalador
echo ========================================
echo.
echo Este script descargara e instalara Visual Studio Community
echo con los componentes necesarios para Flutter en Windows.
echo.

REM Verificar conexion a internet
ping google.com -n 1 >nul 2>&1
if errorlevel 1 (
    echo ERROR: No hay conexion a internet
    echo Por favor, verifica tu conexion
    pause
    exit /b 1
)

echo Descargando Visual Studio Installer...
echo.

REM URL del instalador
set "VS_INSTALLER_URL=https://aka.ms/vs/17/release/vs_community.exe"
set "INSTALLER_PATH=%TEMP%\vs_community.exe"

REM Descargar usando PowerShell
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object System.Net.WebClient).DownloadFile('%VS_INSTALLER_URL%', '%INSTALLER_PATH%')"

if not exist "%INSTALLER_PATH%" (
    echo ERROR: No se pudo descargar el instalador
    echo Intenta descargar manualmente desde:
    echo https://visualstudio.microsoft.com/downloads/
    pause
    exit /b 1
)

echo.
echo ========================================
echo Iniciando instalador
echo ========================================
echo.
echo Se abrira el instalador de Visual Studio.
echo.
echo IMPORTANTE: Selecciona estos componentes:
echo [1] En la pantalla inicial, busca "Desktop development with C++"
echo [2] Marca la casilla al lado
echo [3] En el panel derecho, verifica que esten marcados:
echo     - MSVC v143 - VS 2022 C++ x64/x86 build tools
echo     - C++ CMake tools for Windows
echo     - Windows 10 SDK
echo [4] Haz clic en INSTALL en la esquina inferior derecha
echo [5] Espera a que termine la instalacion
echo.
pause

REM Ejecutar el instalador con los parametros correctos
echo Abriendo instalador...
start "" "%INSTALLER_PATH%"

echo.
echo El instalador se ha abierto. 
echo Por favor sigue las instrucciones anteriores.
echo.
echo Una vez que termine la instalacion, vuelve a esta ventana y presiona una tecla.
pause

echo.
echo Verificando instalacion...
flutter doctor -v

echo.
echo Si flutter doctor muestra "Visual Studio" sin errores, todo esta correcto!
echo.
echo Ahora puedes ejecutar:
echo   flutter run -d windows
echo.
pause
