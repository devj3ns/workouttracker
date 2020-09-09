import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Function onTap;
  final bool disable;
  final IconData icon;
  final Widget iconWidget;
  final String heroTag;

  RoundIconButton({
    @required this.onTap,
    this.disable,
    this.icon,
    this.iconWidget,
    this.heroTag = "",
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColors = [
      Color.fromRGBO(20, 202, 201, 1),
      Color.fromRGBO(35, 233, 160, 1),
    ];

    Color iconColor = Colors.white;

    if (disable != null) {
      if (disable == true) {
        gradientColors = [
          Color.fromRGBO(20, 202, 201, 1).withOpacity(0.8),
          Color.fromRGBO(35, 233, 160, 1).withOpacity(0.8),
        ];

        iconColor = Colors.white.withOpacity(0.8);
      }
    }

    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: disable != null && disable ? () {} : onTap,
      child: Hero(
        tag: heroTag,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(5, 5),
                blurRadius: 10,
              )
            ],
          ),
          child: Center(
            child: iconWidget == null && icon != null
                ? Icon(
                    icon,
                    color: iconColor,
                    size: 30,
                  )
                : iconWidget,
          ),
        ),
      ),
    );
  }
}
