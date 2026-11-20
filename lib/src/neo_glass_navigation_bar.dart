import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'neo_glass_layer_config.dart';
import 'neo_glass_nav_item.dart';
import 'neo_glass_surface.dart';

/// Define cómo se posiciona [NeoGlassNavigationBar] en pantalla o dentro de un [Stack].
enum NeoGlassPosition {
  /// Flotante en la parte inferior con márgenes y SafeArea inferior.
  bottom,

  /// Pegado al borde inferior (ideal para usar en `Scaffold.bottomNavigationBar`
  /// con esquinas superiores redondeadas).
  dockedBottom,

  /// Flotante en la parte superior con SafeArea superior.
  top,

  /// Sin posicionamiento propio: deja el control total al widget padre (`Stack`, `Positioned`, etc.).
  custom,
}

/// Barra de navegación con efecto **iOS Liquid Glass**, construida sobre un
/// [Stack] multicapa con desenfoque, hover, transparencia y bordes redondeados.
class NeoGlassNavigationBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NeoGlassNavItem> items;

  /// Posición preconfigurada del navegador.
  final NeoGlassPosition position;

  /// Atajo directo para ajustar el blur principal (si es `null`, usa `baseLayer`).
  final double? blurSigma;

  /// Atajo directo para ajustar la transparencia/opacidad de la capa base (0.0 a 1.0).
  final double? glassOpacity;

  /// Capa base del cristal (fondo principal).
  final NeoGlassLayerConfig? baseLayer;

  /// Capa de la cápsula activa deslizante.
  final NeoGlassLayerConfig? activePillLayer;

  /// Capa intermedia opcional en el [Stack].
  final NeoGlassLayerConfig? depthLayer;

  /// Capa glass al pasar el cursor (hover) sobre un ítem.
  final NeoGlassLayerConfig? hoverLayer;

  /// Escala al hacer hover sobre un ítem inactivo.
  final double hoverScale;

  /// Color del texto/icono al hacer hover (si es `null`, usa `selectedItemColor` o `unselectedItemColor`).
  final Color? hoverItemColor;

  /// Margen exterior (si es `null`, se calcula según [position]).
  final EdgeInsetsGeometry? margin;

  /// Altura del contenedor de navegación.
  final double height;

  /// Padding interno entre el borde exterior y los ítems.
  final EdgeInsetsGeometry innerPadding;

  /// Tamaño de los iconos.
  final double iconSize;

  /// Separación entre icono y etiqueta.
  final double iconLabelSpacing;

  /// Color para icono y texto del ítem activo.
  final Color? selectedItemColor;

  /// Color para iconos y textos inactivos.
  final Color? unselectedItemColor;

  /// Estilo base de la etiqueta (se combina con [selectedLabelStyle] / [unselectedLabelStyle]).
  final TextStyle? labelStyle;

  /// Estilo adicional o de reemplazo para la etiqueta activa.
  final TextStyle? selectedLabelStyle;

  /// Estilo adicional o de reemplazo para etiquetas inactivas.
  final TextStyle? unselectedLabelStyle;

  /// Muestra u oculta las etiquetas debajo de cada icono.
  final bool showLabels;

  /// Color de fondo del badge.
  final Color? badgeColor;

  /// Color del texto del badge.
  final Color? badgeTextColor;

  /// Estilo de texto personalizado para el badge.
  final TextStyle? badgeTextStyle;

  /// Desplazamiento del badge respecto a la esquina superior derecha del icono.
  final Offset badgeOffset;

  /// Activa vibración háptica al cambiar de tab.
  final bool enableHaptics;

  /// Duración de las animaciones.
  final Duration animationDuration;

  /// Curva de las animaciones.
  final Curve animationCurve;

  const NeoGlassNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.position = NeoGlassPosition.bottom,
    this.blurSigma,
    this.glassOpacity,
    this.baseLayer,
    this.activePillLayer,
    this.depthLayer,
    this.hoverLayer,
    this.hoverScale = 1.05,
    this.hoverItemColor,
    this.margin,
    this.height = 72,
    this.innerPadding = const EdgeInsets.all(6),
    this.iconSize = 23,
    this.iconLabelSpacing = 3,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.labelStyle,
    this.selectedLabelStyle,
    this.unselectedLabelStyle,
    this.showLabels = true,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeTextStyle,
    this.badgeOffset = const Offset(-8, -4),
    this.enableHaptics = true,
    this.animationDuration = const Duration(milliseconds: 280),
    this.animationCurve = Curves.easeOutCubic,
  })  : assert(items.length >= 2,
            'NeoGlassNavigationBar requiere al menos 2 ítems.'),
        assert(
          currentIndex >= 0 && currentIndex < items.length,
          'currentIndex debe estar dentro del rango de items.',
        );

  @override
  State<NeoGlassNavigationBar> createState() => _NeoGlassNavigationBarState();
}

class _NeoGlassNavigationBarState extends State<NeoGlassNavigationBar> {
  int? _hoveredIndex;

  EdgeInsetsGeometry _effectiveMargin() {
    if (widget.margin != null) return widget.margin!;
    switch (widget.position) {
      case NeoGlassPosition.bottom:
        return const EdgeInsets.fromLTRB(18, 0, 18, 18);
      case NeoGlassPosition.dockedBottom:
      case NeoGlassPosition.top:
      case NeoGlassPosition.custom:
        return EdgeInsets.zero;
    }
  }

  NeoGlassLayerConfig _resolveBaseLayer(bool isDark) {
    final bool isDocked = widget.position == NeoGlassPosition.dockedBottom;
    final double defaultRadius = isDocked ? 24.0 : 32.0;

    final config = widget.baseLayer ??
        (isDark
            ? NeoGlassLayerConfig.iosDarkBase(borderRadius: defaultRadius)
            : NeoGlassLayerConfig.iosLightBase(borderRadius: defaultRadius));

    final double? sigma = widget.blurSigma;
    final double? op = widget.glassOpacity;

    List<Color>? updatedGradient = config.gradientColors;
    if (op != null &&
        config.gradientColors != null &&
        config.gradientColors!.isNotEmpty) {
      updatedGradient = config.gradientColors!
          .map((c) => c.withValues(
              alpha: (c.a * (op / (config.opacity == 0 ? 1 : config.opacity)))
                  .clamp(0.0, 1.0)))
          .toList();
    }

    return config.copyWith(
      blurSigmaX: sigma ?? config.blurSigmaX,
      blurSigmaY: sigma ?? config.blurSigmaY,
      opacity: op ?? config.opacity,
      gradientColors: updatedGradient,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final resolvedBase = _resolveBaseLayer(isDark);
    final resolvedPill = widget.activePillLayer ??
        NeoGlassLayerConfig.iosActivePill(
          isDark: isDark,
          borderRadius: (resolvedBase.borderRadius - 8).clamp(12.0, 32.0),
        );
    final resolvedHover = widget.hoverLayer ??
        NeoGlassLayerConfig.iosHover(
          isDark: isDark,
          borderRadius: resolvedPill.borderRadius,
        );

    final activeColor = widget.selectedItemColor ?? theme.colorScheme.primary;
    final inactiveColor = widget.unselectedItemColor ??
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.72 : 0.68);
    final resolvedBadgeColor = widget.badgeColor ?? activeColor;
    final resolvedBadgeTextColor = widget.badgeTextColor ?? Colors.white;

    final effectiveHeight = widget.position == NeoGlassPosition.dockedBottom
        ? widget.height + MediaQuery.paddingOf(context).bottom
        : widget.height;

    Widget navigatorBody = Container(
      margin: _effectiveMargin(),
      height: effectiveHeight,
      padding: widget.position == NeoGlassPosition.dockedBottom
          ? EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom)
          : EdgeInsets.zero,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // CAPA 1: Base Liquid Glass
          Positioned.fill(
            child: NeoGlassSurface(
              config: resolvedBase,
              boxShadow: widget.position == NeoGlassPosition.dockedBottom
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.36 : 0.12,
                        ),
                        blurRadius: 28,
                        spreadRadius: -2,
                        offset: const Offset(0, 12),
                      ),
                    ],
            ),
          ),

          // CAPA 2: Profundidad / gradiente interno
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(1.5),
              child: IgnorePointer(
                child: NeoGlassSurface(
                  config: widget.depthLayer ??
                      NeoGlassLayerConfig(
                        enableBlur: false,
                        tintColor: Colors.white,
                        opacity: 0.0,
                        borderRadius:
                            (resolvedBase.borderRadius - 1.5).clamp(0.0, 200.0),
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

          // CAPA 3: Reflejo especular superior
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

          // CAPA 4: Hover glass + Cápsula activa deslizante
          Positioned.fill(
            child: Padding(
              padding: widget.innerPadding,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final slotWidth = constraints.maxWidth / widget.items.length;
                  return Stack(
                    children: [
                      if (_hoveredIndex != null &&
                          _hoveredIndex != widget.currentIndex)
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 160),
                          curve: Curves.easeOut,
                          left: _hoveredIndex! * slotWidth,
                          top: 0,
                          bottom: 0,
                          width: slotWidth,
                          child: IgnorePointer(
                            child: NeoGlassSurface(config: resolvedHover),
                          ),
                        ),
                      AnimatedPositioned(
                        duration: widget.animationDuration,
                        curve: widget.animationCurve,
                        left: widget.currentIndex * slotWidth,
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

          // CAPA 5: Ítems interactivos con soporte hover, letra, color y badge
          Positioned.fill(
            child: Padding(
              padding: widget.innerPadding,
              child: Row(
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isSelected = index == widget.currentIndex;
                  final isHovered = index == _hoveredIndex;

                  final itemColor = isSelected
                      ? activeColor
                      : (isHovered && widget.hoverItemColor != null
                          ? widget.hoverItemColor!
                          : inactiveColor);

                  final baseTextStyle = const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ).merge(widget.labelStyle);

                  final resolvedTextStyle = baseTextStyle
                      .merge(
                        isSelected
                            ? const TextStyle(fontWeight: FontWeight.w700)
                                .merge(widget.selectedLabelStyle)
                            : const TextStyle(fontWeight: FontWeight.w500)
                                .merge(widget.unselectedLabelStyle),
                      )
                      .copyWith(color: itemColor);

                  final scale = isSelected
                      ? 1.03
                      : (isHovered ? widget.hoverScale : 0.98);

                  return Expanded(
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      onEnter: (_) => setState(() => _hoveredIndex = index),
                      onExit: (_) {
                        if (_hoveredIndex == index) {
                          setState(() => _hoveredIndex = null);
                        }
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            resolvedPill.borderRadius,
                          ),
                          onTap: () {
                            if (widget.enableHaptics &&
                                index != widget.currentIndex) {
                              HapticFeedback.selectionClick();
                            }
                            widget.onTap(index);
                          },
                          child: AnimatedScale(
                            scale: scale,
                            duration: const Duration(milliseconds: 180),
                            curve: widget.animationCurve,
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
                                      size: widget.iconSize,
                                      color: itemColor,
                                    ),
                                    if (item.badge != null)
                                      Positioned(
                                        right: widget.badgeOffset.dx,
                                        top: widget.badgeOffset.dy,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4.5,
                                            vertical: 1,
                                          ),
                                          decoration: BoxDecoration(
                                            color: resolvedBadgeColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            item.badge!,
                                            style: TextStyle(
                                              color: resolvedBadgeTextColor,
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                            ).merge(widget.badgeTextStyle),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                if (widget.showLabels) ...[
                                  SizedBox(height: widget.iconLabelSpacing),
                                  Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: resolvedTextStyle,
                                  ),
                                ],
                              ],
                            ),
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
    );

    if (widget.position == NeoGlassPosition.bottom) {
      return SafeArea(top: false, child: navigatorBody);
    }
    if (widget.position == NeoGlassPosition.top) {
      return SafeArea(bottom: false, child: navigatorBody);
    }
    return navigatorBody;
  }
}
