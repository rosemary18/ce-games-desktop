import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cegames/src/index.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LuckydrawSpinScreen extends StatefulWidget {

  final List<String>? args;

  const LuckydrawSpinScreen({
    super.key,
    required this.args,
  });

  @override
  State<LuckydrawSpinScreen> createState() => _LuckydrawSpinScreenState();
}

class _LuckydrawSpinScreenState extends State<LuckydrawSpinScreen> {

  WindowSpinSettingsModel windowSpinSetting = WindowSpinSettingsModel();
  PrizeModel? activePrize;
  bool isSpinning = false;
  int slots = 0;
  List<ParticipantModel> availableParticipants = [];
  List<ParticipantModel> stageWinners = [];
  Map<String, Map<String, bool>> stageSpins = {};

  @override
  void initState() {
    super.initState();
    DesktopMultiWindow.setMethodHandler(handlerMethodCallBack);
  }

  Future<dynamic> handlerMethodCallBack(MethodCall c, int wid) async {
    dynamic data = jsonDecode(c.arguments.toString());
    setState(() {
      windowSpinSetting = ((data["windowSpinSetting"] != null) ? WindowSpinSettingsModel.fromJson(data["windowSpinSetting"]) : null)!;
      activePrize = (data["activePrize"] != null) ? PrizeModel.fromJson(data["activePrize"]) : null ;
      isSpinning = data["isSpinning"] as bool;
      slots = data["slots"] as int;
      stageWinners = (data["stageWinners"] as List).map((e) => ParticipantModel.fromJson(e)).toList();
      availableParticipants = (data["availableParticipants"] as List).map((e) => ParticipantModel.fromJson(e)).toList();
      stageSpins = Map<String, Map<String, bool>>.from(data["stageSpins"].map((key, value) => MapEntry(key, Map<String, bool>.from(value.cast<String, bool>()))));
    });
  }

  Widget _buildBackground(BuildContext ctx) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Image.file(
        File(windowSpinSetting.backgroundImage),
        fit: windowSpinSetting.backgroundImageFit,
      ),
    );
  }


  Widget _buildSlot(BuildContext ctx, int index) {
    return Container(
      margin: EdgeInsets.all(windowSpinSetting.slotSpacing),
      height: windowSpinSetting.slotHeight,
      width: windowSpinSetting.slotWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Center(
        child: (isSpinning || (stageSpins[index.toString()] != null && stageSpins[index.toString()]!["spin"] == true)) ? TextSpinner(
          strings: [
            ...stageWinners.map((e) => e.name), 
            ...availableParticipants.map((e) => e.name)
          ].toList(),
          spin: true,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 14
          ),
        ) : Text(
          (stageWinners.isNotEmpty && ((index+1) <= stageWinners.length)) ? stageWinners[index].name : "Slot ${index+1}",
          style: TextStyle(
            color: windowSpinSetting.textColor,
            fontSize: windowSpinSetting.textSize
          )
        ),
      )
    );
  }

  Widget _buildContent(BuildContext ctx) {

    return Container(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          if (activePrize != null && activePrize!.image.isNotEmpty) Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: windowSpinSetting.prizeImagePositionX),
              height: windowSpinSetting.prizeImageHeight,
              width: windowSpinSetting.prizeImageWidth,
              child: Image.file(
                File(activePrize!.image),
                fit: BoxFit.contain,
              ),
            ),
          ),
          if (windowSpinSetting.withTitle) Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: (MediaQuery.of(ctx).size.height * .12)),
              child: Text(
                (activePrize != null) ? activePrize!.prize_name : "",
                style: TextStyle(
                  color: windowSpinSetting.titleColor,
                  fontSize: windowSpinSetting.titleSize,
                  fontWeight: FontWeight.bold
                )
              ),
            )
          ),
          if (activePrize!.winners.length != activePrize!.total) Center(
            child: Container(
              padding: EdgeInsets.only(left: (MediaQuery.of(ctx).size.width * .2), right: (MediaQuery.of(ctx).size.width * .2)),
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Wrap(
                    direction: Axis.horizontal,
                    alignment: WrapAlignment.center,
                    children: List.generate(slots, (index) => _buildSlot(context, index)),
                  ),
                ],
              ),
            ),
          ) else Center(
            child: EndlessScrollingAnimation(
              height: min(400, (activePrize!.winners.length*100)),
              width: MediaQuery.of(ctx).size.width*.6,
              children: List.generate(activePrize!.winners.length, (index) => Container(  
                margin: const EdgeInsets.symmetric(vertical: 8),            
                child: Text(
                  activePrize!.winners[index].name,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 22, 18, 48),
                    fontSize: 40,
                  )
                ),
              )).toList()
            ),
          )

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: windowSpinSetting.backgroundColor,
          child: Stack(
            children: [
              if (windowSpinSetting.backgroundImage.isNotEmpty) _buildBackground(context),
              if (activePrize != null) _buildContent(context),
            ],
          ),
        )
      ),
    );
  }
}