import 'package:flutter/material.dart';
import 'package:naytto/src/constants/theme.dart';

class CommonContainer extends Container {
  final double? height;
  final double? width;
  final Widget child;

  CommonContainer({this.height, this.width, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: colors(context).color3,
      ),
      child: child,
    );
  }
}
