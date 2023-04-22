class Band {
  int id;
  String name;
  String genre;

  Band({
    this.id = 0, // set default value to 0
    required this.name,
    required this.genre,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'genre': genre,
    };
  }

  static Band fromMap(Map<String, dynamic> map) {
    return Band(
      id: map['id'],
      name: map['name'],
      genre: map['genre'],
    );
  }
}
