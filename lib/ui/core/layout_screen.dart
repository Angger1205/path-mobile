import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_mobile/ui/core/app_assets.dart';
import 'package:path_mobile/ui/core/app_theme.dart';

class LayoutScreen extends StatelessWidget {
  const LayoutScreen({super.key, required this.child});

  final Widget child;

  static const List<String> _routes = [
    '/beranda',
    '/pengajar',
    '/kelas',
    '/kalender',
    '/profil',
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    final int index = _routes.indexWhere((route) => location.startsWith(route));
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: AppColors.card,
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => context.go(_routes[index]),
        backgroundColor: AppColors.card,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        destinations: AppAssets.navItems
            .map(
              (item) => NavigationDestination(
                icon: _navIcon(item.inactive),
                selectedIcon: _navIcon(item.active),
                label: item.label,
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _navIcon(String path) {
    return Image.asset(
      path,
      width: 26,
      height: 26,
      errorBuilder: (_, _, _) =>
          const Icon(Icons.image_not_supported_outlined),
    );
  }
}
