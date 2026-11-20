# NeoGlassNavigator

![pub package](https://img.shields.io/badge/pub-v0.1.0-0A84FF.svg)
![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.19.0-02569B.svg?logo=flutter)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

Un paquete de Flutter que implementa una barra de navegación estilo **iOS Liquid Glass**, construida íntegramente sobre una arquitectura de `Stack`**&#x20;multicapa** con desenfoque (`BackdropFilter`), transparencia calibrada, bordes redondeados, reflejos especulares, soporte *hover* y adaptación automática a modo claro y oscuro.

---

## 📸 Screenshots (Light & Dark Mode)

| Light Mode – Flotante (`bottom`) | Dark Mode – Flotante (`bottom`) |
| :---: | :---: |
| ![Light Mode Floating](screenshots/light_floating.png) | ![Dark Mode Floating](screenshots/dark_floating.png) |
| *Acabado cristalino claro sobre tarjetas y mapas con cápsula activa elevada.* | *Tinte oscuro translúcido (`#1C1C1E`) con reflejo especular superior.* |

| Light Mode – `bottomNavigationBar` (`dockedBottom`) | Dark Mode – Custom & Hover State |
| :---: | :---: |
| ![Light Mode Docked](screenshots/light_docked.png) | ![Dark Mode Custom Hover](screenshots/dark_custom_hover.png) |
| *Integrado directamente en `Scaffold.bottomNavigationBar` con esquinas superiores redondeadas.* | *Personalización de badges, tipografía, tintes y halo interactivo al hacer hover.* |

> **Nota para tu repositorio:** Guarda tus capturas en la carpeta `screenshots/` en la raíz del paquete con los nombres `light_floating.png`, `dark_floating.png`, `light_docked.png` y `dark_custom_hover.png` para que se rendericen automáticamente en GitHub y `pub.dev`.

---

## ✨ Características Principales

- **Arquitectura&#x20;**`Stack`**&#x20;Multicapa:** separa la sombra ambiental, la capa base con `ImageFilter.blur`, el gradiente de profundidad, el reflejo especular superior, la cápsula activa deslizante y el halo *hover*.
- **Versatilidad de Posición (**`NeoGlassPosition`**):** úsalo flotando sobre un `Stack`, anclado arriba (`top`), con control libre (`custom`) o directamente en `Scaffold.bottomNavigationBar` (`dockedBottom`).
- **Adaptación Automática Claro/Oscuro:** ajusta tinte, opacidad y bordes según `Theme.of(context).brightness` si no especificas capas personalizadas.
- **Soporte Desktop/Web Hover:** incluye `MouseRegion` con escala animada (`hoverScale`), color activo (`hoverItemColor`) y capa *glass* dedicada (`hoverLayer`).
- **Control Total:** personaliza blur, transparencia, tipografía, iconos, colores y badges con facilidad.

---

## 📦 Instalación

Agrega `neo_glass_navigator` a tu archivo `pubspec.yaml`:

### Desde carpeta local

```yaml
dependencies:
  flutter:
    sdk: flutter
  neo_glass_navigator:
    path: ../neo_glass_navigator
```

### Desde Git

```yaml
dependencies:
  flutter:
    sdk: flutter
  neo_glass_navigator:
    git:
      url: https://github.com/tu-usuario/neo_glass_navigator.git
      ref: main
```

Luego instala las dependencias:

```bash
flutter pub get
```

---

## 🚀 Uso Básico

### Opción 1: Flotante dentro de un `Stack` (Recomendado para efecto Liquid Glass)

Activa `extendBody: true` en el `Scaffold` para que el contenido se desplace por detrás del cristal y el `BackdropFilter` difumine los elementos en tiempo real:

```dart
import 'package:flutter/material.dart';
import 'package:neo_glass_navigator/neo_glass_navigator.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    Center(child: Text('Inicio')),
    Center(child: Text('Explorar')),
    Center(child: Text('Rutas')),
    Center(child: Text('Perfil')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // 1. Contenido de fondo
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: _tabs,
            ),
          ),

          // 2. Navegador flotante Liquid Glass
          Align(
            alignment: Alignment.bottomCenter,
            child: NeoGlassNavigator(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: const [
                NeoGlassNavItem(
                  label: 'Inicio',
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                ),
                NeoGlassNavItem(
                  label: 'Explorar',
                  icon: Icons.map_outlined,
                  activeIcon: Icons.map_rounded,
                ),
                NeoGlassNavItem(
                  label: 'Rutas',
                  icon: Icons.route_outlined,
                  activeIcon: Icons.route_rounded,
                  badge: '2',
                ),
                NeoGlassNavItem(
                  label: 'Perfil',
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### Opción 2: Como `bottomNavigationBar` del `Scaffold`

Si prefieres integrarlo directamente en la propiedad `bottomNavigationBar` del `Scaffold`, usa `NeoGlassPosition.dockedBottom`:

```dart
Scaffold(
  extendBody: true,
  body: IndexedStack(
    index: _currentIndex,
    children: _tabs,
  ),
  bottomNavigationBar: NeoGlassNavigator(
    position: NeoGlassPosition.dockedBottom,
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
    items: const [
      NeoGlassNavItem(label: 'Inicio', icon: Icons.home_rounded),
      NeoGlassNavItem(label: 'Explorar', icon: Icons.map_rounded),
      NeoGlassNavItem(label: 'Perfil', icon: Icons.person_rounded),
    ],
  ),
);
```

---

## 🎨 Uso Customizado y Tuning Avanzado

Puedes ajustar rápidamente el desenfoque (`blurSigma`) y la transparencia (`glassOpacity`) desde el widget principal, o configurar cada capa del `Stack` mediante `NeoGlassLayerConfig` (incluyendo *hover*, tipografía, colores y *badges*):

```dart
NeoGlassNavigator(
  position: NeoGlassPosition.bottom,
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  height: 74,
  margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),

  // Atajos rápidos de blur y transparencia
  blurSigma: 26,
  glassOpacity: 0.28,

  // Colores e iconos
  iconSize: 24,
  iconLabelSpacing: 4,
  selectedItemColor: const Color(0xFF0A84FF),
  unselectedItemColor: Colors.grey.shade600,

  // Tipografía personalizada
  labelStyle: const TextStyle(
    fontSize: 11,
    letterSpacing: 0.2,
  ),
  selectedLabelStyle: const TextStyle(
    fontSize: 11.5,
    fontWeight: FontWeight.w800,
  ),
  unselectedLabelStyle: const TextStyle(
    fontWeight: FontWeight.w500,
  ),

  // Personalización de Badges
  badgeColor: Colors.redAccent,
  badgeTextColor: Colors.white,
  badgeOffset: const Offset(-10, -5),
  badgeTextStyle: const TextStyle(
    fontSize: 9.5,
    fontWeight: FontWeight.w800,
  ),

  // Efecto Hover (Web / Desktop)
  hoverScale: 1.06,
  hoverItemColor: const Color(0xFF0A84FF),
  hoverLayer: NeoGlassLayerConfig(
    enableBlur: false,
    tintColor: const Color(0xFF0A84FF),
    opacity: 0.12,
    borderRadius: 22,
    borderColor: const Color(0x440A84FF),
    borderWidth: 1.0,
  ),

  // Tuning granular de la capa base
  baseLayer: NeoGlassLayerConfig(
    blurSigmaX: 26,
    blurSigmaY: 26,
    tintColor: Colors.white,
    opacity: 0.28,
    borderRadius: 32,
    borderColor: const Color(0x88FFFFFF),
    borderWidth: 1.3,
    gradientColors: [
      Colors.white.withValues(alpha: 0.46),
      Colors.white.withValues(alpha: 0.16),
    ],
  ),

  // Tuning granular de la cápsula activa
  activePillLayer: NeoGlassLayerConfig(
    blurSigmaX: 12,
    blurSigmaY: 12,
    tintColor: Colors.white,
    opacity: 0.52,
    borderRadius: 24,
    borderColor: const Color(0xAAFFFFFF),
    borderWidth: 1.1,
  ),

  items: const [
    NeoGlassNavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    NeoGlassNavItem(
      label: 'Explorar',
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded,
    ),
    NeoGlassNavItem(
      label: 'Rutas',
      icon: Icons.route_outlined,
      activeIcon: Icons.route_rounded,
      badge: '3',
    ),
    NeoGlassNavItem(
      label: 'Perfil',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ],
);
```

---

## 🛠️ Guía Rápida de Calibración (Tuning)

1. **Sobre fondos muy claros:** sube `glassOpacity` a `0.30–0.38` y mantén `borderColor` con alfa alto (`0x88FFFFFF`) para que el contorno de cristal destaque.
2. **Sobre mapas o fotos con mucho detalle:** usa `blurSigma` entre `22` y `28` para suavizar el ruido visual debajo de los iconos.
3. **Profundidad entre capas:** mantén un `blur` más alto en `baseLayer` (`24`) y más bajo en `activePillLayer` (`10–14`), respetando radios concéntricos (`baseLayer.borderRadius - innerPadding`).
4. **Rendimiento:** deja `enableBlur: false` en `depthLayer` y `hoverLayer` para evitar apilar múltiples `BackdropFilter` redundantes en la misma área.

---

## 📄 Licencia

Distribuido bajo la licencia MIT. Consulta el archivo `LICENSE` para más información.
