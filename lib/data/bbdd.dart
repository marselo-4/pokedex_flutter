import 'dart:convert';
import 'package:pokedex_flutter/models/pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PokemonDatabase {
  static const String _favoritesKey = 'favorites';

  Future<void> addFavorite(Pokemon pokemon) async {
    final prefs = await SharedPreferences.getInstance();
    final pokemons = prefs.getStringList(_favoritesKey) ?? [];
    final pokemonJson = jsonEncode(pokemon.toJson());
    if (!pokemons.contains(pokemonJson)) {
      pokemons.add(pokemonJson);
      await prefs.setStringList(_favoritesKey, pokemons);
    }
  }

  Future<void> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final pokemons = prefs.getStringList(_favoritesKey) ?? [];
    pokemons.removeWhere((pokemonJson) {
      final pokemon = Pokemon.fromJson(jsonDecode(pokemonJson));
      return pokemon.id == id;
    });
    await prefs.setStringList(_favoritesKey, pokemons);
  }

  Future<Set<Pokemon>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final pokemons = prefs.getStringList(_favoritesKey) ?? [];
    return pokemons.map((pokemonJson) {
      return Pokemon.fromJson(jsonDecode(pokemonJson));
    }).toSet();
  }

  Future<void> saveAllPokemons(List<Pokemon> pokemons) async {
    final prefs = await SharedPreferences.getInstance();
    final pokemonsJson = pokemons.map((pokemon) => jsonEncode(pokemon.toJson())).toList();
    await prefs.setStringList(_favoritesKey, pokemonsJson);
  }

  Future<List<Pokemon>> getAllPokemons() async {
    final prefs = await SharedPreferences.getInstance();
    final pokemons = prefs.getStringList(_favoritesKey) ?? [];
    return pokemons.map((pokemonJson) {
      return Pokemon.fromJson(jsonDecode(pokemonJson));
    }).toList();
  }
}