// ignore_for_file: prefer_function_declarations_over_variables

import 'package:flutter/material.dart';

class TouchableOpacity extends StatefulWidget {

  final Widget child;
  final double activeOpacity;
  final bool disable;
  final void Function() onPress;

  const TouchableOpacity({
    super.key, 
    required this.child, 
    required this.onPress,
    this.activeOpacity = 0.7,
    this.disable = false
  });

  @override
  State<TouchableOpacity> createState() => _TouchableOpacityState();
}

class _TouchableOpacityState extends State<TouchableOpacity> {

  double _co = 1.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => setState(() => _co = widget.activeOpacity),
      onPointerUp: (event) => setState(() => _co = 1.0),
      child: GestureDetector(
        onTap: widget.disable ? () {} : widget.onPress,
        child: AnimatedOpacity(
          opacity: widget.disable ? 0.5 : _co,
          duration: const Duration(milliseconds: 200),
          child: widget.child
        ),
      ),
    );
  }
}