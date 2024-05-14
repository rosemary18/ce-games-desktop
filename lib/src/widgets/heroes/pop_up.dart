import 'package:flutter/material.dart';
import 'hero_route.dart';

class PopUp extends StatelessWidget {

  final Object? tag;
  final Widget? child;
  final Widget? popUp;
  final EdgeInsets? padding;

  const PopUp({
    super.key, 
    this.tag, 
    this.child, 
    this.popUp, 
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return popUp!;
          }));
        },
        child: Hero(
          tag: tag!,
          child: child!,
        ),
      ),
    );
  }
}

class PopUpItem extends StatelessWidget {

  final Object tag;
  final Widget child;
  final Color color;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final ShapeBorder shape;

  const PopUpItem({
    super.key,
    required this.tag,
    required this.child,
    required this.color,
    required this.padding,
    this.margin = const EdgeInsets.all(32),
    required this.shape,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: margin!,
        child: Hero(
          tag: tag,
          transitionOnUserGestures: true,
          child: Material(
            color: color,
            elevation: elevation,
            shape: shape,
            child: SingleChildScrollView(
              child: Container(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}