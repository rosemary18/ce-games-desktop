import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

class DetailHeader extends StatelessWidget {

  final String? title;
  
  const DetailHeader({
    super.key, 
    this.title = ""
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, right: 40, top: 40, bottom: 10),
      width: double.infinity,
      child: Row(
        children: [
          TouchableOpacity(
            activeOpacity: .6,
            onPress: () => context.pop(),
            child: const Icon(
              IconlyBroken.arrow_left_2,
              color:  Color.fromARGB(255, 204, 105, 222),
              size: 30,
            ), 
          ),
          Container(
            margin: const EdgeInsets.only(left: 24),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }
}