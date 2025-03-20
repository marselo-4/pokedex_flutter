import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex_flutter/data/bbdd.dart';
import 'dart:convert';
import 'package:pokedex_flutter/models/pokemon.dart';

class PokemonProvider extends ChangeNotifier {
  Pokemon? pokemon;
  List<Pokemon> pokemonList = [];

  PokemonProvider() {
    cargaPredeterminada();
    fetchPokemon(0);
  }

  void checkLocalDatabase() async {
    PokemonDatabase().getAllPokemons().then((value) {
      pokemonList = value;
      notifyListeners();
    });
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
      'types': json['types'].map((type) => type['type']['name']).toList(),
      'abilities': json['abilities'].map((ability) => ability['ability']['name']).toList(),
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

  final int _limit = 20;
  bool _isLoading = false;

  Future<void> fetchPokemon(int offset) async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=$_limit&offset=$offset'));
      if (response.statusCode == 200) {
        final json = await jsonDecode(response.body) as Map<String, dynamic>;
        final results = json['results'] as List<dynamic>;

        for (var result in results) {
          final pokemonUrl = result['url'];
          final pokemonResponse = await http.get(Uri.parse(pokemonUrl));
          if (pokemonResponse.statusCode == 200) {
            final pokemonJson = await jsonDecode(pokemonResponse.body) as Map<String, dynamic>;

            final pokemon = Pokemon.fromJson({
              'id': pokemonJson['id'],
              'name': pokemonJson['name'],
              'image': pokemonJson['sprites']['other']['home']['front_default'],
              'types': pokemonJson['types'].map((type) => type['type']['name']).toList(),
              'abilities': pokemonJson['abilities'].map((ability) => ability['ability']['name']).toList(),
              'stadistics': {
                'PS': pokemonJson['stats'][0]['base_stat'],
                'AF': pokemonJson['stats'][1]['base_stat'],
                'DE': pokemonJson['stats'][2]['base_stat'],
                'SA': pokemonJson['stats'][3]['base_stat'],
                'SD': pokemonJson['stats'][4]['base_stat'],
                'VEL': pokemonJson['stats'][5]['base_stat']
              }
            });

            pokemonList.add(pokemon);
          }
        }

        offset += _limit;
      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAllPokemon() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/?limit=1025&offset=20'));
      if (response.statusCode == 200) {
        final json = await jsonDecode(response.body) as Map<String, dynamic>;
        final results = json['results'] as List<dynamic>;

        for (var result in results) {
          final pokemonUrl = result['url'];
          final pokemonResponse = await http.get(Uri.parse(pokemonUrl));
          if (pokemonResponse.statusCode == 200) {
            final pokemonJson = await jsonDecode(pokemonResponse.body) as Map<String, dynamic>;

            final pokemon = Pokemon.fromJson({
              'id': pokemonJson['id'],
              'name': pokemonJson['name'],
              'image': pokemonJson['sprites']['other']['home']['front_default'],
              'types': pokemonJson['types'].map((type) => type['type']['name']).toList(),
              'abilities': pokemonJson['abilities'].map((ability) => ability['ability']['name']).toList(),
              'stadistics': {
                'PS': pokemonJson['stats'][0]['base_stat'],
                'AF': pokemonJson['stats'][1]['base_stat'],
                'DE': pokemonJson['stats'][2]['base_stat'],
                'SA': pokemonJson['stats'][3]['base_stat'],
                'SD': pokemonJson['stats'][4]['base_stat'],
                'VEL': pokemonJson['stats'][5]['base_stat']
              }
            });

            pokemonList.add(pokemon);
          }
        }

      } else {
        throw Exception('Failed to load Pokémon');
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}