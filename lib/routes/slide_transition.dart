import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _slideUpTween = Tween(
  begin: const Offset(0, 1),
  end: Offset.zero,
).chain(CurveTween(curve: Curves.easeOut));

CustomTransitionPage slideUpPage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: RepaintBoundary(child: child),
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    opaque: false,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: animation.drive(_slideUpTween),
        child: child,
      );
    },
  );
}
