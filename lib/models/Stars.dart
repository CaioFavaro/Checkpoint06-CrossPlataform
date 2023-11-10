class StarredRepository {
  final String name;
  final String description;

  StarredRepository({
    required this.name,
    required this.description,
  });

  factory StarredRepository.fromJson(Map<String, dynamic> json) {
    return StarredRepository(
      name: json['name'],
      description: json['description'] ?? '',
    );
  }
}
