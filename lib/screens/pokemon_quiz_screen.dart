import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:whos_this_pokemon/screens/components/header.dart';
import 'package:whos_this_pokemon/screens/enum/generation.dart';
import 'package:whos_this_pokemon/services/assets_service.dart';

import '../../models/pokemon.dart';
import '../../services/pokemon_service.dart';
import 'enum/game_status.dart';

class PokemonQuizScreen extends StatefulWidget {
  const PokemonQuizScreen({super.key, required this.chosenGenerations});

  final List<Generation> chosenGenerations;

  @override
  State<PokemonQuizScreen> createState() => _PokemonQuizScreenState();
}

class _PokemonQuizScreenState extends State<PokemonQuizScreen> {
  final pokemonService = PokemonService();
  final assetsService = AssetsService();

  final Random random = Random();

  late final List<String> availablePokemonsNames;
  late final List<int> availablePokemonsIds;

  Pokemon? pokemon;

  GameStatus status = GameStatus.loading;

  String userAnswer = '';
  String? hint;

  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    final pokedexPokemonNames = await assetsService.getPokemonNames();

    availablePokemonsNames = [];
    availablePokemonsIds = [];

    for (var generation in widget.chosenGenerations) {
      availablePokemonsNames.addAll(pokedexPokemonNames.getRange(generation.firstPokemonId - 1, generation.lastPokemonId - 1));
      availablePokemonsIds.addAll(List.generate(generation.lastPokemonId - generation.firstPokemonId + 1, (index) => generation.firstPokemonId + index));
    }

    await loadPokemon();
  }

  Future<void> loadPokemon() async {
    setState(() {
      status = GameStatus.loading;
      hint = null;
      userAnswer = '';
    });

    try {
      final id = availablePokemonsIds[random.nextInt(availablePokemonsIds.length) + 1];

      final result = await pokemonService.getPokemon(id);

      if (!mounted) {
        return;
      }

      setState(() {
        pokemon = result;
        status = GameStatus.playing;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível carregar o Pokémon.')),
      );
    }
  }

  void checkAnswer() {
    final currentPokemon = pokemon;

    if (currentPokemon == null) {
      return;
    }

    if (userAnswer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do Pokémon.')),
      );

      return;
    }

    setState(() {
      if (userAnswer == currentPokemon.name) {
        status = GameStatus.correct;
      } else {
        status = GameStatus.wrong;
      }
    });
  }

  void showHint() {
    final currentPokemon = pokemon;

    if (currentPokemon == null) {
      return;
    }

    final firstLetter = currentPokemon.name[0].toUpperCase();

    final types = currentPokemon.types.join(' / ');

    setState(() {
      hint = 'Começa com "$firstLetter" e possui o tipo $types.';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (status == GameStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: Header(
        showBackButton: true,
        actions: [
          TextButton(onPressed: loadPokemon, child: const Text('Pular')),
        ]
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600, maxHeight: MediaQuery.sizeOf(context).height - kToolbarHeight - 60),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.network(
                      pokemon!.imageUrl,
                      height: 280,
                      color: status == GameStatus.playing ? Colors.black : null,
                      colorBlendMode: status == GameStatus.playing
                          ? BlendMode.srcIn
                          : null,
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (status == GameStatus.playing) ...[
                    Autocomplete<String>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<String>.empty();
                        }
                        return availablePokemonsNames.where((name) => name
                            .toLowerCase()
                            .startsWith(textEditingValue.text.toLowerCase())
                        );
                      },
                      onSelected: (name) => setState(() => userAnswer = name),
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) =>
                        TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: InputDecoration(
                            hintText: 'Digite o pokemon...',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        )
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: checkAnswer,
                        child: const Text('Confirmar'),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: showHint,
                        child: const Text('Dar dica'),
                      ),
                    ),

                    if (hint != null) ...[
                      const SizedBox(height: 16),

                      Text(hint!, textAlign: TextAlign.center),
                    ],
                  ],

                  if (status == GameStatus.correct) ...[
                    Text(
                      'Você acertou! Era ${pokemon!.name}.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: loadPokemon,
                        child: const Text('Próxima rodada'),
                      ),
                    ),
                  ],

                  if (status == GameStatus.wrong) ...[
                    Text(
                      'Você errou! Era ${pokemon!.name}.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Você digitou: $userAnswer',
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: loadPokemon,
                        child: const Text('Próxima rodada'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}