class Member {
  int? memberId;
  String member;
  String instrument;
  int bandId;
  int songId;

  Member({
    this. memberId,
    required this.member,
    required this.instrument,
    required this.bandId,
    required this.songId,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'member': member,
      'instrument': instrument,
      'bandId': bandId,
      'songId': songId,
    };
  }

  static Member fromMap(Map<String, dynamic> map) {
    return Member(
      memberId: map['memberId'],
      member: map['member'],
      instrument: map['instrument'],
      bandId: map['bandId'],
      songId: map['songId'],
    );
  }
}
