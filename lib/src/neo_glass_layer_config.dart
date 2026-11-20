import 'package:material_ui/material_ui.dart';

/// Configuración individual de cada capa translúcida dentro del [Stack]
/// de [NeoGlassNavigationBar] para lograr el efecto Liquid Glass de iOS.
class NeoGlassLayerConfig {
  final double blurSigmaX;
  final double blurSigmaY;
  final Color tintColor;
  final double opacity;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final List<Color>? gradientColors;
  final bool enableBlur;

  const NeoGlassLayerConfig({
    this.blurSigmaX = 22.0,
    this.blurSigmaY = 22.0,
    this.tintColor = Colors.white,
    this.opacity = 0.24,
    this.borderRadius = 30.0,
    this.borderColor = const Color(0x66FFFFFF),
    this.borderWidth = 1.2,
    this.gradientColors,
    this.enableBlur = true,
  });

  factory NeoGlassLayerConfig.iosLightBase({
    double borderRadius = 32.0,
    double blur = 24.0,
    double opacity = 0.28,
  }) {
    return NeoGlassLayerConfig(
      blurSigmaX: blur,
      blurSigmaY: blur,
      tintColor: Colors.white,
      opacity: opacity,
      borderRadius: borderRadius,
      borderColor: const Color(0x88FFFFFF),
      borderWidth: 1.25,
      gradientColors: [
        Colors.white.withValues(alpha: (opacity + 0.16).clamp(0.0, 1.0)),
        Colors.white.withValues(alpha: (opacity * 0.55).clamp(0.0, 1.0)),
        Colors.white.withValues(alpha: (opacity * 0.85).clamp(0.0, 1.0)),
      ],
    );
  }

  factory NeoGlassLayerConfig.iosDarkBase({
    double borderRadius = 32.0,
    double blur = 24.0,
    double opacity = 0.42,
  }) {
    return NeoGlassLayerConfig(
      blurSigmaX: blur,
      blurSigmaY: blur,
      tintColor: const Color(0xFF1C1C1E),
      opacity: opacity,
      borderRadius: borderRadius,
      borderColor: const Color(0x3DFFFFFF),
      borderWidth: 1.1,
      gradientColors: [
        Colors.white.withValues(alpha: 0.16),
        const Color(0xFF1C1C1E).withValues(alpha: opacity.clamp(0.0, 1.0)),
        Colors.white.withValues(alpha: 0.08),
      ],
    );
  }

  factory NeoGlassLayerConfig.iosActivePill({
    required bool isDark,
    double borderRadius = 24.0,
    double blur = 12.0,
    double? opacity,
  }) {
    if (isDark) {
      final resolvedOpacity = opacity ?? 0.16;
      return NeoGlassLayerConfig(
        blurSigmaX: blur,
        blurSigmaY: blur,
        tintColor: Colors.white,
        opacity: resolvedOpacity,
        borderRadius: borderRadius,
        borderColor: const Color(0x4DFFFFFF),
        borderWidth: 1.0,
        gradientColors: [
          Colors.white
              .withValues(alpha: (resolvedOpacity + 0.08).clamp(0.0, 1.0)),
          Colors.white
              .withValues(alpha: (resolvedOpacity * 0.5).clamp(0.0, 1.0)),
        ],
      );
    }

    final resolvedOpacity = opacity ?? 0.48;
    return NeoGlassLayerConfig(
      blurSigmaX: blur,
      blurSigmaY: blur,
      tintColor: Colors.white,
      opacity: resolvedOpacity,
      borderRadius: borderRadius,
      borderColor: const Color(0xAAFFFFFF),
      borderWidth: 1.1,
      gradientColors: [
        Colors.white
            .withValues(alpha: (resolvedOpacity + 0.20).clamp(0.0, 1.0)),
        Colors.white
            .withValues(alpha: (resolvedOpacity * 0.62).clamp(0.0, 1.0)),
      ],
    );
  }

  factory NeoGlassLayerConfig.iosHover({
    required bool isDark,
    double borderRadius = 22.0,
  }) {
    return NeoGlassLayerConfig(
      enableBlur: false,
      tintColor: Colors.white,
      opacity: isDark ? 0.10 : 0.22,
      borderRadius: borderRadius,
      borderColor: isDark ? const Color(0x33FFFFFF) : const Color(0x77FFFFFF),
      borderWidth: 0.9,
      gradientColors: [
        Colors.white.withValues(alpha: isDark ? 0.14 : 0.30),
        Colors.white.withValues(alpha: isDark ? 0.04 : 0.10),
      ],
    );
  }

  NeoGlassLayerConfig copyWith({
    double? blurSigmaX,
    double? blurSigmaY,
    Color? tintColor,
    double? opacity,
    double? borderRadius,
    Color? borderColor,
    double? borderWidth,
    List<Color>? gradientColors,
    bool? enableBlur,
  }) {
    return NeoGlassLayerConfig(
      blurSigmaX: blurSigmaX ?? this.blurSigmaX,
      blurSigmaY: blurSigmaY ?? this.blurSigmaY,
      tintColor: tintColor ?? this.tintColor,
      opacity: opacity ?? this.opacity,
      borderRadius: borderRadius ?? this.borderRadius,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      gradientColors: gradientColors ?? this.gradientColors,
      enableBlur: enableBlur ?? this.enableBlur,
    );
  }
}
