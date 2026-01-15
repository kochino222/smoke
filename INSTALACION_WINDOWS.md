# 🪟 Guía de instalación para Windows

## 📋 Requisitos para ejecutar Smoke en Windows

Para ejecutar la aplicación en Windows necesitas:
- Visual Studio Community 2022 con componentes de C++
- Flutter SDK
- Windows 10 o superior

## 🔧 Pasos para instalar Visual Studio Community

### Opción 1: Instalación automática (Recomendado)

```bash
install_vs.bat
```

Este script:
1. ✅ Descargará Visual Studio Community
2. ✅ Abrirá el instalador
3. ✅ Te guiará en la selección de componentes

Sigue las instrucciones que aparecerán en pantalla.

### Opción 2: Instalación manual

1. **Descargar Visual Studio Community:**
   - Ve a: https://visualstudio.microsoft.com/downloads/
   - Descarga "Visual Studio Community 2022"
   - Ejecuta el instalador descargado

2. **Seleccionar componentes:**
   - Cuando se abra el instalador, haz clic en "Desktop development with C++"
   - **Verifica que estén marcados estos componentes:**
     - ✅ MSVC v143 - VS 2022 C++ x64/x86 build tools
     - ✅ C++ CMake tools for Windows
     - ✅ Windows 10 SDK (versión más reciente)

3. **Instalar:**
   - Haz clic en el botón "Install" en la esquina inferior derecha
   - Espera a que complete (puede tomar 15-30 minutos)
   - Reinicia tu computadora si te lo pide

## ✅ Verificar la instalación

Después de instalar Visual Studio, abre una terminal nueva y ejecuta:

```bash
flutter doctor -v
```

Deberías ver algo como:

```
[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.x.x)
    ✓ Visual Studio at C:\Program Files\Microsoft Visual Studio\2022\Community
    ✓ Windows 10 SDK [version]
```

Si ves errores rojos ❌, significa que faltan componentes. Vuelve al Visual Studio Installer y agrega los componentes faltantes.

## 🚀 Ejecutar la aplicación en Windows

Una vez que `flutter doctor` muestre Visual Studio correcto (✓), ejecuta:

```bash
flutter run -d windows
```

La aplicación se abrirá en una ventana de Windows.

## 🔄 Hotkey durante ejecución

Mientras la app está corriendo en Windows:
- `r` - Hot reload (recarga con cambios menores)
- `R` - Hot restart (reinicia la app completamente)
- `q` - Salir de la app
- `h` - Ver todos los comandos

## 🐛 Solución de problemas

### Problema: "Unable to find suitable Visual Studio toolchain"

**Solución:** Instala los componentes faltantes en Visual Studio:
1. Abre "Visual Studio Installer" (desde el menú Inicio)
2. Busca tu versión de Visual Studio (ej: Community 2022)
3. Haz clic en el botón con tres puntos ⋮ → "Modify"
4. Marca "Desktop development with C++"
5. Haz clic en "Modify" nuevamente en la parte inferior

### Problema: "Cannot find Windows SDK"

**Solución:** Re-ejecuta el Visual Studio Installer y asegúrate que está marcado:
- Windows 10 SDK (versión más reciente)

### Problema: "CMake not found"

**Solución:** En el Visual Studio Installer, verifica que esté marcado:
- C++ CMake tools for Windows

## 📞 Ayuda adicional

Si tienes problemas:
1. Ejecuta `flutter doctor -v` para ver el diagnóstico completo
2. Copia la salida en un issue de GitHub
3. Verifica: https://flutter.dev/setup/windows

---

**Nota:** Este es un requisito único. Una vez instalado Visual Studio, no necesitarás hacerlo de nuevo.
