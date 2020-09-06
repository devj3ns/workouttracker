import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color borderColor;
  final double borderRadius;

  FrostedBox({@required this.child, this.color, this.borderColor = Colors.transparent, this.borderRadius = 6});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: color == null
                  ? Colors.grey.shade200.withOpacity(0.5)
                  : color.withOpacity(0.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
