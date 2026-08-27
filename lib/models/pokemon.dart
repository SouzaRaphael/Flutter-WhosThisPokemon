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
          (item) => item['type']['name'].toString(),
        )
        .toList();

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: artwork ?? '',
      types: types,
    );
  }
}