# neo_glass_navigation_bar

Paquete Flutter que implementa **`NeoGlassNavigationBar`**, un navegador inferior flotante con estética **iOS Liquid Glass** construido íntegramente sobre un **`Stack` multicapa**, donde cada capa aporta desenfoque (`BackdropFilter`), transparencia graduada, bordes redondeados y reflejos especulares.

## Arquitectura por capas (`Stack`)

1. **Capa 0 – Sombra ambiental difusa:** elevación suave que separa el dock del fondo sin perder translucidez.
2. **Capa 1 – Base Liquid Glass (`baseLayer`):** `ClipRRect` + `BackdropFilter` con desenfoque profundo, tinte translúcido y degradado direccional.
3. **Capa 2 – Brillo especular y borde de refracción (`specularLayer`):** reflejo superior tipo cristal líquido de iOS que simula refracción de luz en el contorno redondeado.
4. **Capa 3 – Cápsula activa deslizante (`activePillLayer`):** segunda superficie *glass* independiente que se anima suavemente (`AnimatedPositioned`) detrás del tab seleccionado.
5. **Capa 4 – Contenido interactivo:** iconos y etiquetas con transiciones suaves de escala y color.

## Uso rápido

```dart
import 'package:flutter/material.dart';
import 'package:neo_glass_navigation_bar/neo_glass_navigation_bar.dart';

Scaffold(
  extendBody: true,
  body: Stack(
    children: [
      Positioned.fill(child: currentPage),
      Align(
        alignment: Alignment.bottomCenter,
        child: NeoGlassNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
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
```
