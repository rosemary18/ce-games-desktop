import 'base_interface.dart';

class LuckyDrawRoutes {

  final Route landing;
  final Route form;
  final Route dashboard;
  final Route history;

  const LuckyDrawRoutes({
    this.landing = const Route(name: "luckydraw/landing", path: "/luckydraw/landing"),
    this.form = const Route(name: "luckydraw/form", path: "/luckydraw/form"),
    this.dashboard = const Route(name: "luckydraw/dashboard", path: "/luckydraw/dashboard"),
    this.history = const Route(name: "luckydraw/history", path: "/luckydraw/history"),
  });
}

class GamesRoutes {

  final LuckyDrawRoutes luckydraw;

  const GamesRoutes({
    this.luckydraw = const LuckyDrawRoutes()
  });
}

class AppRoutes {

  final Route root;
  final Route dashboard;
  final Route setting;
  
  final GamesRoutes games;  

  const AppRoutes({
    this.root = const Route(name: "intro", path: "/"),
    this.dashboard = const Route(name: "dashboard", path: "/dashboard"),
    this.setting = const Route(name: "setting", path: "/setting"),
    this.games = const GamesRoutes(),
  });
}

const appRoutes = AppRoutes();