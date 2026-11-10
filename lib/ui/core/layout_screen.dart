import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LayoutScreen extends StatelessWidget {
  const new({super.key, required this.child});

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
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => context.go(_routes[index]),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(label: 'Beranda', icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'Pengajar',
            icon: Icon(Icons.engineering),
          ),
          BottomNavigationBarItem(label: 'Kelas', icon: Icon(Icons.book)),
          BottomNavigationBarItem(
            label: 'Kalender',
            icon: Icon(Icons.calendar_month),
          ),
          BottomNavigationBarItem(label: 'Profil', icon: Icon(Icons.person)),
        ],
      ),
    );
  }
}
