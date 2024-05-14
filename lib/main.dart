import 'package:cegames/src/index.dart';

void main(List<String> args) async {
  
  await startUp(args.firstOrNull != 'multi_window');
  runMultiWindowApp(args);
}