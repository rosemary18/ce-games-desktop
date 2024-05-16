import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';

Future<void> startUp(bool isMainWindow) async {

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();

  if (isMainWindow) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: const Size(700, 800),
      minimumSize: const Size(700, 800),
      center: true,
      titleBarStyle: TitleBarStyle.normal,
      fullScreen: Platform.isMacOS,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}