import 'package:flutter/material.dart';

import 'package:workouttracker/shared/widgets/frostedBox.dart';

class RoundedSquareButton extends StatelessWidget {
  final IconData icon;
  final Function onTap;
  final Color color;

  RoundedSquareButton({
    @required this.icon,
    @required this.onTap,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width * 0.14,
      width: MediaQuery.of(context).size.width * 0.14,
      child: FrostedBox(
        customColor: color.withOpacity(0.9),
        onTap: () => onTap(),
        child: Icon(
          icon,
          color: Colors.white,
          size: 23,
        ),
      ),
    );
  }
}
