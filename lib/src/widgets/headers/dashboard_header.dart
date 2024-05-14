import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class DashboardHeader extends StatelessWidget {

  const DashboardHeader({super.key});

  Future<Object?> Function() handlerSetting(BuildContext ctx) {
    return () => ctx.pushNamed("setting");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 10),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Games",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white
            ),
          ),
          TouchableOpacity(
            activeOpacity: .6,
            onPress: handlerSetting(context),
            child: const Icon(
              IconlyBroken.setting,
              color:  Color.fromARGB(255, 204, 105, 222),
              size: 30,
            ), 
          )
        ],
      ),
    );
  }
}