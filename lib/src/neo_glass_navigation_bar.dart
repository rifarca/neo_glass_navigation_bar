import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'neo_glass_layer_config.dart';
import 'neo_glass_nav_item.dart';
import 'neo_glass_surface.dart';

/// Barra de navegación inferior flotante con efecto **iOS Liquid Glass**,
/// construida sobre un [Stack] multicapa con desenfoque y bordes redondeados.
class NeoGlassNavigationBar extends StatelessWidget {
  /// Índice actualmente seleccionado.
  final int currentIndex;

  /// Callback disparado al seleccionar un ítem.
  final ValueChanged<int> onTap;

  /// Lista de destinos de navegación (mínimo 2).
  final List<NeoGlassNavItem> items;

  /// Configuración de la capa base de cristal (fondo principal).
  /// Si es `null`, se adapta automáticamente al brillo del tema actual.
  final NeoGlassLayerConfig? baseLayer;

  /// Configuración de la cápsula flotante del ítem activo.
  /// Si es `null`, se adapta automáticamente al brillo del tema actual.
  final NeoGlassLayerConfig? activePillLayer;

  /// Capa intermedia opcional para añadir profundidad o tinte extra en el [Stack].
  final NeoGlassLayerConfig? depthLayer;

  /// Margen exterior respecto a los bordes de la pantalla.
  final EdgeInsetsGeometry margin;

  /// Altura total del contenedor de navegación.
  final double height;

  /// Padding interno entre el borde exterior y la cápsula activa.
  final EdgeInsetsGeometry innerPadding;

  /// Color para el icono y texto del ítem activo.
  final Color? selectedItemColor;

  /// Color para los iconos y textos inactivos.
  final Color? unselectedItemColor;

  /// Muestra u oculta las etiquetas debajo de cada icono.
  final bool showLabels;

  /// Activa vibración háptica ligera al cambiar de tab.
  final bool enableHaptics;

  /// Duración de la animación de desplazamiento de la cápsula líquida.
  final Duration animationDuration;

  /// Curva de animación de la cápsula líquida.
  final Curve animationCurve;

  const NeoGlassNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.baseLayer,
    this.activePillLayer,
    this.depthLayer,
    this.margin = const EdgeInsets.fromLTRB(18, 0, 18, 18),
    this.height = 72,
    this.innerPadding = const EdgeInsets.all(6),
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showLabels = true,
    this.enableHaptics = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
  }) : assert(items.length >= 2, 'NeoGlassNavigationBar requiere al menos 2 ítems.'),
       assert(
         currentIndex >= 0 && currentIndex < items.length,
         'currentIndex debe estar dentro del rango de items.',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBase = baseLayer ??
        (isDark
            ? NeoGlassLayerConfig.iosDarkBase()
            : NeoGlassLayerConfig.iosLightBase());

    final resolvedPill = activePillLayer ??
        NeoGlassLayerConfig.iosActivePill(isDark: isDark);

    final activeColor = selectedItemColor ?? theme.colorScheme.primary;
    final inactiveColor = unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.72 : 0.68);

    return SafeArea(
      top: false,
      child: Container(
        margin: margin,
        height: height,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // CAPA 1: Base Liquid Glass (desenfoque profundo + borde redondeado)
            Positioned.fill(
              child: NeoGlassSurface(
                config: resolvedBase,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.36 : 0.12),
                    blurRadius: 28,
                    spreadRadius: -2,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
            ),

            // CAPA 2: Capa de profundidad/tinte intermedia en el Stack
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: IgnorePointer(
                  child: NeoGlassSurface(
                    config: depthLayer ??
                        NeoGlassLayerConfig(
                          enableBlur: false,
                          tintColor: Colors.white,
                          opacity: 0.0,
                          borderRadius: (resolvedBase.borderRadius - 1.5)
                              .clamp(0.0, 200.0),
                          borderWidth: 0,
                          gradientColors: [
                            Colors.white.withValues(alpha: isDark ? 0.14 : 0.42),
                            Colors.transparent,
                            Colors.white.withValues(alpha: isDark ? 0.04 : 0.12),
                          ],
                        ),
                  ),
                ),
              ),
            ),

            // CAPA 3: Reflejo especular superior estilo iOS Liquid Glass
            Positioned(
              top: 1,
              left: resolvedBase.borderRadius * 0.55,
              right: resolvedBase.borderRadius * 0.55,
              height: 1.4,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.0),
                        Colors.white.withValues(alpha: isDark ? 0.42 : 0.85),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // CAPA 4: Cápsula activa deslizante con su propio efecto glass
            Positioned.fill(
              child: Padding(
                padding: innerPadding,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final slotWidth = constraints.maxWidth / items.length;
                    return Stack(
                      children: [
                        AnimatedPositioned(
                          duration: animationDuration,
                          curve: animationCurve,
                          left: currentIndex * slotWidth,
                          top: 0,
                          bottom: 0,
                          width: slotWidth,
                          child: NeoGlassSurface(
                            config: resolvedPill,
                            boxShadow: [
                              BoxShadow(
                                color: activeColor.withValues(
                                  alpha: isDark ? 0.22 : 0.14,
                                ),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // CAPA 5: Ítems interactivos
            Positioned.fill(
              child: Padding(
                padding: innerPadding,
                child: Row(
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    final isSelected = index == currentIndex;
                    final color = isSelected ? activeColor : inactiveColor;

                    return Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            resolvedPill.borderRadius,
                          ),
                          onTap: () {
                            if (enableHaptics && index != currentIndex) {
                              HapticFeedback.selectionClick();
                            }
                            onTap(index);
                          },
                          child: AnimatedScale(
                            scale: isSelected ? 1.03 : 0.98,
                            duration: animationDuration,
                            curve: animationCurve,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? (item.activeIcon ?? item.icon)
                                          : item.icon,
                                      size: 23,
                                      color: color,
                                    ),
                                    if (item.badge != null)
                                      Positioned(
                                        right: -8,
                                        top: -4,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.5,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: activeColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            item.badge!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (showLabels) ...[
                                  const SizedBox(height: 3),
                                  Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: color,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
