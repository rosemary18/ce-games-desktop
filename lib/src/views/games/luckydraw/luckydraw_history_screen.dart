import 'dart:convert';

import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

class LuckyDrawHistoryScreen extends StatefulWidget {
  const LuckyDrawHistoryScreen({super.key});

  @override
  State<LuckyDrawHistoryScreen> createState() => _LuckyDrawHistoryScreenState();
}

class _LuckyDrawHistoryScreenState extends State<LuckyDrawHistoryScreen> {

  final storage = const FlutterSecureStorage();
  LuckyDrawHistoryModel? history;

  @override
  void initState() {
    
    super.initState();
    readStorage(key: "luckydraw_history", cb: (value) {
      if (value != null) {
        setState(() {
          history = LuckyDrawHistoryModel.fromJson(jsonDecode(value));
          debugPrint(history?.history.length.toString());
        });
      }
    });
  }

  Future<void> Function() handlerDelete(BuildContext context, LuckyDrawGameModel game) {
    return () async {
      final bool? confirmed = await showPlatformDialog<bool>(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text("Konfirmasi"),
          content: Text("Yakin untuk menghapus riwayat permainan #${game.id}?"),
          actions: <Widget>[
            BasicDialogAction(
              title: const Text("Batal"),
              onPressed: () {
                Navigator.pop(context, false); // Return false when canceled
              },
            ),
            BasicDialogAction(
              title: const Text("Yakin"),
              onPressed: () {
                Navigator.pop(context, true); // Return true when confirmed
              },
            ),
          ],
        ),
      );

      if (confirmed != null && confirmed) {
        setState(() {
          history?.history.removeWhere((element) => element.id == game.id);
          writeStorage(key: "luckydraw_history", value: jsonEncode(history?.toJson()));
        });
      }
    };
  }

  Function() handlerPlay(BuildContext ctx, LuckyDrawGameModel game) {
    return () async {

      history?.history.removeWhere((element) => element.id == game.id);
      await storage.delete(key: "luckydraw_history").then((value) {
        readStorage(key: "luckydraw_last_game", cb: (value) {
          if (value != null) {
            LuckyDrawGameModel last_game = LuckyDrawGameModel.fromJson(jsonDecode(value));
            history?.history.insert(0, last_game);
            writeStorage(key: "luckydraw_history", value: jsonEncode(history?.toJson()));
          }
        });
      });
      
      await writeStorage(key: "luckydraw_last_game", value: jsonEncode(game.toJson()));

      ctx.pushNamed(appRoutes.games.luckydraw.dashboard.name);

    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFF101827),
        child: Column(
          children: [
            const DetailHeader(title: "Lucky Draw - History"),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 24),
                child: history == null ? const Center(child: CircularProgressIndicator()) : 
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              margin: const EdgeInsets.only(right: 6, bottom: 6, top: 6),
                              decoration: const BoxDecoration(
                                color: Color(0xFF374251),
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              child: const Text(
                                "Game", 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            )
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(right: 6, bottom: 6, top: 6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF374251),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            child: const Text(
                              "Terakhir dimainkan", 
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 6, top: 6),
                            width: 100,
                            decoration: const BoxDecoration(
                              color: Color(0xFF374251),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            child: const Center(
                              child: Text(
                                "Opsi", 
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: history?.history.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Text(
                                    "${index + 1}. #${history?.history[index].id ?? ""}", 
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14
                                    )
                                  ),
                                )
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                margin: const EdgeInsets.only(right: 10),
                                child: Text(
                                  DateFormat('d MMM y, HH:mm:ss').format(history!.history[index].date_last_play), 
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  )
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                width: 100,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: handlerDelete(context, history!.history[index]),
                                      icon: const Icon(IconlyBroken.delete, color: Colors.red),
                                      iconSize: 20,
                                    ),
                                    IconButton(
                                      onPressed: handlerPlay(context, history!.history[index]),
                                      icon: const Icon(IconlyBroken.play, color: Colors.white),
                                      iconSize: 20,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          );
                        }
                      )
                    )
                  ],
                )
              )
            ),
          ],
        ),
      ),
    );
  }
}