import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootKey,
  initialLocation: "/",
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      name: appRoutes.root.name,
      path: appRoutes.root.path,
      builder: (c, s) => const IntroScreen()
    ),
    GoRoute(
      name: appRoutes.dashboard.name,
      path: appRoutes.dashboard.path,
      builder: (c, s) => const DashboardScreen()
    ),
    GoRoute(
      name: appRoutes.setting.name,
      path: appRoutes.setting.path,
      builder: (c, s) => const SettingScreen()
    ),

    GoRoute(
      name: appRoutes.games.luckydraw.landing.name,
      path: appRoutes.games.luckydraw.landing.path,
      builder: (c, s) => const LuckyDrawLandingScreen()
    ),
    GoRoute(
      name: appRoutes.games.luckydraw.form.name,
      path: appRoutes.games.luckydraw.form.path,
      builder: (c, s) => const LuckyDrawFormScreen()
    ),
    GoRoute(
      name: appRoutes.games.luckydraw.dashboard.name,
      path: appRoutes.games.luckydraw.dashboard.path,
      builder: (c, s) => const LuckyDrawDashboardScreen()
    ),
    GoRoute(
      name: appRoutes.games.luckydraw.history.name,
      path: appRoutes.games.luckydraw.history.path,
      builder: (c, s) => const LuckyDrawHistoryScreen()
    ),

  ]
);
