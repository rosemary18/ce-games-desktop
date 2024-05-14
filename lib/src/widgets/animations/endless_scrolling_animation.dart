import 'package:flutter/material.dart';

class EndlessScrollingAnimation extends StatefulWidget {

  final List<Widget> children;
  final double height;
  final double? width;
  final EdgeInsets margin;
  final Duration animationDuration;
  final CrossAxisAlignment crossAxisAlignment;

  const EndlessScrollingAnimation({
    super.key,
    required this.children,
    this.height = 500,
    this.width,
    this.margin = EdgeInsets.zero,
    this.animationDuration = const Duration(seconds: 12),
    this.crossAxisAlignment = CrossAxisAlignment.center
  });

  @override
  State<EndlessScrollingAnimation> createState() => _EndlessScrollingAnimationState();
}

class _EndlessScrollingAnimationState extends State<EndlessScrollingAnimation> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset(0, widget.height), 
    end: Offset(0, -widget.height+20),
  ).animate(_controller);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,  
      duration: const Duration(seconds: 10)
    )
    ..repeat()
    ..addListener(() { 
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(),
      height: widget.height,
      width: widget.width,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.transparent, Colors.black, Colors.black, Colors.transparent,], 
            begin: Alignment.topCenter, 
            end: Alignment.bottomCenter,
            stops: [0.02, 0.12, 0.88, 0.975],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstIn,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          child: Transform.translate(
            offset: _animation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: widget.crossAxisAlignment,
              children: widget.children,
            )
          )
        ),
      ),
    );
  }
}