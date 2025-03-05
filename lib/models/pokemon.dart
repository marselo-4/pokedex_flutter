class Pokemon {
  final int id;
  final String name;
  final String image;
  final Map<String, int> stadistics;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.stadistics
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'] as String?;
    final image = json['image'] as String?;
    final stadistics = (json['stadistics'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value as int));

    if (id == null || name == null || image == null || stadistics == null) {
      throw FormatException('Campos nulos detectados en los datos del JSON: $json');
    }

    return Pokemon(
      id: id,
      name: name,
      image: image,
      stadistics: stadistics,
    );
  }
}
