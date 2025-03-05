import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SliderStadistic extends StatelessWidget {
  const SliderStadistic({required this.textEstadistics, required this.color, required this.value, this.isPV = false, super.key});


  final String textEstadistics;
  final Color? color;
  final int value;
  final bool isPV;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        children:[
          Container(
            width: 25,
            alignment: Alignment.center,
            child: Text(textEstadistics, style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 8))),
          Expanded(
            child: SizedBox(height: 23,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(disabledActiveTrackColor: color, trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0)),
                child: Slider(value: value.toDouble(), min: 0, max: (isPV) ? value.toDouble() : 255, onChanged: null)
              ),
            ),
          ),
          Container(
            width: 25,
            alignment: Alignment.center,
            child: Text(value.toString().split('.')[0], style: GoogleFonts.pressStart2p(color: Colors.white, fontSize: 8))
          )
        ]
      )
    );
  }
}