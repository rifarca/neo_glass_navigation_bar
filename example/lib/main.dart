import 'package:flutter/material.dart';
import 'package:neo_glass_navigation_bar/neo_glass_navigation_bar.dart';
import 'home_tab.dart';

void main() {
  runApp(const GeeslyLiquidGlassApp());
}

class GeeslyLiquidGlassApp extends StatelessWidget {
  const GeeslyLiquidGlassApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geesly – NeoGlassNavigationBar Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0A84FF),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0A84FF),
        brightness: Brightness.dark,
      ),
      home: const GeeslyMainScreen(),
    );
  }
}

class GeeslyMainScreen extends StatefulWidget {
  const GeeslyMainScreen({super.key});

  @override
  State<GeeslyMainScreen> createState() => _GeeslyMainScreenState();
}

class _GeeslyMainScreenState extends State<GeeslyMainScreen> {
  int _currentIndex = 0;

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // CAPA BASE DE FONDO: contenido que pasa por detrás del cristal
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                HomeTab(onExploreTap: () => _selectTab(1)),
                _PlaceholderMapTab(primary: primary),
                const Center(child: Text('Rutas guardadas')),
                const Center(child: Text('Aventuras')),
              ],
            ),
          ),

          // CAPA FLOTANTE: NeoGlassNavigationBar con Stack multicapa Liquid Glass
          Align(
            alignment: Alignment.bottomCenter,
            child: NeoGlassNavigationBar(
              currentIndex: _currentIndex,
              onTap: _selectTab,
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
                  label: 'Aventuras',
                  icon: Icons.explore_outlined,
                  activeIcon: Icons.explore_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceholderMapTab extends StatelessWidget {
  final Color primary;
  const _PlaceholderMapTab({required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primary.withValues(alpha: 0.25),
            Colors.teal.withValues(alpha: 0.20),
            Colors.indigo.withValues(alpha: 0.28),
          ],
        ),
      ),
      child: const Center(
        child: Text(
          'Vista de Mapa / Destinos',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
