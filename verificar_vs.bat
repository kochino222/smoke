@echo off
REM Script mejorado para detectar e instalar Visual Studio

setlocal enabledelayedexpansion

color 0F
title Verificador de Visual Studio para Flutter

echo.
echo ===============================================
echo   Verificando Visual Studio para Flutter
echo ===============================================
echo.

REM Verificar si Visual Studio esta instalado
echo Buscando Visual Studio instalado...
echo.

set "VS_FOUND=0"

REM Buscar en ubicaciones comunes
set "VS_PATHS=C:\Program Files\Microsoft Visual Studio\2022\Community"
set "VS_PATHS=%VS_PATHS%;C:\Program Files (x86)\Microsoft Visual Studio\2022\Community"
set "VS_PATHS=%VS_PATHS%;C:\Program Files\Microsoft Visual Studio\2022\Professional"
set "VS_PATHS=%VS_PATHS%;C:\Program Files (x86)\Microsoft Visual Studio\2022\Professional"

for %%V in (%VS_PATHS%) do (
    if exist "%%V" (
        echo [OK] Encontrado: %%V
        set "VS_FOUND=1"
        set "VS_PATH=%%V"
    )
)

if !VS_FOUND! equ 1 (
    echo.
    echo Verificando componentes necesarios...
    echo.
    
    if exist "!VS_PATH!\VC\Redist\MSVC" (
        echo [OK] MSVC encontrado
    ) else (
        echo [!] MSVC podria estar incompleto
    )
    
    echo.
    echo Visual Studio esta instalado.
    echo Ejecuta: flutter doctor -v
    echo.
    echo para verificar todos los componentes.
    echo.
) else (
    echo.
    echo [X] Visual Studio NO esta instalado
    echo.
    echo ===============================================
    echo   ACCION REQUERIDA
    echo ===============================================
    echo.
    echo Necesitas instalar Visual Studio Community con
    echo el soporte para C++.
    echo.
    echo Opcion 1: Descarga manual (RECOMENDADO)
    echo ____________________________________________
    echo 1. Ve a: https://visualstudio.microsoft.com/downloads/
    echo 2. Haz clic en "Visual Studio Community 2022"
    echo 3. Ejecuta el instalador
    echo 4. Cuando aparezca la pantalla de workloads,
    echo    marca "Desktop development with C++"
    echo 5. En la seccion de detalles, verifica que esten
    echo    estos componentes marcados:
    echo    - MSVC v143 - VS 2022 C++ x64/x86 build tools
    echo    - C++ CMake tools for Windows
    echo    - Windows 10 SDK ^(version mas reciente^)
    echo 6. Haz clic en "Install"
    echo.
    echo Opcion 2: Descargar automaticamente
    echo ____________________________________________
    echo Ejecuta este comando en PowerShell como Admin:
    echo.
    echo   powershell -Command "Start-Process 'https://aka.ms/vs/17/release/vs_community.exe' -Wait"
    echo.
    echo ===============================================
    echo.
    echo Una vez instalado Visual Studio, vuelve a ejecutar
    echo este script para verificar.
    echo.
)

echo.
echo Presiona una tecla para continuar...
pause >nul

endlocal
