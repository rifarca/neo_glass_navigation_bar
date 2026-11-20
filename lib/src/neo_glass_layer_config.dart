import 'package:flutter/material.dart';

/// Configuración individual de cada capa translúcida dentro del [Stack]
/// de [NeoGlassNavigator] para lograr el efecto Liquid Glass de iOS.
class NeoGlassLayerConfig {
  /// Intensidad de desenfoque horizontal (`ImageFilter.blur`).
  final double blurSigmaX;

  /// Intensidad de desenfoque vertical (`ImageFilter.blur`).
  final double blurSigmaY;

  /// Color base del tinte del cristal.
  final Color tintColor;

  /// Opacidad principal del tinte (0.0 a 1.0).
  final double opacity;

  /// Radio de redondeo de la capa.
  final double borderRadius;

  /// Color del contorno de refracción.
  final Color borderColor;

  /// Grosor del contorno de refracción.
  final double borderWidth;

  /// Degradado especular opcional para simular reflejo líquido superior.
  final List<Color>? gradientColors;

  /// Si es `true`, aplica el filtro de desenfoque de fondo (`BackdropFilter`).
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

  /// Preset claro inspirado en iOS Liquid Glass.
  factory NeoGlassLayerConfig.iosLightBase({
    double borderRadius = 32.0,
    double blur = 24.0,
  }) {
    return NeoGlassLayerConfig(
      blurSigmaX: blur,
      blurSigmaY: blur,
      tintColor: Colors.white,
      opacity: 0.28,
      borderRadius: borderRadius,
      borderColor: const Color(0x88FFFFFF),
      borderWidth: 1.25,
      gradientColors: [
        Colors.white.withValues(alpha: 0.44),
        Colors.white.withValues(alpha: 0.16),
        Colors.white.withValues(alpha: 0.24),
      ],
    );
  }

  /// Preset oscuro inspirado en iOS Liquid Glass.
  factory NeoGlassLayerConfig.iosDarkBase({
    double borderRadius = 32.0,
    double blur = 24.0,
  }) {
    return NeoGlassLayerConfig(
      blurSigmaX: blur,
      blurSigmaY: blur,
      tintColor: const Color(0xFF1C1C1E),
      opacity: 0.42,
      borderRadius: borderRadius,
      borderColor: const Color(0x3DFFFFFF),
      borderWidth: 1.1,
      gradientColors: [
        Colors.white.withValues(alpha: 0.16),
        const Color(0xFF1C1C1E).withValues(alpha: 0.45),
        Colors.white.withValues(alpha: 0.08),
      ],
    );
  }

  /// Preset para la cápsula activa (*pill*) que flota dentro del navigator.
  factory NeoGlassLayerConfig.iosActivePill({
    required bool isDark,
    double borderRadius = 24.0,
  }) {
    if (isDark) {
      return NeoGlassLayerConfig(
        blurSigmaX: 12.0,
        blurSigmaY: 12.0,
        tintColor: Colors.white,
        opacity: 0.16,
        borderRadius: borderRadius,
        borderColor: const Color(0x4DFFFFFF),
        borderWidth: 1.0,
        gradientColors: [
          Colors.white.withValues(alpha: 0.24),
          Colors.white.withValues(alpha: 0.08),
        ],
      );
    }

    return NeoGlassLayerConfig(
      blurSigmaX: 12.0,
      blurSigmaY: 12.0,
      tintColor: Colors.white,
      opacity: 0.48,
      borderRadius: borderRadius,
      borderColor: const Color(0xAAFFFFFF),
      borderWidth: 1.1,
      gradientColors: [
        Colors.white.withValues(alpha: 0.68),
        Colors.white.withValues(alpha: 0.30),
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
