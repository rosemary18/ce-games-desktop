import 'package:flutter/material.dart';
import 'package:cegames/src/index.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  Future<Object?> Function() handlerPlayLuckyDraw(BuildContext ctx) {
    return () => ctx.pushNamed(appRoutes.games.luckydraw.landing.name);
  }

  Widget buildCardGame(BuildContext ctx) {
    return TouchableOpacity(
      onPress: handlerPlayLuckyDraw(ctx),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 38, 48, 65),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(12),
              height: 120,
              width: 120,
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.all(Radius.circular(4)),
                // border: Border.all(
                //   width: 1,
                //   color: Colors.white30
                // )
              ),
              child: Image.asset(appIcons["IC_LUCKYDRAW"]!),
            ),
            Center(
              child: Text("Lucky Draw", style: appStyles["text"]?["regularWhite"]!),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xFF101827),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const DashboardHeader(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Row(
                      children: [
                        buildCardGame(context),
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
          Positioned(
            bottom: 14,
            right: 24,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 4),
                  height: 20,
                  width: 20,
                  child: Image.asset(appIcons["IC_APP"]!),
                ),
                const Text("©2024 Central Events", style: TextStyle(fontSize: 8, color: Colors.white54),)
              ],
            )
          )
        ],
      ),
    );
  }
}