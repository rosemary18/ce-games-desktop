import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TextSpinner extends StatefulWidget {

  final List<String> strings;
  final TextStyle? style;
  final bool spin;
  
  const TextSpinner({
    super.key,
    required this.strings,
    this.style,
    this.spin = false
  });

  @override
  State<TextSpinner> createState() => _TextSpinnerState();
}

class _TextSpinnerState extends State<TextSpinner> {

  String _text = "";
  late Timer _timer;
  bool strip = true;

  @override
  void initState() {
    super.initState();
    if (widget.spin) _timer = Timer.periodic(const Duration(milliseconds: 50), _updateCounter);
  }

  @override
  void didUpdateWidget(covariant TextSpinner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spin) _timer = Timer.periodic(const Duration(milliseconds: 50), _updateCounter);
    else if (_timer.isActive) _timer.cancel();
  }

  void _updateCounter(Timer timer) {
    if (mounted) {
      setState(() {
        _text = strip ? "---" : widget.strings[Random().nextInt(widget.strings.length-1) + 1];
        strip = !strip;
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaler: const TextScaler.linear(1),
      style: widget.style,
    );
  }
}