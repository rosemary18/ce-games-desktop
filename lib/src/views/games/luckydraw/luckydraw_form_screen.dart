import 'dart:convert';
import 'dart:typed_data';

import 'package:cegames/src/index.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

class LuckyDrawFormScreen extends StatefulWidget {
  const LuckyDrawFormScreen({super.key});

  @override
  State<LuckyDrawFormScreen> createState() => _LuckyDrawFormScreenState();
}

class _LuckyDrawFormScreenState extends State<LuckyDrawFormScreen> {

  final storage = const FlutterSecureStorage();
  String pathPrizes = "";
  String pathParticipants = "";

  @override
  void initState() {
    super.initState();
  }

  void handlerDownloadTemplate() async {

    const String prizeFileName = 'luckydraw_daftar_hadiah.txt';
    const String prizeFileContent = "*Note: Masukkan hadiah dan jumlah hadiah dipisahkan dengan koma. Setiap hadiah dipisahkan dengan baris baru atau enter. (Note ini jangan dihapus dan tetap terpisah dengan satu baris)\n\nJam Alexander Christie, 2\nTiket Wisata Marbabu, 5\nMobil Civic Full Hybrid, 3";
    const String participantFileName = 'luckydraw_daftar_peserta.txt';
    const String participantFileContent = "*Note: Masukkan nama pemain/peserta dipisahakan dengan baris baru / enter. (Note ini jangan dihapus dan tetap terpisah dengan satu baris)\n\nBagus Ardana\nDeliana Mufas\nArkham Jala\nIvan Vilo\nGarim Aklu\nZuya Axe\nCoppa Vanhi\nArian Tuguf\nLuffy\nToni Hamka\nAbdu Rizy\nArya Manud";
    
    final FileSaveLocation? saveLocationPrize = await getSaveLocation(suggestedName: prizeFileName);

    if (saveLocationPrize == null) {
      return;
    } else {
      final Uint8List fileData = Uint8List.fromList(prizeFileContent.codeUnits);
      const String mimeType = 'text/plain';
      final XFile textFile = XFile.fromData(fileData, mimeType: mimeType, name: prizeFileName);
      await textFile.saveTo(saveLocationPrize.path);
    }

    final FileSaveLocation? saveLocationParticipant = await getSaveLocation(suggestedName: participantFileName);

    if (saveLocationParticipant == null) {
      return;
    } else {
      final Uint8List fileData = Uint8List.fromList(participantFileContent.codeUnits);
      const String mimeType = 'text/plain';
      final XFile textFile = XFile.fromData(fileData, mimeType: mimeType, name: participantFileName);
      await textFile.saveTo(saveLocationParticipant.path);
    }

  }

  Function() handlerStartGame(BuildContext ctx) {

    return () async {

      LuckyDrawGameModel? last_game;
      LuckyDrawHistoryModel history = LuckyDrawHistoryModel(history: []);

      await readStorage(key: "luckydraw_history", cb: (value) {
        if (value != null) {
          setState(() {
            history = LuckyDrawHistoryModel.fromJson(jsonDecode(value));
          });
        }
      });

      readStorage(key: "luckydraw_last_game", cb: (value) {
        if (value != null) {
          setState(() {
            last_game = LuckyDrawGameModel.fromJson(jsonDecode(value));
          });
        }
      });

      LuckyDrawGameModel newGame = LuckyDrawGameModel(
        id: generateRandomString(8),
        date_last_play: DateTime.now(),
        date_play: DateTime.now(),
        prizes: [],
        participants: [],
        winners: [],
      );
      
      String? prizesData = await readFile(pathPrizes);
      String? participantsData = await readFile(pathParticipants);
      List<String> prizes = prizesData.toString().split('\n\n')[1].toString().split('\n');
      List<String> participants = participantsData.toString().split('\n\n')[1].toString().split('\n');

      for (var i = 0; i < prizes.length; i++) {
        newGame.prizes.add(PrizeModel(
          id: generateRandomString(8), 
          prize_name: prizes[i].split(',')[0].toString(), 
          total: prizes[i].split(',')[1].toString().isEmpty ? 0 : int.parse(prizes[i].split(',')[1]), 
          winners: [], 
          defined_winners: []
        ));
      }
      
      for (var i = 0; i < participants.length; i++) {
        newGame.participants.add(ParticipantModel(
          id: generateRandomString(8),
          available: true,
          name: participants[i].toString(),
          defined_prize: false
        ));
      }

      String encoded = jsonEncode(newGame.toJson());

      await writeStorage(key: 'luckydraw_game', value: encoded);
      await writeStorage(key: 'luckydraw_last_game', value: encoded);
      
      if (last_game != null) {
        history.history.add(last_game!);
        await writeStorage(key: 'luckydraw_history', value: jsonEncode(history.toJson()));
      }

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
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 400,
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    height: double.infinity,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFF374251),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Column(
                      children: [
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 12),
                            child: Text("Mulai Baru", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF101827),
                              borderRadius: BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      PickerFile(
                                        title: "Upload file hadiah",
                                        onChange: (path) => setState(() => pathPrizes = path),
                                        margin: const EdgeInsets.all(4),
                                      ),
                                      PickerFile(
                                        title: "Upload file peserta",
                                        onChange: (path) => setState(() => pathParticipants = path),
                                        margin: const EdgeInsets.all(4),
                                      ),
                                    ],
                                  )
                                ),
                                TouchableOpacity(
                                  onPress: handlerDownloadTemplate,
                                  child: const Text(
                                    "** Simpan template file hadiah dan peserta game ←", 
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color.fromARGB(255, 70, 52, 210),
                                      decoration: TextDecoration.underline
                                    ),
                                  ), 
                                ),
                              ]
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TouchableOpacity(
                        onPress: () {
                          context.pop();
                          context.pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                          margin: const EdgeInsets.only(top: 12, right: 6),
                          decoration:  BoxDecoration(
                            color: const Color(0xFF374251),
                            borderRadius:const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: const Color(0xFF374251),
                              width: 1
                            )
                          ),
                          child: const Center(
                            child: Text("Kembali", style: TextStyle(color: Colors.white),),
                          ),
                        )
                      )
                    ),
                    Expanded(
                      child: TouchableOpacity(
                        onPress: handlerStartGame(context),
                        disable: pathPrizes.isEmpty || pathParticipants.isEmpty,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                          margin: const EdgeInsets.only(top: 12, left: 6),
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: Colors.blue,
                              width: 1
                            )
                          ),
                          child: const Center(
                            child: Text("Mulai", style: TextStyle(color: Colors.blue),),
                          ),
                        )
                      )
                    ),
                  ],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}