import 'package:flutter/material.dart';
import 'package:cegames/src/index.dart';

void runMultiWindowApp(List<String> args) {
  if (args.firstOrNull == 'multi_window') {
    runApp(LuckydrawSpinScreen(args: args));
  } else runApp(const App());
}