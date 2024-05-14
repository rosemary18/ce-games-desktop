import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cegames/src/views/games/luckydraw/widgets/index.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:cegames/src/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LuckyDrawHeader extends StatefulWidget {

  final WindowController? windowSpin;
  final Function() handlerOpenWindowSpin;
  final WindowSpinThemeModel? windowSpinTheme;
  final Function(WindowSpinThemeModel?)? handlerSaveWindowSpinTheme;

  const LuckyDrawHeader({
    super.key,
    this.windowSpin,
    required this.handlerOpenWindowSpin,
    this.windowSpinTheme,
    this.handlerSaveWindowSpinTheme
  });

  @override
  State<LuckyDrawHeader> createState() => _LuckyDrawHeaderState();
}

class _LuckyDrawHeaderState extends State<LuckyDrawHeader> {

  final storage = const FlutterSecureStorage();
  LuckyDrawGameModel? last_game;
  WindowSpinThemeModel? windowSpinTheme;

  @override
  void initState() {
    
    super.initState();
    setState(() {
      storage.read(key: "luckydraw_last_game").then((value) {
        if (value != null) {
          last_game = LuckyDrawGameModel.fromJson(jsonDecode(value));
        }
      });
      windowSpinTheme = widget.windowSpinTheme;
    });
  }

  @override
  void didUpdateWidget(covariant LuckyDrawHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      storage.read(key: "luckydraw_last_game").then((value) {
        if (value != null) {
          last_game = LuckyDrawGameModel.fromJson(jsonDecode(value));
        }
      });
      windowSpinTheme = widget.windowSpinTheme;
    });
  }

  void handlerExport() async {

    String fileName = 'luckydraw_daftar_pemenang_luckydraw_#${last_game?.id}.txt';
    String content = "Daftar Pemenang Lucky Draw\n\n";
    Map<String, List<WinnerModel>> groups = {};
    
    for (var winner in last_game!.winners) {
      if (groups.containsKey(winner.prize_name)) groups[winner.prize_name]!.add(winner);
      else groups[winner.prize_name] = [winner];
    }
    
    groups.forEach((key, value) {
      content += "$key\n";
      for (int i = 0; i < value.length; i++) {
        content += "${i + 1}. ${value[i].participant_name}\n";
      }
      content += "\n\n";
    });
    
    final FileSaveLocation? saveLocationPrize = await getSaveLocation(suggestedName: fileName);

    if (saveLocationPrize == null) return;
    else {
      final Uint8List fileData = Uint8List.fromList(content.codeUnits);
      const String mimeType = 'text/plain';
      final XFile textFile = XFile.fromData(fileData, mimeType: mimeType, name: fileName);
      await textFile.saveTo(saveLocationPrize.path);
    }
  }

  Function() handlerExit(BuildContext context) {
    return () {
      dynamic extra = GoRouterState.of(context).extra;      
      context.pop();
      context.pop();
      if (extra?["from"] != "landing") context.pop();
    };
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1F2937),
        border: Border(
          bottom: BorderSide(
            color: Color.fromARGB(255, 87, 94, 103), 
            width: 1
          )
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 40,
                width: 40,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(right: 12),
                child: Image.asset(appIcons["IC_LUCKYDRAW"]!, fit: BoxFit.contain),
              ),
              const Text("Lucky Draw ", style: TextStyle(color: Colors.white, fontSize: 22),),
              Text("#${last_game?.id}", style: const TextStyle(color: Colors.white60, fontSize: 22),)
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.windowSpin == null) TouchableOpacity(
                onPress: widget.handlerOpenWindowSpin,
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF374251),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: const Text("Buka Jendala Spin", style: TextStyle(color: Colors.white),),
                )
              ) else PopUp(
                tag: 'setwindowspintheme',
                padding: const EdgeInsets.all(0),
                popUp: PopUpItem(
                  padding: const EdgeInsets.all(24),
                  color: const Color.fromARGB(255, 38, 48, 65),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                  elevation: 2,
                  margin: EdgeInsets.symmetric(horizontal: min(MediaQuery.of(context).size.width*0.3, 720)),
                  tag: 'setwindowspintheme',
                  child: PopUpSpinTheme(
                    windowSpinTheme: windowSpinTheme, 
                    handlerSaveWindowSpinTheme: widget.handlerSaveWindowSpinTheme
                  ),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF374251),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: const Text(
                    "Spin Theme",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14
                    )
                  ),
                ),
              ),
              if (last_game != null && last_game!.winners.isNotEmpty) TouchableOpacity(
                onPress: handlerExport,
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF374251),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: const Text("Export", style: TextStyle(color: Colors.white),),
                )
              ),
              TouchableOpacity(
                onPress: handlerExit(context),
                child: Container(
                  margin: const EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: Color(0xFF374251),
                    borderRadius: BorderRadius.all(Radius.circular(4))
                  ),
                  child: const Text("Keluar", style: TextStyle(color: Colors.white),),
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}