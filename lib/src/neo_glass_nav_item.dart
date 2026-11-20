import 'package:flutter/widgets.dart';

/// Modelo de cada destino dentro de [NeoGlassNavigationBar].
class NeoGlassNavItem {
  /// Texto descriptivo debajo del icono.
  final String label;

  /// Icono en estado inactivo.
  final IconData icon;

  /// Icono opcional cuando el destino está seleccionado.
  final IconData? activeIcon;

  /// Badge opcional (por ejemplo, contador de notificaciones).
  final String? badge;

  const NeoGlassNavItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.badge,
  });
}
