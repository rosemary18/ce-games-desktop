import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cegames/src/index.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconly/iconly.dart';
import 'package:oktoast/oktoast.dart';
import 'package:path_provider/path_provider.dart';

class LuckyDrawDashboardScreen extends StatefulWidget {
  const LuckyDrawDashboardScreen({super.key});

  @override
  State<LuckyDrawDashboardScreen> createState() => _LuckyDrawDashboardScreenState();
}

class _LuckyDrawDashboardScreenState extends State<LuckyDrawDashboardScreen> {

  final storage = const FlutterSecureStorage();
  AudioPlayer player = AudioPlayer();
  WindowController? windowSpin;
  WindowSpinSettingsModel windowSpinSetting = WindowSpinSettingsModel();
  LuckyDrawGameModel? game;
  PrizeModel? activePrize;
  bool isSpinning = false;
  bool hideRightPanel = true;
  int slots = 1;
  List<ParticipantModel> availableParticipants = [];
  List<ParticipantModel> stageWinners = [];
  List<ParticipantModel?> stageDefinedWinners = [];
  Map<String, Map<String, bool>> stageSpins = {};
  
  @override
  void initState() {

    super.initState();

    readStorage(key: "luckydraw_last_game", cb: (value) {
      if (value != null) {
        setState(() {
          game = LuckyDrawGameModel.fromJson(jsonDecode(value));
          sortParticipants();
        });
      }
    });
    
    readStorage(key: "luckydraw_window_spin_settings", cb: (value) {
      if (value != null) {
        setState(() {
          windowSpinSetting = WindowSpinSettingsModel.fromJson(jsonDecode(value));
        });
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
    if (windowSpin != null) windowSpin!.close();
  }

  void handlerOpenWindowSpin() async {
    await DesktopMultiWindow.createWindow(jsonEncode({})).then((window) {
      Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          if (Platform.isMacOS) window.resizable(true);
          window
            ..setFrame(const Offset(0, 0) & const Size(800, 800))
            ..center()
            ..setTitle('Lucky Draw - Spin')
            ..show();
          windowSpin = window;
          handlerSendDataToWindowSpin();
        });
      });
    });
  }

  void handlerSendDataToWindowSpin() {
    
    if (windowSpin == null) return;
    Map<String, dynamic> data = {
      "activePrize": activePrize,
      "isSpinning": isSpinning,
      "slots": slots,
      "availableParticipants": availableParticipants,
      "stageWinners": stageWinners,
      "stageSpins": stageSpins,
      "windowSpinSetting": windowSpinSetting.toJson()
    };
    DesktopMultiWindow.invokeMethod(windowSpin!.windowId, "update", jsonEncode(data)).onError((e, s) {
      debugPrint(e.toString());
      setState(() {
        windowSpin = null;
      });
    });
  }

  Function() handlerSelectPrize(int index) {
    return () async {
      if (isSpinning || stageSpins.isNotEmpty) {
        showToast(
          'Anda sedang melakukan spin pada hadiah ${activePrize?.prize_name}. Hentikan spin terlebih dahulu untuk berpindah.',
          position: ToastPosition.top,
          backgroundColor: const Color.fromARGB(173, 244, 67, 54),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Consolas",
            decoration: TextDecoration.none
          ),
          radius: 4,
          margin: const EdgeInsets.all(2),
          duration: const Duration(seconds: 5),
          dismissOtherToast: true,
          animationCurve: Curves.easeIn,
          textPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10)
        );
      } else {
        setState(() {
          if (activePrize?.id == game?.prizes[index].id) activePrize = null;
          else activePrize = game?.prizes[index];
          slots = 1;
          stageWinners = [];
          stageSpins = {};
          stageDefinedWinners = game!.prizes[index].defined_winners; 
          if (windowSpin == null) handlerOpenWindowSpin();
          else handlerSendDataToWindowSpin();
        });
      }

      if ((game?.prizes[index].winners.length == game?.prizes[index].total) && windowSpinSetting.enabledWinSound) {
        await player.play(
          (windowSpinSetting.winSoundPath.isEmpty) ? AssetSource("audios/win-sound.mp3") : DeviceFileSource(windowSpinSetting.winSoundPath), 
          volume: windowSpinSetting.volumeSound,
          mode: PlayerMode.lowLatency
        );
        await player.setReleaseMode(ReleaseMode.loop);
      } else await player.stop();

    };
  }

  Function() handlerDeletePrize(int index) {

    return () async {
      final bool? confirmed = await showPlatformDialog<bool>(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text("Konfirmasi"),
          content: Text("Yakin untuk menghapus hadiah #${game?.prizes[index].prize_name}?"),
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
          game?.prizes.removeAt(index);
          writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
        });
      }
    };

  }
  
  Function() handlerDeleteParticipant(int index) {

    return () async {
      final bool? confirmed = await showPlatformDialog<bool>(
        context: context,
        builder: (_) => BasicDialogAlert(
          title: const Text("Konfirmasi"),
          content: Text("Yakin untuk menghapus peserta #${game?.participants[index].name}?"),
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
          game?.participants.removeAt(index);
          writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
          sortParticipants();
        });
      }
    };

  }

  void handlerAddPrize(String prize_name, String total) {
    setState(() {
      game?.prizes.add(
        PrizeModel(
          id: generateRandomString(8),
          prize_name: prize_name,
          total: int.parse(total),
          winners: [], 
          defined_winners: []
        )
      );
      writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
    });
  }

  void handlerAddParticipant(String name) {
    setState(() {
      game?.participants.add(
        ParticipantModel(
          id: generateRandomString(8),
          name: name,
          available: true,
          defined_prize: false
        )
      );
      writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
      sortParticipants();
    });
  }

  void handlerUpdateSlots(int value) {
    setState(() {
      slots = value;
      handlerSendDataToWindowSpin();
    });
  }

  void sortParticipants({Function? cb}) {
    
    List<ParticipantModel> winner = [];
    List<ParticipantModel> looser = [];
    List<ParticipantModel> available = [];
    List<ParticipantModel> availableForSpin = [];
    List<ParticipantModel> sorted = [];

    for (var i = 0; i < game!.participants.length; i++) {
      
      if (game!.participants[i].available) {
        if (!game!.participants[i].defined_prize) availableForSpin.add(game!.participants[i]);
        available.add(game!.participants[i]);
      } else {
        bool asWinner = false;
        for (var j = 0; j < game!.winners.length; j++) {
          if (game!.winners[j].participant_id == game!.participants[i].id) {
            asWinner = true;
            break;
          }
        }
        if (asWinner) {
          winner.add(game!.participants[i]);
        } else looser.add(game!.participants[i]);
      }
    }

    available.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    winner.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    looser.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    sorted.addAll(available);
    sorted.addAll(winner);
    sorted.addAll(looser);

    setState(() {
      game!.participants = sorted;
      availableParticipants = availableForSpin;
    });

    if (cb != null) cb();
  }

  void handlerRigthPanel() {
    setState(() {
      hideRightPanel = !hideRightPanel;
    });
  }

  void handlerSpin() async {
    if (availableParticipants.length < slots) handlerShowMessageLessParticipants();
    else {
      setState(() {
        isSpinning = true;
        for (var i = 0; i < slots; i++) {
          if (stageDefinedWinners.isNotEmpty && stageDefinedWinners[i+activePrize!.winners.length] != null) {
            stageWinners.add(stageDefinedWinners[i+activePrize!.winners.length]!);
          } else {
            int randomIndex = Random().nextInt(availableParticipants.length-1) + 1;
            ParticipantModel sp = availableParticipants[randomIndex];
            availableParticipants.removeAt(randomIndex);
            stageWinners.add(sp);
          }
        }
        handlerSendDataToWindowSpin();
      });
      if (windowSpinSetting.enabledSpinSound) {
        await player.play(
          (windowSpinSetting.spinSoundPath.isEmpty) ? AssetSource("audios/spin-sound.mp3") : DeviceFileSource(windowSpinSetting.spinSoundPath), 
          volume: windowSpinSetting.volumeSound,
          mode: PlayerMode.lowLatency
        );
        await player.setReleaseMode(ReleaseMode.loop);
      }
    }
  }

  void handlerShowMessageLessParticipants() {
    showToast(
      'Sisa jumlah peserta yang tersedia tidak cukup untuk melakukan spin dengan jumlah slot $slots!',
      position: ToastPosition.top,
      backgroundColor: const Color.fromARGB(173, 244, 67, 54),
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontFamily: "Consolas",
        decoration: TextDecoration.none
      ),
      radius: 4,
      margin: const EdgeInsets.all(2),
      duration: const Duration(seconds: 5),
      dismissOtherToast: true,
      animationCurve: Curves.easeIn,
      textPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10)
    );
  }

  void handlerStopSpin() async {
    setState(() {
      isSpinning = false;
      handlerSendDataToWindowSpin();
    });
    await player.stop();
  }

  void handlerSaveWinners() {
    setState(() {
      for (var i = 0; i < game!.prizes.length; i++) {
        if (game!.prizes[i].id == activePrize!.id) {
          List<WinnerModel> winners = [];
          for (var j = 0; j < stageWinners.length; j++) {
            for (var k = 0; k < game!.participants.length; k++) {
              if (game!.participants[k].id == stageWinners[j].id) {
                game!.participants[k].defined_prize = false;
                game!.participants[k].available = false;
              }
            }
            winners.add(
              WinnerModel(
                participant_id: stageWinners[j].id,
                prize_id: game!.prizes[i].id,
                participant_name: stageWinners[j].name,
                prize_name: game!.prizes[i].prize_name
              )
            );
          }
          game!.prizes[i].winners.addAll(stageWinners);
          game!.winners.addAll(winners); 

          if (game!.prizes[i].winners.length == game!.prizes[i].total) game!.prizes[i].defined_winners = [];

          activePrize = game!.prizes[i];

          writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
          break;
        }
      }

      if (slots > (activePrize!.total-activePrize!.winners.length)) {
        slots = activePrize!.total-activePrize!.winners.length;
      }
      
      stageWinners = [];
      sortParticipants();
      handlerSendDataToWindowSpin();
    });
  }

  void handlerFall() {
    setState(() {
      for (var i = 0; i < game!.prizes.length; i++) {
        if (game!.prizes[i].id == activePrize!.id) {
          for (var j = 0; j < stageWinners.length; j++) {
            for (var k = 0; k < game!.participants.length; k++) {
              if (game!.participants[k].id == stageWinners[j].id) {
                game!.participants[k].defined_prize = false;
                game!.participants[k].available = false;
              }
            }
          }
          writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
          break;
        }
      }
      stageWinners = [];
      sortParticipants();
      handlerSendDataToWindowSpin();
    });
  }

  void handlerCancelSpin() {
    setState(() {
      stageWinners = [];
      sortParticipants();
      handlerSendDataToWindowSpin();
    });
  }

  Function() handlerSpinSingle(int slot_idx) {
    return () async {
      if (windowSpinSetting.enabledSpinSound && stageSpins.isEmpty) {
        await player.play(
          (windowSpinSetting.spinSoundPath.isEmpty) ? AssetSource("audios/spin-sound.mp3") : DeviceFileSource(windowSpinSetting.spinSoundPath), 
          volume: windowSpinSetting.volumeSound,
          mode: PlayerMode.lowLatency
        );
        await player.setReleaseMode(ReleaseMode.loop);
      }
      setState(() {

        for (var k = 0; k < game!.participants.length; k++) {
          if (game!.participants[k].id == stageWinners[slot_idx].id) {
            game!.participants[k].defined_prize = false;
            game!.participants[k].available = false;
          }
        }

        int randomIndex = Random().nextInt(availableParticipants.length-1) + 1;
        ParticipantModel sp = availableParticipants[randomIndex];
        availableParticipants.removeAt(randomIndex);
        stageWinners[slot_idx] = sp;

        stageSpins[slot_idx.toString()] = {
          "spin": true,
        };

        writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));

        sortParticipants();
        handlerSendDataToWindowSpin();
      });
    };
  }

  Function() handlerStopSingle(int slot_idx) {
    return () async {
      if (stageSpins.length == 1) await player.stop();
      setState(() {
        stageSpins.remove(slot_idx.toString());
        handlerSendDataToWindowSpin();
      });
    };
  }

  void handlerSaveDefinedWinners(List<ParticipantModel?> definedWinners) {
    setState(() {
      for (var i = 0; i < game!.prizes.length; i++) {
        if (game!.prizes[i].id == activePrize!.id) {

          // Remove old defined winners
          for (var k = 0; k < game!.prizes[i].defined_winners.length; k++) {
            if (game!.prizes[i].defined_winners[k] != null) {
              bool exist = false;
              for (var l = 0; l < definedWinners.length; l++) {
                if ((definedWinners[l] != null) && (game!.prizes[i].defined_winners[k]!.id == definedWinners[l]!.id)) {
                  exist = true;
                  break;
                }
              }       
              if (!exist) {
                for (var m = 0; m < game!.participants.length; m++) {
                  if (game!.participants[m].id == game!.prizes[i].defined_winners[k]!.id) {
                    game!.participants[m].defined_prize = false;
                    break;
                  }
                }
              }      
            }
          }

          // Add new defined winners
          for (var j = 0; j < definedWinners.length; j++) {
            if (definedWinners[j] != null && (j+1) > game!.prizes[i].winners.length) {
              for (var k = 0; k < game!.participants.length; k++) {
                if (game!.participants[k].id == definedWinners[j]!.id) {
                  game!.participants[k].defined_prize = true;
                }
              }
            }
          }

          // Save defined winners
          game!.prizes[i].defined_winners = definedWinners;
          stageDefinedWinners = definedWinners;
          break;
        }
      }

      writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));

      sortParticipants();
    });
  }

  Function() handlerActivateParticipant(String id) {
    return () {
      setState(() {
        for (var k = 0; k < game!.participants.length; k++) {
          if (game!.participants[k].id == id) {
            game!.participants[k].defined_prize = false;
            game!.participants[k].available = true;
            writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
            break;
          }
        }
        sortParticipants(cb: handlerSendDataToWindowSpin);
      });
    };
  }

  void handlerUpdateImagePrize(String image) async {

    if (image.isEmpty) {
        setState(() {
          activePrize?.image = "";
          int index = game!.prizes.indexOf(activePrize!);
          game!.prizes[index] = activePrize!;
          writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));        
          handlerSendDataToWindowSpin();
        });
    } else {
      final dirPath = await getApplicationDocumentsDirectory();
      final destPath = '${dirPath.path}/${image.split('/').last}';

      try {
        final sourceFile = File(image);
        final dest = File(destPath);
        await sourceFile.copy(dest.path).then((value) {
          setState(() {
            activePrize?.image = dest.path;
            int index = game!.prizes.indexOf(activePrize!);
            game!.prizes[index] = activePrize!;
            writeStorage(key: "luckydraw_last_game", value: jsonEncode(game?.toJson()));
            handlerSendDataToWindowSpin();
          });
        });
      } catch (e) {
        debugPrint('Gagal menyalin file: $e');
      }
    }

  }

  void handlerSaveWindowSpinSetting(WindowSpinSettingsModel? settings) async {
    
    if (settings == null) return;

    await player.stop();

    if (isSpinning && settings.enabledSpinSound) {
        await player.play(
          (settings.spinSoundPath.isEmpty) ? AssetSource("audios/spin-sound.mp3") : DeviceFileSource(settings.spinSoundPath), 
          volume: settings.volumeSound,
          mode: PlayerMode.lowLatency
        );
        await player.setReleaseMode(ReleaseMode.loop);
    }

    if (activePrize != null && ((activePrize!.winners.length == activePrize!.total) && settings.enabledWinSound)) {
        await player.play(
          (settings.winSoundPath.isEmpty) ? AssetSource("audios/win-sound.mp3") : DeviceFileSource(settings.winSoundPath), 
          volume: settings.volumeSound,
          mode: PlayerMode.lowLatency
        );
        await player.setReleaseMode(ReleaseMode.loop);
    }

    setState(() {
      windowSpinSetting = settings;
      writeStorage(key: "luckydraw_window_spin_settings", value: jsonEncode(settings.toJson())).then((value) => {
        handlerSendDataToWindowSpin()
      });
      handlerSendDataToWindowSpin();
    });
  }

  WinnerModel? checkParticipantPrize(int index) {
    WinnerModel? winner;
    if (game != null) {
      for (var i = 0; i < game!.winners.length; i++) {
        if (game?.winners[i].participant_id == game?.participants[index].id) {
          winner = game?.winners[i];
          break;
        }
      }
    }
    return winner;
  }

  Widget _buildPrize(BuildContext context, int index) {
    return TouchableOpacity(
      onPress: handlerSelectPrize(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6, left: 8, right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: (activePrize != null && (activePrize!.id == game?.prizes[index].id)) ? Colors.blue : Colors.white10,
          borderRadius: BorderRadius.circular(6)
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "${game?.prizes[index].prize_name}",
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16
                )
              )
            ),
            if ((activePrize == null || (activePrize?.id != game?.prizes[index].id)) && (game != null && (game!.prizes[index].winners.isEmpty && (game!.prizes.length > 1)))) TouchableOpacity(
              onPress: handlerDeletePrize(index),
              child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: const Icon(
                  IconlyBroken.delete, 
                  color: Colors.red,
                  size: 18
                ),
              ), 
            ),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 41, 47, 58),
                borderRadius: BorderRadius.circular(100)
              ),
              padding: EdgeInsets.symmetric(
                horizontal: (game != null && (game!.prizes[index].total > game!.prizes[index].winners.length)) ? 8.2 : 4.2, 
                vertical: (game != null && (game!.prizes[index].total > game!.prizes[index].winners.length)) ? 2.5 : 4.2
              ),
              child: (game != null && (game!.prizes[index].total > game!.prizes[index].winners.length)) ? Text(
                "${(game!.prizes[index].winners.isNotEmpty) ? (game!.prizes[index].total-game!.prizes[index].winners.length) : game?.prizes[index].total}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14
                )
              ) : const Icon(
                Icons.check,
                color: Colors.green,
                size: 16,
              ) 
            ),
          ],
        ),
      ), 
    );
  }

  Widget _buildParticipant(BuildContext context, int index) {

    WinnerModel? prize = checkParticipantPrize(index);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      "${index+1}. ${game?.participants[index].name} ${prize != null ? "(${prize.prize_name})" : ""}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14
                      )
                    ),
                  )
                ),
                if (game != null && game!.participants[index].defined_prize) Container(
                  margin: const EdgeInsets.only(right: 13),
                  child: const Icon(
                    IconlyBroken.bookmark,
                    color: Colors.green,
                    size: 16
                  ),
                ),
              ],
            )
          ),
          if (game != null && prize == null && !game!.participants[index].available) TouchableOpacity(
            onPress: handlerActivateParticipant(game!.participants[index].id),
            child: Container(
            margin: const EdgeInsets.only(right: 12),
            child: const Icon(
                Icons.replay_outlined, 
                color: Colors.blue,
                size: 18
              ),
            ), 
          ),
          if (game != null && (game!.participants[index].available && game!.participants[index].defined_prize == false)) TouchableOpacity(
            onPress: handlerDeleteParticipant(index),
            child: Container(
            margin: const EdgeInsets.only(right: 12),
            child: const Icon(
                IconlyBroken.delete, 
                color: Colors.red,
                size: 18
              ),
            ), 
          ),
          Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
              color: (game != null && game!.participants[index].available) ? Colors.white : prize != null ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(100)
            ),
          ),
        ],
      ), 
    );
  }

  Widget _buildDetailPrize(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PickerImage(
                  onChange: handlerUpdateImagePrize, 
                  path: activePrize!.image,
                  heigth: 140,
                  width: 140,
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            activePrize!.prize_name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                        Text(
                          "Total hadiah: ${activePrize!.total}",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12
                          )
                        ),
                        Text(
                          "Sisa undian: ${activePrize!.total - activePrize!.winners.length}",
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12
                          )
                        )
                      ]
                    ),
                  ),
                )
              ]
            ),
          ),
          if (activePrize != null && activePrize!.winners.isNotEmpty) Container(
            margin: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: const Text(
                    "Pemenang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                ListView.builder(
                  itemCount: activePrize!.winners.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        "${index+1}. ${activePrize!.winners[index].name}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14
                        )
                      )
                    );
                  },
                )
              ]
            ),
          )
        ]
      )
    );
  }

  Widget _buildListWinners(BuildContext context) {

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.only(bottom: 12),
            child: const Text(
              "Pemenang",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold
              )
            ),
          ),
          (game != null && game!.winners.isNotEmpty) ? ListView.builder(
            itemCount: game!.winners.length,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6, left: 12, right: 12),
                child: Text(
                  "${index+1}. ${game!.winners[index].participant_name} - (${game!.winners[index].prize_name})",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14
                  )
                )
              );
            },
          ) : Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: const Text("-",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14
              )
            ),
          )
        ]
      )
    );
  }

  Widget _buildSlot(BuildContext ctx, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12, right: 12),
      height: 40,
      width: 180,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100))
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Center(
              child: (isSpinning || (stageSpins[index.toString()] != null && stageSpins[index.toString()]!["spin"] == true)) ? TextSpinner(
                strings: game!.participants.map((e) => e.name).toList(),
                spin: true,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14
                ),
              ) : Text(
                (stageWinners.isNotEmpty && ((index+1) <= stageWinners.length)) ? stageWinners[index].name : "Slot ${index+1}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14
                )
              ),
            ),
          ),
          if (!(stageDefinedWinners.isNotEmpty && stageDefinedWinners[index+activePrize!.winners.length] != null) && stageWinners.isNotEmpty && ((index+1) <= stageWinners.length) && ((!isSpinning && stageSpins[index.toString()] == null) || (stageSpins[index.toString()] != null && stageSpins[index.toString()]!["spin"] == false))) Positioned(
            right: 0,
            child: IconButton(
              onPressed: handlerSpinSingle(index), 
              icon: const Icon(
                Icons.replay_outlined,
                color: Colors.red,
                size: 22,
              )
            ),
          ),
          if (stageSpins[index.toString()] != null && stageSpins[index.toString()]!["spin"] == true) Positioned(
            right: 0,
            child: IconButton(
              onPressed: handlerStopSingle(index), 
              icon: const Icon(
                Icons.stop_circle,
                color: Colors.red,
                size: 22,
              )
            ),
          ),
        ],
      )
    );
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
            LuckyDrawHeader(
              isSpinning: isSpinning,
              windowSpin: windowSpin, 
              windowSpinSetting: windowSpinSetting,
              handlerOpenWindowSpin: handlerOpenWindowSpin,
              handlerSaveWindowSpinSetting: handlerSaveWindowSpinSetting,
            ),
            Expanded(
              child: Stack(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: min(MediaQuery.of(context).size.width * .275, 400),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F2937),
                          border: Border(
                            right: BorderSide(
                              color: Color.fromARGB(255, 87, 94, 103), 
                              width: 1
                            )
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 24, left: 10, top: 8),
                              child: Text(
                                "Hadiah",
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 68),
                                    child: ListView.builder(
                                      itemCount: game?.prizes.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: _buildPrize,
                                    ),
                                  ),
                                  if (activePrize == null) Positioned(
                                    bottom: 14,
                                    right: 14,
                                    child: PopUp(
                                      tag: 'addprize',
                                      padding: const EdgeInsets.all(0),
                                      popUp: PopUpItem(
                                        padding: const EdgeInsets.all(24),
                                        color: const Color.fromARGB(255, 38, 48, 65),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                                        elevation: 2,
                                        margin: EdgeInsets.symmetric(horizontal: min(MediaQuery.of(context).size.width*0.3, 720)),
                                        tag: 'addprize',
                                        child: PopUpAddPrizeContent(handlerAddPrize: handlerAddPrize),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF374251),
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        child: const Icon(
                                          IconlyBroken.plus,
                                          color:  Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.all(4),
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.08),
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(255, 87, 94, 103)
                                    )
                                  ),
                                  child: (activePrize != null) ? _buildDetailPrize(context) : _buildListWinners(context),
                                ),
                              ),
                              if (activePrize != null && activePrize!.winners.length < activePrize!.total) Expanded(
                                flex: 1,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  margin: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.08),
                                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                                    border: Border.all(
                                      width: 1,
                                      color: const Color.fromARGB(255, 87, 94, 103)
                                    )
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: ListView(
                                            scrollDirection: Axis.vertical,
                                            children: [
                                              Wrap(
                                                direction: Axis.horizontal,
                                                children: List.generate(slots, (index) => _buildSlot(context, index)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: (!isSpinning && stageWinners.isEmpty) ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                PopUp(
                                                  tag: 'setwinner',
                                                  padding: const EdgeInsets.all(0),
                                                  popUp: PopUpItem(
                                                    padding: const EdgeInsets.all(24),
                                                    color: const Color.fromARGB(255, 38, 48, 65),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                                                    elevation: 2,
                                                    margin: EdgeInsets.symmetric(horizontal: min(MediaQuery.of(context).size.width*0.3, 720)),
                                                    tag: 'setwinner',
                                                    child: activePrize != null ? PopUpDefineWinner(
                                                      prize: activePrize!,
                                                      availableParticipants: availableParticipants,
                                                      stageDefinedWinners: stageDefinedWinners,
                                                      handlerSaveDefinedWinners: handlerSaveDefinedWinners,
                                                    ) : Container(),
                                                  ),
                                                  child: Container(
                                                    margin: const EdgeInsets.all(8),
                                                    padding: const EdgeInsets.all(12),
                                                    decoration: const BoxDecoration(
                                                      color: Color(0xFF374251),
                                                      borderRadius: BorderRadius.all(Radius.circular(8))
                                                    ),
                                                    child: const Text(
                                                      "Atur Pemenang",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14
                                                      )
                                                    ),
                                                  ),
                                                ),
                                                PickerNumber(
                                                  numberRange: List.generate(min(min(activePrize!.total, (activePrize!.total - activePrize!.winners.length)), 20), (index) => index+1),
                                                  initialValue: slots,
                                                  margin: const EdgeInsets.only(right: 8, top: 4),
                                                  onChange: handlerUpdateSlots,
                                                ),
                                              ],
                                            ) : Container(),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                if (!isSpinning && stageWinners.isEmpty) TouchableOpacity(
                                                  onPress: handlerSpin,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromARGB(50, 205, 105, 222),
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),                                          
                                                    ),
                                                    child: const Text(
                                                      "Spin",
                                                      style: TextStyle(
                                                        color: Color.fromARGB(255, 204, 105, 222),
                                                        fontSize: 20
                                                      ),
                                                    ),
                                                  ) 
                                                ),
                                                if (isSpinning) TouchableOpacity(
                                                  onPress: handlerStopSpin,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white12,
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),                                          
                                                    ),
                                                    child: const Text(
                                                      "Stop",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20
                                                      ),
                                                    ),
                                                  ) 
                                                ),
                                                if (stageWinners.isNotEmpty && !isSpinning) TouchableOpacity(
                                                  onPress: handlerCancelSpin,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.white12,
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),                                          
                                                    ),
                                                    child: const Text(
                                                      "Batal",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20
                                                      ),
                                                    ),
                                                  ) 
                                                ),
                                                if (stageWinners.isNotEmpty && !isSpinning) TouchableOpacity(
                                                  onPress: handlerFall,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromARGB(55, 244, 67, 54),
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),                                          
                                                    ),
                                                    child: const Text(
                                                      "Gugur",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 20
                                                      ),
                                                    ),
                                                  ) 
                                                ),
                                                if (stageWinners.isNotEmpty && !isSpinning) TouchableOpacity(
                                                  onPress: handlerSaveWinners,
                                                  child: Container(
                                                    margin: const EdgeInsets.only(left: 8),
                                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                                    decoration: const BoxDecoration(
                                                      color: Color.fromARGB(33, 76, 175, 79),
                                                      borderRadius: BorderRadius.all(Radius.circular(8)),                                          
                                                    ),
                                                    child: const Text(
                                                      "Simpan",
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 20
                                                      ),
                                                    ),
                                                  ) 
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!hideRightPanel) Container(
                        width: min(MediaQuery.of(context).size.width * .275, 400),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1F2937),
                          border: Border(
                            left: BorderSide(
                              color: Color.fromARGB(255, 87, 94, 103), 
                              width: 1
                            )
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24, left: 20, top: 18, right: 20),
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Peserta",
                                      style: TextStyle(
                                        color: Colors.white, 
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ),
                                  TouchableOpacity(
                                    onPress: handlerRigthPanel,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6.5),
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 70, 83, 105),
                                        borderRadius: BorderRadius.all(Radius.circular(100)),
                                      ),
                                      child: const Icon(
                                        IconlyBroken.arrow_right_2,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 68, left: 10, right: 10),
                                    child: ListView.builder(
                                      itemCount: game?.participants.length,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: _buildParticipant,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 14,
                                    left: 14,
                                    child: PopUp(
                                      tag: 'addparticipant',
                                      padding: const EdgeInsets.all(0),
                                      popUp: PopUpItem(
                                        padding: const EdgeInsets.all(24),
                                        color: const Color.fromARGB(255, 38, 48, 65),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                                        elevation: 2,
                                        margin: EdgeInsets.symmetric(horizontal: min(MediaQuery.of(context).size.width*0.3, 720)),
                                        tag: 'addparticipant',
                                        child: PopUpAddParticipantContent(handlerAddParticipant: handlerAddParticipant),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF374251),
                                          borderRadius: BorderRadius.all(Radius.circular(8))
                                        ),
                                        child: const Icon(
                                          IconlyBroken.plus,
                                          color:  Colors.white,
                                          size: 28,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            )
                          ],
                        )
                      ),
                    ],
                  ),
                  if (hideRightPanel) Positioned(
                    top: 12,
                    right: -4,
                    child: TouchableOpacity(
                      onPress: handlerRigthPanel,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 70, 83, 105),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(100),
                            bottomLeft: Radius.circular(100)
                          ),
                        ),
                        child: const Icon(
                          IconlyBroken.arrow_left_2,
                          color: Colors.white,
                          size: 20,
                        )
                      ),
                    )
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}

class PopUpAddPrizeContent extends StatefulWidget {

  final Function(String, String)? handlerAddPrize;

  const PopUpAddPrizeContent({
    super.key,
    this.handlerAddPrize
  });

  @override
  State<PopUpAddPrizeContent> createState() => _PopUpAddPrizeContentState();
}

class _PopUpAddPrizeContentState extends State<PopUpAddPrizeContent> {

  String prize_name = "";
  String total = "";
  
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Tambah Hadiah", style: TextStyle(color: Colors.white, fontSize: 24),),

          const Divider(
            color: Colors.white,
            thickness: 0.2,
          ),

          Input(
            onChanged: (value) => setState(() => prize_name = value),
            placeholder: "Masukkan nama hadiah",
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          Input(
            onChanged: (value) => setState(() => total = value),
            placeholder: "Masukkan jumlah hadiah (Masukkan angka)",
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Hanya mengizinkan angka
            ],
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          Center(
            child: TouchableOpacity(
              onPress: () {
                widget.handlerAddPrize!(prize_name, total);
                Navigator.pop(context);
              },
              disable: (prize_name.isEmpty || total.isEmpty),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 189, 65, 211),
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Text("Tambah", style: appStyles["text"]!["bold1White"]),
              )
            ),
          ),
        ],
      ),
    );
  }
}

class PopUpAddParticipantContent extends StatefulWidget {

  final Function(String)? handlerAddParticipant;

  const PopUpAddParticipantContent({
    super.key,
    this.handlerAddParticipant
  });

  @override
  State<PopUpAddParticipantContent> createState() => _PopUpAddParticipantContentState();
}

class _PopUpAddParticipantContentState extends State<PopUpAddParticipantContent> {

  String name = "";
  
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Tambah Peserta", style: TextStyle(color: Colors.white, fontSize: 24),),

          const Divider(
            color: Colors.white,
            thickness: 0.2,
          ),

          Input(
            onChanged: (value) => setState(() => name = value),
            placeholder: "Masukkan nama peserta",
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          Center(
            child: TouchableOpacity(
              onPress: () {
                widget.handlerAddParticipant!(name);
                Navigator.pop(context);
              },
              disable: (name.isEmpty),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 189, 65, 211),
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Text("Tambah", style: appStyles["text"]!["bold1White"]),
              )
            ),
          ),
        ],
      ),
    );
  }
}