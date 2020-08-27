import 'package:flutter/material.dart';

class InheritedIconButton extends StatelessWidget {
  final Function onPressed;

  final Icon icon;

  final EdgeInsets padding;

  const InheritedIconButton({Key key, this.onPressed, this.icon, this.padding});

  @override
  Widget build(BuildContext context) {
    IconThemeData iconThemeData = IconTheme.of(context);
    return IconButton(
      onPressed: onPressed,
      iconSize: iconThemeData.size,
      icon: icon,
      padding: padding,
    );
  }
}
