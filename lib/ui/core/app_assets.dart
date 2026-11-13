import 'package:flutter/material.dart';

class CoverTheme {
  final Color color1;
  final Color color2;
  final IconData icon;

  const CoverTheme({
    required this.color1,
    required this.color2,
    required this.icon,
  });
}

class NavItemData {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItemData({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class AppAssets {
  // Ikon Material bawaan
  static const IconData emptyClassIcon = Icons.school_outlined;
  static const IconData iconTambah = Icons.add_box_outlined;

  // Tema sampul kartu kelas bergaya Material
  static const List<CoverTheme> coverThemes = [
    CoverTheme(
      color1: Color(0xFF1E88E5),
      color2: Color(0xFF1565C0),
      icon: Icons.menu_book_rounded,
    ),
    CoverTheme(
      color1: Color(0xFF43A047),
      color2: Color(0xFF2E7D32),
      icon: Icons.devices_rounded,
    ),
    CoverTheme(
      color1: Color(0xFFE53935),
      color2: Color(0xFFC62828),
      icon: Icons.public_rounded,
    ),
    CoverTheme(
      color1: Color(0xFF8E24AA),
      color2: Color(0xFF6A1B9A),
      icon: Icons.school_rounded,
    ),
    CoverTheme(
      color1: Color(0xFF00ACC1),
      color2: Color(0xFF00838F),
      icon: Icons.science_rounded,
    ),
    CoverTheme(
      color1: Color(0xFFFB8C00),
      color2: Color(0xFFEF6C00),
      icon: Icons.straighten_rounded,
    ),
    CoverTheme(
      color1: Color(0xFF3949AB),
      color2: Color(0xFF283593),
      icon: Icons.sports_soccer_rounded,
    ),
    CoverTheme(
      color1: Color(0xFF546E7A),
      color2: Color(0xFF37474F),
      icon: Icons.handyman_rounded,
    ),
  ];

  static CoverTheme getCoverTheme(int index) {
    final i = index.abs() % coverThemes.length;
    return coverThemes[i];
  }

  // Ikon navigasi bawah menggunakan Material Icons
  static const navItems = [
    NavItemData(
      label: 'Beranda',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    NavItemData(
      label: 'Pengajar',
      icon: Icons.co_present_outlined,
      activeIcon: Icons.co_present,
    ),
    NavItemData(
      label: 'Kelas',
      icon: Icons.menu_book_outlined,
      activeIcon: Icons.menu_book,
    ),
    NavItemData(
      label: 'Kalender',
      icon: Icons.calendar_today_outlined,
      activeIcon: Icons.calendar_today,
    ),
    NavItemData(
      label: 'Profil',
      icon: Icons.account_circle_outlined,
      activeIcon: Icons.account_circle,
    ),
  ];
}
