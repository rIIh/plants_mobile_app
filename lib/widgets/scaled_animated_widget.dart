import 'package:flutter/material.dart';

class ScaledAnimatedWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool inversed;
  final Curve curve;

  const ScaledAnimatedWidget({
    Key key,
    this.child,
    this.duration = const Duration(
      milliseconds: 200,
    ),
    this.inversed = false,
    this.curve = Curves.easeInOut,
  }) : super(key: key);

  @override
  _ScaledAnimatedWidgetState createState() => _ScaledAnimatedWidgetState();
}

class _ScaledAnimatedWidgetState extends State<ScaledAnimatedWidget> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  double get initial => widget.inversed ? 1 : 0;

  double get target => widget.inversed ? 0 : 1;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration, value: initial);
    _controller.animateTo(target, curve: widget.curve);
    super.initState();
  }

  @override
  void didUpdateWidget(ScaledAnimatedWidget oldWidget) {
    if (oldWidget.inversed != widget.inversed) {
      _controller.value = initial;
      _controller.animateTo(target, curve: widget.curve);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: widget.child,
    );
  }
}
