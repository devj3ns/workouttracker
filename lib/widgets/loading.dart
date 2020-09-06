import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final bool scaffold;

  Loading({
    this.scaffold = false,
  });

  @override
  Widget build(BuildContext context) {
    return scaffold
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SpinKitDoubleBounce(
                color: Colors.blueGrey,
                size: 50.0,
              ),
            ),
          )
        : Container(
            child: Center(
              child: SpinKitDoubleBounce(
                color: Colors.blueGrey,
                size: 50.0,
              ),
            ),
          );
  }
}
