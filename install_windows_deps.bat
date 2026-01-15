@echo off
REM Script para instalar componentes necesarios en Visual Studio para Flutter

echo.
echo ========================================
echo Instalando componentes Visual Studio
echo ========================================
echo.

REM Obtener la ruta de Visual Studio
for /f "tokens=*" %%A in ('where devenv.exe') do (
    set "VS_PATH=%%A"
    for /d %%B in ("%%A\..\..") do set "VS_DIR=%%B"
)

if not defined VS_DIR (
    echo Error: Visual Studio no encontrado
    echo Por favor, instala Visual Studio Community desde:
    echo https://visualstudio.microsoft.com/downloads/
    pause
    exit /b 1
)

echo Encontrado Visual Studio en: %VS_DIR%
echo.

REM Ruta del instalador de VS
set "VS_INSTALLER=%VS_DIR%\vs_installer.exe"

if not exist "%VS_INSTALLER%" (
    REM Intentar con el ejecutable del Visual Studio Installer
    set "VS_INSTALLER=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe"
)

if not exist "%VS_INSTALLER%" (
    REM Última opción
    set "VS_INSTALLER=C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
)

if not exist "%VS_INSTALLER%" (
    echo Error: No se pudo encontrar el instalador de Visual Studio
    echo Por favor, ejecuta el Visual Studio Installer manualmente
    pause
    exit /b 1
)

echo.
echo Ejecutando Visual Studio Installer...
echo Por favor, marca "Desktop development with C++" workload
echo.
pause

start "" "%VS_INSTALLER%"

echo.
echo Esperando que finalices la instalación...
echo Presiona cualquier tecla cuando hayas terminado
pause

echo.
echo Verificando instalación...
flutter doctor

pause
