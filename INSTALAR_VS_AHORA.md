# 🪟 Visual Studio para Windows - Guía Rápida

## ❌ Problema

Visual Studio Community no está instalado en tu sistema. Es **obligatorio** para ejecutar Flutter en Windows.

## ✅ Solución: Instalar Visual Studio Community

### Paso 1: Descargar

**Opción A - Descargar manualmente (Recomendado):**

1. Ve a: https://visualstudio.microsoft.com/downloads/
2. Busca **"Visual Studio Community 2022"**
3. Haz clic en **"Download"** (botón azul)

**Opción B - Descargar directamente:**

Link directo: https://aka.ms/vs/17/release/vs_community.exe

---

### Paso 2: Ejecutar el instalador

1. Doble-click en `vs_community.exe` que descargaste
2. Espera a que se abra la ventana del instalador
3. Esto puede tomar 1-2 minutos

---

### Paso 3: Seleccionar componentes

Cuando se abra el instalador, verás una pantalla con varias opciones:

**Busca la tarjeta que dice:**
```
Desktop development with C++
```

**Marca la casilla** ☑️ al lado de esa opción.

---

### Paso 4: Verificar componentes específicos

En el panel derecho ("Installation details"), **asegúrate que estén marcadas:**

```
✅ MSVC v143 - VS 2022 C++ x64/x86 build tools
✅ C++ CMake tools for Windows
✅ Windows 10 SDK (la versión más reciente disponible)
```

Si alguna no está marcada, haz click para marcarla.

---

### Paso 5: Instalar

1. Haz clic en el botón **"Install"** en la esquina inferior derecha
2. Se abrirá una ventana que descargará e instalará los componentes
3. **Esto puede tomar 15-30 minutos** (depende de tu conexión)
4. **No cierres la ventana** mientras está descargando e instalando

---

### Paso 6: Finalizar

1. Una vez que termine, verás un mensaje de éxito
2. Si pide reiniciar, **reinicia tu computadora**
3. Abre una **terminal nueva** (PowerShell o CMD)

---

## ✔️ Verificar que está instalado

Abre una terminal nueva y ejecuta:

```bash
flutter doctor -v
```

**Deberías ver algo como esto:**

```
[✓] Visual Studio - develop Windows apps (Visual Studio Community 2022 17.x.x)
    ✓ Visual Studio at C:\Program Files\Microsoft Visual Studio\2022\Community
    ✓ Windows 10 SDK [version 10.0.xxxxx]
```

Si ves ✓ (verde), ¡todo está correcto!

---

## 🚀 Ahora sí: Ejecutar en Windows

Una vez que todo esté instalado:

```bash
flutter run -d windows
```

La aplicación se abrirá en una ventana de Windows.

---

## 🆘 Si algo falla

### Error: "Windows 10 SDK not found"
- Vuelve al instalador de Visual Studio
- Opción: "Modify" → Marca Windows 10 SDK

### Error: "CMake not found"
- Vuelve al instalador de Visual Studio
- Opción: "Modify" → Marca "C++ CMake tools for Windows"

### Error: "MSVC not found"
- Vuelve al instalador de Visual Studio
- Opción: "Modify" → Marca "MSVC v143"

---

## 📞 Necesitas ayuda?

Si tienes problemas:

1. Ejecuta: `flutter doctor -v`
2. Copia el error
3. Abre un issue en GitHub: https://github.com/kochino222/smoke/issues

---

**Tiempo estimado:** 20-40 minutos (la mayoría es descarga)

**Una vez hecho:** No tendrás que hacerlo de nuevo.
