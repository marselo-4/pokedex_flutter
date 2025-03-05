import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:pokedex_flutter/screens/info_pokemon.dart';
import 'package:pokedex_flutter/extensions/extensions.dart';
import 'package:pokedex_flutter/providers/pokemon_provider.dart';

import 'package:google_fonts/google_fonts.dart';

class PokemonScreen extends StatelessWidget {
  static const name = 'pantalla-pokemón';

  const PokemonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = context.watch<PokemonProvider>().pokemon;
    if (pokemon == null) {
      return Scaffold(
          body: Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xFF1E1E1E),
                Color(0xFF2E2E2E),
                Color(0xFF3E3E3E)
              ])),
              child: Center(
                  child: Image.asset('assets/images/spinnerPokeball.gif'))));
    }

    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Color(0xFF1E1E1E),
            Color(0xFF2E2E2E),
            Color(0xFF3E3E3E)
          ])),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PokemonProvider>().changePreviousPokemon(),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        iconColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(40, 40)),
                    child: const Icon(Icons.arrow_left_rounded, size: 30),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FadeInImage.assetNetwork(
                            key: ValueKey(pokemon.id),
                            height: 264,
                            width: 264,
                            placeholder: 'assets/images/spinnerPokeball.gif',
                            image: pokemon.image,
                            fit: BoxFit.contain)
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .scale(begin: Offset(0.8, 0.8), end: Offset(1.0, 1.0), duration: 500.ms),
                        Text(pokemon.name.toString().capitalize(),
                            style: GoogleFonts.pressStart2p(
                                color: Colors.white, fontSize: 18))
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slide(begin: Offset(0, 0.5), end: Offset(0, 0), duration: 500.ms),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<PokemonProvider>().changeNextPokemon(),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        iconColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        minimumSize: const Size(40, 40)),
                    child: const Icon(Icons.arrow_right_rounded, size: 30),
                  )
                ],
              ),
            ),
            SlidersStadistics(data: pokemon.stadistics)
                .animate()
                .fadeIn(duration: 500.ms)
                .slide(begin: Offset(0, 0.5), end: Offset(0, 0), duration: 500.ms),
            Text('Nº ${pokemon.id}',
                style:
                    GoogleFonts.pressStart2p(color: Colors.white, fontSize: 12))
                .animate()
                .fadeIn(duration: 500.ms)
                .slide(begin: Offset(0, 0.5), end: Offset(0, 0), duration: 500.ms),
          ])),
    );
  }
}
