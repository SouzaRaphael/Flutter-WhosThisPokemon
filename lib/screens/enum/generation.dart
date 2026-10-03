enum Generation {
  gen1(name: "1º Geração", firstPokemonId: 1, lastPokemonId: 151),
  gen2(name: "2º Geração", firstPokemonId: 152, lastPokemonId: 251),
  gen3(name: "3º Geração", firstPokemonId: 252, lastPokemonId: 386),
  gen4(name: "4º Geração", firstPokemonId: 387, lastPokemonId: 493),
  gen5(name: "5º Geração", firstPokemonId: 494, lastPokemonId: 649),
  gen6(name: "6º Geração", firstPokemonId: 650, lastPokemonId: 721),
  gen7(name: "7º Geração", firstPokemonId: 722, lastPokemonId: 809),
  gen8(name: "8º Geração", firstPokemonId: 810, lastPokemonId: 905),
  gen9(name: "9º Geração", firstPokemonId: 906, lastPokemonId: 1025);

  final String name;
  final int firstPokemonId;
  final int lastPokemonId;

  const Generation({required this.firstPokemonId, required this.lastPokemonId, required this.name});
}