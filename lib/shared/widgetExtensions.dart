import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  Widget addPaddingTop(double height) {
    return Padding(
      padding: EdgeInsets.only(top: height),
      child: this,
    );
  }

  Widget addPaddingBottom(double height) {
    return Padding(
      padding: EdgeInsets.only(bottom: height),
      child: this,
    );
  }
}
