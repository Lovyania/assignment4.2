class Song {
  int? songId;
  String title;
  int releaseYear;
  int bandId;

  Song({
    this.songId,
    required this.title,
    required this.releaseYear,
    required this.bandId,
  });

  Map<String, dynamic> toMap() {
    return {
      'songId': songId,
      'title': title,
      'releaseYear': releaseYear,
      'bandId': bandId,
    };
  }

  static Song fromMap(Map<String, dynamic> map) {
    return Song(
      songId: map['songId'],
      title: map['title'],
      releaseYear: map['releaseYear'],
      bandId: map['bandId'],
    );
  }
}
