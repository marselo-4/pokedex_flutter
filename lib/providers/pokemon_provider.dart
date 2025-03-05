import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokedex_flutter/models/pokemon.dart';

class PokemonProvider extends ChangeNotifier {
  Pokemon? pokemon;

  PokemonProvider() {
    cargaPredeterminada();
  }

  void cargaPredeterminada() async {
    pokemon = await getPokemon(idPokemon: 133);
    notifyListeners();
  }

  Future<Pokemon> getPokemon({required int idPokemon}) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$idPokemon/'));
    final json = await jsonDecode(response.body) as Map<String, dynamic>;

    return Pokemon.fromJson({
      'id': json['id'],
      'name': json['name'],
      'image': json['sprites']['other']['home']['front_default'],
      'stadistics': {
        'PS': json['stats'][0]['base_stat'],
        'AF': json['stats'][1]['base_stat'],
        'DE': json['stats'][2]['base_stat'],
        'SA': json['stats'][3]['base_stat'],
        'SD': json['stats'][4]['base_stat'],
        'VEL': json['stats'][5]['base_stat']
      }
    });
  }

  void changePokemon({required int idPokemon}) async {
    pokemon = await getPokemon(idPokemon: idPokemon);
    notifyListeners();
  }

  void changePreviousPokemon() async {
    final idPokemon = pokemon!.id - 1;
    pokemon = await getPokemon(idPokemon: idPokemon);
    notifyListeners();
  }

  void changeNextPokemon() async {
    final idPokemon = pokemon!.id + 1;
    pokemon = await getPokemon(idPokemon: idPokemon);
    notifyListeners();
  }
  
}