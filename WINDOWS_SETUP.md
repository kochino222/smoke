# 🚬 Smoke - Quit Smoking Tracker

Una aplicación Flutter para rastrear tu progreso al dejar de fumar, con 30 hitos de salud verificados científicamente.

## ✨ Características

- 📊 **Contador de tiempo** sin fumar en tiempo real
- 💰 **Cálculo de ahorros** (hoy, este mes, este año)
- 🎯 **Hitos de salud** con beneficios científicos verificados
- 📅 **Timeline de 30 hitos** desde 20 minutos hasta 20 años
- 🌍 **Bilingüe**: Español e Inglés
- 🎨 **Diseño Material 3** moderno y responsive

## 📱 Plataformas soportadas

- ✅ Web (Chrome)
- ✅ Windows Desktop
- ✅ macOS
- ✅ Linux
- ✅ Android
- ✅ iOS

## 🚀 Inicio rápido

### Requisitos previos

- Flutter 3.38.6 o superior
- Dart 3.10.7 o superior

### En Web (Chrome)

```bash
flutter run -d chrome
```

### En Windows Desktop

**Importante:** Visual Studio debe tener instalados los componentes de C++

#### Opción 1: Instalación automática

```bash
install_windows_deps.bat
```

Esto abrirá el Visual Studio Installer. Sigue estos pasos:

1. Haz clic en el botón con tres líneas (⋮) en la esquina superior derecha
2. Selecciona **Modify**
3. Marca la casilla **Desktop development with C++**
4. Asegúrate de que esté marcado:
   - MSVC v142 - VS 2019 C++ x64/x86 build tools
   - C++ CMake tools for Windows
   - Windows 10 SDK
5. Haz clic en **Modify** en la esquina inferior derecha
6. Espera a que se complete la instalación
7. Abre una nueva terminal y ejecuta:

```bash
flutter run -d windows
```

#### Opción 2: Instalación manual

1. Abre **Visual Studio Installer**
2. Busca tu versión de Visual Studio (ej: Community 2022)
3. Haz clic en **Modify**
4. Marca "Desktop development with C++"
5. Completa la instalación

```bash
flutter run -d windows
```

### En otras plataformas

```bash
# macOS
flutter run -d macos

# Linux
flutter run -d linux

# Android (si tienes dispositivo conectado)
flutter run -d android

# iOS (macOS)
flutter run -d ios
```

## 📂 Estructura del proyecto

```
lib/
├── main.dart                      # Entrada principal
├── screens/
│   ├── home_screen.dart          # Pantalla principal
│   ├── settings_screen.dart       # Configuración
│   └── health_timeline_screen.dart # Timeline de salud
├── services/
│   ├── storage_service.dart       # Persistencia de datos
│   ├── health_milestones_service.dart
│   └── health_timeline_service.dart
└── widgets/
    ├── health_benefits_card.dart
    ├── health_timeline_widget.dart
    ├── milestones_list_widget.dart
    ├── savings_breakdown_card.dart
    └── time_since_smoking_widget.dart

assets/
├── health_milestones_es.json      # Hitos básicos (8)
└── health_timeline_es_en.json     # Timeline completa (30, bilingüe)
```

## 🎯 Hitos de salud

30 hitos verificados científicamente desde:

- ✅ **WHO** (Organización Mundial de la Salud)
- ✅ **CDC** (Centers for Disease Control, EE.UU.)
- ✅ **NHS** (National Health Service, Reino Unido)
- ✅ **American Heart Association**

### Categorías de hitos

- 💓 **Cardio**: Salud del corazón y circulación
- 🫁 **Pulmón**: Capacidad y función pulmonar
- 🛡️ **Cáncer**: Reducción de riesgos
- 👃 **Sentidos**: Olfato y gusto
- ⚡ **Energía**: Stamina y salud mental
- ✨ **General**: Beneficios generales
- 🌍 **Ambiente**: Impacto ambiental

## 🛠️ Desarrollo

### Instalar dependencias

```bash
flutter pub get
```

### Ejecutar análisis de código

```bash
flutter analyze
```

### Ejecutar en modo debug

```bash
flutter run -d <device>
```

## 📝 Tecnologías utilizadas

- **Flutter**: Framework UI
- **Dart**: Lenguaje de programación
- **shared_preferences**: Almacenamiento local
- **intl**: Formateo de fechas y moneda

## 🔗 Fuentes de datos médicos

Todos los datos de salud están basados en fuentes oficiales:

- [WHO - Tobacco](https://www.who.int/teams/noncommunicable-diseases/tobacco-control)
- [CDC - Quit Smoking](https://www.cdc.gov/tobacco/quit_smoking/)
- [NHS - Stop Smoking Benefits](https://www.nhs.uk/smokefree/)
- [American Heart Association](https://www.heart.org/en/healthy-living/healthy-lifestyle/quit-smoking)

## 📄 Licencia

MIT

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Soporte

Para reportar bugs o sugerir features, abre un issue en GitHub.

---

**Hecho con ❤️ para ayudarte a dejar de fumar**
