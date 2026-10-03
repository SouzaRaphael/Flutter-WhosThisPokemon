import 'package:flutter/material.dart';
import 'package:whos_this_pokemon/screens/generation_selector_screen.dart';


void main() {
  runApp(const PokemonQuizApp());
}

class PokemonQuizApp extends StatelessWidget {
  const PokemonQuizApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quem é esse Pokémon?',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),
      // home: const PokemonQuizScreen(chosenGenerations: [Generation.gen1, Generation.gen2]),
      home: GenerationSelectorScreen(),
    );
  }
}