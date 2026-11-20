import 'dart:ui';
import 'package:flutter/material.dart';
import 'neo_glass_layer_config.dart';

/// Primitiva visual reutilizable que representa una capa individual dentro
/// del [Stack] con borde redondeado, transparencia graduada y desenfoque.
class NeoGlassSurface extends StatelessWidget {
  final NeoGlassLayerConfig config;
  final List<BoxShadow>? boxShadow;
  final Widget? child;

  const NeoGlassSurface({
    super.key,
    required this.config,
    this.boxShadow,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(config.borderRadius);

    final decoration = BoxDecoration(
      borderRadius: radius,
      color: config.gradientColors == null
          ? config.tintColor.withValues(alpha: config.opacity)
          : null,
      gradient: config.gradientColors != null
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: config.gradientColors!,
            )
          : null,
      border: config.borderWidth > 0
          ? Border.all(
              color: config.borderColor,
              width: config.borderWidth,
            )
          : null,
    );

    Widget content = Container(
      decoration: decoration,
      child: child,
    );

    if (config.enableBlur &&
        (config.blurSigmaX > 0 || config.blurSigmaY > 0)) {
      content = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: config.blurSigmaX,
          sigmaY: config.blurSigmaY,
        ),
        child: content,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: content,
      ),
    );
  }
}
