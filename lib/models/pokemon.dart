class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final artwork =
        json['sprites']['other']['official-artwork']['front_default'];

    final types = (json['types'] as List)
        .map(
          (item) => translatedTypes[item['type']['name'].toString()] ?? '',
        )
        .toList();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: artwork ?? '',
      types: types,
    );
  }

  static const Map<String, String> translatedTypes = {
    "normal": "Normal",
    "grass": "Planta",
    "fire": "Fogo",
    "water": "Água",
    "electric": "Elétrico",
    "bug": "Inseto",
    "flying": "Voador",
    "rock": "Pedra",
    "poison": "Venenoso",
    "ground": "Terrestre",
    "ice": "Gelo",
    "fighting": "Lutador",
    "psychic": "Psíquico",
    "ghost": "Fantasma",
    "dragon": "Dragão",
    "dark": "Sombrio",
    "steel": "Aço",
    "fairy": "Fada"
  };
}