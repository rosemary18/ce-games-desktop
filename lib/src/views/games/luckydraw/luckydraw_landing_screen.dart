import 'dart:convert';

import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LuckyDrawLandingScreen extends StatefulWidget {
  const LuckyDrawLandingScreen({super.key});

  @override
  State<LuckyDrawLandingScreen> createState() => _LuckyDrawLandingScreenState();
}

class _LuckyDrawLandingScreenState extends State<LuckyDrawLandingScreen> {

  final FocusNode _focusNode = FocusNode();
  final storage = const FlutterSecureStorage();
  LuckyDrawGameModel? last_game;
  LuckyDrawHistoryModel? history;

  @override
  void initState() {
    super.initState();

    readStorage(key: "luckydraw_last_game", cb: (value) {
      if (value != null) {
        setState(() {
          last_game = LuckyDrawGameModel.fromJson(jsonDecode(value));
        });
      }
    });

    readStorage(key: "luckydraw_history", cb: (value) {
      if (value != null) {
        setState(() {
          history = LuckyDrawHistoryModel.fromJson(jsonDecode(value));
        });
      }
    });

    _focusNode.addListener(_onFocusChange);
    
  }

  void _onFocusChange() {
    setState(() {
      readStorage(key: "luckydraw_history", cb: (value) {
        if (value != null) {
          setState(() {
            history = LuckyDrawHistoryModel.fromJson(jsonDecode(value));
          });
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant LuckyDrawLandingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> Function() handlerNavigateToHistory(BuildContext ctx) {
    return () => ctx.pushNamed(appRoutes.games.luckydraw.history.name);
  }

  Future<void> Function() handlerNavigateToDashboard(BuildContext ctx) {
    return () => ctx.pushNamed(appRoutes.games.luckydraw.dashboard.name, extra: { "from": "landing" });
  }

  Future<void> Function() handlerNavigateToForm(BuildContext ctx) {
    return () => ctx.pushNamed(appRoutes.games.luckydraw.form.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color(0xFF101827),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 24, bottom: 12),
                child: const Text("Lucky Draw", style: TextStyle(color: Colors.white, fontSize: 38),),
              ),
              if (history != null && history!.history.isNotEmpty) TouchableOpacity(
                onPress: handlerNavigateToHistory(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const  BoxDecoration(
                    color: Color(0xFF183F65),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Text("Riwayat Permainan", style: appStyles["text"]!["bold1White"]),
                )
              ),
              TouchableOpacity(
                onPress: handlerNavigateToForm(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const  BoxDecoration(
                    color: Color.fromARGB(255, 189, 65, 211),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: Text("Mulai Baru", style: appStyles["text"]!["bold1White"]),
                )
              ),
              if (last_game != null) TouchableOpacity(
                onPress: handlerNavigateToDashboard(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                  child: const Text("Lanjutkan", style: TextStyle(color: Colors.blue),),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}