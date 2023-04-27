class Member {
  int? memberId;
  String memberName;
  String instrument;
  int bandId;

  Member({
    this.memberId,
    required this.memberName,
    required this.instrument,
    required this.bandId,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'member': memberName,
      'instrument': instrument,
      'bandId': bandId,
    };
  }

  static Member fromMap(Map<String, dynamic> map) {
    return Member(
      memberId: map['memberId'],
      member: map['member'],
      instrument: map['instrument'],
      bandId: map['bandId'],
    );
  }
}
