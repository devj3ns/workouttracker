import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'mySliderThumbs.dart';

class MySlider extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final int divisions;
  final IconData icon;
  final String text;
  final fullWidth;
  final Function changeValue;
  final bool isDurationSlider;
  final bool isIntensitySlider;
  final bool isRatingSlider;
  final double initialValue;

  MySlider({
    this.sliderHeight = 65,
    @required this.max,
    @required this.min,
    @required this.divisions,
    @required this.icon,
    @required this.text,
    @required this.changeValue,
    this.isDurationSlider = false,
    this.isRatingSlider = false,
    this.isIntensitySlider = false,
    this.fullWidth = false,
    this.initialValue,
  });

  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  double _value = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _value = widget.initialValue / widget.max;
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (this.widget.fullWidth) paddingFactor = .3;

    return Container(
      width: this.widget.fullWidth
          ? double.infinity
          : (this.widget.sliderHeight) * 5.5,
      height: (this.widget.sliderHeight),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.all(
          Radius.circular((this.widget.sliderHeight * .15)),
        ),
        gradient: new LinearGradient(
            colors: [
              const Color(0xFF00c6ff),
              const Color(0xFF0072ff),
            ],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 1.00),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(this.widget.sliderHeight * 0.2, 0,
            this.widget.sliderHeight * 0.1, 0),
        child: Row(
          children: <Widget>[
            widget.isIntensitySlider
                ? FaIcon(
                    widget.icon,
                    color: Colors.white,
                    size: this.widget.sliderHeight * 0.275,
                  )
                : Icon(
                    widget.icon,
                    color: Colors.white,
                  ),
            SizedBox(
              width: this.widget.sliderHeight * 0.075,
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 5.0,
                  thumbShape: widget.isDurationSlider
                      ? MySliderThumbRect(
                          thumbRadius: this.widget.sliderHeight * 0.3,
                          thumbHeight: this.widget.sliderHeight * 0.7,
                          min: this.widget.min,
                          max: this.widget.max,
                        )
                      : MySliderThumbCircle(
                          thumbRadius: this.widget.sliderHeight * 0.25,
                          min: this.widget.min,
                          max: this.widget.max,
                          isRating: this.widget.isRatingSlider,
                        ),
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  activeTickMarkColor: Colors.white,
                  inactiveTickMarkColor: Colors.white.withOpacity(0.5),
                ),
                child: Slider(
                  value: _value,
                  divisions: this.widget.divisions,
                  onChanged: (val) {
                    setState(() {
                      widget.changeValue(val * widget.max);
                      _value = val;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
