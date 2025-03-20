class Pokemon {
  final int id;
  final String name;
  final String image;
  final List<String> types;
  final Map<String, int> stadistics;

  Pokemon({
    required this.id,
    required this.name,
    required this.image,
    required this.types,
    required this.stadistics,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'] as String?;
    final image = json['image'] as String?;
    final types = (json['types'] as List<dynamic>?)?.map((e) => e as String).toList();
    final stadistics = (json['stadistics'] as Map<String, dynamic>?)?.map((key, value) => MapEntry(key, value as int));

    if (id == null || name == null || image == null || stadistics == null) {
      throw FormatException('Campos nulos detectados en los datos del JSON: $json');
    }

    return Pokemon(
      id: id,
      name: name,
      image: image,
      stadistics: stadistics,
      types: types ?? [],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'types': types,
    };
  }
}

