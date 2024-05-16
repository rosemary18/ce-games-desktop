import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cegames/src/index.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iconly/iconly.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DetailHeader(title: "Pengaturan",),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PopUp(
                          tag: 'cpass',
                          padding: const EdgeInsets.all(0),
                          popUp: PopUpItem(
                            padding: const EdgeInsets.all(24),
                            color: const Color.fromARGB(255, 38, 48, 65),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
                            elevation: 2,
                            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.3),
                            tag: 'cpass',
                            child: const PopUpChangePassContent(),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 38, 48, 65),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right:24),
                                  child: const Icon(
                                    IconlyBroken.password,
                                    color:  Colors.white54,
                                    size: 32,
                                  ),
                                ),
                                const Text("Ubah password", style: TextStyle(fontSize: 28, color: Colors.white)),
                              ],
                            ),
                          )  
                        ),
                        TouchableOpacity(
                          onPress: () => exit(0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 38, 48, 65),
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 24),
                                  child: const Icon(
                                    IconlyBroken.logout,
                                    color:  Colors.white54,
                                    size: 32,
                                  ),
                                ),
                                const Text("Keluar", style: TextStyle(fontSize: 28, color: Colors.white)),
                              ],
                            ),
                          )                            
                        ),
                      ],
                    )
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

class PopUpChangePassContent extends StatefulWidget {
  const PopUpChangePassContent({super.key});

  @override
  State<PopUpChangePassContent> createState() => _PopUpChangePassContentState();
}

class _PopUpChangePassContentState extends State<PopUpChangePassContent> {

  String password = "";
  String passwordConfirm = "";
  final storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ubah Password", style: TextStyle(color: Colors.white, fontSize: 24),),

          const Divider(
            color: Colors.white,
            thickness: 0.2,
          ),

          Input(
            onChanged: (value) => setState(() => password = value),
            placeholder: "Password",
            obscure: true,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          Input(
            onChanged: (value) => setState(() => passwordConfirm = value),
            placeholder: "Confirm Password",
            onSubmitted: (value) async {
              if (!((password.isEmpty || passwordConfirm.isEmpty) || (password != passwordConfirm))) {
                await writeStorage(key: "password", value: password);
                Navigator.pop(context);
              }
            },
            obscure: true,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          
          Center(
            child: TouchableOpacity(
              onPress: () async {
                if (!((password.isEmpty || passwordConfirm.isEmpty) || (password != passwordConfirm))) {
                  await writeStorage(key: "password", value: password);
                  Navigator.pop(context);
                }
              },
              disable: (password.isEmpty || passwordConfirm.isEmpty) || (password != passwordConfirm),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 189, 65, 211),
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Text("Simpan", style: appStyles["text"]!["bold1White"]),
              )
            ),
          ),
        ],
      ),
    );
  }
}