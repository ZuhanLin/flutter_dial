
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_dial/dial_painter.dart';

enum DialRotateType {
  ticker,
  smooth,
}

class DialPage extends StatefulWidget {
  const DialPage({Key? key, this.rotateType = DialRotateType.ticker})
      : super(key: key);

  final DialRotateType? rotateType;

  @override
  State<DialPage> createState() => _DialPageState();
}

class _DialPageState extends State<DialPage> with SingleTickerProviderStateMixin {

  AnimationController? _secondAnimationController;
  Animation<double>? _secondAnimation;

  @override
  void initState() {
    super.initState();

    if (widget.rotateType == DialRotateType.smooth) {
      _secondAnimationController =
          AnimationController(vsync: this, duration: Duration(seconds: 60));
      double begin = 2 * pi / 60 * (DateTime.now().second - 15);
      double end = begin + 2 * pi;
      _secondAnimation =
          Tween(begin: begin, end: end).animate(_secondAnimationController!);
      _secondAnimationController?.repeat();
    } else if (widget.rotateType == DialRotateType.ticker) {
      Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {});
      });
    }
  }
  @override
  void dispose() {
    _secondAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: const Color.fromARGB(255, 35, 36, 38),
      child: Center(
        child: widget.rotateType == DialRotateType.smooth
            ? AnimatedBuilder(
          animation: _secondAnimationController!,
          builder: (context, widget) {
            return CustomPaint(
              // 使用CustomPaint
              size: Size(width, width),
              painter: DialPainter(secondAngle: _secondAnimation?.value),
            );
          },
        )
            : CustomPaint(
          size: Size(width, width),
          painter: DialPainter(),
        ),
      ),
    );
  }
}


