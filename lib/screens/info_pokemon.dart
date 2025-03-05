import 'package:flutter/material.dart';
import 'package:pokedex_flutter/screens/slider_stadistic.dart';

class SlidersStadistics extends StatelessWidget {
  const SlidersStadistics({
    super.key,
    required this.data,
  });

  final Map<String, int> data;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SliderStadistic(textEstadistics: 'PS', color: Colors.red[200], value: data['PS']!,  isPV: true),
        SliderStadistic(textEstadistics: 'AF', color: Colors.red[200], value: data['AF']!),
        SliderStadistic(textEstadistics: 'DE', color: Colors.red[200], value: data['DE']!),
        SliderStadistic(textEstadistics: 'SA', color: Colors.red[200], value: data['SA']!),
        SliderStadistic(textEstadistics: 'SD', color: Colors.red[200], value: data['SD']!),
        SliderStadistic(textEstadistics: 'VEL', color: Colors.red[200], value: data['VEL']!),
      ]
    );
  }
}