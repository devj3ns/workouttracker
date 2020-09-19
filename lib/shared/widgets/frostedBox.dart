import 'dart:ui';

import 'package:flutter/material.dart';

class FrostedBox extends StatelessWidget {
  final Widget child;
  final Color customColor;
  final double borderRadius;
  final bool colorHighlight;
  final bool borderHighlight;
  final Function onTap;

  FrostedBox({
    @required this.child,
    this.customColor,
    this.borderRadius = 8,
    this.colorHighlight = false,
    this.borderHighlight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius - 1),
      onTap: onTap,
      child: Container(
        decoration: borderHighlight
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.black12.withOpacity(0.5),
                ),
              )
            : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 1),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                color: customColor == null
                    ? colorHighlight
                        ? Colors.blueGrey[100].withOpacity(0.5)
                        : Colors.grey.shade200.withOpacity(0.5)
                    : customColor,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
