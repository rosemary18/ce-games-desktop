import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:window_manager/window_manager.dart';

Future<void> startUp(bool isMainWindow) async {

  await dotenv.load(fileName: '.env');

  WidgetsFlutterBinding.ensureInitialized();

  if (isMainWindow) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(700, 800),
      minimumSize: Size(700, 800),
      center: true,
      titleBarStyle: TitleBarStyle.normal,
      fullScreen: true
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
}