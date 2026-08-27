import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/pokemon.dart';
import '../../services/pokemon_service.dart';
import 'game_status.dart';

class PokemonQuizScreen extends StatefulWidget {
  const PokemonQuizScreen({super.key});

  @override
  State<PokemonQuizScreen> createState() => _PokemonQuizScreenState();
}

class _PokemonQuizScreenState extends State<PokemonQuizScreen> {
  final PokemonService pokemonService = PokemonService();

  final TextEditingController answerController = TextEditingController();

  final Random random = Random();

  Pokemon? pokemon;

  GameStatus status = GameStatus.loading;

  int score = 0;
  int hits = 0;
  int errors = 0;

  String userAnswer = '';
  String? hint;

  @override
  void initState() {
    super.initState();

    loadPokemon();
  }

  @override
  void dispose() {
    answerController.dispose();

    super.dispose();
  }

  Future<void> loadPokemon() async {
    setState(() {
      status = GameStatus.loading;
      hint = null;
      userAnswer = '';
      answerController.clear();
    });

    try {
      final id = random.nextInt(386) + 1;

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

    final answer = answerController.text.trim();

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite o nome do Pokémon.')),
      );

      return;
    }

    setState(() {
      userAnswer = answer;

      if (normalize(answer) == normalize(currentPokemon.name)) {
        status = GameStatus.correct;

        hits++;
        score += 10;
      } else {
        status = GameStatus.wrong;

        errors++;
        score = max(0, score - 5);
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

  String normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('♀', '-f')
        .replaceAll('♂', '-m')
        .replaceAll(' ', '-');
  }

  @override
  Widget build(BuildContext context) {
    if (status == GameStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quem é esse Pokémon?'),
        actions: [
          TextButton(onPressed: loadPokemon, child: const Text('Pular')),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      'Pontos: $score | Acertos: $hits | Erros: $errors',
                    ),
                  ),

                  const SizedBox(height: 24),

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
                    TextField(
                      controller: answerController,
                      decoration: const InputDecoration(
                        labelText: 'Digite o nome do Pokémon',
                        border: OutlineInputBorder(),
                      ),
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