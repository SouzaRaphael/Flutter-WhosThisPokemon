import 'package:flutter/material.dart';
import 'package:whos_this_pokemon/screens/components/header.dart';
import 'package:whos_this_pokemon/screens/enum/generation.dart';
import 'package:whos_this_pokemon/screens/pokemon_quiz_screen.dart';

class GenerationSelectorScreen extends StatefulWidget {
  const GenerationSelectorScreen({super.key});

  @override
  State<GenerationSelectorScreen> createState() => _GenerationSelectorScreenState();
}

class _GenerationSelectorScreenState extends State<GenerationSelectorScreen> {
  List<bool> checkboxGenerations = List.generate(Generation.values.length, (_) => false);

  List<Generation>? makeGenerationsList() {
    List<Generation> checkedGenerations = [];

    for (var i = 0; i < checkboxGenerations.length; i++) {
      if (checkboxGenerations[i]) {
        checkedGenerations.add(Generation.values.elementAt(i));
      }
    }

    if (checkedGenerations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos uma geração')),
      );
      return null;
    }

    return checkedGenerations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 10,
          children: [
            Text("Escolha as gerações de Pokemons que deseja palpitar:", style: Theme.of(context).textTheme.headlineSmall,),
            Expanded(
              child: Column(children: Generation.values.map(
                  (generation) {
                    int index = Generation.values.indexOf(generation);
                        
                    return Column(
                      children: [
                        CheckboxListTile(
                          value: checkboxGenerations[index], 
                          onChanged: (value) => setState(() => checkboxGenerations[index] = value!) ,
                          title: Text(generation.name),
                        ),
                        Divider(height: 2)
                      ],
                    );
                  }
              ).toList()),
            ),
            Padding(
              padding: EdgeInsetsGeometry.all(10),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final generationsList = makeGenerationsList();
                    
                    generationsList != null
                    ? Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PokemonQuizScreen(
                        chosenGenerations: generationsList
                      ))
                    )
                    : setState(() {});
                  },
                  child: Text("Jogar")
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}