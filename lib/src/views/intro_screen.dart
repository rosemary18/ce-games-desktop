import 'dart:async';
import 'dart:convert';
import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oktoast/oktoast.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  double opcIcon = 0;
  double opcBg = 0;
  double opcForm = 0;
  String token = "";
  String activationId = "";
  ActivationModel? activation;
  final passwordField = TextEditingController();
  final tokenField = TextEditingController();
  final activationIdField = TextEditingController();
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();

    readStorage(key: "activation", cb: (value) {
      if (value != null) {
        setState(() {
          activation = ActivationModel.fromJson(jsonDecode(value));
          Timer(const Duration(milliseconds: 500), () {
            Duration diff = DateTime.now().difference(activation!.lastCheck);
            if (diff.inDays >= 7) handlerReactivation();
          });
        });
      }
    });

    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        opcIcon = 1;
        Timer(const Duration(milliseconds: 2000), () {
          setState(() {
            opcIcon = 0;
            Timer(const Duration(milliseconds: 2000), () {
              setState(() {
                opcBg = .2;
                opcForm = 1;
              });
            });
          });
        });
      });
    });

    writeStorage(key: "password", value: "admin");
  }

  String handlerChiperToken(String token) {

    String res = "";
    List<String> tokenChars = token.split("");
    List<String> chars = "abcdefghijkl0123456789mnopqrstuvwxyz".split("");

    for (int i = 0; i < tokenChars.length; i++) {
      int idx = chars.indexOf(tokenChars[i]);
      if (idx != -1) {
        int nidx = (idx - 10) % chars.length;
        if (nidx < 0) nidx += chars.length;
        res += chars[nidx];
      } else {
        res += tokenChars[i];
      }
    }

    return res;
  }

  void handlerActivation() async {

    String link = "";

    if (activation != null) {
      link = activation!.link;
    } else {
      Map<String, dynamic> payload = JwtDecoder.decode(handlerChiperToken(token));
      if (payload.containsKey("exp") && payload.containsKey("link")) {
        DateTime exp = DateFormat("dd/MM/yyyy").parse(payload["exp"].toString());
        if (exp.isBefore(DateTime.now())) {
          showToast(
            'Token expired',
            position: ToastPosition.top,
            backgroundColor: const Color.fromARGB(145, 244, 67, 54),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          );
          return;
        } else {
          link = payload["link"].toString();
        }
      }
    }

    await http.get(Uri.parse(link)).then((response) {
      if (response.statusCode == 200) {
        List<dynamic> data = [];
        bool valid = false;

        try {
          data = jsonDecode(response.body);
        } catch (e) {
          debugPrint(e.toString());
        }

        if (data.isNotEmpty) {

          for (int i = 0; i < data.length; i++) {
            if (data[i] == activationId) valid = true;
          }

          if (valid) {
            setState(() {

              activation = ActivationModel(
                activationCode: activationId,
                link: link,
                lastCheck: DateTime.now(),
              );

              writeStorage(key: "password", value: "admin");
              writeStorage(key: "activation", value: jsonEncode(activation!.toJson()));

              showToast(
                'Aktivasi berhasil!',
                position: ToastPosition.top,
                backgroundColor: const Color.fromARGB(145, 52, 199, 89),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              );

            });
          } else {

            showToast(
              'Kode aktivasi salah',
              position: ToastPosition.top,
              backgroundColor: const Color.fromARGB(145, 244, 67, 54),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            );
          }

        } else {
          showToast(
            'Tidak ditemukan kode aktivasi pada token yang ada!',
            position: ToastPosition.top,
            backgroundColor: const Color.fromARGB(145, 244, 67, 54),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          );
        }
      } else {
        showToast(
          'Periksa jaringan anda atau pastikan token benar!',
          position: ToastPosition.top,
          backgroundColor: const Color.fromARGB(145, 244, 67, 54),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );
      }
    });

  }

  void handlerReactivation() async {

    if (activation == null) return;

    await http.get(Uri.parse(activation!.link)).then((response) {

      if (response.statusCode >= 200 || response.statusCode < 300) {

        List<dynamic> data = [];
        bool valid = false;

        try {
          data = jsonDecode(response.body);
        } catch (e) {
          debugPrint(e.toString());
        }

        if (data.isNotEmpty) {

          for (int i = 0; i < data.length; i++) {
            if (data[i] == activationId) valid = true;
          }

          if (valid) {
            setState(() {
              activation!.lastCheck = DateTime.now();
              writeStorage(key: "activation", value: jsonEncode(activation!.toJson()));
            });
          } else {
            setState(() {
              activation = null;
              storage.delete(key: "activation");
            });
            showToast(
              'Aktivasi telah berakhir!',
              position: ToastPosition.top,
              backgroundColor: const Color.fromARGB(145, 244, 67, 54),
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            );
          }

        } else {
          setState(() {
            activation = null;
            storage.delete(key: "activation");
          });
          showToast(
            'Aktivasi telah berakhir!',
            position: ToastPosition.top,
            backgroundColor: const Color.fromARGB(145, 244, 67, 54),
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          );
        }
      } else {
        showToast(
          'Aktivasi telah berakhir!',
          position: ToastPosition.top,
          backgroundColor: const Color.fromARGB(145, 244, 67, 54),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        );
      }
    });
  }

  Future<void> Function() handlerSignIn(BuildContext ctx) {
    return () async {
      String? password = await storage.read(key: "password");
      if (password == passwordField.text) ctx.pushNamed("dashboard");
      else {
        showToast(
          'Kata sandi salah',
          position: ToastPosition.top,
          backgroundColor: const Color.fromARGB(145, 244, 67, 54),
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
    };
  }

  Future<void> Function(String? value) handlerSubmit(BuildContext ctx) {
    return (String? value) => handlerSignIn(ctx)();
  }

  Widget buildActivationView(BuildContext ctx) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Input(
            controller: tokenField,
            width: 200,
            onChanged: (v) => setState(() => token = v),
            placeholder: "Token",
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          ),
          Input(
            controller: activationIdField,
            width: 200,
            onChanged: (v) => setState(() => activationId = v),
            placeholder: "Activation ID",
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          ),
          TouchableOpacity(
            onPress: handlerActivation,
            disable: (token.isEmpty || activationId.isEmpty),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
              margin: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 189, 65, 211),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              child: Text("Aktivasi", style: appStyles["text"]!["bold1White"]),
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black,
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Stack(
                children: [
                  AnimatedOpacity(
                    opacity: opcBg,
                    duration: const Duration(milliseconds: 1000),
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Image.asset(
                        appImages["IMG_INTRO_BG"]!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: opcForm,
                    duration: const Duration(milliseconds: 1000),
                    child: SizedBox(
                        height: double.infinity,
                        width: double.infinity,
                        child: (activation == null) ? buildActivationView(context) : SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: Center(
                            child: SizedBox(
                              width: 300,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 120,
                                    width: 170,
                                    child: Image.asset(appIcons["IC_APP"]!),
                                  ),
                                  Input(
                                    controller: passwordField,
                                    onSubmitted: handlerSubmit(context),
                                    placeholder: "Password",
                                    obscure: true,
                                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                                  ),
                                  TouchableOpacity(
                                    onPress: handlerSignIn(context),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                                      margin: const EdgeInsets.all(24),
                                      decoration: const BoxDecoration(
                                        color: Color.fromARGB(255, 189, 65, 211),
                                        borderRadius: BorderRadius.all(Radius.circular(4)),
                                      ),
                                      child: Text("Masuk", style: appStyles["text"]!["bold1White"]),
                                    )
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),
            (opcForm != 1) ? AnimatedOpacity(
              opacity: opcIcon,
              curve: Easing.standard,
              duration: const Duration(milliseconds: 2000),
              child: Center(
                child: SizedBox(
                  height: 400,
                  width: 400,
                  child: Image.asset(appIcons["IC_APP"]!),
                ),
              ),
            ) : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
