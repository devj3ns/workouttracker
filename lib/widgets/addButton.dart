import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {

  final Function onTap;
  final bool disable;

  AddButton({@required this.onTap, this.disable});



  @override
  Widget build(BuildContext context) {

    List<Color> gradientColors = [
      Color.fromRGBO(20, 202, 201, 1),
      Color.fromRGBO(35, 233, 160, 1),
    ];
    
    Color iconColor = Colors.white;
    
    if(disable != null){
      if(disable == true){
        gradientColors = [
          Color.fromRGBO(20, 202, 201, 1).withOpacity(0.8),
          Color.fromRGBO(35, 233, 160, 1).withOpacity(0.8),
        ];
        
        iconColor = Colors.white.withOpacity(0.8);
      }
    }
    
    return GestureDetector(
      onTap:  disable != null && disable ? (){} : onTap,
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
          child: Icon(
            Icons.add,
            color: iconColor,
            size: 30,
          ),
        ),
      ),
    );
  }
}
