// import 'package:whos_this_pokemon/services/assets_service.dart';
// import 'package:whos_this_pokemon/services/pokemon_service.dart';

// List<String> pokemonNames = [];
// const totalPokemons = 1025;
// final assetsService = AssetsService();

// Future<void> init() async {
//   pokemonNames = await assetsService.getPokemonNames();

//   if (pokemonNames.length >= totalPokemons) {
//     await getAllPokemons();
//   }
// }

// Future<void> getAllPokemons() async {
//   final pokemonService = PokemonService();
  
//   for (var i = 1; i <= totalPokemons; i++) {
//     pokemonNames.add(await pokemonService.getPokemonName(i));
//   }

//   await assetsService.setPokemonNames(pokemonNames);
// }