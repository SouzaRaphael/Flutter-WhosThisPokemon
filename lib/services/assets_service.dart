import 'dart:convert';
import 'dart:io';

class AssetsService {
  static const pokemonNamesPath = "assets/pokemon_names.json";
  final pokemonNamesFile = File(pokemonNamesPath);

  Future<List<String>> getPokemonNames() async {
    final json = jsonDecode(await pokemonNamesFile.readAsString());

    return List<String>.from(json["pokemon_names"]);
  }

  Future<void> setPokemonNames(List<String> pokemonNames) async {
    final json = jsonEncode(pokemonNames);

    await pokemonNamesFile.writeAsString(json);
  }
}