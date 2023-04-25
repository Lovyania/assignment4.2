class Band {
  int? bandId;
  String name;
  String genre;

  Band({
    this.bandId,
    required this.name,
    required this.genre,
  });

  Map<String, dynamic> toMap() {
    return {
      'bandId': bandId,
      'name': name,
      'genre': genre,
    };
  }

  static Band fromMap(Map<String, dynamic> map) {
    return Band(
      bandId: map['bandId'],
      name: map['name'],
      genre: map['genre'],
    );
  }
}
