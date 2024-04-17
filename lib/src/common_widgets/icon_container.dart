import 'package:flutter/material.dart';
import 'package:naytto/src/constants/theme.dart';

class IconContainer extends Container {
  final double? height;
  final double? width;
  final String iconText;
  final IconButton icon;

  IconContainer(
      {this.height,
      this.width,
      required this.iconText,
      required this.icon,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 95,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: colors(context).color1,
        border: Border.all(
            // color: Color.fromRGBO(0, 124, 124, 1),
            color: Colors.black,
            width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          Text(
            iconText,
            style: Theme.of(context).textTheme.displaySmall,
          )
        ],
      ),
    );
  }
}
